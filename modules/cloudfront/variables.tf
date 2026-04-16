variable "environment" {
  description = "Environment name"
  type        = string
}

variable "s3_bucket_domain_name" {
  description = "Regional domain name of the S3 frontend bucket"
  type        = string
}

variable "s3_bucket_id" {
  description = "ID (name) of the S3 frontend bucket for bucket policy"
  type        = string
}

variable "acm_certificate_arn" {
  description = "ACM certificate ARN from us-east-1 for CloudFront HTTPS"
  type        = string
}

variable "domain_name" {
  description = "Custom domain name for CloudFront alias (e.g. cdn.nerox.xyz)"
  type        = string
}
