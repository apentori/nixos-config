{ pkgs, inputs, ... }:

{
  imports = [
    ./monitoring.nix
    ./docker.nix
    ./users.nix
    ./tailscale.nix
  ];
  environment.systemPackages = with pkgs; [
    # Utility
    file zsh bash man-pages sudo bc lsb-release uptimed
    zip unzip thefuck direnv oh-my-zsh
    # monitoring
    btop monitorets usbutils
    # Code
    neovim jq fzf silver-searcher git nodejs
    gcc mpv scdoc busybox
    # Networking
    wget curl nmap nettools traceroute dnsutils wirelesstools blueman wireguard-tools
    # file system
    ncdu zfs zfstools
    # security
    pass openssl
    # GPG
    gnupg gnupg1
    # backup
    rclone
    xdg-utils
    vimPlugins.LazyVim
    inputs.agenix.packages."${pkgs.system}".default
    firefox
    nerdfetch
  ];

  fonts.packages = with pkgs; [
    meslo-lgs-nf
    nerd-fonts.fira-code
    fira-code-symbols
  ];
  # Shell
  programs.zsh.enable = true;
  users.defaultUserShell = pkgs.zsh;

  programs.fzf = {
    keybindings = true;
    fuzzyCompletion = true;
  };
  # Editor
  programs.neovim = {
    enable = true;
    viAlias = true;
    vimAlias = true;
    defaultEditor = true;
  };

    # Editor
  environment.variables = {
    EDITOR = "nvim";
    VISUAL = "nvim";
  };

  # Uptime tracker
  services.uptimed.enable = true;
  services.openssh = {
    enable = true;
  };

  programs.zsh.ohMyZsh = {
    enable = true;
    theme = "blinks";
  };

  }
