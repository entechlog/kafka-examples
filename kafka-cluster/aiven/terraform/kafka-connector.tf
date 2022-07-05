# Kafka connect service
resource "aiven_kafka_connector" "src_mongodb" {
  project        = upper(var.project_name) == "NONE" ? aiven_project.kafka.project : var.project_name
  service_name   = aiven_kafka_connect.kafka_connect.service_name
  connector_name = "src-mongodb"

  config = {
    "name" : "src-mongodb",
    "_aiven.restart.on.failure" : "true",
    "connector.class" : "com.mongodb.kafka.connect.MongoSourceConnector",
    "connection.uri" : "mongodb+srv://${var.mongodb_username}:${var.mongodbdb_password}@${var.mongodbdb_uri}",
    "database" : "sample_mflix"
  }
}