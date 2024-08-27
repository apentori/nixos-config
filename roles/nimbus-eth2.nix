{ pkgs, lib, config,  ... }:

let  
  listenPort = 9802; # WebDAV Source TLS/SSL
  discoverPort = 9802; # WebDAV Source TLS/SSL
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
      jwt-secret =  {
        file = ../secrets/services/geth/jwt-secret.age;
        path = "/nimbus/jwt-secret";
        owner = "nimbus";
        group = "nimbus";
        mode = "600";
      };
    };
    #  Firewall Permission
    networking.firewall.allowedTCPPorts = [ listenPort ];
    networking.firewall.allowedUDPPorts = [ discoverPort ];

    services.nimbus-eth2 = {
      enable = true;
      metrics.enable = true;
      rest.enable = true;
      el = "http://localhost:8551";
      jwtSecret = "/nimbus/jwt-secret";
      inherit listenPort discoverPort;
#      extraArgs = [];
    };
  };
}
