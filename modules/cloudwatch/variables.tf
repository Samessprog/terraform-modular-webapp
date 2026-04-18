variable "environment" {
  description = "Environment name"
  type        = string
}

variable "alarm_email" {
  description = "Email address for SNS alarm notifications"
  type        = string
}

variable "ec2_instance_ids" {
  description = "Map of EC2 instance IDs to monitor"
  type        = map(string)
}

variable "alb_arn_suffix" {
  description = "ARN suffix of the ALB for CloudWatch dimensions"
  type        = string
}

variable "rds_identifier" {
  description = "RDS instance identifier for CloudWatch dimensions"
  type        = string
}

variable "cpu_threshold" {
  description = "CPU utilization threshold percentage for alarms"
  type        = number
  default     = 80
}

variable "alb_5xx_threshold" {
  description = "ALB 5xx error count threshold for alarms"
  type        = number
  default     = 10
}

variable "tags" {
  description = "Common tags to apply to all resources"
  type        = map(string)
  default     = {}
}
