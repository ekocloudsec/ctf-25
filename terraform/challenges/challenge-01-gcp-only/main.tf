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

# GCP Cloud Storage Module
module "gcp_storage" {
  source = "../../modules/gcp/infrastructure"
  
  project_name    = var.project_name
  region          = var.gcp_region
  index_html_path = "${path.module}/../../../web-content/gcp-challenge-01/index.html"
  flag_txt_path   = "${path.module}/../../../web-content/gcp-challenge-01/flag.txt"
  
  labels = {
    challenge = "challenge-01-gcp-only"
    cloud     = "gcp"
  }
}
