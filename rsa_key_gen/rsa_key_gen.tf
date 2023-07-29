terraform {

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

# Auto-generate key
resource "tls_private_key" "gen_tls_pk" {
  algorithm = "RSA"
  rsa_bits  = 4096
}

# Auto-generate key-pair
resource "aws_key_pair" "gen_key_pair" {
  key_name   = "simple_server_key"
  public_key = tls_private_key.gen_tls_pk.public_key_openssh
}

# Save key to .pem file
resource "local_file" "key_local_file" {
  content  = tls_private_key.gen_tls_pk.private_key_pem
  filename = "simple_server_key.pem"
}