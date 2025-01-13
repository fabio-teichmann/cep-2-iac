terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 5.0"
    }
  }
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
