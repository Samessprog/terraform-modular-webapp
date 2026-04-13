variable "environment" {
  description = "Environment name"
  type        = string
  default     = "dev"
}

variable "vpc_cidr" {
  description = "CIDR block for the VPC"
  type        = string
  default     = "10.0.0.0/16"
}

variable "public_subnet_1a_cidr" {
  description = "CIDR block for public subnet in us-east-1a"
  type        = string
  default     = "10.0.1.0/24"
}

variable "public_subnet_1b_cidr" {
  description = "CIDR block for public subnet in us-east-1b"
  type        = string
  default     = "10.0.2.0/24"
}

variable "private_subnet_1a_cidr" {
  description = "CIDR block for private subnet in us-east-1a"
  type        = string
  default     = "10.0.3.0/24"
}

variable "private_subnet_1b_cidr" {
  description = "CIDR block for private subnet in us-east-1b"
  type        = string
  default     = "10.0.4.0/24"
}

variable "my_ip" {
  description = "My IP address for SSH access in CIDR format (e.g. 1.2.3.4/32)"
  type        = string
}

variable "key_name" {
  description = "SSH key pair name for EC2 instance access"
  type        = string
}

variable "db_user_name" {
  description = "user for RDS"
  type = string
}

variable "db_password" {
  description = "password for RDS"
  type = string
  sensitive = true
}

variable "db_name" {
  description = "RDS name"
  type = string
}

variable "domain_name" {
  description = "my domain name for cert"
  type = string
  default = "nerox.xyz"
}