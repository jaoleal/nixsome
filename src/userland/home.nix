{ config, pkgs, ... }:
{

  home = {
    username = "jaoleal";

    homeDirectory = "/home/jaoleal";

    stateVersion = "24.05"; # Dont change

    packages = with pkgs; [
      wget
      vim
      nixd
      rustup
      pkg-config
      openssl
      clang
      vial
      git
      zed-editor
      gnupg
      nixfmt-rfc-style
      nil
    ];

    file = { };

    sessionVariables = { };

  };

  xsession = {
    enable = true;
    windowManager = {
      command = "…";
    };
  };

  programs = {

    direnv = {
      enable = true;

      nix-direnv.enable = true;

    };

    waybar.enable = true;

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

    gpg = {
      enable = true;
      scdaemonSettings = {
        disable-ccid = true;
      };
    };

    bash = {
      enable = true;
      bashrcExtra = ''
        	export SSH_AUTH_SOCK=$(gpgconf --list-dirs agent-ssh-socket)
        	gpgconf --launch gpg-agent
         # Start Niri if we're on tty1
         if [ -z "$DISPLAY" ] && [ "$(tty)" = "/dev/tty1" ]; then
           exec niri
         fi
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
