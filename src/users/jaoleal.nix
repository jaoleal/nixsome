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
    #initialPassword = "123";
	hashedPassword = "$y$j9T$F8L9DbGkN22.hwMIXOEIb1$6TtjVOcJB9Tcadv/V.dlwYzbWMfJR6UV7ABdINvgwN8";    
	extraGroups = [
      "networkmanager"
      "wheel"
      "libvirtd"
    ];

    # User packages are specified via home-manager
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
      #vial
      git
      zed-editor
      gnupg
      nixfmt-rfc-style
      nil
      rustup
    ];
  };

  home-manager.users.${username} = {
    home = {
      inherit username stateVersion; # Dont change

      homeDirectory = "/home/${username}";
      # Packages are defined in user packages.
      # packages = with pkgs; [];
      file = { };

      sessionVariables = { };

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

        pinentryPackage = pkgs.pinentry-gnome3;

      };
    };

	  dconf = {
    enable = true;
    settings."org/gnome/desktop/interface".color-scheme = "prefer-dark";
  };

    programs = {

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

      home-manager.enable = true;

      bash = {
        enable = true;

        bashrcExtra = ''
            export SSH_AUTH_SOCK=$(gpgconf --list-dirs agent-ssh-socket)
           gpgconf --launch gpg-agent
           export ZED_ALLOW_EMULATED_GPU=1
           export DISPLAY=$(route.exe print | grep 0.0.0.0 | head -1 | awk '{print $4}'):0.00 
           export LIBGL_ALWAYS_INDIRECT=1
'';

	shellAliases = {
	
	zed = ''WAYLAND_DISPLAY="" zeditor'';
};


      };
      chromium = {
        enable = false;

        extensions = [
          { id = "ddkjiahejlhfcafbddmgiahcphecmpfh"; } # Ublock
          { id = "ghmbeldphafepmbegfdlkpapadhbakde"; } # Proton Pass
          { id = "mnjggcdmjocbbbhaepdhchncahnbgone"; } # Sponsor Block
          { id = "ncmflpbbagcnakkolfpcpogheckolnad"; } # Nostr Profiles
        ];
      };
      zed-editor = {
        enable = true;

        package = pkgs.zed-editor;

        userSettings = {
          buffer_font_family = "Source Code Pro";

          restore_on_startup = "last_workspace";

          autoscroll_on_clicks = true;

          load_direnv = "direct";

          base_keymap = "VSCode";

          theme = {
            mode = "system";

            dark = "Gruvbox Dark Soft";

            light = "Gruvbox Material";

          };
          terminal = {
            copy_on_select = true;

            font_family = "UbuntuMono Nerd Font Mono";

          };
          current_line_highlight = "line";

          inline_completions_disabled_in = {
            disabled_in = [
              "comment"
              "string"
            ];

          };
          autosave = {
            after_delay = {
              milliseconds = 1000;

            };
          };

          scrollbar = {
            show = "auto";

            cursors = false;

            axes = {
              horizontal = true;

              vertical = true;

            };
          };
          languages = {
            Nix = {
              language_servers = [
                "nil"
                "!nixd"
              ];

              formatter = {
                external = {
                  command = "nixfmt";
                };
              };
            };
          };

          ssh_connections = [
            {
              host = "sv";
              projects = [ { paths = [ "~/Work/floresta" ]; } ];
            }
          ];

          lsp = {
            rust-analyzer = {
              binary = {
                path = "${pkgs.rustup}/bin/rust-analyzer";
              };
            };
            nil = {
              binary = {
                path = "${pkgs.nil}/bin/nil";
              };
            };
          };
        };
      };
    };
  };
}
