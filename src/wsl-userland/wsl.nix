{
  stateVersion,
  username,
  ...
}:
{

  wsl = {
    enable = true;
    startMenuLaunchers = true;
    usbip = {
      enable = true;
      autoAttach = [
        "1-7"
      ];
    };
    wslConf.user.default = username;
    useWindowsDriver = true;
  };

  nixpkgs.config.allowUnfree = true;

  time.timeZone = "America/Sao_Paulo";

  nix.settings.experimental-features = [
    "nix-command"
    "flakes"
  ];
  system.stateVersion = stateVersion; # Did you read the comment?

  networking.networkmanager.enable = true;
  security.rtkit.enable = true;

  services = {

    tailscale.enable = true;

    flatpak.enable = true;

    xserver = {
      xkb = {
        layout = "us";
        variant = "";
      };
    };
  };

  boot = {
    loader.systemd-boot.enable = true;
  };
}
