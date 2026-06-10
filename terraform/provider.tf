# Main provider configuration with strict version locking
terraform {
  required_version = ">= 1.5.7"  # Minimum version for AWS provider 6.0 [citation:1]
  
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = ">= 6.0, < 7.0"  # AWS provider 6.x [citation:1][citation:6]
    }
    random = {
      source  = "hashicorp/random"
      version = "~> 3.6"
    }
    tls = {
      source  = "hashicorp/tls"
      version = ">= 4.0"  # Required for EKS module [citation:1]
    }
  }
  
  # Optional: Backend configuration for state management (S3 + DynamoDB)
  # backend "s3" {
  #   bucket         = "your-terraform-state-bucket"
  #   key            = "eks-insureme/terraform.tfstate"
  #   region         = "ap-south-1"
  #   dynamodb_table = "terraform-state-lock"
  #   encrypt        = true
  # }
}

# AWS Provider configuration
provider "aws" {
  region = var.aws_region
  
  default_tags {
    tags = {
      Environment = var.environment
      Project     = "insureme"
      ManagedBy   = "Terraform"
    }
  }
}