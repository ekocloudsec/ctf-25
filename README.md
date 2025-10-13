# MediCloudX Security CTF 2025

Bienvenido al CTF de seguridad en la nube de MediCloudX. Este evento presenta 15 desafíos que abarcan AWS, Azure y GCP, diseñados para poner a prueba tus habilidades en seguridad cloud y descubrir vulnerabilidades en infraestructuras de nube.

---

## 📋 Challenges

### 🔴 AWS Challenges

#### **AWS-01: MediCloudX Public Portal**
- **Categoría:** Cloud Security / AWS
- **Tipo:** Standard
- **Puntos:** 50
- **Dificultad:** ⭐ Beginner

**Descripción del Reto:**

MediCloudX ha lanzado su nuevo portal de información pública para pacientes. La empresa afirma que su infraestructura en la nube es completamente segura y que han implementado las mejores prácticas de AWS.

Tu objetivo es investigar si realmente han configurado correctamente su almacenamiento en la nube.

**Recursos Proporcionados:**
- URL del sitio web público de MediCloudX
- Nombre del bucket S3

**Objetivo:**
Encuentra la flag almacenada en el sistema de almacenamiento de MediCloudX.

**Formato de la Flag:**
```
CLD[uuid-format]
```

**Habilidades Requeridas:**
- Conocimientos básicos de AWS S3
- Enumeración de recursos cloud
- Uso de AWS CLI o herramientas web

**Pistas:**
- Los buckets S3 pueden tener diferentes configuraciones de acceso público
- Existen múltiples formas de acceder al contenido de un bucket
- No necesitas credenciales AWS para completar este desafío

---

#### **AWS-02A: MediCloudX Patient Portal**
- **Categoría:** Web Security / Identity & Access / AWS
- **Tipo:** Dynamic
- **Puntos Iniciales:** 450 (decrece con más solves)
- **Dificultad:** ⭐⭐⭐⭐ Hard

**Descripción del Reto:**

MediCloudX ha desarrollado un portal web moderno para que el personal médico acceda a los registros de pacientes. El sistema implementa un sofisticado esquema de autenticación basado en AWS Cognito con diferentes roles de usuario: personal de lectura básica y directores médicos con acceso completo.

La aplicación está orgullosa de su sistema de control de acceso basado en roles. Tu objetivo es encontrar una forma de acceder a los registros médicos confidenciales a través de la API REST del sistema.

**Recursos Proporcionados:**
- URL de la aplicación web MediCloudX Patient Portal
- Sistema de autenticación y registro de usuarios
- API Gateway endpoint para gestión de registros de pacientes

**Objetivo:**
Accede a la API de registros médicos con privilegios elevados y encuentra la flag oculta en los datos de pacientes almacenados en DynamoDB.

**Formato de la Flag:**
```
CTF{m3d1cl0udx_d4t4b4s3_4cc3ss_pr1v1l3g3_3sc4l4t10n}
```

**Habilidades Requeridas:**
- Análisis de aplicaciones web y código fuente del cliente
- Conocimiento de AWS Cognito y gestión de identidades
- Comprensión de JWT y tokens de autenticación
- Interacción con APIs REST y API Gateway
- Conceptos de control de acceso basado en roles (RBAC)

**Pistas:**
- Inspecciona el código fuente del sitio web para encontrar la configuración de la API
- Las validaciones del lado del cliente no siempre son suficientes
- Los sistemas de autenticación modernos utilizan tokens JWT para autorización
- Los tokens JWT contienen claims sobre el usuario - ¿qué información llevan?
- Considera cómo se asignan los roles de usuario en el sistema de autenticación

---

#### **AWS-02B: MediCloudX Patient Exfiltration**
- **Categoría:** Identity & Access / AWS / Cloud Security
- **Tipo:** Dynamic
- **Puntos Iniciales:** 450 (decrece con más solves)
- **Dificultad:** ⭐⭐⭐⭐ Hard

**Descripción del Reto:**

El portal de MediCloudX no solo gestiona autenticación web, también utiliza AWS Cognito Identity Pool para proporcionar acceso directo a recursos de AWS basándose en el rol del usuario autenticado. Esto permite que aplicaciones móviles y otros clientes accedan directamente a servicios como S3 y DynamoDB sin pasar por la API web.

Si logras escalar tus privilegios en el sistema de autenticación, podrías obtener credenciales AWS temporales con permisos elevados para acceder a recursos sensibles almacenados en la nube.

**Recursos Proporcionados:**
- Mismo portal web de MediCloudX (relacionado con AWS-02A)
- AWS Cognito Identity Pool configurado
- Buckets S3 con datos clasificados

