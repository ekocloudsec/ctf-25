# Challenge 05 - Mobile Security

## 🏥 MediCloudX Health Manager

Bienvenido al análisis de seguridad de MediCloudX Health Manager, una aplicación móvil Android diseñada para profesionales de la salud.

## 📱 Descripción del Challenge

MediCloudX Health Manager es una aplicación Android empresarial para la gestión integral de pacientes y registros médicos. La aplicación utiliza tecnologías modernas de Firebase para la sincronización de datos y configuración dinámica.

### Características de la Aplicación

- **Gestión de Pacientes**: Sistema completo de registro y seguimiento de pacientes
- **Autenticación Segura**: Login con credenciales médicas validadas
- **Sincronización en Tiempo Real**: Integración con Firebase Firestore
- **Configuración Dinámica**: Parámetros ajustables via Firebase
- **Interfaz Médica Profesional**: Diseño optimizado para profesionales de la salud
- **Cumplimiento HIPAA**: Arquitectura diseñada para el manejo seguro de datos médicos

## 🎯 Objetivo

Analiza la aplicación móvil MediCloudX Health Manager para identificar vulnerabilidades de configuración y encontrar información sensible que pueda estar expuesta.

## 🚀 Inicio Rápido

### 1. Descarga la Aplicación

La aplicación Android se encuentra disponible en el directorio `android-project/` como proyecto compilable, o puedes usar el APK precompilado si está disponible.

### 2. Herramientas Recomendadas

- **Android Studio** con APK Analyzer
- **jadx** (Java Decompiler)
- **aapt** (Android Asset Packaging Tool)
- **curl** para llamadas API REST
- **Herramientas de análisis estático**

### 3. Análisis Inicial

```bash
# Si tienes el APK
aapt dump badging medicloudx-health-manager.apk
jadx -d output_folder medicloudx-health-manager.apk

# O analiza el proyecto Android directamente
cd android-project/app/src/main/res/values/
cat strings.xml
```

## 🔍 Puntos de Análisis

- **Configuraciones embebidas**: Archivos de recursos y strings
- **Servicios en la Nube**: Integración con servicios Firebase
- **Configuraciones de API**: Credenciales y tokens de acceso
- **Gestión de Datos**: Estructura de base de datos y parámetros administrativos

## 📋 Información Técnica

### Especificaciones de la App

- **Nombre del Paquete**: `com.medicloudx.healthmanager`
- **Versión**: 1.0.0
- **SDK Mínimo**: Android 7.0 (API 24)
- **Servicios**: Firebase Auth, Firestore, Remote Config

## 🎖️ Criterios de Éxito

Para completar exitosamente este challenge, deberás:

1. ✅ **Analizar** la estructura del APK/proyecto y identificar componentes clave
2. ✅ **Extraer** configuraciones y credenciales embebidas
3. ✅ **Acceder** a servicios de backend utilizando información extraída
4. ✅ **Localizar** la información objetivo del challenge

## 🏆 Recursos Adicionales

### Credenciales de Prueba (para testing funcional)

La aplicación incluye credenciales predefinidas para pruebas de funcionalidad:

- Email: `dr.martinez@medicloudx.com`
- Password: `MediCloud2024!`

*Nota: Estas credenciales son únicamente para verificar el funcionamiento de la aplicación*

---

**MediCloudX Corporation © 2024**  
*Desarrollo de Soluciones de Salud Digital*
