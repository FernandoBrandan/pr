## 1. Introducción a Microservicios

[link](https://aws.amazon.com/es/architecture/well-architected/?wa-lens-whitepapers.sort-by=item.additionalFields.sortDate&wa-lens-whitepapers.sort-order=desc&wa-guidance-whitepapers.sort-by=item.additionalFields.sortDate&wa-guidance-whitepapers.sort-order=desc)

- Beneficios: Escalabilidad, resiliencia, ciclos de desarrollo acelerados, y flexibilidad para innovar.
- No es una solución universal: evaluar frente a arquitecturas monolíticas según complejidad, escala y casos de uso.
- Combina principios de desarrollo ágil, CI/CD, diseño API-first y patrones de Twelve-Factor App.

## 2. Arquitectura de Microservicios en AWS

Interfaz de usuario: Uso de S3 y CloudFront para contenido estático, y API Gateway (REST/GraphQL).

- Microservicios:
  - Implementación:
    - Contenedores: Amazon ECS (simplicidad), Amazon EKS (Kubernetes gestionado), y AWS Fargate (serverless para contenedores).
    - Serverless: AWS Lambda (sin gestión de infraestructura, escalado automático).
  - Almacenamiento de datos:
    - Bases relacionales (Amazon Aurora, RDS) y NoSQL (DynamoDB para escalabilidad y latencia baja).
    - Cachés: Amazon ElastiCache (Redis/Memcached).
  - Redes privadas: AWS PrivateLink para tráfico seguro sin exposición a internet.
  - CI/CD: Herramientas como AWS CodePipeline y CodeDeploy para automatización (detalles en otros whitepapers).

## 3. Arquitecturas Serverless

- Ventajas:
  - Sin gestión de infraestructura, escalado automático, alta disponibilidad integrada y modelo de pago por uso.
  - Servicios clave:
    - Lambda + API Gateway para lógica de negocio.
    - Fargate para contenedores sin servidores.
    - Aurora Serverless para bases de datos autoajustables.
- Novedades:
  - Respuestas en streaming de Lambda (mejora latencia en aplicaciones web/móviles).

## 4. Gestión de Sistemas Distribuidos

- Descubrimiento de servicios:
  - AWS Cloud Map, ECS Service Discovery, o Route 53.
  - Para sistemas complejos: Amazon VPC Lattice (gestión de políticas y monitoreo).
- Datos distribuidos:
  - Consistencia eventual: Preferida sobre consistencia inmediata para escalabilidad.
  - Patrones clave:
    - Saga: Coordina transacciones distribuidas con compensación (usando Step Functions).
    - Event Sourcing + CQRS: Registro de eventos en Kinesis Data Streams/S3 y separación de lecturas/escrituras.
- Configuración y secretos:
  - AWS AppConfig para gestión dinámica de configuraciones.
  - Secrets Manager/Parameter Store para credenciales seguras.

## 5. Comunicación entre Microservicios

- Síncrona:
  - REST (API Gateway), GraphQL (AppSync), gRPC (eficiencia con HTTP/2).
- Asíncrona:
  - Colas (SQS), pub/sub (SNS/EventBridge), y streaming (Kinesis/MSK).
- Optimización:
  - Cachés (ElastiCache, API Gateway) para reducir latencia.
  - Evitar "chattiness" con gRPC (múltiples requests en una conexión) o revisión del modelo de dominio.

## 6. Observabilidad y Monitoreo

- Monitoreo: CloudWatch (métricas personalizadas), Container Insights (para contenedores), Prometheus/Grafana (EKS).
- Trazado distribuido: AWS X-Ray para seguimiento de solicitudes.
- Centralización de logs: CloudWatch Logs, OpenSearch (análisis con Kibana), y Redshift/QuickSight para BI.
- Auditoría: CloudTrail (registro de API calls) y AWS Config (cumplimiento de políticas).

## 7. Optimización de Costos y Sostenibilidad

- Estrategias:
  - Escalado granular (solo servicios necesarios).
  - Uso de Spot Instances (para cargas tolerantes a interrupciones).
  - Graviton (instancias ARM eficientes).
- Sostenibilidad:
  - Monitoreo de huella de carbono con AWS Customer Carbon Footprint Tool.
