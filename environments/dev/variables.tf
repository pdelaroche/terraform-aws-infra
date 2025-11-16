variable "region" {
  description = "The AWS region to deploy resources in"
  type        = string
  validation {
    condition     = var.region == "eu-west-1"
    error_message = "The region must be 'eu-west-1' for the dev environment"
  }
}

variable "env_01" {
  description = "The deployment environment"
  type        = string
  validation {
    condition     = var.env_01 == "dev"
    error_message = "The env_01 must be 'dev' for the dev environment"
  }

}

variable "vpc_cidr" {
  description = "The CIDR block for the VPC"
  type        = string
  validation {
    condition     = var.vpc_cidr == "172.16.0.0/16"
    error_message = "The vpc_cidr must be '172.16.0.0/16' for the dev environment"
  }
}

variable "bastion_public_ip" {
  description = "Public IP for bastion host (optional)"
  type        = string
  default     = null
}

# variable "private_subnets" {
#   description = "Lista de subnets privadas donde se crearán los web servers"
#   type        = list(string)
# }

# variable "public_subnets" {
#   description = "Lista de subnets públicas donde se creará el bastion host"
#   type        = list(string)
# }

variable "web_instance_type" {
  description = "Instance type for the web server instances"
  type        = string
  validation {
    condition     = var.web_instance_type == "t3.micro"
    error_message = "The web_instance_type must be 't3.micro' for the dev environment"
  }
}

variable "bastion_instance_type" {
  description = "Instance type for the bastion host"
  type        = string
  validation {
    condition     = var.bastion_instance_type == "t3.micro"
    error_message = "The bastion_instance_type must be 't3.micro' for the dev environment"
  }
}