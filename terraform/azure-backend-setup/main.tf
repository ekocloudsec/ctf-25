terraform {
  required_version = ">= 1.5.0"
  
  required_providers {
    azurerm = {
      source  = "hashicorp/azurerm"
      version = "~> 3.0"
    }
  }
}

provider "azurerm" {
  features {}
  subscription_id = var.azure_subscription_id
  tenant_id       = var.azure_tenant_id
}

# Resource Group for Terraform State
resource "azurerm_resource_group" "terraform_state" {
  name     = "ctf-25-terraform-state"
  location = var.azure_location

  tags = {
    Purpose   = "terraform-backend"
    Project   = "ctf-25"
    ManagedBy = "terraform"
  }
}

# Storage Account for Terraform State
resource "azurerm_storage_account" "terraform_state" {
  name                     = "ctf25terraformstate"
  resource_group_name      = azurerm_resource_group.terraform_state.name
  location                 = azurerm_resource_group.terraform_state.location
  account_tier             = "Standard"
  account_replication_type = "LRS"
  
  # Security settings
  min_tls_version                = "TLS1_2"
  allow_nested_items_to_be_public = false

  tags = {
    Purpose   = "terraform-backend"
    Project   = "ctf-25"
    ManagedBy = "terraform"
  }
}

# Container for Terraform State
resource "azurerm_storage_container" "terraform_state" {
  name                  = "tfstate"
  storage_account_name  = azurerm_storage_account.terraform_state.name
  container_access_type = "private"
}
