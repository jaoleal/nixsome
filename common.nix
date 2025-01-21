# This is the commom configs between desktop and notebook
{ pkgs, ... }:
{
  imports = [
    ./hardware-configuration.nix
  ];

  environment.systemPackages = with pkgs; [
    wget
    vim
    proton-vpn-local-agent
    protonvpn-gui
    protonmail-desktop
    just
    yubikey-manager
    usbutils
    nixpkgs-fmt
    nixd
    rustup
    pkg-config
    openssl
    clang
  ];
  fonts.packages = with pkgs; [ nerdfonts ];
  users.users.jaoleal = {
    isNormalUser = true;
    description = "Joao Leal";
    extraGroups = [ "networkmanager" "wheel" ];
  };
  services.tailscale.enable = true;
  services.xserver = {
    enable = true;
    desktopManager.gnome.enable = true;
    displayManager.gdm.enable = true;
  };
  nixpkgs.config.allowUnfree = true;
  services.udev.packages = [ pkgs.yubikey-personalization ];
  services.dbus.packages = [ pkgs.gcr ];
  services.flatpak.enable = true;
  services.pcscd.enable = true;
  networking.networkmanager.enable = true;
  time.timeZone = "America/Sao_Paulo";
  services.xserver.xkb = {
    layout = "us";
    variant = "";
  };
  hardware.pulseaudio.enable = false;
  security.rtkit.enable = true;
  services.pipewire = {
    enable = true;
    alsa.enable = true;
    alsa.support32Bit = true;
    pulse.enable = true;
  };
  i18n.defaultLocale = "en_US.UTF-8";
  time.hardwareClockInLocalTime = true;
  boot = {
    loader = {
      grub.enable = true;
      grub.device = "nodev";
      grub.useOSProber = true;
      grub.efiSupport = true;
      efi.canTouchEfiVariables = true;
    };
  };
  system.stateVersion = "24.05"; # Did you read the comment?

  nix.settings.experimental-features = [ "nix-command" "flakes" ];
}
