{
  pkgs,
  username,
  ...
}:
{

  users.users.${username} = {
    isNormalUser = true;
    description = "Joao Leal";
    extraGroups = [
      "networkmanager"
      "wheel"
      "libvirtd"
    ];
  };

  fonts.packages = with pkgs; [ nerdfonts ];

  nixpkgs.config.allowUnfree = true;

  time.timeZone = "America/Sao_Paulo";

  nix.settings.experimental-features = [
    "nix-command"
    "flakes"
  ];
  system.stateVersion = "24.11"; # Did you read the comment?

  services = {

    hardware.pulseaudio.enable = false;

    tailscale.enable = true;

    security.rtkit.enable = true;

    networking.networkmanager.enable = true;

    xserver = {

      enable = true;
      desktopManager.gnome.enable = true;

      xkb = {
        layout = "us";
        variant = "";
      };
    };

    i18n.defaultLocale = "en_US.UTF-8";

    flatpak.enable = true;

    gpg-agent = {
      enable = true;
      sshKeys = [ "17E5F552FCCEC23CD086C617298E5BD0BAF906BD" ];
      enableSshSupport = true;
      defaultCacheTtlSsh = 4000;
      defaultCacheTtl = 34560000;
      maxCacheTtl = 34560000;
      enableBashIntegration = true;
      enableScDaemon = true;
      grabKeyboardAndMouse = true;
      pinentryPackage = pkgs.pinentry-gnome3;
    };

    pipewire = {
      enable = true;
      alsa.enable = true;
      alsa.support32Bit = true;
      pulse.enable = true;
    };
  };

  boot.loader.systemd-boot.enable = true;
}
