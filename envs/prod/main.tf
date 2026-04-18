terraform {
  backend "s3" {
    bucket         = "terraform-state-modular-webapp"
    key            = "prod/terraform.tfstate"
    region         = "eu-central-1"
    dynamodb_table = "terraform-state-lock-modular-webapp"
    encrypt        = true
  }
}

locals {
  common_tags = {
    Project     = "terraform-modular-webapp"
    Environment = var.environment
    ManagedBy   = "Terraform"
  }
}

module "vpc" {
  source = "../../modules/vpc"

  environment            = var.environment
  vpc_cidr               = var.vpc_cidr
  public_subnet_1a_cidr  = var.public_subnet_1a_cidr
  public_subnet_1b_cidr  = var.public_subnet_1b_cidr
  private_subnet_1a_cidr = var.private_subnet_1a_cidr
  private_subnet_1b_cidr = var.private_subnet_1b_cidr
  tags                   = local.common_tags
}

module "security_group" {
  source      = "../../modules/security_group"
  environment = var.environment
  vpc_id      = module.vpc.vpc_id
  my_ip       = var.my_ip
  tags        = local.common_tags
}

module "bastion" {
  source            = "../../modules/ec2_instance"
  environment       = var.environment
  name              = "bastion"
  instance_type     = "t3.micro"
  subnet_id         = module.vpc.public_subnet_1a_id
  security_group_id = module.security_group.bastion_sg_id
  key_name          = var.key_name
  tags              = local.common_tags
}

module "backend_1a" {
  source               = "../../modules/ec2_instance"
  environment          = var.environment
  name                 = "backend-1a"
  subnet_id            = module.vpc.private_subnet_1a_id
  security_group_id    = module.security_group.ec2_sg_id
  key_name             = var.key_name
  iam_instance_profile = module.iam.instance_profile_name
  tags                 = local.common_tags
}

module "backend_1b" {
  source               = "../../modules/ec2_instance"
  environment          = var.environment
  name                 = "backend-1b"
  subnet_id            = module.vpc.private_subnet_1b_id
  security_group_id    = module.security_group.ec2_sg_id
  key_name             = var.key_name
  iam_instance_profile = module.iam.instance_profile_name
  tags                 = local.common_tags
}

module "alb" {
  source            = "../../modules/alb"
  security_group_id = module.security_group.alb_sg_id
  subnet_ids        = [module.vpc.public_subnet_1a_id, module.vpc.public_subnet_1b_id]
  environment       = var.environment
  vpc_id            = module.vpc.vpc_id
  certificate_arn   = module.acm.alb_certificate_arn
  instance_ids = {
    backend_1a = module.backend_1a.instance_id
    backend_1b = module.backend_1b.instance_id
  }
  tags = local.common_tags
}

module "secretsmanager" {
  source      = "../../modules/secret-manager"
  environment = var.environment
  db_username = var.db_user_name
  db_password = var.db_password
  tags        = local.common_tags
}

module "rds" {
  source            = "../../modules/rds"
  environment       = var.environment
  subnet_ids        = [module.vpc.private_subnet_1a_id, module.vpc.private_subnet_1b_id]
  security_group_id = module.security_group.rds_sg_id
  instance_class    = "db.t3.micro"
  db_name           = var.db_name
  db_user_name      = var.db_user_name
  secret_arn        = module.secretsmanager.secret_arn
  tags              = local.common_tags
}

resource "local_file" "ssh_info" {
  content  = <<-EOT
      bastion_ip       = ${module.bastion.public_ip}
      backend_1a_ip    = ${module.backend_1a.private_ip}
      backend_1b_ip    = ${module.backend_1b.private_ip}
    EOT
  filename = "${path.module}/ssh_info.txt"
}

module "acm" {
  source      = "../../modules/acm"
  domain_name = var.domain_name
  tags        = local.common_tags

  providers = {
    aws           = aws
    aws.us_east_1 = aws.us_east_1
  }
}

module "s3_frontend" {
  source             = "../../modules/s3_bucket"
  bucket_name        = "frontend-${var.environment}-nerox"
  versioning_enabled = false

  tags = merge(local.common_tags, {
    Purpose = "frontend"
  })
}

module "s3_backend" {
  source             = "../../modules/s3_bucket"
  bucket_name        = "backend-${var.environment}-nerox"
  versioning_enabled = true

  tags = merge(local.common_tags, {
    Purpose = "backend"
  })
}

module "iam" {
  source = "../../modules/iam"

  environment           = var.environment
  s3_backend_bucket_arn = module.s3_backend.bucket_arn
  tags                  = local.common_tags
}

module "cloudtrail" {
  source         = "../../modules/cloudtrail"
  environment    = var.environment
  s3_bucket_name = module.s3_backend.bucket_id
  tags           = local.common_tags
}

module "cloudwatch" {
  source      = "../../modules/cloudwatch"
  environment = var.environment
  alarm_email = var.alarm_email
  ec2_instance_ids = {
    backend_1a = module.backend_1a.instance_id
    backend_1b = module.backend_1b.instance_id
  }
  alb_arn_suffix = module.alb.alb_arn_suffix
  rds_identifier = module.rds.rds_identifier
  cpu_threshold  = 75
  tags           = local.common_tags
}
