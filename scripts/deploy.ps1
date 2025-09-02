# CTF-25 Deployment Script
# PowerShell script to deploy Challenge 1 across all cloud providers

param(
    [Parameter(Mandatory=$true)]
    [string]$GcpProjectId,
    
    [string]$BackendConfig = "s3"
)

Write-Host "🚀 Starting CTF-25 Challenge 1 deployment..." -ForegroundColor Green

# Change to challenge directory
$ChallengeDir = Join-Path $PSScriptRoot "..\terraform\challenges\challenge-01-public-storage"
Set-Location $ChallengeDir

# Create terraform.tfvars if it doesn't exist
$TfvarsFile = "terraform.tfvars"
if (-not (Test-Path $TfvarsFile)) {
    Write-Host "📝 Creating terraform.tfvars file..." -ForegroundColor Yellow
    @"
gcp_project_id = "$GcpProjectId"
"@ | Out-File -FilePath $TfvarsFile -Encoding UTF8
}

# Initialize Terraform
Write-Host "🔧 Initializing Terraform..." -ForegroundColor Blue
$BackendConfigFile = "..\..\backend-configs\$BackendConfig.hcl"
terraform init -backend-config=$BackendConfigFile

if ($LASTEXITCODE -ne 0) {
    Write-Error "❌ Terraform initialization failed!"
    exit 1
}

# Plan deployment
Write-Host "📋 Planning deployment..." -ForegroundColor Blue
terraform plan -out=tfplan

if ($LASTEXITCODE -ne 0) {
    Write-Error "❌ Terraform planning failed!"
    exit 1
}

# Apply deployment
Write-Host "🚀 Applying deployment..." -ForegroundColor Green
terraform apply tfplan

if ($LASTEXITCODE -eq 0) {
    Write-Host "✅ Deployment completed successfully!" -ForegroundColor Green
    Write-Host "🎯 Challenge URLs will be displayed above in the Terraform outputs." -ForegroundColor Cyan
} else {
    Write-Error "❌ Deployment failed!"
    exit 1
}

# Cleanup plan file
Remove-Item tfplan -ErrorAction SilentlyContinue

Write-Host "🏆 CTF Challenge 1 is now live across all three cloud providers!" -ForegroundColor Green
