{ pkgs, ... }:
{
  imports = [
    ./prometheus.nix
    ./promtail.nix
    ./paperless.nix
    ./tandoor.nix
    ./docmost.nix
    ./grist.nix
    ];

  programs.zsh.ohMyZsh = {
    enable = true;
    theme = "blinks";
  };
}
