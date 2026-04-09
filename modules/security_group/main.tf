resource "aws_security_group" "sg_ec2" {
  name        = "${var.environment}-ec2-sg"
  description = "EC2 security group"
  vpc_id      = var.vpc_id

  tags = {
    Name        = "${var.environment}-ec2-sg"
    Environment = var.environment
  }
}

resource "aws_vpc_security_group_egress_rule" "sg_egress_ec2" {
  ip_protocol       = "-1"
  cidr_ipv4 = "0.0.0.0/0"
  security_group_id = aws_security_group.sg_ec2.id
}

resource "aws_vpc_security_group_ingress_rule" "sg_ingress_ssh_ec2" {
  from_port         = 22
  to_port           = 22
  cidr_ipv4         = var.my_ec2_ip
  ip_protocol       = "tcp"
  security_group_id = aws_security_group.sg_ec2.id
}

resource "aws_vpc_security_group_ingress_rule" "sg_ingress_http_ec2" {
  from_port         = 80
  to_port           = 80
  cidr_ipv4         = "0.0.0.0/0"
  ip_protocol       = "tcp"
  security_group_id = aws_security_group.sg_ec2.id
}

resource "aws_vpc_security_group_ingress_rule" "sg_ingress_https_ec2" {
  from_port         = 443
  to_port           = 443
  cidr_ipv4         = "0.0.0.0/0"
  ip_protocol       = "tcp"
  security_group_id = aws_security_group.sg_ec2.id
}

resource "aws_security_group" "sg_rds" {
  name        = "${var.environment}-rds-sg"
  description = "RDS security group"
  vpc_id      = var.vpc_id

  tags = {
    Name        = "${var.environment}-rds-sg"
    Environment = var.environment
  }
}

resource "aws_vpc_security_group_ingress_rule" "sg_ingress_rds" {
  ip_protocol                  = "tcp"
  security_group_id            = aws_security_group.sg_rds.id
  referenced_security_group_id = aws_security_group.sg_ec2.id
  from_port                    = 5432
  to_port                      = 5432
}
