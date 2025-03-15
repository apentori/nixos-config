# Edit this configuration file to define what should be installed on
# your system. Help is available in the configuration.nix(5) man page, on
# https://search.nixos.org/options and in the NixOS manual (`nixos-help`).

{ config, lib, pkgs, ... }:
let
  SSID = "Livebox6-0600";
  SSIDpassword = "Nfv9HTEb6qts";
  interface = "wlan0";
in
{
  imports =
    [ # Include the results of the hardware scan.
      ./hardware-configuration.nix
      ../../roles/wifi.nix
      ../../roles/default.nix
      ../../roles/users.nix

    ];
  nixpkgs.system = "aarch64-linux";
  # Use the extlinux boot loader. (NixOS wants to enable GRUB by default)
  boot.loader.grub.enable = false;
  # Enables the generation of /boot/extlinux/extlinux.conf
  boot.loader.generic-extlinux-compatible.enable = true;

  hardware.enableRedistributableFirmware = true;
  # Pick only one of the below networking options.
  networking = {
    hostName = "mnemosyme";
  };
  # networking.networkmanager.enable = true;  # Easiest to use and most distros use this by default.
  time.timeZone = "Europe/Madrid";

  system.stateVersion = "24.05"; # Did you read the comment?

}

