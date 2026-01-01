{
  pkgs,
  username,
  hostname,
  stateVersion,
  config,
  ...
}:
{
  system = { inherit stateVersion; };

  users.users."ismael" = {
    name = "ismael";
    hashedPassword = "$y$j9T$.h9gU/4FU7PAQkxpHmg7h1$r5dkf1lzpU3laZ8Loj3IIWJ7ZOKS1evHBIXWsI3jsv5";
    extraGroups = [
      "wheel"
    ];
    isSystemUser = true;
  };
  services = {
    openssh = {
      enable = true;
      ports = [ 22 ];
      openFirewall = true;
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

  sops = {
    age.keyFile = "/home/${username}/.config/sops/age/keys.txt";

    secrets.tailscale_authkey.sopsFile = ../../secrets/sec.yaml;
  };

  services.tailscale = {
    enable = true;
    authKeyFile = config.sops.secrets.tailscale_authkey.path;
  };

  services.sunshine = {
    enable = true;
    autoStart = true;
    capSysAdmin = true;
    openFirewall = true;
  };

  services = {
    displayManager = {
      autoLogin = {
        enable = true;
        user = "jaoleal";
      };

      gdm = {
        enable = true;
        wayland = true;
        autoSuspend = false;
      };
    };
    desktopManager.gnome.enable = true;
    xserver = {
      videoDrivers = [ "amdgpu" ];
      enable = true;
    };
  };

  nixpkgs.config.allowUnfree = true;
  nix.settings.experimental-features = [
    "nix-command"
    "flakes"
  ];

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
      networks."wlp5s0" = {
        networkConfig.DHCP = "ipv4";
        dhcpV4Config = {
          UseDNS = false;
        };
        dns = [
          # tailscale dns
          "100.100.100.100"
          # i need better dns
          "8.8.8.8"
          "8.8.4.4"
        ];
        domains = [ "snake-mooneye.ts.net" ];
      };
    };
    targets.hibernate.enable = false;
    targets.hybrid-sleep.enable = false;
    network.wait-online.enable = false;
  };

  services.dnsmasq = {
    enable = true;
    settings = {
      interface = "enp6s0";
      bind-interfaces = true;
      dhcp-range = "192.168.100.50,192.168.100.150,24h";
      dhcp-option = [
        "3,192.168.100.1"
        "6,192.168.100.1"
      ];
      server = [ "8.8.8.8" "8.8.4.4" ];
    };
  };

  networking = {
    hostName = hostname;
    nat = {
      enable = true;
      externalInterface = "wlp5s0";
      internalInterfaces = [ "enp6s0" ];
    };

    interfaces.enp6s0 = {
      ipv4.addresses = [{
        address = "192.168.100.1";
        prefixLength = 24;
      }];
    };

    firewall = {
      enable = true;
      trustedInterfaces = [ "tailscale0" "enp6s0" ];
    };
  };

  boot = {
    loader = {
      grub = {
        enable = true;
        efiSupport = true;
        device = "nodev";
      };
      efi.canTouchEfiVariables = true;
    };

    kernel.sysctl = {
      "net.ipv4.ip_forward" = 1;
    };
    kernelParams = [
      "video=HDMI-A-1:1920x1080@60"
    ];

    kernelPackages = pkgs.linuxPackages;

    initrd.kernelModules = [ "amdgpu" ];

  };
}
