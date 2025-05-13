{ pkgs, ... }:
{
  # It is highly recommended to share the host's nix-store
  # with the VMs to prevent building huge images.
  microvm = {
    shares = [
      {
        source = "/nix/store";
        mountPoint = "/nix/.ro-store";
        tag = "ro-store";
      }
    ];
    interfaces = [
      {
        type = "user";
        id = "services";
        mac = "56:7c:93:8d:58:64";
      }
    ];
    hypervisor = "qemu";
    vcpu = 4;
    #30gb ram
    mem = 30720;
  };
  services = {
    openssh = {

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
  boot.kernelPackages = pkgs.linuxPackages;

  networking.hostName = "services";
  system.stateVersion = "24.05";

  users.users.root = {
    isSystemUser = true;
    initialPassword = "123";
  };
  time.timeZone = "America/Sao_Paulo";
  services.tailscale.enable = true;
  nixpkgs.config.allowUnfree = true;

  users.users.jaoleal = {
    initialPassword = "123";
    isNormalUser = true;
    linger = true;
    extraGroups = [
      "wheel"
    ];
  };
  programs.nix-ld.enable = true;
  environment.systemPackages = with pkgs; [
    coreutils-full
  ];

  systemd.network.networks."20-lan" = {
    matchConfig.Name = "br0";
    networkConfig = {
      DHCP = true;
    };
  };
  hardware.graphics.enable = true;
}
