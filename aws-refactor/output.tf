output "ec2_public_ip" {
  description = "The public IP address of the EC2 instance"
  value       = module.server.public_server_ip #aws_instance.my_vm.public_ip
}

output "vpc_id" {
  description = "ID of CPV"
  value       = module.vpc.main_vpc_id
}

output "ami_id" {
  value = module.server.server_ami
}
