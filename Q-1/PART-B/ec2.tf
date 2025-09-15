# Launch EC2 instances in private subnets
resource "aws_instance" "app" {
  count                       = var.instance_count
  ami                         = data.aws_ami.amazon_linux.id
  instance_type               = var.instance_type
  subnet_id                   = values(aws_subnet.private)[count.index].id
  vpc_security_group_ids      = [aws_security_group.app_sg.id]
  key_name                    = var.ssh_key_name != "" ? var.ssh_key_name : null

  # User data: install nginx and serve simple page on port 8080
  user_data = <<-EOF
              #!/bin/bash
              yum update -y
              amazon-linux-extras install -y nginx1
              cat > /usr/share/nginx/html/index.html <<HTML
              <html><body><h1>Host: $(hostname)</h1></body></html>
              HTML
              sed -i 's/listen       80;/listen       8080;/' /etc/nginx/nginx.conf
              systemctl enable nginx
              systemctl start nginx
              EOF

  tags = merge(var.tags, { Name = "app-instance-${count.index}" })
}
