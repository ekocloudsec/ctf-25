# Multi-Cloud CTF Project

A comprehensive Capture The Flag (CTF) project spanning AWS, Azure, and GCP with 15 challenges (5 per cloud provider).

## Project Structure

```
ctf-25/
├── terraform/
│   ├── modules/                    # Reusable Terraform modules
│   │   ├── aws/
│   │   ├── azure/
│   │   └── gcp/
│   ├── environments/               # Environment-specific configurations
│   │   ├── dev/
│   │   ├── staging/
│   │   └── prod/
│   ├── backend-configs/            # Remote state configurations
│   └── challenges/                 # Challenge-specific infrastructure
│       ├── challenge-01-public-storage/
│       ├── challenge-02-*/
│       └── ...
├── web-content/                    # Static web content for challenges
├── scripts/                       # Deployment and utility scripts
└── docs/                          # Documentation
```

## Challenges Overview

### AWS Challenges (5)
1. **Public S3 Storage** - Misconfigured public S3 bucket
2. TBD
3. TBD
4. TBD
5. TBD

### Azure Challenges (5)
1. **Public Storage Account** - Misconfigured public blob storage
2. TBD
3. TBD
4. TBD
5. TBD

### GCP Challenges (5)
1. **Public Cloud Storage** - Misconfigured public bucket
2. TBD
3. TBD
4. TBD
5. TBD

## Getting Started

### Prerequisites
- Terraform >= 1.5.0
- AWS CLI configured
- Azure CLI configured
- Google Cloud SDK configured

### Authentication Setup
See [Authentication Guide](docs/authentication.md) for detailed setup instructions.

### Deployment
```bash
# Navigate to specific challenge
cd terraform/challenges/challenge-01-public-storage

# Initialize Terraform
terraform init -backend-config=../../backend-configs/s3.hcl

# Plan deployment
terraform plan

# Apply changes
terraform apply
```