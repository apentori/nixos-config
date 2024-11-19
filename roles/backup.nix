{ pkgs, lib, config, ... }:

let
  services = config.services;
in {
  imports = [
    ../services/backup.nix
  ];
  config = let
    cfg = config.backup;
  in {
    services.backup.enable = true;
  };
}
