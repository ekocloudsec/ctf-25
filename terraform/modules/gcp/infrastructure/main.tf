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

  # Enable uniform bucket-level access
  uniform_bucket_level_access = true

  # Website configuration
  website {
    main_page_suffix = "index.html"
    not_found_page   = "error.html"
  }

  # Prevent deletion for safety
  lifecycle {
    prevent_destroy = false
  }

  labels = merge(var.labels, {
    project = var.project_name
  })
}

# Make bucket publicly readable (intentionally misconfigured for CTF)
resource "google_storage_bucket_iam_member" "public_read" {
  bucket = google_storage_bucket.website.name
  role   = "roles/storage.objectViewer"
  member = "allUsers"
}

# Upload index.html
resource "google_storage_bucket_object" "index" {
  name   = "index.html"
  bucket = google_storage_bucket.website.name
  source = var.index_html_path

  content_type = "text/html"

  depends_on = [google_storage_bucket_iam_member.public_read]
}

# Upload flag.txt
resource "google_storage_bucket_object" "flag" {
  name   = "flag.txt"
  bucket = google_storage_bucket.website.name
  source = var.flag_txt_path

  content_type = "text/plain"

  depends_on = [google_storage_bucket_iam_member.public_read]
}
