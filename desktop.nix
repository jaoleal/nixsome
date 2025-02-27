{ config, ... }:
{
  services.xserver = {
    videoDrivers = [ "nvidia" ];
  };
  networking.hostName = "SM8953";
  hardware.nvidia = {
    modesetting.enable = true;
    powerManagement.enable = true;
    powerManagement.finegrained = false;
    open = false;
    nvidiaSettings = true;
    package = config.boot.kernelPackages.nvidiaPackages.stable;
  };

  programs.virt-manager.enable = true;

  users.groups.libvirtd.members = [ "jaoleal" ];
  boot = {
    loader = {
      grub.enable = true;
      grub.device = "nodev";
      grub.useOSProber = true;
      grub.efiSupport = true;
      efi.canTouchEfiVariables = true;
    };
  };
  virtualisation = {
    libvirtd.enable = true;
    spiceUSBRedirection.enable = true;
  };
}
