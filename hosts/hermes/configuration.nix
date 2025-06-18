# Edit this configuration file to define what should be installed on
# your system. Help is available in the configuration.nix(5) man page, on
# https://search.nixos.org/options and in the NixOS manual (`nixos-help`).

{ config, lib, pkgs, system, inputs, ... }:

{
  imports =
    [ # Include the results of the hardware scan.
      ./hardware-configuration.nix
      ../../roles/hyrpland.nix
      ../../roles/users.nix
      ../../roles/default.nix
      ../../roles/work.nix
      ../../roles/laptop.nix
      ../../roles/tailscale.nix
    ];

  # Use the systemd-boot EFI boot loader.
  boot.loader.grub = {
    enable = true;
    zfsSupport = true;
    efiSupport = true;
    efiInstallAsRemovable = true;
    mirroredBoots = [
      { devices = [ "nodev"]; path = "/boot"; }
    ];
  };

  networking ={
    hostName = "hermes"; # Define your hostname.
    hostId = "a425e349";	
    networkmanager.enable = true;
    wireless.userControlled.enable = true;
  };
  
  environment.systemPackages = with pkgs; [
    catppuccin-gtk
    catppuccin-kvantum
    catppuccin-cursors.macchiatoTeal
    inputs.zen-browser.packages."${system}".default
    inputs.ags.packages.aarch64-linux.agsFull
    inputs.hypr-panel.packages."${system}".default
  ];

  catppuccin = {
    enable = true;
  };

  environment.variables = {
    GTK_THEME = "catppuccin-macchiato-teal-standard";
    XCURSOR_THEME = "Catppuccin-Macchiato-Teal";
    XCURSOR_SIZE = "24";
    HYPRCURSOR_THEME = "Catppuccin-Macchiato-Teal";
    HYPRCURSOR_SIZE = "24";
  };

  nixpkgs = {
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
  services.xserver={
    enable = true;
    xkb = {
    layout = "us";
    variant = "altgr-intl";
    };
  };

  hardware = {
      bluetooth.enable = true;
      system76 = {
        enableAll = true;
        kernel-modules.enable = true;
      };
  };

  xdg.portal.enable = true;
  xdg.portal.extraPortals = [pkgs.xdg-desktop-portal-gtk];
    # Enable sound.
  services.blueman.enable = true;
  security.rtkit.enable = true;
  services.pipewire = {
    enable = true;
    alsa.enable = true;
    alsa.support32Bit = true;
    pulse.enable = true;
    jack.enable = true;
    wireplumber.enable = true;
  };

  services.upower.enable = true;
  nixpkgs.config.permittedInsecurePackages = [
    "electron-33.4.11"
      "vault-1.18.10"
  ];



  nix.gc = {
    automatic = true;
    dates = "weekly";
    options = "--delete-older-than 7d";
  };

  nix.settings.trusted-users = ["irotnep" ];
  system.autoUpgrade = {
      enable = true;
};
 
  system.stateVersion = "25.05"; # Did you read the comment?

}

