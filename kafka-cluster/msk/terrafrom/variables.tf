variable "env_code" {
  default = "dev"
}

variable "cluster_name" {
  default = "msk-cluster"
}

variable "aws_region" {
  default = "us-east-1"
}

variable "use_current_vpc" {
  default = true
}

variable "current_vpc_id" {
  default = ""
}

variable "current_vpc_subnets" {
  default = [""]
}

variable "vpc_cidr_block" {
  description = "Specify the vpc CIDR block"
  type        = string
  default     = "172.32.0.0/16"
}

variable "private_subnet_cidr_block" {
  type        = list(any)
  description = "CIDR block for Private Subnet"
  default     = ["172.32.0.0/22", "172.32.4.0/22", "172.32.8.0/22"]
}

variable "public_subnet_cidr_block" {
  default = "172.32.12.0/22"
}

variable "public_subnet_availability_zone" {
  default = "us-east-1a"
}

variable "kafka_version" {
  default = "3.2.0"
}

variable "brokers_count" {
  default = 3
}

variable "broker_instance_type" {
  default = "kafka.t3.small"
}

variable "broker_ebs_volume_size" {
  default = 100
}

variable "kafka_unauthenticated_access_enabled" {
  default = true
}

variable "kafka_sasl_scram_auth_enabled" {
  default = true
}

variable "kafka_sasl_iam_auth_enabled" {
  default = true
}

variable "kafka_sasl_scram_auth_configs" {
  default = {
    username = "foo",
    password = "uswgbhdaubhdaiubhdhauvdea"
  }
  sensitive = true
}

variable "open_monitoring" {
  default = true
}

variable "tags" {
  default = {
    Owner = "Entechlog"
  }
}

// MongoDB
variable "mongodbdb_uri" {
  description = "MongoDB database uri"
  type        = string
}

variable "mongodb_username" {
  description = "MongoDB database username"
  type        = string
  sensitive   = true
}

variable "mongodbdb_password" {
  description = "MongoDB database password"
  type        = string
  sensitive   = true
}

variable "mongodb_vpce_service_name" {
  description = "MongoDB Atlas Endpoint Service	Name"
  type        = string
  sensitive   = true
}

// Snowflake
variable "snowflake_url_name" {
  description = "Snowflake database uri"
  type        = string
}

variable "snowflake_user_name" {
  description = "Snowflake database username"
  type        = string
  sensitive   = true
}

variable "snowflake_private_key" {
  description = "Snowflake private key"
  type        = string
  sensitive   = true
}

variable "snowflake_private_key_passphrase" {
  description = "Snowflake private key passphrase"
  type        = string
  sensitive   = true
}