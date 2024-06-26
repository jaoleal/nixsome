{ config, pkgs,... }:
{
environment.systemPackages = with pkgs; [
    gnupg
    home-manager
    
    #bitcoin
    bitcoin
    sparrow
    firefox
    tor-browser
    lutris
    wine
    gamescope
    syncthing-tray
    syncthing
    #Ide's and Pde's
    vscode

    #Socials
    mullvad-vpn
    discord
    mullvad
    signal-desktop
    protonmail-desktop
    keepassxc
    
    #dev tools
    pkg-config
    openssl
    cargo 
    rustup
    rustc
    direnv
    wget
  ]; 
}
