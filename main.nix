{ lib, pkgs, ... }:
{
  systemPackages = with pkgs; [
    wget
    vim
    just
    distrobox
    yubikey-manager
    usbutils
    nixpkgs-fmt
    nixd
    gnupg
    clang
  ];
  programs = {
    nix-ld = {
      enable = true;
      package = pkgs.nix-ld-rs;
    };
  };

  nixosConfig = lib.mkIf (pkgs.stdenv.isLinux && pkgs.stdenv.isNixos) {
    wsl = {
      enable = true;
      defaultUser = "JoaoLeal";
    };
    networking.hostName = "nixos";
    time.timeZone = "UTC";
    users.users.JoaoLeal = {
      isNormalUser = true;
      extraGroups = [ "wheel" ];
    };
    services.udev.packages = [ pkgs.yubikey-personalization ];
    services.pcscd.enable = true;
    hardware.gpgSmartcards.enable = true;
  };

  nix.settings.experimental-features = [ "nix-command" "flakes" ];
}
