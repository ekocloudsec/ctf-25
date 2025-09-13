# Deployment Guide - Challenge 1: Public Storage

This guide walks you through deploying the first CTF challenge across all three cloud providers.

## Quick Start

### 1. Setup Authentication
Follow the [Authentication Guide](authentication.md) to configure access to all three cloud providers.

### 2. Configure Variables
```bash
# Navigate to your chosen challenge (example with AWS)
cd terraform/challenges/challenge-01-aws-only
cp terraform.tfvars.example terraform.tfvars
```

Edit `terraform.tfvars` with your GCP project ID:
```hcl
gcp_project_id = "your-actual-gcp-project-id"
```

### 3. Initialize and Deploy
```bash
# Initialize Terraform with S3 backend
terraform init -backend-config=../../backend-configs/s3.hcl

# Review the deployment plan
terraform plan

# Deploy the infrastructure
terraform apply
```

### 4. Access Challenge URLs
After deployment, Terraform will output the URLs for each cloud provider:
- **AWS S3**: `http://bucket-name.s3-website-us-east-1.amazonaws.com`
- **Azure Storage**: `https://storageaccount.z13.web.core.windows.net/`
- **GCP Storage**: `https://storage.googleapis.com/bucket-name/index.html`

## Challenge Solution

Each storage service contains:
- `index.html` - Challenge webpage with instructions
- `flag.txt` - Hidden flag file with format `CLD[UUID]`

### Flags Location
- **AWS**: `http://bucket-name.s3-website-us-east-1.amazonaws.com/flag.txt`
- **Azure**: `https://storageaccount.z13.web.core.windows.net/flag.txt`
- **GCP**: `https://storage.googleapis.com/bucket-name/flag.txt`

## Security Misconfigurations Demonstrated

### AWS S3
- Public read access via bucket policy
- Static website hosting enabled
- No access restrictions

### Azure Storage
- Public blob access enabled
- Anonymous read permissions
- Static website hosting configured

### GCP Cloud Storage
- `allUsers` granted `storage.objectViewer` role
- Public object access
- Direct URL access to objects

## Cleanup

To destroy the infrastructure:
```bash
terraform destroy
```

## Troubleshooting

### Common Issues
1. **GCP Project ID not set** - Ensure `gcp_project_id` is configured in `terraform.tfvars`
2. **Authentication errors** - Verify cloud provider authentication following the auth guide
3. **Backend initialization fails** - Ensure S3 bucket exists and credentials are valid
4. **Resource naming conflicts** - Random suffixes are used to prevent conflicts

### Logs and Debugging
```bash
# Enable detailed Terraform logging
export TF_LOG=DEBUG
terraform apply
```
