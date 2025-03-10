{pkgs, config, ...}:
{
  age.secrets."wireguard/private-key" = {
    file = ../secrets/services/wireguard/private-key.age;
    path = "/etc/wireguard/private";
  };

  networking.firewall = {
    allowedUDPPorts = [ 51820 ]; # Clients and peers can use the same port, see listenport
  };

  networking.wireguard.interfaces = {
    wg0 = {
      ips = [ "10.100.0.2/24" ];
      listenPort = 51820;
      privateKeyFile = "/etc/wireguard/private";

      peers = [
        { # Feel free to give a meaning full name
          publicKey = "wireguard-public-key";
          # List of IPs assigned to this peer within the tunnel subnet. Used to configure routing.
          allowedIPs = [ "10.100.0.1/32" ];
          endpoint = "149.202.75.222:51820";
          persistentKeepalive = 25;
        }
      ];
    };
  };
}
