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

# Create Firestore database
resource "google_firestore_database" "database" {
  name        = "${var.database_name}-${random_id.suffix.hex}"
  location_id = var.region
  type        = "FIRESTORE_NATIVE"

  # Set delete protection to false for easy cleanup
  delete_protection_state = "DELETE_PROTECTION_DISABLED"
}

# Create Firestore collection for audit logs
resource "google_firestore_document" "audit_logs" {
  for_each = var.log_entries

  project    = google_firestore_database.database.project
  collection = var.collection_name
  document_id = each.key
  database    = google_firestore_database.database.name

  fields = jsonencode(each.value)
  
  # Esperar explícitamente a que la base de datos esté disponible
  depends_on = [google_firestore_database.database]
  
  # Añadir un tiempo de espera para que Terraform no abandone demasiado rápido
  timeouts {
    create = "2m"
    update = "2m"
    delete = "2m"
  }
}
