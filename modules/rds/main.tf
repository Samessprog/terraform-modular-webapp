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
  tags = merge(var.tags, {
    Name = "${var.environment}-rds-subnet-group"
  })
}

resource "aws_db_instance" "rds-instance" {
  identifier              = "${var.environment}-rds"
  engine                  = "postgres"
  engine_version          = "16"
  instance_class          = var.instance_class
  allocated_storage       = var.allocated_storage
  db_name                 = var.db_name
  username                = var.db_user_name
  password                = jsondecode(data.aws_secretsmanager_secret_version.rds_secrets.secret_string)["password"]
  db_subnet_group_name    = aws_db_subnet_group.rds-group.name
  vpc_security_group_ids  = [var.security_group_id]
  backup_retention_period = var.backup_retention_period
  skip_final_snapshot     = false
  lifecycle {
    prevent_destroy = true
  }
  tags = merge(var.tags, {
    Name = "${var.environment}-rds"
  })
}

data "aws_secretsmanager_secret_version" "rds_secrets" {
  secret_id = var.secret_arn
}