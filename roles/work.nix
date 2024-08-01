{ pkgs, ... }:

let
  # For details see: https://nixos.wiki/wiki/Python
  myPythonPkgs = _: with (pkgs.python311Packages); [
    ipython pip
    # Development
    setuptools retry yapf mohawk grip pyyaml jinja2
    # Devops
    boto3 wakeonlan PyGithub python-hosts cloudflare
    # Security
    pyopenssl cryptography passlib
    # Databases
    elasticsearch elastic-transport psycopg2
    # Statistics
    matplotlib pandas seaborn
    # Misc
    sh backoff psutil
    ansible-core
    hvac
  ];
  myPython = pkgs.python311.withPackages myPythonPkgs;

in {
   /* Required tools and libraries. */
  environment.systemPackages = with pkgs; [
    ccid opensc pcsctools
    gnumake
    terraform
    ripgrep
    docker docker-compose
    marp-cli
    pinentry
  ];

  users.users.irotnep.packages = with pkgs; [
    # DevOps
    ansible
    # Security
    bitwarden bitwarden-cli 
    # Matrix client fallback communication
    element-web
    # Network
    netcat websocat tcpdump whois
    # Cloud
    awscli s3cmd #unstable.doctl google-cloud-sdk
    scaleway-cli aliyun-cli hcloud
    # Python dev
    myPython
    # Utils
    jsonnet appimage-run 
    # Yubikey
    yubikey-agent yubikey-manager pinentry 
    vagrant
    vault
    zeal
  ];
  users.users.irotnep.extraGroups = [ "docker" ];
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
    #pinentryFlavor = "gtk2";
  };
  virtualisation.docker.enable = true;
} 
