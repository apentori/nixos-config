{ pkgs, ... }:

{
  environment.systemPackages = with pkgs; [
  #wine
  lua5.1-luarocks
  # winetricks (all versions)
  winetricks
  # native wayland support (unstable)
  wineWowPackages.waylandFull
  # Finance tools
  denaro
  ledger-live-desktop ledger-udev-rules
  qemu
  keepassxc
  joplin-desktop
];
services.udev.packages = with pkgs; [ ledger-udev-rules ];
  users.users.irotnep.packages = with pkgs; [
    # Web
    firefox brave
    # Communication
    discord
    # Note
    obsidian
  ];

  programs.zsh.ohMyZsh = {
    enable = true;
    theme = "agnoster";
  };
}
