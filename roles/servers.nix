{ pkgs, ... }:
{
  imports = [
    ./prometheus.nix
    ./promtail.nix
    ./paperless.nix
    ./tandoor.nix
    ./docmost.nix
    ];

  programs.zsh.ohMyZsh = {
    enable = true;
    theme = "blinks";
  };
}
