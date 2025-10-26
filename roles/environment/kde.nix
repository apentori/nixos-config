{ pkgs, ... }:

{
  environment.systemPackages = with pkgs; [
    kdePackages.kscreen
    alacritty
    stremio
  ];
}
