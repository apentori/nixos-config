{ pkgs, secret, ... }:
{
  age.secrets."nextcloud-admin" = {
    file = ../secrets/services/nextcloud/admin;
    path = "/etc/nextcloud-admin-pass";
  };

  services.nextcloud = {
    enable = true;
    package = pkgs.nextcloud28;
    hostName = "localhost";
    config.adminpassFile = "/etc/nextcloud-admin-pass";
    datadir = "/data/nextcloud";
  };
}
