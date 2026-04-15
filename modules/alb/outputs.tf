output "lb_dns_name" {
  value = aws_lb.main.dns_name
}

output "lb_target_group_arn" {
  value = aws_lb_target_group.lb-group.arn
}

output "alb_arn_suffix" {
  description = "ARN suffix of the ALB for CloudWatch dimensions"
  value       = aws_lb.main.arn_suffix
}