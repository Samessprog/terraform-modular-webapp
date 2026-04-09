variable "vpc_id" {
  description = "VPC ID"
  type        = string
}

variable "environment" {
  description = "Environment name (e.g. dev, prod)"
  type        = string
}

variable "my_ec2_ip" {
  description = "My IP address for SSH access in CIDR format"
  type        = string
}
