resource "aws_key_pair" "deployer" {

  key_name   = "ansible"
  public_key = file("ansible.pub")
}


resource "aws_default_vpc" "default" {}

resource "aws_instance" "ec2_instances" {
  for_each = var.instances

  ami                    = each.value.ami
  instance_type          = each.value.instance_type
  key_name               = aws_key_pair.deployer.key_name
  vpc_security_group_ids = [aws_security_group.ec2_sg.id]

  root_block_device {
    volume_size = 10
    volume_type = "gp3"
  }

  tags = {
    Name      = each.key
    Role      = each.key
    OS_Family = each.value.os_family
    ManagedBy = "Terraform"
  }
}

resource "aws_security_group" "ec2_sg" {
  name        = "Common Security Group"
  description = "Security group with dynamic allowed ports"
  vpc_id      = aws_default_vpc.default.id

  dynamic "ingress" {
    for_each = var.allowed_ports
    content {
      from_port   = ingress.value
      to_port     = ingress.value
      protocol    = "tcp"
      cidr_blocks = ["0.0.0.0/0"]
    }
  }

  egress {
    description = "Allow all outbound"
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = {
    Name      = "Common Security Group"
    ManagedBy = "Terraform"
  }
}
