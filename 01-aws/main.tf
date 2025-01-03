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

# internet gateway
resource "aws_internet_gateway" "igw" {
  vpc_id = aws_vpc.vcp_cep_2.id
  tags = {
    "Name" = "${var.vpc_name} igw"
  }
}

# route table
resource "aws_default_route_table" "vpc_default_rt" {
  default_route_table_id = aws_vpc.vcp_cep_2.default_route_table_id

  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.igw.id
  }
  tags = {
    "Name" = "deafult rt"
  }
}

# security group
resource "aws_default_security_group" "default_sg" {
  vpc_id = aws_vpc.vcp_cep_2.id
  ingress {
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }
  ingress {
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }
  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1" # any protocol
    cidr_blocks = ["0.0.0.0/0"]
  }
  tags = {
    "Name" = "default sg"
  }
}
