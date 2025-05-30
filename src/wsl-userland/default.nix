{ ... }:
{
  imports = [
    ./wsl.nix
  ];
  home-manager.useGlobalPkgs = true;
  home-manager.useUserPackages = true;
}
