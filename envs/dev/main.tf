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
  my_ec2_ip = var.my_ip
}