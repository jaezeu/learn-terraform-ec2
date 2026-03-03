locals {
  prefix = "jazeel"
}

resource "aws_instance" "public" {
  count                       = var.instance_count
  ami                         = data.aws_ami.amazon_linux.id    #Amazon Linux 2023 AMI ID, e.g. ami-xxxxxxxxxxxx
  instance_type               = var.instance_type               #EC2 instance type, e.g. t2.micro
  subnet_id                   = data.aws_subnets.example.ids[0] #Public Subnet ID, e.g. subnet-xxxxxxxxxxx
  associate_public_ip_address = true
  vpc_security_group_ids      = [aws_security_group.allow_ssh.id]

  tags = {
    Name = "${local.prefix}-ec2-${var.env}-${count.index + 1}" #Prefix your own name, e.g. jazeel-ec2-dev-1
  }
}

resource "aws_security_group" "allow_ssh" {
  name        = "${local.prefix}-sg-ec2-${var.env}" #Security group name, e.g. jazeel-terraform-security-group
  description = "Allow SSH inbound"
  vpc_id      = data.aws_vpc.selected.id #VPC ID (Same VPC as your EC2 subnet above), E.g. vpc-xxxxxxx
}

resource "aws_vpc_security_group_ingress_rule" "allow_tls_ipv4" {
  security_group_id = aws_security_group.allow_ssh.id
  cidr_ipv4         = "0.0.0.0/0"
  from_port         = 22
  ip_protocol       = "tcp"
  to_port           = 22
}
