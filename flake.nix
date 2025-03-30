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
            inputs.microvm.nixosModules.host
          ];
        };
        vm-userland = inputs.nixpkgs.lib.nixosSystem {
          inherit system;
          modules = [
            inputs.microvm.nixosModules.microvm
            hardware
            ./src/userland.nix
            (
              { ... }:
              {
                microvm = {
                  devices = [
                    {
                      bus = "pci";
                      path = "0000:0c:00.0";
                    }
                  ];
                  shares = [
                    {
                      source = "/nix/store";
                      mountPoint = "/nix/.ro-store";
                      tag = "ro-store";
                    }
                  ];
                  interfaces = [
                    {
                      type = "user";
                      id = "vm-userland";
                      mac = "56:7c:93:8d:58:64";
                    }
                  ];
                  hypervisor = "qemu";
                  vcpu = 4;
                  #30gb ram
                  mem = 30720;
                };
                nixpkgs.overlays = [ inputs.niri.overlays.niri ];
              }
            )

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
