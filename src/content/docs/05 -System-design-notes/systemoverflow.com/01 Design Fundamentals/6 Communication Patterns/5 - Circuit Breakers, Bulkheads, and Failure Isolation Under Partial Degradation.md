---
title: title
description: description
---

## Circuit Breakers, Bulkheads, and Failure Isolation Under Partial Degradation

Circuit breakers prevent cascading failures by stopping calls to a failing or slow dependency before exhausting caller resources. A circuit starts closed (calls flow through); when error rate or latency exceeds a threshold in a rolling window (for example, 50 percent errors over 10 seconds or p99 above 200ms), the circuit trips to open, immediately failing subsequent calls with a fallback response without attempting the downstream call. After a timeout (say 30 seconds), the circuit enters half open, allowing a few probe requests through. If probes succeed, the circuit closes; if they fail, it reopens. Netflix popularized this pattern with Hystrix, reporting billions of isolated command executions per day that prevented thread pool exhaustion and kept tail latencies contained during dependency brownouts.

Bulkheads isolate failures by segregating resources into independent pools so that one dependency cannot starve others. Instead of a shared thread pool for all downstream calls, allocate separate pools per dependency: 20 threads for payment service, 10 for inventory, 5 for recommendations. If recommendations hang, only its 5 threads block; payment and inventory remain unaffected. The cost is reduced average utilization (you reserve capacity that sits idle when dependencies are healthy) and increased configuration complexity. Uber uses bulkheads to prioritize critical dependencies like dispatch and payments over optional features like promotions; under load, optional features degrade while core ride functionality remains available.

Failure isolation also requires admission control and backpressure. When a service is overloaded, queuing requests worsens latency and leads to timeout/retry amplification. Instead, apply token bucket or leaky bucket rate limiting at the edge and reject excess requests immediately with 429 or 503, signaling callers to back off. Netflix sheds load at the edge when mid tier services report high latency, returning cached or degraded responses to keep end user experience acceptable. Without these patterns, a single slow database query can exhaust application threads, block health checks, cause load balancer to remove the instance, and shift load to remaining instances in a cascading failure that takes down the entire cluster.

---

### 💡 Key Takeaways
- ✓ Circuit breakers trip open when error rate or latency exceeds threshold (50 percent errors, p99 above 200ms) in rolling window; open circuits fail fast without calling dependency, preventing thread pool exhaustion and cascading failures
- ✓ Netflix Hystrix executes billions of isolated commands daily; circuit breakers reduced p99 latencies by 30 to 50 percent during dependency brownouts by cutting off slow dependencies and returning fallbacks
- ✓ Bulkheads allocate separate thread pools or concurrency limits per dependency; if one dependency hangs, only its pool blocks, isolating failure and preserving capacity for other dependencies
- ✓ Bulkheads reduce average resource utilization because reserved capacity sits idle when dependencies healthy; trade off is improved resilience and blast radius containment versus lower efficiency
- ✓ Admission control at edge rejects excess requests with 429 or 503 when backend overloaded, preventing queue buildup and timeout amplification; failing fast is better than slow failure after timeout
- ✓ Without failure isolation, a single slow dependency exhausts caller threads, blocks health checks, causes load balancer to remove instance, shifting load to others in cascading failure that takes down entire cluster

---

### 📌 Interview Tips
1. Netflix API gateway circuit breaker for recommendations service: if p99 exceeds 200ms for 10 seconds, circuit opens, subsequent calls return cached top picks without querying backend; after 30 seconds, probe requests check if service recovered
2. Uber dispatch service uses bulkheads: 50 threads for driver matching (critical), 20 threads for ETA calculation (important), 5 threads for promotions (optional); under load, promotions degrade while dispatch remains fast
3. E commerce checkout with separate circuit breakers for payment gateway, inventory service, and tax calculator; if tax service fails, circuit opens and checkout proceeds with estimated tax, preventing payment and inventory from blocking
