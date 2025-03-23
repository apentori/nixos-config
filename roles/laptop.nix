{ pkgs, ... }:

{
  environment.systemPackages = with pkgs; [
    # Monitors and Docks
    #displaylink
    # Sensors scans
    lm_sensors
    # Connect phones
    libsForQt5.kdeconnect-kde
    feishin yt-dlp id3v2
    ungoogled-chromium
    pdftk # PDF modidification tools
  ];
}
