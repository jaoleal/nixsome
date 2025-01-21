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
}
