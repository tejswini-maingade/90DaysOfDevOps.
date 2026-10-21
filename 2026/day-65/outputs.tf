output "web_server_id" {
  description = "Web server EC2 instance ID"
  value       = module.web_server.instance_id
}

output "web_server_ip" {
  description = "Web server public IP"
  value       = module.web_server.public_ip
}

output "api_server_id" {
  description = "API server EC2 instance ID"
  value       = module.api_server.instance_id
}

output "api_server_ip" {
  description = "API server public IP"
  value       = module.api_server.public_ip
}

output "security_group_id" {
  description = "Shared security group ID"
  value       = module.web_sg.sg_id
}

output "vpc_id" {
  description = "VPC ID"
  value       = module.vpc.vpc_id
}
