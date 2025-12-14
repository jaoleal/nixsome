{ ... }:
{
  imports = [
    ./backend.nix
    ./dashy.nix
    ./../../hardware-config/backend-hardware-configuration.nix
    ./../../containers/bitcoin.nix
  ];
}
