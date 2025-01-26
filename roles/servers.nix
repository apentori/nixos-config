{ pkgs, ... }:
{
  imports = [
    ./prometheus.nix
    ./promtail.nix
    ./paperless.nix
    ./tandoor.nix
    ];

  programs.zsh.ohMyZsh = {
    enable = true;
    theme = "blinks";
  };
}
