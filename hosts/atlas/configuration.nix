{ config, pkgs, secrets, ... }:
{
  imports =
    [
      ./hardware-configuration.nix
      ../../roles/environment
      ../../roles/infra/backup.nix
    ];

  boot.loader.systemd-boot.enable = true;
  boot.loader.efi.canTouchEfiVariables = true;


  networking = {
    hostName = "atlas";
    hostId = "8425e349";
    networkmanager.enable = true;
  };

  i18n = {
    defaultLocale = "en_US.UTF-8";
    extraLocaleSettings = {
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
  };
  environment.systemPackages = with pkgs; [
    networkmanager
  ];

  time.timeZone = "Europe/Madrid";

  # Enable the OpenSSH daemon.
  services.openssh = {
    enable = true;
    settings = {
      #PasswordAuthentication = false;
      AllowUsers = [ "irotnep" ];
      UseDns = true;
    };
  };

  nix.settings = {
    trusted-users = ["root" "irotnep" ];
    experimental-features = [ "nix-command" "flakes" ];
  };

  nixpkgs = {
    config = {
      allowUnfree = true;
      permittedInsecurePackages = [
        "docker-28.5.2"
      ];
    };
  };

  system.stateVersion = "25.05";
}
