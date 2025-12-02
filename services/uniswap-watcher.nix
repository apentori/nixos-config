{ config, lib, ...}:
let
  cfg = config.services.uniswap-watcher;
in {
  options.services.uniswap-watcher = with lib; {
    enable = mkEnableOption (lib.mdDoc "UniswapWatcher");
    image = mkOption {
      type = types.str;
      default = "ghcr.io/apentori/uniswap-watcher";
      description = "Name of Uniswap Watcher image";
    };
    tag = mkOption {
      type = types.str;
      default = "latest";
      description = "Tag of UniswapWatcher image";
    };
    pathSecretApiKey = mkOption {
      type = types.str;
      default = "/etc/uniswap-watcher/api-key.env";
      description = "Path to the environment file for API Key";
    };
    pathSecretDatabaseSecret = mkOption {
      type = types.str;
      default = "/etc/uniswap-watcher/database.env";
      description = "Path to the environment file for Database Password";
    };
  };
  config = lib.mkIf cfg.enable {
    environment.etc."uniswap-watcher/config.yaml" = {
      source = ../files/uniswap-watcher/config.yml;
    };
    virtualisation.oci-containers.containers.uniswap-watcher = {
      image = "${cfg.image}:${cfg.tag}";
      serviceName = "uniswap-watcher";
      hostname = "uniswap-watcher";
      environmentFiles = [
        (/. + "${cfg.pathSecretApiKey}")
        (/. + "${cfg.pathSecretDatabaseSecret}")
      ];
      volumes = [
        "/etc/uniswap-watcher/config.yaml:/app/config.yaml"
      ];
      extraOptions = ["--network=host"];
    };
  };
}
