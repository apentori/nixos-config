{ pkgs, ... }:

{
  imports = [

  ];

  # System packages
  environment.systemPackages = with pkgs; [
    # utilities
    file zsh sudo bc lsb-release
    # building
    gcc zip unzip
    # monitoring
    htop ncdu 
    # dev tools
    neovim jq tmux fzf silver-searcher git
    # file system
    zfs zfstools
    # networking
    wget curl nmap nettols traceroute
    # Security
    pass openssl
  ];

  # Shell
  programs.zsh.enable = true;
  users.defaultuserShell = pkgs.zsh;
  # Editor
  programs.neovim = {
      enable = true;
      viAlias = true;
      vimAlias =  true;
      defaultEditor =  true;
  };

  environment.variables = {
      EDITOR = "nvim";
      VISUAL = "nvim";
  };

  # Uptime tracker
  services.uptimed.enable = true;
}
