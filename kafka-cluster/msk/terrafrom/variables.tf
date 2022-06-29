variable "env_code" {
  default = "dev"
}

variable "cluster_name" {
  default = "msk-cluster"
}

variable "aws_region" {
  default = "us-east-1"
}

variable "vpc_id" {
  default = ""
}

variable "vpc_subnets" {
  default = [""]
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

// Sensitive

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
