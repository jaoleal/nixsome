{ lib, unstablePkgs, ... }:
let
  pkgs = unstablePkgs;
in
{
  containers."bitcoin" = {
    autoStart = true;
    privateNetwork = true;
    # localAddress = "192.168.100.11"; change for the one tailnet


    # Bind a host-provided decrypted secret file into the container run-time.
    # The host module (modules/sops-host.nix) will decrypt into /var/lib/secrets/bitcoin.conf
    # and the container will see it at /run/secrets/bitcoin.conf (read-only).
    bindMounts = {
      "bitcoinconf" = {
        mountPoint = "/var/lib/secrets/bitcoin.conf";
        hostPath = "/run/secrets/bitcoin.conf";
      };
      "tailscale-authkey" = {
        mountPoint = "/var/lib/secrets/tailscale-authkey";
        hostPath = "/run/secrets/tailscale-authkey";
      };
    };

    config =
      { pkgs, ... }:
      {
        imports = [ ];

        # make sure some useful packages (for debugging) are available inside container
        environment.systemPackages = with pkgs; [
          tailscale
          bitcoind
          vim
        ];

        # ensure /run/secrets exists and is secure
        systemd.tmpfiles.rules = [
          "d /run/secrets 0700 root root -"
        ];

        # A oneshot inside the container that copies the bound secret (which the host provides)
        # to a proper /etc/bitcoin/bitcoin.conf with correct perms before bitcoind starts.
        systemd.services.render-bitcoin-conf = {
          description = "Render bitcoin.conf from /run/secrets/bitcoin.conf";
          wantedBy = [ "multi-user.target" ];
          serviceConfig = {
            Type = "oneshot";
            RemainAfterExit = "yes";
          };
          script = ''
            if [ ! -f /run/secrets/bitcoin.conf ]; then
              echo "ERROR: /run/secrets/bitcoin.conf not present" >&2
              exit 1
            fi
            mkdir -p /etc/bitcoin
            # /run/secrets/bitcoin.conf is expected to be a full bitcoin.conf (rpcauth or rpcuser/rpcpassword)
            cat /run/secrets/bitcoin.conf > /etc/bitcoin/bitcoin.conf
            chown root:root /etc/bitcoin/bitcoin.conf
            chmod 0600 /etc/bitcoin/bitcoin.conf
          '';
        };

        # Tailscale client inside the container
        services.tailscale = {
          enable = true;
          # the module supports authKeyFile; we point it to the bound file
          authKeyFile = "/run/secrets/tailscale-authkey";
          extraUpFlags = [ "--ssh" ];
          openFirewall = false;
        };

        # Bitcoind module configuration (the module will create a unit bitcoind-mainnet.service)
        services.bitcoind."mainnet" = {
          enable = true;
          dataDir = "/var/lib/bitcoin/mainnet";
          extraConfig = ''
            rpcallowip=10.64.0.0/10
          '';
        };

        # Ensure bitcoind waits for the config to be rendered
        systemd.services."bitcoind-mainnet" = {
          after = [ "render-bitcoin-conf.service" ];
          requires = [ "render-bitcoin-conf.service" ];
        };
      };
  };

}
