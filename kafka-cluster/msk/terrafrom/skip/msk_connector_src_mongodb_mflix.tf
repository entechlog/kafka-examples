// MongoDB Connector

resource "aws_mskconnect_connector" "src_mongodb_mflix" {
  name = "src-mongodb-mflix"

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
    "connector.class" = "com.mongodb.kafka.connect.MongoSourceConnector",
    "connection.uri"  = "mongodb+srv://${var.mongodb_username}:${var.mongodbdb_password}@${var.mongodbdb_uri}/",
    "database"        = "sample_mflix"
    "tasks.max"       = "1"
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
      arn      = aws_mskconnect_custom_plugin.mongodb.arn
      revision = aws_mskconnect_custom_plugin.mongodb.latest_revision
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