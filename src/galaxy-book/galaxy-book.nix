{
  pkgs,
  hostname,
  stateVersion,
  ...
}:
{
  system.stateVersion = stateVersion;

  services.libinput.enable = true;

  networking = {
    hostName = hostname;
  };

  xdg.portal.enable = true;
  xdg.portal.extraPortals = [ pkgs.xdg-desktop-portal-gtk ];

  programs.nix-ld.enable = true;

  environment.systemPackages = with pkgs; [
    git
    nautilus
    wget
    vim
    just
    usbutils
    curl
    alacritty
  ];
  services.tailscale.enable = true;

  hardware.graphics = {
    enable = true;
    extraPackages = with pkgs; [ vpl-gpu-rt ];
  };

  nixpkgs.config.allowUnfree = true;

  time.timeZone = "America/Sao_Paulo";
  services.xserver.xkb = {
    layout = "us";
    variant = " ";
  };

  security.rtkit.enable = true;

  i18n.defaultLocale = "en_US.UTF-8";

  nix.settings.experimental-features = [
    "nix-command"
    "flakes"
  ];
}
