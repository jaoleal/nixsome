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

  programs.virt-manager.enable = true;

  virtualisation.libvirtd.enable = true;

  virtualisation.spiceUSBRedirection.enable = true;

  services.minecraft-server = {
    enable = true;
    eula = true; # Required to accept Mojang's EULA
    package = pkgs.papermc; # Better performance than vanilla
    openFirewall = true; # Allows connections on port 25565
    declarative = true; # Ensures config is managed by NixOS

    # Basic server settings (customize as needed)
    serverProperties = {
      server-port = 25565;
      difficulty = "hard";
      gamemode = "survival";
      max-players = 50;
      motd = "CypherCraft~!!";
      online-mode = true; # Set to false for offline/cracked servers
    };

    # Optimized JVM flags for massive RAM (64GB allocated)
    jvmOpts = ''
      -Xms64G -Xmx64G
      -XX:+UseG1GC
      -XX:+UnlockExperimentalVMOptions
      -XX:MaxGCPauseMillis=100
      -XX:+AlwaysPreTouch
      -XX:ParallelGCThreads=8
    '';
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
    #proton-vpn-local-agent
    #protonvpn-gui
    #protonmail-desktop
    signal-desktop
    git
    nautilus
    wget
    vim
    # usbutils
    just
    usbutils
    curl
    direnv
    jetbrains.rust-rover
    swtpm
  ];
  #fonts.packages = with pkgs; [ nerdfonts ];
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
  };

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
    targets.hibernate.enable = false;
    targets.hybrid-sleep.enable = false;
    network.wait-online.enable = false;
  };
  networking.useNetworkd = true;
  networking = {
    hostName = "${hostname}";
    firewall = {
      enable = true;
      allowedTCPPorts = [
        22
        47984
        3389
        47989
        47990
        48010
      ];
      allowedUDPPortRanges = [
        {
          from = 47998;
          to = 48000;
        }
        {
          from = 8000;
          to = 8010;
        }
      ];
    };
  };
  systemd.network.enable = true;
  systemd.network.networks."10-lan" = {
    matchConfig.Name = [
      "enp6s0"
      "services"
    ];
    networkConfig = {
      Bridge = "br0";
    };
  };
  systemd.network.netdevs."br0" = {
    netdevConfig = {
      Name = "br0";
      Kind = "bridge";
    };
  };

  systemd.network.networks."10-lan-bridge" = {
    matchConfig.Name = "br0";
    networkConfig = {
      DHCP = true;
    };
  };

  # microvm.autostart = [
  #   "vm-services"
  #
  #];

  nix.settings.experimental-features = [
    "nix-command"
    "flakes"
  ];

  boot = {

    initrd.systemd.network.wait-online.enable = false;

    loader.grub.enable = true;
    loader.grub.device = "nodev";
    loader.grub.useOSProber = true;

    kernelPackages = pkgs.linuxPackages;

    initrd.kernelModules = [ "amdgpu" ];

  };
}
