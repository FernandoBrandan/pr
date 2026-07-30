---
title: Queues Strems Broker
description: Queues Strems Broker
--- 

## Message Queues (Colas de Mensajes)

Una cola de mensajes es un sistema en el que los mensajes se almacenan en orden y se entregan a los consumidores de manera garantizada, generalmente una sola vez.

🔹 Características:
- Modelo de Productor-Consumidor: Un productor envía mensajes a la cola y un consumidor los procesa.
- Persistencia: Los mensajes se guardan hasta que un consumidor los recibe y los procesa.
- Entrega Garantizada: Los mensajes solo son consumidos una vez por un consumidor.
- Escalabilidad: Si hay múltiples consumidores, la carga se distribuye entre ellos.

Casos de Uso:
- Procesamiento de trabajos en segundo plano (background jobs).
- Sistemas de notificaciones y procesamiento de eventos.
- Balanceo de carga en servicios desacoplados.

---

## Streams (Flujos de Datos)
Un flujo de datos es un sistema en el que los eventos se procesan en tiempo real o casi en tiempo real. 
A diferencia de las colas, los datos no desaparecen inmediatamente después de ser consumidos, permitiendo que múltiples consumidores los lean a su propio ritmo.

🔹 Características:
- Modelo de Publicador-Suscriptor: Múltiples consumidores pueden leer el mismo evento sin eliminarlo del flujo.
- Retención de Datos: Los mensajes pueden permanecer en el sistema por un tiempo definido.
- Procesamiento en Tiempo Real: Permite análisis y transformación de datos mientras se generan.
- Escalabilidad Masiva: Soporta alto volumen de eventos sin comprometer el rendimiento.

Casos de Uso:
- Procesamiento de logs y métricas en tiempo real.
- Streaming de eventos en aplicaciones de IoT.
- Análisis de datos en flujos como redes sociales o plataformas de comercio.

---

## Message broker 
Es un intermediario o un sistema de software que facilita la comunicación entre aplicaciones o servicios, usando mensajes. 

- Maneja múltiples colas, rutas y reglas de enrutamiento, y proporciona funcionalidades adicionales que permiten una mayor flexibilidad y escalabilidad.
- Puede enrutar mensajes de forma compleja, lo que significa que puede dirigir los mensajes a diferentes colas, basándose en reglas de enrutamiento o temas específicos (pub/sub).
- Almacena los mensajes temporalmente, asegurando que no se pierdan durante el proceso de entrega.
- Garantiza que los mensajes sean entregados al destinatario, incluso en casos de fallos, ya sea mediante acknowledgments (confirmaciones) o técnicas como la persistencia de mensajes.
- Permite que un servicio (publicador) envíe mensajes a múltiples suscriptores.
- Permite que los sistemas de productores y consumidores estén desacoplados. Esto facilita la escalabilidad y la tolerancia a fallos.

### Ejemplos de Message Brokers:
- Apache Kafka: Maneja grandes volúmenes de datos y eventos, para arquitecturas de microservicios y procesamiento de flujos de eventos en tiempo real.
- RabbitMQ: Un broker basado en AMQP que es fácil de usar y admite enrutamiento complejo de mensajes, ideal para tareas que requieren fiabilidad.
- ActiveMQ: Un broker con soporte para múltiples protocolos de mensajería y una buena integración con aplicaciones Java.





 