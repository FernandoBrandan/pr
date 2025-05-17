---
title: Event-Driven Architecture
description: Event-Driven Architecture (EDA)
--- 

____
https://medium.com/@diego.coder/introducci%C3%B3n-a-la-arquitectura-orientada-a-eventos-a532c71c9945

Trata sobre el uso de eventos como una forma de comunicarse dentro de un sistema. 
En general, aprovecha un agente de mensajes para publicar y consumir eventos de forma asincrónica. 
El editor no sabe quién está consumiendo un evento y los consumidores no se conocen. 
La arquitectura impulsada por eventos es simplemente una forma de lograr un acoplamiento suelto entre los servicios dentro de un sistema.

### ¿Qué es un evento?
- Un evento es un punto de datos que representa cambios de estado en un sistema. 
- No especifica qué debería suceder y cómo el cambio debería modificar el sistema, solo notifica el sistema de un cambio de estado particular.
- Cuando un usuario realiza una acción, desencadena un evento.

## Componentes
Productores de eventos: Publica un evento en el enrutador.
Enrutadores de eventos: Filtra y envía los eventos a los consumidores.
Consumidores de eventos: Utiliza los eventos para reflejar los cambios en el sistema.

## Patrones
- Sagas
- Publish-Subscribe
- Event Sourcing
- Command and Query Responsibility Segregation (CQRS)

## Ventajas

- Productores y consumidores desacoplados.
- Altamente escalable y distribuido.
- Fácil de agregar nuevos consumidores.
- Mejora la agilidad.

## Desafíos

- Entrega garantizada.
- El manejo de errores es difícil.
- Los sistemas basados en eventos son complejos en general.
- Exactamente una vez, procesamiento de eventos en orden.

## Usar casos

- Metadatos y métricas.
- Servidor y registros de seguridad.
- Integración de sistemas heterogéneos.
- Aventón y procesamiento paralelo.

## Ejemplos

- NATS
- Apache Kafka
- Amazon EventBridge
- Amazon SNS
- Google PubSub

___
 
  
Cuando se utiliza un enfoque síncrono, el productor tendría que esperar a que el consumidor procese el evento antes de pasar a la siguiente tarea. Por ejemplo, al reservar un hotel por Internet, el navegador esperaría a que el sistema completara la solicitud y devolviera un resultado antes de poder continuar.

El procesamiento síncrono proporciona una ruta de ejecución predecible para cada evento dado, lo que hace que sea mucho más sencillo de entender y depurar. Es necesario en escenarios donde una respuesta inmediata es crítica, como el procesamiento de transacciones financieras. Sin embargo, su naturaleza rígida lo hace incompatible con componentes que generan grandes cantidades de eventos o realizan operaciones de procesamiento que requieren mucho tiempo. El procesamiento síncrono limita la escalabilidad y la tolerancia a fallos del sistema, por lo que sólo debe reservarse para cuando sea absolutamente necesario.

Por otro lado, el procesamiento asíncrono no espera una respuesta. Los productores ponen en cola los eventos para que los procesen los consumidores y luego pasan a la siguiente tarea. Por ejemplo, publicar una actualización de estado en las redes sociales no requiere una acción inmediata. En su lugar, tus seguidores pueden ser notificados de forma asíncrona.

El procesamiento asíncrono es más común en la arquitectura basada en eventos porque promueve la escalabilidad, el acoplamiento flexible, la resistencia y la flexibilidad mejor que un enfoque síncrono. Es ideal en escenarios donde los eventos se generan con frecuencia y en grandes porciones, que es generalmente el caso de la mayoría de los sistemas construidos con un diseño dirigido por eventos. Las condiciones de carrera son el escollo más notable del procesamiento asíncrono, esto a menudo se resuelve mejor con colas bien diseñadas.

La arquitectura basada en eventos es una solución escalable y eficiente para sistemas que constan de muchos nodos o servicios y procesan grandes volúmenes de eventos. Promueve el acoplamiento flexible y ayuda a mantener el sistema flexible y fácil de mantener.

