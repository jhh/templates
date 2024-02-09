{
  description = "Nix Flake Templates";

  outputs = { self, nixpkgs }: {
    templates = {
      django = {
        path = ./django;
        description = "A simple Django project";
      };
      html = {
        path = ./html;
        description = "HTML design setup";
      };
    };
  };
}
