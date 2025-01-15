terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 5.0"
    }
  }
}

# Configure AWS provider
provider "aws" {
  region     = "eu-central-1"
  access_key = var.AWS_ACCESS_KEY_CEP2
  secret_key = var.AWS_SECRET_KEY_CEP2
}

variable "users" {
  type    = list(string)
  default = ["demo-user", "admin1", "john"]
}

# for_each example
resource "aws_iam_user" "test_for_each" {
  for_each = toset(var.users)
  name     = each.key
  path     = "/system/"
}

# # count example
# resource "aws_iam_user" "test_count" {
#   name  = element(var.users, count.index)
#   path  = "/system/"
#   count = length(var.users)
# }
