{
  pkgs,
  username,
  hostname,
  ...
}:
{

  users.groups.libvirtd.members = [ "${username}" ];

  services = {
    openssh = {

      startWhenNeeded = true;
      ports = [ 22 ];
      settings = {
        PasswordAuthentication = true;
        AllowUsers = [ "${username}" ];
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
  users.users.${username} = {
    isNormalUser = true;
    linger = true;
    description = "Joao Leal";
    extraGroups = [
      "networkmanager"
      "wheel"
      "libvirtd"
    ];
  };
  services.xserver = {
    videoDrivers = [ "amdgpu" ];
    enable = true;
  };

  nixpkgs.config.allowUnfree = true;
  services.tailscale.enable = true;
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

  microvm.autostart = [
    "vm-services"
  ];

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
