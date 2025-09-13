# Deployment Guide - New GCP Challenges

Esta guía te ayudará a desplegar los nuevos desafíos de GCP que hemos creado.

## Requisitos Previos

### 1. Configuración de Autenticación
Asegúrate de tener configurada la autenticación para GCP:
- Instala Google Cloud SDK
- Ejecuta `gcloud auth application-default login`
- Configura tu proyecto de GCP

### 2. Backend de Terraform
Para GCP, utilizamos un archivo de backend específico para cada desafío:

```bash
# Inicializar con el backend específico del desafío
# Sustituye XX con el número del desafío (01, 02, 03, 04)
terraform init -backend-config=../../backend-configs/challenge-XX-gcs.hcl
```

## Despliegue de Challenge-01-gcp-only (Storage Bucket)

```bash
# Navegar al directorio del desafío
cd terraform/challenges/challenge-01-gcp-only

# Copiar y editar el archivo de variables
cp terraform.tfvars.example terraform.tfvars

# Editar el archivo terraform.tfvars con tu ID de proyecto GCP
# gcp_project_id = "tu-id-de-proyecto-gcp"

# Inicializar Terraform con backend GCS
terraform init -backend-config=../../backend-configs/challenge-01-gcs.hcl

# Revisar el plan de despliegue
terraform plan

# Desplegar la infraestructura
terraform apply
```

## Despliegue de Challenge-02-gcp-only (Secret Manager)

```bash
# Navegar al directorio del desafío
cd terraform/challenges/challenge-02-gcp-only

# Copiar y editar el archivo de variables
cp terraform.tfvars.example terraform.tfvars

# Editar el archivo terraform.tfvars con tu ID de proyecto GCP
# gcp_project_id = "tu-id-de-proyecto-gcp"

# Inicializar Terraform con backend GCS
terraform init -backend-config=../../backend-configs/challenge-02-gcs.hcl

# Revisar el plan de despliegue
terraform plan

# Desplegar la infraestructura
terraform apply
```

Después del despliegue, Terraform mostrará los outputs con:
- Nombre del secreto creado
- URL para acceder al secreto (para referencia interna)

## Despliegue de Challenge-03-gcp-only (Bucket Privado)

```bash
# Navegar al directorio del desafío
cd terraform/challenges/challenge-03-gcp-only

# Copiar y editar el archivo de variables
cp terraform.tfvars.example terraform.tfvars

# Editar el archivo terraform.tfvars con tu ID de proyecto GCP
# gcp_project_id = "tu-id-de-proyecto-gcp"

# Inicializar Terraform con backend GCS
terraform init -backend-config=../../backend-configs/challenge-03-gcs.hcl

# Revisar el plan de despliegue
terraform plan

# Desplegar la infraestructura
terraform apply
```

Después del despliegue, Terraform mostrará los outputs con:
- Nombre del bucket privado creado
- URL del bucket (accesible solo con autenticación)

## Despliegue de Challenge-04-gcp-only (Firestore Database)

```bash
# Navegar al directorio del desafío
cd terraform/challenges/challenge-04-gcp-only

# Copiar y editar el archivo de variables
cp terraform.tfvars.example terraform.tfvars

# Editar el archivo terraform.tfvars con tu ID de proyecto GCP
# gcp_project_id = "tu-id-de-proyecto-gcp"

# Inicializar Terraform con backend GCS
terraform init -backend-config=../../backend-configs/challenge-04-gcs.hcl

# Revisar el plan de despliegue
terraform plan

# Desplegar la infraestructura
terraform apply
```

Después del despliegue, Terraform mostrará los outputs con:
- Nombre de la base de datos Firestore
- Ruta de la colección de logs
- URL para acceder a la consola de Firestore

## Limpieza

Para eliminar la infraestructura desplegada:

```bash
terraform destroy
```

## Solución de Problemas

### Problemas Comunes
1. **ID de proyecto GCP no configurado** - Asegúrate de configurar `gcp_project_id` en `terraform.tfvars`
2. **Errores de autenticación** - Verifica la autenticación con GCP
3. **Fallo en inicialización del backend** - Asegúrate de que el bucket GCS existe y las credenciales son válidas
4. **Conflictos en nombres de recursos** - Se utilizan sufijos aleatorios para evitar conflictos

### Registros y Depuración
```bash
# Habilitar registros detallados de Terraform
export TF_LOG=DEBUG
terraform apply
```
