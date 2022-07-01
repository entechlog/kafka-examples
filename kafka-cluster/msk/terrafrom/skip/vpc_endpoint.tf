resource "aws_vpc_endpoint" "mongodb" {
  vpc_id             = aws_vpc.data.id
  subnet_ids         = aws_subnet.private_subnet.*.id
  service_name       = var.mongodb_vpce_service_name
  vpc_endpoint_type  = "Interface"
  security_group_ids = [aws_security_group.sg.id]
  //  private_dns_enabled = true
}

output "mongodb_vpc_endpoint_id" {
  description = "VPC Endpoint ID for MongoDB"
  value       = aws_vpc_endpoint.mongodb.id
}