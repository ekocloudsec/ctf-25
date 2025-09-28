output "gcp_website_url" {
  description = "GCP Cloud Storage website URL"
  value       = module.gcp_storage.website_url
}

output "gcp_bucket_name" {
  description = "GCP Cloud Storage bucket name"
  value       = module.gcp_storage.bucket_name
}

output "gcp_flag_url" {
  description = "GCP Cloud Storage flag URL"
  value       = "https://storage.googleapis.com/${module.gcp_storage.bucket_name}/flag.txt"
}

output "gcp_discovery_key_url" {
  description = "GCP Cloud Storage discovery key URL"
  value       = "https://storage.googleapis.com/${module.gcp_storage.bucket_name}/medicloudx-discovery-key.json.b64"
}

output "challenge_summary" {
  description = "Challenge 1 GCP - Summary"
  value = {
    website      = module.gcp_storage.website_url
    flag         = "https://storage.googleapis.com/${module.gcp_storage.bucket_name}/flag.txt"
    bucket       = module.gcp_storage.bucket_name
    discovery_key = "https://storage.googleapis.com/${module.gcp_storage.bucket_name}/medicloudx-discovery-key.json.b64"
  }
}
