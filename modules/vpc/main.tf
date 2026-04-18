terraform {
  required_version = ">= 1.5.0"
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 5.0"
    }
  }
}

resource "aws_vpc" "main_vpc" {
  cidr_block           = var.vpc_cidr
  enable_dns_hostnames = true

  tags = merge(var.tags, {
    Name = "${var.environment}-vpc"
  })
}

resource "aws_subnet" "public_subnet_1a" {
  vpc_id                  = aws_vpc.main_vpc.id
  cidr_block              = var.public_subnet_1a_cidr
  availability_zone       = "eu-central-1a"
  map_public_ip_on_launch = true

  tags = merge(var.tags, {
    Name = "${var.environment}-public-subnet-1a"
  })
}

resource "aws_subnet" "public_subnet_1b" {
  vpc_id                  = aws_vpc.main_vpc.id
  cidr_block              = var.public_subnet_1b_cidr
  availability_zone       = "eu-central-1b"
  map_public_ip_on_launch = true

  tags = merge(var.tags, {
    Name = "${var.environment}-public-subnet-1b"
  })
}

resource "aws_subnet" "private_subnet_1a" {
  vpc_id            = aws_vpc.main_vpc.id
  cidr_block        = var.private_subnet_1a_cidr
  availability_zone = "eu-central-1a"

  tags = merge(var.tags, {
    Name = "${var.environment}-private-subnet-1a"
  })
}

resource "aws_subnet" "private_subnet_1b" {
  vpc_id            = aws_vpc.main_vpc.id
  cidr_block        = var.private_subnet_1b_cidr
  availability_zone = "eu-central-1b"

  tags = merge(var.tags, {
    Name = "${var.environment}-private-subnet-1b"
  })
}

resource "aws_internet_gateway" "main_gateway" {
  vpc_id = aws_vpc.main_vpc.id

  tags = merge(var.tags, {
    Name = "${var.environment}-igw"
  })
}

resource "aws_route_table" "public_route_table" {
  vpc_id = aws_vpc.main_vpc.id

  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.main_gateway.id
  }

  tags = merge(var.tags, {
    Name = "${var.environment}-public-route-table"
  })
}

resource "aws_route_table_association" "public_subnet_1a" {
  subnet_id      = aws_subnet.public_subnet_1a.id
  route_table_id = aws_route_table.public_route_table.id
}

resource "aws_route_table_association" "public_subnet_1b" {
  subnet_id      = aws_subnet.public_subnet_1b.id
  route_table_id = aws_route_table.public_route_table.id
}

resource "aws_eip" "nat_ip" {
  domain = "vpc"

  tags = merge(var.tags, {
    Name = "${var.environment}-eip"
  })
}

resource "aws_nat_gateway" "main_nat" {
  subnet_id     = aws_subnet.public_subnet_1a.id
  allocation_id = aws_eip.nat_ip.id
  depends_on    = [aws_internet_gateway.main_gateway]

  tags = merge(var.tags, {
    Name = "${var.environment}-nat"
  })
}

resource "aws_route_table" "private_route_table" {
  vpc_id = aws_vpc.main_vpc.id

  route {
    cidr_block     = "0.0.0.0/0"
    nat_gateway_id = aws_nat_gateway.main_nat.id
  }

  tags = merge(var.tags, {
    Name = "${var.environment}-private-route-table"
  })
}

resource "aws_route_table_association" "private_subnet_1a" {
  subnet_id      = aws_subnet.private_subnet_1a.id
  route_table_id = aws_route_table.private_route_table.id
}

resource "aws_route_table_association" "private_subnet_1b" {
  subnet_id      = aws_subnet.private_subnet_1b.id
  route_table_id = aws_route_table.private_route_table.id
}
