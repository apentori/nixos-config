{ pkgs, ... }:
{
  imports = [
    ./infra/nginx.nix
    ./infra/headscale.nix
    # Monitoring and logs
    ./infra/prometheus.nix
    ./infra/grafana.nix
    ./infra/promtail.nix
    ./infra/loki.nix
    # Applications
    ./misc/habitsync.nix
    ./misc/uniswap-watcher.nix
    ];

}
