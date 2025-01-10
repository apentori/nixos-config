{ pkgs, lib, config, ...}:
let
  writeTextDir = {
  name = "ghostfolio_compose";
  destination = "/data/ghostfolio/docker-compose.yml";
  text = ''
    name: ghostfolio
    services:
      ghostfolio:
        image: docker.io/ghostfolio/ghostfolio:latest
        container_name: ghostfolio
        restart: unless-stopped
        init: true
        cap_drop:
          - ALL
        security_opt:
          - no-new-privileges:true
        env_file:
          - /data/ghostfolio/.env
        ports:
          - 3333:3333
        depends_on:
          postgres:
            condition: service_healthy
          redis:
            condition: service_healthy
        healthcheck:
          test: ['CMD-SHELL', 'curl -f http://localhost:3333/api/v1/health']
          interval: 10s
          timeout: 5s
          retries: 5
    
      postgres:
        image: docker.io/library/postgres:15-alpine
        container_name: gf-postgres
        restart: unless-stopped
        cap_drop:
          - ALL
        cap_add:
          - CHOWN
          - DAC_READ_SEARCH
          - FOWNER
          - SETGID
          - SETUID
        security_opt:
          - no-new-privileges:true
        env_file:
          - /data/ghostfolio/.env
        healthcheck:
          test:
            ['CMD-SHELL', 'pg_isready -d "$${POSTGRES_DB}" -U $${POSTGRES_USER}']
          interval: 10s
          timeout: 5s
          retries: 5
        volumes:
          - /data/ghostfolio/data:/var/lib/postgresql/data
    
      redis:
        image: docker.io/library/redis:alpine
        container_name: gf-redis
        restart: unless-stopped
        user: '999:1000'
        cap_drop:
          - ALL
        security_opt:
          - no-new-privileges:true
        env_file:
          - /data/ghostfolio/.env
        command:
          - /bin/sh
          - -c
          - redis-server --requirepass "$${REDIS_PASSWORD:?REDIS_PASSWORD variable is not set}"
        healthcheck:
          test:
            ['CMD-SHELL', 'redis-cli --pass "$${REDIS_PASSWORD}" ping | grep PONG']
          interval: 10s
          timeout: 5s
          retries: 5
  '';
  };


in {
    age.secrets."ghostfolio-admin" = {
    file = ../secrets/services/ghostfolio/env.age;
    path = "/data/ghostfolio/.env";
    owner = "irotnep";
    group = "docker";
  };

 systemd.tmpfiles.rules = [
    "d /data/ghostfolio 0750 irotnep docker"
    "d /data/ghostfolio/data 0750 irotnep docker"
];

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
