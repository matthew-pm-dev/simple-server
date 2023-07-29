terraform {

  backend "local" {
    path = "terraform.tfstate"
  }

  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 3.0"
    }
  }
}

provider "aws" {
  region = "us-east-1"
}

resource "aws_instance" "simple_server_ub" {
  count = var.ubuntu_count

  ami           = var.ubuntu_ami
  instance_type = var.instance_type

  key_name        = var.ssh_admin_key
  security_groups = [aws_security_group.ext1-secgroup.name]

  tags = {
    Name      = "simple_server_ub_${count.index + 1}"
    Terraform = "True"
    Purpose   = "Simple test server running Ubuntu with SSH connectivity"
  }
}

resource "aws_instance" "simple_server_rh" {
  count = var.redhat_count

  ami           = var.redhat_ami
  instance_type = var.instance_type

  key_name        = var.ssh_admin_key
  security_groups = [aws_security_group.ext1-secgroup.name]

  tags = {
    Name      = "simple_server_rh_${count.index + 1}"
    Terraform = "True"
    Purpose   = "Simple test server running RedHat with SSH connectivity"
  }
}

resource "aws_security_group" "ext1-secgroup" {
  name = "ext1-secgroup"

  #SSH Enable
  ingress {
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = var.admin_ip_range
  }

  #allow inbound http requests on port 80
  ingress {
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  #allow all outbound
  egress {
    from_port   = 0
    to_port     = 0
    protocol    = -1
    cidr_blocks = ["0.0.0.0/0"]
  }

}

# output name and public ip of each instance created
output "instance_data" {
  value = join("", [
    "%{for i, name in aws_instance.simple_server_ub[*].tags.Name}${name} ${aws_instance.simple_server_ub[i].public_ip}\n%{endfor}\n",
    "%{for i, name in aws_instance.simple_server_rh[*].tags.Name}${name} ${aws_instance.simple_server_rh[i].public_ip}\n%{endfor}"
  ])
}

# Auto-generate ini format ansible inventory files
resource "local_file" "inventory" {
  content = join("", [
    "[ubuntu]\n%{for i, ip in aws_instance.simple_server_ub[*].public_ip}${ip}\n%{endfor}\n",
    "[redhat]\n%{for i, ip in aws_instance.simple_server_rh[*].public_ip}${ip}\n%{endfor}"
  ])
  filename = "inventory"
}