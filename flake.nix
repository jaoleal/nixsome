{
  description = "Remember the DISSSSS ";
  outputs =
    { self, ... }@inputs:
    let
      system = "x86_64-linux";
      # May god permit that i have some ARM userland but not now.
      pkgs = inputs.nixpkgs.legacyPackages.${system};

      hardware = import ./src/hardware-configuration.nix;
    in
    {
      nixosConfigurations = {
        userland = inputs.nixpkgs.lib.nixosSystem {
          modules = [
            (
              { ... }:
              {
                nixpkgs.overlays = [ inputs.niri.overlays.niri ];
              }
            )
            hardware
            ./src/userland.nix
          ];
          inherit system;
        };

        backend = inputs.nixpkgs.lib.nixosSystem {
          modules = [
            ./src/backend.nix

            inputs.vscode-server.nixosModules.default
            (
              { pkgs, ... }:
              {
                services.vscode-server.enable = true;
              }
            )
          ];
        };
        services = inputs.nixpkgs.lib.nixosSystem {
          inherit system;
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
  };

}
