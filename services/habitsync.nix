{ config, lib, ...}:
let
  cfg = config.services.habitsync;
in {
  options.services.habitsync = with lib; {
    enable = mkEnableOption (lib.mdDoc "HabitSync");
    image = mkOption {
      type = types.str;
      default = "ghcr.io/jofoerster/habitsync";
      description = "Name of HabitSync image";
    };
    tag = mkOption {
      type = types.str;
      default = "latest";
      description = "tag of HabitSync image";
    };
    port = mkOption {
      type = types.port;
      default = 6842;
    };
    baseUrl = mkOption {
      type = types.str;
      default = "http://habit.irotn.ep";
    };
    jwtSecretPath = mkOption {
      type = types.str;
      description = "Path of the env file containing the JWT token for Frontend session";
    };
    basicAuthPath = mkOption {
      type = types.str;
      description = "Path of the env file containing the basic auth creds";
    };
    dbVolumePath = mkOption {
      type = types.str;
      description = "Path of volume for database";
      default = "/data/habitsync/db";
    };
  };

  config = lib.mkIf cfg.enable {
    virtualisation.oci-containers.containers.habitsync = {
      image = "${cfg.image}:${cfg.tag}";
      environment = {
        BASE_URL = "${cfg.baseUrl}";
      };
      volumes = [
        "${cfg.dbVolumePath}:/data/"
      ];
      environmentFiles = [
        (/. + "${cfg.jwtSecretPath}")
        (/. + "${cfg.basicAuthPath}")
      ];
      ports = ["${toString cfg.port}:${toString cfg.port}"];
      extraOptions = ["--network=host"];
    };
  };
}
