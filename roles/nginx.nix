{ config, ...}:
{
  networking.firewall.allowedTCPPorts = [ 443 80 ];

  systemd.tmpfiles.rules = [
    "d /etc/nginx 0760 nginx nginx"
  ];

  security.acme.acceptTerms = true;
  security.acme.defaults.email = "irotnep@proton.me";
  services.nginx= {
    enable = true;
  };
}
