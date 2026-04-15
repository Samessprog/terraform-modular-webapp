# Terraform Modular Web App

![Terraform](https://img.shields.io/badge/Terraform-%3E%3D1.5.0-623CE4?logo=terraform)
![CI](https://github.com/sames/terraform-modular-webapp/actions/workflows/ci.yml/badge.svg)
![AWS](https://img.shields.io/badge/AWS-eu--central--1-FF9900?logo=amazonaws)

Modular Terraform infrastructure for a production-grade web application hosted on AWS. Demonstrates real-world patterns: reusable modules, multi-environment setup (dev/prod), remote state management, security best practices, observability, and automated CI/CD pipeline.

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
               │                         80 → 443 redirect
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
                  backups: 7 days           versioning enabled
                                                 ▲
                                        IAM Role (no hardcoded creds)

  ┌─ Observability ──────────────────────────────────────────────────┐
  │  CloudWatch Alarms → SNS → Email   (CPU, ALB 5xx, RDS)          │
  │  CloudTrail → S3                   (all API calls, multi-region) │
  └──────────────────────────────────────────────────────────────────┘
```

## Project Structure

```
terraform-modular-webapp/
├── bootstrap/           # One-time setup: remote state S3 bucket + DynamoDB lock table
├── modules/
│   ├── vpc/             # VPC, subnets, internet gateway, NAT gateway, route tables
│   ├── security_group/  # Security groups (ALB, Bastion, EC2, RDS) — least-privilege
│   ├── ec2_instance/    # EC2 instances (bastion + 2x backend across AZs)
│   ├── alb/             # Application Load Balancer, HTTPS listener, HTTP→HTTPS redirect
│   ├── rds/             # RDS PostgreSQL — backups, final snapshot on destroy
│   ├── acm/             # ACM certificates (eu-central-1 for ALB, us-east-1 for CloudFront)
│   ├── s3_bucket/       # Reusable S3 module (frontend static hosting + backend storage)
│   ├── iam/             # IAM roles and instance profiles (EC2 → S3 access)
│   ├── cloudtrail/      # AWS API audit logging to S3, multi-region, log validation
│   └── cloudwatch/      # CloudWatch alarms (EC2/ALB/RDS) + SNS email notifications
├── envs/
│   ├── dev/             # Development environment (10.0.0.0/16)
│   └── prod/            # Production environment (10.1.0.0/16)
├── .github/
│   └── workflows/
│       └── ci.yml       # CI pipeline (fmt, validate, tflint, tfsec)
└── .pre-commit-config.yaml  # Pre-commit hooks (fmt, validate, tflint)
```

## Infrastructure Overview

### Networking
- **VPC** with public and private subnets across 2 availability zones (eu-central-1a, eu-central-1b)
- **Internet Gateway** — inbound/outbound internet access for public subnets
- **NAT Gateway** — outbound internet access from private subnets (no public IPs on backends)
- **Route Tables** — public (→ IGW) and private (→ NAT Gateway)

### Compute & Load Balancing
- **ALB** — internet-facing Application Load Balancer, HTTPS on port 443, HTTP→HTTPS redirect (301)
- **EC2 Bastion** — jump host in public subnet for SSH access to private instances
- **EC2 Backend x2** — application servers in private subnets, one per AZ (1a, 1b)

### Storage & CDN
- **S3 Frontend** — static website hosting (HTML/JS/CSS), public read via CloudFront
- **S3 Backend** — file storage for backend (uploads, assets), versioning enabled
- **CloudFront** — CDN distribution serving frontend from S3 with HTTPS (planned)

### Security
- **Security Groups** — separate SGs for ALB, Bastion, EC2, RDS with least-privilege rules
- **ACM** — SSL/TLS certificates for ALB (eu-central-1) and CloudFront (us-east-1), multi-region
- **IAM Roles** — EC2 instance profile with scoped S3 access, no hardcoded credentials
- **Private Subnets** — EC2 backends and RDS are not reachable from the internet

### Database
- **RDS PostgreSQL 16** — db.t3.micro in private subnet
- Automated backups: `backup_retention_period = 7` days
- `skip_final_snapshot = false` — snapshot created on destroy

### Observability
- **CloudTrail** — all AWS API calls logged to S3, multi-region, log file validation enabled
- **CloudWatch Alarms** — EC2 CPU > 75%, ALB 5xx errors > 10/min, RDS CPU > 75%
- **SNS** — email notifications triggered by any CloudWatch alarm

### State Management
- **Remote State** — Terraform state stored in S3 with DynamoDB state locking
- **Per-environment state** — `dev/terraform.tfstate`, `prod/terraform.tfstate`
- **Bootstrap** — separate root module to provision S3 + DynamoDB before first apply

## CI/CD Pipeline

Every pull request triggers:

| Step | Tool | Purpose |
|------|------|---------|
| Format check | `terraform fmt -check` | Enforce consistent formatting |
| Validate | `terraform validate` | Syntax and configuration check |
| Lint | `tflint` | Terraform-specific linting rules |
| Security scan | `tfsec` | Detect security misconfigurations |

Pre-commit hooks run `fmt`, `validate` and `tflint` locally before every commit.

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
| iam            | Done     |
| cloudtrail     | Done     |
| cloudwatch     | Done     |
| cloudfront     | Planned  |
| secrets_manager| Planned  |

## Environments

| Environment | VPC CIDR     | State key              |
|-------------|--------------|------------------------|
| dev         | 10.0.0.0/16  | dev/terraform.tfstate  |
| prod        | 10.1.0.0/16  | prod/terraform.tfstate |

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
cd envs/dev        # or envs/prod
terraform init
terraform plan
terraform apply
```
