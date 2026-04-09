# Terraform Modular Web App

Modular Terraform infrastructure for a web application hosted on AWS. The project is structured around reusable modules and separated environments.

## Project Structure

```
terraform-modular-webapp/
├── modules/
│   ├── vpc/             # VPC, subnets, internet gateway, NAT gateway, route tables
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

- **VPC** with public and private subnets across 2 availability zones (eu-central-1a, eu-central-1b)
- **Public subnets** — for EC2 instances accessible from the internet
- **Private subnets** — for RDS database and EC2 instances isolated from the internet
- **Internet Gateway** — allows inbound/outbound internet access from public subnets
- **NAT Gateway** — allows outbound internet access from private subnets (e.g. package updates)
- **Route Tables** — public route table (→ IGW) and private route table (→ NAT Gateway)

## Module Status

| Module         | Status      |
|----------------|-------------|
| vpc            | Done        |
| security_group | In progress |
| ec2_instance   | Planned     |
| rds            | Planned     |
| s3_bucket      | Planned     |

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
