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
    wget curl nmap nettools traceroute dnsutils wirelesstools
    # file system
    ncdu zfs zfstools
    # security
    pass openssl gnupg gnupg1

    hyprland xwayland polkit
    waybar dunst
    libnotify
    swww # wallpaper 
    kitty alacritty # terminals
    rofi-wayland # app launcher
    networkmanagerapplet #network 
    pipewire # screen sharing
    swaylock # Lock screen
    wlroots #Dynamic Menu
    wl-clipboard # CopyPast Utilities
    wofi
    mako
    yad
    pastel
    xfce.thunar # file manger
    pulsemixer
    (waybar.overrideAttrs (oldAttrs: {
      mesonFlags = oldAttrs.mesonFlags ++ [ "-Dexperimental=true" ];
      }))

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
