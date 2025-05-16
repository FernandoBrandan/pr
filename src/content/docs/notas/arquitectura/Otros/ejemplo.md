---
title: Ejemplo de proyecto
description: Apuntes varios
--- 

**EDA** **MDA** **Sistema distribuido** **Eventos y mensajes** **Microservicios** **Event Sourcing** 
 
- MS : inventario, envíos, notificaciones, pagos, etc. 
- Basado en eventos y mensajes interacción de manera desacoplada. 
- Event Sourcing

- Escenario: Sistema de Comercio Electrónico con Procesamiento de Pagos

- Servicios en el sistema:
  - API de productos: Gestiona los productos, sus precios, stock, etc.
  - API de pagos: Maneja las solicitudes de pago y su validación.
  - API de inventarios: Administra la cantidad de productos disponibles.
  - API de envíos: Gestiona las entregas de los productos comprados.
  - API de notificaciones: Envía mensajes o correos electrónicos a los clientes.
  - API de auditoría: Monitorea y guarda registros detallados de las transacciones.

## Proceso de compra (Evento de CompraRealizada):

- Usuario realiza una compra.
- Api orden: Consulta si el producto está en stock.
- Api pagos: Recibe una solicitud de pago con la información de la compra.
- Evento CompraRealizada es emitido, y todos los sistemas reaccionan.

## Flujo de Eventos y Mensajes:

### Paso 1: El Evento CompraRealizada es Emitido

- Event-Driven Architecture (EDA): 
  - API pagos emite el evento CompraRealizada cuando el pago es solicitado.
  - Se publica en un broker de mensajes
  - Otros servicios suscrito a él, actúan sobre el evento.

### Paso 2: Servicios Reaccionan a través de Pub/Sub
- API inventarios: 
  - Se suscribe al evento CompraRealizada. 
  - Verifica si el producto está disponible en el inventario y reduce el stock.

- API de envíos: 
  - Se suscribe al evento CompraRealizada. 
  - Prepara la orden para su envío, generando un mensaje de PedidoEnviado.

- API notificaciones: 
  - Se suscribe al evento CompraRealizada. 
  - Envía un correo o mensaje al cliente notificándole sobre la compra y el estado del pago.

### Paso 3: Mensajes de Estado (Mensajes de Confirmación)

- API pagos valida el pago 
  - Emite un evento de PagoAprobado o PagoRechazado.
- API inventarios y API envíos 
  - Proceden con las acciones correspondientes.

- Agregando Event Sourcing:
  - Genera un registro detallado de cada cambio de estado. 
  - Guarda todos los eventos que ocurrieron durante el proceso de la compra.
    - Almacenamiento de eventos: 
    - Evento CompraRealizada: El usuario realiza una compra.
    - Evento PagoAprobado: El pago es aprobado.
    - Evento ProductoEnviado: El producto ha sido enviado.
    - Evento NotificaciónEnviada: La notificación ha sido enviada al cliente.
- Recreación del estado:
 	 - Si se necesita conocer el estado actual, se reconstruye ese estado a partir de los eventos almacenados. 

### Integración con Event Sourcing:
Cada MS tiene su propio "Event Store", donde almacena los eventos relevantes para su dominio. 
- API pagos: PagoIniciado, PagoAprobado, etc.
- API inventarios: ProductoComprado, StockReducido.

Event Sourcing es útil para la auditoría, deshacer cambios (si es necesario), y la reconstrucción del sistema en caso de fallos.

## Panorama Completo con los Tres Enfoques:
- Flujo de compra: 
  - El usuario realiza la compra. Esto emite el evento CompraRealizada.
- Reacción de microservicios:
  - API inventarios reduce el stock.
  - API pagos procesa el pago y emite el evento PagoAprobado o PagoRechazado.
  - API envíos prepara el pedido para el envío, emitiendo el evento ProductoEnviado.
  - API notificaciones envía un mensaje al cliente.
- Almacenamiento de eventos:
  - Cada uno de los servicios almacena los eventos en su Event Store
  - Asegura que los cambios en el estado de la compra estén siempre disponibles para reconstruir el estado final.
- Auditoría y trazabilidad: 
  - Usando Event Sourcing podemos: 
    - Auditar el sistema
    - Ver la evolucion el estado de cada compra
    - Tener un historial completo de cada cambio.

## Beneficios y Mejoras:
- Desacoplamiento: Los servicios no necesitan saber nada entre sí, solo reaccionan a los eventos que publican.
- Escalabilidad: Es fácil escalar servicios individuales sin preocuparse por la sincronización directa entre ellos.
- Trazabilidad: Con Event Sourcing, podemos auditar cada paso del proceso de compra y pago. Si necesitamos reproducir un caso anterior, podemos hacerlo a partir de los eventos almacenados.
- Resiliencia: Si algún servicio falla, los eventos pueden ser almacenados y procesados más tarde, garantizando que el sistema continúe funcionando.

