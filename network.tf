#VPC creation
resource "aws_vpc" "vpc" {
  tags = {
    Name        = "T-Vpc"
    Environment = "Dev"
  }
  cidr_block           = "192.168.0.0/16"
  instance_tenancy     = "default"
  enable_dns_hostnames = "true"

}

#Public subnet-1 creation
resource "aws_subnet" "subnets-1" {
  vpc_id = aws_vpc.vpc.id
  tags = {
    Name = "public-subnet-1"
  }
  availability_zone       = "eu-north-1a"
  cidr_block              = "192.168.0.0/25"
  map_public_ip_on_launch = "true"
}

#Public subnet-2 creation
resource "aws_subnet" "subnets-2" {
  vpc_id = aws_vpc.vpc.id
  tags = {
    Name = "public-subnet-2"
  }
  availability_zone       = "eu-north-1b"
  cidr_block              = "192.168.0.128/25"
  map_public_ip_on_launch = "true"
}

#Private subnet-1 creation
resource "aws_subnet" "private-subnets-1" {
  vpc_id = aws_vpc.vpc.id
  tags = {
    Name = "private-subnet-1"
  }
  availability_zone       = "eu-north-1a"
  cidr_block              = "192.168.1.0/25"
  map_public_ip_on_launch = "false"
}

#Private subnet-2 creation
resource "aws_subnet" "private-subnets-2" {
  vpc_id = aws_vpc.vpc.id
  tags = {
    Name = "private-subnet-2"
  }
  availability_zone       = "eu-north-1b"
  cidr_block              = "192.168.1.128/25"
  map_public_ip_on_launch = "false"
}

#Internet Gateway creation attached to VPC
resource "aws_internet_gateway" "igw" {
  tags = {
    Name = "T-IGW"
  }
  vpc_id = aws_vpc.vpc.id
}

#Public route table created and IGW added to routes
resource "aws_route_table" "route-table" {
  tags = {
    Name = "T-RT"
  }
  vpc_id = aws_vpc.vpc.id
  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.igw.id
  }
}

#Private route table-1 created and NAT-1 added to routes
resource "aws_route_table" "private-route-table-1" {
  tags = {
    Name = "T-PRT"
  }
  vpc_id = aws_vpc.vpc.id
  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_nat_gateway.nat1.id
  }
}

#Private route table-2 created and NAT-2 added to routes
resource "aws_route_table" "private-route-table-2" {
  tags = {
    Name = "T-PRT"
  }
  vpc_id = aws_vpc.vpc.id
  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_nat_gateway.nat2.id
  }
}

#Public subnet-1 associations to route table
resource "aws_route_table_association" "rt_association_1" {
  route_table_id = aws_route_table.route-table.id
  subnet_id      = aws_subnet.subnets-1.id
}

#Public subnet-2 associations to route table
resource "aws_route_table_association" "rt_association_2" {
  route_table_id = aws_route_table.route-table.id
  subnet_id      = aws_subnet.subnets-2.id
}

#Private subnet-1 associations to private route table-1
resource "aws_route_table_association" "private-rt_association_1" {
  route_table_id = aws_route_table.private-route-table-1.id
  subnet_id      = aws_subnet.private-subnets-1.id
}

#Private subnet-2 associations to private route table-2
resource "aws_route_table_association" "private-rt_association_2" {
  route_table_id = aws_route_table.private-route-table-2.id
  subnet_id      = aws_subnet.private-subnets-2.id
}

#Elastic IP created for NAT1
resource "aws_eip" "eip1" {
  domain = "vpc"
}

#Elastic IP created for NAT2
resource "aws_eip" "eip2" {
  domain = "vpc"
}

#NAT1 created
resource "aws_nat_gateway" "nat1" {
  allocation_id = aws_eip.eip1.id
  subnet_id     = aws_subnet.subnets-1.id

  tags = {
    Name = "NAT1"
  }
  depends_on = [aws_internet_gateway.igw]
}

#NAT2 created
resource "aws_nat_gateway" "nat2" {
  allocation_id = aws_eip.eip2.id
  subnet_id     = aws_subnet.subnets-2.id

  tags = {
    Name = "NAT2"
  }
  depends_on = [aws_internet_gateway.igw]
}
