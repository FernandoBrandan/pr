---
title: Aws
description: Aws
---

- Microservicios desacoplados,
- Arquitecturas event-driven en AWS
- Serverless
- Mensajería asíncrona
- Orquestación de flujos de trabajo
- IaC
- Bases de datos NoSQL/SQL
- Patrones CQRS/Event Sourcing
- Seguridad con API Gateway

1. Comenzarás instalando y familiarizándote con la consola, la CLI y el modelo de responsabilidad compartida de AWS.
2. Luego avanzarás a computación serverless con Lambda, mensajería con SQS y SNS, y al diseño de arquitecturas orientadas a eventos.
3. Después profundizarás en Step Functions para orquestación, CloudFormation para IaC, DynamoDB y RDS para modelado de datos, y patrones avanzados como CQRS y event sourcing.
4. Finalmente, integrarás API Gateway con JWT e IAM y consolidarás todo mediante proyectos prácticos y certificaciones.

## 1. AWS

- Según la función:
  - [Arquitectura](https://aws.amazon.com/es/training/learn-about/architect/?la=sec&sec=role)
  - [Desarrollador](https://aws.amazon.com/es/training/learn-about/developer/?la=sec&sec=role)
- Según la solución:
  - [Bases de datos](https://aws.amazon.com/es/training/learn-about/databases/?la=sec&sec=solution)
  - [Serverless](https://aws.amazon.com/es/training/learn-about/serverless/)
  - [Almacenamiento](https://aws.amazon.com/es/training/learn-about/storage/?la=sec&sec=solution)
- MS: [Link](https://docs.aws.amazon.com/whitepapers/latest/microservices-on-aws/microservices-on-aws.html)

## 2. Compute Serverless con AWS Lambda

- Estudia el Getting Started with AWS Lambda y haz el tutorial de crear una función básica con Node.js. [Amazon Web Services, Inc.](https://aws.amazon.com/es/lambda/getting-started/)
- Enlaza tu función con API Gateway para exponer endpoints HTTP (Path 2 en el tutorial)
- Profundiza en optimización de tiempos de ejecución (bundle, layers) y gestión de errores con handlers y Dead Letter Queues.

## 3. Mensajería Asíncrona: SQS y SNS

- Configura colas Standard y FIFO en SQS: revisa ejemplos de envío/recepción de mensajes con Boto3 o AWS SDK. [Medium](https://medium.com/analytics-vidhya/how-to-use-aws-sns-and-sqs-528c485db051)
- Crea topics en SNS y suscribe colas SQS o endpoints HTTP para decoupling completo de productores y consumidores.
- Practica patrones de pub/sub y fan‑out para notificaciones y pipelines de eventos.

## 4. Arquitectura Orientada a Eventos

- Lee la guía oficial de Event-Driven Architecture para comprender productores, routers y consumidores. [Amazon Web Services, Inc.](https://aws.amazon.com/es/event-driven-architecture/)
- Aplica EDA en microservicios desacoplados: produce eventos desde Lambda y enrútalos con Amazon EventBridge.

## 5. Orquestación de Flujos de Trabajo con Step Functions

- Sigue el tutorial Getting Started with AWS Step Functions para crear tu primer state machine síncrono y asíncrono. [AWS Documentation](https://docs.aws.amazon.com/step-functions/latest/dg/getting-started.html)
- Implementa flujos que combinen tareas Lambda, retardos (Wait), retry y manejo de errores (Catch).
- Escala a patrones de Saga para transacciones distribuidas.

## 6. Infraestructura como Código: CloudFormation

- Inicia con Getting Started with AWS CloudFormation y despliega stacks desde plantillas YAML/JSON. [Amazon Web Services, Inc.](https://aws.amazon.com/es/cloudformation/getting-started/)
- Versiona tus plantillas en un repositorio Git y usa módulos/macro para reutilizar recursos.
- Explora StackSets para despliegues multi–cuenta y drift detection.

## 7. Bases de Datos: DynamoDB y RDS

- 7.1. DynamoDB (NoSQL)
  - Haz el curso Introduction to Amazon DynamoDB y el tutorial de CRUD con la consola y SDK. [Amazon Web Services, Inc.](https://aws.amazon.com/es/dynamodb/getting-started/)
  - Diseña esquemas con single-table design y atributos compuestos para consultas eficientes.
- 7.2. Amazon RDS (SQL)
  - Despliega un cluster RDS (MySQL/PostgreSQL) y configura VPC, subnets y grupos de seguridad.
  - Practica migraciones sencillas y backups automáticos.

## 8. Patrones Avanzados: CQRS y Event Sourcing

- Lee el patrón CQRS para separar comandos de consultas y optimizar rendimiento y consistencia. [AWS Documentation](https://docs.aws.amazon.com/prescriptive-guidance/latest/modernization-data-persistence/cqrs-pattern.html)
- Implementa Event Sourcing almacenando cada cambio de estado como evento en un store dedicado. [AWS Documentation](https://docs.aws.amazon.com/prescriptive-guidance/latest/modernization-data-persistence/service-per-team.html)
- Conecta tus eventos con microservicios de lectura/escritura desacoplados usando SNS/SQS.

## 9. API Gateway, Seguridad y Autenticación

- Aprende a crear REST y HTTP APIs en Amazon API Gateway, integrándolas con Lambda y VPC links. [AWS Documentation](https://docs.aws.amazon.com/apigateway/latest/developerguide/http-api-jwt-authorizer.html)
- Configura JWT Authorizers para validar tokens de Cognito u otros Identity Providers. [AWS Documentation](https://docs.aws.amazon.com/apigateway/latest/developerguide/http-api-jwt-authorizer.html)
- Explora el uso de IAM Roles y políticas afinadas para granularidad de acceso. [AWS Documentation](https://docs.aws.amazon.com/apigateway/latest/developerguide/security_iam_service-with-iam.html)

## 10. Práctica, Proyectos y Certificación

- Construye un proyecto final: un sistema de gestión de inventarios con microservicios Lambda, SQS, Step Functions, y DynamoDB/RDS.
- Usa CloudFormation para desplegar todo como IaC.
- Prepara la certificación AWS Certified Solutions Architect – Associate o Developer – Associate siguiendo el AWS Learning Plan. [Amazon Web Services, Inc.](https://aws.amazon.com/es/training/learn-about/architect/)

## Siguiente paso: Asigna tiempos semanales a cada módulo, realiza laboratorios Hands‑On en AWS Skill Builder y comparte tus avances en GitHub para recibir feedback.

## [Link AWS Documentation](https://docs.aws.amazon.com/)

## [Link JS](https://docs.aws.amazon.com/sdk-for-javascript/v3/developer-guide/welcome.html)

## [Link Node](https://docs.aws.amazon.com/sdk-for-javascript/v3/developer-guide/getting-started-nodejs.html)

## [Link Tools](https://aws.amazon.com/es/developer/tools/)

- [IAM](https://docs.aws.amazon.com/sdk-for-javascript/v2/developer-guide/iam-examples.html)
  gestión de identidades y permisos, para asegurar credenciales y roles adecuados en tus aplicaciones
- [Almacenamiento S3](https://jsonworld.com/blog/most-common-aws-services-a-nodejs-developer-should-know)
- [EC2 y Elastic Beanstalk](https://stackoverflow.com/questions/66156246/what-aws-services-can-i-use-to-deploy-node-js-app)

Tras desplegar servidores, explorar arquitecturas serverless con AWS Lambda y Amazon API Gateway permite ejecutar código sin gestionar infraestructuras

- [Infraestructuras](https://medium.com/%40interviewer.live/how-to-use-aws-services-with-node-js-for-scalable-web-applications-4927c2efc561)
- DynamoDB (NoSQL)
- RDS (SQL)
- Monitorización y logging [CloudWatch](https://docs.aws.amazon.com/sdk-for-javascript/v2/developer-guide/cloudwatch-examples.html)
- Servicios de mensajería como SQS y SNS
  - [SQS](https://docs.aws.amazon.com/sdk-for-javascript/v2/developer-guide/sqs-examples.html)
  - [SNS](https://docs.aws.amazon.com/sdk-for-javascript/v2/developer-guide/sns-examples-publishing-messages.html)

## Siguiente Paso

- explora arquitecturas avanzadas:
  - EventBridge (event bus)
  - Step Functions (orquestación serverless)
  - Cognito (auth)
  - CDK/Serverless Framework para Infraestructura como Código
