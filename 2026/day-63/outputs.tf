
output "vpc_id" {
  description = "ID of the created VPC"
  value       = aws_vpc.main.id
}

output "public_subnet_id" {
  description = "ID of the public subnet"
  value       = aws_subnet.public.id
}

output "security_group_id" {
  description = "ID of the security group"
  value       = aws_security_group.main.id
}

output "instance_id" {
  description = "ID of the EC2 instance"
  value       = aws_instance.server.id
}

output "instance_public_ip" {
  description = "Public IP address of the EC2 instance"
  value       = aws_instance.server.public_ip
}

output "instance_public_dns" {
  description = "Public DNS name of the EC2 instance"
  value       = aws_instance.server.public_dns
}

output "selected_ami_id" {
  description = "AMI selected by the data source"
  value       = data.aws_ami.amazon_linux.id
}

output "selected_availability_zone" {
  description = "Availability Zone used by the subnet"
  value       = aws_subnet.public.availability_zone
}
