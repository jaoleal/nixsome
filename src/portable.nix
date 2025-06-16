{
  pkgs,
  username,
  stateVersion,
config,
  ...
}:
{
home = {
  inherit username stateVersion; # Dont change

  sessionPath = [

  "$HOME/.nix-profile/bin"

  "/nix/var/nix/profiles/default/bin"

];
      homeDirectory = "/home/${username}";
      # Packages are defined in user packages.
         packages = with pkgs; [
           git
      wget
      vim
      just
      usbutils
      curl
      direnv
      git
      gnupg
    ];
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
        extraConfig = ''
        allow-loopback-pinentry
        '';
        pinentry.package = pkgs.pinentry-curses;

      };
    };

    dconf = {
    enable = true;
    settings."org/gnome/desktop/interface".color-scheme = "prefer-dark";
  };
  nix = {

    package = pkgs.nix;

    settings.experimental-features = [ "nix-command" "flakes" ];

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

  extraConfig = {
    gpg = {
      program = "${pkgs.gnupg}/bin/gpg";
    };
  };
};

      home-manager.enable = true;

      bash = {
        enable = true;

        bashrcExtra = ''
           export GPG_TTY=$(tty)
           export SSH_AUTH_SOCK=$(gpgconf --list-dirs agent-ssh-socket)
           gpgconf --launch gpg-agent
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
}
