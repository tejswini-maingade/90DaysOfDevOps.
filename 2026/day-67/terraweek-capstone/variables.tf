variable "aws_region" {
  description = "AWS region for the infrastructure"
  type        = string
  default     = "ap-south-1"
}

variable "project_name" {
  description = "Project name prefix"
  type        = string
  default     = "terraweek"
}

variable "vpc_cidr" {
  description = "VPC CIDR block"
  type        = string
}

variable "subnet_cidr" {
  description = "Public subnet CIDR block"
  type        = string
}

variable "instance_type" {
  description = "EC2 instance type"
  type        = string
}

variable "ingress_ports" {
  description = "TCP ports permitted from the internet"
  type        = list(number)
  default     = [80]
}

variable "ami_id" {
  description = "Optional Ubuntu AMI override"
  type        = string
  default     = null
}
