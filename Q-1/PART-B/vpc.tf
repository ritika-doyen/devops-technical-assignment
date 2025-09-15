# Create VPC
resource "aws_vpc" "main" {
  cidr_block           = var.vpc_cidr
  enable_dns_hostnames = true # Needed for ALB and EC2 DNS
  enable_dns_support   = true

  tags = merge(var.tags, {
    Name = "vpc-main"
  })
}

# Use given AZs or fallback to first two available
locals {
  azs = length(var.availability_zones) >= 2 ? var.availability_zones : slice(data.aws_availability_zones.available.names, 0, 2)
}

# Public subnets in 2 AZs
resource "aws_subnet" "public" {
  for_each = { for idx, cidr in var.public_subnet_cidrs : idx => cidr }

  vpc_id                  = aws_vpc.main.id
  cidr_block              = each.value
  availability_zone       = local.azs[each.key]
  map_public_ip_on_launch = true # Assign public IPs automatically

  tags = merge(var.tags, { Name = "public-subnet-${each.key}" })
}

# Private subnets in 2 AZs
resource "aws_subnet" "private" {
  for_each = { for idx, cidr in var.private_subnet_cidrs : idx => cidr }

  vpc_id                  = aws_vpc.main.id
  cidr_block              = each.value
  availability_zone       = local.azs[each.key]
  map_public_ip_on_launch = false # No public IPs

  tags = merge(var.tags, { Name = "private-subnet-${each.key}" })
}

# Internet Gateway for public subnets
resource "aws_internet_gateway" "igw" {
  vpc_id = aws_vpc.main.id
  tags   = merge(var.tags, { Name = "igw-main" })
}

# Route table for public subnets
resource "aws_route_table" "public" {
  vpc_id = aws_vpc.main.id
  route {
    cidr_block = "0.0.0.0/0"       # Default route to internet
    gateway_id = aws_internet_gateway.igw.id
  }
  tags = merge(var.tags, { Name = "rt-public" })
}

# Associate public subnets with public route table
resource "aws_route_table_association" "public_assoc" {
  for_each       = aws_subnet.public
  subnet_id      = each.value.id
  route_table_id = aws_route_table.public.id
}

# NAT Gateway setup for private subnets
resource "aws_eip" "nat_eip" {
  vpc  = true
  tags = merge(var.tags, { Name = "nat-eip" })
}

resource "aws_nat_gateway" "nat" {
  allocation_id = aws_eip.nat_eip.id
  subnet_id     = aws_subnet.public[0].id # Place in first public subnet
  tags          = merge(var.tags, { Name = "nat-gw" })
}

# Private route table (use NAT for outbound internet)
resource "aws_route_table" "private" {
  vpc_id = aws_vpc.main.id
  route {
    cidr_block     = "0.0.0.0/0"
    nat_gateway_id = aws_nat_gateway.nat.id
  }
  tags = merge(var.tags, { Name = "rt-private" })
}

# Associate private subnets with private route table
resource "aws_route_table_association" "private_assoc" {
  for_each       = aws_subnet.private
  subnet_id      = each.value.id
  route_table_id = aws_route_table.private.id
}
