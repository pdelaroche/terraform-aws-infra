module "network" {
  source   = "../../modules/network"
  env_01   = var.env_01
  region   = var.region
  vpc_cidr = var.vpc_cidr
}


module "compute" {
  source            = "../../modules/compute"
  env_01            = var.env_01
  region            = var.region
  vpc_id            = module.network.vpc_id
  subnet_ids        = module.network.private_subnets
  public_subnet_ids = module.network.public_subnets
  instance_type     = var.web_instance_type
  web_sg_id         = module.network.web_sg_id
  bastion_sg_id     = module.network.bastion_sg_id
}


# module "dns" {
#   source      = "../../modules/dns"
#   env         = "dev"
#   vpc_id      = module.network.vpc_id
#   domain_name = "dev.example.com"
# }




# module "storage" {
#   source = "../../modules/storage"
#   env    = "dev"
#   tags   = { Environment = "dev" }
# }