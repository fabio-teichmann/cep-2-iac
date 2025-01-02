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
  # Access keys managed via env vars for security reasons
  access_key = var.AWS_ACCESS_KEY_CEP2
  secret_key = var.AWS_SECRET_KEY_CEP2
}

resource "aws_vpc" "vcp_cep_2" {
  cidr_block = var.vpc_cidr_block
  tags = {
    "Name" = "cep-2"
  }
}

resource "aws_subnet" "web" {
  vpc_id            = aws_vpc.vcp_cep_2.id
  cidr_block        = var.web_subnet_cidr
  availability_zone = "eu-central-1a"
  tags = {
    "Name" = "Web subnet"
  }
}
