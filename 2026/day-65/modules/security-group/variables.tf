variable "vpc_id" {
  description = "VPC ID for the security group"
  type        = string
}

variable "sg_name" {
  description = "Name of the security group"
  type        = string
}

variable "ingress_ports" {
  description = "List of inbound TCP ports"
  type        = list(number)
  default     = [22, 80]
}

variable "tags" {
  description = "Additional security group tags"
  type        = map(string)
  default     = {}
}
