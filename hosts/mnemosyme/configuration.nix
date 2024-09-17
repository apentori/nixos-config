# Edit this configuration file to define what should be installed on
# your system. Help is available in the configuration.nix(5) man page, on
# https://search.nixos.org/options and in the NixOS manual (`nixos-help`).

{ config, lib, pkgs, ... }:
let 
  SSID = "Livebox6-0600";
  SSIDpassword = "somePassword";
  interface = "wlan0";
in
{
  imports =
    [ # Include the results of the hardware scan.
      ./hardware-configuration.nix
    ];
  nixpkgs.system = "aarch64-linux";
  # Use the extlinux boot loader. (NixOS wants to enable GRUB by default)
  boot.loader.grub.enable = false;
  # Enables the generation of /boot/extlinux/extlinux.conf
#  boot.loader.generic-extlinux-compatible.enable = true;
    boot.kernelParams = [
    "console=ttyS1,115200n8"
  ];
  boot.loader.raspberryPi = {
    enable = true;
    version = 3;
    firmwareConfig = ''
      core_freq=250
    '';
  };
  hardware.enableRedistributableFirmware = true;
  # networking.hostName = "nixos"; # Define your hostname.
  # Pick only one of the below networking options.
  networking = {
    hostName = "mnemosyme";
    wireless = {
      enable = true;
      networks."${SSID}".psk = SSIDpassword;
      interfaces = [ interface ];
    };
  };
  # networking.networkmanager.enable = true;  # Easiest to use and most distros use this by default.
#  nix.binaryCaches = lib.mkForce["https://cache.armv7.xyz"]
#  nix.binaryCachePublicKeys = ["cache.arm7l.xyz-1:kBY/eGnBAYiqYfg0fy0inWhshUo+pGFM3Pj7kIkmlBk="]
  # Set your time zone.
  time.timeZone = "Europe/Madrid";


  # Define a user account. Don't forget to set a password with ‘passwd’.
   users.users.irotnep = {
     isNormalUser = true;
     password= "aPassWord";
     extraGroups = [ "wheel" ]; # Enable ‘sudo’ for the user.
     packages = with pkgs; [
      	vim
        tree
     ];
   };

  # Enable the OpenSSH daemon.
  services.openssh = {
    enable = true;
  };
  # Open ports in the firewall.
  # networking.firewall.allowedTCPPorts = [ ... ];
  # networking.firewall.allowedUDPPorts = [ ... ];
  # Or disable the firewall altogether.
  # networking.firewall.enable = false;

  # Copy the NixOS configuration file and link it from the resulting system
  # (/run/current-system/configuration.nix). This is useful in case you
  # accidentally delete configuration.nix.
  # system.copySystemConfiguration = true;

  # This option defines the first version of NixOS you have installed on this particular machine,
  # and is used to maintain compatibility with application data (e.g. databases) created on older NixOS versions.
  #
  # Most users should NEVER change this value after the initial install, for any reason,
  # even if you've upgraded your system to a new NixOS release.
  #
  # This value does NOT affect the Nixpkgs version your packages and OS are pulled from,
  # so changing it will NOT upgrade your system - see https://nixos.org/manual/nixos/stable/#sec-upgrading for how
  # to actually do that.
  #
  # This value being lower than the current NixOS release does NOT mean your system is
  # out of date, out of support, or vulnerable.
  #
  # Do NOT change this value unless you have manually inspected all the changes it would make to your configuration,
  # and migrated your data accordingly.
  #
  # For more information, see `man configuration.nix` or https://nixos.org/manual/nixos/stable/options#opt-system.stateVersion .
  system.stateVersion = "24.05"; # Did you read the comment?

}

