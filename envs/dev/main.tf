module "vpc" {
  source = "../../modules/vpc"

  environment            = var.environment
  vpc_cidr               = var.vpc_cidr
  public_subnet_1a_cidr  = var.public_subnet_1a_cidr
  public_subnet_1b_cidr  = var.public_subnet_1b_cidr
  private_subnet_1a_cidr = var.private_subnet_1a_cidr
  private_subnet_1b_cidr = var.private_subnet_1b_cidr
}

module "security_group" {
  source = "../../modules/security_group"
  environment            = var.environment
  vpc_id = module.vpc.vpc_id
  my_ip = var.my_ip
}

module "bastion" {
  source = "../../modules/ec2_instance"
  environment       = var.environment
  name              = "bastion"
  instance_type     = "t3.micro"
  subnet_id         = module.vpc.public_subnet_1a_id
  security_group_id = module.security_group.bastion_sg_id
  key_name          = var.key_name
}

module "backend_1a" {
  source            = "../../modules/ec2_instance"
  environment       = var.environment
  name              = "backend-1a"
  subnet_id         = module.vpc.private_subnet_1a_id
  security_group_id = module.security_group.ec2_sg_id
  key_name          = var.key_name
}

module "backend_1b" {
  source            = "../../modules/ec2_instance"
  environment       = var.environment
  name              = "backend-1b"
  subnet_id         = module.vpc.private_subnet_1b_id
  security_group_id = module.security_group.ec2_sg_id
  key_name          = var.key_name
}


resource "local_file" "ssh_info" {
  content  = <<-EOT
      bastion_ip       = ${module.bastion.public_ip}
      backend_1a_ip    = ${module.backend_1a.private_ip}
      backend_1b_ip    = ${module.backend_1b.private_ip}
    EOT
  filename = "${path.module}/ssh_info.txt"
}
