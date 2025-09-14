# Challenge 01 - GCP Only: Public Storage Misconfiguration

## 🎯 Objetivo del Challenge

Este challenge simula una configuración incorrecta común en Google Cloud Platform donde un bucket de Cloud Storage se configura con permisos públicos, exponiendo archivos sensibles que deberían ser privados.

## 🏗️ Arquitectura del Challenge

```
┌─────────────────────────────────────────┐
│           Google Cloud Platform         │
├─────────────────────────────────────────┤
│  ┌─────────────────────────────────┐    │
│  │      Cloud Storage Bucket       │    │
│  │   ctf-25-website-{random}       │    │
│  │                                 │    │
│  │  📄 index.html (público)        │    │
│  │  🚩 flag.txt (público)          │    │
│  │                                 │    │
│  │  IAM: allUsers → objectViewer   │    │
│  └─────────────────────────────────┘    │
└─────────────────────────────────────────┘
```

## 🚀 Despliegue del Challenge

### Prerrequisitos

1. **Google Cloud CLI instalado y configurado**
   ```bash
   gcloud --version
   gcloud auth list
   ```

2. **Terraform instalado**
   ```bash
   terraform --version
   ```

3. **Autenticación configurada**
   ```bash
   gcloud auth application-default login
   ```

### Pasos de Despliegue

1. **Crear bucket para el estado de Terraform**
   ```bash
   gsutil mb gs://ctf-25-terraform-state-gcp
   ```

2. **Inicializar Terraform**
   ```bash
   terraform init -backend-config=../../backend-configs/challenge-01-gcs.hcl
   ```

3. **Crear archivo de variables (opcional)**
   ```bash
   cp terraform.tfvars.example terraform.tfvars
   # Editar si es necesario
   ```

4. **Planificar el despliegue**
   ```bash
   terraform plan
   ```

5. **Aplicar la configuración**
   ```bash
   terraform apply
   ```

## 🔍 Información del Challenge Desplegado

Después del despliegue exitoso, obtendrás las siguientes URLs:

- **Sitio web**: `https://storage.googleapis.com/{bucket-name}/index.html`
- **Flag**: `https://storage.googleapis.com/{bucket-name}/flag.txt`
- **Bucket**: `{bucket-name}`

## 🕵️ Información para Participantes

Te encuentras con una aplicación web de "MediCloudX Store" que parece ser una tienda en línea de dispositivos médicos. Tu objetivo es encontrar información sensible que podría estar expuesta debido a configuraciones incorrectas de seguridad.

La solución detallada se encuentra en el archivo `SOLUTION.md` de este directorio.

## 🧪 Comandos de Verificación

```bash
# Verificar el despliegue
terraform output

# Probar acceso al flag
curl $(terraform output -raw gcp_flag_url)

# Verificar permisos del bucket
gsutil iam get gs://$(terraform output -raw gcp_bucket_name)

# Listar objetos del bucket
gsutil ls gs://$(terraform output -raw gcp_bucket_name)/
```

## 🧹 Limpieza

Para destruir los recursos creados:

```bash
terraform destroy
```

Para eliminar el bucket de estado (opcional):
```bash
gsutil rm -r gs://ctf-25-terraform-state-gcp/
```

## 📚 Referencias

- [Google Cloud Storage Security Best Practices](https://cloud.google.com/storage/docs/best-practices)
- [IAM for Cloud Storage](https://cloud.google.com/storage/docs/access-control/iam)
- [Cloud Storage Access Control](https://cloud.google.com/storage/docs/access-control)
- [Terraform Google Provider](https://registry.terraform.io/providers/hashicorp/google/latest/docs)

## 🏷️ Etiquetas

`#CTF` `#GCP` `#CloudStorage` `#IAM` `#SecurityMisconfiguration` `#PublicBucket` `#Challenge01`
