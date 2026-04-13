terraform {
  required_version = ">= 1.5.0"
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 5.0"
    }
    local = {
      source  = "hashicorp/local"
      version = "~> 2.0"
    }
  }
  backend "local" {
    path = "terraform.tfstate"
  }
}

provider "aws" {
  region  = "eu-central-1"
  profile = "default"
}

provider "aws" {
  alias   = "us_east_1"
  region  = "us-east-1"
  profile = "default"
}
