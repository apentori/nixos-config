{ pkgs, secret, ... }:
{
  age.secrets."nextcloud-admin" = {
    file = ../secrets/services/nextcloud/admin.age;
    path = "/etc/nextcloud-admin-pass";
    owner = "nextcloud";
    group = "nextcloud";
  };

  services.nextcloud = {
    enable = true;
    package = pkgs.nextcloud28;
    hostName = "nextcloud.irotnep.net";
    config.adminpassFile = "/etc/nextcloud-admin-pass";
  };
  services.nginx.virtualHosts."nextcloud.irotnep.net" = {
    forceSSL = true;
    enableACME = true;
  };

}
