output "aws_s3_website_endpoint" {
  description = "AWS S3 website endpoint URL"
  value       = "http://${module.aws_storage.website_endpoint}"
}

output "aws_s3_bucket_name" {
  description = "AWS S3 bucket name"
  value       = module.aws_storage.bucket_name
}

output "aws_flag_url" {
  description = "AWS S3 flag URL"
  value       = "http://${module.aws_storage.website_endpoint}/flag.txt"
}

output "azure_static_website_url" {
  description = "Azure Storage static website URL"
  value       = module.azure_storage.static_website_url
}

output "azure_storage_account_name" {
  description = "Azure Storage account name"
  value       = module.azure_storage.storage_account_name
}

output "azure_flag_url" {
  description = "Azure Storage flag URL"
  value       = "${module.azure_storage.static_website_url}flag.txt"
}

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

# Summary output for easy access
output "challenge_summary" {
  description = "Challenge 1 - All endpoints summary"
  value = {
    aws = {
      website = "http://${module.aws_storage.website_endpoint}"
      flag    = "http://${module.aws_storage.website_endpoint}/flag.txt"
      bucket  = module.aws_storage.bucket_name
    }
    azure = {
      website = module.azure_storage.static_website_url
      flag    = "${module.azure_storage.static_website_url}flag.txt"
      storage = module.azure_storage.storage_account_name
    }
    gcp = {
      website = module.gcp_storage.website_url
      flag    = "https://storage.googleapis.com/${module.gcp_storage.bucket_name}/flag.txt"
      bucket  = module.gcp_storage.bucket_name
    }
  }
}
