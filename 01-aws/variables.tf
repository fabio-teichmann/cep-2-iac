variable "AWS_ACCESS_KEY_CEP2" { type = string }
variable "AWS_SECRET_KEY_CEP2" { type = string }

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
