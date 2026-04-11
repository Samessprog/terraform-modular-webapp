output "bastion_ip" {
  value = module.bastion.public_ip
}

output "db_port" {
  value = module.rds.db_port
}

output "db_endpoint" {
  value = module.rds.db_endpoint
}
