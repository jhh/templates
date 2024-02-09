{
  description = "Nix Flake Templates";

  outputs = { self }: {
    templates = {
      django = {
        path = ./django;
        description = "A simple Django project";
        welcomeText = ''
          # Getting started
          - Run `poetry lock --no-update`
          - Run `django-admin startproject <NAME> . --template https://github.com/jhh/django-startproject/archive/main.zip`
        '';

      };
      html = {
        path = ./html;
        description = "HTML design setup";
      };
    };
  };
}
