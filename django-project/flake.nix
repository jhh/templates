{
  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs/nixos-unstable";
    utils.url = "github:numtide/flake-utils";
  };

  outputs = { self, nixpkgs, utils }:
    let
      out = system:
        let pkgs = nixpkgs.legacyPackages."${system}";
        in
        {

          devShell = pkgs.mkShell {

            nativeBuildInputs = with pkgs; [
              postgresql
              python39Packages.poetry
              nodejs-16_x
              watchman
              pre-commit
            ];

            buildInputs = with pkgs; lib.optional stdenv.isDarwin openssl;
          };

          packages = {
            default = let djangoProject = with pkgs.poetry2nix; mkPoetryApplication {
              projectDir = ./.;
              preferWheels = true;
            }; in djangoProject.dependencyEnv;
          };
        };
    in
    with utils.lib; eachSystem defaultSystems out // {

      nixosModules.default = { config, lib, pkgs, ... }:
        with lib;
        let
          cfg = config.j3ff.djangoProject;
        in
        {
          options.j3ff.djangoProject = {
            enable = mkEnableOption "Enable the djangoProject service";
          };

          config = mkIf cfg.enable
            {
              systemd.services.djangoProject = {
                description = "djangoProject";

                wantedBy = [ "multi-user.target" ];

                environment = {
                  DJANGO_SETTINGS_MODULE = "config.settings.production";
                };

                serviceConfig =
                  let pkg = self.packages.${pkgs.system}.default;
                  in
                  {
                    # agenix secret in github:jhh/nixos-configs
                    EnvironmentFile = "/run/agenix/djangoProject_secrets";
                    ExecStart = "${pkg}/bin/gunicorn config.wsgi --log-file -";

                    DynamicUser = true;
                    NoNewPrivileges = true;
                    ProtectSystem = "strict";
                  };
              };
            };
        };
      nixosConfigurations.container = nixpkgs.lib.nixosSystem {
        system = "x86_64-linux";
        modules = [
          self.nixosModules.default
          ({ config, pkgs, ... }: {
            # Only allow this to boot as a container
            boot.isContainer = true;
            networking.hostName = "django";

            j3ff.djangoProject.enable = true;
          })
        ];
      };
    };

}
