{
  config,
  lib,
  pkgs,
  ...
}:
{
    services.prometheus.exporters.systemd = {
    enable = true;
    listenAddress = "127.0.0.1";
    port = 9558;
    # Useful extra collector for restart counters
    extraFlags = [ "--systemd.collector.enable-restart-count" ];
  };

  # If Prometheus runs on this host, add a scrape job for the exporter
  services.prometheus = {
    enable = lib.mkDefault true;
    scrapeConfigs = [
      {
        job_name = "systemd";
        static_configs = [
          { targets = [ "127.0.0.1:${toString config.services.prometheus.exporters.systemd.port}" ]; }
        ];
      }
    ];
  };
  # Dashy as a native NixOS service (static build served by Nginx)
  services.dashy = {
    enable = true;
    virtualHost = {
      enableNginx = true;
      domain = "nixos-3"; # change to your LAN DNS / domain
    };

    # Dashy settings will be embedded at build time (static build)
    # Note: status checks + UI write/trigger rebuilds are disabled in static mode.
    settings = {
      pageInfo = {
        title = "Backend";
        description = "Self-hosted services on backend";

        # Prefer local NixOS docs (served below at /docs/)
        navLinks = [
          {
            title = "NixOS Manual (local)";
            path = "http://nixos-3/docs/";
            icon = "si:nixos";
          }
          {
            title = "NixOS Options (local)";
            path = "http://nixos-3/docs/options.html";
            icon = "si:nixos";
          }
          {
            title = "nixpkgs";
            path = "https://github.com/NixOS/nixpkgs";
            icon = "si:github";
          }
          {
            title = "Repo: nixsome";
            path = "https://github.com/jaoleal/nixsome";
            icon = "si:github";
          }
        ];
      };

      appConfig = {
        theme = "nord";
        layout = "auto";
        iconSize = "medium";
        language = "en";
        externalLinksTarget = "newtab";
        statusCheck = false;
      };

      sections = [
        {
          name = "Admin & Monitoring";
          icon = "fas fa-toolbox";
          items = [
            {
              name = "Grafana";
              icon = "si:grafana";
              url = "http://nixos-3:3000";
            }
            {
              name = "Prometheus";
              icon = "si:prometheus";
              url = "http://nixos-3:9090";
            }
            {
              name = "Loki";
              icon = "si:grafana";
              url = "http://nixos-3:3100";
            }
            {
              name = "Portainer";
              icon = "si:portainer";
              url = "http://nixos-3:9000";
            }
          ];
        }
        {
          name = "Storage & Media";
          icon = "fas fa-database";
          items = [
            {
              name = "Nextcloud";
              icon = "si:nextcloud";
              url = "http://nixos-3:8081";
            }
            {
              name = "Jellyfin";
              icon = "si:jellyfin";
              url = "http://nixos-3:8096";
            }
            {
              name = "qBittorrent";
              icon = "si:qbittorrent";
              url = "http://nixos-3:8082";
            }
          ];
        }
        {
          name = "Home & Network";
          icon = "fas fa-network-wired";
          items = [
            {
              name = "Home Assistant";
              icon = "si:homeassistant";
              url = "http://nixos-3:8123";
            }
            {
              name = "Pi-hole";
              icon = "si:pihole";
              url = "http://nixos-3/admin";
            }
            {
              name = "AdGuard Home";
              icon = "si:adguard";
              url = "http://nixos-3:3001";
            }
            {
              name = "UniFi Network";
              icon = "si:ubiquiti";
              url = "https://nixos-3:8443";
            }
          ];
        }
        {
          name = "Remote & Access";
          icon = "fas fa-plug";
          items = [
            # Sunshine's Web UI (usually HTTPS with a self-signed cert)
            {
              name = "Sunshine";
              icon = "si:sun";
              url = "https://nixos-3:47990";
            }

            {
              name = "Tailscale Admin";
              icon = "si:tailscale";
              url = "https://login.tailscale.com/admin/machines";
            }
          ];
        }
        {
          name = "Dev & Docs";
          icon = "fas fa-code";
          items = [
            {
              name = "GitHub";
              icon = "si:github";
              url = "https://github.com";
            }
            {
              name = "NixOS Manual (local)";
              icon = "si:nixos";
              url = "http://nixos-3/docs/";
            }
            {
              name = "Options (local)";
              icon = "si:nixos";
              url = "http://nixos-3/docs/options.html";
            }
          ];
        }
      ];
    };
  };

  # Serve the local NixOS manual via the same vhost under /docs/
  # This avoids browser restrictions on file:// links from http(s) pages.
  services.nginx.virtualHosts."${config.services.dashy.virtualHost.domain}" = {
    locations."/docs/".alias = "/run/current-system/sw/share/doc/nixos/"; # contains index.html, options.html, release-notes.html
    locations."/docs/".index = "index.html";
  };

  # Open HTTP/HTTPS if you proxy with TLS
  networking.firewall.allowedTCPPorts = [
    80
    443
  ];
}
