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
  ledger-live-desktop
  qemu
  keepassxc
];

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
