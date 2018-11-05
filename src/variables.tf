variable "aws_region" {
  default = "us-west-2"
}

variable "env" {
  description = "Environment (prod, stage, etc)"
}

variable "db_master_password" {
  description = "Master database password (keep this secret & safe & DO NOT COMMIT TO SOURCE CONTROL)"
}

variable "vpc_cidr" {
  default = "10.0.0.0/16"
}

variable "public_subnet_cidr" {
  default = "10.0.1.0/24"
}

variable "private_subnet_cidr" {
  default = "10.0.2.0/24"
}

variable "key_path" {
  default = "~/.ssh/id_rsa.pub"
}

variable "web_ami" {
  # aws --region=us-west-2 ec2 describe-images --filters Name=owner-alias,Values=amazon,Name=name,Values=amzn-ami-hvm-*-ebs
  description = "amzn-ami-hvm-2018.03.0.20180811-x86_64-ebs"
  default     = "ami-09c6e771"
}

variable "web_instance_count" {
  description = "number of EC2 instances in the web tier"
  default     = 1
}

variable "web_instance_type" {
  description = "EC2 instance type for the web tier"
  default     = "t2.small"
}
