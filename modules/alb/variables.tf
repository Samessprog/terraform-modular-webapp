variable "environment" {
  description = "Environment name (e.g. dev, prod)"
  type        = string
}

variable "security_group_id" {
  description = "Security group ID to attach to the ALB"
  type        = string
}

variable "subnet_ids" {
  description = "List of public subnet IDs for the ALB (Multi-AZ)"
  type        = list(string)
}
