# Challenge 02 - AWS Cognito Privilege Escalation

## Overview

This challenge demonstrates a common vulnerability in AWS Cognito implementations where custom user attributes can be manipulated to escalate privileges. Players will exploit weak role mapping configurations in Cognito Identity Pools to gain unauthorized access to sensitive resources.

## Vulnerability Description

The challenge contains two main vulnerabilities:

1. **Client-side validation bypass**: Email domain validation is performed only on the frontend, allowing direct registration via AWS CLI
2. **Privilege escalation via custom attributes**: Users can modify their `custom:role` attribute to escalate from `reader` to `admin` role, gaining access to privileged AWS resources

## Architecture

```
┌─────────────────┐    ┌──────────────────┐    ┌─────────────────┐
│   Web App       │    │   Cognito        │    │   Identity      │
│   (S3/API GW)   │◄──►│   User Pool      │◄──►│   Pool          │
└─────────────────┘    └──────────────────┘    └─────────────────┘
                                │                        │
                                ▼                        ▼
                       ┌──────────────────┐    ┌─────────────────┐
                       │   Lambda         │    │   IAM Roles     │
                       │   (Post-Confirm) │    │   Reader/Admin  │
                       └──────────────────┘    └─────────────────┘
                                                        │
                                                        ▼
                                               ┌─────────────────┐
                                               │   S3 Bucket     │
                                               │   (Flag)        │
                                               └─────────────────┘
```

## Challenge Information

Participants will receive the web application URL and basic scenario description after deployment. The detailed attack flow and solution steps are available in the `SOLUTION.md` file.

## Key Learning Points

1. **Client-side validation is insufficient**: Always implement server-side validation for security controls
2. **Custom attributes security**: Carefully consider which attributes users can modify and implement proper authorization checks
3. **Identity Pool role mapping**: Use fine-grained role mapping rules and avoid overly permissive configurations
4. **Token exposure**: Sensitive tokens stored in browser storage can be extracted and misused

## Security Recommendations

1. **Server-side validation**: Implement email domain validation on the backend
2. **Attribute protection**: Mark sensitive custom attributes as admin-only or implement proper authorization
3. **Role mapping**: Use more specific role mapping rules based on verified claims
4. **Least privilege**: Apply principle of least privilege to IAM roles
5. **Token security**: Consider using secure, httpOnly cookies instead of localStorage for token storage

## Deployment

1. Copy `terraform.tfvars.example` to `terraform.tfvars` and update values
2. Initialize and apply Terraform:
   ```bash
   terraform init
   terraform apply
   ```
3. Update the web application with the generated Cognito configuration
4. Upload web content to the S3 bucket

## Flag Format

The flag follows the standard CTF format.

## Resources

- [AWS Cognito Security Best Practices](https://docs.aws.amazon.com/cognito/latest/developerguide/security.html)
- [Identity Pool Role Mapping](https://docs.aws.amazon.com/cognito/latest/developerguide/role-based-access-control.html)
- [CloudGoat Vulnerable Cognito](https://github.com/RhinoSecurityLabs/cloudgoat)
