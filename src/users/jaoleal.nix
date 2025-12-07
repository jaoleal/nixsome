{
  pkgs,
  username,
  stateVersion,
  ...
}:
{
  home-manager.useGlobalPkgs = true;
  home-manager.useUserPackages = true;
  users.users.${username} = {
    name = username;
    isNormalUser = true;
    description = "${username}";
    hashedPassword = "$y$j9T$F8L9DbGkN22.hwMIXOEIb1$6TtjVOcJB9Tcadv/V.dlwYzbWMfJR6UV7ABdINvgwN8";
    extraGroups = [
      "wheel"
      "libvirtd"
    ];

    packages = with pkgs; [
      pkg-config
      git
      wget
      vim
      just
      usbutils
      curl
      direnv
      openssl
      clang
      vial
      git
      gnupg
      nixfmt-rfc-style
      nil
      nixd
      rustup
      proton-pass
      protonvpn-gui
      protonmail-desktop
      gnome-software
      gnome-extension-manager
      gnomeExtensions.blur-my-shell
      gnomeExtensions.proton-vpn-button
      gnomeExtensions.gsconnect
      gnomeExtensions.zed-search-provider
      gnomeExtensions.zen
      gnomeExtensions.x11-gestures
      gnomeExtensions.wtmb-window-thumbnails
      gnomeExtensions.wsp-windows-search-provider
      gnomeExtensions.wireless-hid
      gnomeExtensions.whoami-in-top-bar
      gnomeExtensions.wifi-qrcode
      gnomeExtensions.system-monitor
      gnomeExtensions.systemd-manager
      gnomeExtensions.caffeine
      gnomeExtensions.dash-to-panel
    ];
  };

  services.udev.packages = with pkgs; [ gnome-settings-daemon ];

  services.flatpak.enable = true;
  systemd.services.flatpak-repo = {
    wantedBy = [ "multi-user.target" ];
    path = [ pkgs.flatpak ];
    script = ''
      flatpak remote-add --if-not-exists flathub https://flathub.org/repo/flathub.flatpakrepo
      flatpak update
      flatpak install --or-update -y flathub com.ultimaker.cura
      flatpak install --or-update -y flathub com.discordapp.Discord
      flatpak install --or-update -y flathub org.signal.Signal
      flatpak install --or-update -y flathub org.blender.Blender
      flatpak install --or-update -y flathub net.codelogistics.webapps
      flatpak install --or-update -y flathub io.wasabiwallet.WasabiWallet
      flatpak install --or-update -y flathub org.torproject.torbrowser-launcher
    '';
  };

  home-manager.users.${username} = {
    home = {
      inherit username stateVersion; # Dont change

      homeDirectory = "/home/${username}";
      # Packages are defined in user packages.
      # packages = with pkgs; [];
      file = { };

      sessionVariables = {
        CARGO_BUILD_JOBS = 4;
        EDITOR = "zeditor --wait";
      };

    };

    dconf = {
      enable = true;
      settings."org/gnome/shell" = {
        disable-user-extensions = false;
        enabled-extensions = with pkgs.gnomeExtensions; [
          blur-my-shell.extensionUuid
          gsconnect.extensionUuid
          zed-search-provider.extensionUuid
          zen.extensionUuid
          x11-gestures.extensionUuid
          wtmb-window-thumbnails.extensionUuid
          wsp-windows-search-provider.extensionUuid
          wireless-hid.extensionUuid
          whoami-in-top-bar.extensionUuid
          wifi-qrcode.extensionUuid
          system-monitor.extensionUuid
          systemd-manager.extensionUuid
          caffeine.extensionUuid
          dash-to-panel.extensionUuid
          # pomodoro-timer.extensionUuid Add back when home-manager change to 25.05
        ];

        disabled-extensions = [ ];
      };
    };
    services = {
      gpg-agent = {
        enable = true;

        sshKeys = [ "17E5F552FCCEC23CD086C617298E5BD0BAF906BD" ];

        enableSshSupport = true;

        defaultCacheTtlSsh = 4000;

        defaultCacheTtl = 34560000;

        maxCacheTtl = 34560000;

        enableBashIntegration = true;

        enableScDaemon = true;

        grabKeyboardAndMouse = true;

        pinentryPackage = pkgs.pinentry-tty;

      };
    };

    programs = {
      helix = {
        enable = true;
        languages.language = [
          {
            name = "nix";
            auto-format = true;
            formatter.command = "${pkgs.nixfmt}/bin/nixfmt";
          }
          {
            name = "rust";
            auto-format = true;
          }
          {
            name = "toml";
            formatter = {
              command = "taplo";
              args = [
                "fmt"
                "-"
              ];
            };
            auto-format = false;
          }
          {
            name = "bash";
            formatter = {
              command = "shfmt";
            };
          }
        ];
      };

      direnv = {
        enable = true;

        nix-direnv.enable = true;

      };

      alacritty.enable = true;

      git = {
        enable = true;
        userEmail = "jgleal@protonmail.com";
        userName = "jaoleal";
        signing = {
          key = "0xA85033E37C1CB47E";
          signByDefault = true;
        };
      };

      zed-editor = {
        enable = true;
        extraPackages = with pkgs; [
          rustup
          nixd
          nixfmt-rfc-style
          bash-language-server
          shellcheck
          shfmt
          just
        ];

        mutableUserSettings = true;
        mutableUserKeymaps = true;
        mutableUserTasks = true;
        mutableUserDebug = true;

        # Names must match repos from https://github.com/zed-industries/extensions/tree/main/extensions
        extensions = [
          "nix"
          "basher"
          "just"
        ];

        # Core Zed configuration
        userSettings = {
          vim_mode = false;
          ui_font_size = 14;
          buffer_font_size = 14;
          soft_wrap = "preferred";
          format_on_save = true;

          telemetry = {
            metrics = false;
            devtools = false;
          };

          features = {
            copilot = true;
          };

          languages = {
            rust = {
              formatter = {
                command = "rustfmt";
              };
            };
            nix = {
              formatter = {
                command = "nixfmt";
              };
            };
            bash = {
              formatter = {
                command = "shfmt";
                args = [
                  "-i"
                  "2"
                  "-bn"
                  "-ci"
                ];
              };
            };
          };
        };

        # Example keybindings – optional
        userKeymaps = [
          {
            context = "Workspace";
            bindings = {
              "ctrl-shift-t" = "workspace::NewTerminal";
              "ctrl-b" = "project_panel::Toggle";
            };
          }
        ];

        # Example tasks – optional, but nice for Nix / Just workflows
        userTasks = [
          {
            label = "Nix fmt (project)";
            command = "nix";
            args = [
              "fmt"
              "$ZED_WORKTREE_ROOT"
            ];
          }
          {
            label = "Run default just task";
            command = "just";
            args = [ ];
          }
          {
            label = "List just recipes";
            command = "just";
            args = [ "--list" ];
          }
        ];

        # No debug configs by default, but you can add Rust debug profiles here later
        userDebug = [ ];
      };

      home-manager.enable = true;

      bash = {
        enable = true;

        bashrcExtra = ''
          export SSH_AUTH_SOCK=$(gpgconf --list-dirs agent-ssh-socket)
          gpgconf --launch gpg-agent
        '';
      };

      chromium = {
        enable = true;

        extensions = [
          { id = "ddkjiahejlhfcafbddmgiahcphecmpfh"; } # Ublock
          { id = "ghmbeldphafepmbegfdlkpapadhbakde"; } # Proton Pass
          { id = "mnjggcdmjocbbbhaepdhchncahnbgone"; } # Sponsor Block
          { id = "ncmflpbbagcnakkolfpcpogheckolnad"; } # Nostr Profiles
        ];
      };
    };
  };
}
