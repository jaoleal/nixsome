{
  inputs = {
    pkgs.url = "github:nixos/nixpkgs/nixos-24.11";
    vscode-server.url = "github:nix-community/nixos-vscode-server";
  };
  outputs = { self, pkgs, vscode-server, ... }:
    let
      system = "x86_64-linux";

      hardware = ./hardware-configuration.nix;
    in
    {
      nixosConfigurations = {
        userland = pkgs.lib.nixosSystem {

          modules = [
            hardware
            ./userland.nix
          ];
          inherit system;
        };
        backend = pkgs.lib.nixosSystem {
          modules = [
            hardware
            ./backend.nix

            vscode-server.nixosModules.default
            ({ pkgs, ... }: {
              services.vscode-server.enable = true;
            })
          ];
          inherit system;
        };
      };
    };

  description = "Remember the DISSSSS ?";
}
