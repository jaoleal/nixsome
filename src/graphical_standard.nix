{ pkgs, ... }:

let
  theme = "${pkgs.base16-schemes}/share/themes/decaf.yaml";

in
{
  # Enable essential services
  services = {
    dbus.enable = true;
  };

  programs = {
    niri = {
      enable = true;

    };

    waybar.enable = true;

    dconf.enable = true;
  };

  environment = {
    systemPackages = with pkgs; [

      waybar
      swww
      fuzzel
      swaylock-effects
      mako

      xdg-desktop-portal-gtk
      xdg-desktop-portal-wlr
      xdg-utils

      wl-clipboard
      swaylock

      networkmanagerapplet
      pavucontrol
    ];

    # GTK theming
    variables = {
      GTK_THEME = "Adwaita-dark"; # Example theme
      QT_QPA_PLATFORM = "wayland";
      SDL_VIDEODRIVER = "wayland";
    };
  };

  # XDG integration
  xdg = {
    portal = {
      enable = true;
      extraPortals = with pkgs; [
        xdg-desktop-portal-gtk
        xdg-desktop-portal-wlr
      ];
    };
  };

  security.polkit.enable = true;

  services = {
    # Disable automatic suspend
    logind = {
      lidSwitch = "ignore";
      lidSwitchExternalPower = "ignore";
      extraConfig = ''
        HandlePowerKey=ignore
        HandleSuspendKey=ignore
        HandleHibernateKey=ignore
        HandleLidSwitch=ignore
        HandleLidSwitchExternalPower=ignore
      '';
    };

    # Optional: For manual power management control
    upower.enable = true;
  };

  # Disable screen blanking
  services.xserver.xautolock.enable = false;

  services.swayidle = {
    enable = true;
    timeouts = [
      # Turn off screen after 5 minutes, but don't lock
      {
        timeout = 300;
        command = "${pkgs.sway}/bin/swaymsg 'output * dpms off'";
        resumeCommand = "${pkgs.sway}/bin/swaymsg 'output * dpms on'";
      }
    ];

    # Lock immediately when switching to idle state
    events = [
      {
        event = "before-sleep";
        command = "${pkgs.swaylock-effects}/bin/swaylock";
      }
      {
        event = "lock";
        command = "${pkgs.swaylock-effects}/bin/swaylock";
      }
    ];
  };

}
