terraform {
  required_version = ">= 1.5.0"
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 5.0"
    }
  }
}

resource "aws_db_subnet_group" "rds-group" {
  name       = "${var.environment}-rds-subnet-group"
  subnet_ids = var.subnet_ids
  tags = {
    Name        = "${var.environment}-rds-subnet-group"
    Environment = var.environment
  }
}

resource "aws_db_instance" "rds-instance" {
  identifier             = "${var.environment}-rds"
  engine                 = "postgres"
  engine_version         = "16"
  instance_class         = var.instance_class
  allocated_storage      = 20
  db_name                = var.db_name
  username               = var.db_user_name
  password               = var.db_password
  db_subnet_group_name   = aws_db_subnet_group.rds-group.name
  vpc_security_group_ids = [var.security_group_id]
  skip_final_snapshot    = true
  tags = {
    Name        = "${var.environment}-rds"
    Environment = var.environment
  }
}