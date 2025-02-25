{ ... }: {
  hardware.graphics.enable = true;
  boot = {
    loader = {
      systemd-boot.enable = true;
    };
  };
}
