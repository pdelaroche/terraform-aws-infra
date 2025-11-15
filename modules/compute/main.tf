resource "aws_instance" "web" {
  count         = length(var.private_subnets)
  ami           = data.aws_ami.ubuntu.id
  instance_type = var.web_instance_type
  subnet_id     = var.private_subnets[count.index]

  tags = {
    Name = "${var.env_01}-web-${count.index + 1}"
  }
}

resource "aws_instance" "bastion_host" {
  ami           = data.aws_ami.ubuntu.id
  instance_type = var.bastion_instance_type
  subnet_id     = var.public_subnets[0]

  tags = {
    Name = "${var.env_01}-bastion_host"
  }
}