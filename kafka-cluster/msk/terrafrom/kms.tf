resource "aws_kms_key" "kms" {
  description = var.cluster_name
  tags        = var.tags
}