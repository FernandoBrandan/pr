---
title: title
description: description
---

# What Are Latency and Throughput? Core Definitions and Measurement

## Definition

Latency is the time from request start to response completion. Throughput is the number of operations completed per unit time. These are the two fundamental metrics that define system performance.

## Why These Metrics Matter

Think of a highway: latency is how long your car takes to travel from point A to point B, while throughput is how many cars pass a checkpoint per hour. A highway with high throughput (six lanes) can still have high latency (traffic jam). Optimizing one often hurts the other.

Users feel latency directly. A 100ms response feels instant, 300ms feels sluggish, and 1000ms feels broken. Meanwhile, throughput determines whether your system survives traffic spikes. A system handling 1,000 requests per second will crash under 10,000 RPS load regardless of how fast each individual request completes.

## Measuring Latency Correctly

Average latency lies. If 99 requests take 10ms and 1 request takes 1000ms, the average is 20ms but users experience 1000ms 1% of the time. Use percentiles instead: p50 (median), p95, and p99.

* **p50:** Half of requests are faster than this. Shows typical experience.
* **p95:** 95% of requests are faster. Shows what most users experience.
* **p99:** 99% of requests are faster. Shows worst case for nearly everyone.

A healthy API might show: `p50=15ms`, `p95=45ms`, `p99=120ms`. If p99 is 10x higher than p50, you have tail latency problems that will compound in distributed systems.

## Measuring Throughput

Throughput is measured in operations per second: RPS (requests per second), QPS (queries per second), or TPS (transactions per second). The maximum sustainable throughput is your system's capacity.

Peak throughput is misleading. A system might handle 10,000 RPS briefly but only sustain 5,000 RPS before queues grow unbounded and latency explodes. Always measure sustained throughput under steady state conditions, not burst capacity.

> **Key Insight:** Latency and throughput are connected through queuing. As throughput approaches capacity, latency increases exponentially, not linearly. At 80% capacity, expect 4x the latency compared to 50% capacity.

---

## 💡 Key Takeaways

* Latency is time per operation (milliseconds), throughput is operations per time unit (requests/second); optimizing one often hurts the other
* Use percentiles (p50, p95, p99) instead of averages; averages hide tail latency that compounds in distributed systems
* As throughput approaches capacity, latency grows exponentially due to queuing; at 80% utilization expect 4x latency versus 50%
* Sustained throughput matters more than peak; systems often handle 2x their sustainable capacity briefly before collapsing

---

## 📌 Interview Tips

1. When discussing performance requirements, always ask for both latency targets (p99 < 100ms) AND throughput targets (5000 RPS); systems optimized for only one will fail at the other
2. Mention Little's Law: `concurrent_requests = throughput × latency`; this shows you understand how the metrics connect mathematically
3. Explain why you would measure p99 over average; this demonstrates awareness of tail latency issues in microservices