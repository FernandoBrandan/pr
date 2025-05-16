---
title: MDA, EDA, Event Sourcing
description: Apuntes varios
--- 

- Message-Driven Architecture (MDA) - Event-Driven Architecture (EDA) - Event Sourcing
- Son enfoques avanzados en sistemas distribuidos que aprovechan el procesamiento y la gestión de eventos o mensajes
- Están estrechamente vinculados con la idea de la mensajería porque todos hacen un uso extensivo de mensajes o eventos 
como forma de comunicación entre los distintos componentes del sistema. 


### Message-Driven Architecture (MDA)
- Es un estilo arquitectónico donde los componentes del sistema interactúan principalmente a través de mensajes. 
- Los componentes se comunican de manera asíncrona usando mensajes que pasan a través de colas o brokers.
 
### Event-Driven Architecture (EDA)
- Es un enfoque arquitectónico en el que los eventos (cambios o acciones significativas en el sistema) son la unidad central que desencadena la comunicación y el procesamiento de datos. 
- Los componentes reaccionan a eventos, lo que hace que este modelo sea ideal para sistemas altamente dinámicos, escalables y en tiempo real.
 
### Event Sourcing
- Es un patrón donde todos los cambios de estado del sistema son capturados como una secuencia de eventos inmutables. 
- En lugar de almacenar el estado actual de un sistema, se almacenan los eventos que modifican ese estado, y el estado final se puede reconstruir a partir de esos eventos.
- Este enfoque asegura que puedas reconstruir el estado del sistema en cualquier punto de la historia, lo que proporciona alta trazabilidad y fiabilidad.


## Los message brokers juegan un papel central en estos patrones:
- En MDA, los mensajes que viajan a través de un broker permiten una comunicación eficiente y desacoplada.
- En EDA, los eventos son transmitidos a través de un broker y los sistemas reaccionan a ellos en tiempo real.
- En Event Sourcing, los eventos se almacenan y se pueden transmitir a través de un broker para que otros servicios reaccionen a ellos, 
o incluso para que el sistema reconstruya el estado a partir de los eventos previos.

### Cuál es el más usado?
- Event-Driven Architecture (EDA): El más común en aplicaciones modernas que requieren escalabilidad y reactividad en tiempo real, como sistemas de notificaciones, procesamiento de pagos, análisis de datos en tiempo real, etc.
- Message-Driven Architecture (MDA): Se usa en sistemas distribuidos donde los servicios deben estar altamente desacoplados, y los mensajes se manejan mediante un broker central.
- Event Sourcing es más especializado y se utiliza en sistemas donde la trazabilidad, la reconstrucción del estado y la inmutabilidad son requisitos clave.

 