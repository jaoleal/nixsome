{
  stateVersion,
  username,
pkgs,
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

    useWindowsDriver = true;
	defaultUser = username;
	};

	users.users.root = {
		name =  "root";
	hashedPassword =  "$y$j9T$c79Lyfiy4jwaboa8I8CXW0$4cxD4o/NaqwgYBQ3V0iAV6WL3v1eT0YP8OSuUndvxx9";
#	description = "A root user for the wsl nixos";
	isSystemUser = true;
};

environment.systemPackages = with pkgs; [
	jetbrains.rust-rover
	jetbrains.gateway
];

services.openssh = {
  enable = true;
  ports = [ 22 ];
  settings = {
    PasswordAuthentication = true;
    AllowUsers = null; # Allows all users by default. Can be [ "user1" "user2" ]
    UseDns = true;
    X11Forwarding = false;
    PermitRootLogin = "prohibit-password"; # "yes", "without-password", "prohibit-password", "forced-commands-only", "no"
  };
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

  # boot = {
  #  loader.systemd-boot.enable = true;
  # };
}
