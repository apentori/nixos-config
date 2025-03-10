{ pkgs, ...}:
{
  systemd.services.docmost = {
    script = ''
      docker compose -f ${ ../files/docmost/docker-compose.yml} up
    '';
    wantedBy = ["default.target"];
    after=["docker.service" "docker.socket"];
    serviceConfig = {
      User="irotnep";
      Group="docker";
    };
    path = [ pkgs.docker ];
  };

  services.nginx.virtualHosts."docmost.irotnep.net" = {
   addSSL = true;
   enableACME = true;
   locations."/" = {
     proxyPass = "http://localhost:4000";
     proxyWebsockets = true;
     recommendedProxySettings = true;
    };
  };
}
