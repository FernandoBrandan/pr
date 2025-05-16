---
title: "Relaciones"
description: "Relaciones entre Patrones y Arquitecturas de Software"
--- 

# Relaciones entre Patrones y Arquitecturas de Software

## Arquitecturas Tradicionales
| **Patrón/Arquitectura** | **Relaciones Clave**		  | **Características**                                   | **Casos de Uso**                             |
|-------------------------|-------------------------------|-------------------------------------------------------|----------------------------------------------|
| **Monolithic**           | Base para MVC, Layered       | Un solo despliegue, fácil desarrollo inicial  		  | Aplicaciones pequeñas, MVP                   |
| **MVC**                  | Usado en Monolithic, Layered | Separa Modelo-Vista-Controlador                       | Web apps tradicionales                       |
| **Layered/N-tier**       | Combina con MVC, Repository  | Capas separadas (UI, negocio, datos)                  | Sistemas empresariales complejos             |

---

## Arquitecturas Distribuidas
| **Patrón/Arquitectura** | **Relaciones Clave**                          | **Características**                                   | **Casos de Uso**                             |
|-------------------------|-----------------------------------------------|-------------------------------------------------------|----------------------------------------------|
| **Microservicios**       | Combina con EDA, CQRS, Event Sourcing        | Servicios independientes, escalabilidad horizontal    | Plataformas escalables (e-commerce, SaaS)    |
| **Client-Server**        | Base para API REST, N-tier                   | Separación clara cliente/servidor                     | Apps móviles, Banca en línea                 |

---

## Patrones de Diseño
| **Patrón**              | **Relaciones Clave**                          | **Características**                                   | **Casos de Uso**                             |
|-------------------------|-----------------------------------------------|-------------------------------------------------------|----------------------------------------------|
| **Repository**          | Usado en MVC, Hexagonal                       | Desacopla acceso a datos                              | Cambios de base de datos                     |
| **CQRS**                | Combina con Event Sourcing, Microservicios    | Separa lectura/escritura                              | Sistemas con alta concurrencia               |
| **Hexagonal**           | Combina con EDA, Repository                   | Aísla lógica de negocio de infraestructura            | Apps mantenibles a largo plazo               |

---

## Sistemas de Mensajería
| **Concepto**            | **Relaciones Clave**                          | **Características**                                   | **Casos de Uso**                             |
|-------------------------|-----------------------------------------------|-------------------------------------------------------|----------------------------------------------|
| **Message Queues**       | Base para MDA, Microservicios                | Entrega garantizada, modelo productor-consumidor      | Procesamiento de órdenes, notificaciones     |
| **Streams**             | Usado en EDA, Event Sourcing                  | Procesamiento en tiempo real, retención de datos      | Análisis de logs, IoT                        |
| **Pub/Sub**             | Combina con EDA, Microservicios               | Múltiples suscriptores, desacoplamiento               | Notificaciones en tiempo real                |
| **Message Broker**       | Central para MDA, EDA                        | Enrutamiento complejo, garantías de entrega           | Sistemas financieros, telecomunicaciones     |

---

## Arquitecturas Basadas en Eventos
| **Arquitectura**         | **Relaciones Clave**                         | **Características**                                   | **Casos de Uso**                             |
|-------------------------|-----------------------------------------------|-------------------------------------------------------|----------------------------------------------|
| **EDA**                 | Combina con Microservicios, CQRS              | Reactividad en tiempo real, escalabilidad masiva      | Plataformas de trading, redes sociales       |
| **Event Sourcing**      | Usado con CQRS, Hexagonal                     | Reconstrucción histórica de estados                   | Sistemas de auditoría, banca                 |
| **MDA**                 | Base para sistemas empresariales              | Comunicación asíncrona, desacoplamiento               | Integración de sistemas legacy               |

---

## Combinaciones Comunes
| **Combinación**                | **Ventajas**                                      | **Ejemplo de Uso**                              |
|--------------------------------|---------------------------------------------------|-------------------------------------------------|
| **Microservicios + EDA**       | Escalabilidad, reactividad en tiempo real         | Plataforma de e-commerce con notificaciones     |
| **CQRS + Event Sourcing**      | Trazabilidad completa, optimización de consultas  | Sistema bancario con auditoría detallada        |
| **Hexagonal + Repository**     | Independencia de DB, fácil mantenimiento          | Migración de SQL a NoSQL en apps empresariales  |
| **MVC + Modular**              | Organización clara, fácil escalabilidad inicial   | Startups en fase de crecimiento                 |
| **Serverless + Event-Driven**  | Costo eficiente, escalado automático              | Procesamiento de imágenes/videos bajo demanda   |

---

## Tecnologías Clave por Dominio
| **Dominio**              | **Tecnologías Representativas**                              |
|--------------------------|---------------------------------------------------------------|
| **Mensajería**           | Kafka, RabbitMQ, AWS SNS/SQS                                  |
| **Orquestación**         | Kubernetes, Docker Swarm, AWS ECS                             |
| **Bases de Datos**       | PostgreSQL, MongoDB, Cassandra                                |
| **Monitoreo**            | Prometheus, Grafana, New Relic                                |
| **Autenticación**        | Auth0, Keycloak, AWS Cognito                                  |