variable "region" {
  description = "The AWS region to deploy resources in"
  type        = string
}

variable "env_01" {
  description = "The deployment environment"
  type        = string
}

variable "vpc_cidr" {
  description = "The CIDR block for the VPC"
  type        = string
}

variable "vpc_id" {
  description = "The ID of the VPC where resources will be deployed"
  type        = string
}

variable "private_subnets" {
  description = "Lista de subnets privadas donde se lanzarán los web servers"
  type        = list(string)
}

variable "public_subnets" {
  description = "Lista de subnets públicas donde se lanzará el bastion host"
  type        = list(string)
}

variable "web_instance_type" {
  description = "Instance type for the web server instances"
  type        = string
}

variable "bastion_instance_type" {
  description = "Instance type for the bastion host"
  type        = string
}