# Outputs for Challenge-04-Azure-Only

# Resource Group Information
output "resource_group_name" {
  description = "Name of the resource group"
  value       = azurerm_resource_group.medicloudx_identity.name
}

output "location" {
  description = "Azure region where resources are deployed"
  value       = azurerm_resource_group.medicloudx_identity.location
}

# Container Registry Information
output "acr_name" {
  description = "Azure Container Registry name"
  value       = azurerm_container_registry.medicloudx_acr.name
}

output "acr_login_server" {
  description = "Azure Container Registry login server"
  value       = azurerm_container_registry.medicloudx_acr.login_server
}

# App Service Information
output "app_service_url" {
  description = "URL of the MediCloudX Onboarding application"
  value       = "https://${azurerm_linux_web_app.medicloudx_onboarding.name}.azurewebsites.net"
}

output "app_service_name" {
  description = "Name of the App Service"
  value       = azurerm_linux_web_app.medicloudx_onboarding.name
}

output "app_service_managed_identity_principal_id" {
  description = "Principal ID of the App Service managed identity"
  value       = azurerm_linux_web_app.medicloudx_onboarding.identity[0].principal_id
}

# Azure AD Information
output "azure_ad_application_id" {
  description = "Azure AD Application (Client) ID"
  value       = azuread_application.medicloudx_app.client_id
}

output "azure_ad_application_object_id" {
  description = "Azure AD Application Object ID"
  value       = azuread_application.medicloudx_app.object_id
}

output "service_principal_object_id" {
  description = "Service Principal Object ID"
  value       = azuread_service_principal.medicloudx_sp.object_id
}

# Key Vault Information
output "key_vault_name" {
  description = "Name of the Key Vault"
  value       = azurerm_key_vault.medicloudx_vault.name
}

output "key_vault_uri" {
  description = "URI of the Key Vault"
  value       = azurerm_key_vault.medicloudx_vault.vault_uri
}

# Challenge Information
output "challenge_info" {
  description = "Information about the challenge and how to get started"
  value = {
    challenge_name        = "Challenge-04-Azure-Only: MediCloudX Workforce Onboarding"
    application_url       = "https://${azurerm_linux_web_app.medicloudx_onboarding.name}.azurewebsites.net"
    vulnerability         = "Next.js Middleware Authorization Bypass (CVE-2025-29927)"
    demo_credentials     = {
      username = "hradmin"
      password = "MediCloudX2025!"
    }
    objective            = "Bypass authentication to access the user creation API endpoint"
    target_endpoint      = "/api/create-user"
  }
}

# API Endpoints
output "api_endpoints" {
  description = "Important API endpoints for the challenge"
  value = {
    base_url              = "https://${azurerm_linux_web_app.medicloudx_onboarding.name}.azurewebsites.net"
    login_page            = "https://${azurerm_linux_web_app.medicloudx_onboarding.name}.azurewebsites.net/login"
    create_user_api       = "https://${azurerm_linux_web_app.medicloudx_onboarding.name}.azurewebsites.net/api/create-user"
    update_departament_api = "https://${azurerm_linux_web_app.medicloudx_onboarding.name}.azurewebsites.net/api/update-departament"
    vulnerable_header     = "x-middleware-subrequest: src/middleware:src/middleware:src/middleware:src/middleware:src/middleware"
  }
}

# Azure AD Permissions
output "azure_ad_permissions" {
  value = {
    app_permissions = [
      "User.ReadWrite.All",
      "Group.ReadWrite.All", 
      "Directory.ReadWrite.All"
    ]
    managed_identity_permissions = [
      "User.ReadWrite.All"
    ]
  }
}

# Security Configuration
output "security_notes" {
  description = "Security configuration notes"
  value = {
    auth_enabled            = false
    middleware_protection   = "Vulnerable to CVE-2025-29927"
    managed_identity       = "System-assigned identity with Graph API permissions"
    key_vault_integration  = "Enabled with RBAC authorization"
  }
}
