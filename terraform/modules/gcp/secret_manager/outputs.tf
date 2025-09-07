output "secret_id" {
  description = "ID of the Secret Manager secret"
  value       = google_secret_manager_secret.challenge_secret.id
}

output "secret_name" {
  description = "Name of the Secret Manager secret"
  value       = google_secret_manager_secret.challenge_secret.secret_id
}

output "secret_version" {
  description = "Version of the Secret Manager secret"
  value       = google_secret_manager_secret_version.secret_version.version
}

output "secret_url" {
  description = "URL to access the secret (for internal reference)"
  value       = "https://console.cloud.google.com/security/secret-manager/secret/${google_secret_manager_secret.challenge_secret.id}/versions"
}
