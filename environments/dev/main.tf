module "network" {
  source   = "../../modules/network"
  env_01   = var.env_01
  region   = var.region
  vpc_cidr = var.vpc_cidr
}


# module "compute" {
#   source                = "../../modules/compute"
#   env_01                = var.env_01
#   region                = var.region
#   vpc_id                = module.network.vpc_id
#   private_subnets       = module.network.private_subnets
#   public_subnets        = module.network.public_subnets
#   web_instance_type     = var.web_instance_type
#   bastion_instance_type = var.bastion_instance_type
# }


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