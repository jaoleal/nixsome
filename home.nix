{ config, pkgs, ... }:

{
  home = {
    username = "joaoleal";
    homeDirectory = "/home/joaoleal";
    stateVersion = "24.05"; # Dont change.
    packages = with pkgs; [ git ];
    file = { };
    sessionVariables = { };
  };
  services = {
    gpg-agent = {
      enable = true;
      #pinentryPackage = pkgs.pinentry-qt;
      #Enable the gpg-agent to act as a ssh-agent. 
      enableSshSupport = true;
      
      defaultCacheTtlSsh = 14400;
      defaultCacheTtl = 14400;
      maxCacheTtl = 14400;
      maxCacheTtlSsh = 14400;
    };
  };
  programs = {
    git = {
      enable = true;
      userEmail = "jgleal@protonmail.com";
      userName = "jaoleal";
      signing = {
        key = "0x80A9E51B3B06FE4A";
        signByDefault = true;
      };
    };
    home-manager.enable = true;
  };
}
