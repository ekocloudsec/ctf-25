# Challenge 01: Azure-Only Public Storage

Este desafío implementa una cuenta de Azure Storage con configuraciones de seguridad vulnerables para propósitos educativos de CTF.

## Descripción del Desafío

**Objetivo**: Encontrar y acceder a una flag almacenada en un Azure Storage Account públicamente accesible.

**Recursos desplegados**:
- Azure Storage Account con acceso público de lectura
- Hosting de sitio web estático habilitado
- Flag almacenada en `flag.txt`

**Vulnerabilidad demostrada**:
- Container con acceso público de lectura
- Sin restricciones de acceso a blobs
- Hosting web estático habilitado

## Prerrequisitos

### 1. Herramientas Requeridas
- Terraform >= 1.5.0
- Azure CLI
- Suscripción de Azure activa

### 2. Configuración de Azure

#### Configurar Azure CLI
```bash
# Iniciar sesión en Azure
az login

# Listar suscripciones disponibles
az account list --output table

# Configurar suscripción activa
az account set --subscription "your-subscription-id"

# Verificar autenticación
az account show --query "{subscriptionId: id, tenantId: tenantId}" --output table
```

### 3. Permisos Azure Requeridos
Tu usuario/rol Azure necesita los siguientes permisos:
- `Microsoft.Storage/storageAccounts/*`
- `Microsoft.Resources/resourceGroups/*`
- Contributor role en la suscripción (recomendado para CTF)

## Despliegue

### 1. Configurar Variables
```bash
cd terraform/challenges/challenge-01-azure-only

# Copiar archivo de ejemplo
cp terraform.tfvars.example terraform.tfvars

# Editar con tus credenciales de Azure
# azure_subscription_id = "tu-subscription-id"
# azure_tenant_id = "tu-tenant-id"
```

### 2. Configurar Backend de Terraform
```bash
# Inicializar con backend Azure
terraform init -backend-config=../../backend-configs/azurerm.hcl
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

azure_flag_url = "https://ctf25sa9ed81dc6.z13.web.core.windows.net/flag.txt"
azure_storage_account_name = "ctf25sa9ed81dc6"
azure_storage_website_endpoint = "https://ctf25sa9ed81dc6.z13.web.core.windows.net/"
challenge_summary = {
  "flag" = "https://ctf25sa9ed81dc6.z13.web.core.windows.net/flag.txt"
  "storage_account" = "ctf25sa9ed81dc6"
  "website" = "https://ctf25sa9ed81dc6.z13.web.core.windows.net/"
}
```

## Solución del Desafío

### Paso a Paso para Candidatos

Una vez que tengas los outputs del despliegue de Terraform, sigue estos pasos para enumerar el Azure Storage Account y obtener la flag:

#### Información Disponible
Con base en los outputs de Terraform, tienes:
```
azure_flag_url = "https://ctf25sa9ed81dc6.z13.web.core.windows.net/flag.txt"
azure_storage_account_name = "ctf25sa9ed81dc6"
azure_storage_website_endpoint = "https://ctf25sa9ed81dc6.z13.web.core.windows.net/"
```

#### Método 1: Enumeración con Azure CLI (Recomendado)

**Paso 1: Listar blobs del container**
```bash
# Listar todos los blobs en el container público
az storage blob list --account-name ctf25sa9ed81dc6 --container-name '$web' --output table --auth-mode login

# Alternativamente, sin autenticación (acceso público)
az storage blob list --account-name ctf25sa9ed81dc6 --container-name '$web' --output table
```

**Paso 2: Descargar y ver el contenido de la flag**
```bash
# Descargar la flag directamente
az storage blob download --account-name ctf25sa9ed81dc6 --container-name '$web' --name flag.txt --file flag.txt --auth-mode login

# Ver contenido
cat flag.txt

# O descargar directamente a stdout
az storage blob download --account-name ctf25sa9ed81dc6 --container-name '$web' --name flag.txt --file /dev/stdout --auth-mode login
```

**Paso 3: Verificar otros archivos (opcional)**
```bash
# Ver el contenido del index.html
az storage blob download --account-name ctf25sa9ed81dc6 --container-name '$web' --name index.html --file /dev/stdout --auth-mode login
```

#### Método 2: Acceso Web Directo

**Paso 1: Acceder al sitio web**
```bash
# Usar curl para acceder al endpoint web
curl https://ctf25sa9ed81dc6.z13.web.core.windows.net/

# O abrir en navegador
open https://ctf25sa9ed81dc6.z13.web.core.windows.net/
```

