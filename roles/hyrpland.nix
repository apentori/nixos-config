{ pkgs, ... }:

{
  environment.systemPackages = with pkgs; [
    hyprland xwayland polkit
    waybar 
    #dunst # Notif daemon
    swaynotificationcenter # notification daemon
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
    gnome.nautilus # file manager
    libsForQt5.koko # image reader 
    slurp grim # screen shot
    (waybar.overrideAttrs (oldAttrs: {
      mesonFlags = oldAttrs.mesonFlags ++ [ "-Dexperimental=true" ];
      }))
      meson
      gvfs
      playerctl
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
  
  
  programs.hyprland = {
     enable = true;
     xwayland.enable = true;
    };
  environment.sessionVariables = {
    WLR_NO_HARDWARE_CURSORS = "1";
    NIXOS_OZONE_WL = "1";
  };
  programs.waybar = {
    enable = true;
  };
}
