{ config, lib, pkgs, ... }:

let
  inherit (lib)
    types mkEnableOption mkOption mkIf length
    optionalString optionalAttrs;

  cfg = config.services.backup;

in {
  options = {
    services = {
      backup = {
        enable = mkEnableOption "Backup Service";
      };
      user = mkOption {
        type = types.str;
        default = "irotnep";
      };
      group = mkOption {
        type = types.str;
        default = "irotnep";
      };
    };
  };
  config = mkIf cfg.enable {
    systemd.user.extraConfig = ''
      DefaultEnvironment="PATH=/run/current-system/sw/bin"
    '';
    systemd.services.backup = {
      enable = true;
      serviceConfig = {
        User = "irotnep";
        Restart = "on-failure";
        ExecStart = ''
          /home/irotnep/bin/backup.sh
        '';
      };
      wantedBy = [ "multi-user.target" ];
    };
    systemd.timers.backup = {
      wantedBy = [ "multi-user.target" ];
      timerConfig = {
        OnBootSec = "5m";
        OnUnitActiveSec = "5m";
        Unit = "backup.service";
        OnCalendar = "daily";
        Persistent = true;
      };
    };
  };

}
