# Authentication Setup Guide

This guide explains how to authenticate with each cloud provider to deploy the CTF challenges.

## Prerequisites

Ensure you have the following tools installed:
- Terraform >= 1.5.0
- AWS CLI v2
- Azure CLI
- Google Cloud SDK (gcloud)

## AWS Authentication

### Option 1: AWS CLI Configuration (Recommended)
```bash
# Configure AWS CLI with your credentials
aws configure

# Verify authentication
aws sts get-caller-identity
```

### Option 2: Environment Variables
```bash
export AWS_ACCESS_KEY_ID="your-access-key"
export AWS_SECRET_ACCESS_KEY="your-secret-key"
export AWS_DEFAULT_REGION="us-east-1"
```

### Option 3: IAM Roles (for EC2/ECS)
If running from AWS services, attach an appropriate IAM role with the following permissions:
- `s3:*`
- `iam:GetRole`
- `iam:PassRole`

### Required AWS Permissions
```json
{
    "Version": "2012-10-17",
    "Statement": [
        {
            "Effect": "Allow",
            "Action": [
                "s3:*",
                "iam:GetRole",
                "iam:PassRole"
            ],
            "Resource": "*"
        }
    ]
}
```

## Azure Authentication

### Option 1: Azure CLI Login (Recommended)
```bash
# Login to Azure
az login

# Verify authentication
az account show

# Set subscription (if you have multiple)
az account set --subscription "your-subscription-id"
```

### Option 2: Service Principal
```bash
# Create a service principal
az ad sp create-for-rbac --name "ctf-25-terraform" --role="Contributor"

# Set environment variables
export ARM_CLIENT_ID="your-client-id"
export ARM_CLIENT_SECRET="your-client-secret"
export ARM_SUBSCRIPTION_ID="your-subscription-id"
export ARM_TENANT_ID="your-tenant-id"
```

### Required Azure Permissions
- **Contributor** role on the subscription or resource group
- **Storage Account Contributor** for storage operations

## GCP Authentication

### Option 1: gcloud CLI (Recommended)
```bash
# Login to GCP
gcloud auth login

# Set default project
gcloud config set project YOUR_PROJECT_ID

# Enable required APIs
gcloud services enable storage-api.googleapis.com
gcloud services enable cloudresourcemanager.googleapis.com

# Verify authentication
gcloud auth list
```

### Option 2: Service Account Key
```bash
# Create a service account
gcloud iam service-accounts create ctf-25-terraform \
    --display-name="CTF-25 Terraform Service Account"

# Grant necessary roles
gcloud projects add-iam-policy-binding YOUR_PROJECT_ID \
    --member="serviceAccount:ctf-25-terraform@YOUR_PROJECT_ID.iam.gserviceaccount.com" \
    --role="roles/storage.admin"

# Create and download key
gcloud iam service-accounts keys create ~/ctf-25-key.json \
    --iam-account=ctf-25-terraform@YOUR_PROJECT_ID.iam.gserviceaccount.com

# Set environment variable
export GOOGLE_APPLICATION_CREDENTIALS="~/ctf-25-key.json"
```

### Required GCP Permissions
- **Storage Admin** (`roles/storage.admin`)
- **Project IAM Admin** (`roles/resourcemanager.projectIamAdmin`) - if managing IAM

## Terraform Backend Setup

### AWS S3 Backend (Recommended)
Create the S3 bucket and DynamoDB table for state management:

```bash
# Create S3 bucket for Terraform state
aws s3 mb s3://ctf-25-terraform-state --region us-east-1

# Enable versioning
aws s3api put-bucket-versioning \
    --bucket ctf-25-terraform-state \
    --versioning-configuration Status=Enabled

# Create DynamoDB table for state locking
aws dynamodb create-table \
    --table-name ctf-25-terraform-locks \
    --attribute-definitions AttributeName=LockID,AttributeType=S \
    --key-schema AttributeName=LockID,KeyType=HASH \
    --provisioned-throughput ReadCapacityUnits=5,WriteCapacityUnits=5 \
    --region us-east-1
```

### Alternative: GCP Backend
```bash
# Create GCS bucket for Terraform state
gsutil mb gs://ctf-25-terraform-state
```

### Alternative: Azure Backend
```bash
# Create resource group
az group create --name ctf-25-terraform-state --location "East US"

# Create storage account
az storage account create \
    --resource-group ctf-25-terraform-state \
    --name ctf25terraformstate \
    --sku Standard_LRS \
    --encryption-services blob

# Create container
az storage container create \
    --name tfstate \
    --account-name ctf25terraformstate
```

## Verification

After setting up authentication, verify access to each cloud:

```bash
# AWS
aws sts get-caller-identity

# Azure
az account show

# GCP
gcloud auth list
gcloud config get-value project
```

## Security Best Practices

1. **Use least privilege access** - Grant only the minimum permissions required
2. **Rotate credentials regularly** - Especially for long-lived access keys
3. **Use temporary credentials** when possible (IAM roles, service principals)
4. **Never commit credentials** to version control
5. **Use separate accounts/projects** for different environments
6. **Enable MFA** on all cloud accounts
7. **Monitor access logs** for unusual activity

## Troubleshooting

### Common Issues

**AWS "Access Denied"**
- Check IAM permissions
- Verify region settings
- Ensure credentials are not expired

**Azure "Insufficient privileges"**
- Check role assignments
- Verify subscription access
- Ensure resource providers are registered

**GCP "Permission denied"**
- Check service account permissions
- Verify project ID is correct
- Ensure APIs are enabled

### Getting Help

If you encounter authentication issues:
1. Check the cloud provider's official documentation
2. Verify your account has the necessary permissions
3. Test authentication with simple CLI commands first
4. Check Terraform logs for detailed error messages
