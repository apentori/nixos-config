{ pkgs, secret, ... }:
{
  age.secrets."tandoor-secret-key" = {
    file = ../../secrets/services/tandoor/secret-key.age;
    path = "/etc/tandoor-secret-key";
  };


  users.groups.nextcloud.members = [ "irotnep" ];

  services.tandoor-recipes = {
    enable = true;
    package = pkgs.tandoor-recipes;
    extraConfig = {
      SECRET_KEY_FILE=/etc/tandoor-secret-key;
    };
    port = 8020;
  };
  services.nginx.virtualHosts."tandoor.irotnep.net" = {
   addSSL = true;
   enableACME = true;
   locations."/" = {
     proxyPass = "http://localhost:8020";
     proxyWebsockets = true;
     recommendedProxySettings = true;
    };
  };

}
