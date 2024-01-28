# Edit this configuration file to define what should be installed on
# your system. Help is available in the configuration.nix(5) man page, on
# https://search.nixos.org/options and in the NixOS manual (`nixos-help`).

{ config, lib, pkgs, ... }:

{
  imports =
    [ # Include the results of the hardware scan.
      ./hardware-configuration.nix
#      ../../roles/windows.nix
      ../../roles/users.nix
      ../../roles/default.nix
      ../../roles/work.nix
    ];

   boot.loader.grub = {
    enable = true;
    zfsSupport = true;
    efiSupport = true;
    efiInstallAsRemovable = true;
    mirroredBoots = [
      { devices = [ "nodev"]; path = "/boot"; }
    ];
  };

  networking = {
    hostName = "achilleus"; # Define your hostname.
    hostId = "8425e349";
    wireless = {
      enable = true;
      interfaces = [ "wlp2s0" ];
    };
  };
  nixpkgs = {
    # You can add overlays here
    overlays = [
    ];
    config = {
      allowUnfree = true;
    };
  };
  nix.settings.experimental-features = [ "nix-command" "flakes"];
  time.timeZone = "Europe/Madrid";

  i18n.defaultLocale = "en_US.UTF-8";

  i18n.extraLocaleSettings = {
    LC_ADDRESS = "es_ES.UTF-8";
    LC_IDENTIFICATION = "es_ES.UTF-8";
    LC_MEASUREMENT = "es_ES.UTF-8";
    LC_MONETARY = "es_ES.UTF-8";
    LC_NAME = "es_ES.UTF-8";
    LC_NUMERIC = "es_ES.UTF-8";
    LC_PAPER = "es_ES.UTF-8";
    LC_TELEPHONE = "es_ES.UTF-8";
    LC_TIME = "es_ES.UTF-8";
  };


  #  console = {
  #   font = "Lat2-Terminus16";
  #   keyMap = "us";
  #   useXkbConfig = true; # use xkb.options in tty.
  # };

  # Enable the X11 windowing system.
  # services.xserver= {
  #   enable = true;
  # # Enable the GNOME Desktop Environment.
  #   displayManager.gdm.enable = true;
  #   desktopManager.gnome.enable = true;
  # 
  # # Enable touchpad support (enabled default in most desktopManager).
  #   libinput.enable = true;
  # };
  programs.waybar.enable = true;
  programs.hyprland = {
     enable = true;
     xwayland.enable = true;
    };
  environment.sessionVariables = {
    WLR_NO_HARDWARE_CURSORS = "1";
    NIXOS_OZONE_WL = "1";
  };
  
#     environment.systemPackages = [
#       (pkgs.waybar.overrideAttrs (oldAttrs: {
#         mesonFlags = oldAttrs.mesonFlags ++ [ "-Dexperimental=true" ];
#         }))
#     ];
   hardware = {
      opengl.enable =  true;
    };
 
    xdg.portal.enable =  true;
    xdg.portal.extraPortals = [pkgs.xdg-desktop-portal-gtk];
    # Enable sound.
  sound.enable = true;
  security.rtkit.enable = true;
  services.pipewire = {
    enable = true;
    alsa.enable = true;
    alsa.support32Bit = true;
    pulse.enable = true;
    jack.enable = true;
  };
  hardware.pulseaudio.enable = false;

  nixpkgs.config.permittedInsecurePackages = [
      "electron-25.9.0"
  ];
  system.stateVersion = "23.11"; # Did you read the comment?

}

