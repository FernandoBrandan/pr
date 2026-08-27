- **plataforma de pedidos/pagos**
- **wallet**
- **ISP/billing**

## 1. Proyecto principal: Marketplace / Order Platform

### Arquitectura inicial

```text
                    API
                     │
                     ▼
              ┌─────────────┐
              │ Order API   │
              └──────┬──────┘
                     │
          ┌──────────┼──────────┐
          ▼          ▼          ▼
      Inventory   Payment    Notification
          │          │
          ▼          ▼
         DB         DB
```

Empezás **simple**, incluso con un solo backend.

Después:

```text
                 Load Balancer
                      │
          ┌───────────┼───────────┐
          ▼           ▼           ▼
       Order-1     Order-2     Order-3
          │           │           │
          └───────────┼───────────┘
                      ▼
                    DB
```

Y ahí empiezan los problemas interesantes.

---

# 2. Escenario: generación de IDs

Supongamos:

```http
POST /orders
```

Tenés 10 instancias.

### Opción A — DB sequence

```text
Order → PostgreSQL
          ↓
       sequence
```

**Pros**

* simple
* consistente
* fácil de consultar

**Contras**

* dependencia de DB
* generación centralizada

---

### Opción B — UUID

```text
Order Service
     ↓
UUID
     ↓
DB
```

**Pros**

* descentralizado
* sencillo
* prácticamente sin colisiones

**Contras**

* más grande
* menos amigable para índices dependiendo del formato/versión
* no necesariamente orden temporal

---

### Opción C — Snowflake

```text
timestamp | worker | sequence
```

**Pros**

* distribuido
* numérico
* aproximadamente ordenable por tiempo

**Contras**

* más complejidad
* necesitás gestionar worker IDs
* aparecen problemas de reloj

### 🎯 Escenario

Probá:

> "Tenemos 20 instancias generando 50k órdenes/segundo."

Y decidí:

```text
DB sequence
vs
UUID
vs
Snowflake
```

Ese es un **trade-off real**.

---

# 3. Escenario: retry + idempotency

Ahora:

```text
Client
  │
  │ POST /orders
  ▼
Server
  │
  ├── create order ✓
  │
  └── response X
```

El cliente hace retry.

```text
POST /orders
POST /orders
```

Resultado:

```text
Order #100
Order #101
```

💥 Duplicado.

---

## Solución

```http
Idempotency-Key: abc123
```

Servidor:

```text
abc123
   ↓
┌──────────────────┐
│ Order #100       │
│ status: CREATED  │
└──────────────────┘
```

Segundo request:

```text
abc123
   ↓
return Order #100
```

### Ahora meté retries

```text
timeout
   ↓
retry
   ↓
retry
   ↓
retry
```

Probá:

* exponential backoff
* jitter
* timeout
* máximo de retries
* circuit breaker

### Trade-off

```text
Sin retry
    ↓
menos carga
pero más errores visibles

Con retry
    ↓
más resiliencia
pero más carga
```

Y:

```text
Retry + idempotency
        ↓
mucho más seguro
```

---

# 4. Escenario: inventario concurrente

Tenés:

```text
Stock = 1
```

Llegan:

```text
Request A → comprar producto
Request B → comprar producto
```

Ambos leen:

```text
stock = 1
```

Ambos compran.

💥 Overselling.

Acá podés practicar **Distributed Lock**.

```text
Request
   │
   ▼
acquire(product:123)
   │
   ▼
check stock
   │
   ▼
decrement
   │
   ▼
release
```

---

# 5. Pero después eliminá el Distributed Lock

Esta es una práctica MUY buena.

Primero:

```text
Redis Distributed Lock
        ↓
update inventory
```

Después:

```text
DB atomic update

UPDATE inventory
SET stock = stock - 1
WHERE product_id = ?
AND stock > 0;
```

Y comparás:

