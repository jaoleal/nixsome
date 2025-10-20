{
  pkgs,
  username,
  hostname,
  stateVersion,
  ...
}:
{
  system.stateVersion = stateVersion;
  users = {
    users.service-runner = {
      isNormalUser = true;
      linger = true;
      name = "service-runner";
      description = "service-runner, user that owns backservices";
      extraGroups = [
        "networkmanager"
        "wheel"
        "libvirtd"
      ];
    };
    mutableUsers = true;
    groups.libvirtd.members = [
      "service-runner"
      username
    ];
  };

  services = {
    openssh = {
      enable = true;
      ports = [ 22 ];
      settings = {
        PasswordAuthentication = true;
        UseDns = true;
        X11Forwarding = true;
      };
    };
  };

  programs = {
    nix-ld.enable = true;

    steam = {
      enable = true;
      remotePlay.openFirewall = true;
      dedicatedServer.openFirewall = true;
      localNetworkGameTransfers.openFirewall = true;
    };
  };

  environment.systemPackages = with pkgs; [
    signal-desktop
    git
    nautilus
    wget
    vim
    just
    usbutils
    curl
    direnv
    alacritty
  ];
  services.tailscale.enable = true;
  services.sunshine = {
    enable = true;
    autoStart = true;
    capSysAdmin = true;
    openFirewall = true;
  };
  services.xserver = {
    videoDrivers = [ "amdgpu" ];
    enable = true;

    displayManager.gdm.enable = true;
    desktopManager.gnome.enable = true;

  };
  environment.gnome.excludePackages = (
    with pkgs;
    [
      atomix # puzzle game
      cheese # webcam tool
      epiphany # web browser
      evince # document viewer
      geary # email reader
      gedit # text editor
      gnome-characters
      gnome-music
      gnome-photos
      gnome-terminal
      gnome-tour
      hitori # sudoku game
      iagno # go game
      tali # poker game
      totem # video player
    ]
  );

  nixpkgs.config.allowUnfree = true;

  time.timeZone = "America/Sao_Paulo";
  services.xserver.xkb = {
    layout = "us";
    variant = " ";
  };

  security.rtkit.enable = true;

  i18n.defaultLocale = "en_US.UTF-8";

  systemd = {
    sleep.extraConfig = ''
      AllowSuspend=no
      AllowHibernation=no
      AllowHybridSleep=no
      AllowSuspendThenHibernate=no
    '';
    targets.sleep.enable = false;
    targets.suspend.enable = false;
    network = {
      enable = true;
      networks."10-lan" = {
        matchConfig.Name = "lan";
        networkConfig.DHCP = "ipv4";
      };
    };
    targets.hibernate.enable = false;
    targets.hybrid-sleep.enable = false;
    network.wait-online.enable = false;
  };
  nix.settings.experimental-features = [
    "nix-command"
    "flakes"
  ];

  boot = {

    #    initrd.systemd.network.wait-online.enable = false;

    # loader.grub.enable = true;
    # loader.grub.device = "nodev";
    # loader.grub.useOSProber = true;
    # Use the systemd-boot EFI boot loader.
    loader.systemd-boot.enable = true;
    loader.efi.canTouchEfiVariables = true;

    kernelPackages = pkgs.linuxPackages;

    initrd.kernelModules = [ "amdgpu" ];

  };
}
