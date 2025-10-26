{ config, pkgs, secret, ...}:
let
  domain = "headscale.irotnep.net";
  port = 8080;
in {
  services = {
    headscale = {
      enable = true;
      address = "0.0.0.0";
      port = 8080;
      settings = {
        dns = {
          magic_dns= true;
          base_domain = "irotn.ep";
          extra_records = [
            { name = "grafana.irotn.ep"; type= "A"; value = "100.64.0.5"; }
            { name = "habit.irotn.ep";   type= "A"; value = "100.64.0.5"; }
          ];
        };
        server_url = "https://${domain}";
        logtail.enable = false;
      };
    };
    nginx.virtualHosts.${domain} = {
      addSSL = true;
      enableACME=true;
      locations."/" = {
        proxyPass = "http://localhost:8080";
        proxyWebsockets = true;
        recommendedProxySettings = true;
      };
    };
  };
  users.users.irotnep.extraGroups = [ "headscale" ];

  environment.systemPackages = with pkgs; [ headscale ];
}
