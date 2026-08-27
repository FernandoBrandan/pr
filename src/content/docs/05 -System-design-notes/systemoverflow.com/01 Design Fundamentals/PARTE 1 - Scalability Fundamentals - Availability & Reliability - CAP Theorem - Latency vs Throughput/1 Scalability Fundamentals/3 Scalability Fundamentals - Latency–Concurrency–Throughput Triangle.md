# Little's Law and the Latency–Concurrency–Throughput Triangle

## Core Formula

**Little's Law:**
**Concurrency = Throughput × Latency**

When latency rises, you need proportionally more concurrent connections to maintain throughput. This explains why systems collapse under load.

---

## THE MATH IN ACTION

API serves **10,000 RPS** with **50ms latency**:

* Concurrency = 10,000 × 0.05 = **500**

You need **500 concurrent connections** to sustain this throughput.

Implications:

* Thread pool must handle 500 threads
* Connection pool must support 500 connections
* Memory must support 500 in-flight requests

---

## THE DEATH SPIRAL

Database slows down:

* Latency: **50ms → 200ms**
* Required concurrency: 10,000 × 0.2 = **2,000**

But:

* Thread pool caps at **1,000**
* Requests start queueing

Then:

* Queue time adds latency → **500ms total**
* New concurrency need: 10,000 × 0.5 = **5,000**
* Even more queuing

→ System spirals into failure

> **Key Insight:** Capacity problems manifest as latency first.
> Rising latency is the early warning. By the time requests fail, you are already deep in the spiral.

---

## PLANNING WITH THE FORMULA

Target:

* **20,000 RPS**
* **100ms p95 latency**

Calculation:

* Concurrency = 20,000 × 0.1 = **2,000**

Add **30% headroom**:

* Required capacity = **2,600 concurrent connections**

### Memory Planning

If each request uses **50KB**:

* 2,600 × 50KB = **130MB** just for request data
* (+ additional overhead)

---

## SERVICE TIME CEILING

Each request needs **10ms CPU** on **8 cores**:

* Max throughput = 8 × 100 = **800 RPS**

More threads **do not help** when CPU-bound.

Solutions:

* Optimize code
* Add more servers

---

## Rule of Thumb

* Keep **p99 < 5× p50**

Example:

* p50 = 40ms
* p99 should stay below **200ms**

Exceeding this signals **tail latency problems**.

---

## Little's Law Visualization

```
Little's Law: L = λ × W
Concurrency = Throughput × Latency
```

### Healthy System

* 10,000 RPS × 50ms = **500 in-flight**
* Pool capacity: OK

---

### Death Spiral

* 10,000 RPS × 200ms = **2,000 in-flight**
* Pool: **EXHAUSTED**

```
Latency ↑ → Queue ↑ → Resources ↓ → Cascade failure
```

---

# 💡 Key Takeaways

* ✓ Little's Law (Concurrency = Throughput × Latency) means doubling latency from **50ms → 100ms** doubles required concurrency from **500 → 1,000**
* ✓ Tail latency amplifies across microservices: 5 services with p99 = 200ms → ~1s end-to-end latency
* ✓ Provision **20–40% headroom**: 8K RPS peak → design for **10K–12K RPS**
* ✓ Target **p99 < 5× p50**; exceeding indicates GC pauses, slow queries, or contention issues
* ✓ CPU-bound services have hard ceilings: **8 cores × 10ms = 800 RPS**, adding threads won't help

---

# 📌 Interview Tips

1. Use the formula explicitly:

   * *"At 10K RPS with 50ms latency, we need 500 concurrent connections."*

2. Mention the **death spiral**:

   * Latency ↑ → Concurrency ↑ → Queue ↑ → Latency ↑

3. Size thread/connection pools from load:

   * **RPS × p99 latency + 30% headroom**

