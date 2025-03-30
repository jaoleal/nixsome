# This is the commom configs between desktop and notebook
{ pkgs, ... }: {
  environment.systemPackages = with pkgs; [
    wget
    vim
    proton-vpn-local-agent
    protonvpn-gui
    protonmail-desktop
    just
    usbutils
    nixpkgs-fmt
    niv
    curl
    direnv
    nixd
    rustup
    pkg-config
    vscode
    openssl
    clang
    moonlight-qt
    vial
  ];
  services.udev.packages = with pkgs; [ vial via ];
  programs.steam.enable = true;
  fonts.packages = with pkgs; [ nerdfonts ];
  users.users.jaoleal = {
    isNormalUser = true;
    description = "Joao Leal";
    extraGroups = [ "networkmanager" "wheel" "libvirtd" ];
  };
  services.tailscale.enable = true;
  services.xserver = {
    enable = true;
    desktopManager.gnome.enable = true;
  };
  nixpkgs.config.allowUnfree = true;
  services.flatpak.enable = true;
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

  system.stateVersion = "24.11"; # Did you read the comment?

  nix.settings.experimental-features = [ "nix-command" "flakes" ];

  hardware.graphics.enable = true;
  boot = { loader = { systemd-boot.enable = true; }; };
}
