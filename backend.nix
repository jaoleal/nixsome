{ pkgs, ... }: {

  imports = [ ./hardware-configuration.nix ];

  fileSystems."/mnt/bigd" = {
    device = "/dev/sda1";
    fsType = "ext4";
    options = [ "defaults" "noatime" ];
  };
  systemd.user.services = {
    florestad-master = {
      enable = true;
      after = [ "network.target" ];
      wantedBy = [ "multi-user.target" ];
      description = "Florestad service";
      serviceConfig = {
        Type = "simple";
        ExecStart = "/home/jaoleal/floresta/target/release/florestad";
      };
    };
    utreexod = {
      enable = true;
      after = [ "network.target" ];
      wantedBy = [ "multi-user.target" ];
      description = "Florestad service";
      serviceConfig = {
        Type = "simple";
        ExecStart =
          "/home/jaoleal/utreexod/utreexod --utreexoproofindex --prune=0 -b  /mnt/bigd/.utreexod/data";
      };
    };

  };
  services = {
    pipewire = {
      enable = true;
      alsa.enable = true;
      alsa.support32Bit = true;
      pulse.enable = true;
    };
    sunshine = {
      enable = true;
      autoStart = true;
      capSysAdmin = true;
      openFirewall = true;
    };
    xserver = {
      enable = true;
      desktopManager.gnome.enable = true;
      displayManager.gdm.enable = true;
    };
    openssh = {
      enable = true;
      startWhenNeeded = true;
      ports = [ 22 ];
      settings = {
        PasswordAuthentication = true;
        AllowUsers = [ "jaoleal" ];
        UseDns = true;
        X11Forwarding = true;
        X11UseLocalhost = "no";
      };
    };
  };
  programs = {
    nix-ld.enable = true;
    ssh.forwardX11 = true;
  };
  environment.systemPackages = let
    #Some packages that i need locally to do remote development
    dev_deps = with pkgs; [
      rustup
      git
      just
      clang
      pkg-config
      openssl

    ];
  in with pkgs; [ wget vim yubikey-manager usbutils xorg.xauth ] ++ dev_deps;
  hardware.graphics.enable = true;

  users.users.jaoleal = {
    isNormalUser = true;
    linger = true;
    description = "Joao Leal";
    extraGroups = [ "networkmanager" "wheel" ];
  };

  nixpkgs.config.allowUnfree = true;
  services.pcscd.enable = true;
  services.tailscale.enable = true;
  networking.networkmanager.enable = true;
  time.timeZone = "America/Sao_Paulo";
  services.xserver.xkb = {
    layout = "us";
    variant = " ";
  };
  hardware.pulseaudio.enable = false;
  security.rtkit.enable = true;
  i18n.defaultLocale = "en_US.UTF-8";
  time.hardwareClockInLocalTime = true;
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

    network.wait-online.enable = false;
  };

  networking.firewall = {
    enable = true;
    allowedTCPPorts = [ 22 47984 47989 47990 48010 ];
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

  system.stateVersion = " 24.05 "; # Did you read the comment?

  nix.settings.experimental-features = [ "nix-command" "flakes" ];
}
