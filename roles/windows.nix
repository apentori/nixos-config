{ pkgs, ... }:

{
#  environment.systemPackages = with pkgs; [
#    hyprland xwayland
#    waybar dunst
#    libnotify
#    swww # wallpaper 
#    kitty # terminal
#    rofi-wayland # app launcher
#    networkmanagerapplet
#    (waybar.overrideAttrs (oldAttrs: {
#      mesonFlags = oldAttrs.mesonFlags ++ [ "-Dexperimental=true" ];
#      }))
#
#  ];
#  font.packages = with pkgs [
#    noto-fonts
#    noto-fonts-cjk
#    noto-fonts-emoji
#    liberation_ttf
#    fira-code
#    fira-code-symbols
#    mplus-outline-fonts.githubRelease
#    dina-font
#    proggyfonts
#    otf-font-awesome
#  ];


#   programs.hyprland = {
#     enable = true;
#    xwayland.enable = true;
#   };
#   environment.sessionVariables = {
#     WLR_NO_HARDWARE_CURSORS = "1";
#     NIXOS_OZONE_WL = "1";
#   };
#  hardware = {
#    opengl.enable =  true;
#  };
#  xdg.portal.enable =  true;
#  xdg.portal.extraPortals = [pkgs.xdg-desktop-portal-gtk];

  }
