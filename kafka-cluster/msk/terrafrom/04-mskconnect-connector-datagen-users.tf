resource "aws_mskconnect_connector" "datagen_users" {
  name = "datagen-users"

  kafkaconnect_version = "2.7.1"

  capacity {
    autoscaling {
      mcu_count        = 1
      min_worker_count = 1
      max_worker_count = 2

      scale_in_policy {
        cpu_utilization_percentage = 20
      }

      scale_out_policy {
        cpu_utilization_percentage = 80
      }
    }
  }

  connector_configuration = {
    "connector.class" = "io.confluent.kafka.connect.datagen.DatagenConnector",
    "key.converter"   = "org.apache.kafka.connect.storage.StringConverter",
    "kafka.topic"     = "users",
    "quickstart"      = "users",
    "max.interval"    = 1000,
    "iterations"      = 10000000,
    "tasks.max"       = "1"
  }

  kafka_cluster {
    apache_kafka_cluster {
      bootstrap_servers = module.msk_cluster.bootstrap_brokers_tls

      vpc {
        security_groups = [module.msk_cluster.default_security_group]
        subnets         = var.subnet_id
      }
    }
  }

  kafka_cluster_client_authentication {
    authentication_type = "NONE"
  }

  kafka_cluster_encryption_in_transit {
    encryption_type = "TLS"
  }

  plugin {
    custom_plugin {
      arn      = aws_mskconnect_custom_plugin.datagen.arn
      revision = aws_mskconnect_custom_plugin.datagen.latest_revision
    }
  }

  service_execution_role_arn = "arn:aws:iam::582805303120:role/dev-kakfa-service-role"

}