---
title: Otras Arquitecturas
description: Apuntes varios
--- 

## Otras Arquitecturas o Patrones menos utilizados

| Patrón         | Usarlo cuando...                                              |
| -------------- | ------------------------------------------------------------- | 
| MVC            | Buscas una estructura tradicional y clara.                    |
| Hexagonal      | Quieres desacoplar la lógica del framework e infraestructura. |


## 📌 Hexagonal Architecture (Arquitectura Hexagonal)

Por qué después de CQRS: Este patrón te ayuda a desacoplar completamente la lógica de negocio del resto de la infraestructura (bases de datos, servicios externos, etc.). Es perfecto cuando estás listo para escalar y hacer la aplicación más flexible.
Lo que aprenderás: A aislar la lógica de negocio de las interacciones con bases de datos, APIs o cualquier infraestructura externa.
¿Cómo se usa? Crear puertos (interfaces) que definen las operaciones del negocio, y adaptadores que implementan esas interfaces.
Primer paso práctico: Definir puertos y adaptadores para manejar acceso a bases de datos y servicios externos.

___


## 2. Básicas - Conocidas para principiantes

Arquitecturas estructurales y patrones comunes en aplicaciones tradicionales.

Monolithic - (Estructural) Aplicación unificada.
Client-Server - (Distribuida) Comunicación entre cliente y servidor.
MVC - (Patrón de diseño, no arquitectura en sí) Organiza código en Model, View y Controller.
Layered - (Estructural) Divide el sistema en capas separadas.
Observación: MVC no es una arquitectura completa, sino un patrón de diseño usado dentro de arquitecturas como Monolithic y Layered.
 

## 📌 3. MVC (Model-View-Controller)

Por qué después de modular y repositorio: El patrón MVC es un patrón clásico y muy usado. Aunque NestJS no implementa un MVC estricto, sus controladores y servicios siguen este principio.
Lo que aprenderás: Separar claramente las responsabilidades: el controlador maneja las solicitudes HTTP, el servicio implementa la lógica de negocio, y el modelo representa la entidad.
¿Cómo se usa? Definir controladores que reciban las solicitudes, servicios que manejen la lógica, y modelos para las entidades.
Primer paso práctico: Crear controladores para exponer rutas y métodos de servicio.

## Capas y Arquitectura de Software

📌 Modelos que organizan la estructura del software en capas o niveles.

N-tier Architecture (Arquitectura en N Capas)
📌 División de una aplicación en múltiples capas lógicas para modularización.
🔗 Relacionado con Layered Architecture y Client-Server.
🚀 Puede incluir capas como presentación (UI), lógica de negocio, acceso a datos y base de datos.
✅ Ejemplo:
3-tier (3 capas): Frontend (React) → Backend (Node.js) → Base de datos (MySQL).
N-tier: Agrega más capas como autenticación, caché, API Gateway.

https://www.karanpratapsingh.com/courses/system-design/n-tier-architecture


___
___
___



## 3. Otras no comunes - Poco relevantes para mi uso

Arquitecturas especializadas o menos populares en tu contexto.

- Pipe-and-Filter - Procesamiento en etapas (ej. compiladores).
- Peer to Peer (P2P) - (Distribuida) Comunicación descentralizada.
- Component-Based - (Estructural) Aplicaciones modulares con componentes reutilizables.
- Blackboard - Compartición de datos en entornos dinámicos (IA).
- Microkernel - Núcleo mínimo con extensiones (ej. sistemas operativos).
- SOA (Service-Oriented Architecture) - Antecesor de Microservices, menos ágil.
- Domain-Driven Design (DDD) - Más una metodología que una arquitectura.
- Observación: Algunas de estas pueden usarse en combinación con las más comunes (ej. Event Sourcing con CQRS).