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
    gcc mpv scdoc busybox
    # Networking
    wget curl nmap nettools traceroute dnsutils wirelesstools blueman
    # file system
    ncdu zfs zfstools
    # security
    pass openssl gnupg gnupg1

    hyprland xwayland polkit
    waybar 
    dunst # Notif daemon
    swww # wallpaper 
    kitty alacritty # terminals
    rofi-wayland # app launcher
    networkmanagerapplet #network 
    pipewire
    wireplumber # screen sharing
    greetd.tuigreet
    pavucontrol
    swaylock-effects swayidle wlogout swaybg  #Login etc..  
    wlroots # Dynamic Menu
    wl-clipboard # CopyPast Utilities
    brightnessctl # brightness control
    mako
    cliphist # Clipboard manager
    pulsemixer # sound
    swayosd
    xdg-desktop-portal-wlr # Desktop portal
    viewnior # image manager 
    xfce.thunar # filemanager
    slurp grim # screen shot
    (waybar.overrideAttrs (oldAttrs: {
      mesonFlags = oldAttrs.mesonFlags ++ [ "-Dexperimental=true" ];
      }))
      meson
    ];
  
  fonts.packages = with pkgs; [
    nerdfonts
   meslo-lgs-nf
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

  services.greetd = {
    enable = true;
    settings = {
      default_session = {
        command = "${pkgs.greetd.tuigreet}/bin/tuigreet --time --cmd Hyprland";
#        user="irotnep";
      };
    };
  };
  # avoid swaylock telling wrong password
  security.pam.services.swaylock = {};
}
