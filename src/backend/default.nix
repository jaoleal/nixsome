{ ... }:
{
  imports = [
    ./backend.nix
    ./dashy.nix
    ./disko.nix
    ./../../hardware-config/backend-hardware-configuration.nix
    #./../../containers/bitcoin.nix
  ];
}
