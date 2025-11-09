# VPC
resource "aws_vpc" "cloudlab" {
  cidr_block           = "172.16.0.0/16"
  enable_dns_hostnames = true
  enable_dns_support   = true
  tags = {
    Name = "cloudlab-vpc"
  }
}

# Private Subnets
resource "aws_subnet" "private_1" {
  vpc_id            = aws_vpc.cloudlab.id
  cidr_block        = "172.16.1.0/24"
  availability_zone = "eu-west-2a"
  tags = {
    Name = "cloudlab-private-subnet-1"
  }
}

resource "aws_subnet" "private_2" {
  vpc_id            = aws_vpc.cloudlab.id
  cidr_block        = "172.16.2.0/24"
  availability_zone = "eu-west-2b"
  tags = {
    Name = "cloudlab-private-subnet-2"
  }
}

# Public Subnets
resource "aws_subnet" "public_1" {
  vpc_id                  = aws_vpc.cloudlab.id
  cidr_block              = "172.16.3.0/24"
  availability_zone       = "eu-west-2a"
  map_public_ip_on_launch = true
  tags = {
    Name = "cloudlab-public-subnet-1"
  }
}

resource "aws_subnet" "public_2" {
  vpc_id                  = aws_vpc.cloudlab.id
  cidr_block              = "172.16.4.0/24"
  availability_zone       = "eu-west-2b"
  map_public_ip_on_launch = true
  tags = {
    Name = "cloudlab-public-subnet-2"
  }
}

# 3. Internet Gateway
resource "aws_internet_gateway" "cloudlab_igw" {
  vpc_id = aws_vpc.cloudlab.id
  tags = {
    Name = "cloudlab-igw"
  }
}

# 4. Elastic IPs
resource "aws_eip" "eip_public_1" {
  domain = "vpc"
  tags = {
    Name = "cloudlab-eip-az-2a"
  }
}

resource "aws_eip" "eip_public_2" {
  domain = "vpc"
  tags = {
    Name = "cloudlab-eip-az-2b"
  }
}

# NAT Gateway
resource "aws_nat_gateway" "public_1" {
  allocation_id = aws_eip.eip_public_1.id
  subnet_id     = aws_subnet.public_1.id

  tags = {
    Name = "cloudlab-nat-gateway-az-2a"
  }

  depends_on = [aws_internet_gateway.cloudlab_igw]
}

resource "aws_nat_gateway" "public_2" {
  allocation_id = aws_eip.eip_public_2.id
  subnet_id     = aws_subnet.public_2.id

  tags = {
    Name = "cloudlab-nat-gateway-az-2b"
  }

  depends_on = [aws_internet_gateway.cloudlab_igw]
}

# Route Tables
resource "aws_route_table" "rt_public" {
  vpc_id = aws_vpc.cloudlab.id

  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.cloudlab_igw.id
  }

  tags = {
    Name = "cloudlab-public-rt"
  }
}

resource "aws_route_table_association" "rt_assoc_public_1" {
  subnet_id      = aws_subnet.public_1.id
  route_table_id = aws_route_table.rt_public.id
}

resource "aws_route_table_association" "rt_assoc_public_2" {
  subnet_id      = aws_subnet.public_2.id
  route_table_id = aws_route_table.rt_public.id
}
resource "aws_route_table" "rt_private_1" {
  vpc_id = aws_vpc.cloudlab.id

  route {
    cidr_block     = "0.0.0.0/0"
    nat_gateway_id = aws_nat_gateway.public_1.id
  }

  tags = {
    Name = "cloudlab-private-rt"
  }
}

resource "aws_route_table_association" "rt_assoc_private_1" {
  subnet_id      = aws_subnet.private_1.id
  route_table_id = aws_route_table.rt_private_1.id
}

resource "aws_route_table" "rt_private_2" {
  vpc_id = aws_vpc.cloudlab.id

  route {
    cidr_block     = "0.0.0.0/0"
    nat_gateway_id = aws_nat_gateway.public_2.id
  }

  tags = {
    Name = "cloudlab-private-route-table-az-2b"
  }
}

resource "aws_route_table_association" "rt_assoc_private_2" {
  subnet_id      = aws_subnet.private_2.id
  route_table_id = aws_route_table.rt_private_2.id
}

# Security Groups
resource "aws_security_group" "sg_bastion" {
  name        = "sg_bastion_host"
  description = "Allow SSH to Bastion Host from known IP"
  vpc_id      = aws_vpc.cloudlab.id

  ingress {
    description = "SSH allow"
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  egress {
    description = "Allow all outbound traffic"
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = {
    Name = "sg-bastion"
  }
}

resource "aws_security_group" "sg_web" {
  name        = "sg_web_servers"
  description = "Allow web traffic and SSH from Bastion"
  vpc_id      = aws_vpc.cloudlab.id

  ingress {
    description = "Allow HTTP"
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }
  ingress {
    description = "Allow HTTPS"
    from_port   = 443
    to_port     = 443
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  ingress {
    description     = "Allow SSH from Bastion Host"
    from_port       = 22
    to_port         = 22
    protocol        = "tcp"
    security_groups = [aws_security_group.sg_bastion.id]
  }

  egress {
    description = "Allow all outbound traffic"
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = {
    Name = "sg-web"
  }
}
