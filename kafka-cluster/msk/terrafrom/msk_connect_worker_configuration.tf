resource "aws_mskconnect_worker_configuration" "default_config" {
  name                    = "default-config"
  properties_file_content = <<EOT
key.converter=org.apache.kafka.connect.storage.StringConverter
value.converter=org.apache.kafka.connect.storage.StringConverter
offset.storage.topic=__consumer_offsets
EOT
}