output "vpc_id" {
  description = "The ID of the VPC"
  value       = module.network.vpc_id
}

output "public_subnets" {
  description = "List of public subnet IDs"
  value       = module.network.public_subnets
}

output "private_subnets" {
  description = "List of private subnet IDs"
  value       = module.network.private_subnets
}