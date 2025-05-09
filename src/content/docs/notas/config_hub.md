---
title: "Configuración centralizada"
description: "Configuración centralizada"
slug: "Configuración centralizada"
---

## Configuración Dinámica

- El microservicio no tiene su configuración embebida directamente, sino que la
  obtiene dinámicamente a través de un archivo como `getConfig`.
- Se obtienen puertos, nombres de servicio, credenciales o cualquier otro
  parámetro desde una fuente externa (Consul).
- Facilita la portabilidad y la modificación de parámetros sin necesidad de
  redeploy.

## Descubrimiento de Servicios

### Eureka Client

- Cada microservicio se registra en un **Eureka Server**, una herramienta de
  descubrimiento de servicios desarrollada por Netflix.
- Permite que otros servicios encuentren este microservicio sin necesidad de
  saber su dirección IP o puerto.
- Ideal para entornos donde los servicios se escalan dinámicamente o cambian de
  dirección frecuentemente.

**Rol del cliente:**

- Registrarse automáticamente al iniciar.
- Renovar su registro periódicamente mediante _heartbeats_.
- Descubrir a otros servicios registrados en Eureka si se necesita hacer
  llamadas salientes.

#### Consul

Consul también permite el descubrimiento y registro de servicios, y puede ser
utilizado como fuente de configuración remota.

**Características:**

- Clave-valor store.
- Health checks automáticos.
- Integración con múltiples lenguajes.

_Nota:_ Se puede usar **Consul solo para configuración**, solo para
descubrimiento, o para ambos roles.

https://microservices.io/microservices/news/2017/12/04/qconsf2017-presentation.html
https://microservices.io/microservices/news/2017/12/04/microservices-at-code-freeze.html
https://microservices.io/microservices/news/2017/08/01/data-patterns-presentation.html
https://microservices.io/microservices/news/2017/07/24/revised-data-patterns.html
https://microservices.io/microservices/news/2017/03/26/no-such-thing-as-a-microservice.html
https://microservices.io/microservices/news/ddd/2017/02/24/microservice-patterns-book.html
https://microservices.io/microservices/news/ddd/2017/02/12/how-to-apply-the-pattern-language.html
https://microservices.io/microservices/news/ddd/2016/06/06/eric-evans-ddd-microservices.html
https://microservices.io/microservices/news/2016/02/23/one-day-microservices-class.html
https://microservices.io/microservices/news/2016/02/21/microservice-chassis.html
https://microservices.io/microservices/news/2015/07/28/whats-new.html
https://microservices.io/microservices/news/2015/06/23/whats-new.html
https://microservices.io/microservices/news/2015/06/06/whats-new.html
https://microservices.io/microservices/news/2015/03/15/deployment-patterns.html
https://microservices.io/microservices/news/2015/03/01/service-discovery-patterns.html
https://microservices.io/microservices/news/2015/01/15/example-microservice-app.html
https://microservices.io/microservices/news/2014/11/02/spring-boot-cf-and-microservices-webinars.html
https://microservices.io/microservices/news/2014/09/08/apigateway-pattern.html
https://microservices.io/microservices/news/2014/05/12/whats-new.html
https://microservices.io/microservices/news/2014/04/07/whats-new.html
https://microservices.io/microservices/news/2014/03/31/whats-new.html
https://microservices.io/microservices/general/2014/03/18/welcome-to-microservices.html
