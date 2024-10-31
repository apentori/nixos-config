{ pkgs, ... }:
{
  services.loki= {
    enable = true;
    configFile = ../files/loki/config.yml;
    };
  #services.grafana.provision.datasources = [{
  #  name = "loki";
  #  type = "loki";
  #  url = "localhost:3030";
  #}];
}
