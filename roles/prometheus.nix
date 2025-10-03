{lib, config, ... }:

let
  inherit (config) services;

  default = { netdata = 9000;};

  hosts = {
    "hermes.irotn.ep"     = default;
    "hyperion.irotn.ep"   = default;
  };

  hostsWithPort = service: lib.filterAttrs(_: v: lib.hasAttr service v) hosts;

  genTargets = service:
    lib.mapAttrsToList
    (host: val: "${host}:${toString (lib.getAttr service val)}")
    (hostsWithPort service);

  genScrapeJob = { name, path, port }: {
    job_name = name;
    metrics_path = path;
    scrape_interval = "60s";
    scheme = "http";
    params = { format = [ "prometheus" ]; };
    static_configs = [{ targets = genTargets name; }];
  };
in {
  services.prometheus = {
    enable = true;
    globalConfig.scrape_interval = "10s";
    scrapeConfigs = [
      (genScrapeJob {name= "nimbus";    path = "metrics";       port = 5052; })
      (genScrapeJob {name= "geth";      path = "debug/metrics"; port = 6060; })
      (genScrapeJob {name= "exporter";  path = "metrics";       port = 9090; })
    ];
#    exporters.node = {
#      enable = true;
#      port = 9000;
#      enabledCollectors = [ "systemd" ];
#      extraFlags = [ "--collector.ethtool" "--collector.softirqs" "--collector.tcpstat" "--collector.wifi" ];
#    };

  };
}
