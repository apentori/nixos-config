{ pkgs, secret, ... }:
{
  age.secrets."paperless-admin" = {
    file = ../secrets/services/paperless/admin.age;
    path = "/etc/paperless-admin-pass";
    owner = "paperless";
    group = "paperless";
  };

  systemd.tmpfiles.rules = [
    "d /data/paperless 0750 paperless paperless"
  ];

  users.groups.paperless.members = [ "irotnep" ];

  services.paperless = {
    enable = true;
    passwordFile = "/etc/paperless-admin-pass";
    dataDir = "/data/paperless";
  };

  services.nginx.virtualHosts."paperless.irotnep.net" = {
   addSSL = true;
   enableACME = true;
   locations."/" = {
     proxyPass = "http://localhost:28981";
     proxyWebsockets = true;
     recommendedProxySettings = true;
    };
  };

}
