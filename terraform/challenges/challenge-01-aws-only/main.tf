terraform {
  required_version = ">= 1.5.0"
  
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 5.0"
    }
    random = {
      source  = "hashicorp/random"
      version = "~> 3.0"
    }
  }

  # backend "s3" {
  #   # Configuration loaded from backend-configs/s3.hcl
  # }
}

# Provider configuration
provider "aws" {
  region  = var.aws_region
  profile = var.aws_profile
  
  default_tags {
    tags = {
      Project   = "ctf-25"
      Challenge = "challenge-01-aws-only"
      ManagedBy = "terraform"
    }
  }
}

# AWS S3 Module
module "aws_storage" {
  source = "../../modules/aws/infrastructure"
  
  project_name    = var.project_name
  index_html_path = "${path.module}/../../../web-content/aws-challenge-01/index.html"
  flag_txt_path   = "${path.module}/../../../web-content/aws-challenge-01/flag.txt"
  
  tags = {
    Challenge = "challenge-01-aws-only"
    Cloud     = "aws"
  }
}
