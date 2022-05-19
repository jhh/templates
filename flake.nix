{
  description = "Nix Flake Templates";

  outputs = { self, nixpkgs }: {
    templates = {
      django = {
        path = ./django;
        description = "A basic Django setup";
      };
    };
  };
}
