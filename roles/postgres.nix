{ pkgs, ...}:
{
    services.postgresql = {
      enable = true;
      dataDir = "/data/postgresql"
      ensureUsers = [
        { name = "irotnep"; ensureDBOwnership = true; }
      ];
      ensureDatabases = [
        "ghostfolio"
      ];
  };
}
