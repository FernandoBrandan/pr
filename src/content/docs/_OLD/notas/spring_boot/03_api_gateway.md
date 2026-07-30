---
title: Api Gateway
description: Api Gateway
---

## Proyecto Api Gateway
- Dependencias:
  - Spring Cloud Gateway 
  - Spring Cloud Starter Netflix Eureka Client

## Configuración de proyecto


```
Project: API Gateway
File: /src/main/resources/application.properties
_______________________________________________________________________
+ spring.application.name=api-gateway
+ spring.cloud.gateway.discovery.enabled=true
+ eureka.instance.instance-id=${spring.application.name}:${random.uuid}
+ spring.cloud.loadbalancer.ribbon.enabled=false

+ spring.cloud.gateway.routes[0].id=ms-cliente
+ spring.cloud.gateway.routes[0].uri=lb://ms-cliente
+ spring.cloud.gateway.routes[0].predicates[0]=Path=/ms-cliente/**
```

```
Project: API Gateway
File: /src/main/java/com/api/Application.java
_______________________________________________________________________
+ @EnableEurekaServer
```

