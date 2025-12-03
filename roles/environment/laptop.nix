{ pkgs, ... }:

{
  environment.systemPackages = with pkgs; [
    flameshot
    # Sensors scans
    lm_sensors
    # Connect phones
    feishin yt-dlp id3v2
    ungoogled-chromium
    pdftk # PDF modidification tools
    # Game dev
    godot_4
    # Security
    #clamav clamtk
  ];

 # services.clamav = {
 #   daemon.enable=true;
 #   updater = {
 #     enable = true;
 #     frequency = 1;
 #     interval = "daily";
 #     };
 #   scanner.enable= true;
 # };
}
