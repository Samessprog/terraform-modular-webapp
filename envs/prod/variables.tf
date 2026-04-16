variable "environment" {
  description = "Environment name"
  type        = string
  default     = "prod"

  validation {
    condition     = contains(["dev", "prod"], var.environment)
    error_message = "Environment must be dev or prod."
  }
}

variable "vpc_cidr" {
  description = "CIDR block for the VPC"
  type        = string
  default     = "10.1.0.0/16"

  validation {
    condition     = can(cidrnetmask(var.vpc_cidr))
    error_message = "VPC CIDR must be a valid CIDR block."
  }
}

variable "public_subnet_1a_cidr" {
  description = "CIDR block for public subnet in eu-central-1a"
  type        = string
  default     = "10.1.1.0/24"

  validation {
    condition     = can(cidrnetmask(var.public_subnet_1a_cidr))
    error_message = "Public subnet 1a CIDR must be a valid CIDR block."
  }
}

variable "public_subnet_1b_cidr" {
  description = "CIDR block for public subnet in eu-central-1b"
  type        = string
  default     = "10.1.2.0/24"

  validation {
    condition     = can(cidrnetmask(var.public_subnet_1b_cidr))
    error_message = "Public subnet 1b CIDR must be a valid CIDR block."
  }
}

variable "private_subnet_1a_cidr" {
  description = "CIDR block for private subnet in eu-central-1a"
  type        = string
  default     = "10.1.3.0/24"

  validation {
    condition     = can(cidrnetmask(var.private_subnet_1a_cidr))
    error_message = "Private subnet 1a CIDR must be a valid CIDR block."
  }
}

variable "private_subnet_1b_cidr" {
  description = "CIDR block for private subnet in eu-central-1b"
  type        = string
  default     = "10.1.4.0/24"

  validation {
    condition     = can(cidrnetmask(var.private_subnet_1b_cidr))
    error_message = "Private subnet 1b CIDR must be a valid CIDR block."
  }
}

variable "my_ip" {
  description = "My IP address for SSH access in CIDR format (e.g. 1.2.3.4/32)"
  type        = string

  validation {
    condition     = can(cidrnetmask(var.my_ip))
    error_message = "my_ip must be a valid CIDR block (e.g. 1.2.3.4/32)."
  }
}

variable "key_name" {
  description = "SSH key pair name for EC2 instance access"
  type        = string
}

variable "db_user_name" {
  description = "user for RDS"
  type        = string
}

variable "db_password" {
  description = "password for RDS"
  type        = string
  sensitive   = true

  validation {
    condition     = length(var.db_password) >= 8
    error_message = "Database password must be at least 8 characters."
  }
}

variable "db_name" {
  description = "RDS name"
  type        = string
}

variable "domain_name" {
  description = "my domain name for cert"
  type        = string
  default     = "nerox.xyz"
}

variable "alarm_email" {
  description = "Email address for CloudWatch alarm notifications"
  type        = string

  validation {
    condition     = strcontains(var.alarm_email, "@")
    error_message = "alarm_email must be a valid email address."
  }
}
