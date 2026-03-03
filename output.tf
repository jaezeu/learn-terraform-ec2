output "my_vpc_id" {
  value = data.aws_vpc.selected.id
}

output "ami_id" {
  value = data.aws_ami.amazon_linux.id
}

output "subnet_ids" {
  value = data.aws_subnets.example.ids
}