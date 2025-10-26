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
  virtualisation.oci-containers.backend = "docker";

  users.extraGroups.docker.members = [ "irotnep" ];

}
