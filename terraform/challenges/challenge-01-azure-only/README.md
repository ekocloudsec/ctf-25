# Challenge 01: Azure Combined Storage & Identity Challenge

Este desafío combinado implementa múltiples vectores de ataque en Azure Storage y Azure AD para propósitos educativos de CTF.

## Descripción del Desafío

**Objetivo**: Encontrar y acceder a flags mediante dos rutas de ataque diferentes:

### Vector 1: Acceso Directo (Básico)
- Azure Storage Account con acceso público de lectura
- Hosting de sitio web estático habilitado
- Flag básica almacenada en `flag.txt`

### Vector 2: MediCloudX Research Portal (Avanzado)
- Portal de investigación con SAS tokens embebidos
- Container privado con datos sensibles
- Azure AD App Registration con autenticación por certificado
- Usuario Azure AD con credenciales conocidas
- Flag avanzada en container privado

**Vulnerabilidades demostradas**:
- Container con acceso público de lectura (CWE-200)
- SAS token expuesto en código cliente (CWE-200)
- Token SAS con permisos excesivos y larga expiración (CWE-732)
- Certificado almacenado en ubicación accesible (CWE-522)
- Contraseña débil de certificado (CWE-521)

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

## Información para Participantes

Una vez desplegada la infraestructura, los participantes recibirán las URLs necesarias para completar el desafío. La solución detallada se encuentra en el archivo `SOLUTION.md` de este directorio.

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

Para troubleshooting detallado de problemas de enumeración, consulta el archivo `SOLUTION.md`.

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
