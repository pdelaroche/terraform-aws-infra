variable "region" {
  description = "The AWS region to deploy resources in"
  type        = string
}

variable "env_01" {
  description = "The deployment environment"
  type        = string
}

variable "vpc_id" {
  description = "The VPC ID where resources will be created"
  type        = string
}

variable "subnet_ids" {
  description = "List of subnet IDs where resources will be created"
  type        = list(string)
}

variable "instance_type" {
  description = "EC2 instance type"
  type        = string
}

variable "web_sg_id" {
  description = "Security Group ID for web servers"
  type        = string
}

variable "bastion_sg_id" {
  description = "Security Group ID for bastion server"
  type        = string
}

variable "public_subnet_ids" {
  description = "List of public subnet IDs for bastion server"
  type        = list(string)
}