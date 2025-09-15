terraform {
  required_version = ">= 1.5.0"
  
  required_providers {
    azurerm = {
      source  = "hashicorp/azurerm"
      version = "~> 3.0"
    }
    azuread = {
      source  = "hashicorp/azuread"
      version = "~> 2.0"
    }
    random = {
      source  = "hashicorp/random"
      version = "~> 3.0"
    }
    tls = {
      source  = "hashicorp/tls"
      version = "~> 4.0"
    }
    local = {
      source  = "hashicorp/local"
      version = "~> 2.0"
    }
  }

  backend "azurerm" {
    # Configuration loaded from backend-configs/azurerm.hcl
  }
}

# Provider configuration
provider "azurerm" {
  features {}
  subscription_id = var.azure_subscription_id
  tenant_id       = var.azure_tenant_id
}

provider "azuread" {
  tenant_id = var.azure_tenant_id
}

# Random suffix for unique resource names
resource "random_string" "suffix" {
  length  = 8
  special = false
  upper   = false
}

# Azure Storage Module (Original Challenge-01)
module "azure_storage" {
  source = "../../modules/azure/infrastructure"
  
  project_name      = var.project_name
  location          = var.azure_location
  index_html_path   = "${path.module}/../../../web-content/azure-challenge-01/index.html"
  flag_txt_path     = "${path.module}/../../../web-content/azure-challenge-01/flag.txt"
  
  tags = {
    Challenge = "challenge-01-azure-only"
    Cloud     = "azure"
    Project   = "ctf-25"
    ManagedBy = "terraform"
  }
}
