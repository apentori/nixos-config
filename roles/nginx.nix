{ config, ...}:
{
 networking.firewall.allowedTCPPorts = [ 443 80 ];

  security.acme.acceptTerms = true;
  security.acme.defaults.email = "irotnep@proton.me";
  services.nginx= {
    enable = true;
  }; 
}
