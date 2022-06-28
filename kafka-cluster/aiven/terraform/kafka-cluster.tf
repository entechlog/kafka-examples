# Kafka service
resource "aiven_kafka" "kafka-service" {
  project                 = upper(var.project_name) == "NONE" ? aiven_project.kafka.project : var.project_name
  cloud_name              = "aws-us-west-2"
  plan                    = "startup-2"
  service_name            = "epd-kafka"
  maintenance_window_dow  = "saturday"
  maintenance_window_time = "01:00:00"

  kafka_user_config {
    kafka_version = "3.1"

    kafka {
      group_max_session_timeout_ms = 70000
      log_retention_bytes          = 1000000000
      auto_create_topics_enable    = true
    }

    public_access {
      kafka_rest    = false
      kafka_connect = false
    }
  }
}

