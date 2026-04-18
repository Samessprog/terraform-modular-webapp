terraform {
  required_version = ">= 1.5.0"
  required_providers {
    aws = {
      source                = "hashicorp/aws"
      version               = "~> 5.0"
      configuration_aliases = [aws.us_east_1]
    }
  }
}

resource "aws_acm_certificate" "alb_certificate" {
  domain_name       = var.domain_name
  validation_method = "DNS"
  tags              = var.tags
}

resource "aws_acm_certificate" "cloudfront_certificate" {
  domain_name       = var.domain_name
  validation_method = "DNS"
  provider          = aws.us_east_1
  tags              = var.tags
}