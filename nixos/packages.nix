{ config, pkgs ? import (fetchTarball "github:NixOS/nixpkgs/nixos-unstable"), ... }:
{
    #Set my neovim here
    #neovim.url = ""
    environment = {
        systemPackages = with pkgs; [
            #hyprland
            kitty
            #Ide's and Pde's
            nano
            vscode
            neovim
            
            #Socials
            discord
            mullvad-vpn
            mullvad
            signal-desktop

            #dev tools
            direnv
            docker
            wget
            git
            alacritty
            zsh
            tmux
            gnupg
        ]
    }
}