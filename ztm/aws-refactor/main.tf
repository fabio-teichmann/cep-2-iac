terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 5.0"
    }
  }
}

# Configure the AWS Provider
provider "aws" {
  region = "eu-central-1"
  # Access keys managed via aws config profile
  profile = "cep-2-admin"
}

module "vpc" {
  source = "../modules/vpc/"
}

module "server" {
  source         = "../modules/server/"
  main_vpc_id    = module.vpc.main_vpc_id
  web_subnet_id  = module.vpc.web_subnet_id
  ssh_public_key = var.ssh_public_key
  script_name    = var.script_name
}
