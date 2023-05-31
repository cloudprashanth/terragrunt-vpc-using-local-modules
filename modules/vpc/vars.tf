variable "project_name" {
  description = "Name of the Project"
  default     = "pg"
}

variable "env" {
  description = "Name of the environment"
}

variable "vpc_main_cidr" {
  description = "Provide the CIDR block of VPC"
  default     = "10.0.0.0/18"
}

variable "instance_tenancy" {
  description = "Details of the tenancy for the services to be deployed"
  default     = "default"
}