**Paso 2: Acceder directamente a la flag**
```bash
# Descargar la flag vía HTTPS
curl https://ctf25sa9ed81dc6.z13.web.core.windows.net/flag.txt

# O usar wget
wget -O - https://ctf25sa9ed81dc6.z13.web.core.windows.net/flag.txt
```

#### Método 3: Enumeración con Azure Storage Explorer

**Usando Azure Storage Explorer (GUI):**
1. Descargar e instalar Azure Storage Explorer
2. Conectar usando "Add a resource via URL"
3. URL: `https://ctf25sa9ed81dc6.blob.core.windows.net/`
4. Navegar al container `$web`
5. Descargar `flag.txt`

#### Método 4: Enumeración con herramientas de terceros

**Usando PowerShell (Windows/Linux/macOS):**
```powershell
# Instalar módulo Azure Storage si no está disponible
Install-Module -Name Az.Storage -Force

# Crear contexto de storage sin autenticación
$ctx = New-AzStorageContext -StorageAccountName "ctf25sa9ed81dc6" -Anonymous

# Listar blobs en el container
Get-AzStorageBlob -Container '$web' -Context $ctx

# Salida esperada:
# Name         BlobType  Length  ContentType   LastModified         AccessTier
# ----         --------  ------  -----------   ------------         ----------
# flag.txt     BlockBlob 42      text/plain    2025-09-12 20:01:37Z Hot
# index.html   BlockBlob 13168   text/html     2025-09-12 20:01:37Z Hot

# Descargar flag a archivo local
Get-AzStorageBlobContent -Container '$web' -Blob "flag.txt" -Destination "./flag.txt" -Context $ctx

# Ver contenido de la flag
Get-Content "./flag.txt"

# Método alternativo: Descargar directamente con Invoke-WebRequest
$flagContent = Invoke-WebRequest -Uri "https://ctf25sa9ed81dc6.z13.web.core.windows.net/flag.txt"
Write-Output "Flag: $($flagContent.Content)"

# O usar el endpoint blob directo
$flagContent = Invoke-WebRequest -Uri "https://ctf25sa9ed81dc6.blob.core.windows.net/`$web/flag.txt"
Write-Output "Flag: $($flagContent.Content)"
```

**Usando Python con azure-storage-blob:**
```python
from azure.storage.blob import BlobServiceClient

# Cliente sin autenticación para acceso público
account_url = "https://ctf25sa9ed81dc6.blob.core.windows.net"
blob_service_client = BlobServiceClient(account_url=account_url)

# Listar blobs en el container $web
container_client = blob_service_client.get_container_client('$web')
blob_list = container_client.list_blobs()

print("Blobs encontrados:")
for blob in blob_list:
    print(f"- {blob.name} ({blob.size} bytes)")

# Descargar flag
blob_client = blob_service_client.get_blob_client(container='$web', blob='flag.txt')
flag_content = blob_client.download_blob().readall().decode('utf-8')
print(f"Flag: {flag_content}")
```

#### Método 5: Enumeración Manual con Browser

1. **Acceder al storage account via navegador:**
   - URL: `https://ctf25sa9ed81dc6.z13.web.core.windows.net/`
   - Explorar el contenido disponible

2. **Acceso directo a la flag:**
   - URL: `https://ctf25sa9ed81dc6.z13.web.core.windows.net/flag.txt`

3. **Explorar estructura de URLs:**
   - Probar diferentes paths como `/admin/`, `/config/`, `/backup/`
   - Buscar archivos comunes como `robots.txt`, `sitemap.xml`

### Comandos de Verificación

**Verificar configuración del storage account:**
```bash
# Obtener propiedades del storage account
az storage account show --name ctf25sa9ed81dc6 --query "{name:name, kind:kind, accessTier:accessTier, allowBlobPublicAccess:allowBlobPublicAccess}"

# Verificar configuración de sitio web estático
az storage blob service-properties show --account-name ctf25sa9ed81dc6 --services b --query "staticWebsite"

# Verificar permisos del container
az storage container show --name '$web' --account-name ctf25sa9ed81dc6 --query "{name:name, publicAccess:properties.publicAccess}"
```

**Verificar accesibilidad sin autenticación:**
```bash
# Probar acceso directo a blobs
curl -I https://ctf25sa9ed81dc6.blob.core.windows.net/\$web/flag.txt

# Verificar headers de respuesta
curl -v https://ctf25sa9ed81dc6.z13.web.core.windows.net/flag.txt
```

