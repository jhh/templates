{
  description = "Nix Flake Templates";

  outputs = { self, nixpkgs }: {
    templates = {
      django = {
        path = ./django-project;
        description = "A basic Django setup";
      };
      html = {
        path = ./html-design;
        description = "HTML design setup";
      };
    };
  };
}
