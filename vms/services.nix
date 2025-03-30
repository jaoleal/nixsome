{ lib, pkgs, ... }:
{
  # It is highly recommended to share the host's nix-store
  # with the VMs to prevent building huge images.
  microvm.shares = [
    {
      source = "/nix/store";
      mountPoint = "/nix/.ro-store";
      tag = "ro-store";
    }
  ];
  microvm = {
    graphics.enable = true;
    interfaces = [
      {
        type = "tap";
        id = "vm-services";
        mac = "56:7c:93:8d:58:64";
      }
    ];
    vcpu = 4;
    #30gb ram
    mem = 30720;
  };

  users.groups.user = { };

  networking.hostName = "services";
  system.stateVersion = "24.05";

  users.users."root" = {
    isSystemUser = true;
    initialPassword = "123";
  };

  users.users."jaoleal" = {
    group = "user";
    initialPassword = "123";
    isNormalUser = true;
    extraGroups = [
      "wheel"
      "video"
    ];
  };

  environment.systemPackages = with pkgs; [
    hello
  ];
  systemd.network.enable = true;

  systemd.network.networks."20-lan" = {
    matchConfig.Name = "br0";
    networkConfig = {
      DHCP = true;
    };
  };
  hardware.graphics.enable = true;

}
