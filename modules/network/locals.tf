
locals {
  subnets_config = {
    "private_1" = { type = "private", cidr = "172.16.1.0/24", az_index = 0, public_ip = false, nat_gateway = "public_1" },
    "private_2" = { type = "private", cidr = "172.16.2.0/24", az_index = 1, public_ip = false, nat_gateway = "public_2" },
    "public_1"  = { type = "public", cidr = "172.16.3.0/24", az_index = 0, public_ip = true },
    "public_2"  = { type = "public", cidr = "172.16.4.0/24", az_index = 1, public_ip = true }
  }

  eip_config = {
    for k, v in local.subnets_config : k => v
    if v.type == "public"
  }

  private_subnets_config = {
    for k, v in local.subnets_config : k => v
    if v.type == "private"
  }

  web_ingress_rules = {
    http  = { port = 80, cidr = "0.0.0.0/0", description = "HTTP desde Internet" },
    https = { port = 443, cidr = "0.0.0.0/0", description = "HTTPS desde Internet" }
  }

  sg_with_global_egress = {
    bastion = aws_security_group.sg_bastion.id
    web     = aws_security_group.sg_web.id
  }
}