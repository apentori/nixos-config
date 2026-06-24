{ pkgs, ... }:

{
  environment.systemPackages = with pkgs; [
    flameshot
    # Sensors scans
    lm_sensors
    # Connect phones
    feishin yt-dlp id3v2
    ungoogled-chromium
    thunderbird
    pdftk # PDF modidification tools
    # Game dev
    godot_4 unityhub
    restic
  ];

}