|                 | Distributed Lock | Atomic DB update |
| --------------- | ---------------- | ---------------- |
| Complejidad     | Mayor            | Menor            |
| Infraestructura | Redis/etc.       | DB               |
| Concurrencia    | Buena            | Buena            |
| Failure modes   | Más              | Menos            |
| Scope           | Flexible         | Más específico   |
| Debug           | Más difícil      | Más fácil        |

Esto te enseña algo importante:

> **No todo problema distribuido necesita una primitive distribuida.**

Muchas veces una buena operación atómica de DB es mejor.

---

# 6. Escenario: Leader Election

Agregá:

```text
Order Service
Inventory Service
Payment Service
```

y un job:

```text
expire abandoned orders
```

Tenés 5 instancias:

```text
Instance A ─┐
Instance B ─┤
Instance C ─┼── execute job
Instance D ─┤
Instance E ─┘
```

No querés que las 5 ejecuten el mismo job.

### Solución simple

Distributed lock:

```text
acquire("expire-orders")
        ↓
solo uno ejecuta
```

Pero después podés implementar:

```text
Leader Election
```

```text
        Leader
       /  |  \
      A   B   C
```

Si muere:

```text
Leader X
   ↓
Election
   ↓
New Leader
```

### Trade-off interesante

```text
Distributed Lock
vs
Leader Election
```

**Lock:**

> "Necesito exclusión mutua para esta operación."

**Leader:**

> "Necesito que un nodo tenga responsabilidad de coordinación durante un período."

Son problemas parecidos pero conceptualmente diferentes.

---

# 7. Escenario: Payment + Order + Inventory

Acá aparece el plato fuerte.

```text
Order
  │
  ├── Inventory
  │
  └── Payment
```

Supongamos:

```text
Order       ✓
Inventory   ✓
Payment     X
```

¿Cómo volvés atrás?

---

## Saga

```text
Create Order
     ↓
Reserve Inventory
     ↓
Charge Payment
     X
     ↓
Release Inventory
     ↓
Cancel Order
```

Ahora agregá:

```text
retry
timeout
idempotency
```

Te queda:

```text
Saga
 ├── retry
 ├── timeout
 ├── idempotency
 └── compensation
```

Esto es un **excelente proyecto de portfolio**, porque ya no es CRUD.

---

# 8. Después implementá 2PC como experimento

No necesariamente como arquitectura definitiva.

Construí:

```text
Coordinator
     │
 ┌───┼────┐
 ▼   ▼    ▼
Order Payment Inventory
```

Fase:

```text
PREPARE
   ↓
COMMIT
```

Y provocá:

```text
Payment → PREPARED
Inventory → PREPARED

Coordinator → 💀
```

Preguntate:

> ¿Qué hacen los participantes?

Ahí vas a entender **por qué 2PC tiene problemas** mucho mejor que leyendo teoría.

---

# 9. Saga vs 2PC

Este es uno de los mejores trade-offs para practicar.

|                         | 2PC             | Saga                 |
| ----------------------- | --------------- | -------------------- |
| Atomicidad              | Fuerte          | Eventual             |
| Complejidad operacional | Alta            | Alta                 |
| Bloqueos                | Puede haber     | No tradicionalmente  |
| Performance             | Menor           | Mejor potencialmente |
| Compensaciones          | No              | Sí                   |
| Fallos                  | Difíciles       | Explícitos           |
| Microservicios          | Menos atractivo | Muy común            |
| Consistencia            | Fuerte          | Eventual             |

La pregunta de laboratorio sería:

> "Tengo Order + Payment + Inventory. ¿Cuándo elegiría 2PC y cuándo Saga?"

No hay una respuesta universal.

---

# 10. Gossip + Failure Detection

Ahora hacé que tengas:

```text
10 Order instances
```

Cada una conoce:

```text
A alive
B alive
C alive
D ?
```

Implementá heartbeat:

```text
A → B
"I'm alive"

B → A
"I'm alive"
```

Si no responde:

```text
timeout
   ↓
suspect
```

Después propagá esa información usando Gossip:

```text
A → B
A → C

B → D
C → E

...
```

