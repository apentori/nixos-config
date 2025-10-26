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
    ./office/paperless.nix
    ./office/docmost.nix
    ./office/grist.nix
    ./misc/media.nix
    ./misc/habitsync.nix
    ];

}
