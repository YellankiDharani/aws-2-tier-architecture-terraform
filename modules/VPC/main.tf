resource "aws_vpc" "vpc" {
  cidr_block = var.vpc_cidr_block
  tags = {
    Name = "VPC"
  }
}

resource "aws_internet_gateway" "Internet_gateway" {
  vpc_id = aws_vpc.vpc.id
  tags = {
    Name = "Internet-gateway"
  }
}

resource "aws_route_table" "Public_subnets_route_table" {
  vpc_id = aws_vpc.vpc.id

  route  {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.Internet_gateway.id
  }

  tags = {
    Name = "Public_route_table"
  }
}

resource "aws_route_table_association" "public_subnet1_association" {
  subnet_id = var.public_subnet1
  route_table_id = aws_route_table.Public_subnets_route_table.id
}

resource "aws_route_table_association" "public_subnet2_association" {
  subnet_id = var.public_subnet2
  route_table_id = aws_route_table.Public_subnets_route_table.id
}

resource "aws_eip" "Elastic_IP" {
  domain = "vpc"

  tags = {
    Name = "Elastic-IP"
  }
}

resource "aws_nat_gateway" "nat_gateway" {
  subnet_id = var.subnet_id
  allocation_id = aws_eip.Elastic_IP.id

  tags = {
    Name = "NAT-Gateway"
  }
}

resource "aws_route_table" "private_subnets_route_table" {
  vpc_id = aws_vpc.vpc.id

  route {
    nat_gateway_id = aws_nat_gateway.nat_gateway.id
    cidr_block = "0.0.0.0/0"
  }
  
  tags = {
      Name = "NAT-Route-table"
  }
}

resource "aws_route_table_association" "NAT-association" {
  route_table_id = aws_route_table.private_subnets_route_table.id
  subnet_id = var.asg_subnet
}


