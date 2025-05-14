# These are expressions that yield a
# full blown gaming setup that offers
# a complete isolated and restrained
# environment with the solely purposes off
# gaming.
#
# The principles i want to to cover is;
#
# 1. Eficient remote access with Wake-on-Lan and auto login.
#
# 2. Separated environment that doesnt offer ways to interfere
# the use/execution of other users (Mostly myself, this will
# offer more protection).
#
# 3.
{
  pkgs,
  hostname,
  ...
}:
let
  username = "gaminboy";
in
{
  users = {
    users.${username} = {
      isNormalUser = true;
      name = username;
      description = "${username}, Just a little gamer.";
      password = "sebolinha~adestrado"; # Congrats, now you can play my games!
      packages = with pkgs; [
        moonlight-qt
        heroic
      ];
    };

  };

  programs = {
    steam = {
      enable = true;
      remotePlay.openFirewall = true;
      dedicatedServer.openFirewall = true;
      localNetworkGameTransfers.openFirewall = true;
    };
  };

  services.tailscale.enable = true;

  services.sunshine = {
    enable = true;

    autoStart = true;

    capSysAdmin = true;

    openFirewall = true;

    environment = {
      PATH = [
        "$PATH"
        "$HOME/.local/bin"
      ];

      DISPLAY = ":0";

    };

    applications = {
      apps = [
        {
          name = "steam";

          prep-cmd = [
            {
              do = "${pkgs.xorg.xrandr}/bin/xrandr --output DP-3 --mode ${"$SUNSHINE_CLIENT_WIDTH"}x${"$SUNSHINE_CLIENT_HEIGHT"} --rate ${"$SUNSHINE_CLIENT_FPS"}";

              undo = "${pkgs.xorg.xrandr}/bin/xrandr --output DP-3 --mode 2560x1440 --rate 120";

            }
          ];

          exclude-global-prep-cmd = false;

          auto-detach = true;

          detached-commands = [
            "${pkgs.steam}/bin/steam steam://open/bigpicture"
          ];

        }
      ];
    };
  };
  nixpkgs.config.allowUnfree = true;
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
  networking.useNetworkd = false;
  networking = {
    hostName = "${hostname}";
    firewall = {
      enable = true;
      allowedTCPPorts = [
        47984
        3389
        47989
        47990
        48010
      ];
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
  };
}
