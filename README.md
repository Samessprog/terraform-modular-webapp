# Terraform Modular Web App

Modular Terraform infrastructure for a web application hosted on AWS. The project is structured around reusable modules and separated environments.

## Project Structure

```
terraform-modular-webapp/
├── modules/
│   ├── vpc/             # VPC, subnets, internet gateway, route tables
│   ├── security_group/  # Security groups
│   ├── ec2_instance/    # EC2 instances
│   ├── rds/             # RDS database
│   └── s3_bucket/       # S3 bucket
├── envs/
│   ├── dev/             # Development environment
│   └── prod/            # Production environment
└── README.md
```

## Infrastructure Overview

- **VPC** with public and private subnets across 2 availability zones (us-east-1a, us-east-1b)
- **Public subnets** — for EC2 instances accessible from the internet
- **Private subnets** — for RDS database, isolated from the internet
- **Internet Gateway** — allows outbound internet access from public subnets

## Requirements

- Terraform >= 1.5.0
- AWS CLI configured with appropriate profile
- AWS Provider ~> 5.0

## Usage

```bash
cd envs/dev
terraform init
terraform plan
terraform apply
```