Podés visualizar:

```text
A says:
"B is suspected"

        ↓

B ───> C
       ↓
       D
       ↓
       E
```

### Experimento

Matá deliberadamente:

```bash
kill instance-3
```

Y medí:

> ¿Cuánto tarda el cluster en saber que murió?

Después aumentá:

```text
10 nodes
100 nodes
500 nodes
```

Ahí entendés por qué Gossip existe.

---

# 11. Vector Clocks

Yo lo dejaría para un proyecto separado o para una segunda etapa.

Podés hacer un pequeño sistema de **replicated key-value store**:

```text
        Client
          │
     ┌────┼────┐
     ▼    ▼    ▼
    N1   N2    N3
```

Cada nodo puede aceptar writes.

Por ejemplo:

```text
N1:
x = A

N3:
x = B
```

Sin comunicación entre ellos.

Después se sincronizan.

Ahora tenés:

```text
x = A
x = B
```

¿Cómo sabés si:

```text
B reemplaza A
```

o si:

```text
A y B fueron escritos concurrentemente
```

Ahí entran:

* Lamport clocks
* Vector clocks
* conflict resolution
* eventual consistency

Este proyecto ya es bastante más avanzado.

---

# 12. Proyecto completo que yo haría

Si querés **un solo proyecto grande**, haría:

## Distributed Order Platform

```text
                    ┌─────────────┐
                    │ API Gateway │
                    └──────┬──────┘
                           │
             ┌─────────────┼─────────────┐
             ▼             ▼             ▼
          Orders       Inventory      Payments
             │             │             │
             ▼             ▼             ▼
            DB            DB             DB
```

Y progresivamente:

### Nivel 1

```text
CRUD
Orders
Products
Users
```

### Nivel 2

```text
UUID / Snowflake
```

### Nivel 3

```text
Timeout
Retry
Idempotency
```

### Nivel 4

```text
Concurrent inventory
```

Comparás:

```text
DB atomic update
vs
Distributed Lock
```

### Nivel 5

```text
Order + Inventory + Payment
```

Implementás:

```text
Saga
```

### Nivel 6

```text
2PC
```

Solo para comparar.

### Nivel 7

```text
Leader Election
```

para jobs distribuidos.

### Nivel 8

```text
Failure Detection
+
Gossip
```

### Nivel 9

```text
Raft
```

para un pequeño servicio de configuración/metadata.

### Nivel 10

```text
Vector Clocks
```

en un replicated KV store.

---

# 13. Y acá aparece una distinción MUY importante

No intentaría meter **Raft + Paxos + Vector Clocks + Gossip + Saga + 2PC** todos en la arquitectura final.

Eso sería artificial.

Haría:

```text
                  LABORATORIO
                       │
        ┌──────────────┼──────────────┐
        │              │              │
     Order          Cluster        KV Store
     System         System         Replicated
        │              │              │
     Saga/2PC       Raft/Gossip    Clocks
        │
   Retry/Idempotency
        │
   Lock/Atomic DB
        │
      IDs
```

Porque el objetivo no es construir "una arquitectura con todas las palabras de Distributed Systems".

El objetivo es poder decir:

> **"Tengo este problema → estas son las soluciones posibles → elegí X porque..."**

Eso es muchísimo más parecido al trabajo real de backend.

## Los 5 trade-offs que más te conviene practicar

Si tuviera que reducir todo tu laboratorio a cinco decisiones:

```text
1. UUID vs Snowflake vs DB Sequence

2. Distributed Lock vs Atomic DB Operation

3. Lock vs Leader Election

4. 2PC vs Saga

5. Retry vs no-retry
   + idempotency
```

Y después:

```text
6. Centralized failure detection vs Gossip

7. Strong consistency vs Eventual consistency

8. Raft vs simpler coordination

9. Logical ordering vs Vector Clocks
```

Ahí ya tenés un **laboratorio de Distributed Systems bastante serio**, sin caer en hacer proyectos académicos desconectados del backend real.
