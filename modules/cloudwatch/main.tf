terraform {
  required_version = ">= 1.5.0"
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 5.0"
    }
  }
}


resource "aws_sns_topic" "alerts_topic" {
  name = "${var.environment}-alerts"
  tags = {
    Environment = var.environment
  }
}

resource "aws_sns_topic_subscription" "topic_subscription" {
  topic_arn = aws_sns_topic.alerts_topic.arn
  endpoint  = var.alarm_email
  protocol  = "email"
}


resource "aws_cloudwatch_metric_alarm" "EC2_CPU_alert" {
  for_each            = var.ec2_instance_ids
  alarm_name          = "${var.environment}-ec2-cpu-${each.key}"
  namespace           = "AWS/EC2"
  metric_name         = "CPUUtilization"
  comparison_operator = "GreaterThanThreshold"
  evaluation_periods  = 2
  period              = 300
  threshold           = var.cpu_threshold
  statistic           = "Average"
  dimensions          = { InstanceId = each.value }
  alarm_actions       = [aws_sns_topic.alerts_topic.arn]
}

resource "aws_cloudwatch_metric_alarm" "ALB_5xx_alert" {
  alarm_name          = "${var.environment}-alb-5xx"
  comparison_operator = "GreaterThanThreshold"
  evaluation_periods  = 2
  namespace           = "AWS/ApplicationELB"
  alarm_actions       = [aws_sns_topic.alerts_topic.arn]
  metric_name         = "HTTPCode_ELB_5XX_Count"
  statistic           = "Sum"
  threshold           = 10
  period              = 60
  treat_missing_data  = "notBreaching"
  dimensions          = { LoadBalancer = var.alb_arn_suffix }
}

resource "aws_cloudwatch_metric_alarm" "rds_cpu_alert" {
  alarm_name          = "${var.environment}-rds-cpu"
  namespace           = "AWS/RDS"
  metric_name         = "CPUUtilization"
  comparison_operator = "GreaterThanThreshold"
  evaluation_periods  = 2
  period              = 300
  threshold           = var.cpu_threshold
  statistic           = "Average"
  dimensions          = { DBInstanceIdentifier = var.rds_identifier }
  alarm_actions       = [aws_sns_topic.alerts_topic.arn]
}
