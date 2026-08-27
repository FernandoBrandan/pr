---
title: title
description: description
---

# How Latency and Throughput Interact Through Queuing and Utilization

## The Queuing Relationship

Every system has a queue, visible or not. When requests arrive faster than they complete, they wait. The relationship follows a predictable pattern: as arrival rate approaches service rate, wait times grow without bound.

Consider a server that processes 100 requests per second:

* At 50 RPS load, average queue length stays near zero, latency equals processing time.
* At 80 RPS, queue length averages 4 requests, latency doubles.
* At 95 RPS, queue length averages 19 requests, latency is 5x.
* At 99 RPS, queue length averages 99 requests, latency is 100x.

This is queuing theory in action.

## Little's Law

Little's Law is the fundamental equation connecting latency and throughput: $L = \lambda \times W$ where $L$ is concurrent requests in the system, $\lambda$ (lambda) is throughput (requests per second), and $W$ is average latency (seconds).

If your API handles 500 RPS with 200ms average latency: $L = 500 \times 0.2 = 100$. You need capacity for 100 concurrent requests. Double the throughput without reducing latency, you need 200 concurrent request capacity. This is why connection pools, thread counts, and memory scale with throughput × latency.

## The Utilization Cliff

The relationship between utilization and latency is nonlinear. At low utilization, adding load barely affects latency. Past 70% utilization, latency climbs steeply. Past 90%, small load increases cause massive latency spikes.

This happens because queuing time follows $\text{wait\_time} = \frac{\text{service\_time}}{1 - \text{utilization}}$. At 50% utilization, wait equals service time. At 90%, wait is 9x service time. At 99%, wait is 99x service time. This cliff is why production systems target 60 to 70% capacity, not 90%.

> **Key Trade-off:** Higher throughput requires running closer to capacity, which increases latency. You cannot maximize both. Pick your priority based on user experience requirements: interactive systems prioritize latency, batch systems prioritize throughput.

## Batching: Trading Latency for Throughput

Batching is the clearest example of the trade-off. Instead of processing requests one at a time, you wait to collect a batch. Individual request latency increases by the wait time, but throughput increases because per-request overhead is amortized.

A database insert with 5ms overhead per request handles 200 inserts/second. Batch 100 inserts together with 10ms total overhead, and you handle 9,900 inserts/second. Latency increases by the batch collection time (maybe 50ms), but throughput increases 50x.

---

## 💡 Key Takeaways

* Queue length grows toward infinity as arrival rate approaches service rate; at 95% utilization expect 19x longer queues than at 50%
* Little's Law ($L = \text{throughput} \times \text{latency}$) determines concurrent capacity needed; doubling throughput doubles required connections and memory
* Target 60 to 70% utilization in production; past 90% utilization, small load increases cause massive latency spikes due to queuing math
* Batching trades latency for throughput; collecting requests increases individual wait times but amortizes overhead across many operations

---

## 📌 Interview Tips

1. Use Little's Law to size connection pools: if you need 1000 RPS at 50ms latency, you need at least 50 connections; this shows you can do capacity math
2. When asked about scaling, mention the utilization cliff; explain why you would add capacity at 70% load rather than waiting for 90%
3. Discuss batching trade-offs for database writes; explain when you would accept higher latency for dramatically better throughput