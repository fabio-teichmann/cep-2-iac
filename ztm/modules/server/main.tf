
# security group
resource "aws_default_security_group" "default_sg" {
  vpc_id = var.main_vpc_id
  ingress {
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }
  ingress {
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }
  ingress {
    from_port   = 8080
    to_port     = 8080
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }
  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1" # any protocol
    cidr_blocks = ["0.0.0.0/0"]
  }
  tags = {
    "Name" = "default sg"
  }
}

# key-pair resource for automation
resource "aws_key_pair" "test_ssh_key" {
  key_name   = "testing_ssh_key"
  public_key = file(var.ssh_public_key)
}

# data source
data "aws_ami" "latest_amazon_linux2" {
  owners      = ["amazon"]
  most_recent = true # optional
  filter {
    name   = "name"
    values = ["amzn2-ami-kernel-*-x86_64-gp2"]
  }
  filter {
    name   = "architecture"
    values = ["x86_64"]
  }
}

resource "aws_instance" "my_vm" {
  ami                         = data.aws_ami.latest_amazon_linux2.id # dynamically choose AMI's for different region
  instance_type               = "t2.micro"
  subnet_id                   = var.web_subnet_id
  vpc_security_group_ids      = [aws_default_security_group.default_sg.id]
  associate_public_ip_address = true
  key_name                    = aws_key_pair.test_ssh_key.key_name
  user_data                   = file(var.script_name)
  tags = {
    "Name" = "ec2 - Amazon Linux 2"
  }
}
