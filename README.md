# Terraform Modular Web App

Modular Terraform infrastructure for a web application hosted on AWS. The project is structured around reusable modules and separated environments.

## Project Structure

```
terraform-modular-webapp/
├── modules/
│   ├── vpc/             # VPC, subnets, internet gateway, NAT gateway, route tables
│   ├── security_group/  # Security groups
│   ├── ec2_instance/    # EC2 instances
│   ├── alb/             # Application Load Balancer
│   ├── rds/             # RDS database
│   ├── s3_bucket/       # S3 bucket
│   └── iam/             # IAM roles and policies (EC2 access to S3 and other AWS services)
├── envs/
│   ├── dev/             # Development environment
│   └── prod/            # Production environment
└── README.md
```

## Infrastructure Overview

- **VPC** with public and private subnets across 2 availability zones (eu-central-1a, eu-central-1b)
- **Public subnets** — for ALB and bastion host (internet-facing)
- **Private subnets** — for backend EC2 instances and RDS database (isolated from the internet)
- **Internet Gateway** — allows inbound/outbound internet access from public subnets
- **NAT Gateway** — allows outbound internet access from private subnets (e.g. package updates)
- **Route Tables** — public route table (→ IGW) and private route table (→ NAT Gateway)
- **Security Groups** — ALB SG (HTTP/HTTPS from internet), Bastion SG (SSH from my IP only), EC2 SG (SSH from bastion, HTTP from ALB), RDS SG (PostgreSQL from EC2 only)
- **ALB** — internet-facing Application Load Balancer with HTTPS listener, distributes traffic across backend instances
- **Bastion** — jump host in public subnet for SSH access to private EC2 instances

## Module Status

| Module         | Status   |
|----------------|----------|
| vpc            | Done     |
| security_group | Done     |
| ec2_instance   | Done     |
| alb            | Done     |
| rds            | Done     |
| s3_bucket      | In Progress |
| iam            | Planned  |

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
