# Challenge 01: AWS-Only Public Storage

Este desafío implementa un bucket S3 público con configuraciones de seguridad vulnerables para propósitos educativos de CTF.

## Descripción del Desafío

**Objetivo**: Encontrar y acceder a una flag almacenada en un bucket S3 públicamente accesible.

**Recursos desplegados**:
- Bucket S3 con acceso público de lectura
- Hosting de sitio web estático habilitado
- Flag almacenada en `flag.txt`

**Vulnerabilidad demostrada**:
- Bucket policy que permite acceso público de lectura
- Sin restricciones de acceso
- Hosting web estático habilitado

## Prerrequisitos

### 1. Herramientas Requeridas
- Terraform >= 1.5.0
- AWS CLI v2
- Perfil AWS configurado

### 2. Configuración de AWS

#### Opción A: AWS CLI (Recomendado)
```bash
# Configurar AWS CLI
aws configure --profile ekocloudsec

# Verificar autenticación
aws sts get-caller-identity --profile ekocloudsec
```

#### Opción B: Variables de Entorno
```bash
export AWS_ACCESS_KEY_ID="tu-access-key"
export AWS_SECRET_ACCESS_KEY="tu-secret-key"
export AWS_DEFAULT_REGION="us-east-1"
export AWS_PROFILE="ekocloudsec"
```

### 3. Permisos AWS Requeridos
Tu usuario/rol AWS necesita los siguientes permisos:
- `s3:CreateBucket`
- `s3:DeleteBucket`
- `s3:GetBucketPolicy`
- `s3:PutBucketPolicy`
- `s3:PutBucketWebsite`
- `s3:PutObject`
- `s3:GetObject`
- `s3:DeleteObject`

## Despliegue

### 1. Configurar Variables
```bash
cd terraform/challenges/challenge-01-aws-only

# Copiar archivo de ejemplo
cp terraform.tfvars.example terraform.tfvars

# Editar variables (opcional)
# Las variables por defecto funcionan con el perfil 'ekocloudsec'
```

### 2. Configurar Backend de Terraform
```bash
# Inicializar con backend S3
terraform init -backend-config=../../backend-configs/s3.hcl
```

### 3. Desplegar Infraestructura
```bash
# Revisar el plan de despliegue
terraform plan

# Aplicar cambios
terraform apply
```

### 4. Obtener URLs del Desafío
Después del despliegue, Terraform mostrará:
```
Outputs:

aws_flag_url = "http://bucket-name.s3-website-us-east-1.amazonaws.com/flag.txt"
aws_s3_bucket_name = "bucket-name"
aws_s3_website_endpoint = "http://bucket-name.s3-website-us-east-1.amazonaws.com"
challenge_summary = {
  "bucket" = "bucket-name"
  "flag" = "http://bucket-name.s3-website-us-east-1.amazonaws.com/flag.txt"
  "website" = "http://bucket-name.s3-website-us-east-1.amazonaws.com"
}
```

## Información para Participantes

Una vez desplegada la infraestructura, los participantes recibirán las URLs necesarias para completar el desafío. La solución detallada se encuentra en el archivo `SOLUTION.md` de este directorio.

## Limpieza

Para eliminar todos los recursos:
```bash
terraform destroy
```

## Troubleshooting

### Problemas Comunes

**Error: "Access Denied"**
- Verifica que tu perfil AWS esté configurado correctamente
- Confirma que tienes los permisos S3 necesarios
- Verifica la región configurada

**Error: "Backend initialization failed"**
- Asegúrate de que el bucket S3 para el backend existe
- Verifica que tienes acceso al bucket de backend
- Confirma que la tabla DynamoDB para locks existe

**Error: "Bucket name conflicts"**
- Los nombres de bucket S3 son únicos globalmente
- El módulo usa sufijos aleatorios para evitar conflictos
- Si persiste, cambia el `project_name` en `terraform.tfvars`

### Problemas de Enumeración

Para troubleshooting detallado de problemas de enumeración, consulta el archivo `SOLUTION.md`.

### Logs Detallados
```bash
# Habilitar logging detallado
export TF_LOG=DEBUG
terraform apply
```

## Configuración Avanzada

### Variables Personalizables

| Variable | Descripción | Valor por Defecto |
|----------|-------------|-------------------|
| `aws_region` | Región AWS | `us-east-1` |
| `aws_profile` | Perfil AWS CLI | `ekocloudsec` |
| `project_name` | Nombre del proyecto | `ctf-25` |

### Ejemplo de terraform.tfvars Personalizado
```hcl
aws_region   = "us-west-2"
aws_profile  = "mi-perfil"
project_name = "mi-ctf"
```

## Notas de Seguridad

⚠️ **ADVERTENCIA**: Este desafío crea vulnerabilidades de seguridad intencionalmente para propósitos educativos. 

- NO despliegues en entornos de producción
- NO uses con datos sensibles
- Elimina los recursos después de completar el desafío
- Los buckets públicos pueden incurrir en costos si reciben tráfico masivo
