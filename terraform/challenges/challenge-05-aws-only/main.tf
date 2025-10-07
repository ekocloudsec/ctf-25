terraform {
  required_version = ">= 1.5.0"
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 5.0"
    }
    random = {
      source  = "hashicorp/random"
      version = "~> 3.6"
    }
  }
}

provider "aws" {
  region  = var.aws_region
  profile = var.aws_profile

  default_tags {
    tags = {
      Project     = "CTF-2025"
      Challenge   = "challenge-05-aws-only"
      Environment = var.environment
      Owner       = "EkoCloudSec"
    }
  }
}

# Random suffix for unique resource naming
resource "random_string" "suffix" {
  length  = 8
  special = false
  upper   = false
}

# Local values for consistent naming
locals {
  resource_suffix = random_string.suffix.result
  base_name      = "ctf-25-medical-exporter"
}
