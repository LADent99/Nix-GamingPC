{
  description = "Nix Configs";

  nixConfig = {
    ## Caching for long running binary builds
    extra-substituters = [
      "https://ladent.cachix.org"
    ];
    extra-trusted-public-keys = [
      "ladent.cachix.org-1:iJiLXkTbnPWmZ0OWqt9M4zFipIRdStMR1fF1eJpsI8k="
    ];
  };
  inputs = {
    # NixOS official package source, using unstable 
    nixpkgs.url = "github:nixos/nixpkgs/nixpkgs-unstable";
    ollama-cache.url = "github:ladent99/ollama-binary-caching";
  };

  outputs = { self, nixpkgs, ollama-cache, ... }@inputs: 
  
  {

    nixosConfigurations = {

      # Setup Lucas' PC
      LD-NixOS-PC = let 
        hostName = "LD-NixOS-PC";
        system = "x86_64-linux";
        specialArgs = {
          inherit hostName;
          inherit ollama-cache;
          };

      in nixpkgs.lib.nixosSystem {
        inherit specialArgs;

        modules = [
          ./general-config # Import general modules
          ./nvidia-graphics # Import nvidia graphics
          ./${hostName} # Import host specific config
        ];

      };
    };
  };
}
