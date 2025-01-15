output "ec2_public_ip" {
  description = "The public IP address of the EC2 instance"
  value       = aws_instance.my_vm.public_ip
}

output "vpc_id" {
  description = "ID of CPV"
  value       = aws_vpc.vcp_cep_2.id
}

output "ami_id" {
  value = aws_instance.my_vm.ami
}
