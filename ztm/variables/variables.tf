variable "AWS_ACCESS_KEY_CEP2" { type = string }
variable "AWS_SECRET_KEY_CEP2" { type = string }

variable "vpc_name" {
  default = "cep-2"
  type    = string
}

variable "aws_region" {
  type    = string
  default = "eu-central-1"
}

variable "azs" {
  description = "AZs in the region"
  type        = list(string)
  default     = ["eu-central-1a", "eu-central-1b", "eu-central-1c"]
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

variable "web_port" {
  description = "Web Port"
  default     = 80
  type        = number
}
variable "enable_dns" {
  description = "DNS support for VPC"
  type        = bool
  default     = true
}

# type map
variable "amis" {
  type        = map(string)
  description = "AMIs per region"
  default = {
    "eu-central-1" : "",
    "us-west-1" : ""
  }
}

variable "my_instance" {
  type    = tuple([string, number, bool])
  default = ["t2.micro", 1, true]
}

variable "egress_dsg" {
  type = object({
    from_port  = number
    to_port    = number
    protocol   = string
    cidr_block = list(string)
  })
  default = {
    from_port  = 0,
    to_port    = 65365,
    protocol   = "tcp",
    cidr_block = ["100.0.0.0/16", "10.0.0.0/24"]
  }
}
