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

## Solución del Desafío

### Paso a Paso para Candidatos

Una vez que tengas los outputs del despliegue de Terraform, sigue estos pasos para enumerar el bucket S3 y obtener la flag:

#### Información Disponible
Con base en los outputs de Terraform, tienes:
```
aws_flag_url = "http://ctf-25-website-c7b06639.s3-website-us-east-1.amazonaws.com/flag.txt"
aws_s3_bucket_name = "ctf-25-website-c7b06639"
aws_s3_website_endpoint = "http://ctf-25-website-c7b06639.s3-website-us-east-1.amazonaws.com"
```

#### Método 1: Enumeración con AWS CLI (Recomendado)

**Paso 1: Listar objetos del bucket**
```bash
# Listar todos los objetos en el bucket público
aws s3 ls s3://ctf-25-website-c7b06639 --no-sign-request

# Salida esperada:
# 2024-01-15 10:30:45        123 flag.txt
# 2024-01-15 10:30:45       1024 index.html
```

**Paso 2: Descargar y ver el contenido de la flag**
```bash
# Descargar la flag directamente a stdout
aws s3 cp s3://ctf-25-website-c7b06639/flag.txt - --no-sign-request

# O descargar a un archivo local
aws s3 cp s3://ctf-25-website-c7b06639/flag.txt ./flag.txt --no-sign-request
cat flag.txt
```

**Paso 3: Verificar otros archivos (opcional)**
```bash
# Ver el contenido del index.html
aws s3 cp s3://ctf-25-website-c7b06639/index.html - --no-sign-request
```

#### Método 2: Acceso Web Directo

**Paso 1: Acceder al sitio web**
```bash
# Usar curl para acceder al endpoint web
curl http://ctf-25-website-c7b06639.s3-website-us-east-1.amazonaws.com

# O abrir en navegador
open http://ctf-25-website-c7b06639.s3-website-us-east-1.amazonaws.com
```

**Paso 2: Acceder directamente a la flag**
```bash
# Descargar la flag vía HTTP
curl http://ctf-25-website-c7b06639.s3-website-us-east-1.amazonaws.com/flag.txt

# O usar wget
wget -O - http://ctf-25-website-c7b06639.s3-website-us-east-1.amazonaws.com/flag.txt
```

#### Método 3: Enumeración con herramientas de terceros

**Usando s3cmd:**
```bash
# Instalar s3cmd si no está disponible
pip install s3cmd

# Listar objetos (configuración anónima)
s3cmd ls s3://ctf-25-website-c7b06639 --no-ssl

# Descargar flag
s3cmd get s3://ctf-25-website-c7b06639/flag.txt --no-ssl
```

**Usando boto3 (Python):**
```python
import boto3
from botocore import UNSIGNED
from botocore.config import Config

# Cliente S3 sin autenticación
s3 = boto3.client('s3', config=Config(signature_version=UNSIGNED))

# Listar objetos
response = s3.list_objects_v2(Bucket='ctf-25-website-c7b06639')
for obj in response.get('Contents', []):
    print(f"{obj['Key']} - {obj['Size']} bytes")

# Descargar flag
response = s3.get_object(Bucket='ctf-25-website-c7b06639', Key='flag.txt')
flag_content = response['Body'].read().decode('utf-8')
print(f"Flag: {flag_content}")
```

#### Método 4: Enumeración Manual con Browser

1. **Acceder al bucket via navegador:**
   - URL: `http://ctf-25-website-c7b06639.s3-website-us-east-1.amazonaws.com`
   - Explorar el contenido disponible

2. **Acceso directo a la flag:**
   - URL: `http://ctf-25-website-c7b06639.s3-website-us-east-1.amazonaws.com/flag.txt`

### Comandos de Verificación

**Verificar permisos del bucket:**
```bash
# Intentar obtener la política del bucket
aws s3api get-bucket-policy --bucket ctf-25-website-c7b06639 --no-sign-request

# Verificar configuración de sitio web
aws s3api get-bucket-website --bucket ctf-25-website-c7b06639 --no-sign-request

# Verificar ACL del bucket
aws s3api get-bucket-acl --bucket ctf-25-website-c7b06639 --no-sign-request
```

### Formato de la Flag
```
CLD[UUID]
```

### Puntos de Aprendizaje

1. **Buckets S3 públicos**: Los buckets con políticas de acceso público permiten enumeración sin autenticación
2. **Website hosting**: Los buckets configurados como sitios web estáticos son accesibles vía HTTP
3. **Enumeración**: Múltiples métodos para acceder al contenido (AWS CLI, curl, navegador, herramientas de terceros)
4. **Sin autenticación**: El flag `--no-sign-request` permite acceso anónimo a recursos públicos

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

**Error: "NoSuchBucket" al enumerar**
```bash
# Verificar que el bucket existe
aws s3api head-bucket --bucket ctf-25-website-c7b06639 --no-sign-request

# Si falla, verificar el nombre exacto del bucket en los outputs de Terraform
terraform output aws_s3_bucket_name
```

**Error: "Access Denied" durante enumeración**
```bash
# Verificar si el bucket permite acceso público
aws s3api get-bucket-policy --bucket ctf-25-website-c7b06639 --no-sign-request

# Intentar acceso web directo si AWS CLI falla
curl -I http://ctf-25-website-c7b06639.s3-website-us-east-1.amazonaws.com
```

**Error: "SSL Certificate" con herramientas de terceros**
```bash
# Para s3cmd, usar --no-ssl
s3cmd ls s3://ctf-25-website-c7b06639 --no-ssl

# Para curl, usar --insecure si es necesario
curl --insecure http://ctf-25-website-c7b06639.s3-website-us-east-1.amazonaws.com/flag.txt
```

**Timeout o conexión lenta**
```bash
# Verificar conectividad básica
ping s3.amazonaws.com

# Usar región específica si hay problemas
aws s3 ls s3://ctf-25-website-c7b06639 --region us-east-1 --no-sign-request
```

**Flag no encontrada**
```bash
# Listar todos los objetos para verificar estructura
aws s3 ls s3://ctf-25-website-c7b06639 --recursive --no-sign-request

# Verificar si la flag está en subdirectorios
aws s3 ls s3://ctf-25-website-c7b06639/ --recursive --no-sign-request | grep -i flag
```

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
