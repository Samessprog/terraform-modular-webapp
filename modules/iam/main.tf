terraform {
  required_version = ">= 1.5.0"
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 5.0"
    }
  }
}

data "aws_iam_policy_document" "assume_role_policy" {
  statement {
    effect  = "Allow"
    actions = ["sts:AssumeRole"]
    principals {
      type        = "Service"
      identifiers = ["ec2.amazonaws.com"]
    }
  }
}

data "aws_iam_policy_document" "s3_policy" {
  statement {
    effect    = "Allow"
    actions   = ["s3:GetObject", "s3:PutObject", "s3:DeleteObject"]
    resources = ["${var.s3_backend_bucket_arn}/*"]
  }
}

resource "aws_iam_role" "role" {
  name               = "${var.environment}-ec2-role"
  assume_role_policy = data.aws_iam_policy_document.assume_role_policy.json

  tags = {
    Environment = var.environment
  }
}

resource "aws_iam_role_policy" "role_policy" {
  name   = "${var.environment}-ec2-s3-policy"
  role   = aws_iam_role.role.id
  policy = data.aws_iam_policy_document.s3_policy.json
}

resource "aws_iam_instance_profile" "instance_profile" {
  name = "${var.environment}-ec2-profile"
  role = aws_iam_role.role.name
}