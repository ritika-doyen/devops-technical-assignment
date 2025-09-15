# Security group for ALB
resource "aws_security_group" "alb_sg" {
  name        = "alb-sg"
  vpc_id      = aws_vpc.main.id
  description = "Allow inbound HTTP(s) from internet"

  ingress {
    description = "Allow HTTP"
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"] # Open to the world
  }

  # Allow outbound to anywhere
  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = merge(var.tags, { Name = "alb-sg" })
}

# Security group for EC2 app servers
resource "aws_security_group" "app_sg" {
  name        = "app-sg"
  vpc_id      = aws_vpc.main.id
  description = "Allow inbound traffic from ALB only"

  # Allow only ALB traffic on port 8080
  ingress {
    description     = "App traffic from ALB"
    from_port       = 8080
    to_port         = 8080
    protocol        = "tcp"
    security_groups = [aws_security_group.alb_sg.id]
  }

  # Optional SSH (only if key specified)
  dynamic "ingress" {
    for_each = var.ssh_key_name != "" ? [1] : []
    content {
      description = "SSH (for debugging, restrict in production)"
      from_port   = 22
      to_port     = 22
      protocol    = "tcp"
      cidr_blocks = ["0.0.0.0/0"] # Replace with office IP in production
    }
  }

  # Outbound allowed
  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = merge(var.tags, { Name = "app-sg" })
}
