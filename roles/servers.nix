{ pkgs, ... }:
{
  imports = [
    ./prometheus.nix
    ./promtail.nix
    ];

  programs.zsh.ohMyZsh = {
    enable = true;
    theme = "blinks";
  };
}
