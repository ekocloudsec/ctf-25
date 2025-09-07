output "database_id" {
  description = "ID of the Firestore database"
  value       = google_firestore_database.database.id
}

output "database_name" {
  description = "Name of the Firestore database"
  value       = google_firestore_database.database.name
}

output "collection_path" {
  description = "Path to the Firestore collection"
  value       = "${var.collection_name}"
}

output "database_url" {
  description = "URL to access the Firestore database (for internal reference)"
  value       = "https://console.cloud.google.com/firestore/data?project=${google_firestore_database.database.project}"
}
