{ pkgs, ... }:

{
  users.users.irotnep.packages = with pkgs; [
    # Web 
    firefox brave
    # Communication 
    discord
    # Note 
    obsidian
  ];
  environment.systemPackages = with pkgs; [
    neovim vim
    wget
  ];

}
