{
  description = "Remember the DISSSSS ";
  outputs =
    { self, ... }@inputs:
    {
      nixosConfigurations = {
        userland = inputs.nixpkgs.lib.nixosSystem {
          modules = [
            ./src/hardware-configuration.nix
            ./src/userland.nix
          ];
          system = "x86_64-linux";
        };
        backend = inputs.nixpkgs.lib.nixosSystem {
          modules = [
            ./src/backend.nix
            inputs.microvm.nixosModules.host
          ];
        };
        vm-services = inputs.nixpkgs.lib.nixosSystem {
          system = "x86_64-linux";
          modules = [
            ./vms/services.nix
            inputs.microvm.nixosModules.microvm
          ];
        };
      };
    };

  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs/nixos-24.11";
    vscode-server.url = "github:nix-community/nixos-vscode-server";
    niri.url = "github:sodiboo/niri-flake";
    microvm = {
      url = "github:astro/microvm.nix";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    utreexod-flake.url = "github:jaoleal/utreexod-flake";
    floresta.url = "git+https://github.com/jaoleal/Floresta?ref=more-flake-checks";
  };

}
