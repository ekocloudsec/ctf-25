output "user_pool_id" {
  description = "Cognito User Pool ID"
  value       = aws_cognito_user_pool.main.id
}

output "user_pool_client_id" {
  description = "Cognito User Pool Client ID"
  value       = aws_cognito_user_pool_client.main.id
}

output "identity_pool_id" {
  description = "Cognito Identity Pool ID"
  value       = aws_cognito_identity_pool.main.id
}

output "web_application_url" {
  description = "Web application URL"
  value       = "http://${aws_s3_bucket_website_configuration.web_bucket.website_endpoint}"
}

output "web_bucket_website_url" {
  description = "S3 website URL for the web application"
  value       = "http://${aws_s3_bucket_website_configuration.web_bucket.website_endpoint}"
}

output "flag_bucket_name" {
  description = "S3 bucket containing the flag"
  value       = aws_s3_bucket.flag_bucket.id
}

output "aws_region" {
  description = "AWS region"
  value       = var.aws_region
}

output "challenge_instructions" {
  description = "Instructions for the challenge"
  value = <<EOF
Challenge 02 - AWS Cognito Privilege Escalation

1. Navigate to the web application: http://${aws_s3_bucket_website_configuration.web_bucket.website_endpoint}
2. Discover the Cognito User Pool Client ID in the source code
3. Register a new user directly via AWS CLI bypassing frontend validation
4. Login and extract the access token from browser storage
5. Update your custom:role attribute from 'reader' to 'admin'
6. Obtain Identity Pool credentials using your ID token
7. Use the admin credentials to access the flag in S3 bucket: ${aws_s3_bucket.flag_bucket.id}

User Pool ID: ${aws_cognito_user_pool.main.id}
Client ID: ${aws_cognito_user_pool_client.main.id}
Identity Pool ID: ${aws_cognito_identity_pool.main.id}
EOF
}
