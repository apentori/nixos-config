{ pkgs, ... }:

{
  environment.systemPackages = with pkgs; [
  #wine
  # winetricks (all versions)
  winetricks
  # native wayland support (unstable)
  wineWowPackages.waylandFull
  # Finance tools
  denaro
  qemu
  ungoogled-chromium
  keepassxc
];
}
