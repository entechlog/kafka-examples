resource "aws_vpc" "data" {
  count                = var.use_current_vpc == true ? 0 : 1
  cidr_block           = var.vpc_cidr_block
  instance_tenancy     = "default"
  enable_dns_support   = true
  enable_dns_hostnames = true
  tags                 = var.tags
}