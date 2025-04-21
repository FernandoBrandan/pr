---
title: Relaciones
description: Apuntes varios
--- 

# Relaciones entre Patrones y Arquitecturas de Software

## 🏛️ Arquitecturas Tradicionales
| **Patrón/Arquitectura** | **Relaciones Clave**                          | **Tecnologías**       | **Características**                                   | **Casos de Uso**                             |
|-------------------------|-----------------------------------------------|-----------------------|-------------------------------------------------------|----------------------------------------------|
| **Monolithic**           | Base para MVC, Layered                        | Express, Django       | Todo en un solo despliegue, fácil desarrollo inicial  | Aplicaciones pequeñas, MVP                   |
| **MVC**                  | Usado en Monolithic, Layered                  | Spring, Rails         | Separa Modelo-Vista-Controlador                       | Web apps tradicionales                       |
| **Layered/N-tier**       | Combina con MVC, Repository                   | .NET, Java EE         | Capas separadas (UI, negocio, datos)                  | Sistemas empresariales complejos             |

---

## 🌐 Arquitecturas Distribuidas
| **Patrón/Arquitectura** | **Relaciones Clave**                          | **Tecnologías**       | **Características**                                   | **Casos de Uso**                             |
|-------------------------|-----------------------------------------------|-----------------------|-------------------------------------------------------|----------------------------------------------|
| **Microservicios**       | Combina con EDA, CQRS, Event Sourcing         | Docker, Kubernetes    | Servicios independientes, escalabilidad horizontal    | Plataformas escalables (e-commerce, SaaS)    |
| **Client-Server**        | Base para API REST, N-tier                    | Node.js, MySQL        | Separación clara cliente/servidor                     | Apps móviles, Banca en línea                 |

---

## 🧩 Patrones de Diseño
| **Patrón**              | **Relaciones Clave**                          | **Tecnologías**       | **Características**                                   | **Casos de Uso**                             |
|-------------------------|-----------------------------------------------|-----------------------|-------------------------------------------------------|----------------------------------------------|
| **Repository**          | Usado en MVC, Hexagonal                       | TypeORM, Hibernate    | Desacopla acceso a datos                              | Cambios de base de datos                     |
| **CQRS**                | Combina con Event Sourcing, Microservicios    | Axon, Kafka           | Separa lectura/escritura                              | Sistemas con alta concurrencia               |
| **Hexagonal**           | Combina con EDA, Repository                   | NestJS, Spring Boot   | Aísla lógica de negocio de infraestructura            | Apps mantenibles a largo plazo               |

---

## 🚀 Sistemas de Mensajería
| **Concepto**            | **Relaciones Clave**                          | **Tecnologías**       | **Características**                                   | **Casos de Uso**                             |
|-------------------------|-----------------------------------------------|-----------------------|-------------------------------------------------------|----------------------------------------------|
| **Message Queues**       | Base para MDA, Microservicios                 | RabbitMQ, AWS SQS     | Entrega garantizada, modelo productor-consumidor      | Procesamiento de órdenes, notificaciones     |
| **Streams**             | Usado en EDA, Event Sourcing                  | Kafka, Apache Pulsar  | Procesamiento en tiempo real, retención de datos       | Análisis de logs, IoT                        |
| **Pub/Sub**             | Combina con EDA, Microservicios               | Redis, Google Pub/Sub | Múltiples suscriptores, desacoplamiento               | Notificaciones en tiempo real                |
| **Message Broker**       | Central para MDA, EDA                         | Kafka, RabbitMQ       | Enrutamiento complejo, garantías de entrega           | Sistemas financieros, telecomunicaciones     |

---

## ⚡ Arquitecturas Basadas en Eventos
| **Arquitectura**         | **Relaciones Clave**                          | **Tecnologías**       | **Características**                                   | **Casos de Uso**                             |
|-------------------------|-----------------------------------------------|-----------------------|-------------------------------------------------------|----------------------------------------------|
| **EDA**                 | Combina con Microservicios, CQRS              | Kafka, AWS EventBridge| Reactividad en tiempo real, escalabilidad masiva      | Plataformas de trading, redes sociales       |
| **Event Sourcing**      | Usado con CQRS, Hexagonal                     | EventStore, Kafka     | Reconstrucción histórica de estados                   | Sistemas de auditoría, banca                 |
| **MDA**                 | Base para sistemas empresariales              | RabbitMQ, ActiveMQ    | Comunicación asíncrona, desacoplamiento               | Integración de sistemas legacy               |

---

## 🔄 Combinaciones Comunes
| **Combinación**                | **Ventajas**                                      | **Ejemplo de Uso**                              |
|--------------------------------|---------------------------------------------------|-------------------------------------------------|
| **Microservicios + EDA**       | Escalabilidad, reactividad en tiempo real         | Plataforma de e-commerce con notificaciones     |
| **CQRS + Event Sourcing**      | Trazabilidad completa, optimización de consultas  | Sistema bancario con auditoría detallada        |
| **Hexagonal + Repository**     | Independencia de DB, fácil mantenimiento          | Migración de SQL a NoSQL en apps empresariales  |
| **MVC + Modular**              | Organización clara, fácil escalabilidad inicial   | Startups en fase de crecimiento                 |
| **Serverless + Event-Driven**  | Costo eficiente, escalado automático              | Procesamiento de imágenes/videos bajo demanda   |

---

## 🛠️ Tecnologías Clave por Dominio
| **Dominio**              | **Tecnologías Representativas**                              |
|--------------------------|---------------------------------------------------------------|
| **Mensajería**           | Kafka, RabbitMQ, AWS SNS/SQS                                  |
| **Orquestación**         | Kubernetes, Docker Swarm, AWS ECS                             |
| **Bases de Datos**       | PostgreSQL, MongoDB, Cassandra                                |
| **Monitoreo**            | Prometheus, Grafana, New Relic                                |
| **Autenticación**        | Auth0, Keycloak, AWS Cognito                                  |