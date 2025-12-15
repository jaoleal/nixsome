{
  pkgs,
  username,
  hostname,
  stateVersion,
  config,
  ...
}:
{
  networking = {
    hostName = hostname;
  };

  system = { inherit stateVersion; };
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
    displayManager.gdm.enable = true;
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
      networks."10-lan" = {
        matchConfig.Name = "lan";
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

  networking = {
    nftables.enable = true;

    firewall = {
      enable = true;
      trustedInterfaces = [ "tailscale0" ];
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

    kernelPackages = pkgs.linuxPackages;

    initrd.kernelModules = [ "amdgpu" ];

  };
}
