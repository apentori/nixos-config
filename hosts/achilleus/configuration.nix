# Edit this configuration file to define what should be installed on
# your system. Help is available in the configuration.nix(5) man page, on
# https://search.nixos.org/options and in the NixOS manual (`nixos-help`).

{ config, lib, pkgs, ... }:

{
  imports =
    [ # Include the results of the hardware scan.
      ./hardware-configuration.nix
      ../../roles/hyrpland.nix
      ../../roles/users.nix
      ../../roles/default.nix
      ../../roles/work.nix
      ../../roles/personnal.nix
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
  boot.initrd.kernelModules = [ "amdgpu" ];

  environment.systemPackages = with pkgs; [
    system76-firmware
  ];

  networking = {
    hostName = "achilleus"; # Define your hostname.
    hostId = "8425e349";
    networkmanager.enable = true;
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
    layout = "us";
    xkbVariant="altgr-intl";
    videoDrivers = [ "amdgpu" ];
  };

  hardware = {
      opengl.enable =  true;
      bluetooth.enable = true;
  };
 
  xdg.portal.enable =  true;
  xdg.portal.extraPortals = [pkgs.xdg-desktop-portal-gtk];
    # Enable sound.
  sound.enable = true;
  security.rtkit.enable = true;
  services.blueman.enable = true;
  services.pipewire = {
    enable = true;
    alsa.enable = true;
    alsa.support32Bit = true;
    pulse.enable = true;
    jack.enable = true;
    wireplumber.enable = true;
  };

  nixpkgs.config.permittedInsecurePackages = [
      "electron-25.9.0"
      "vault-1.14.10"
  ];

  # System76
  hardware.system76={
    enableAll = true;
  };
  system.stateVersion = "23.11"; # Did you read the comment?

  nix.gc = {
    automatic = true;
    dates = "weekly";
    options = "--delete-older-than 7d";
  };
  system.autoUpgrade = {
      enable = true;
};
}

