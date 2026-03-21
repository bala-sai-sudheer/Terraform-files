#VPC creation
resource "aws_vpc" "vpc" {
  tags = {
    Name = "Terraform-VPC"
  }
  cidr_block           = "10.0.0.0/24"
  instance_tenancy     = "default"
  enable_dns_hostnames = "true"
}

#VPC-subnet creation
resource "aws_subnet" "subnet" {
  vpc_id = aws_vpc.vpc.id
  tags = {
    Name = "Terraform-SN1"
  }
  cidr_block              = "10.0.0.0/25"
  availability_zone       = "eu-north-1a"
  map_public_ip_on_launch = "true"
}

#VPC-private subnet creation
resource "aws_subnet" "private" {
  vpc_id = aws_vpc.vpc.id
  tags = {
    Name = "Terraform-SN2"
  }
  cidr_block              = "10.0.0.128/25"
  availability_zone       = "eu-north-1b"
  map_public_ip_on_launch = "false"
}

#VPC-subnet-IGW creation
resource "aws_internet_gateway" "igw" {
  tags = {
    Name = "Terraform-IGW"
  }
  vpc_id = aws_vpc.vpc.id
}

#VPC-subnet-Route table creation
resource "aws_route_table" "route" {
  tags = {
    Name = "Terraform-Route"
  }
  vpc_id = aws_vpc.vpc.id
  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.igw.id
  }
}

#VPC-private subnet-Route table creation
resource "aws_route_table" "private" {
  tags = {
    Name = "Terraform-PrivateRoute"
  }
  vpc_id = aws_vpc.vpc.id
  route {
    cidr_block     = "0.0.0.0/0"
    nat_gateway_id = aws_nat_gateway.nat.id
  }
}

#VPC-subnet-Route association
resource "aws_route_table_association" "rt-ass" {
  route_table_id = aws_route_table.route.id
  subnet_id      = aws_subnet.subnet.id
}

#VPC-private subnet-Route association
resource "aws_route_table_association" "private-ass" {
  route_table_id = aws_route_table.private.id
  subnet_id      = aws_subnet.private.id
}

#VPC-private subnet- NAT gateway
resource "aws_nat_gateway" "nat" {
  allocation_id = aws_eip.nat_eip.id
  subnet_id     = aws_subnet.subnet.id  
  tags = {
    Name = "Terraform-Nat"
  }

  depends_on = [aws_internet_gateway.igw]
}

#VPC-NATgateway-Elastc_IP creation
resource "aws_eip" "nat_eip" {
  domain = "vpc"
}
