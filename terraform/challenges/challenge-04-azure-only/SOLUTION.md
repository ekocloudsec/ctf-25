# Technical Documentation: MediCloudX Workforce Onboarding System

## System Architecture Overview

The MediCloudX Workforce Onboarding system is deployed on Azure using modern cloud-native technologies:

### Infrastructure Components

1. **Azure Resource Group**: `medicloudx-identity-<suffix>`
2. **Azure Container Registry**: Private registry for application images
3. **App Service Plan**: Linux-based container hosting (B1 SKU)
4. **Azure Web App**: Next.js application with system-assigned managed identity
5. **Azure Active Directory**: App registration with Microsoft Graph API permissions
6. **Azure Key Vault**: Secure storage for application secrets

### Application Stack

- **Framework**: Next.js 13.4.0 (React-based web framework)
- **Runtime**: Node.js 18 Alpine Linux container
- **Authentication**: Cookie-based session management
- **API Integration**: Microsoft Graph API for Azure AD operations

## API Endpoints

### Primary Application Routes

- `GET /` - Main dashboard (requires authentication)
- `GET /login` - Authentication page
- `POST /api/create-user` - User creation endpoint (protected)

### Authentication Flow

1. User accesses the application at the root URL
2. Middleware checks for `auth-token` cookie
3. If no token present, user is redirected to `/login`
4. Valid credentials: `hradmin` / `MediCloudX2025!`
5. Upon successful login, auth cookie is set with 1-hour expiration

## Microsoft Graph API Integration

### Permissions Granted

The application has the following Microsoft Graph API permissions:

**Application Permissions (Admin Consent Required):**
- `User.ReadWrite.All` - Create, read, update users
- `Group.ReadWrite.All` - Manage group memberships  
- `Directory.ReadWrite.All` - Directory-wide operations

**Managed Identity Permissions:**
- `User.ReadWrite.All` - Assigned to App Service managed identity

### User Creation Process

When a user creation request is made to `/api/create-user`, the application:

1. Generates a random 5-character user identifier
2. Creates a secure temporary password (16 characters)
3. Constructs user data object with Azure AD fields
4. Returns user information including temporary credentials

## Security Implementation

### Middleware Configuration

The application uses Next.js middleware (`src/middleware.js`) to:
- Skip authentication for static resources and public pages
- Protect sensitive API endpoints
- Redirect unauthenticated users to login page

### Authentication Validation

Protected routes check for the presence of an `auth-token` cookie before allowing access to restricted functionality.

## Technical Analysis Points

### Framework Version Information

- **Next.js Version**: 13.4.0
- **Release Timeline**: This version was released in early 2025
- **Security Considerations**: Version predates certain security patches

### HTTP Header Processing

The middleware implementation processes incoming HTTP requests and examines various headers and cookies for authentication decisions.

### Request Interception

Next.js middleware operates at the edge, intercepting requests before they reach API routes or pages, allowing for request manipulation and routing decisions.

## Deployment Configuration

### Container Configuration

```dockerfile
FROM node:18-alpine AS base
# Multi-stage build process
# Production optimizations applied
# Runs as non-root user (nextjs:nodejs)
```

### Azure App Service Settings

- **Runtime Stack**: Node.js 18 LTS
- **Container Port**: 3000
- **Authentication**: Disabled at App Service level
- **Managed Identity**: System-assigned, integrated with Key Vault

## Development and Testing

### Local Testing Commands

```bash
# Install dependencies
npm ci --only=production

# Build application
npm run build

# Start production server
npm start
```

### Docker Operations

```bash
# Build container image
docker build -t medicloudx-onboarding .

# Run container locally
docker run -p 3000:3000 medicloudx-onboarding
```

## Monitoring and Logging

- Application logs are captured by Azure App Service
- Authentication events are logged for audit purposes
- Microsoft Graph API calls are tracked through Azure AD logs
- Container health monitoring enabled

## Compliance and Security Notes

- Healthcare data handling compliance (HIPAA considerations)
- Azure AD integration for enterprise identity management
- Key Vault integration for secure credential storage
- Role-based access control implementation
- Audit logging for user creation activities

---

*This documentation provides technical implementation details for the MediCloudX Workforce Onboarding system. For operational procedures, refer to the main README documentation.*
