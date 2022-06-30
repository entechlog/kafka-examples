resource "aws_vpc_endpoint" "mongodb" {
  vpc_id             = var.use_current_vpc == true ? var.current_vpc_id : aws_vpc.data[0].id
  subnet_ids         = var.current_vpc_subnets
  service_name       = var.mongodb_vpce_service_name
  vpc_endpoint_type  = "Interface"
  security_group_ids = [aws_security_group.sg.id]
  //  private_dns_enabled = true
}