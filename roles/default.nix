{ pkgs, ... }:

{
  environment.systemPackages = with pkgs; [
  # Utility
    file zsh bash man-pages sudo bc lsb-release uptimed
    zip unzip
    thefuck
    # monitoring
    btop psensor usbutils
    # Code
    neovim jq fzf silver-searcher git
    gcc mpv scdoc busybox
    # Networking
    wget curl nmap nettools traceroute dnsutils wirelesstools blueman
    # file system
    ncdu zfs zfstools
    # security
    pass openssl gnupg gnupg1
    xdg-utils
    # Monitors and Docks
    displaylink
  ];
  
  fonts.packages = with pkgs; [
    nerdfonts
    meslo-lgs-nf
    fira-code
    fira-code-symbols
  ];
  # Shell 
  programs.zsh.enable =  true;
  users.defaultUserShell = pkgs.zsh;
 
  programs.fzf = {
    keybindings = true;
    fuzzyCompletion = true;
  };
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
