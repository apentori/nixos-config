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
  age.secrets."trade-tracker-secrets" = {
    file = ../../secrets/services/trade-tracker/secrets.age;
    path = "/etc/trade-tracker/secrets.env";
  };


  services = {
    clickhouse = {
      enable = true;

      serverConfig = {
        listen_host = "0.0.0.0";
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
      extraServerConfig = ''
        <clickhouse>
          <prometheus>
              <endpoint>/metrics</endpoint>
              <host>0.0.0.0</host>
              <port>9363</port>
              <metrics>true</metrics>
              <events>true</events>
              <asynchronous_metrics>true</asynchronous_metrics>
              <errors>true</errors>
          </prometheus>
        </clickhouse>
      '';
    };
    uniswap-watcher = {
      enable = true;
      tag = "main";
    };
    trade-tracker = {
      enable = true;
      follow = false;
      clickhouse = {
        host = "localhost";
        port = 9001;
        user = "watcher";
        database = "watcher";
        table = "trades";
      };
      pairs = [
        {
          name = "ETH/USDC";
          base_token = "0x4200000000000000000000000000000000000006";
          quote_token = "0x0b2c639c533813f4aa9d7837caf62653d097ff85";
          base_decimals = 18;
          quote_decimals = 6;
        }
        {
          name = "ETH/DAI";
          base_token = "0x4200000000000000000000000000000000000006";
          quote_token = "0xda10009cbd5d07dd0cecc66161fc93d7c9000da1";
          base_decimals = 18;
          quote_decimals = 18;
        }
      ];

    };
  };
}