**Objetivo:**
Obtén credenciales AWS temporales con privilegios administrativos y accede al bucket S3 que contiene información clasificada de MediCloudX.

**Formato de la Flag:**
```
CTF{c0gn1t0_pr1v1l3g3_3sc4l4t10n_vuln3r4b1l1ty}
```

**Habilidades Requeridas:**
- Conocimiento avanzado de AWS Cognito Identity Pool
- Uso de AWS CLI para servicios de identidad
- Comprensión de credenciales temporales de AWS (STS)
- Acceso a recursos AWS (S3, DynamoDB)
- Mapeo de roles IAM en Identity Pool

**Pistas:**
- AWS Cognito Identity Pool proporciona credenciales AWS temporales a usuarios autenticados
- Necesitas un ID token válido para obtener credenciales del Identity Pool
- Una vez que tienes credenciales temporales, actúan como cualquier credencial AWS
- Los atributos del usuario determinan qué rol IAM se asigna
- Busca información sobre Identity Pool ID en la configuración de la aplicación

**Recursos Útiles:**
- AWS Cognito Identity CLI documentation
- AWS STS (Security Token Service)
- Documentación de aws cognito-identity get-credentials-for-identity

---

#### **AWS-03: MediCloudX Data Analytics Portal**
- **Categoría:** Web Security / Cloud Security / AWS
- **Tipo:** Dynamic
- **Puntos Iniciales:** 550 (decrece con más solves)
- **Dificultad:** ⭐⭐⭐ Medium

**Descripción del Reto:**

MediCloudX ha implementado un portal interno de análisis de datos para su equipo de investigación médica. El portal incluye una herramienta de verificación de conectividad que permite a los analistas probar la accesibilidad de servicios externos necesarios para sus estudios.

Tu misión es investigar este portal y encontrar una manera de acceder a los datos sensibles de pacientes almacenados en el sistema de almacenamiento de la empresa.

**Recursos Proporcionados:**
- URL del portal de análisis de datos de MediCloudX
- Herramienta de verificación de conectividad

**Objetivo:**
Explora el portal, identifica vulnerabilidades en los servicios web, y recupera la flag almacenada en los sistemas de almacenamiento de MediCloudX.

**Formato de la Flag:**
```
CTF{...}
```

**Habilidades Requeridas:**
- Análisis de aplicaciones web
- Pruebas de seguridad en servicios web
- Comprensión de arquitecturas cloud AWS
- Conocimiento de servicios de computación y almacenamiento
- Uso de AWS CLI
- Análisis de configuraciones IAM

**Pistas:**
- Las herramientas de verificación de conectividad pueden ser peligrosas si no están bien implementadas
- Los servidores en la nube tienen acceso a metadatos internos
- Las instancias de computación en AWS pueden tener roles asociados
- Los roles proporcionan credenciales temporales para acceder a otros recursos
- Puede haber múltiples usuarios IAM con diferentes niveles de permisos
- No todos los recursos están directamente accesibles - a veces necesitas escalar privilegios

**Recursos Útiles:**
- Documentación de AWS EC2
- AWS IAM roles y policies
- AWS S3 CLI commands

---

### 🔵 Azure Challenges

*Próximamente...*

---

### 🟢 GCP Challenges

*Próximamente...*

---

## 📊 Sistema de Puntuación

Este CTF utiliza dos tipos de desafíos:

### Standard Challenges
Desafíos con puntuación fija. El valor de puntos no cambia sin importar cuántos participantes lo resuelvan.

### Dynamic Challenges
Desafíos con puntuación dinámica. El valor disminuye a medida que más participantes lo resuelven. Los primeros en resolver obtienen más puntos.

### Escala de Dificultad y Puntos

| Dificultad | Puntos (Standard) | Puntos Iniciales (Dynamic) | Descripción |
|------------|-------------------|---------------------------|-------------|
| ⭐ Beginner | 50-100 | 100-150 | Conceptos básicos, configuraciones obvias |
| ⭐⭐ Easy | 150-250 | 250-350 | Enumeración simple, herramientas estándar |
| ⭐⭐⭐ Medium | 300-450 | 450-600 | Múltiples pasos, conocimiento intermedio |
| ⭐⭐⭐⭐ Hard | 500-750 | 750-1000 | Cadenas de explotación, técnicas avanzadas |
| ⭐⭐⭐⭐⭐ Expert | 800-1000 | 1000-1500 | Investigación profunda, CVEs, bypass complejos |

