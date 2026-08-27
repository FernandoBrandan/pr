# Scaling Decision Framework: When and How to Scale

## Key Question

When should you scale, and how? Scaling too early wastes money. Scaling too late causes outages. This framework uses concrete signals to guide decisions.

---

## WHEN TO SCALE: THE SIGNALS

* CPU above 70% sustained: Limited headroom for spikes. At 90%, a 20% traffic increase causes queueing.
* p99 rising faster than p50: Tail latency divergence signals resource contention.
* Connection pool exhaustion: Requests waiting for database connections.
* Memory pressure: Frequent GC pauses, swap usage, OOM kills.

---

## VERTICAL VS HORIZONTAL DECISION

**Scale vertically:**

* Single-threaded workloads.
* Data must stay on one node (ACID).
* Team lacks distributed expertise.
* Quick fix needed.

**Scale horizontally:**

* Workload parallelizable.
* Need fault tolerance.
* Approaching hardware ceiling.
* Need geographic distribution.

> **Common Mistake:** Scaling app servers when the bottleneck is the database. Adding 10 app servers hitting one overloaded database just increases database load. Find the bottleneck first.

---

## THE THREE SCALING DIMENSIONS

* **Compute:** More CPU, memory, instances for more requests.
* **Data:** Sharding, read replicas, caching for more data operations.
* **Network:** CDNs, edge caching for lower latency.

Most scaling addresses only one dimension. Identify which is your bottleneck before spending.

---

## Rule of Thumb

Maintain 30–40% headroom above peak. If you hit 70% capacity during peak, scale proactively. Reactive scaling during incidents often fails.

---

## When to Scale: Warning Signals

```
CPU          70%        Warning Zone
p99 Latency  Rising     Trending Up
Conn Pool    FULL       CRITICAL!
Memory       GC         GC Pressure
```

> Rule of thumb: Scale at 70% sustained utilization, not at 100% crisis.

---

# 💡 Key Takeaways

* ✓ Before scaling, optimize first: adding a database index takes minutes and costs nothing versus adding replicas which takes days and hundreds per month
* ✓ Scale triggers: CPU above 70%, memory above 80%, growing queue depth, p99 exceeding 5x p50, or error rates above 0.1% sustained for 15+ minutes at peak
* ✓ Below 5K requests per second vertical usually wins on total cost; 5K to 50K either works; above 50K horizontal becomes necessary regardless of preference
* ✓ Horizontal scaling hidden costs include configuration management, deployment complexity, monitoring overhead, and distributed system debugging skills
* ✓ Choose horizontal when you need 99.99%+ availability, geographic distribution, sustained throughput beyond single node limits, or workload isolation between tenants

---

# 📌 Interview Tips

1. Before proposing any scaling solution, identify the bottleneck first. Saying *"let me check if this is CPU, memory, or I/O bound"* shows systematic thinking.

2. Mention monitoring signals: CPU above 70%, p99 diverging from p50, connection pool exhaustion. This demonstrates production experience.

3. When asked to scale a system, always ask: *"Is this read-heavy or write-heavy?"* The answer determines whether caching, read replicas, or sharding is appropriate.
