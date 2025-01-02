terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 5.0"
    }
  }
}

variable "AWS_ACCESS_KEY_CEP2" { type = string }
variable "AWS_SECRET_KEY_CEP2" { type = string }
# Configure the AWS Provider
provider "aws" {
  region = "eu-central-1"
  # Access keys managed via env vars for security reasons
  access_key = var.AWS_ACCESS_KEY_CEP2
  secret_key = var.AWS_SECRET_KEY_CEP2
}

resource "aws_vpc" "vcp_cep_2" {
  cidr_block = "10.0.0.0/16"
  tags = {
    "Name" = "cep-2"
  }
}
