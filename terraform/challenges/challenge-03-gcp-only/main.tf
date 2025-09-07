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

# First let's create the content directory if it doesn't exist
resource "local_file" "flag_file" {
  content  = "CLD[${random_uuid.flag.result}]"
  filename = "${path.module}/../../../web-content/gcp-challenge-03/flag.txt"

  provisioner "local-exec" {
    command = "New-Item -Path '${path.module}/../../../web-content/gcp-challenge-03' -ItemType Directory -Force"
    interpreter = ["PowerShell", "-Command"]
  }
}

# Generate random UUID for the flag
resource "random_uuid" "flag" {}

# GCP Private Bucket Module
module "gcp_private_bucket" {
  source = "../../modules/gcp/private_bucket"
  
  project_name  = var.project_name
  region        = var.gcp_region
  bucket_name   = "medicloudx-store-bucket"
  flag_txt_path = local_file.flag_file.filename
  
  labels = {
    challenge = "challenge-03-gcp-only"
    cloud     = "gcp"
  }
}
