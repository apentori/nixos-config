{lib, config, ... }:

let
  inherit (config) services;

  default = { netdata = 9000;};

  hosts = {
    "hyperion.irotn.ep" = default // { loki = 3030; };
    "hermes.irotn.ep" = default;
  };

  hostsWithPort = service: lib.filterAttrs(_: v: lib.hasAttr service v) hosts;

  genTargets = service:
    lib.mapAttrsToList
    (host: val: "${host}:${toString (lib.getAttr service val)}")
    (hostsWithPort service);

  genScrapeJob = { name, path }: {
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
      (genScrapeJob { name = "netdata";   path = "/api/v1/allmetrics";})
      (genScrapeJob { name = "loki";      path = "/metrics"; })
    ];

  };
}
