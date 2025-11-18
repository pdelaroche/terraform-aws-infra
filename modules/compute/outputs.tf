output "web_server_id" {
  value       = aws_instance.web_server.id
  description = "The ID of the web server EC2 instance"
}

output "web_server_ip" {
  value       = aws_instance.web_server.public_ip
  description = "The public IP of the web server EC2 instance"

}
output "bastion_server_id" {
  value       = aws_instance.bastion_server.id
  description = "The ID of the bastion host EC2 instance"
}

output "bastion_server_ip" {
  value       = aws_instance.bastion_server.public_ip
  description = "The public IP of the bastion host EC2 instance"
}