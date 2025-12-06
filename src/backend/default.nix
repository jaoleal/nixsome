{ ... }:
{
  imports = [
    ./backend.nix
    ./dashy.nix
    ./../../hardware-config/hardware-configuration.nix
    ./../../containers/bitcoin.nix
  ];
}
