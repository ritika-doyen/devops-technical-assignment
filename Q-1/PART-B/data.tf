# Query AWS for available AZs (used if user doesn’t pass them explicitly)
data "aws_availability_zones" "available" {}

# Find the latest Amazon Linux 2 AMI (x86_64) to use for EC2 instances
data "aws_ami" "amazon_linux" {
  most_recent = true
  owners      = ["amazon"]

  filter {
    name   = "name"
    values = ["amzn2-ami-hvm-*-x86_64-gp2"]
  }
}
