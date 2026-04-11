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

variable "vpc_id" {
  description = "VPC ID for the target group"
  type        = string
}

variable "certificate_arn" {
  type = string
}

variable "instance_ids" {
  description = "Map of EC2 instance IDs to attach to the target group"
  type        = map(string)
}