output "main_vpc_id" {
  value = aws_vpc.vcp_cep_2.id
}

output "web_subnet_id" {
  value = aws_subnet.web.id
}
