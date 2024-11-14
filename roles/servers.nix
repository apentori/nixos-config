{ pkgs, ... }:
{
  imports = [
    ./prometheus.nix
    ./promtail.nix
    ./paperless.nix
    ];

  programs.zsh.ohMyZsh = {
    enable = true;
    theme = "blinks";
  };
}
