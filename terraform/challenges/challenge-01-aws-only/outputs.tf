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

output "challenge_summary" {
  description = "Challenge 1 AWS - Summary"
  value = {
    website = "http://${module.aws_storage.website_endpoint}"
    flag    = "http://${module.aws_storage.website_endpoint}/flag.txt"
    bucket  = module.aws_storage.bucket_name
  }
}
