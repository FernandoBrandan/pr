Acá tenés un **resumen global**, manteniendo el espíritu técnico y directo de todo lo que viste 👇

---

# 🧠 System Design Fundamentals — Resumen General

## 1. Scaling (Vertical vs Horizontal)

* **Vertical scaling:** más CPU/RAM → simple pero con límite físico y SPOF
* **Horizontal scaling:** más máquinas → escalabilidad casi infinita + alta disponibilidad
* **Regla:** empezar vertical → escalar horizontal al llegar a límites

> ⚠️ Horizontal introduce complejidad: sharding, consistencia, estado

---

## 2. Stateless Architecture

* Servidores **no guardan estado entre requests**
* Todo el estado va a:

  * Redis (sesiones)
  * DB (datos)
  * JWT (auth)

✔ Permite:

* Load balancing real
* Failover sin impacto
* Escalado horizontal limpio

> 🔑 Test: podés matar cualquier server sin romper nada

---

## 3. Little’s Law (capacidad real)

**Concurrency = Throughput × Latency**

* Más latencia ⇒ necesitás más concurrencia
* Si no la tenés ⇒ **cola → más latencia → colapso**

> 🔥 Death spiral: latencia ↑ → concurrencia ↑ → colas ↑ → latencia ↑

---

## 4. Scaling Decision Framework

Escalar cuando:

* CPU > 70%
* p99 crece más que p50
* connection pool lleno
* GC / memoria inestable

✔ Antes de escalar:

* encontrar el bottleneck
* optimizar primero

---

## 5. Caching Problems (Stampede)

Problema:

* Cache expira → miles de requests → DB colapsa

Soluciones:

* Locking (1 solo regenera)
* Early expiration (antes del TTL)
* Stale-while-revalidate

> 🔑 Hot keys necesitan tratamiento especial

---

## 6. Sharding Issues (Hotspots)

Problema:

* Un shard recibe 80% del tráfico

Causas:

* celebrity users
* mala key
* skew temporal

Soluciones:

* key salting
* caching
* sharding compuesto

> ⚠️ Más shards ≠ solución si el hotspot sigue igual

---

## 7. Availability vs Reliability

* **Availability:** sistema responde
* **Reliability:** sistema responde correctamente

✔ Podés tener uno sin el otro

> 🔥 Sistema disponible pero incorrecto = peor que downtime

---

## 8. Error Budgets (SRE mindset)

* 99.9% = 8.76h downtime/año
* Ese tiempo es tu **presupuesto de errores**

Se usa para:

* deploys
* mantenimiento
* fallas

✔ Si se agota → freeze de cambios

---

## 9. Failure Modes

Tipos:

* Hardware (discos, red)
* Software (leaks, bugs)
* Cascading failures (lo más peligroso)
* Error humano (60–80%)

> 🔥 Cascada: retry → más carga → colapso total

---

## 10. Designing for Availability & Reliability

### Availability

* redundancia
* failover automático
* multi-AZ / multi-region

### Reliability

* validación
* idempotencia
* transacciones
* testing

✔ Balance:

* más consistencia → menos disponibilidad (a veces)

---

## 11. Graceful Degradation

Cuando el sistema sufre:

* devolver datos cacheados
* desactivar features
* simplificar respuestas

> ✔ Mejor parcial que caída total

---

# 💡 Ideas Clave (High-Level)

* Escalar ≠ agregar servidores → primero entender el bottleneck
* Latencia es el primer síntoma de problemas
* Sistemas distribuidos fallan de formas predecibles
* El mayor riesgo no es el fallo… es la **cascada**
* Alta disponibilidad sin confiabilidad destruye confianza
* Todo diseño real es trade-offs (consistencia, costo, complejidad)

---

# 📌 Mental Model Final

Pensalo así:

1. **Scale:** ¿puede crecer?
2. **Stateless:** ¿puede distribuirse?
3. **Capacity:** ¿aguanta carga? (Little’s Law)
4. **Failures:** ¿qué pasa cuando rompe?
5. **Recovery:** ¿qué tan rápido vuelve?
6. **Correctness:** ¿hace lo correcto?

---

Si querés, el siguiente paso lógico es armarte un **system design completo (tipo entrevista FAANG)** usando TODOS estos conceptos juntos (por ejemplo: diseñar Twitter / pagos / reservas).
