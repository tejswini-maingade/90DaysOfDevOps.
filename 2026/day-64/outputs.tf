output "vpc_id" {
  description = "ID of the Day 64 VPC"
  value       = aws_vpc.main.id
}

output "instance_id" {
  description = "ID of the Day 64 EC2 instance"
  value       = aws_instance.day64.id
}

output "instance_type" {
  description = "Configured EC2 instance type"
  value       = aws_instance.day64.instance_type
}
