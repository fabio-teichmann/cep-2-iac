variable "ami_id" {
  type    = string
  default = "ami-03074cc1b166e8691"
}

variable "instance_type" {
  type    = string
  default = "t2.micro"
}

variable "servers" {
  description = "number of instances to create"
  type        = number
  default     = 1
}
