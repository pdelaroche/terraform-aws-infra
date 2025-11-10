variable "region" {
  description = "The AWS region to deploy resources in"

  type = string
}

variable "env_01" {
  description = "The deployment environment"
  type        = string
}

variable "vpc_cidr" {
  description = "The CIDR block for the VPC"
  type        = string
}

# variable "bastion_public_ip" {
#   type = list(string)
#   default = []
# }