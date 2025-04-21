---
title: Otras Arquitectura 
description: Apuntes varios
--- 

## En algun proyecto debo usar CQRS o Event Sourcing

| Patrón         | Usarlo cuando...                                              |
| -------------- | ------------------------------------------------------------- | 
| CQRS           | Hay alta concurrencia y necesitas separar lectura/escritura.  |
| Event Sourcing | Necesitas un registro de cambios históricos para reconstrucción. |

## CQRS (Command Query Responsibility Segregation) 
- Un patrón que optimiza el rendimiento de microservicios.
- Separa comandos (escritura) de consultas (lectura).
– Se usa en aplicaciones que requieren escalabilidad y separación entre lectura/escritura, pero no siempre es necesario.

## Event Sourcing 
Modelo avanzado donde el estado de un sistema se reconstruye a partir de eventos históricos.
Registro de cambios en eventos en lugar de estado.

## Microservices + CQRS + Event Sourcing

- Ideal para sistemas de alto tráfico con requisitos de consistencia eventual.
- CQRS separa comandos (escritura) y consultas (lectura).
- Event Sourcing almacena eventos en lugar de estados.
- Se usa EDA para notificar cambios a otros servicios.

- Ejemplo:
  - Un usuario realiza una compra → Se genera un evento "PedidoRealizado".
  - Un servicio CQRS-Command escribe el evento en un log (Event Sourcing).
  - Un servicio CQRS-Query procesa los eventos y actualiza vistas optimizadas. 