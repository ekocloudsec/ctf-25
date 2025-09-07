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

# Secret Manager secret
resource "google_secret_manager_secret" "challenge_secret" {
  secret_id = "${var.secret_name}-${random_id.suffix.hex}"
  
  replication {
    auto {}
  }

  labels = merge(var.labels, {
    project = var.project_name
  })
}

# Store the flag in the secret
resource "google_secret_manager_secret_version" "secret_version" {
  secret      = google_secret_manager_secret.challenge_secret.id
  secret_data = var.secret_data
}

# IAM binding to make the secret accessible to specific users (for CTF challenge)
resource "google_secret_manager_secret_iam_binding" "binding" {
  project   = google_secret_manager_secret.challenge_secret.project
  secret_id = google_secret_manager_secret.challenge_secret.secret_id
  role      = "roles/secretmanager.secretAccessor"
  members = var.secret_access_members
}
