{ config, ...}:
{
  age.secrets."grafana-admin" = {
    file = ../../secrets/services/grafana/admin-pass.age;
    path = "/etc/grafana/admin-pass";
    owner = "grafana";
    group = "grafana";
  };

  users.groups.grafana.members = [ "irotnep" ];

  services.grafana = {
    enable = true;
    settings = {
      server = {
        http_addr = "127.0.0.1";
        http_port = 3000;
        domain = "grafana.irotnep.net";
      };
      security = {
        admin_password = "$__file{/etc/grafana/admin-pass}";
      };
    };
    provision = {
      enable = true;
      datasources.settings = {
        datasources = [
          {
            name = "Prometheus";
            type = "prometheus";
            access = "proxy";
            url = "http://localhost:${toString config.services.prometheus.port}";
          }
          {
            name = "Loki";
            type = "loki";
            access = "proxy";
            url = "http://localhost:${toString config.services.loki.configuration.server.http_listen_port}";
            jsonData = {
              timeout = 5*60;
              maxLines = config.services.loki.configuration.limits_config.max_entries_limit_per_query;
            };
          }
        ];
      };
    };

  };


  services.nginx.virtualHosts."grafana.irotnep.net" = {
   addSSL = true;
   enableACME = true;
   locations."/" = {
     proxyPass = "http://${toString config.services.grafana.settings.server.http_addr}:${toString config.services.grafana.settings.server.http_port}";
     proxyWebsockets = true;
     recommendedProxySettings = true;
    };
  };
  services.nginx.virtualHosts."grafana.irotn.ep" = {
    addSSL = false;
    enableACME= false;
       locations."/" = {
     proxyPass = "http://${toString config.services.grafana.settings.server.http_addr}:${toString config.services.grafana.settings.server.http_port}";
     proxyWebsockets = true;
     recommendedProxySettings = true;
    };
  };
}
