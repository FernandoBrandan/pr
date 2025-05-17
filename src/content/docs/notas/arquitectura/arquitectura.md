---
title: Arquitectura Utilizadas
description: Apuntes varios
--- 

### **Modular** - **Repository** - **Microservicios** - **Event-Driven**

|                | Usarlo cuando...                                      |
| -------------- | ------------------------------------------------------| 
| Modular        | Mantener código organizado en módulos.                |
| Repository     | Desacoplar acceso a datos y facilitar cambios de DB.  |
| Microservicios | Necesitas escalabilidad y despliegue independiente.   |
| Event-Driven   | Requieres procesamiento asíncrono basado en eventos.  |

## Modular Pattern 

- Cómo estructurar tu código en módulos y mantenerlo organizado.
- Cada entidad o funcionalidad (como users, products, etc.) se organiza en su propio módulo.
 
## Repository Pattern 

Es importante separar el acceso a datos de la lógica de negocio. 
El Repository Pattern te ayuda a desacoplar estas capas.
Esto hace que tu código sea más limpio, escalable y fácil de modificar.
 
## Conceptos Fundamentales de Mensajería   

Message Queues and Streams 
Message Broker (RabbitMQ o Kafka): Gestionan la comunicación entre servicios.
Publish-Subscribe (Pub-Sub): Un modelo para comunicación en eventos. Un productor envía mensajes a múltiples suscriptores.

- Message Driven Architecture
  - Message-Driven Architecture (MDA) 
  - Explica cómo los sistemas pueden reaccionar a mensajes en lugar de solicitudes directas.
  - Comunicación basada en mensajes en lugar de llamadas directas.

- Event-Driven Architecture (EDA) 
  - Se basa en eventos para gestionar la lógica del sistema.
  - Reacciona a eventos en tiempo real.

## Event-Driven:
- Cuando ya tengas tu lógica desacoplada y la aplicación más madura
- Manejar comunicaciones asíncronas y procesar operaciones en paralelo.
- Usar eventos para comunicar diferentes partes de la aplicación sin acoplarlas directamente. 
- Es útil cuando manejas tareas largas o distribuidas.
- Enviar eventos cuando ocurren ciertos cambios (ej. un producto fue creado) y suscribirse a esos eventos en otras partes de la aplicación.
 
## Microservices  

Permiten escalar independientemente partes de la aplicación.
   
- API Gateway Pattern: Arquitecturas de ms, centraliza la entrada a las APIs, mejora la seguridad y la gestión de tráfico.
- Service Discovery Pattern: Clave en entornos de ms, permite a los servicios encontrar y comunicarse dinámicamente.
- Circuit Breaker Pattern: Evita fallos en cascada en sistemas distribuidos, mejora la resiliencia y disponibilidad.

## Fallos y resiliencia
- Retry Pattern: Esencial para manejar fallos transitorios en redes y servicios externos.
- Bulkhead Pattern: Mejora la estabilidad de sistemas al aislar recursos y prevenir sobrecarga en servicios críticos.
 
## Serverless 
Integrar mensajería con colas y eventos.
Funciones en la nube que escalan bajo demanda.

___
## Ejemplos

### Microservices + EDA + MDA + Pub-Sub
Arquitectura típica de sistemas modernos distribuidos
- Cada microservicio se comunica a través de eventos y mensajes.
- Se usa Pub-Sub para distribuir eventos a múltiples consumidores.
- MDA garantiza comunicación asíncrona entre microservicios.

Ejemplos:
- Un servicio de Pedidos emite un evento "Orden creada".
- Un servicio de Inventario consume el evento y actualiza el stock.
- Un servicio de Facturación recibe el evento y genera la factura.
- Tecnologías: Kafka, RabbitMQ, NATS, gRPC, WebSockets.

### Microservices + Message Queues + Pub-Sub

Evita pérdida de datos en sistemas de alta disponibilidad.
-  Message Queues garantizan entrega de eventos.
-  Pub-Sub distribuye mensajes a múltiples consumidores.
-  Se desacoplan servicios para mejorar escalabilidad.

Ejemplo:
- Un servicio de Pagos envía un mensaje a una cola de procesamiento.
- Un servicio de Facturación extrae el mensaje y genera la factura.
- Un servicio de Notificaciones escucha el mensaje y envía un correo al usuario.
- Tecnologías: RabbitMQ, AWS SQS, Apache Kafka.

### Serverless + Event-Driven + Message Queues -> Service Discovery

Para sistemas escalables sin servidores gestionados manualmente.
- Serverless permite ejecutar funciones bajo demanda.
- EDA gestiona eventos sin necesidad de servidores persistentes.
- Message Queues controlan la carga de trabajo.

Ejemplo:
- Un usuario sube una imagen a S3.
- Un evento "Imagen subida" activa una AWS Lambda.
- La función procesa la imagen y guarda los resultados en DynamoDB.
- Un evento "Proceso completado" notifica al usuario por correo.
- Tecnologías: AWS Lambda, Google Cloud Functions, Azure Functions, Firebase.


### Ejemplo Completo: Un E-commerce Moderno
- El usuario realiza una compra → Se genera un evento "Pedido Creado".
- EDA distribuye el evento → Servicios como Pagos, Inventario y Notificaciones reaccionan.
- CQRS procesa la compra → Comandos actualizan el estado, consultas optimizan reportes.
- Message Queues garantizan entrega → RabbitMQ o Kafka manejan la carga.
- Pub-Sub permite escalar → Facturación y Análisis reciben eventos en paralelo.
- Serverless maneja tareas puntuales → Una Lambda genera la factura en PDF.