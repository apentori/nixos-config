{ pkgs, config, ...}:
let
  gethPort=30303;
in {
  config = let
    cfg = config.geth;
  in {
    # Secrets
    age.secrets = {
      jwt-secret-geth =  {
        file = ../secrets/services/geth/jwt-secret.age;
        path = "/geth/jwt-secret";
        owner = "geth-holesky";
        group = "geth-holesky";
        mode = "600";
      };
    };
    # Firewall
    networking.firewall.allowedTCPPorts = [ gethPort ];
    networking.firewall.allowedUDPPorts = [ gethPort ];

    services.geth.holesky = {
      enable = true;
      port=gethPort;
 #  datadir = "/data/geth";
#      authrpc ={
#        enable = true;
#        jwtsecret =  "/geth/jwt-secret";
#      };
      extraArgs=[
        "--syncmode=full"
        "--holesky"
        "--nat=extip:149.202.75.222"
      ];
      metrics= {
        enable= true;
      };
    };

    systemd.services.geth-holesky = {
    };
  };
}
