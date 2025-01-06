variable "AWS_ACCESS_KEY_CEP2" { type = string }
variable "AWS_SECRET_KEY_CEP2" { type = string }

variable "vpc_name" {
  default = "cep-2"
  type    = string
}
variable "vpc_cidr_block" {
  default     = "10.0.0.0/16"
  description = "CIDR block for the main VPC"
  type        = string
}

variable "web_subnet_cidr" {
  default     = "10.0.10.0/24"
  description = "CIDR block for subnet"
  type        = string
}

variable "ssh_public_key" { type = string }

variable "ingress_ports" {
  description = "list of ingress ports"
  type        = list(number)
  default     = [22, 80, 8080, 443, 143, 110, 25]
}
