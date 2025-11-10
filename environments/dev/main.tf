# environments/dev/main.tf

# module "network" {
#   source            = "../../modules/network"
#   env_01            = var.env_01
#   region            = var.region
#   vpc_cidr          = var.vpc_cidr
#   bastion_public_ip = var.bastion_public_ip
# }

module "network" {
  source   = "../../modules/network"
  env_01   = var.env_01
  region   = var.region
  vpc_cidr = var.vpc_cidr
}


# module "dns" {
#   source      = "../../modules/dns"
#   env         = "dev"
#   vpc_id      = module.network.vpc_id
#   domain_name = "dev.example.com"
# }


# module "compute" {
#   source     = "../../modules/compute"
#   env        = "dev"
#   vpc_id     = module.network.vpc_id
#   subnet_ids = module.network.public_subnets
# }


# module "storage" {
#   source = "../../modules/storage"
#   env    = "dev"
#   tags   = { Environment = "dev" }
# }