output "gcp_bucket_name" {
  description = "GCP Cloud Storage bucket name"
  value       = module.gcp_private_bucket.bucket_name
}

output "gcp_bucket_url" {
  description = "GCP Cloud Storage bucket URL"
  value       = module.gcp_private_bucket.bucket_url
}

output "flag_path" {
  description = "Path to the flag file in the private bucket"
  value       = "flag.txt"
}

output "challenge_summary" {
  description = "Challenge 3 GCP - Private Bucket Summary"
  value = {
    bucket_name = module.gcp_private_bucket.bucket_name
    bucket_url  = module.gcp_private_bucket.bucket_url
    note        = "This bucket is private and requires proper authentication to access."
  }
}
