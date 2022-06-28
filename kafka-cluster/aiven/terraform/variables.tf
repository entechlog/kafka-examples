variable "aiven_api_token" {
  type      = string
  sensitive = true
}

variable "env_code" {
  type        = string
  description = "Environmental code to identify the target environment"
}

variable "project_code" {
  type        = string
  description = "Code to identify the project name"
}

variable "project_name" {
  type        = string
  default     = "NONE"
  description = "Existing project name"
}

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

