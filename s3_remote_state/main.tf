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

# # using secrets from AWS Secrets Manager
# data "aws_secretsmanager_secret_version" "creds" {
#   secret_id = "db_credentials" # name in AWS Secrets Manager
# }

# locals {
#   db_creds = jsondecode(data.aws_secretsmanager_secret_version.creds.secret_string)
# }

resource "aws_instance" "server" {
  ami           = "ami-03074cc1b166e8691"
  instance_type = "t2.micro"
}
