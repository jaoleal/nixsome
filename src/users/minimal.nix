{
  pkgs,
  lib,
  username,
  ...
}:
{
  programs.hyprland.enable = true;

  services.xserver.enable = lib.mkDefault false;
  services.desktopManager.gnome.enable = lib.mkDefault false;
  services.displayManager.gdm.enable = lib.mkDefault false;

  environment.sessionVariables.NIXOS_OZONE_WL = "1";

  environment.sessionVariables.QT_QPA_PLATFORMTHEME = "gtk3";

  environment.systemPackages = with pkgs; [
    waybar
    wofi
    wl-clipboard
    mako
    hyprpaper
  ];

  home-manager.users.${username} = {

    wayland.windowManager.hyprland = {
      enable = true;
      settings = {
        "$mod" = "SUPER";
        "$terminal" = "alacritty";
        "$menu" = "wofi --show drun";

        monitor = [ ",preferred,auto,1" ];

        general = {
          gaps_in = 4;
          gaps_out = 8;
          border_size = 2;
          "col.active_border" = "rgba(88c0d0ff)";
          "col.inactive_border" = "rgba(4c566aff)";
          layout = "dwindle";
        };

        decoration = {
          rounding = 6;
          blur = {
            enabled = true;
            size = 4;
            passes = 2;
          };
          shadow = {
            enabled = false;
          };
        };

        input = {
          kb_layout = "us";
          follow_mouse = 1;
          touchpad = {
            natural_scroll = true;
          };
        };

        animations.enabled = false;

        dwindle = {
          pseudotile = true;
          preserve_split = true;
        };

        gesture = [ "3, horizontal, workspace" ];

        # Workspace rules: assign apps to workspaces
        windowrule = [
          "workspace 2, match:class ^(chromium-browser)$"
          "workspace 3, match:class ^(dev.zed.Zed)$"
          "workspace 1, match:class ^(Alacritty)$"
        ];

        # Autostart
        exec-once = [
          "waybar"
          "mako"
        ];

        # Keybindings
        bind = [
          # App launchers
          "$mod, Return, exec, $terminal"
          "$mod, D, exec, $menu"
          "$mod, Q, killactive,"
          "$mod, M, exit,"
          "$mod, F, fullscreen,"
          "$mod, V, togglefloating,"
          "$mod, P, pseudo,"
          "$mod, S, togglesplit,"

          # Focus (arrow keys)
          "$mod, left, movefocus, l"
          "$mod, right, movefocus, r"
          "$mod, up, movefocus, u"
          "$mod, down, movefocus, d"

          # Focus (vim keys)
          "$mod, H, movefocus, l"
          "$mod, L, movefocus, r"
          "$mod, K, movefocus, u"
          "$mod, J, movefocus, d"

          # Move windows
          "$mod SHIFT, left, movewindow, l"
          "$mod SHIFT, right, movewindow, r"
          "$mod SHIFT, up, movewindow, u"
          "$mod SHIFT, down, movewindow, d"
          "$mod SHIFT, H, movewindow, l"
          "$mod SHIFT, L, movewindow, r"
          "$mod SHIFT, K, movewindow, u"
          "$mod SHIFT, J, movewindow, d"

          # Workspaces
          "$mod, 1, workspace, 1"
          "$mod, 2, workspace, 2"
          "$mod, 3, workspace, 3"
          "$mod, 4, workspace, 4"
          "$mod, 5, workspace, 5"
          "$mod, 6, workspace, 6"
          "$mod, 7, workspace, 7"
          "$mod, 8, workspace, 8"
          "$mod, 9, workspace, 9"

          # Move window to workspace
          "$mod SHIFT, 1, movetoworkspace, 1"
          "$mod SHIFT, 2, movetoworkspace, 2"
          "$mod SHIFT, 3, movetoworkspace, 3"
          "$mod SHIFT, 4, movetoworkspace, 4"
          "$mod SHIFT, 5, movetoworkspace, 5"
          "$mod SHIFT, 6, movetoworkspace, 6"
          "$mod SHIFT, 7, movetoworkspace, 7"
          "$mod SHIFT, 8, movetoworkspace, 8"
          "$mod SHIFT, 9, movetoworkspace, 9"

          # Scroll through workspaces
          "$mod, mouse_down, workspace, e+1"
          "$mod, mouse_up, workspace, e-1"
        ];

        # Mouse bindings
        bindm = [
          "$mod, mouse:272, movewindow"
          "$mod, mouse:273, resizewindow"
        ];
      };
    };

    # Dark mode (GTK)
    gtk = {
      enable = true;
      theme = {
        name = "Adwaita-dark";
        package = pkgs.gnome-themes-extra;
      };
    };

    dconf.settings = {
      "org/gnome/desktop/interface" = {
        color-scheme = "prefer-dark";
      };
    };

    services.hyprpaper = {
      enable = true;
      settings = {
        ipc = "on";
        splash = false;

        preload = [
          "/home/jaoleal/Documents/kbumbum.jpg"
          "/home/jaoleal/Documents/OhayoWindowsSama.jpg"
        ];

        wallpaper = [
          "DP-1,/home/jaoleal/Documents/OhayoWindowsSama.jpg"
        ];
      };

    };

    programs.waybar = {
      enable = true;
      settings = {
        mainBar = {
          layer = "top";
          position = "top";
          height = 30;
          modules-left = [ "hyprland/workspaces" ];
          modules-center = [ "clock" ];
          modules-right = [
            "cpu"
            "memory"
            "battery"
            "custom/power"
            "network"
          ];

          "hyprland/workspaces" = {
            format = "{name}";
            on-click = "activate";
          };

          clock = {
            format = "{:%a %b %d  %H:%M}";
            tooltip-format = "<tt>{calendar}</tt>";
            calendar = {
              mode = "month";
              weeks-pos = "left";
              format = {
                months = "<span color='#88c0d0'><b>{}</b></span>";
                weeks = "<span color='#a3be8c'><b>W{}</b></span>";
                weekdays = "<span color='#81a1c1'><b>{}</b></span>";
                today = "<span color='#bf616a'><b><u>{}</u></b></span>";
              };
            };
          };

          cpu = {
            format = "CPU {usage}%";
            interval = 5;
          };

          memory = {
            format = "MEM {}%";
            interval = 5;
          };

          battery = {
            format = "BAT {capacity}%";
            format-charging = "CHR {capacity}%";
            format-plugged = "PLG {capacity}%";
            interval = 30;
          };

          "custom/power" = {
            exec = "awk '{printf \"%.1fW\", $1/1000000}' /sys/class/power_supply/BAT1/power_now";
            interval = 5;
            format = "PWR {}";
          };

          network = {
            format-wifi = "WiFi {signalStrength}%";
            format-ethernet = "ETH";
            format-disconnected = "OFF";
            interval = 10;
          };
        };
      };

      style = ''
        * {
          font-family: monospace;
          font-size: 13px;
        }

        window#waybar {
          background-color: rgba(43, 48, 59, 0.9);
          color: #d8dee9;
        }

        #workspaces button {
          padding: 0 8px;
          color: #d8dee9;
          border-bottom: 2px solid transparent;
        }

        #workspaces button.active {
          color: #88c0d0;
          border-bottom: 2px solid #88c0d0;
        }

        #clock, #cpu, #memory, #battery, #custom-power, #network {
          padding: 0 10px;
        }

        #battery.charging {
          color: #a3be8c;
        }

        #battery.warning:not(.charging) {
          color: #ebcb8b;
        }

        #battery.critical:not(.charging) {
          color: #bf616a;
        }
      '';
    };

    # Mako notification daemon
    services.mako = {
      enable = true;
      settings = {
        default-timeout = 5000;
        border-radius = 6;
        background-color = "#2e3440";
        text-color = "#d8dee9";
        border-color = "#88c0d0";
      };
    };

    # hyprkeys alias for quick keybinding reference
    home.shellAliases.hyprkeys = ''
          echo "
      Hyprland Keybindings
      ────────────────────
      SUPER + Return     Terminal (alacritty)
      SUPER + D          App launcher (wofi)
      SUPER + Q          Kill window
      SUPER + F          Fullscreen
      SUPER + V          Toggle floating
      SUPER + M          Exit Hyprland

      SUPER + H/J/K/L    Focus left/down/up/right
      SUPER + Arrows     Focus left/down/up/right

      SUPER+SHIFT + H/J/K/L   Move window
      SUPER+SHIFT + Arrows     Move window

      SUPER + 1-9        Switch workspace
      SUPER+SHIFT + 1-9  Move window to workspace
      SUPER + Scroll     Cycle workspaces

      SUPER + LMB        Move window (drag)
      SUPER + RMB        Resize window (drag)

      Workspaces: 1=Terminal  2=Browser  3=Editor
      "
    '';
  };
}
