resource "aws_cloudwatch_log_group" "msk" {
  name = var.cluster_name
  tags = var.tags
}