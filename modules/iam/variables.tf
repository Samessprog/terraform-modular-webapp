variable "environment" {
  description = "Environment name"
  type        = string
}

variable "s3_backend_bucket_arn" {
  description = "ARN of the S3 backend bucket that EC2 instances will have access to"
  type        = string
}
