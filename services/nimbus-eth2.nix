{ config, lib, pkgs, ... }:

let
  inherit (lib)
    types mkEnableOption mkOption mkIf length
    escapeShellArgs literalExpression toUpper
    boolToString concatMapStringsSep optionalString optionalAttrs ;

  cfg = config.services.nimbus-eth2;
in {
  options = {
    services = {
      nimbus-eth2 = {
        enable = mkEnableOption "Nimbus Eth2 Beacon Node service.";

        package = mkOption {
          type = types.package;
          default = pkgs.callPackage ../packages/nimbus-eth2.nix { };
          defaultText = literalExpression "pkgs.go-ethereum.geth";
          description = lib.mdDoc "Package to use as Go Ethereum node.";
        };
        service = {
          user = mkOption {
            type = types.str;
            default = "nimbus";
            description = "Username for Nimbus Eth2 service.";
          };
          group = mkOption {
            type = types.str;
            default = "nimbus";
            description = "Group name for Nimbus Eth2 service.";
          };
        };
        network = mkOption  {
          type  = types.str;
          default = "holesky";
          description = "Name of Ethereum network";
        };
        numThreat = mkOption {
          type = types.int;
          default = 2;
          description = "Number of threat allocated to Nimbus";
        };
        listenPort = mkOption {
          type = types.int;
          default = 9000;
          description = "Port for TCP P2P connection to the server";
        };
        discoverPort = mkOption {
          type = types.int;
          default = 9000;
          description = "Port for UDP P2P connection to the server";
        };
        el = mkOption {
          type =  types.str;
          default = "";
          description = "URL of Execution Layer";
        };
        feeRecipient = mkOption {
          type =  types.str;
          default = "";
          description = "Recipient fees";
        };
        rest = {
          enable = lib.mkEnableOption "Nimbus Eth2 REST API";
          port = mkOption {
            type = types.int;
            default= 5052;
            description  = "REST port for Nimbus";
          };
          address = mkOption {
            type = types.str;
            default = "127.0.0.1";
            description = "Host name for Nimbus REST API";
          };
        };
        metrics = {
          enable = lib.mkEnableOption "Nimbus Eth2 Metrics";
          port = mkOption {
            type = types.int;
            default= 5052;
            description  = "Port for Nimbus Metrics ";
          };
          address = mkOption {
            type = types.str;
            default = "127.0.0.1";
            description = "Host name for Nimbus Metrics";
          };
        };
        log = {
          level = mkOption {
            type = types.str;
            default = "Info";
            description = "Level of log for Nimbus";
          };
          format = mkOption {
            type = types.str;
            default = "json";
            description = "Format of log for Nimbus";
          };
        };
        dataDir= mkOption {
          type = types.str;
          default = "/nimbus";
          description = "Base directory for Nimbus";
        };
        jwtSecret = mkOption {
          type = types.str;
          default="/nimbus/jwtSecret";
          description = "Path Of jwtSecret for geth API";
        };
        trustedNode = mkOption {
          type = types.str;
          default="";
          description = "Address of a trustedNode";
        };
        extraArgs = mkOption {
          type = types.listOf types.str;
          default= [];
          description = "Extra argument for Nimbus";
        };
      };
    };
  };

  config = mkIf cfg.enable {
    users.users = optionalAttrs (cfg.service.user == "nimbus") {
      nimbus = {
        group = cfg.service.group;
        home = cfg.dataDir;
        uid = 5000;
        description = "Nimbus Eth2 service user";
        isSystemUser = true;
      };
    };

    users.groups = optionalAttrs (cfg.service.user == "nimbus") {
      nimbus = {
        gid = 5000;
      };
    };
    systemd.services.nimbus-eth2 = {
      enable = true;
      serviceConfig = {
        User = cfg.service.user;
        Group = cfg.service.group;

        ExecStart = ''
          ${cfg.package}/bin/nimbus_beacon_node \
            --network=${cfg.network} \
            --data-dir=${cfg.dataDir} \
            --log-level=${cfg.log.level} \
            --log-format=${cfg.log.format} \
            --tcp-port=${toString cfg.listenPort} \
            --udp-port=${toString cfg.discoverPort} \
            --rest \
            --rest=${boolToString cfg.rest.enable} ${optionalString cfg.rest.enable ''--rest-address=${cfg.rest.address} --rest-port=${toString cfg.rest.port} ''} \
            --metrics=${boolToString cfg.metrics.enable} ${optionalString cfg.metrics.enable ''--metrics-address=${cfg.metrics.address} --metrics-port=${toString cfg.metrics.port} ''} \
            ${if cfg.el != "" then "--el=${cfg.el}" else "--no-el"} \
            --jwt-secret=${cfg.jwtSecret} \
            --suggested-fee-recipient=${cfg.feeRecipient} \
            ${if cfg.el != "" then "--web3-url=${cfg.el}" else ""} \
            ${escapeShellArgs cfg.extraArgs}
            '';
        Restart = "on-failure";
      };
      wantedBy = [ "multi-user.target" ];
      requires = [ "network.target" ];
    };
  };
}
