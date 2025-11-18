resource "aws_instance" "web_server" {
  ami                    = data.aws_ami.ubuntu.id
  instance_type          = var.instance_type
  subnet_id              = var.subnet_ids[0]
  vpc_security_group_ids = [var.web_sg_id]

  tags = {
    Name = "WebServer"
  }
}

resource "aws_instance" "bastion_server" {
  ami                    = data.aws_ami.ubuntu.id
  instance_type          = var.instance_type
  subnet_id              = var.public_subnet_ids[0]
  vpc_security_group_ids = [var.bastion_sg_id]

  tags = {
    Name = "BastionServer"
  }
}