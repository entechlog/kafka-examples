# Kafka connect service
resource "aiven_kafka_connect" "kafka_connect" {
  project                 = upper(var.project_name) == "NONE" ? aiven_project.kafka.project : var.project_name
  cloud_name              = "aws-us-west-2"
  plan                    = "startup-4"
  service_name            = "epd-kafka-connect"
  maintenance_window_dow  = "saturday"
  maintenance_window_time = "01:00:00"

  kafka_connect_user_config {
    kafka_connect {
      consumer_isolation_level = "read_committed"
    }

    public_access {
      kafka_connect = true
    }
  }
}

// Kafka connect service integration
resource "aiven_service_integration" "kafka_service_integration" {
  project                  = upper(var.project_name) == "NONE" ? aiven_project.kafka.project : var.project_name
  integration_type         = "kafka_connect"
  source_service_name      = aiven_kafka.kafka-service.service_name
  destination_service_name = aiven_kafka_connect.kafka_connect.service_name

  kafka_connect_user_config {
    kafka_connect {
      group_id             = "connect"
      status_storage_topic = "__connect_status"
      offset_storage_topic = "__connect_offsets"
    }
  }
}