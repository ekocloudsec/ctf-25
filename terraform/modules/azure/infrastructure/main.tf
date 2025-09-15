terraform {
  required_providers {
    azurerm = {
      source  = "hashicorp/azurerm"
      version = "~> 3.0"
    }
  }
}

# Random suffix for unique resource naming
resource "random_id" "suffix" {
  byte_length = 4
}

# Resource group
resource "azurerm_resource_group" "main" {
  name     = "${var.project_name}-rg-${random_id.suffix.hex}"
  location = var.location

  tags = merge(var.tags, {
    Project = var.project_name
  })
}

# Storage account
resource "azurerm_storage_account" "website" {
  name                     = "ctf25sa${random_id.suffix.hex}"
  resource_group_name      = azurerm_resource_group.main.name
  location                 = azurerm_resource_group.main.location
  account_tier             = "Standard"
  account_replication_type = "LRS"
  account_kind             = "StorageV2"

  # Enable static website hosting
  static_website {
    index_document     = "index.html"
    error_404_document = "error.html"
  }

  # Allow public access (intentionally misconfigured for CTF)
  allow_nested_items_to_be_public = true
  public_network_access_enabled   = true

  tags = merge(var.tags, {
    Project = var.project_name
  })
}

# Configure the $web container with public access
# Note: This container is automatically created by static_website, but we manage it explicitly
resource "azurerm_storage_container" "web" {
  name                  = "$web"
  storage_account_name  = azurerm_storage_account.website.name
  container_access_type = "container"  # Allow public read access to blobs AND container listing

  depends_on = [azurerm_storage_account.website]
}

# Upload index.html
resource "azurerm_storage_blob" "index" {
  name                   = "index.html"
  storage_account_name   = azurerm_storage_account.website.name
  storage_container_name = "$web"
  type                   = "Block"
  source                 = var.index_html_path
  content_type           = "text/html"
  
  depends_on = [azurerm_storage_container.web]
}

# Upload flag.txt
resource "azurerm_storage_blob" "flag" {
  name                   = "flag.txt"
  storage_account_name   = azurerm_storage_account.website.name
  storage_container_name = "$web"
  type                   = "Block"
  source                 = var.flag_txt_path
  content_type           = "text/plain"
  
  depends_on = [azurerm_storage_container.web]
}
