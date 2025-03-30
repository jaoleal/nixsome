{ pkgs, ... }:
{
  imports = [
    ../hardware-config/backend-hardware-configuration.nix
  ];

  users.groups.libvirtd.members = [ "jaoleal" ];

  virtualisation.libvirtd.enable = true;

  boot.kernelPackages = pkgs.linuxPackages;
  services = {
    openssh = {
      enable = true;
      startWhenNeeded = true;
      ports = [ 22 ];
      settings = {
        PasswordAuthentication = true;
        AllowUsers = [ "jaoleal" ];
        UseDns = true;
        X11Forwarding = true;
      };
    };
  };
  programs = {
    nix-ld.enable = true;
  };
  environment.systemPackages =

    with pkgs; [
      git
      wget
      vim
      usbutils
    ];
  hardware.graphics.enable = true;

  users.users.jaoleal = {
    isNormalUser = true;
    linger = true;
    description = "Joao Leal";
    extraGroups = [
      "networkmanager"
      "wheel"
    ];
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
  boot = {
    initrd.systemd.network.wait-online.enable = false;
    loader.systemd-boot.enable = true;
  };
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
    hostName = "sv";
    networkmanager.enable = true;
  };

  networking.firewall = {
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

  system.stateVersion = "24.05"; # Did you read the comment?

  microvm.autostart = [
    "vm-userland"
    "vm-services"
  ];
  nix.settings.experimental-features = [
    "nix-command"
    "flakes"
  ];
}
