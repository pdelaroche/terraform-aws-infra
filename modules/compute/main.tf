resource "ec2_instance" "web_server" {
  ami           = var.ami_id
  instance_type = var.instance_type

  tags = {
    Name = "WebServer"
  }
}