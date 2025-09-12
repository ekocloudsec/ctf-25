terraform {
  required_version = ">= 1.5.0"
  
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 5.0"
    }
    azurerm = {
      source  = "hashicorp/azurerm"
      version = "~> 3.0"
    }
    google = {
      source  = "hashicorp/google"
      version = "~> 5.0"
    }
    random = {
      source  = "hashicorp/random"
      version = "~> 3.0"
    }
  }

  backend "s3" {
    # Configuration loaded from backend-configs/s3.hcl
  }
}

# Provider configurations
provider "aws" {
  region = var.aws_region
  
  default_tags {
    tags = {
      Project   = "ctf-25"
      Challenge = "challenge-01-public-storage"
      ManagedBy = "terraform"
    }
  }
}

provider "azurerm" {
  features {}
}

provider "google" {
  project = var.gcp_project_id
  region  = var.gcp_region
}

# AWS S3 Module
module "aws_storage" {
  source = "../../modules/aws/infrastructure"
  
  project_name    = var.project_name
  index_html_path = "${path.module}/../../../web-content/aws-challenge-01/index.html"
  flag_txt_path   = "${path.module}/../../../web-content/aws-challenge-01/flag.txt"
  
  tags = {
    Challenge = "challenge-01-public-storage"
    Cloud     = "aws"
  }
}

# Azure Storage Module
module "azure_storage" {
  source = "../../modules/azure/infrastructure"
  
  project_name    = var.project_name
  location        = var.azure_location
  index_html_path = "${path.module}/../../../web-content/azure-challenge-01/index.html"
  flag_txt_path   = "${path.module}/../../../web-content/azure-challenge-01/flag.txt"
  
  tags = {
    Challenge = "challenge-01-public-storage"
    Cloud     = "azure"
  }
}

# GCP Storage Module
module "gcp_storage" {
  source = "../../modules/gcp/infrastructure"
  
  project_name    = var.project_name
  region          = var.gcp_region
  index_html_path = "${path.module}/../../../web-content/gcp-challenge-01/index.html"
  flag_txt_path   = "${path.module}/../../../web-content/gcp-challenge-01/flag.txt"
  
  labels = {
    challenge = "challenge-01-public-storage"
    cloud     = "gcp"
  }
}
