---
title: Configuración centralizada
description: Configuración centralizada
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
 