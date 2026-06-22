{ pkgs, secret, ...}:
{
  age.secrets."restic-password" = {
    file = ../../secrets/services/restic/http-password.age;
    path = "/etc/restic/password";
    owner = "restic";
  };

  services.restic.server = {
    enable = true;
    listenAddress = "0.0.0.0:8000";
    dataDir = "/data/backup";
    htpasswd-file = "/etc/restic/password";
    prometheus = true;
  };
}
