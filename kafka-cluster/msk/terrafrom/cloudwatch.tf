resource "aws_cloudwatch_log_group" "msk" {
  name = "/${lower(var.env_code)}/msk/kafka-cluster"
  tags = var.tags
}

resource "aws_cloudwatch_log_group" "msk_connect" {
  name = "/${lower(var.env_code)}/msk/kafka-connect"
  tags = var.tags
}