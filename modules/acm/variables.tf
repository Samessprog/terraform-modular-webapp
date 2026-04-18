variable "domain_name" {
  default     = "nerox.xyz"
  description = "Domain name for ACM certificates"
  type        = string
}

variable "tags" {
  description = "Common tags to apply to all resources"
  type        = map(string)
  default     = {}
}