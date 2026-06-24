{ config, pkgs, secrets, ... }:
{
  imports =
    [
      ./hardware-configuration.nix
      ../../roles/environment
      ../../roles/infra/backup.nix
      ../../roles/infra/promtail.nix
    ];

  boot.loader.systemd-boot.enable = true;
  boot.loader.efi.canTouchEfiVariables = true;

 # Load the NVIDIA kernel module
  boot.kernelModules = [ "nvidia" ];
  boot.extraModprobeConfig = ''
    options nvidia-drm modeset=1
  '';

  hardware.graphics = {
    enable = true;
    enable32Bit = true; # Required for 32-bit games (Steam, Wine, etc.)
  };
  hardware.nvidia = {
    powerManagement.enable = false;
    powerManagement.finegrained = false;

    # CRITICAL: GM107 (Maxwell) does NOT support the open-source kernel module.
    open = false;
    # Enable the Nvidia settings menu (nvidia-settings)
    nvidiaSettings = true;
    # Use the stable production driver branch
    package = config.boot.kernelPackages.nvidiaPackages.stable;
  };
  networking = {
    hostName = "atlas";
    hostId = "8425e349";
    networkmanager.enable = true;
    interfaces.eth0.useDHCP = true;
  };
  systemd.services.NetworkManager.wantedBy = [ "multi-user.target" ];

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
