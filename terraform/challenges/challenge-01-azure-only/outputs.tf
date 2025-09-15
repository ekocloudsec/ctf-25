# Original Challenge-01 Outputs
output "azure_storage_website_endpoint" {
  description = "Azure Storage static website endpoint URL"
  value       = module.azure_storage.static_website_url
}

output "azure_storage_account_name" {
  description = "Azure Storage Account name"
  value       = module.azure_storage.storage_account_name
}

output "azure_flag_url" {
  description = "Azure Storage flag URL (Challenge-01)"
  value       = "${module.azure_storage.static_website_url}flag.txt"
}

# Extended Challenge Outputs (MediCloudX Research Portal)
output "research_portal_url" {
  description = "MediCloudX Research Portal URL"
  value       = "https://${module.azure_storage.storage_account_name}.blob.core.windows.net/research-portal/research-portal.html"
}

output "medicloud_sas_token" {
  description = "SAS token for medicloud-research container (intentionally exposed)"
  value       = data.azurerm_storage_account_blob_container_sas.medicloud_sas.sas
  sensitive   = true  # Required by Terraform but intentionally exposed in CTF
}

output "azure_ad_app_id" {
  description = "Azure AD Application Client ID"
  value       = azuread_application.medicloud_app.client_id
}

output "certificate_thumbprint" {
  description = "Certificate thumbprint for Azure AD authentication"
  value       = azuread_application_certificate.medicloud_cert.key_id
}

output "azure_ad_user" {
  description = "Azure AD User Principal Name"
  value       = azuread_user.medicloud_user.user_principal_name
}

output "medicloud_research_container_url" {
  description = "Private container URL (requires SAS token)"
  value       = "https://${module.azure_storage.storage_account_name}.blob.core.windows.net/medicloud-research/"
}

output "challenge_summary" {
  description = "Combined Challenge Summary"
  sensitive   = true
  value = {
    # Challenge-01 (Basic)
    basic_website = module.azure_storage.static_website_url
    basic_flag    = "${module.azure_storage.static_website_url}flag.txt"
    
    # Challenge-02 (Advanced)
    research_portal = "https://${module.azure_storage.storage_account_name}.blob.core.windows.net/research-portal/research-portal.html"
    private_container = "https://${module.azure_storage.storage_account_name}.blob.core.windows.net/medicloud-research/"
    sas_token = data.azurerm_storage_account_blob_container_sas.medicloud_sas.sas
    azure_ad_app = azuread_application.medicloud_app.client_id
    azure_ad_user = azuread_user.medicloud_user.user_principal_name
    
    storage_account = module.azure_storage.storage_account_name
  }
}

# Attack Vectors Summary
output "attack_vectors" {
  description = "Available attack vectors in this combined challenge"
  value = {
    vector_1 = {
      name = "Direct Storage Access (Challenge-01)"
      target = "${module.azure_storage.static_website_url}flag.txt"
      difficulty = "Basic"
      flag = "CLD[b8c4d0f3-5g9e-5b2c-ad4f-8g3b6e9c7f5d]"
    }
    vector_2 = {
      name = "SAS Token Extraction + Certificate Auth (Challenge-02)"
      target = "https://${module.azure_storage.storage_account_name}.blob.core.windows.net/medicloud-research/flag.txt"
      difficulty = "Advanced"
      entry_point = "https://${module.azure_storage.storage_account_name}.blob.core.windows.net/research-portal/research-portal.html"
      flag = "CTF{m3d1cl0udx_4zur3_st0r4g3_s4s_t0k3n_3xf1ltr4t10n}"
    }
  }
}
