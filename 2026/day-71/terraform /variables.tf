variable "region" {
  type    = string
  default = "us-east-1"
}

variable "instances" {
  description = "Map of instance names to AMI IDs,SSH users,OS family and instance type"

  type = map(object({
    ami           = string
    user          = string
    os_family     = string
    instance_type = string
  }))

  default = {
    "control-node" = {
      ami           = "ami-0ec10929233384c7f" # Ubuntu Server 24.04 LTS 
      user          = "ubuntu"
      os_family     = "ubuntu"
      instance_type = "t3.micro"
    }

    "web-server" = {
      ami           = "ami-0ec10929233384c7f" # Ubuntu Server 24.04 LTS 
      user          = "ubuntu"
      os_family     = "ubuntu"
      instance_type = "t3.micro"
    }

    "app-server" = {
      ami           = "ami-0ec10929233384c7f" # Ubuntu Server 24.04 LTS 
      user          = "ubuntu"
      os_family     = "ubuntu"
      instance_type = "t3.micro"
    }

    "db-server" = {
      ami           = "ami-0ec10929233384c7f" # Ubuntu Server 24.04 LTS 
      user          = "ubuntu"
      os_family     = "ubuntu"
      instance_type = "t3.micro"
    }
  }


}


variable "allowed_ports" {
  description = "List of allowed inbound TCP ports"
  type        = list(number)
  default     = [22, 80]
}
