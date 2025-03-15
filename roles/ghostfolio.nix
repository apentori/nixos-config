{ pkgs, lib, config, ...}:
{
    age.secrets."ghostfolio-admin" = {
    file = ../secrets/services/ghostfolio/env.age;
    path = "/data/ghostfolio/.env";
    owner = "irotnep";
    group = "docker";
  };

   systemd.tmpfiles.rules = [
    "d /data/ghostfolio 0750 irotnep docker"
    "d /data/ghostfolio/data 0750 irotnep docker"
  ];
  systemd.services.ghostfolio = {
    script = ''
      docker compose -f ${ ../files/ghostfolio/docker-compose.yml} up
    '';
    wantedBy = ["default.target"];
    after=["docker.service" "docker.socket"];
    serviceConfig = {
      User="irotnep";
      Group="docker";
    };
    path = [ pkgs.docker ];
  };


    services.nginx.virtualHosts."ghostfolio.irotnep.net" = {
    forceSSL = true;
    enableACME = true;
    locations."/" = {
     proxyPass = "http://127.0.0.1:3333";
     proxyWebsockets = true;
     recommendedProxySettings = true;
    };
  };

}
