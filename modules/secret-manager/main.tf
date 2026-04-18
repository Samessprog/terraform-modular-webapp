terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 5.0"
    }
  }
  required_version = ">= 1.5.0"
}
resource "aws_secretsmanager_secret" "secret_manager" {
  name = "${var.environment}/rds/password"
  tags = var.tags
}

resource "aws_secretsmanager_secret_version" "secret_manager_version" {
  secret_id     = aws_secretsmanager_secret.secret_manager.id
  secret_string = jsonencode({ username = var.db_username, password = var.db_password })
}