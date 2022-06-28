module "msk_cluster" {
  source = "./modules"

  cluster_name           = var.cluster_name
  instance_type          = var.instance_type
  number_of_broker_nodes = var.number_of_broker_nodes
  kafka_version          = var.kafka_version
  volume_size            = var.volume_size

  vpc_id              = var.vpc_id
  subnet_id           = var.subnet_id
  access_allowed_cidr = var.access_allowed_cidr

  enhanced_monitoring = var.enhanced_monitoring

  prometheus_jmx_exporter  = var.prometheus_jmx_exporter
  prometheus_node_exporter = var.prometheus_node_exporter

  server_properties                   = var.server_properties
  encryption_in_transit_client_broker = var.encryption_in_transit_client_broker

  client_authentication = var.client_authentication

  tags = {
    Owner       = var.Owner
    Environment = "${upper(var.env_code)}"
    Component   = var.Component
  }
}