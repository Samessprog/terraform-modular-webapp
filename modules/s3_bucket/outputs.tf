output "bucket_id" {
  value = aws_s3_bucket.bucket_name.id
}

output "bucket_arn" {
  value = aws_s3_bucket.bucket_name.arn
}

output "bucket_domain_name" {
  description = "Regional domain name of the S3 bucket"
  value       = aws_s3_bucket.bucket_name.bucket_regional_domain_name
}
