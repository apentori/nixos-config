# Edit this configuration file to define what should be installed on
# your system. Help is available in the configuration.nix(5) man page
# and in the NixOS manual (accessible by running ‘nixos-help’).

{ config, pkgs, ... }:

{
  imports =
    [
      ./hardware-configuration.nix
      ../../roles/users.nix
      ../../roles/default.nix
      ../../roles/servers.nix
      ../../roles/go-ethereum.nix
      ../../roles/nimbus-eth2.nix
      ../../roles/grafana.nix
      ../../roles/loki.nix
      ../../roles/nextcloud.nix
      ../../roles/nginx.nix
    ];
  boot.loader.grub = {
    enable = true;
    zfsSupport = true;
    efiSupport = true;
    forceInstall = true;
    #efiInstallAsRemovable = true;
    mirroredBoots = [
      { devices = [ "/dev/disk/by-id/ata-HGST_HUS726T4TALA6L1_V6H00B9S"]; path = "/boot1"; }
      { devices = [ "/dev/disk/by-id/ata-HGST_HUS726T4TALA6L1_V1JUHSKH"]; path = "/boot2"; }
    ];
  };
  i18n = {
    defaultLocale = "en_US.UTF-8";
  };
  # Set your time zone.
  time.timeZone = "Europe/Paris";

  networking = {
    hostName = "hyperion";
    hostId = "8425e349";
    interfaces.eth0.ipv4.addresses = [{
      address = "149.202.75.222";
      prefixLength = 24;
    }];
    defaultGateway = "149.202.75.254";
    nameservers = ["8.8.8.8"];
  };

  systemd.tmpfiles.rules = [
    "d /data/geth/data 760 irotnep ethereum"
  ];

  # Enable the OpenSSH daemon.
  services.openssh = {
    enable = true;
    settings = {
      PasswordAuthentication = true;
      AllowUsers = [ "irotnep" ];
      UseDns = true;
    };
  };
  # Open ports in the firewall.
  networking.firewall = {
    allowedTCPPorts = [ 22 ];
    enable = true;
  };

  nix.settings = {
    trusted-users = ["root" "irotnep" ];
    experimental-features = [ "nix-command" "flakes" ];
  };

  system.stateVersion = "24.05"; # Did you read the comment?

}

