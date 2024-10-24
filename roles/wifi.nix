{ lib, secret, ...}:

{
    age.secrets."wifi"= {
      file = ../secrets/services/wifi/manoir.age;
      path = "/etc/wifi.env";
    };
    networking.wireless = {
      enable = true;
      interfaces = [ "wlan0" ];
      environmentFile = "/etc/wifi.env";
      networks."@SSID@".psk = "@PASS@";
    };

}
