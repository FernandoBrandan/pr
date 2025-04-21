---
title: Ejemplo de proyecto
description: Apuntes varios
--- 

Imaginemos un sistema en el que tenemos diferentes microservicios para distintos aspectos del sistema, como el inventario, envíos, notificaciones, pagos, etc. Todo el sistema está basado en eventos y mensajes que permiten que los servicios interactúen de manera desacoplada. Vamos a repasar cómo se interconectan los servicios y cómo Event Sourcing encaja en este panorama.

Escenario: Sistema de Comercio Electrónico con Procesamiento de Pagos
Servicios en el sistema:

API de productos: Gestiona los productos, sus precios, stock, etc.
API de pagos: Maneja las solicitudes de pago y su validación.
API de inventarios: Administra la cantidad de productos disponibles.
API de envíos: Gestiona las entregas de los productos comprados.
API de notificaciones: Envia mensajes o correos electrónicos a los clientes.
API de auditoría: Monitorea y guarda registros detallados de las transacciones.

Proceso de compra (Evento de CompraRealizada):

Un usuario realiza una compra en el sistema.
La API de productos consulta si el producto está en stock.
Si el producto está disponible, la API de pagos recibe una solicitud de pago con la información de la compra.
En este momento, un evento CompraRealizada es emitido, y todos los sistemas relevantes reaccionan ante este evento.

Flujo de Eventos y Mensajes:
Paso 1: El Evento CompraRealizada es Emitido
Event-Driven Architecture (EDA): La API de pagos emite el evento CompraRealizada cuando el pago es solicitado.
Este evento se publica en un broker de mensajes (puede ser Kafka, RabbitMQ, etc.) para que otros servicios puedan suscribirse a él y actuar sobre el evento.
Paso 2: Servicios Reaccionan a través de Pub/Sub
API de inventarios: Se suscribe al evento CompraRealizada. Cuando el evento llega, verifica si el producto está disponible en el inventario y reduce el stock.
API de envíos: También se suscribe al evento CompraRealizada. Cuando el evento llega, prepara la orden para su envío, generando un mensaje de PedidoEnviado.
API de notificaciones: Se suscribe al evento CompraRealizada. Cuando recibe el evento, envía un correo o mensaje al cliente notificándole sobre la compra y el estado del pago.
Paso 3: Mensajes de Estado (Mensajes de Confirmación)
Una vez que API de pagos valida el pago, emite un evento de PagoAprobado o PagoRechazado.
API de inventarios y API de envíos reaccionan a estos eventos y proceden con las acciones correspondientes.
Agregando Event Sourcing:
Event Sourcing encaja cuando queremos mantener un registro detallado de cada cambio de estado. En lugar de guardar solo el estado final (por ejemplo, un pago completado), guardamos todos los eventos que ocurrieron durante el proceso de la compra.

Almacenamiento de eventos: Cada cambio en el sistema es almacenado como un evento:

Evento CompraRealizada: El usuario realiza una compra.
Evento PagoAprobado: El pago es aprobado.
Evento ProductoEnviado: El producto ha sido enviado.
Evento NotificaciónEnviada: La notificación ha sido enviada al cliente.
Recreación del estado:

Si alguna parte del sistema necesita conocer el estado actual (por ejemplo, si necesitamos saber si un pago fue aprobado), podemos reconstruir ese estado a partir de los eventos almacenados. Así, en lugar de almacenar el estado final, se almacenan todos los eventos y, cuando sea necesario, podemos "reproducir" esos eventos para reconstruir el estado.
Integración con Event Sourcing:

Cada microservicio puede tener su propio "Event Store", donde almacena los eventos relevantes para su dominio. Por ejemplo:
La API de pagos tendría un Event Store para eventos como PagoIniciado, PagoAprobado, etc.
La API de inventarios podría almacenar eventos como ProductoComprado, StockReducido.
Event Sourcing no solo ayuda a mantener un historial detallado, sino que también es útil para la auditoría, deshacer cambios (si es necesario), y la reconstrucción del sistema en caso de fallos.
Panorama Completo con los Tres Enfoques:
Flujo de compra: El usuario realiza la compra. Esto emite el evento CompraRealizada.
Reacción de microservicios:
API de inventarios reduce el stock.
API de pagos procesa el pago y emite el evento PagoAprobado o PagoRechazado.
API de envíos prepara el pedido para el envío, emitiendo el evento ProductoEnviado.
API de notificaciones envía un mensaje al cliente.
Almacenamiento de eventos:
Cada uno de estos servicios puede almacenar los eventos en su Event Store, asegurando que los cambios en el estado de la compra estén siempre disponibles para reconstruir el estado final.
Auditoría y trazabilidad: Usando Event Sourcing, podemos auditar el sistema, ver cómo evolucionó el estado de cada compra, y tener un historial completo de cada cambio.
Beneficios y Mejoras:
Desacoplamiento: Los servicios no necesitan saber nada entre sí, solo reaccionan a los eventos que publican.
Escalabilidad: Es fácil escalar servicios individuales sin preocuparse por la sincronización directa entre ellos.
Trazabilidad: Con Event Sourcing, podemos auditar cada paso del proceso de compra y pago. Si necesitamos reproducir un caso anterior, podemos hacerlo a partir de los eventos almacenados.
Resiliencia: Si algún servicio falla, los eventos pueden ser almacenados y procesados más tarde, garantizando que el sistema continúe funcionando.
Resumen:
EDA y MDA se complementan bien en un sistema distribuido donde los servicios reaccionan a eventos y mensajes, respetando la arquitectura de microservicios.
Event Sourcing agrega valor al proporcionar un historial completo de todos los cambios de estado a través de eventos, lo que ayuda tanto en la trazabilidad como en la resiliencia del sistema.
Puedes combinar EDA y Event Sourcing para mantener un sistema robusto y escalable, donde los eventos fluyen entre los servicios de manera eficiente y el estado completo de la compra o transacción puede ser reconstruido en cualquier momento a partir de los eventos.
