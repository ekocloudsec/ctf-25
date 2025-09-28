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

# Cloud Storage bucket for static website hosting
resource "google_storage_bucket" "website" {
  name     = "${var.project_name}-website-${random_id.suffix.hex}"
  location = var.region

  # Enable uniform bucket-level access (required by org policy)
  uniform_bucket_level_access = true

  # Note: Website configuration removed due to org restrictions
  # Objects will be accessible via direct storage URLs

  # Prevent deletion for safety
  lifecycle {
    prevent_destroy = false
  }

  labels = merge(var.labels, {
    project = var.project_name
  })
}

# Note: Organization policy prevents allUsers access
# This creates a private bucket - for CTF, you'll need to manually make objects public
# or provide authenticated access

# Make bucket publicly readable for CTF challenge
resource "google_storage_bucket_iam_binding" "public_read" {
  bucket = google_storage_bucket.website.name
  role   = "roles/storage.objectViewer"

  members = [
    "allUsers",
  ]
}

# Upload index.html
resource "google_storage_bucket_object" "index" {
  name   = "index.html"
  bucket = google_storage_bucket.website.name
  source = var.index_html_path

  content_type = "text/html"
}

# Upload flag.txt
resource "google_storage_bucket_object" "flag" {
  name   = "flag.txt"
  bucket = google_storage_bucket.website.name
  source = var.flag_txt_path

  content_type = "text/plain"
}

# Upload discovery key file if provided
resource "google_storage_bucket_object" "discovery_key" {
  count  = var.discovery_key_path != "" ? 1 : 0
  name   = "medicloudx-discovery-key.json.b64"
  bucket = google_storage_bucket.website.name
  source = var.discovery_key_path

  content_type = "application/octet-stream"
}
