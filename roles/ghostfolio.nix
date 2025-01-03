{ pkgs, lib, config, ...}:
{
  # Application
  virtualisation.oci-containers.containers."ghostfolio-app" = {
    image = "ghostfolio/ghostfolio:latest";
    hostname = "ghostfolio";
    ports = [ "3333:3333"];
    environment = {
      ACCESS_TOKEN_SALT = "acsaceccaceveve";
      COMPOSE_PROJECT_NAME = "ghostfolio-development";
      DATABASE_URL = "postgresql://postgres:Th1s1sAPgslGhostfolioPwd@postgres:5432/ghostfolio-db?connect_timeout=300&sslmode=prefer";
      JWT_SECRET_KEY = "acasclacsj236615ewce";
      POSTGRES_DB = "ghostfolio-db";
      POSTGRES_PASSWORD = "Th1s1sAPgslGhostfolioPwd";
      POSTGRES_USER = "postgres";
      REDIS_HOST = "redis";
      REDIS_PASSWORD = "12345pass67890word";
      REDIS_PORT = "6379";
    };
    dependsOn = [
      "ghostfolio-postgres"
      "ghostfolio-redis"
    ];
    #environmentFile = [ /etc/ghostfolio/.env ];
    log-driver = "journald";
    extraOptions = [
      "--health-cmd=curl -f http://localhost:3333/api/v1/health"
      "--health-interval=10s"
      "--health-retries=5"
      "--health-timeout=5s"
      "--network-alias=ghostfolio"
      "--network=ghostfolio_default"
    ];
  };

  systemd.services."docker-ghostfolio-ghostfolio" = {
    serviceConfig = {
      Restart = lib.mkOverride 90 "no";
    };
    after = [ "docker-network-ghostfolio_default.service" ];
    requires = [ "docker-network-ghostfolio_default.service" ];
    partOf = [ "docker-compose-ghostfolio-root.target" ];
    wantedBy = [ "docker-compose-ghostfolio-root.target" ];
  };
  virtualisation.oci-containers.containers."ghostfolio-postgres" = {
    image = "postgres:15";
    environment = {
      ACCESS_TOKEN_SALT = "acsaceccaceveve";
      COMPOSE_PROJECT_NAME = "ghostfolio-development";
      DATABASE_URL = "postgresql://postgres:Th1s1sAPgslGhostfolioPwd@postgres:5432/ghostfolio-db?connect_timeout=300&sslmode=prefer";
      JWT_SECRET_KEY = "acasclacsj236615ewce";
      POSTGRES_DB = "ghostfolio-db";
      POSTGRES_PASSWORD = "Th1s1sAPgslGhostfolioPwd";
      POSTGRES_USER = "postgres";
      REDIS_HOST = "redis";
      REDIS_PASSWORD = "12345pass67890word";
      REDIS_PORT = "6379";
    };
    volumes = [
      "/data/ghostfolio:/var/lib/postgresql/data:rw"
    ];
    log-driver = "journald";
    extraOptions = [
      "--health-cmd=pg_isready -d \${POSTGRES_DB} -U \${POSTGRES_USER}"
      "--health-interval=10s"
      "--health-retries=5"
      "--health-timeout=5s"
      "--network-alias=postgres"
      "--network=ghostfolio_default"
    ];
  };
  systemd.services."docker-ghostfolio-postgres" = {
    serviceConfig = {
      Restart = lib.mkOverride 90 "no";
    };
    after = [ "docker-network-ghostfolio_default.service" ];
    requires = [ "docker-network-ghostfolio_default.service" ];
    partOf = [ "docker-compose-ghostfolio-root.target" ];
    wantedBy = [ "docker-compose-ghostfolio-root.target" ];
  };
  virtualisation.oci-containers.containers."ghostfolio-redis" = {
    image = "redis:alpine";
    environment = {
      ACCESS_TOKEN_SALT = "acsaceccaceveve";
      COMPOSE_PROJECT_NAME = "ghostfolio-development";
      DATABASE_URL = "postgresql://postgres:Th1s1sAPgslGhostfolioPwd@postgres:5432/ghostfolio-db?connect_timeout=300&sslmode=prefer";
      JWT_SECRET_KEY = "acasclacsj236615ewce";
      POSTGRES_DB = "ghostfolio-db";
      POSTGRES_PASSWORD = "Th1s1sAPgslGhostfolioPwd";
      POSTGRES_USER = "postgres";
      REDIS_HOST = "redis";
      REDIS_PASSWORD = "12345pass67890word";
      REDIS_PORT = "6379";
    };
    cmd = [ "redis-server" ];
    log-driver = "journald";
    extraOptions = [
      "--health-cmd=redis-cli --pass ping | grep PONG"
      "--health-interval=10s"
      "--health-retries=5"
      "--health-timeout=5s"
      "--network-alias=redis"
      "--network=ghostfolio_default"
    ];
  };
  systemd.services."docker-ghostfolio-redis" = {
    serviceConfig = {
      Restart = lib.mkOverride 90 "no";
    };
    after = [ "docker-network-ghostfolio_default.service" ];
    requires = [ "docker-network-ghostfolio_default.service" ];
    partOf = [ "docker-compose-ghostfolio-root.target" ];
    wantedBy = [ "docker-compose-ghostfolio-root.target" ];
  };

  # Networks
  systemd.services."docker-network-ghostfolio_default" = {
    path = [ pkgs.docker ];
    serviceConfig = {
      Type = "oneshot";
      RemainAfterExit = true;
      ExecStop = "docker network rm -f ghostfolio_default";
    };
    script = ''
      docker network inspect ghostfolio_default || docker network create ghostfolio_default
    '';
    partOf = [ "docker-compose-ghostfolio-root.target" ];
    wantedBy = [ "docker-compose-ghostfolio-root.target" ];
  };

  # Root service
  # When started, this will automatically create all resources and start
  # the containers. When stopped, this will teardown all resources.
  systemd.targets."docker-compose-ghostfolio-root" = {
    unitConfig = {
      Description = "Root target generated by compose2nix.";
    };
    wantedBy = [ "multi-user.target" ];
  };
    services.nginx.virtualHosts."ghostfolio.irotnep.net" = {
    forceSSL = true;
    enableACME = true;
    locations."/" = {
     proxyPass = "http://127.0.0.1:3333";
     proxyWebsockets = true;
     recommendedProxySettings = true;
    };
  };

}
