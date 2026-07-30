---
title: Concurrencia Redis_DB
description: Concurrencia Redis_DB
---

En el contexto de un sistema de ecommerce, la concurrencia puede ser un desafío crítico. 
Cuando múltiples usuarios realizan compras concurrentes de un mismo artículo, es crucial asegurarse de que el stock no se sobrevenda.

`Articulo: Cómo bloquear stock en un sistema de órdenes por colas: Redis vs Base de Datos`

## Problema
En sistemas de ecommerce modernos, especialmente cuando usamos colas de procesamiento como RabbitMQ, Kafka o SQS para gestionar las órdenes de compra, surge un desafío clásico pero crítico: ¿cómo asegurar que no se sobrevendan productos con stock limitado?

Cuando múltiples usuarios realizan compras concurrentes del mismo artículo, necesitamos una estrategia eficiente para bloquear o reservar stock durante el procesamiento de la orden, evitando condiciones de carrera y errores de inventario.

## Qué debemos bloquear y por qué?
El elemento a proteger es el stock disponible de cada artículo. 
Si no se controla adecuadamente, dos órdenes pueden reducir el mismo stock al mismo tiempo, resultando en ventas por encima del límite real.

- Lo que debe estar protegido:
  - La cantidad disponible del producto.
  - La integridad de la operación de “restar stock”.
  - El momento entre el inicio del procesamiento y la confirmación de la orden.

## Soluciones posibles


### 1. Bloqueo directo en la Base de Datos

Se realiza una operación atómica o con SELECT ... FOR UPDATE dentro de una transacción.

```sql
BEGIN;
SELECT stock FROM productos WHERE id = 42 FOR UPDATE;
-- Verifico stock disponible
-- Actualizo stock
COMMIT;
```
- Ventajas:
  - Alta consistencia: todo ocurre en la fuente de verdad.
  - Usa transacciones ACID.

- Desventajas:
  - Lento bajo alta concurrencia.
  - Potenciales deadlocks.
  - Poca escalabilidad si hay miles de órdenes por segundo.

- Cuándo usarlo:
  - Sistemas con bajo volumen de ventas concurrentes.
  - Productos únicos o de valor alto.

### 2. Bloqueo con Redis
Usamos Redis como sistema de bloqueo rápido, ya sea para reservar stock (DECR) o mediante locks (SETNX o Redlock).

```bash
DECR producto:42:stock
-- Si el valor queda < 0, deshacer o rechazar orden.
```

- Ventajas:
  - Altísimo rendimiento y baja latencia.
  - Ideal para eventos de alto tráfico (ej: Hot Sale).

- Desventajas:
  - Redis no es la fuente de verdad.
  - Puede haber desincronización con la base de datos.
  - Requiere lógica adicional para sincronizar si falla.

- Cuándo usarlo:
  - Escenarios de alto tráfico donde la velocidad es prioridad.
  - Casos en los que Redis ya se usa como caché.

## 3. Enfoque híbrido
Primero reservamos stock temporalmente en Redis, luego confirmamos la operación en la base de datos.

- Flujo típico:
  1) Reducir stock en Redis (rápido).
  1) Encolar orden para procesamiento.
  1) Confirmar stock y guardar orden en DB.
  1) Sincronizar Redis si ocurre rollback.
- Ventajas:
  - Muy rápido.
  - Más resiliente y balanceado.
  - Permite manejar picos de tráfico sin perder consistencia.
- Desventajas:
  - Mayor complejidad.
  - Requiere mecanismos de sincronización entre Redis y DB.
- Cuándo usarlo:
  - Ecommerce de tamaño medio a grande.
  - Procesamiento por colas donde la performance importa. 

