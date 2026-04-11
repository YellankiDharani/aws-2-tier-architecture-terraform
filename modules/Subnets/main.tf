resource "aws_subnet" "public_subnet1" {
  vpc_id = var.vpc_id
  cidr_block = var.public_subnet1_cidr
  availability_zone = "us-east-1a"
  map_public_ip_on_launch = true

  tags = {
    Name = "Public-subnet1"
  }

}

resource "aws_subnet" "public_subnet2" {
  vpc_id = var.vpc_id
  cidr_block = var.public_subnet2_cidr
  availability_zone = "us-east-1b"
  map_public_ip_on_launch = true

  tags = {
    Name = "Public-subnet2"
  }

}

resource "aws_subnet" "asg_subnet" {
  vpc_id = var.vpc_id
  cidr_block = var.asg_subnet_cidr
  availability_zone = "us-east-1a"
  map_public_ip_on_launch = false

  tags = {
    Name = "ASG-subnet1"
  }

}

resource "aws_subnet" "private_subnet2" {
  vpc_id = var.vpc_id
  cidr_block = var.private_subnet2_cidr
  availability_zone = "us-east-1b"
  map_public_ip_on_launch = false

  tags = {
    Name = "private_subnet2"
  }

}