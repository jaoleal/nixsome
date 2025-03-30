{ pkgs, ... }:

{
  home = {
    username = "jaoleal";
    homeDirectory = "/home/jaoleal";
    stateVersion = "24.05"; # Dont change.
    packages = with pkgs; [ git zed-editor gnupg nixfmt-rfc-style nil ];
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

  programs = {
    direnv = {
      enable = true;
      nix-direnv.enable = true;
    };
    git = {
      enable = true;
      userEmail = "jgleal@protonmail.com";
      userName = "jaoleal";
      signing = {
        key = "0xA85033E37C1CB47E";
        signByDefault = true;
      };
    };
    gpg = {
      enable = true;
      scdaemonSettings = {
        disable-ccid = true;
      };
    };
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
    zed-editor =
      {
        enable = true;
        package = pkgs.zed-editor;
        userSettings =
          {
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
              disabled_in = [ "comment" "string" ];
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
                  external =
                    {
                      command = "nixfmt";
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
