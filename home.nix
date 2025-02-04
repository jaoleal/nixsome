{ pkgs, ... }:

{
  home = {
    username = "jaoleal";
    homeDirectory = "/home/jaoleal";
    stateVersion = "24.05"; # Dont change.
    packages = with pkgs; [ git zed-editor gnupg nixpkgs-fmt nil ];
    file = { };
    sessionVariables = { };
  };
  services = {
    gpg-agent = {
      enable = true;
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
  fonts.packages = with pkgs; [
    (nerdfonts.override { fonts = [ "FiraCode" "DroidSansMono" ]; })
    fira-code
    droid-sans-mono
  ];
  programs = {
    git = {
      enable = true;
      userEmail = "jgleal@protonmail.com";
      userName = "jaoleal";
      signing = {
        key = "0x9AE892D482B588FA";
        signByDefault = true;
      };
    };
    gpg = {
      enable = true;
      scdaemonSettings = {
        disable-ccid = true;
      };
    };
    home-manager.enable = true;
    bash.enable = true;
    bash.bashrcExtra = ''
      	export SSH_AUTH_SOCK=$(gpgconf --list-dirs agent-ssh-socket)
      	gpgconf --launch gpg-agent
      	echo Haro '';
    chromium = {
      enable = true;
      extensions = [
        { id = "ddkjiahejlhfcafbddmgiahcphecmpfh"; } #Ublock
        { id = "ghmbeldphafepmbegfdlkpapadhbakde"; } #Proton Pass
        { id = "mnjggcdmjocbbbhaepdhchncahnbgone"; } #Sponsor Block
        { id = "ncmflpbbagcnakkolfpcpogheckolnad"; } #Nostr Profiles
      ];
    };
    zed-editor = {
      enable = true;
      package = pkgs.zed-editor;
      userSettings = {
        buffer_font_family = "DroidSansMono";
        scrollbar = {
          show = "never";
        };
        languages = {
          Nix = {
            language_servers = [
              "nil"
              "!nixd"
            ];
            formatter = {
              external =
                {
                  command = "nixpkgs-fmt";
                };
            };
          };
        };

        lsp = {
          rust-analyzer = {
            binary = {
              path = "/run/current-system/sw/bin/rust-analyzer";
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
