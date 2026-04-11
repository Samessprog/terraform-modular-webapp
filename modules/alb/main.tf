
resource "aws_lb" "main" {
  name               = "${var.environment}-alb"
  internal           = false
  load_balancer_type = "application"
  security_groups    = [var.security_group_id]
  subnets            = var.subnet_ids

  tags = {
    Name        = "${var.environment}-alb"
    Environment = var.environment
  }
}

resource "aws_lb_target_group" "lb-group" {
  name     = "${var.environment}-tg"
  vpc_id   = var.vpc_id
  protocol = "HTTP"
  port     = 80

  health_check {
    path     = "/"
    protocol = "HTTP"
  }
}

resource "aws_lb_listener" "lb-listener" {
  load_balancer_arn = aws_lb.main.arn
  port              = 443
  protocol          = "HTTPS"
  certificate_arn   = var.certificate_arn
  default_action {
    type             = "forward"
    target_group_arn = aws_lb_target_group.lb-group.arn
  }
}

resource "aws_lb_target_group_attachment" "backends" {
  for_each         = var.instance_ids
  target_group_arn = aws_lb_target_group.lb-group.arn
  target_id        = each.value
  port             = 80
}