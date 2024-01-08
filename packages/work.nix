{ pkgs, ...}:

{
  imports=[];
  # Accept unfree licenses
  nixpkgs.config.allowUnfree = true;
  
  # System packages
  environment.systemPackages = with pkgs; [
  ];
  
  users.users.irotnep.packages = with pkgs; [
     # Dev tools
     git  
     
     # Notes
     obsidian
     #  Communication
     discord
  ];
}
