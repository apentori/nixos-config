{ lib, secret, ...}:
{
    age.secrets."wifi"= {
      file = ../secrets/services/wifi/manoir.age;
      path = "/etc/wifi.conf";
    };
    networking.wireless = {
      enable = true;
      interfaces = [ "wlan0" ];
      secretsFile = "/etc/wifi.conf";
      networks= {
        "Livebox6-0600".pskRaw = "ext:psk_manoir";
      };
    };

}
