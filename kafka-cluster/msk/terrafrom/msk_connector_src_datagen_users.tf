// Datagen Connector

resource "aws_mskconnect_connector" "src_datagen_users" {
  name = "src-datagen-users"

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

  worker_configuration {
    arn      = aws_mskconnect_worker_configuration.default_config.arn
    revision = aws_mskconnect_worker_configuration.default_config.latest_revision
  }

  connector_configuration = {
    "connector.class"                = "io.confluent.kafka.connect.datagen.DatagenConnector",
    "key.converter"                  = "org.apache.kafka.connect.storage.StringConverter",
    "value.converter"                = "org.apache.kafka.connect.json.JsonConverter",
    "value.converter.schemas.enable" = "false",
    "kafka.topic"                    = "users",
    "quickstart"                     = "users",
    "max.interval"                   = 1000,
    "iterations"                     = 10000000,
    "tasks.max"                      = "1"
  }

  kafka_cluster {
    apache_kafka_cluster {
      bootstrap_servers = aws_msk_cluster.main.bootstrap_brokers_tls

      vpc {
        security_groups = [aws_security_group.sg.id]
        subnets         = aws_subnet.private_subnet.*.id
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

  log_delivery {
    worker_log_delivery {
      cloudwatch_logs {
        enabled   = true
        log_group = aws_cloudwatch_log_group.msk_connect.name
      }
    }
  }

}