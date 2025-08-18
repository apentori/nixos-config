{ pkgs, secret, ...}:
{
services.netdata = {
    enable = true;
    configDir."stream.conf" = pkgs.writeText "stream.conf" ''
      [stream]
      enabled = yes
      destination = localhost:1999
    '';
    };
services.netdata.package = pkgs.netdata.override {
  withCloudUi = true;
};
}
