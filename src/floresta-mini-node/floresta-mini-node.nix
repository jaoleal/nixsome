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

  environment.systemPackages = with pkgs; [
    wget
    vim
    just
    usbutils
    curl
    direnv
    htop
    tmux
  ];

  services.tailscale.enable = true;

  time.timeZone = "America/Sao_Paulo";
  services.xserver.xkb = {
    layout = "us";
    variant = " ";
  };

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
  nix.settings.experimental-features = [
    "nix-command"
    "flakes"
  ];

  boot = {
    loader.systemd-boot.enable = true;
    loader.efi.canTouchEfiVariables = true;

    kernelPackages = pkgs.linuxPackages;

    initrd.kernelModules = [ "amdgpu" ];

  };
}
