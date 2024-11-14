{ pkgs, lib, config, ... }:

let
  listenPort = 9000; # WebDAV Source TLS/SSL
  discoverPort = 9000; # WebDAV Source TLS/SSL
  services = config.services;
in {
  imports = [
    ../services/nimbus-eth2.nix
  ];
  config = let
    cfg = config.nimbus;
  in {
    # Secret
    age.secrets = {
      jwt-secret = {
        file = ../secrets/services/geth/jwt-secret.age;
        path = "/nimbus/jwt-secret";
        owner = "nimbus";
        group = "nimbus";
        mode = "600";
      };
    };
    # Firewall Permission
    networking.firewall.allowedTCPPorts = [ listenPort ];
    networking.firewall.allowedUDPPorts = [ discoverPort ];

    services.nimbus-eth2 = {
      enable = false;
      metrics.enable = true;
      rest.enable = true;
      el = "http://localhost:8551";
      jwtSecret = "/nimbus/jwt-secret";
      feeRecipient = "0xaEf9C1bA601c3ec72AD2E82cCC3Bd9AB2A92F3FE";
      inherit listenPort discoverPort;
      # extraArgs = [];
    };
  };
}
