terraform {
  required_providers {
    aws = {
      source                = "hashicorp/aws"
      configuration_aliases = [aws.us_east_1]
    }
  }
}

resource "aws_acm_certificate" "alb_certificate" {
  domain_name = var.domain_name
  validation_method = "DNS"

}

resource "aws_acm_certificate" "cloudfront_certificate" {
  domain_name = var.domain_name
  validation_method = "DNS"

  provider = aws.us_east_1

}