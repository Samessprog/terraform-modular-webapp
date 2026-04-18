variable "environment" {
  description = "Environment name (e.g. dev, prod)"
  type        = string
}

variable "subnet_ids" {
  description = "List of private subnet IDs for the RDS subnet group"
  type        = list(string)
}

variable "security_group_id" {
  description = "Security group ID to attach to the RDS instance"
  type        = string
}

variable "instance_class" {
  description = "RDS instance class"
  type        = string
  default     = "db.t3.micro"
}

variable "db_name" {
  description = "Name of the database"
  type        = string
}

variable "db_user_name" {
  description = "Master username for the database"
  type        = string
}

variable "secret_arn" {
  description = "ARN of the Secrets Manager secret containing RDS credentials"
  type        = string
}

variable "allocated_storage" {
  description = "Allocated storage size in GB for the RDS instance"
  type        = number
  default     = 20
}

variable "backup_retention_period" {
  description = "Number of days to retain automated RDS backups"
  type        = number
  default     = 7
}

variable "tags" {
  description = "Common tags to apply to all resources"
  type        = map(string)
  default     = {}
}
