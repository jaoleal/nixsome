{ inputs, username, ... }:
{
  imports = [
    inputs.home-manager.nixosModules.home-manager
    ./home.nix
    ./userland.nix
  ];
  home-manager.useGlobalPkgs = true;
  home-manager.useUserPackages = true;
  home-manager.users.${username} = ./home.nix;

}
