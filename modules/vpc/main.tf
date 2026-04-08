resource "aws_vpc" "main-vpc" {
  cidr_block           = var.vpc_cidr
  enable_dns_hostnames = true

  tags = {
    Name        = "${var.environment}-vpc"
    Environment = var.environment
  }
}

resource "aws_subnet" "public-subnet_1a" {
  vpc_id                  = aws_vpc.main-vpc.id
  cidr_block              = var.public_subnet_1a_cidr
  availability_zone       = "us-east-1a"
  map_public_ip_on_launch = true

  tags = {
    Name        = "${var.environment}-public-subnet-1a"
    Environment = var.environment
  }
}

resource "aws_subnet" "public-subnet_1b" {
  vpc_id                  = aws_vpc.main-vpc.id
  cidr_block              = var.public_subnet_1b_cidr
  availability_zone       = "us-east-1b"
  map_public_ip_on_launch = true

  tags = {
    Name        = "${var.environment}-public-subnet-1b"
    Environment = var.environment
  }
}

resource "aws_subnet" "private-subnet_1a" {
  vpc_id            = aws_vpc.main-vpc.id
  cidr_block        = var.private_subnet_1a_cidr
  availability_zone = "us-east-1a"

  tags = {
    Name        = "${var.environment}-private-subnet-1a"
    Environment = var.environment
  }
}

resource "aws_subnet" "private-subnet_1b" {
  vpc_id            = aws_vpc.main-vpc.id
  cidr_block        = var.private_subnet_1b_cidr
  availability_zone = "us-east-1b"

  tags = {
    Name        = "${var.environment}-private-subnet-1b"
    Environment = var.environment
  }
}

resource "aws_internet_gateway" "main-gateway" {
  vpc_id = aws_vpc.main-vpc.id

  tags = {
    Name        = "${var.environment}-igw"
    Environment = var.environment
  }
}




