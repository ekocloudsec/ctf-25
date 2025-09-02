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
