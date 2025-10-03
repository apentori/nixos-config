# Edit this configuration file to define what should be installed on
# your system. Help is available in the configuration.nix(5) man page
# and in the NixOS manual (accessible by running ‘nixos-help’).

{ config, pkgs, secrets, ... }:

{
  imports =
    [
      ./hardware-configuration.nix
      ../../roles/users.nix
      ../../roles/default.nix
      ../../roles/docker.nix
      ../../roles/servers.nix
      ../../roles/grafana.nix
      ../../roles/loki.nix
      ../../roles/ghostfolio.nix
      ../../roles/nginx.nix
      ../../roles/media.nix
      ../../roles/headscale.nix
      ../../roles/tailscale.nix
      ../../roles/monitoring.nix
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
      { devices = [ "/dev/disk/by-id/ata-HGST_HUS726T4TALA6L1_V1HML8LH"]; path = "/boot3"; }
      { devices = [ "/dev/disk/by-id/ata-HGST_HUS726T4TALA6L1_V6GMXTYS"]; path = "/boot4"; }
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
    allowedTCPPorts = [ 22 51820 ];
    enable = true;
  };

  nix.settings = {
    trusted-users = ["root" "irotnep" ];
    experimental-features = [ "nix-command" "flakes" ];
  };

  nixpkgs = {
    config = {
      allowUnfree = true;
      permittedInsecurePackages = [
      "python3.11-youtube-dl-2021.12.17"
      ];
    };
  };


  system.stateVersion = "24.05"; # Did you read the comment?

}

