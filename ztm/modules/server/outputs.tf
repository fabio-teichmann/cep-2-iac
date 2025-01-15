output "public_server_ip" {
  value = aws_instance.my_vm.public_ip
}
output "server_ami" {
  value = aws_instance.my_vm.ami
}
