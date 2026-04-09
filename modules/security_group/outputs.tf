output "ec2_sg_id" {
  value = aws_security_group.sg_ec2.id
}

output "rds_sg_id" {
  value = aws_security_group.sg_rds.id
}
