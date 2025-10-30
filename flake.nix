{
  description = "Remember the DISSSSS ";
  outputs =
    { self, ... }@inputs:
    let
      src = import ./src { };

      system = "x86_64-linux";
      stateVersion = "25.11";
    in
    {
      nixosConfigurations = {
        backend = src.buildNixos {
          inherit inputs system stateVersion;

          hostname = "backend";
          username = "jaoleal";
          extraModules = [
            inputs.home-manager.nixosModules.home-manager
          ];
        };
        wsl-userland = src.buildNixos {
          inherit inputs system stateVersion;

          hostname = "wsl-userland";
          username = "jaoleal";
          extraModules = [
            inputs.nixos-wsl.nixosModules.default
            inputs.home-manager.nixosModules.home-manager
          ];
        };
        galaxy-book = src.buildNixos {
          inherit inputs system stateVersion;

          hostname = "galaxy-book";
          username = "jaoleal";
          extraModules = [
            inputs.home-manager.nixosModules.home-manager
          ];
        };

        floresta-mini-node = src.buildNixos {
          inherit inputs system stateVersion;

          hostname = "floresta-mini-node";
          username = "cubo";
          extraModules = [
            inputs.floresta.packages.${system}
            inputs.home-manager.nixosModules.home-manager
          ];
        };
      };
    };

  inputs = {
    nixpkgs = {
      url = "github:nixos/nixpkgs/nixos-25.11";
    };
    vscode-server = {
      url = "github:nix-community/nixos-vscode-server";
    };
    nixpkgs-unstable = {
      url = "github:nixos/nixpkgs/nixos-unstable";
    };
    nixos-wsl = {
      url = "github:nix-community/NixOS-WSL/main";
    };
    home-manager = {
      url = "github:nix-community/home-manager/release-25.11";
    };
  };
}
