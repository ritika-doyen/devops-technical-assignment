# AWS region where resources will be created
variable "aws_region" {
  type    = string
  default = "us-east-1"
}

# CIDR range for the main VPC
variable "vpc_cidr" {
  type    = string
  default = "10.0.0.0/16"
}

# CIDR ranges for two public subnets
variable "public_subnet_cidrs" {
  type    = list(string)
  default = ["10.0.1.0/24", "10.0.2.0/24"]
}

# CIDR ranges for two private subnets
variable "private_subnet_cidrs" {
  type    = list(string)
  default = ["10.0.101.0/24", "10.0.102.0/24"]
}

# Availability Zones (optional). If not set, Terraform picks automatically.
variable "availability_zones" {
  type        = list(string)
  default     = []
  description = "List of AZs. Leave empty to auto-select."
}

# Number of EC2 instances to launch in private subnets
variable "instance_count" {
  type    = number
  default = 2
}

# Instance type (small for cost control)
variable "instance_type" {
  type    = string
  default = "t3.micro"
}

# Optional EC2 key pair for SSH access
variable "ssh_key_name" {
  type        = string
  default     = ""
  description = "Name of existing EC2 key pair. Leave empty to disable SSH."
}

# Tags applied to all resources
variable "tags" {
  type = map(string)
  default = {
    Project = "devops-assignment"
    Owner   = "student"
    Env     = "dev"
  }
}
