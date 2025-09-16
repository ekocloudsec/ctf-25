# Variables for Challenge-03-Azure-Only

variable "azure_location" {
  description = "Azure region for resources"
  type        = string
  default     = "East US"
}

variable "azure_subscription_id" {
  description = "Azure subscription ID"
  type        = string
}

variable "azure_tenant_id" {
  description = "Azure tenant ID"
  type        = string
}

variable "challenge_01_app_name_prefix" {
  description = "Application name prefix from Challenge-01 to locate the Service Principal"
  type        = string
  default     = "MediCloudXApp"
}

variable "tags" {
  description = "Tags to apply to all resources"
  type        = map(string)
  default = {
    Environment = "CTF-25"
    Challenge   = "Challenge-03-Azure-Only"
    Purpose     = "Key Vault Privilege Escalation"
    Owner       = "EkoCloudSec"
  }
}
