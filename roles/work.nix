{ pkgs, ... }:

{

   /* Required tools and libraries. */
  environment.systemPackages = with pkgs; [
    ccid opensc pcsctools
    pinentry

    terraform
  ];


  users.users.irotnep.packages = with pkgs; [
    # DevOps
    ansible_2_14
    # Security
    bitwarden #unstable.bitwarden-cli yubikey-manager
    # Network
    netcat websocat tcpdump whois
    # Cloud
    awscli s3cmd #unstable.doctl google-cloud-sdk
    scaleway-cli aliyun-cli hcloud

    # Utils
    jsonnet appimage-run 
    # Yubikye
    yubikey-agent
    yubikey-manager
    pinentry
  ];

  /* Required udev rules for YubiKey usage */
  services.udev.packages = with pkgs; [
    yubikey-personalization
    libu2f-host
  ];

  /* Necessary for GPG Agent. */
  services.pcscd.enable = true;
  hardware.gpgSmartcards.enable = false;

  # Enable GnuPG agent for keys.
  programs.gnupg.agent = {
    enable = true;
    enableSSHSupport = true;
    enableBrowserSocket = true;
    #pinentryFlavor = "gnome3";
    pinentryFlavor = "gtk2";
  };
} 
