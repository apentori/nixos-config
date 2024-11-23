{ pkgs, ...}:
{
  virtualisation.docker = {
    enable = true;
    rootless = {
      enable = true;
      setSocketVariable = true;
    };
    daemon.settings = {
      data-root = "/docker";
    };
  };
  users.extraGroups.docker.members = [ "irotnep" ];

}
