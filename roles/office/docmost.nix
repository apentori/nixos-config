{ pkgs, secret, ...}:
{
  age.secrets.docmost = {
    file = ../../secrets/services/docmost/env.age;
    path = "/data/docmost/docmost.env";
    owner = "irotnep";
    group = "docker";
    mode = "770";
    symlink = false;
  };

 systemd.tmpfiles.rules = [
    "d /data/docmost 0760 irotnep docker"
    "d /data/docmost/app 0760 irotnep docker"
    "d /data/docmost/db 0760 irotnep docker"
    "d /data/docmost/redis 0760 irotnep docker"
  ];



  systemd.services.docmost = {
    script = ''
      docker compose -f ${ ../../files/docmost/docker-compose.yml} up
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
