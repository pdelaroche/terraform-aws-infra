variable "region" {
  description = "The AWS region to deploy resources in"
  type        = string
  default     = "eu-west-1"
}

variable "env_01" {
  description = "The deployment environment"
  type        = string
  default     = "dev"
}

variable "vpc_cidr" {
  description = "The CIDR block for the VPC"
  type        = string
}

variable "bastion_public_ip" {
  description = "Lista de IPs permitidas para SSH al bastion"
  type        = list(string)
  default     = null
}

/*
    Lista de IPs permitidas para SSH al bastion.
    Ejemplos de uso:
  
    # Cambiar a una IP:
    terraform apply -var='bastion_public_ip=["1.2.3.4/32"]'

    # Cambiar a múltiples IPs:
    terraform apply -var='bastion_public_ip=["1.2.3.4/32","5.6.7.8/32"]'

    # Quitar todo acceso:
    terraform apply -var='bastion_public_ip=null'
    */
