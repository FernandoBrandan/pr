---
title: Publish-Subscribe
description: Publish-Subscribe
--- 

https://www.youtube.com/watch?v=O1PgqUqZKTA
https://en.wikipedia.org/wiki/Publish%E2%80%93subscribe_pattern

____

Publish-Subscribe es una forma de comunicación de servicio a servicio que facilita la comunicación asíncrona. En un modelo de pub/sub, cualquier mensaje publicado sobre un tema se envía inmediatamente a todos los suscriptores del tema.

<Image src="https://www.karanpratapsingh.com/_next/image?url=%2Fstatic%2Fcourses%2Fsystem-design%2Fchapter-III%2Fpublish-subscribe%2Fpublish-subscribe.png&w=3840&q=75">

- Los suscriptores del tema del mensaje realizan diferentes funciones, y cada uno puede hacer algo diferente con el mensaje en paralelo. 
- El editor no necesita saber quién está utilizando la información que está transmitiendo, y los suscriptores no necesitan saber de dónde proviene el mensaje. 
- Este estilo de mensajería es un poco diferente a las colas de mensajes, donde el componente que envía el mensaje a menudo conoce el destino al que está enviando.

## Working
A diferencia de las colas de mensajes, que procesan los mensajes por lotes hasta que se recuperan, los temas de mensajes transfieren los mensajes con poca o ninguna cola y los envían inmediatamente a todos los suscriptores.

- Un tema de mensaje proporciona un mecanismo ligero para transmitir notificaciones de eventos asíncronos y puntos finales que permiten que los componentes de software se conecten al tema para enviar y recibir esos mensajes.
- Para transmitir un mensaje, un componente llamado a editor simplemente empuja un mensaje al tema.
- Todos los componentes que se suscriben al tema ( conocidos como suscriptores) recibirá cada mensaje que se transmitió.

## Ventajas

- __Eliminar encuestas:__ Los temas de mensajes permiten la entrega instantánea basada en el impulso, eliminando la necesidad de que los consumidores de mensajes verifiquen periódicamente o "encuesta" para nueva información y actualizaciones. Esto promueve un tiempo de respuesta más rápido y reduce la latencia de entrega, que puede ser particularmente problemática en sistemas donde no se pueden tolerar retrasos.
- __Orientación dinámica:__ Pub/Sub hace que el descubrimiento de servicios sea más fácil, más natural y menos propenso a errores. En lugar de mantener una lista de pares donde una aplicación puede enviar mensajes, un editor simplemente publicará mensajes sobre un tema. Luego, cualquier parte interesada suscribirá su punto final al tema y comenzará a recibir estos mensajes. Los suscriptores pueden cambiar, actualizar, multiplicar o desaparecer y el sistema se ajusta dinámicamente.
- __Escala desacoplada e independiente:__ Los editores y suscriptores están desacoplados y trabajan independientemente uno del otro, lo que nos permite desarrollarlos y escalarlos de forma independiente.
- __Simplificar comunicación:__ El modelo Publicar-Suscribir reduce la complejidad al eliminar todas las conexiones punto a punto con una sola conexión a un tema de mensaje, que administrará las suscripciones y decidirá qué mensajes deben entregarse a qué puntos finales.

## Características
 
- __Push Delivery:__
La mensajería Pub/Sub activa instantáneamente las notificaciones de eventos asíncronos cuando se publican mensajes en el tema del mensaje. 
Los suscriptores son notificados cuando hay un mensaje disponible.

- __Multiple Delivery Protocols:__
Los temas generalmente pueden conectarse a múltiples tipos de puntos finales, como colas de mensajes, funciones sin servidor, servidores HTTP, etc.

- __Fanout:__
Este escenario ocurre cuando se envía un mensaje a un tema y luego se replica y se empuja a múltiples puntos finales. Fanout proporciona notificaciones de eventos asíncronos que a su vez permiten el procesamiento paralelo.

- __Filtering:__
Esta característica permite al suscriptor crear una política de filtrado de mensajes para que solo reciba las notificaciones que le interesan, en lugar de recibir cada mensaje publicado en el tema.

- __Durability:__
Proporcionan una durabilidad muy alta y, al menos una vez, al almacenar copias del mismo mensaje en múltiples servidores.

- __Security:__
Los temas de mensajes autentican las aplicaciones que intentan publicar contenido, esto nos permite usar puntos finales cifrados y cifrar mensajes en tránsito a través de la red.

## Examples
https://aws.amazon.com/es/sns/
https://cloud.google.com/pubsub

___
https://blog.levelupcoding.co/p/luc-09-exploring-power-eventdriven-architecture
