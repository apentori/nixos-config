{ pkgs, config, ...}:
 
{
  # Secrets 
  # Firewall 

  config.services.geth.holesky = {
    enable = true;
 #  datadir = "/data/geth";
    extraArgs=[
      "--holesky"
    ];
    metrics= {
      enable= true;
    };
  };
}
