terraform {
  required_providers {
    google = {
      source  = "hashicorp/google"
      version = "~> 5.0"
    }
  }
}

# Random suffix for unique resource naming
resource "random_id" "suffix" {
  byte_length = 4
}

# Cloud Storage bucket (private)
resource "google_storage_bucket" "private_bucket" {
  name     = "${var.bucket_name}-${random_id.suffix.hex}"
  location = var.region

  # Enable uniform bucket-level access
  uniform_bucket_level_access = true

  # No public access is configured intentionally

  # Prevent deletion for safety
  lifecycle {
    prevent_destroy = false
  }

  labels = merge(var.labels, {
    project = var.project_name
  })
}

# Upload flag.txt to the bucket
resource "google_storage_bucket_object" "flag" {
  name   = "flag.txt"
  bucket = google_storage_bucket.private_bucket.name
  source = var.flag_txt_path

  content_type = "text/plain"
}
