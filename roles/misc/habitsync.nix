{ config, secret, ... }:
{
  imports = [
    ../../services/habitsync.nix
  ];
  age.secrets."habitsync-jwt-secret" = {
    file = ../../secrets/services/habitsync/jwt-secret.age;
    path = "/data/habitsync/jwt-secret.env";
  };
  age.secrets."habitsync-basic-auth" = {
    file = ../../secrets/services/habitsync/basic-auth.age;
    path = "/data/habitsync/basic-auth.env";
  };

  systemd.tmpfiles.rules = [
    "d /data/habitsync/data 0750 6842 docker"
  ];

  services.habitsync = {
    enable = true;
    baseUrl = "http://habit.irotn.ep";
    jwtSecretPath = "/data/habitsync/jwt-secret.env";
    basicAuthPath = "/data/habitsync/basic-auth.env";
    dbVolumePath = "/data/habitsync/data";
  };

  services.nginx.virtualHosts."habit.irotn.ep" = {
    addSSL = false;
    enableACME= false;
       locations."/" = {
     proxyPass = "http://127.0.0.1:${toString config.services.habitsync.port}";
     proxyWebsockets = true;
     recommendedProxySettings = true;
    };
  };
}
