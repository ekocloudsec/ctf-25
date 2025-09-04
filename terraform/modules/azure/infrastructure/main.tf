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

# The $web container is automatically created when static website is enabled
# No need to explicitly create it

# Upload index.html
resource "azurerm_storage_blob" "index" {
  name                   = "index.html"
  storage_account_name   = azurerm_storage_account.website.name
  storage_container_name = "$web"
  type                   = "Block"
  source                 = var.index_html_path
  content_type           = "text/html"
}

# Upload flag.txt
resource "azurerm_storage_blob" "flag" {
  name                   = "flag.txt"
  storage_account_name   = azurerm_storage_account.website.name
  storage_container_name = "$web"
  type                   = "Block"
  source                 = var.flag_txt_path
  content_type           = "text/plain"
}
