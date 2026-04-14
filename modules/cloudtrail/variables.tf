variable "environment" {
  description = "Environment name"
  type        = string
}

variable "s3_bucket_name" {
  description = "S3 bucket name for CloudTrail logs"
  type        = string
}

variable "name" {
  description = "CloudTrail name"
  type        = string
  default     = "cloudtrail"
}

