---
title: title
description: description
---


## Synchronous vs Asynchronous Communication: Temporal Coupling and Latency Trade Offs

### Definition
Communication patterns describe how services in a distributed system exchange information. The two fundamental approaches are synchronous (caller waits for response) and asynchronous (caller continues without waiting). This choice affects latency, coupling, failure propagation, and scalability of your entire system.

### Synchronous: Blocking Request/Response
Synchronous communication creates tight temporal coupling where the caller blocks waiting for a response, propagating both latency and failures across service boundaries. Every hop in a synchronous chain adds variance to tail latency. Netflix maintains per hop budgets of 10 to 50 milliseconds to keep end user p95 page latencies under a few hundred milliseconds. When services fan out synchronously, tail latencies amplify; even if each dependency has a p99 of 50ms, calling 10 dependencies in parallel yields a combined p99 well above 100ms due to tail at scale effects.

### Asynchronous: Decoupled Messaging
Asynchronous messaging decouples producers from consumers in time, allowing systems to absorb bursts and scale fan out without blocking the caller. LinkedIn processes over 7 trillion Kafka messages per day with typical publish latencies in the low milliseconds and consumer lag SLOs kept under seconds for critical pipelines. This pattern enables one publisher to notify hundreds of downstream consumers (feed updates, notifications, analytics) without waiting for each to acknowledge. The cost is eventual consistency, at least once delivery semantics requiring idempotent consumers, and observability challenges since a single user action triggers a cascade of asynchronous events across many services.

### When to Use Each
The choice hinges on your latency budget and consistency requirements. For checkout authorization where you need an immediate yes/no decision and strong sequencing, synchronous RPC with timeouts is appropriate despite the tight coupling. For notifications, audit logs, and analytics where you can tolerate seconds of delay and need to decouple availability, asynchronous messaging wins. Uber uses time bounded RPC with propagated deadlines for critical ride lifecycle writes, keeping p95 in the tens to low hundreds of milliseconds, while using asynchronous eventing to propagate location updates and trip milestone events to fraud detection and analytics systems that can process with lag.

---

### 💡 Key Takeaways
- ✓ Netflix allocates 10 to 50 milliseconds per internal hop to maintain end user p95 latencies under a few hundred milliseconds; synchronous fan out to even 5 to 10 services can exceed user experience budgets without hedging or fallbacks
- ✓ LinkedIn publishes over 7 trillion Kafka messages daily with intra datacenter latencies in low milliseconds; asynchronous messaging decouples producer availability from consumer processing and smooths traffic bursts during regional spikes
- ✓ Synchronous calls provide immediate results and strong sequencing but propagate failures; a single slow dependency cascades into timeouts and retries across all callers, requiring circuit breakers and bulkheads for isolation
- ✓ Asynchronous patterns require at least once delivery handling with idempotency keys or versioned upserts; duplicate and out of order messages are inevitable under consumer restarts and partition rebalancing
- ✓ Use synchronous when you need immediate feedback and can afford tight coupling (payments, authorization); use asynchronous when you need high fan out, burst absorption, and can design UX around eventual consistency (notifications, replication, analytics)
- ✓ Observability is harder in async systems; correlation IDs, causality metadata, and monitoring of queue depths, consumer lag, and redelivery counts become mandatory to debug distributed flows

---

### 📌 Interview Tips
1. Netflix API gateway handles millions of requests per second at peak; internal services use client side load balancing with circuit breakers that execute billions of isolated command executions daily to contain tail latencies during dependency brownouts
2. Uber propagates deadlines through synchronous RPC chains for trip creation and pricing to keep p95 under 100ms, while publishing location updates asynchronously to decouple hot paths from downstream fraud detection and analytics processing
3. LinkedIn uses Kafka pub sub to fan out profile updates to feed generation, notifications, search indexing, and analytics; each consumer maintains its own offset and processes with seconds of lag under SLO without blocking the profile write path
