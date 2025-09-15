# Print VPC ID
output "vpc_id" {
  value = aws_vpc.main.id
}

# Print subnet IDs
output "public_subnets" {
  value = [for s in aws_subnet.public : s.id]
}

output "private_subnets" {
  value = [for s in aws_subnet.private : s.id]
}

# Print ALB DNS name (main output to test)
output "alb_dns_name" {
  value = aws_lb.app_alb.dns_name
}
