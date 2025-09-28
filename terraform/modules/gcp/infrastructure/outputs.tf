output "bucket_name" {
  description = "Name of the Cloud Storage bucket"
  value       = google_storage_bucket.website.name
}

output "bucket_url" {
  description = "URL of the Cloud Storage bucket"
  value       = google_storage_bucket.website.url
}

output "website_url" {
  description = "Website URL for the bucket"
  value       = "https://storage.googleapis.com/${google_storage_bucket.website.name}/index.html"
}

output "bucket_self_link" {
  description = "Self link of the bucket"
  value       = google_storage_bucket.website.self_link
}

output "discovery_key_url" {
  description = "URL to access the discovery key file"
  value       = var.discovery_key_path != "" ? "https://storage.googleapis.com/${google_storage_bucket.website.name}/medicloudx-discovery-key.json.b64" : ""
}
