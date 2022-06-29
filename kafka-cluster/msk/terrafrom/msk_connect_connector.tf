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
      bootstrap_servers = aws_msk_cluster.main.bootstrap_brokers_tls

      vpc {
        security_groups = [aws_security_group.sg.id]
        subnets         = var.vpc_subnets
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
        log_group = aws_cloudwatch_log_group.msk.name
      }
    }
  }

}

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
        subnets         = var.vpc_subnets
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
        log_group = aws_cloudwatch_log_group.msk.name
      }
    }
  }

}