{
  description = "Nix Flake Templates";

  outputs = { self }: {
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
