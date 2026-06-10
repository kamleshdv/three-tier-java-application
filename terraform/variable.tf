# AWS Configuration
variable "aws_region" {
  description = "AWS region"
  type        = string
  default     = "ap-south-1"  # Mumbai region
}

variable "environment" {
  description = "Environment name"
  type        = string
  default     = "production"
}

# EKS Configuration
variable "cluster_name" {
  description = "EKS cluster name"
  type        = string
  default     = "insureme-eks"
}

variable "kubernetes_version" {
  description = "Kubernetes version"
  type        = string
  default     = "1.30"  # Latest stable
}

# Node Groups Configuration
variable "frontend_node_group" {
  description = "Frontend node group configuration"
  type = object({
    desired_size = number
    max_size     = number
    min_size     = number
    instance_types = list(string)
  })
  default = {
    desired_size   = 1
    max_size       = 2
    min_size       = 1
    instance_types = ["t3.small"]
  }
}

variable "backend_node_group" {
  description = "Backend node group configuration"
  type = object({
    desired_size = number
    max_size     = number
    min_size     = number
    instance_types = list(string)
  })
  default = {
    desired_size   = 1
    max_size       = 2
    min_size       = 1
    instance_types = ["t3.small"]
  }
}

variable "redis_node_group" {
  description = "Redis node group configuration"
  type = object({
    desired_size = number
    max_size     = number
    min_size     = number
    instance_types = list(string)
  })
  default = {
    desired_size   = 1
    max_size       = 2
    min_size       = 1
    instance_types = ["t3.micro"]
  }
}

# VPC Configuration
variable "vpc_cidr" {
  description = "VPC CIDR block"
  type        = string
  default     = "10.0.0.0/16"
}

variable "availability_zones" {
  description = "Availability zones"
  type        = list(string)
  default     = ["ap-south-1a", "ap-south-1b", "ap-south-1c"]
}

# RDS Configuration
variable "db_instance_class" {
  description = "RDS instance class"
  type        = string
  default     = "db.t3.micro"  # Free tier eligible
}

variable "db_name" {
  description = "Database name"
  type        = string
  default     = "insureme_db"
}

variable "db_username" {
  description = "Database master username"
  type        = string
  sensitive   = true
  default     = "ram"
}

variable "db_password" {
  description = "Database master password"
  type        = string
  sensitive   = true
  default     = "ram@1234"  # You MUST set this in terraform.tfvars
}