#### VPC ####
resource "aws_vpc" "cloudlab" {
  cidr_block           = var.vpc_cidr
  enable_dns_hostnames = true
  enable_dns_support   = true
  tags = {
    Name = "${var.env_01}-cloudlab-vpc"
  }
}


#### Subnets ####
resource "aws_subnet" "all_subnets" {
  for_each = local.subnets_config

  vpc_id                  = aws_vpc.cloudlab.id
  cidr_block              = each.value.cidr
  availability_zone       = data.aws_availability_zones.available.names[each.value.az_index]
  map_public_ip_on_launch = each.value.public_ip

  tags = {
    Name = "${var.env_01}-cloudlab-${each.key}-subnet"
    Type = each.value.type
    AZ   = data.aws_availability_zones.available.names[each.value.az_index]
  }
}


#### Internet Gateway ####
resource "aws_internet_gateway" "cloudlab_igw" {
  vpc_id = aws_vpc.cloudlab.id
  tags = {
    Name = "${var.env_01}-cloudlab-igw"
    Type = "internet-gateway"
  }
}


#### Elastic IPs ####
resource "aws_eip" "public" {
  for_each = local.eip_config

  domain = "vpc"

  tags = {
    Name = "${var.env_01}-cloudlab-eip-${each.key}"

    AZ = data.aws_availability_zones.available.names[each.value.az_index]
  }
}


#### NAT Gateways ####
resource "aws_nat_gateway" "public" {
  for_each = local.eip_config

  allocation_id = aws_eip.public[each.key].id

  subnet_id = aws_subnet.all_subnets[each.key].id

  tags = {
    Name = "${var.env_01}-cloudlab-nat-gateway-${each.key}"
    Type = "Nat-Gateway"
  }

  depends_on = [aws_internet_gateway.cloudlab_igw]
}


#### Route Tables ####
resource "aws_route_table" "rt_public" {
  vpc_id = aws_vpc.cloudlab.id

  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.cloudlab_igw.id
  }

  tags = {
    Name = "${var.env_01}-cloudlab-public-rt"
  }
}

resource "aws_route_table_association" "rt_assoc_public" {
  for_each = local.eip_config

  subnet_id      = aws_subnet.all_subnets[each.key].id
  route_table_id = aws_route_table.rt_public.id
}

resource "aws_route_table" "rt_private" {
  vpc_id   = aws_vpc.cloudlab.id
  for_each = local.private_subnets_config
  route {
    cidr_block     = "0.0.0.0/0"
    nat_gateway_id = aws_nat_gateway.public[each.value.nat_gateway].id
  }

  tags = {
    Name = "${var.env_01}-cloudlab-private-rt-${each.key}"
  }
}

resource "aws_route_table_association" "rt_assoc_private" {
  for_each = local.private_subnets_config

  subnet_id      = aws_subnet.all_subnets[each.key].id
  route_table_id = aws_route_table.rt_private[each.key].id
}


#### Security Groups ####
resource "aws_security_group" "sg_bastion" {
  name        = "sg_bastion_host"
  description = "Allow SSH to Bastion Host from known IP"
  vpc_id      = aws_vpc.cloudlab.id

  tags = {
    Name = "${var.env_01}-sg-bastion"
  }
}

resource "aws_security_group" "sg_web" {
  name        = "${var.env_01}-sg-web-servers"
  description = "Allow web traffic and SSH from Bastion"
  vpc_id      = aws_vpc.cloudlab.id

  tags = {
    Name = "${var.env_01}-sg-web"
  }
}

resource "aws_vpc_security_group_ingress_rule" "bastion_ssh_in" {
  for_each = var.bastion_public_ip != null ? toset(var.bastion_public_ip) : []

  security_group_id = aws_security_group.sg_bastion.id
  cidr_ipv4         = each.value
  from_port         = 22
  to_port           = 22
  ip_protocol       = "tcp"
  description       = "SSH access from ${each.value}"
}

resource "aws_vpc_security_group_ingress_rule" "web_public_in" {
  for_each = local.web_ingress_rules

  security_group_id = aws_security_group.sg_web.id
  cidr_ipv4         = each.value.cidr
  from_port         = each.value.port
  to_port           = each.value.port
  ip_protocol       = "tcp"
  description       = each.value.description
}

resource "aws_vpc_security_group_ingress_rule" "web_ssh_from_bastion" {
  security_group_id            = aws_security_group.sg_web.id
  referenced_security_group_id = aws_security_group.sg_bastion.id
  from_port                    = 22
  to_port                      = 22
  ip_protocol                  = "tcp"
  description                  = "SSH permitido solo desde Bastion Host"
}

resource "aws_vpc_security_group_egress_rule" "global_egress_all" {
  for_each = local.sg_with_global_egress

  security_group_id = each.value
  cidr_ipv4         = "0.0.0.0/0"
  ip_protocol       = "-1"
  description       = "Allow all outbound traffic to Internet"
}