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
  source = "terraform-aws-modules/vpc/aws"

  name = var.vpc_name
  cidr = var.vpc_cidr_block

  azs            = [var.subnet_zone]
  public_subnets = [var.web_subnet_cidr]


  tags = {
    Terraform   = "true"
    Environment = "dev"
  }
}
