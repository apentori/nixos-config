{ pkgs, ... }:

{
  environment.systemPackages = with pkgs; [
    # Utility
    file zsh bash man-pages sudo bc lsb-release uptimed
    zip unzip
    thefuck
    # monitoring
    htop 
    # Code
    neovim jq fzf silver-searcher git
    gcc
    # Networking
    wget curl nmap nettools traceroute dnsutils
    # file system
    ncdu zfs zfstools
    # security
    pass openssl gnupg gnupg1
  ];
  # Shell 
  programs.zsh.enable =  true;
  users.defaultUserShell = pkgs.zsh;
  
  # Editor
  programs.neovim = {
    enable = true;
    viAlias = true;
    vimAlias = true;
    defaultEditor = true;
  };

    # Editor
  environment.variables = {
    EDITOR = "nvim";
    VISUAL = "nvim";
  };

  # Uptime tracker
  services.uptimed.enable = true;

  users.users.irotnep.packages = with pkgs; [
    # Web 
    firefox brave
    # Communication 
    discord
    # Note 
    obsidian
  ];


}
