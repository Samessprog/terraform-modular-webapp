output "db_endpoint" {
  value = aws_db_instance.rds-instance.endpoint
}

output "db_port" {
  value = aws_db_instance.rds-instance.port
}

