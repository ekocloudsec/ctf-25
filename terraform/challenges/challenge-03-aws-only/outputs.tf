# Output values for the challenge

output "web_application_url" {
  description = "Public URL of the MediCloudX Health web application"
  value       = "http://${aws_eip.web_app_eip.public_ip}"
}

output "web_application_ip" {
  description = "Public IP address of the web application"
  value       = aws_eip.web_app_eip.public_ip
}

output "ec2_instance_id" {
  description = "ID of the EC2 instance running the web application"
  value       = aws_instance.web_app.id
}

output "credentials_bucket_name" {
  description = "Name of the S3 bucket containing daniel.lopez credentials"
  value       = aws_s3_bucket.credentials_bucket.id
}

output "flag_bucket_name" {
  description = "Name of the S3 bucket containing the flag"
  value       = aws_s3_bucket.flag_bucket.id
}

output "daniel_lopez_access_key" {
  description = "Access key for daniel.lopez user (for verification)"
  value       = aws_iam_access_key.daniel_lopez_key.id
  sensitive   = true
}

output "daniel_lopez_secret_key" {
  description = "Secret key for daniel.lopez user (for verification)"
  value       = aws_iam_access_key.daniel_lopez_key.secret
  sensitive   = true
}

output "challenge_instructions" {
  description = "Instructions for participants"
  value = <<-EOT
    Challenge 03 - AWS EC2 SSRF to S3 Access
    
    🎯 Objetivo: Obtener el flag final desde el bucket de datos de pacientes
    
    📋 Información inicial:
    - URL del Portal: http://${aws_eip.web_app_eip.public_ip}
    - Sistema: MediCloudX Health - Portal de Análisis de Datos
    
    🔍 Flujo de ataque esperado:
    1. Explorar el portal web de MediCloudX Health
    2. Identificar la funcionalidad vulnerable a SSRF
    3. Usar SSRF para acceder al servicio de metadatos de EC2
    4. Obtener credenciales temporales de AWS desde el metadata service
    5. Usar las credenciales para acceder al bucket de credenciales
    6. Obtener las credenciales de daniel.lopez desde el archivo CSV
    7. Usar las credenciales de daniel.lopez para acceder al bucket de datos de pacientes
    8. Recuperar el flag final
    
    🏁 Flag format: CTF{...}
  EOT
}
