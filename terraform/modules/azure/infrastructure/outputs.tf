output "resource_group_name" {
  description = "Name of the resource group"
  value       = azurerm_resource_group.main.name
}

output "storage_account_name" {
  description = "Name of the storage account"
  value       = azurerm_storage_account.website.name
}

output "storage_account_primary_endpoint" {
  description = "Primary endpoint of the storage account"
  value       = azurerm_storage_account.website.primary_blob_endpoint
}

output "static_website_url" {
  description = "Static website URL"
  value       = azurerm_storage_account.website.primary_web_endpoint
}

output "storage_container_name" {
  description = "Name of the storage container"
  value       = "$web"
}
