
---
title: Message Queues
description: Message Queues
--- 

- Características clave:
  - Funciona como una estructura FIFO (First-In, First-Out).
  - Los mensajes se mantienen en la cola hasta que un consumidor los lee y los procesa.
  - Garantiza que cada mensaje sea procesado una sola vez por un único consumidor.
  - Usa patrones de comunicación Punto a Punto (P2P).
-  Ejemplo de uso:
  - En un sistema de procesamiento de pagos, un Message Queue puede almacenar transacciones en cola para ser procesadas una por una y evitar la sobrecarga del sistema.
- Ejemplo de tecnologías de Message Queue:
  - RabbitMQ (con colas AMQP)
  - Amazon SQS
  - ActiveMQ

___

Una Message Queues es una forma de comunicación de servicio a servicio que facilita la comunicación asíncrona. 
Recibe mensajes asíncronos de los productores y los envía a los consumidores.

Las colas se utilizan para gestionar eficazmente las solicitudes en sistemas distribuidos a gran escala. 
En sistemas pequeños con cargas de procesamiento mínimas y bases de datos pequeñas, las escrituras pueden ser previsiblemente rápidas. 
Sin embargo, en sistemas más complejos y grandes, las escrituras pueden tardar un tiempo casi indeterminado.

<Image src="https://www.karanpratapsingh.com/_next/image?url=%2Fstatic%2Fcourses%2Fsystem-design%2Fchapter-III%2Fmessage-queues%2Fmessage-queue.png&w=2048&q=75" />

## Working
Los mensajes se almacenan en la cola hasta que son procesados y eliminados. 
Cada mensaje es procesado una sola vez por un único consumidor. 

El funcionamiento es el siguiente:

- Un productor publica un trabajo en la cola y, a continuación, notifica al usuario el estado del trabajo.
- Un consumidor recoge el trabajo de la cola, lo procesa y, a continuación, señala que el trabajo se ha completado.

## Ventajas

- Escalabilidad 
- Desacoplamiento
- Rendimiento
- Fiabilidad

## Características

- __Push or Pull Delivery:__
  - Proporcionan opciones push y pull para recuperar mensajes. 
  - Pull significa consultar continuamente la cola para recibir nuevos mensajes. 
  - Push significa que un consumidor es notificado cuando hay un mensaje disponible. 
  - Podemos utilizar «long-polling» para que los pulls esperen un tiempo determinado a que lleguen nuevos mensajes.

- __FIFO (First-In-First-Out)__

- __Schedule or Delay Delivery:__
  - Admiten establecer un tiempo de entrega específico para un mensaje. 
  - Si necesitamos tener un retraso común para todos los mensajes, podemos configurar una cola de retraso.

- __At-Least-Once Delivery:__
Las Message Queues pueden almacenar múltiples copias de mensajes para redundancia y alta disponibilidad, y reenviar mensajes en caso de fallas o errores de comunicación para garantizar que se entreguen al menos una vez.

- __Exactly-Once Delivery:__
Cuando no se pueden tolerar duplicados, las colas de mensajes FIFO se asegurarán de que cada mensaje se entregue exactamente una vez filtrando duplicados automáticamente.

- __Dead-letter Queues:__
Una cola de letra muerta es una cola a la que otras colas pueden enviar mensajes que no se pueden procesar con éxito. 
Esto facilita dejarlos de lado para una inspección adicional sin bloquear el procesamiento de la cola o gastar los ciclos de la CPU en un mensaje que nunca podría consumirse con éxito.

- __Ordering:__
La mayoría de las colas de mensajes proporcionan el mejor orden de esfuerzo, lo que garantiza que los mensajes se entreguen generalmente en el mismo orden en que se envían y que se envíe un mensaje al menos una vez.

- __Poison-pill Messages:__
Las píldoras venenosas son mensajes especiales que se pueden recibir, pero no procesar. Son un mecanismo utilizado para indicar a un consumidor que finalice su trabajo para que ya no espere nuevas entradas y sean similares a cerrar un enchufe en un cliente/modelo de servidor.

- __Security:__
Las colas de mensajes autenticarán las aplicaciones que intentan acceder a la cola, esto nos permite cifrar mensajes a través de la red, así como en la cola misma.

- <mark>__Task Queues:__
  - Las colas de tareas reciben tareas y sus datos relacionados, los ejecutan y luego entregan sus resultados. 
  - Pueden admitir la programación y pueden usarse para ejecutar trabajos computacionalmente intensivos en el fondo.
  - https://docs.celeryq.dev/en/stable/

## Backpressure

- Si las colas comienzan a crecer significativamente, el tamaño de la cola puede ser mayor que la memoria, lo que resulta en fallas de caché, lecturas de disco e incluso un rendimiento más lento. 
- Backpressure puede ayudar limitando el tamaño de la cola, manteniendo así una alta tasa de rendimiento y buenos tiempos de respuesta para trabajos que ya están en la cola. 
- Una vez que la cola se llena, los clientes obtienen un servidor ocupado o un código de estado HTTP 503 para volver a intentarlo más tarde. 
- Los clientes pueden volver a intentar la solicitud más adelante, tal vez con respaldo exponencial estrategia.
- https://en.wikipedia.org/wiki/Exponential_backoff
- https://mechanical-sympathy.blogspot.com/2012/05/apply-back-pressure-when-overloaded.html

