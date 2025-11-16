terraform {
  backend "s3" {
    bucket       = "terraform-backend-akdl312409r8u7t2"
    key          = "state/dev/terraform.tfstate"
    region       = "eu-west-1"
    encrypt      = true
    use_lockfile = true
  }
}