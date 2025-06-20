{
  description = "Remember the DISSSSS ";
  outputs =
    { self, ... }@inputs:
    let
      src = import ./src { };

      system = "x86_64-linux";
      stateVersion = "25.05";
    in
    {
      homeConfigurations."jaoleal" = inputs.home-manager.lib.homeManagerConfiguration {
         pkgs = import inputs.nixpkgs {
                        inherit system;

                        config.allowUnfree = true;
                        };
        
	# Specify your home configuration modules here, for example,
        # the path to your home.nix.
        modules = [ ./src/portable.nix ];
	
	extraSpecialArgs = {
		inherit system stateVersion;
		username = "jaoleal";
		pkgs = import inputs.nixpkgs {
        		inherit system;

        		config.allowUnfree = true;
        		};
       	};
      };
      nixosConfigurations = {
        backend = src.buildNixos {
          inherit inputs system stateVersion;

          hostname = "backend";
          username = "jaoleal";
          extraModules = [
            inputs.microvm.nixosModules.host
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
      };
    };

  inputs = {
    nixpkgs = {
      url = "github:nixos/nixpkgs/nixos-25.05";
    };
    vscode-server = {
      url = "github:nix-community/nixos-vscode-server";
    };
    niri = {
      url = "github:sodiboo/niri-flake";
    };
    microvm = {
      url = "github:astro/microvm.nix";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    utreexod-flake = {
      url = "github:jaoleal/utreexod-flake";
    };
    stylix = {
      url = "github:danth/stylix";
    };
    nixpkgs-unstable = {
      url = "github:nixos/nixpkgs-channels/nixos-unstable";
    };
    nixos-wsl = {
      url = "github:nix-community/NixOS-WSL/main";
    };
    home-manager = {
      url = "github:nix-community/home-manager/release-25.05";
    };

    floresta = {
      url = "git+https://github.com/jaoleal/Floresta?ref=more-flake-checks";
    };
  };
}
