terraform {
  required_version = ">= 1.5.0"
  
  required_providers {
    azurerm = {
      source  = "hashicorp/azurerm"
      version = "~> 3.0"
    }
    random = {
      source  = "hashicorp/random"
      version = "~> 3.0"
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

# Azure Storage Module
module "azure_storage" {
  source = "../../modules/azure/infrastructure"
  
  project_name      = var.project_name
  location          = var.azure_location
  index_html_path   = "${path.module}/../../../web-content/azure/index.html"
  flag_txt_path     = "${path.module}/../../../web-content/azure/flag.txt"
  
  tags = {
    Challenge = "challenge-01-azure-only"
    Cloud     = "azure"
    Project   = "ctf-25"
    ManagedBy = "terraform"
  }
}
