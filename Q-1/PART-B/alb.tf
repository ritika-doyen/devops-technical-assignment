# Create ALB in public subnets
resource "aws_lb" "app_alb" {
  name               = "app-alb"
  load_balancer_type = "application"
  internal           = false # Public
  security_groups    = [aws_security_group.alb_sg.id]
  subnets            = values(aws_subnet.public)[*].id

  tags = merge(var.tags, { Name = "app-alb" })
}

# Create target group for EC2 instances
resource "aws_lb_target_group" "app_tg" {
  name     = "app-tg"
  port     = 8080
  protocol = "HTTP"
  vpc_id   = aws_vpc.main.id

  health_check {
    path                = "/"
    protocol            = "HTTP"
    matcher             = "200-399"
    interval            = 30
    healthy_threshold   = 2
    unhealthy_threshold = 3
    timeout             = 5
  }

  tags = merge(var.tags, { Name = "app-tg" })
}

# Register EC2 instances with ALB target group
resource "aws_lb_target_group_attachment" "app_targets" {
  for_each = { for idx, inst in aws_instance.app : idx => inst }

  target_group_arn = aws_lb_target_group.app_tg.arn
  target_id        = each.value.id
  port             = 8080
}

# Create listener on port 80
resource "aws_lb_listener" "http" {
  load_balancer_arn = aws_lb.app_alb.arn
  port              = 80
  protocol          = "HTTP"

  default_action {
    type             = "forward"
    target_group_arn = aws_lb_target_group.app_tg.arn
  }
}
