{ pkgs, inputs, ... }:
{

  users.users.irotnep.extraGroups = [ "jellyfin" ];

  environment.systemPackages = [
    pkgs.jellyfin
    pkgs.jellyfin-web
    pkgs.jellyfin-ffmpeg
    pkgs.yt-dlp
  ];
 systemd.tmpfiles.rules = [
    "d /data/jellyfin 0750 jellyfin jellyfin"
    "d /data/jellyfin/media/musics 760 jellyfin jellyfin"
    "d /data/jellyfin/media/series 760 jellyfin jellyfin"
    "d /data/jellyfin/media/movies 760 jellyfin jellyfin"
    "d /data/jellyfin/media/books 760 jellyfin jellyfin"
  ];

  services.jellyfin = {
    enable = true;
    openFirewall = true;
    dataDir = "/data/jellyfin";
  };

  services.nginx.virtualHosts."jellyfin.irotnep.net" = {
    forceSSL = true;
    enableACME = true;
    locations."/" = {
     proxyPass = "http://127.0.0.1:8096";
     proxyWebsockets = true;
     recommendedProxySettings = true;
    };
  };
}
