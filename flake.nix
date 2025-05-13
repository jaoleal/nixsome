{
  description = "Remember the DISSSSS ";
  outputs =
    { self, ... }@inputs:
    let
      src = import ./src { };

      system = "x86_64-linux";
      stateVersion = "24.11";
    in
    {
      nixosConfigurations = {
        backend = src.buildNixos {
          inherit inputs system stateVersion;

          hostname = "backend";
          username = "jaoleal";
          userland = false;
          extraModules = [
           # inputs.stylix.nixosModules.stylix

            inputs.microvm.nixosModules.host
          ];
        };
        userland = src.buildNixos {
          inherit inputs system stateVersion;

          hostname = "userland";
          username = "jaoleal";
          userland = false;
          extraModules = [
           <home-manager/nixos>
           # inputs.home-manager.nixosModules.home-manager
            #            inputs.stylix.nixosModules.stylix
            #           inputs.niri.nixosModules.niri
          ];
        };

        #vm-services = inputs.nixpkgs.lib.nixosSystem {
        #  system = "x86_64-linux";
        #  modules = [
        #    ./src/services.nix
        #    inputs.microvm.nixosModules
        #  ];
        #};
      };
    };

  inputs = {
    nixpkgs = {
      url = "github:nixos/nixpkgs/nixos-24.11";
    };
    vscode-server = {
      url = "github:nix-community/nixos-vscode-server";
    };
    #  niri = {
    # url = "github:sodiboo/niri-flake";
    # };
    microvm = {
      url = "github:astro/microvm.nix";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    utreexod-flake = {
      url = "github:jaoleal/utreexod-flake";
    };
    #stylix = {
    #  url = "github:danth/stylix";
    #};
    nixpkgs-unstable.url = "github:nixos/nixpkgs-channels/nixos-unstable";

    home-manager = {
      url = "github:nix-community/home-manager";
    };
    floresta = {
      url = "git+https://github.com/jaoleal/Floresta?ref=more-flake-checks";
    };
  };
}
