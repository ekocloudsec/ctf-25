output "gcp_secret_name" {
  description = "GCP Secret Manager secret name"
  value       = module.gcp_secret.secret_name
}

output "gcp_secret_id" {
  description = "GCP Secret Manager secret ID"
  value       = module.gcp_secret.secret_id
}

output "gcp_secret_version" {
  description = "GCP Secret Manager secret version"
  value       = module.gcp_secret.secret_version
}

output "flag_identifier" {
  description = "Flag identifier (but not the actual value for security)"
  value       = "medicloudx-store-secret contains a flag with UUID format"
}

output "challenge_summary" {
  description = "Challenge 2 GCP - Secret Manager Summary"
  value = {
    secret_name    = module.gcp_secret.secret_name
    secret_version = module.gcp_secret.secret_version
    secret_url     = module.gcp_secret.secret_url
  }
}
