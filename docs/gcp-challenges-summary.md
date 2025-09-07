# GCP Challenges Summary

This document provides an overview of all Google Cloud Platform (GCP) challenges implemented in the CTF-25 project.

## Challenge Overview

| Challenge ID | Name | Difficulty | Type | Description |
|-------------|------|------------|------|-------------|
| 01-gcp-only | Public Storage | Easy | Misconfiguration | Find a flag in a publicly accessible Cloud Storage bucket |
| 02-gcp-only | Secret Manager | Medium | Misconfiguration | Discover a flag stored in a publicly accessible Secret Manager secret |
| 03-gcp-only | Private Bucket | Medium | Access Control | Find a way to access a private Cloud Storage bucket |
| 04-gcp-only | Firestore Logs | Medium | Data Analysis | Analyze audit logs stored in Firestore to find a hidden flag |

## Detailed Challenge Descriptions

### Challenge 01: Public Storage (GCP)

**Objective**: Find and access a flag stored in a publicly accessible Cloud Storage bucket.

**Resources**:
- Public Cloud Storage bucket
- Static website hosting with public objects
- Flag stored in flag.txt

**Technical Details**:
- Bucket has IAM binding with `roles/storage.objectViewer` granted to `allUsers`
- Flag Format: `CLD[UUID]`

### Challenge 02: Secret Manager (GCP)

**Objective**: Find a flag stored in Google Cloud Secret Manager.

**Resources**:
- Secret Manager secret named `medicloudx-store-secret`
- IAM misconfiguration allowing public access
- Secret contains a flag in the standard format

**Technical Details**:
- Secret has IAM binding with `roles/secretmanager.secretAccessor` granted to `allUsers`
- Flag Format: `CLD[UUID]`

### Challenge 03: Private Bucket (GCP)

**Objective**: Access a flag stored in a private Cloud Storage bucket.

**Resources**:
- Private Cloud Storage bucket named `medicloudx-store-bucket`
- No public access is configured intentionally
- Flag stored in flag.txt

**Technical Details**:
- Bucket has uniform bucket-level access enabled
- No explicit IAM permissions for public access
- Participants need to find a vulnerability or misconfiguration elsewhere to access the bucket
- Flag Format: `CLD[UUID]`

### Challenge 04: Firestore Logs (GCP)

**Objective**: Analyze application audit logs stored in Firestore to find a hidden flag.

**Resources**:
- Firestore database named `medicloudx-store`
- Collection named `medicloudx-store-audit-logs`
- Multiple log entries simulating application activity
- One log entry contains a hidden flag

**Technical Details**:
- The log entry with the hidden flag has a `secret` field not present in other logs
- The suspicious log entry is related to a backup operation
- Flag Format: `CLD[UUID]`

## Deployment Instructions

Each challenge has its own README.md file with specific deployment instructions. Generally:

1. Set up backend state storage using the backend setup module
2. Create a `terraform.tfvars` file with your GCP project ID and other required variables
3. Initialize Terraform with the appropriate backend config
4. Apply the Terraform configuration
5. Reference the outputs to get information about deployed resources

## Testing

After deployment, you can test each challenge to verify it works as expected:

1. Challenge 01: Access the public bucket URL
2. Challenge 02: Access the Secret Manager secret
3. Challenge 03: Verify the bucket is private but contains the flag
4. Challenge 04: Check the Firestore database contains all audit log entries

## Security Notes

These challenges intentionally create security vulnerabilities for educational purposes. Do not deploy these in a production environment or with sensitive information.
