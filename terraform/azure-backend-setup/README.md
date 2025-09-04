# Azure Backend Setup for CTF-25

## Purpose
Creates the Azure infrastructure needed for Terraform remote state management.

## What This Creates
- Resource Group: `ctf-25-terraform-state`
- Storage Account: `ctf25terraformstate`
- Storage Container: `tfstate`

## Setup Instructions

### 1. Get Azure Credentials
```bash
az login
az account show --query "{subscriptionId:id, tenantId:tenantId}" --output table
```

### 2. Configure Variables
```bash
cd terraform/azure-backend-setup
cp terraform.tfvars.example terraform.tfvars
# Edit terraform.tfvars with your Azure credentials
```

### 3. Deploy Backend
```bash
terraform init
terraform apply
```

### 4. Use in Challenges
After this is deployed, you can use the azurerm backend in your challenges:
```bash
cd ../challenges/challenge-01-azure-only
terraform init -backend-config="../../backend-configs/azurerm.hcl"
```

## Cleanup
```bash
terraform destroy
```
