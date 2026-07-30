---
title: Message Brokers
description: Message Brokers
--- 

____
https://www.youtube.com/watch?v=57Qr9tk6Uxc
https://www.ibm.com/mx-es/topics/message-brokers
https://hasithas.medium.com/introduction-to-message-brokers-c4177d2a9fe3 

Un Message Broker es un sistema que gestiona la comunicación entre servicios enviando y recibiendo mensajes. 

Pueden validar, almacenar, enrutar y entregar mensajes a los destinos apropiados. 

- Características clave:
  - Desacopla a los emisores (producers) de los receptores (consumers).
  - Puede transformar, enrutar y filtrar mensajes.
  - Soporta múltiples patrones de mensajería: Message Queue, Pub-Sub, Request-Response, etc.

- Tipos de Message Brokers:
  - Basados en colas (Message Queue): RabbitMQ, ActiveMQ.
  - Basados en logs/eventos (Event Streaming): Apache Kafka, NATS Streaming.
____

- El usuario no es bloqueado y el trabajo se procesa en segundo plano. 
- Durante este tiempo, el cliente puede realizar opcionalmente una pequeña cantidad de procesamiento para que parezca que la tarea se ha completado.
- Por ejemplo, si se publica un tuit, el tuit podría publicarse instantáneamente en tu cronología, pero podría pasar algún tiempo antes de que el tuit se envíe realmente a todos tus seguidores.
___

<Image src="https://www.karanpratapsingh.com/_next/image?url=%2Fstatic%2Fcourses%2Fsystem-design%2Fchapter-III%2Fmessage-brokers%2Fmessage-broker.png&w=3840&q=75" />

 
## Modelos

- Mensajería punto a punto: Es utilizado en las colas de mensajes con una relación uno a uno entre el emisor y el receptor del mensaje.
- Mensajería de publicación-suscripción: Denominado "pub/sub", el productor de cada mensaje lo publica en un tema, y múltiples consumidores de mensajes se suscriben a los temas de los que desean recibir mensajes.

## Message brokers vs Event streaming

- Los Message brokers pueden admitir dos o más patrones de mensajería, incluidas colas de mensajes y pub/sub
- Las plataformas de Event streaming sólo ofrecen patrones de distribución de tipo pub/sub. 
- Diseñadas para su uso con grandes volúmenes de mensajes, las plataformas de streaming de eventos son fácilmente escalables. 
- Son capaces de ordenar flujos de registros en categorías denominadas temas y almacenarlos durante un periodo de tiempo predeterminado. 
Sin embargo, a diferencia de los Message brokers, las plataformas de streaming de eventos no pueden garantizar la entrega de los mensajes ni realizar un seguimiento de los consumidores que los han recibido.

Las plataformas de streaming de eventos ofrecen más escalabilidad que los Message brokers, pero menos funciones que garanticen la tolerancia a fallos, como el reenvío de mensajes, así como capacidades más limitadas de enrutamiento y puesta en cola de mensajes.

## Message brokers vs Enterprise Service Bus (ESB)

- La infraestructura de bus de servicios empresariales (ESB) es compleja y puede resultar difícil de integrar y cara de mantener. 
- Resulta difícil solucionar los problemas que surgen en los entornos de producción, no son fáciles de escalar y su actualización es tediosa.

En cambio, los Message brokers son una alternativa "ligera" a los ESB que ofrecen una funcionalidad similar, un mecanismo para la comunicación entre servicios, a un coste menor. Se adaptan bien a las arquitecturas de microservicios que se han ido imponiendo a medida que los ESB han ido perdiendo popularidad.

## Ejemplos

https://nats.io/
https://zeromq.org/
https://activemq.apache.org/
___
https://kafka.apache.org/ 
https://www.youtube.com/watch?v=B5j3uNBH8X4 
___
https://www.rabbitmq.com/ 
https://www.youtube.com/watch?v=nFxjaVmFj5E
https://medium.com/@diego.coder/introducci%C3%B3n-a-rabbitmq-e7989f832f5c 
___
https://redis.io/
https://aws.amazon.com/es/sqs/
https://medium.com/dev-genius/introduction-to-redis-bc567c402a37
Redis es útil como intermediario de mensajes sencillo, pero los mensajes pueden perderse. 
AWS SQS está alojado pero puede tener una alta latencia y existe la posibilidad de que los mensajes se entreguen dos veces.  

