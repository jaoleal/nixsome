{
  description = "Remember the DISSSSS ";
  outputs =
    { self, ... }@inputs:
    let
      system = "x86_64-linux";
      pkgs = import inputs.nixpkgs { inherit system; };
    in
    {
      nixosConfigurations = {
        userland = inputs.nixpkgs.lib.nixosSystem {
          inherit system;
          modules = [
            ./src/hardware-configuration.nix
            ./src/userland.nix
          ];
        };
        backend = inputs.nixpkgs.lib.nixosSystem {
          inherit system;
          modules = [
            ./src/backend.nix
            inputs.microvm.nixosModules.host
          ];
        };
        vm-services = inputs.nixpkgs.lib.nixosSystem {
          inherit system;
          modules = [
            ./vms/services.nix
            inputs.microvm.nixosModules.microvm
          ];
        };
      };
      devShells.${system} = {
        # Default devshell for nix development.
        default = pkgs.mkShell {
          nativeBuildInputs = with pkgs; [
            nixfmt-rfc-style
            nil
            git
          ];
          shellHook = ''
            echo "Haro"
          '';

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
