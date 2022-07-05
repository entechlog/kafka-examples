resource "aws_glue_registry" "msk" {
  registry_name = var.cluster_name
}

resource "aws_glue_schema" "example_avro" {
  schema_name       = format("%s-avro-example", var.cluster_name)
  registry_arn      = aws_glue_registry.msk.arn
  data_format       = "AVRO"
  compatibility     = "NONE"
  schema_definition = <<PROPERTIES
{
  "name": "Example",
  "type": "record",
  "namespace": "com.acme.avro",
  "fields": [
    {
      "name": "name",
      "type": "string"
    },
    {
      "name": "age",
      "type": "int"
    }
  ]
}
PROPERTIES
}