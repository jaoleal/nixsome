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
      formatter.${system} = inputs.nixpkgs-unstable.legacyPackages.${system}.nixfmt-rfc-style;

      nixosConfigurations = {
        backend = src.buildNixos {
          inherit inputs system stateVersion;

          hostname = "backend";
          username = "jaoleal";
          extraModules = [
            inputs.disko.nixosModules.disko
            inputs.sops-nix.nixosModules.sops
            inputs.home-manager.nixosModules.home-manager
            inputs.nix-bitcoin.nixosModules.default
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

        # Hardened ISO configurations
        backend-iso = src.buildNixosISO {
          inherit inputs system stateVersion;
          hostname = "backend-iso";
          baseConfig = "backend";
          hardened = true;
        };

        galaxy-book-iso = src.buildNixosISO {
          inherit inputs system stateVersion;
          hostname = "galaxy-book-iso";
          baseConfig = "galaxy-book";
          hardened = true;
        };

        floresta-mini-node-iso = src.buildNixosISO {
          inherit inputs system stateVersion;
          hostname = "floresta-mini-node-iso";
          baseConfig = "floresta-mini-node";
          hardened = true;
        };
      };

      # WSL Tarball export
      packages.${system} = {
        wsl-tarball = self.nixosConfigurations.wsl-userland.config.system.build.tarball or null;
        
        # Placeholder for future portable apps
        example-script = inputs.nixpkgs-unstable.legacyPackages.${system}.writeShellApplication {
          name = "example-script";
          text = ''
            echo "This is an example script from nixsome!"
            echo "Usage: nix run github:jaoleal/nixsome#example-script"
          '';
        };
      };

      # Apps output for nix run
      apps.${system} = {
        example-script = {
          type = "app";
          program = "${self.packages.${system}.example-script}/bin/example-script";
        };
      };
    };

  inputs = {
    nixpkgs = {
      url = "github:nixos/nixpkgs/nixos-25.11";
    };
    nix-bitcoin = {
      url = "github:fort-nix/nix-bitcoin/nixos-25.05";
    };
    vscode-server = {
      url = "github:nix-community/nixos-vscode-server";
    };
    disko = {
      url = "github:nix-community/disko";
      inputs.nixpkgs.follows = "nixpkgs-unstable";
    };
    sops-nix = {
      url = "github:Mic92/sops-nix";
      inputs.nixpkgs.follows = "nixpkgs-unstable";
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
    floresta = {
      url = "github:vinteumorg/Floresta";
    };
  };
}