### Resumen de Challenges Disponibles

| Challenge | Cloud | Tipo | Puntos | Dificultad | Tiempo Est. |
|-----------|-------|------|--------|------------|-------------|
| AWS-01: MediCloudX Public Portal | AWS | Standard | 50 | ⭐ Beginner | 5-15 min |
| AWS-02A: MediCloudX Patient Portal | AWS | Dynamic | 450 → 150 | ⭐⭐⭐⭐ Hard | 30-60 min |
| AWS-02B: MediCloudX Patient Exfiltration | AWS | Dynamic | 450 → 150 | ⭐⭐⭐⭐ Hard | 30-60 min |
| AWS-03: MediCloudX Data Analytics Portal | AWS | Dynamic | 550 → 175 | ⭐⭐⭐ Medium | 30-45 min |
| **Total Puntos AWS:** | | | **1500** | | |

*Nota: AWS-02A y AWS-02B comparten la misma infraestructura web pero tienen diferentes objetivos y flags.*

---

## 🎯 Categorías de Desafíos

- **Cloud Security:** Misconfigurations y vulnerabilidades en servicios cloud
- **Identity & Access:** IAM, Service Principals, credenciales expuestas
- **Web Security:** Aplicaciones web con vulnerabilidades
- **Mobile Security:** Análisis y reverse engineering de apps móviles
- **Container Security:** Kubernetes, Docker, Registry vulnerabilities
- **Cryptography:** Certificados, keys, y secretos mal gestionados

---

## 📖 Estructura del Proyecto

```
ctf-25/
├── terraform/
│   ├── modules/                    # Módulos Terraform reutilizables
│   │   ├── aws/
│   │   ├── azure/
│   │   └── gcp/
│   ├── environments/               # Configuraciones por ambiente
│   │   └── dev/
│   ├── backend-configs/            # Configuración de estados remotos
│   └── challenges/                 # Infraestructura de cada reto
│       ├── challenge-01-aws-only/
│       ├── challenge-01-azure-only/
│       ├── challenge-01-gcp-only/
│       └── ...
├── web-content/                    # Contenido web estático
├── scripts/                        # Scripts de despliegue
└── docs/                           # Documentación técnica
```

---

## 🚀 Para Participantes

### Cómo Participar

1. **Regístrate** en la plataforma CTFd
2. **Selecciona un desafío** de la lista disponible
3. **Lee cuidadosamente** la descripción y recursos proporcionados
4. **Investiga y explota** las vulnerabilidades
5. **Encuentra la flag** y envíala en el formato correcto
6. **Gana puntos** y sube en el ranking

### Reglas Generales

- ✅ Se permite el uso de cualquier herramienta de pentesting
- ✅ Puedes colaborar y discutir en los canales oficiales
- ✅ Consulta las pistas disponibles si te quedas atascado
- ❌ No realices ataques DDoS o de fuerza bruta excesiva
- ❌ No compartas flags completas públicamente
- ❌ No intentes acceder a infraestructura fuera del scope

### Recursos Útiles

- **AWS CLI:** https://aws.amazon.com/cli/
- **Azure CLI:** https://docs.microsoft.com/en-us/cli/azure/
- **Google Cloud SDK:** https://cloud.google.com/sdk
- **Burp Suite:** https://portswigger.net/burp
- **Postman:** https://www.postman.com/

---

## 🛠️ Para Organizadores

### Prerequisites
- Terraform >= 1.5.0
- AWS CLI configured
- Azure CLI configured
- Google Cloud SDK configured

### Authentication Setup
See [Authentication Guide](docs/authentication.md) for detailed setup instructions.

### Deployment
```bash
# Navigate to specific challenge (example with AWS)
cd terraform/challenges/challenge-01-aws-only

# Initialize Terraform
terraform init -backend-config=../../backend-configs/s3.hcl

# Plan deployment
terraform plan

# Apply changes
terraform apply
```

### Challenge Management

Cada desafío incluye:
- **README.md:** Documentación técnica para organizadores
- **SOLUTION.md:** Solución completa paso a paso
- **terraform.tfvars.example:** Configuración de ejemplo
- **outputs.tf:** Información generada para participantes

---

## 📞 Soporte

- **Discord:** [Enlace al servidor]
- **Email:** ctf@ekocloudsec.com
- **Twitter:** @EkoCloudSec

---

## 📝 Licencia

Este proyecto es creado con fines educativos por EkoCloudSec.

⚠️ **ADVERTENCIA:** Los desafíos contienen vulnerabilidades intencionales. No desplegar en ambientes de producción.