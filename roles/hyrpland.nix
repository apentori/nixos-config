{ pkgs, ... }:

{
  environment.systemPackages = with pkgs; [
    pciutils
    hyprland xwayland polkit
    xdg-desktop-portal-hyprland
    swaynotificationcenter # notification daemon
    alacritty # terminals
    rofi-wayland # app launcher
    networkmanagerapplet #network
    pipewire
    wireplumber # screen sharing
    greetd.tuigreet
    pavucontrol
    wlogout swaybg  #Login etc..
    wlroots # Dynamic Menu
    wl-clipboard # CopyPast Utilities
    brightnessctl # brightness control
    cliphist # Clipboard manager
    pulsemixer pulseaudioFull# sound
    xdg-desktop-portal-wlr # Desktop portal
    nautilus # file manager
    slurp grim # screen shot
    playerctl

    hyprlock
    hypridle
    # PDF
    zathura
    # media
    imv mpv
    yazi
    hyprpanel
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

  services.hypridle.enable = true;
}
