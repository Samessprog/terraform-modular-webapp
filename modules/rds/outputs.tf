output "db_endpoint" {
  value = aws_db_instance.rds-instance.endpoint
}

output "db_port" {
  value = aws_db_instance.rds-instance.port
}

output "rds_identifier" {
  description = "RDS instance identifier for CloudWatch dimensions"
  value       = aws_db_instance.rds-instance.identifier
}

