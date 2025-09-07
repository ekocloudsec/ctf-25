output "gcp_database_name" {
  description = "GCP Firestore database name"
  value       = google_firestore_database.database.name
}

output "gcp_collection_path" {
  description = "GCP Firestore collection path"
  value       = "medicloudx-store-audit-logs"
}

output "gcp_database_url" {
  description = "GCP Firestore database URL"
  value       = "https://console.cloud.google.com/firestore/data?project=${var.gcp_project_id}"
}

output "challenge_hint" {
  description = "Challenge 4 GCP - Firestore Database Hint"
  value       = "Check the audit logs collection for suspicious entries. One of the logs contains a 'secret' field that shouldn't be there."
}

output "challenge_summary" {
  description = "Challenge 4 GCP - Firestore Database Summary"
  value = {
    database   = google_firestore_database.database.name
    collection = "medicloudx-store-audit-logs"
    hint       = "One of the audit logs contains more than standard fields - look for the backup entry"
  }
}
