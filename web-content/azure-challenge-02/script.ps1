# MediCloudX Labs - MediCloud Research Project Data Exfiltration Script
# This script demonstrates credential extraction from Azure AD App Registration

$ApplicationID = "${app_id}"
$TenantID = "${tenant_id}"

# MediCloud researcher credentials (intentionally exposed)
$PlainPassword = "M3d1Cl0ud25!"
$SecurePassword = ConvertTo-SecureString $PlainPassword -AsPlainText -Force
$Cred = New-Object System.Management.Automation.PSCredential("medicloud-researcher",$SecurePassword)

Write-Output "=== MediCloudX Labs - MediCloud Research Project Access ==="
Write-Output "ApplicationID: $ApplicationID"
Write-Output "TenantID: $TenantID"
Write-Output "User Credentials:"
$Cred

Write-Output ""
Write-Output "=== Certificate Authentication Example ==="
Write-Output "# Use the following PowerShell commands to authenticate with certificate:"
Write-Output '$ApplicationId = "' + $ApplicationID + '"'
Write-Output '$TenantId = "' + $TenantID + '"'
Write-Output '$certPath = "C:\MediCloudXAppAuthCert.pfx"'
Write-Output '$password = ConvertTo-SecureString -String "M3d1Cl0ud25!" -Force -AsPlainText'
Write-Output '$clientCertificate = New-Object System.Security.Cryptography.X509Certificates.X509Certificate2 -ArgumentList $certPath, $password'
Write-Output 'Connect-MgGraph -ClientId $ApplicationId -TenantId $TenantId -Certificate $clientCertificate'

Write-Output ""
Write-Output "=== Storage Access Information ==="
Write-Output "Storage Account: Use SAS token from web page source"
Write-Output "Container: medicloud-research"
Write-Output "Files available:"
Write-Output "- flag.txt (Main objective)"
Write-Output "- certificadob64delpfx.txt (Certificate for app authentication)"
Write-Output "- script.ps1 (This script)"
Write-Output "- close-up-doctor-holding-red-heart.jpg (Research image)"

Write-Output ""
Write-Output "=== Attack Vector Summary ==="
Write-Output "1. Extract SAS token from HTML source code"
Write-Output "2. Use SAS token to access private Azure Storage container"
Write-Output "3. Download certificate file and decode from base64"
Write-Output "4. Use certificate to authenticate to Azure AD application"
Write-Output "5. Escalate privileges using app permissions"
Write-Output "6. Access sensitive research data and flag"
