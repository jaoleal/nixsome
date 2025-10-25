{ config, lib, pkgs, ... }:
{
  services.dashy = {
    enable = true;
    virtualHost = {
      enableNginx = true;
      domain = "nixos-3.snake-mooneye.ts.net";
    };

    settings = {
      pageInfo = {
        title = "Backend";
        description = "Self-hosted services on backend";
        navLinks = [
          { title = "NixOS Options"; path = "https://search.nixos.org/options"; icon = "si:nixos"; }
          { title = "nixpkgs";       path = "https://github.com/NixOS/nixpkgs"; icon = "si:github"; }
          { title = "Repo: nixsome"; path = "https://github.com/jaoleal/nixsome"; icon = "si:github"; }
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
            { name = "Grafana";     icon = "si:grafana";     url = "http://backend.home.arpa:3000"; }
            { name = "Prometheus";  icon = "si:prometheus";  url = "http://backend.home.arpa:9090"; }
            { name = "Loki";        icon = "si:grafana";     url = "http://backend.home.arpa:3100"; }
            { name = "Portainer";   icon = "si:portainer";   url = "http://backend.home.arpa:9000"; }
          ];
        }
        {
          name = "Storage & Media";
          icon = "fas fa-database";
          items = [
            { name = "Nextcloud";   icon = "si:nextcloud";   url = "http://backend.home.arpa:8081"; }
            { name = "Jellyfin";    icon = "si:jellyfin";    url = "http://backend.home.arpa:8096"; }
            { name = "qBittorrent"; icon = "si:qbittorrent"; url = "http://backend.home.arpa:8082"; }
          ];
        }
        {
          name = "Home & Network";
          icon = "fas fa-network-wired";
          items = [
            { name = "Home Assistant"; icon = "si:homeassistant"; url = "http://backend.home.arpa:8123"; }
            { name = "Pi-hole";        icon = "si:pihole";        url = "http://backend.home.arpa/admin"; }
            { name = "AdGuard Home";   icon = "si:adguard";       url = "http://backend.home.arpa:3001"; }
            { name = "UniFi Network";  icon = "si:ubiquiti";      url = "https://backend.home.arpa:8443"; }
          ];
        }
        {
          name = "Dev & Docs";
          icon = "fas fa-code";
          items = [
            { name = "GitHub";           icon = "si:github";  url = "https://github.com"; }
            { name = "NixOS Manual";     icon = "si:nixos";   url = "https://nixos.org/manual/nixos/stable/"; }
            { name = "NixOS Module Search"; icon = "si:nixos"; url = "https://search.nixos.org/options"; }
          ];
        }
      ];
    };
  };

  # Open HTTP/HTTPS if you proxy with TLS
  networking.firewall.allowedTCPPorts = [ 80 443 ];

  # Optional: tweak nginx vhost further using the same domain
  # services.nginx.virtualHosts."${config.services.dashy.virtualHost.domain}" = {
  #   forceSSL = true;
  #   enableACME = true;
  #   locations."/" = { extraConfig = "proxy_read_timeout 120s;"; };
  # };
  # security.acme = {
  #   acceptTerms = true;
  #   defaults.email = "you@example.com";
  # };
}