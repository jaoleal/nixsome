{ config, pkgs, ... }:

{
    #redundant, but whatever... 
    home.username = "joaoleal";
    home.homeDirectory = "/home/joaoleal";
    home.stateVersion = "23.11";
    programs.home-manager.enable = true;
}