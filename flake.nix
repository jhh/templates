{
  description = "Django application";

  inputs = {
    flake-utils.url = "github:numtide/flake-utils";
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-unstable";
    poetry2nix = {
      url = "github:nix-community/poetry2nix";
      inputs.nixpkgs.follows = "nixpkgs";
    };
  };

  outputs = { self, nixpkgs, flake-utils, poetry2nix }:
    flake-utils.lib.eachDefaultSystem (system:
      let
        pkgs = nixpkgs.legacyPackages.${system};
        inherit (poetry2nix.lib.mkPoetry2Nix { inherit pkgs; }) mkPoetryEnv mkPoetryApplication;
      in
      {
        packages = {
          myapp = mkPoetryApplication { projectDir = self; };

          devEnv = mkPoetryEnv {
            projectDir = self;
            groups = [ "main" "dev" ];
          };

          # refresh venv for Pycharm with: nix build .#venv -o .venv
          venv = self.packages.${system}.devEnv;
          default = self.packages.${system}.myapp;
        };

        devShells.default = pkgs.mkShell {
          inputsFrom = [ self.packages.${system}.devEnv ];
          packages = with pkgs; [ poetry ];
        };
      });
}
