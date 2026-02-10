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
    networkmanager.enable = true;
  };
  hardware.bluetooth.enable = true;

  services.blueman.enable = true;

  xdg.portal.enable = true;
  xdg.portal.extraPortals = [ pkgs.xdg-desktop-portal-gtk ];

  programs.nix-ld.enable = true;
  services.udev = {
    packages = with pkgs; [
      qmk-udev-rules
      vial
    ];
  };

  environment.systemPackages = with pkgs; [
    git
    bottom
    vial
    nautilus
    bluetui
    wget
    vim
    just
    usbutils
    curl
    alacritty
    powertop
  ];
  services.tailscale.enable = true;

  services.auto-cpufreq.enable = true;
  services.power-profiles-daemon.enable = false;
  services.thermald.enable = true;

  systemd.services.powertop-autotune = {
    description = "Powertop auto-tune";
    wantedBy = [ "multi-user.target" ];
    serviceConfig = {
      Type = "oneshot";
      ExecStart = "${pkgs.powertop}/bin/powertop --auto-tune";
      RemainAfterExit = true;
    };
  };

  boot.kernelParams = [
    "nmi_watchdog=0"
    "i915.enable_psr=1"
    "i915.enable_fbc=1"
  ];

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
