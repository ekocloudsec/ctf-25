# Challenge 2: Azure Storage Advanced Misconfiguration

## Overview
This challenge demonstrates an advanced Azure Storage Account misconfiguration scenario designed for intermediate-level participants. It focuses on Azure-specific security vulnerabilities in blob storage configurations.

## Challenge Details
- **Difficulty**: Intermediate
- **Cloud Provider**: Microsoft Azure (Azure-only)
- **Challenge Type**: Storage Misconfiguration
- **Flag Format**: `CLD[uuid]`

## Prerequisites
- Azure account with active subscription
- Azure CLI installed and configured
- Terraform >= 1.5.0
- Basic understanding of Azure Storage services

## Setup Instructions

### 1. Azure Account Configuration
Since you're using a new Azure account, you'll need to:

```bash
# Login to Azure
az login

# List your subscriptions
az account list --output table

# Set the subscription you want to use
az account set --subscription "your-subscription-id"

# Get your tenant ID
az account show --query tenantId --output tsv
```

### 2. Configure Terraform Variables
Copy the example variables file and configure it:

```bash
cd terraform/challenges/challenge-02-azure-only
cp terraform.tfvars.example terraform.tfvars
```

Edit `terraform.tfvars` with your Azure details:
```hcl
# Azure Configuration
azure_subscription_id = "your-azure-subscription-id"
azure_tenant_id       = "your-azure-tenant-id"
azure_location        = "East US"

# Project Configuration
project_name = "ctf-25"
```

### 3. Initialize and Deploy
```bash
# Initialize Terraform
terraform init -backend-config="../../backend-configs/azurerm.hcl"

# Plan the deployment
terraform plan

# Apply the configuration
terraform apply
```

## Challenge Objectives
1. **Primary Goal**: Find the hidden flag in the misconfigured Azure Storage Account
2. **Learning Objectives**:
   - Understand Azure Storage public access levels
   - Learn about blob container security policies
   - Practice Azure Storage enumeration techniques
   - Identify common Azure Storage misconfigurations

## What You'll Learn
- Azure Storage Account security models
- Public blob access configurations
- Container-level permissions
- Azure Storage URL patterns
- Static website hosting vulnerabilities

## Hints
- Azure Storage blobs can be accessed directly via URL
- Container-level permissions affect blob accessibility
- Look for files that might be stored alongside the main webpage
- Understanding Azure Storage naming conventions is key

## Expected Outputs
After successful deployment, you should see:
- Azure Storage Account website endpoint
- Direct flag URL
- Storage account name
- Challenge summary with all relevant URLs

## Cleanup
To avoid Azure charges, destroy the resources when done:
```bash
terraform destroy
```

## Troubleshooting
- Ensure your Azure account has sufficient permissions to create Storage Accounts
- Verify your subscription is active and not in a spending limit
- Check that the selected Azure region supports the required services
- Make sure Terraform has proper Azure credentials configured

## Security Note
This challenge intentionally creates insecure configurations for educational purposes. Never deploy similar configurations in production environments.
