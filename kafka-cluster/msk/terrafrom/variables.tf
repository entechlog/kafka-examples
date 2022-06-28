// Cluster
variable "cluster_name" {
  type        = string
  description = "(Required) Name of the MSK cluster"
}

variable "kafka_version" {
  type        = string
  description = "(Required) Specify the desired Kafka software version"
}

variable "number_of_broker_nodes" {
  type        = number
  description = "(Required) The desired total number of broker nodes in the kafka cluster"
}

variable "enhanced_monitoring" {
  type        = string
  description = "(Optional) Specify the desired enhanced MSK CloudWatch monitoring level"
}

variable "prometheus_jmx_exporter" {
  type        = string
  description = "(Optional) Configuration block for JMX Exporter"
}

variable "prometheus_node_exporter" {
  type        = string
  description = "(Optional) Configuration block for Node Exporter"
}

variable "client_authentication" {
  type = list(any)
}

// Broker
variable "instance_type" {
  type        = string
  description = "(Required) Specify the instance type to use for the kafka"
}

variable "volume_size" {
  type        = string
  description = "(Optional) The size in GiB of the EBS volume for the data drive on each broker node"
}

variable "vpc_id" {
  type        = string
  description = ""
}

variable "subnet_id" {
  type        = list(string)
  description = ""
}

variable "access_allowed_cidr" {
  type        = list(string)
  description = ""
}

variable "encryption_in_transit_client_broker" {
  type        = string
  description = "(Optional) Encryption setting for data in transit between clients and brokers. Valid values: TLS, TLS_PLAINTEXT, and PLAINTEXT"
}

// Tags

variable "Owner" {
  type        = string
  description = ""
}
variable "env_code" {
  type        = string
  description = ""
}
variable "Component" {
  type        = string
  description = ""
}

variable "server_properties" {
  type = map(string)
}