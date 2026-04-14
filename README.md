# Terraform Modular Web App

Modular Terraform infrastructure for a web application hosted on AWS. The project demonstrates real-world infrastructure patterns using reusable modules, separated environments, remote state management, and automated CI/CD pipeline.

## Architecture

```
                        ┌─────────────┐
                        │    USER     │
                        └──────┬──────┘
                               │
               ┌───────────────┴───────────────┐
               │                               │
               ▼                               ▼
         CloudFront                           ALB
    (cdn.nerox.xyz)                   (api.nerox.xyz)
    ACM cert us-east-1                ACM cert eu-central-1
               │                               │
               ▼                          ┌────┴────┐
          S3 Frontend                     ▼         ▼
         (HTML/JS/CSS)               EC2-1a      EC2-1b
                                    (private)   (private)
                                         │         │
                                    ┌────┴─────────┘
                                    │
                       ┌────────────┴────────────┐
                       ▼                         ▼
                  RDS PostgreSQL             S3 Backend
                  (private subnet)          (uploads/files)
                                                 ▲
                                        IAM Role (EC2 access)
```

## Project Structure

```
terraform-modular-webapp/
├── bootstrap/           # One-time setup: remote state S3 bucket + DynamoDB lock table
├── modules/
│   ├── vpc/             # VPC, subnets, internet gateway, NAT gateway, route tables
│   ├── security_group/  # Security groups (ALB, Bastion, EC2, RDS)
│   ├── ec2_instance/    # EC2 instances (bastion + backend)
│   ├── alb/             # Application Load Balancer with HTTPS listener
│   ├── rds/             # RDS PostgreSQL database
│   ├── acm/             # ACM certificates (eu-central-1 for ALB, us-east-1 for CloudFront)
│   ├── s3_bucket/       # S3 buckets (frontend static hosting + backend file storage)
│   └── iam/             # IAM roles and instance profiles (EC2 access to S3)
├── envs/
│   ├── dev/             # Development environment
│   └── prod/            # Production environment
├── .github/
│   └── workflows/
│       └── ci.yml       # CI pipeline (fmt, validate, tflint, tfsec)
└── .pre-commit-config.yaml  # Pre-commit hooks for local development
```

## Infrastructure Overview

### Networking
- **VPC** with public and private subnets across 2 availability zones (eu-central-1a, eu-central-1b)
- **Internet Gateway** — inbound/outbound internet access for public subnets
- **NAT Gateway** — outbound internet access from private subnets
- **Route Tables** — public (→ IGW) and private (→ NAT Gateway)

### Compute & Load Balancing
- **ALB** — internet-facing Application Load Balancer with HTTPS listener (ACM certificate)
- **EC2 Bastion** — jump host in public subnet for SSH access to private instances
- **EC2 Backend x2** — application servers in private subnets across 2 AZs

### Storage & CDN
- **S3 Frontend** — static website hosting (HTML/JS/CSS)
- **S3 Backend** — file storage for backend (uploads, assets) with versioning enabled
- **CloudFront** — CDN distribution serving frontend from S3 with HTTPS

### Security
- **Security Groups** — ALB SG, Bastion SG, EC2 SG, RDS SG with least-privilege rules
- **ACM** — SSL/TLS certificates for ALB (eu-central-1) and CloudFront (us-east-1)
- **IAM Roles** — EC2 instance profile with S3 access (no hardcoded credentials)
- **Private Subnets** — EC2 backend and RDS isolated from the internet

### Database
- **RDS PostgreSQL** — db.t3.micro in private subnet with automated backups

### State Management
- **Remote State** — Terraform state stored in S3 with DynamoDB state locking
- **State per environment** — `dev/terraform.tfstate`, `prod/terraform.tfstate`

## CI/CD Pipeline

Every pull request triggers:

| Step | Tool | Purpose |
|------|------|---------|
| Format check | `terraform fmt -check` | Enforce consistent formatting |
| Validate | `terraform validate` | Syntax and configuration check |
| Lint | `tflint` | Terraform-specific linting |
| Security scan | `tfsec` | Detect misconfigurations |

Pre-commit hooks run the same checks locally before every commit.

## Module Status

| Module         | Status   |
|----------------|----------|
| vpc            | Done     |
| security_group | Done     |
| ec2_instance   | Done     |
| alb            | Done     |
| rds            | Done     |
| acm            | Done     |
| s3_bucket      | Done     |
| iam            | In Progress |

## Requirements

- Terraform >= 1.5.0
- AWS CLI configured with appropriate profile
- AWS Provider ~> 5.0

## Usage

### First time setup (remote state)

```bash
cd bootstrap
terraform init
terraform apply
```

### Deploy environment

```bash
cd envs/dev
terraform init
terraform plan
terraform apply
```
