resource "aws_s3_bucket" "kafka_plugin" {
  bucket = "${lower(var.env_code)}-entechlog-kafka"
}

resource "aws_s3_bucket_acl" "kafka_plugin_acl" {
  bucket = aws_s3_bucket.kafka_plugin.id
  acl    = "authenticated-read"
}

// MongoDB Connector

resource "aws_s3_object" "mongodb" {
  bucket = aws_s3_bucket.kafka_plugin.id
  key    = "connect/plugins/mongo-kafka-connect-1.7.0-all.jar"
  source = "./connect/plugins/mongo-kafka-connect-1.7.0-all.jar"
}

resource "aws_mskconnect_custom_plugin" "mongodb" {
  name         = "mongodb-1-7-0"
  content_type = "JAR"
  location {
    s3 {
      bucket_arn     = aws_s3_bucket.kafka_plugin.arn
      file_key       = aws_s3_object.mongodb.key
      object_version = "null"
    }
  }
}

// Datagen Connector

resource "aws_s3_object" "datagen" {
  bucket = aws_s3_bucket.kafka_plugin.id
  key    = "connect/plugins/confluentinc-kafka-connect-datagen-0.5.3.zip"
  source = "./connect/plugins/confluentinc-kafka-connect-datagen-0.5.3.zip"
}

resource "aws_mskconnect_custom_plugin" "datagen" {
  name         = "datagen-0-5-3"
  content_type = "ZIP"
  location {
    s3 {
      bucket_arn     = aws_s3_bucket.kafka_plugin.arn
      file_key       = aws_s3_object.datagen.key
      object_version = "null"
    }
  }
}

// Snowflake Connector

resource "aws_s3_object" "snowflake" {
  bucket = aws_s3_bucket.kafka_plugin.id
  key    = "connect/plugins/snowflake-kafka-connector-1.8.0.zip"
  source = "./connect/plugins/snowflake-kafka-connector-1.8.0.zip"
}

resource "aws_mskconnect_custom_plugin" "snowflake" {
  name         = "snowflake-1-8-0"
  content_type = "ZIP"
  location {
    s3 {
      bucket_arn     = aws_s3_bucket.kafka_plugin.arn
      file_key       = aws_s3_object.snowflake.key
      object_version = "null"
    }
  }
}