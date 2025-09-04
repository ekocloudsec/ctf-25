output "azure_storage_website_endpoint" {
  description = "Azure Storage static website endpoint URL"
  value       = module.azure_storage.static_website_url
}

output "azure_storage_account_name" {
  description = "Azure Storage Account name"
  value       = module.azure_storage.storage_account_name
}

output "azure_flag_url" {
  description = "Azure Storage flag URL"
  value       = "${module.azure_storage.static_website_url}flag.txt"
}

output "challenge_summary" {
  description = "Challenge 2 Azure - Summary"
  value = {
    website = module.azure_storage.static_website_url
    flag    = "${module.azure_storage.static_website_url}flag.txt"
    storage_account = module.azure_storage.storage_account_name
  }
}
