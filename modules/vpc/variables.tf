variable "vpc_cidr" {
  description = "CIDR block for the VPC"
  type        = string
  default     = "10.0.0.0/16"
}

variable "environment" {
  description = "Environment name (e.g. dev, prod)"
  type        = string
}

variable "public_subnet_1a_cidr" {
  description = "CIDR block for public subnet in eu-central-1a"
  type        = string
  default     = "10.0.1.0/24"
}

variable "public_subnet_1b_cidr" {
  description = "CIDR block for public subnet in eu-central-1b"
  type        = string
  default     = "10.0.2.0/24"
}

variable "private_subnet_1a_cidr" {
  description = "CIDR block for private subnet in eu-central-1a"
  type        = string
  default     = "10.0.3.0/24"
}

variable "private_subnet_1b_cidr" {
  description = "CIDR block for private subnet in eu-central-1b"
  type        = string
  default     = "10.0.4.0/24"
}

variable "tags" {
  description = "Common tags to apply to all resources"
  type        = map(string)
  default     = {}
}
