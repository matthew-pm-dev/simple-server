# EC2 instance counts

variable "ubuntu_count" {
  description = "Number of Ubuntu instances to spawn"
  type        = number
  default     = 2
}

variable "redhat_count" {
  description = "Number of RedHat instances to spawn"
  type        = number
  default     = 0
}

# EC2 config variables

variable "ubuntu_ami" {
  description = "Amazon Ubuntu machine image to use for ec2 instance"
  type        = string
  default     = "ami-053b0d53c279acc90" #Ubuntu Server 22.04 LTS (HVM) // us-east-1
}

variable "redhat_ami" {
  description = "Amazon Redhat machine image to use for ec2 instance"
  type        = string
  default     = "ami-026ebd4cfe2c043b2" #Red Hat Enterprise Linux 9 (HVM) // us-east-1
}

variable "instance_type" {
  description = "ec2 instance type"
  type        = string
  default     = "t2.micro"
}

variable "ssh_admin_key" {
  description = "Default SSH key for EC2 admin"
  type        = string
  default     = "mpm-admin-ssh-key"
}