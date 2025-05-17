---
title: Short/Long Polling
description: Short Polling vs. Long Polling
--- 

____
https://blog.tundeonasanya.dev/short-polling-vs-long-polling-understanding-the-differences-and-when-to-use-each-clfsmzdmf00000amidruc02uc

- Mecanismos de Comunicación Cliente-Servidor
- Técnicas para mantener la comunicación entre el cliente y el servidor.

- Métodos para obtener datos de un servidor cuando no hay una conexión persistente.
- Relacionado con __Client-Server__, __Pub-Sub__ y __WebSockets.__
- Se usan cuando el cliente necesita actualizarse con nueva información.

## Short Polling:
- El cliente consulta periódicamente al servidor (cada X segundos).
- Ineficiente porque genera muchas solicitudes innecesarias.
- Ejemplo: Un sitio de noticias que actualiza la página cada 10 segundos.

## Long Polling:
- El cliente mantiene la conexión abierta hasta recibir una respuesta.
- Más eficiente que short polling pero no tan óptimo como WebSockets.
- Ejemplo: Un chat donde el servidor responde solo cuando hay un nuevo mensaje.

## Alternativas modernas:
- WebSockets: Conexión persistente bidireccional.
- Server-Sent Events (SSE): Permite que el servidor envíe eventos al cliente.