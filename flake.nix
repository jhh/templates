{
  description = "Nix Flake Templates";

  outputs = { self, nixpkgs }: {
    templates = {
      go-web-server = {
        path = ./django;
        description = "A basic Django setup";
      };
    };
  };
}
