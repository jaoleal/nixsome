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

      home-manager.enable = true;

      bash = {
        enable = true;

        bashrcExtra = ''
          export SSH_AUTH_SOCK=$(gpgconf --list-dirs agent-ssh-socket)
          gpgconf --launch gpg-agent
        '';
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
    };
  };
}
