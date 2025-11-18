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

output "web_server_ip" {
  description = "The public IP of the web server EC2 instance"
  value       = module.compute.web_server_ip
}
output "bastion_server_ip" {
  description = "The public IP of the bastion host EC2 instance"
  value       = module.compute.bastion_server_ip
}