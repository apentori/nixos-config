{ pkgs, ...}:
{
    services.postgresql = {
      enable = true;
      dataDir = "/data/postgresql";
      ensureDatabases = [
        "local"
      ];
      ensureUsers = [
        { name = "irotnep"; ensureDBOwnership = true; }
      ];
  };
}
