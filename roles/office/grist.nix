{ pkgs, secret, ...}:
{
  systemd.tmpfiles.rules = [
    "d /data/grist 0760 irotnep docker"
  ];

  age.secrets.grist = {
    file = ../../secrets/services/grist/env.age;
    path = "/data/grist/grist.env";
    owner = "irotnep";
    group = "docker";
    mode = "770";
    symlink = false;
  };

  age.secrets.grist-auth = {
    file = ../../secrets/services/grist/auth.age;
    path = "/etc/nginx/grist.auth";
    owner = "nginx";
    group = "nginx";
    mode = "770";
    symlink = false;
  };



  systemd.services.grist = {
    script = ''
      docker compose -f ${ ../../files/grist/docker-compose.yml} up
    '';
    wantedBy = ["default.target"];
    after=["docker.service" "docker.socket"];
    serviceConfig = {
      User="irotnep";
      Group="docker";
    };
    path = [ pkgs.docker ];
  };

  services.nginx.virtualHosts."grist.irotnep.net" = {
   addSSL = true;
   enableACME = true;
   basicAuthFile= "/etc/nginx/grist.auth";
   locations."/" = {
     proxyPass = "http://localhost:8484";
     proxyWebsockets = true;
     recommendedProxySettings = true;
    };
  };
}
