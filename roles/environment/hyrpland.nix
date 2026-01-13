{ pkgs, ... }:

{
  environment.systemPackages = with pkgs; [
    pciutils

    hyprland
    polkit

    xdg-desktop-portal-hyprland
    swaynotificationcenter # notification daemon
    alacritty # terminals
    rofi # app launcher
    networkmanagerapplet #network
    pipewire
    wireplumber # screen sharing
    tuigreet
    pavucontrol
    wlogout swaybg  #Login etc..
    wlroots # Dynamic Menu
    wl-clipboard # CopyPast Utilities
    brightnessctl # brightness control
    cliphist # Clipboard manager
    pulsemixer pulseaudioFull# sound
    xdg-desktop-portal-wlr # Desktop portal
    xdg-desktop-portal-gtk
    nautilus # file manager
    slurp grim # screen shot
    playerctl

    hyprlock
    hypridle
    hyprland-qt-support
    hyprpolkitagent
    hyprcursor
    nwg-displays
    nwg-look
    waypaper
    mesa
    # PDF
    zathura
    # media
    imv mpv
    yazi
    hyprpanel
    ags
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

    # Extra Portal Configuration
  xdg.portal = {
    enable = true;
    wlr.enable = true;
    extraPortals = [
      pkgs.xdg-desktop-portal-gtk
      pkgs.xdg-desktop-portal-wlr
      #pkgs.xdg-desktop-portal
    ];
    configPackages = [
      pkgs.xdg-desktop-portal-gtk
      pkgs.xdg-desktop-portal-wlr
    ];
  };

  programs.hyprland = {
     enable = true;
     xwayland.enable = true;
     portalPackage = pkgs.xdg-desktop-portal-hyprland;
     withUWSM = false;
    };
  environment.sessionVariables = {
    WLR_NO_HARDWARE_CURSORS = "1";
    NIXOS_OZONE_WL = "1";
  };
  environment.sessionVariables = {
    XCURSOR_THEME = "Bibata-Modern-Classic";
    XCURSOR_SIZE = "24";
  };

  services.hypridle.enable = true;
}
