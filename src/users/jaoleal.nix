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
      "networkmanager"
    ];

    packages = with pkgs; [
      git
      wget
      vim
      just
      usbutils
      curl
      direnv
      clang
      git
      gnupg
      proton-pass
      protonvpn-gui
      protonmail-desktop
    ];
  };
  services.flatpak.enable = true;

  # systemd.services.flatpak-repo = {
  #   wantedBy = [ "multi-user.target" ];
  #   path = [ pkgs.flatpak ];
  #   script = ''
  #     flatpak remote-add --if-not-exists flathub https://flathub.org/repo/flathub.flatpakrepo
  #     flatpak update
  #     flatpak install --or-update -y flathub com.ultimaker.cura
  #     flatpak install --or-update -y flathub com.discordapp.Discord
  #     flatpak install --or-update -y flathub org.signal.Signal
  #     flatpak install --or-update -y flathub org.blender.Blender
  #     flatpak install --or-update -y flathub net.codelogistics.webapps
  #     flatpak install --or-update -y flathub io.wasabiwallet.WasabiWallet
  #     flatpak install --or-update -y flathub org.torproject.torbrowser-launcher
  #   '';
  # };

  home-manager.users.${username} = {
    home = {
      inherit username stateVersion; # Dont change

      homeDirectory = "/home/${username}";
      # Packages are defined in user packages.
      # packages = with pkgs; [];
      file = { };

      sessionVariables = {
        CARGO_BUILD_JOBS = "$(nproc)";
        EDITOR = "zeditor --wait";

      };
      shellAliases = {
        z = "zeditor";
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

        pinentry.package = pkgs.pinentry-tty;

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
        enableBashIntegration = true;
        nix-direnv.enable = true;
      };

      alacritty.enable = true;

      git = {
        enable = true;
        signing = {
          key = "0xA85033E37C1CB47E";
          signByDefault = true;
        };
        settings = {
          user = {
            email = "jgleal@protonmail.com";
            name = username;
          };

          core.excludesFiles = [ ".envrc" ];
        };
      };

      zed-editor = {
        enable = true;
        extraPackages = with pkgs; [
          rustup
          nil
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
          "just-ls"
        ];

        # Core Zed configuration
        userSettings = {
          vim_mode = false;
          ui_font_size = 14;
          buffer_font_size = 14;
          format_on_save = "on";

          telemetry.metrics = false;
        };
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
