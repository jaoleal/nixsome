{
  pkgs,
  username,
  stateVersion,
  ...
}:
{

  users.users.${username} = {
    name = username;
    isNormalUser = true;
    description = "${username}";
    initialPassword = "123";
    extraGroups = [
      "networkmanager"
      "wheel"
      "libvirtd"
    ];
  };

  fonts.packages = with pkgs; [ nerdfonts ];

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

    xserver = {

      enable = true;
      desktopManager.gnome.enable = true;

      xkb = {
        layout = "us";
        variant = "";
      };
    };

    flatpak.enable = true;

  };

  boot = {
    loader.systemd-boot.enable = true;
    kernelParams = [
      "acpi_osi=!"
      ''acpi_osi="Windows 2022"''
    ];
  };
}
