{ pkgs, secret, ... }:
{
  age.secrets."nextcloud-admin" = {
    file = ../secrets/services/nextcloud/admin.age;
    path = "/etc/nextcloud-admin-pass";
    owner = "nextcloud";
    group = "nextcloud";
  };

  systemd.tmpfiles.rules = [
    "d /data/nextcloud 0750 nextcloud nextcloud"
  ];

  users.groups.nextcloud.members = [ "irotnep" ];

  services.nextcloud = {
    enable = true;
    package = pkgs.nextcloud29;
    hostName = "nextcloud.irotnep.net";
    https = true;
    config.adminpassFile = "/etc/nextcloud-admin-pass";
    datadir = "/data/nextcloud";
  };
  services.nginx.virtualHosts."nextcloud.irotnep.net" = {
    forceSSL = true;
    enableACME = true;
  };

}
