---
title:
description: Rate limit
---

## Hay dos enfoques para limitar la velocidad:

- Bloqueo de solicitudes entrantes: Cuando un cliente excede los límites definidos, niegue sus solicitudes adicionales.
- Disminución de las solicitudes: Introduzca un retraso para las solicitudes más allá de los límites, haciendo que la persona que llama espere más y más para obtener una respuesta.

https://blog.appsignal.com/2024/04/03/how-to-implement-rate-limiting-in-express-for-nodejs.html
https://express-rate-limit.mintlify.app/overview

```js
npm i express-rate-limit: // Para bloquear solicitudes que excedan los límites especificados.
npm i express-slow-down:  // Para ralentizar solicitudes similares provenientes del mismo actor
```
