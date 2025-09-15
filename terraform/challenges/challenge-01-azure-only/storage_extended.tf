# Extended Storage Resources for MediCloudX Research Portal
# This adds the private container and SAS token functionality to challenge-01

# Private container for sensitive research files
resource "azurerm_storage_container" "medicloud_research" {
  name                  = "medicloud-research"
  storage_account_name  = module.azure_storage.storage_account_name
  container_access_type = "private"
}

# Research portal container (public)
resource "azurerm_storage_container" "research_portal" {
  name                  = "research-portal"
  storage_account_name  = module.azure_storage.storage_account_name
  container_access_type = "blob"
}

# Upload research image to private container
resource "azurerm_storage_blob" "research_image" {
  name                   = "close-up-doctor-holding-red-heart.jpg"
  storage_account_name   = module.azure_storage.storage_account_name
  storage_container_name = azurerm_storage_container.medicloud_research.name
  type                   = "Block"
  source                 = "${path.module}/../../../web-content/azure-challenge-02/close-up-doctor-holding-red-heart.jpg"
}

# Upload base64 encoded certificate to private container
resource "azurerm_storage_blob" "certificate_b64" {
  name                   = "certificadob64delpfx.txt"
  storage_account_name   = module.azure_storage.storage_account_name
  storage_container_name = azurerm_storage_container.medicloud_research.name
  type                   = "Block"
  content_type           = "text/plain"
  source_content         = local_file.medicloud_pfx.content_base64
}

# Upload PowerShell script to private container
resource "azurerm_storage_blob" "powershell_script" {
  name                   = "script.ps1"
  storage_account_name   = module.azure_storage.storage_account_name
  storage_container_name = azurerm_storage_container.medicloud_research.name
  type                   = "Block"
  content_type           = "text/plain"
  source_content         = local_file.processed_script.content
}

# Upload flag to private container
resource "azurerm_storage_blob" "medicloud_flag" {
  name                   = "flag.txt"
  storage_account_name   = module.azure_storage.storage_account_name
  storage_container_name = azurerm_storage_container.medicloud_research.name
  type                   = "Block"
  content_type           = "text/plain"
  source                 = "${path.module}/../../../web-content/azure-challenge-02/flag.txt"
}

# Create PFX certificate using local_file and openssl
resource "local_file" "medicloud_pfx" {
  content_base64 = base64encode(
    # This creates a simple PFX-like structure for demonstration
    # In a real scenario, you'd use openssl or similar tools
    "${tls_self_signed_cert.medicloud_cert.cert_pem}${tls_private_key.medicloud_cert_key.private_key_pem}"
  )
  filename = "${path.module}/../../../web-content/azure-challenge-01/medicloud_cert.pfx"
}

# Generate SAS token for private container access
data "azurerm_storage_account_blob_container_sas" "medicloud_sas" {
  connection_string = module.azure_storage.primary_connection_string
  container_name    = azurerm_storage_container.medicloud_research.name
  https_only        = true
  
  start  = "2024-01-01T00:00:00Z"
  expiry = "2026-12-31T23:59:59Z"
  
  permissions {
    read   = true
    add    = false
    create = false
    write  = false
    delete = false
    list   = true
  }
}
