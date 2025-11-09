#### Provider ####
provider "aws" {
  region = var.region
  default_tags {
    tags = {
      Environment = var.env_01
      Owner       = "pablo@aws.com"
      Team        = "DevOps"
      Project     = "cloudlab"
    }
  }
}
