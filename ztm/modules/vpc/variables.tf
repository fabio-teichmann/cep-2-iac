variable "vpc_name" {
  default = "cep-2"
  type    = string
}

variable "vpc_cidr_block" {
  type    = string
  default = "10.0.0.0/16"
}

variable "web_subnet_cidr" {
  type    = string
  default = "10.0.10.0/24"
}