### Formato de la Flag
```
CLD[UUID]
```

### Puntos de Aprendizaje

1. **Azure Storage público**: Los containers con acceso público permiten enumeración sin autenticación
2. **Static website hosting**: Los storage accounts configurados para hosting estático son accesibles vía HTTPS
3. **Container $web**: Azure usa el container especial `$web` para hosting de sitios web estáticos
4. **Múltiples métodos de acceso**: Azure CLI, REST API, PowerShell, Python, navegador web
5. **Sin autenticación**: Los recursos públicos no requieren credenciales de Azure

## Limpieza

Para eliminar todos los recursos:
```bash
terraform destroy
```

## Troubleshooting

### Problemas Comunes

**Error: "Authentication failed"**
- Verifica que tu Azure CLI esté autenticado: `az account show`
- Confirma que tienes los permisos necesarios en la suscripción
- Verifica la región configurada

**Error: "Backend initialization failed"**
- Asegúrate de que el Resource Group para el backend existe
- Verifica que tienes acceso al Storage Account de backend
- Confirma que el container `tfstate` existe

**Error: "Storage account name conflicts"**
- Los nombres de storage account son únicos globalmente
- El módulo usa sufijos aleatorios para evitar conflictos
- Si persiste, cambia el `project_name` en `terraform.tfvars`

### Problemas de Enumeración

**Error: "StorageAccountNotFound" al enumerar**
```bash
# Verificar que el storage account existe
az storage account show --name ctf25sa9ed81dc6

# Si falla, verificar el nombre exacto en los outputs de Terraform
terraform output azure_storage_account_name
```

**Error: "Access Denied" durante enumeración**
```bash
# Verificar si el container permite acceso público
az storage container show --name '$web' --account-name ctf25sa9ed81dc6

# Intentar acceso web directo si Azure CLI falla
curl -I https://ctf25sa9ed81dc6.z13.web.core.windows.net/
```

**Error: "SSL Certificate" con herramientas de terceros**
```bash
# Para curl, verificar certificados
curl --insecure https://ctf25sa9ed81dc6.z13.web.core.windows.net/flag.txt

# Verificar conectividad básica
nslookup ctf25sa9ed81dc6.z13.web.core.windows.net
```

**Timeout o conexión lenta**
```bash
# Verificar conectividad básica
ping ctf25sa9ed81dc6.z13.web.core.windows.net

# Usar región específica si hay problemas
az storage blob list --account-name ctf25sa9ed81dc6 --container-name '$web' --output table --query "[].{Name:name, Size:properties.contentLength}"
```

**Flag no encontrada**
```bash
# Listar todos los blobs para verificar estructura
az storage blob list --account-name ctf25sa9ed81dc6 --container-name '$web' --output table

# Verificar si la flag está en otros containers
az storage container list --account-name ctf25sa9ed81dc6 --output table

# Buscar archivos que contengan "flag" en el nombre
az storage blob list --account-name ctf25sa9ed81dc6 --container-name '$web' --output table | grep -i flag
```

### Logs Detallados
```bash
# Habilitar logging detallado
export TF_LOG=DEBUG
terraform apply

# Logs de Azure CLI
az storage blob list --account-name ctf25sa9ed81dc6 --container-name '$web' --debug
```

## Configuración Avanzada

### Variables Personalizables

| Variable | Descripción | Valor por Defecto |
|----------|-------------|-------------------|
| `azure_location` | Región Azure | `East US` |
| `azure_subscription_id` | ID de suscripción Azure | (requerido) |
| `azure_tenant_id` | ID de tenant Azure | (requerido) |
| `project_name` | Nombre del proyecto | `ctf-25` |

### Ejemplo de terraform.tfvars Personalizado
```hcl
azure_subscription_id = "tu-subscription-id"
azure_tenant_id       = "tu-tenant-id"
azure_location        = "West Europe"
project_name          = "mi-ctf"
```

## Notas de Seguridad

⚠️ **ADVERTENCIA**: Este desafío crea vulnerabilidades de seguridad intencionalmente para propósitos educativos. 

- NO despliegues en entornos de producción
- NO uses con datos sensibles
- Elimina los recursos después de completar el desafío
- Los storage accounts públicos pueden incurrir en costos si reciben tráfico masivo
- Azure cobra por almacenamiento y transferencia de datos
