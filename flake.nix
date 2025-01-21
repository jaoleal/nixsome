{
  inputs = {
    pkgs.url = "github:nixos/nixpkgs/nixos-24.11";
  };

  outputs = { self, pkgs, ... }:
    let
      system = "x86_64-linux";
      nixDevShell = import ./nixdev.nix {
        pkgs = import pkgs {
          system = system;
        };
      };
    in
    {
      nixosConfigurations = {
        desktop = pkgs.lib.nixosSystem {
          system = system;
          modules = [
            ./common.nix
            ./desktop.nix
          ];
        };
        notebook = pkgs.lib.nixosSystem {
          system = system;
          modules = [
            ./common.nix
            ./notebook.nix
          ];
        };
      };
      devShells = {
        x86_64-linux = { default = nixDevShell; };
      };
    };

  description = "Remember the DISSSSS ?";
}
