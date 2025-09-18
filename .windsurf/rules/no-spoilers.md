---
trigger: always_on
---

# Regla de No-Spoilers en Challenges

## 1. Prohibición de Spoilers
- Está estrictamente prohibido revelar en cualquier parte del reto (descripción, archivos adjuntos, código fuente, infraestructura, metadata, etc.) información que constituya un **spoiler**.  
- Esto incluye, pero no se limita a:  
  - Comentarios que indiquen la existencia de una vulnerabilidad.  
  - Frases como *"aquí hay un bug"*, *"fíjate en esta función"*, *"este archivo es clave"*, etc.  
  - Guías o explicaciones parciales del flujo de explotación.  
  - Pistas que faciliten directamente la obtención de la flag.  

## 2. Contenido Permitido
La descripción del reto debe limitarse a:  
- Contexto narrativo (historia, escenario, empresa ficticia (MediCloudX) etc.).  
- Instrucciones operativas (cómo acceder al entorno, credenciales iniciales si aplica, reglas de interacción).  
- Objetivo claro (ejemplo: *"obtén la flag en `/root/flag.txt`"*).  

## 3. Contenido Prohibido
- No incluir *hints*, *walkthroughs* ni referencias a la vulnerabilidad usada.  
- No mencionar el tipo de vector esperado (ejemplo: SQLi, RCE, XXE, etc.).  
- No agregar comentarios en el código fuente que sugieran pasos de explotación.  

## 4. Ejemplo Incorrecto
# Archivo vulnerable, cuidado aquí!
# Hay una inyeccion que permite obtener la flag

## 5. Ejemplo Correcto
# Bienvenido al sistema financiero de MediCloudX.
# Tu objetivo es encontrar la manera de acceder a la flag en /home/flag.txt