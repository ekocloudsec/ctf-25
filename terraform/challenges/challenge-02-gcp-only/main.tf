terraform {
  required_version = ">= 1.5.0"
  
  required_providers {
    google = {
      source  = "hashicorp/google"
      version = "~> 5.0"
    }
    random = {
      source  = "hashicorp/random"
      version = "~> 3.0"
    }
  }

  backend "gcs" {
    # Configuration will be provided via backend config file
  }
}

# Provider configuration
provider "google" {
  project = var.gcp_project_id
  region  = var.gcp_region
}

# Generate random UUID for the flag
resource "random_uuid" "flag" {}

locals {
  flag_value = "CLD[${random_uuid.flag.result}]"
}

# GCP Secret Manager Module
module "gcp_secret" {
  source = "../../modules/gcp/secret_manager"
  
  project_name = var.project_name
  secret_name  = "medicloudx-store-secret"
  secret_data  = local.flag_value
  
  # Using default auto replication
  
  # Specify your GCP account email address
  secret_access_members = ["user:${var.gcp_user_email}"]
  
  labels = {
    challenge = "challenge-02-gcp-only"
    cloud     = "gcp"
  }
}
