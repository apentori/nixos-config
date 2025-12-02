{ config, secret, ... }:
{
  imports = [
    ../../services/uniswap-watcher.nix
  ];

  age.secrets."uniswap-watcher-api-key" = {
    file = ../../secrets/services/uniswap-watcher/api-key.age;
    path = "/etc/uniswap-watcher/api-key.env";
  };
  age.secrets."uniswap-watcher-database-password" = {
    file = ../../secrets/services/uniswap-watcher/clickhouse-password.age;
    path = "/etc/uniswap-watcher/database.env";
  };


  services = {
    clickhouse = {
      enable = true;
      serverConfig = {
        http_port = 8123;
        tcp_port = 9001;
      };
      usersConfig = {
        profiles = {};
        users = {
          watcher = {
            profile = "default";
            password_sha256_hex = "ca3f61ee74f07cebcc90f446cd537db06e1b92d69137604be64a6cb5e319fbc7";
          };
        };
      };
    };
    uniswap-watcher = {
      enable = true;
      tag = "main";
    };
  };
}
