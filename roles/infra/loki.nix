{ pkgs, ... }:
let
  basePath = "/data/loki";
in {
  systemd.tmpfiles.rules = [
    "d ${basePath} 0750 loki loki"
  ];

  services.loki= {
    enable = true;

    configuration = {
      server.http_listen_port = 3030;
      auth_enabled = false;
      common = {
        instance_addr = "127.0.0.1";
        storage = {
          filesystem= {
            chunks_directory = "${basePath}/chunks";
            rules_directory = "${basePath}/rules";
          };
        };
        replication_factor = 1;
        ring.kvstore.store = "inmemory";
      };

      query_range.results_cache.cache.embedded_cache = {
        enabled= true;
        max_size_mb= 100;
      };

      schema_config.configs = [{
          from = "2020-10-24";
          store = "tsdb";
          object_store = "filesystem";
          schema = "v13";
          index = { prefix = "index_"; period = "24h";};
      }];

      storage_config = {
        tsdb_shipper = {
          active_index_directory = "${basePath}/tsdb-shipper-active";
          cache_location = "${basePath}/tsdb-shipper-cache";
          cache_ttl = "24h";
        };

        filesystem = {
          directory = "${basePath}/chunks";
        };
      };

      limits_config = {
        reject_old_samples = true;
        reject_old_samples_max_age = "168h";
        ingestion_rate_mb = 32;
        retention_period = "4320h";
        allow_structured_metadata = false;
        max_entries_limit_per_query = 20000;
        tsdb_max_query_parallelism = 128;
        split_queries_by_interval = "10m";

      };
      table_manager = {
        retention_deletes_enabled = false;
        retention_period = "0s";
      };

      query_scheduler = {
        max_outstanding_requests_per_tenant = 32768;
      };


      querier = {
        max_concurrent = 2;
        #split_queriers_by_interval = "5m";
      };

      compactor = {
        working_directory = "${basePath}/compactor";
        retention_enabled = true;
        # Wait time after marking chunks for retention deletion
        retention_delete_delay = "5m";
        # Allow time to cancel a manual log deletion request
        delete_request_cancel_period = "5m";
        retention_delete_worker_count = 150;
        delete_request_store = "filesystem";
        compaction_interval = "10m";
        compactor_ring = {
          kvstore = {
            store = "inmemory";
          };
        };
      };
    };
  };
}
