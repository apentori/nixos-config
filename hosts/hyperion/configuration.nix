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
      ../../roles/nextcloud.nix
      ../../roles/ghostfolio.nix
      ../../roles/nginx.nix
      ../../roles/media.nix
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
  # Wireguard config
#  age.secrets = {
#    "wireguard/private-key" = {
#      file = ../../secrets/services/wireguard/private-key.age;
#      path = "/etc/wireguard/private";
#    };
#  };
#
#  networking.wireguard.interfaces = {
#    wg0 = {
#      ips = [ "10.100.0.1/24" ];
#      listenPort = 51820;
#      privateKeyFile = "/etc/wireguard/private";
#      postSetup = ''
#        ${pkgs.iptables}/bin/iptables -t nat -A POSTROUTING -s 10.100.0.0/24 -o eth0 -j MASQUERADE
#      '';
#
#      # This undoes the above command
#      postShutdown = ''
#        ${pkgs.iptables}/bin/iptables -t nat -D POSTROUTING -s 10.100.0.0/24 -o eth0 -j MASQUERADE
#      '';
#      peers = [
#        # List of allowed peers.
#        { # Feel free to give a meaning full name
#          publicKey = "wireguard-public-key";
#          allowedIPs = [ "10.100.0.2/32" ];
#        }
#      ];
#    };
#  };


  nix.settings = {
    trusted-users = ["root" "irotnep" ];
    experimental-features = [ "nix-command" "flakes" ];
  };

  nixpkgs.config.permittedInsecurePackages = [
    "python3.11-youtube-dl-2021.12.17"
  ];

  system.stateVersion = "24.05"; # Did you read the comment?

}

