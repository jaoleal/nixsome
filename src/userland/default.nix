{ inputs, ... }:
{
  imports = [
    ./home.nix
    ./userland.nix
    ./../../hardware-config/laptop-hardware.nix
  ];
  home-manager.useGlobalPkgs = true;
  home-manager.useUserPackages = true;
}
