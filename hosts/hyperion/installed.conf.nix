{ config, pkgs, ... }:

{
  imports =
    [
      ./hardware-configuration.nix
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

users.users = {
    irotnep = {
      isNormalUser = true;
      openssh.authorizedKeys.keys = [
        "ssh-rsa AAAAB3NzaC1yc2EAAAADAQABAAACAQDHb8ORNUIJkwUACMl59CvbqJJ2dFVL2QYDtJhAgehKRQSW87nU2GtAc/23ncC7BsDJMolAare3gDODpcfxlDcrHOG6O9FQmakEY0AMRO0Wk4uJHRCCPjxyYLoRUNKOUjmpY6JEG+ZzKjRGqMcvH19PmzUOkR2thdJBJ8tluXEk/UraFoSJUcA8dRxou2o9jdLtTPJIRyZNkhiRXrnD+8rD6a+VqM2JWqTqg/Mgj6EaZHyXcg2xAtXHEbVl5MIAbWPwCz2DjVNp52dEe3GyUFdlFr8Rp7TVPfA8qe+hbrs2V+ubdgEAFxQBfsSoY9UPjhdO8Yl3nhqNvXOKRTQ+EJLdlGobJUG2blrAyleyREomSixOIf6LM6HwdRxPz1QzGf8kKvqyIWtzR/s7xoV3ELLTzxyrUZF9yLrRYbdlqnxIKErb6lrwB3WUIAaT7ZQdJpRZvM5kNPg3Z2ZQZzs7SdQ/d3N4CYptr+mXHOze2cazE6DYyCshk9E4C70pBMejfaRM8RCjky6jDkODNKvu9sJXtKHyX7QceSnK83jPE/1taDLhOfFxezcqSNATtATENd8D6ulTTxflWU+cxfsCEoAUIaat5ORINYFsLlxdf3VUAKZNNmWiEB7cWKzdXbiRuqSpTAyuIxdFpFCe3GrM2R+LunsEmx/qWsDyhYjU0t7C7w== irotnep@proton.me"
      ];
      extraGroups = ["wheel" "networkmanager" "nimbus" "geth"];
    };
  };
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
    services.openssh = {
    enable = true;
    settings = {
      PasswordAuthentication = true;
      AllowUsers = [ "irotnep" "root" ];
      UseDns = true;
    };
  };

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
