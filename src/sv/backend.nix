{
  pkgs,
  username,
  hostname,
  ...
}:
{
  users = {
    users.${username} = {
      isNormalUser = true;
      linger = true;
      name = username;
      description = "${username}";
      initialPassword = "cadu";
      extraGroups = [
        "networkmanager"
        "wheel"
        "libvirtd"
      ];
    };
    mutableUsers = true;
    groups.libvirtd.members = [ "${username}" ];
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
    moonlight-qt
    proton-vpn-local-agent
    protonvpn-gui
    protonmail-desktop
    signal-desktop
    heroic
    git
    wget
    vim
    usbutils
    just
    usbutils
    curl
    direnv
  ];
  hardware.graphics.enable = true;
  fonts.packages = with pkgs; [ nerdfonts ];
  services.tailscale.enable = true;
  services.sunshine = {
    enable = true;
    autoStart = true;
    capSysAdmin = true;
    openFirewall = true;
    #applications = {
    #  env = {
    #    PATH = "$(PATH):$(HOME)/.local/bin";
    #  };
    #  apps = [
    #    {
    #      name = "steam";
    #      prep-cmd = [
    #        {
    #            do = "${pkgs.xorg.xrandr}/bin/xrandr --output DP-3 --mode $(SUNSHINE_CLIENT_WIDTH)x$(SUNSHINE_CLIENT_HEIGHT) --rate $(SUNSHINE_CLIENT_FPS)";
    #            undo = "${pkgs.xorg.xrandr}/bin/xrandr --output DP-3 --mode 2560x1440 --rate 120";
    #          }
    #        ];
    #        exclude-global-prep-cmd = "false";
    #        auto-detach = "true";
    #        detached-commands = [
    #          "setsid steam steam://open/bigpicture"
    #        ];
    #      }
    #    ];
    #  };

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
  hardware.pulseaudio.enable = false;

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
  networking.useNetworkd = false;
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

    loader.systemd-boot.enable = true;

    kernelPackages = pkgs.linuxPackages;

    initrd.kernelModules = [ "amdgpu" ];

  };
}
