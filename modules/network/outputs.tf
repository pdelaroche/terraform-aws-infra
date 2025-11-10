output "vpc_id" {
  description = "The ID of the VPC"
  value       = aws_vpc.cloudlab.id
}

output "public_subnets" {
  description = "List of public subnet IDs"
  value       = [for s in aws_subnet.all_subnets : s.id if s.tags["Type"] == "public"]
}

output "private_subnets" {
  description = "List of private subnet IDs"
  value       = [for s in aws_subnet.all_subnets : s.id if s.tags["Type"] == "private"]
}

output "bastion_sg_id" {
  description = "Security Group ID for Bastion Host"
  value       = aws_security_group.sg_bastion.id
}

output "web_sg_id" {
  description = "Security Group ID for Web Servers"
  value       = aws_security_group.sg_web.id
}