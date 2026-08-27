Perfecto — lo organizo en **Markdown limpio**, sin modificar absolutamente nada del contenido 👇

---

# Hotspots and Skew: When One Shard Takes All the Heat

## Failure Mode

A hotspot occurs when one shard receives disproportionate traffic, becoming the bottleneck while other shards sit idle. Adding more shards does not help because the hot one remains overloaded.

---

## COMMON CAUSES

* Temporal skew: Sharding by date puts all writes on today's partition while yesterday's sits cold.
* Celebrity problem: One user has 10 million followers. Every post triggers millions of fan-out writes to their shard.
* Bad partition key: Sharding by country puts 50% of traffic on the US shard while others handle 5% each.

---

## DETECTING HOTSPOTS

Monitor per-shard metrics: QPS, latency, CPU, disk IO. If one shard shows 10x the load of others, you have a hotspot. Look for partition keys appearing in 20%+ of queries.

> **Warning Sign:** Adding shards does not improve throughput. Traffic is concentrated on one shard you cannot split further.

---

## SOLUTIONS

* **Composite partition keys:** Use user_id + random_suffix to spread one user's data across shards. Trade-off: queries now hit multiple shards.

* **Write sharding with read aggregation:** Write hot data to many random shards. Aggregate on read. Higher read latency but sustainable writes.

* **Dedicated hot partition:** Give the hot shard beefy hardware. Accept asymmetry when simpler than re-architecting.

* **Caching layer:** For read hotspots, cache hot data so 99% of reads never reach the overloaded shard.

---

## Key Insight

Perfect distribution is impossible. Design for skew, monitor for hotspots, and have a playbook ready before the celebrity signs up.

---

## Hotspot: Uneven Shard Distribution

```id="4r6h5u"
Incoming Traffic (e.g., celebrity post goes viral)
↓ ↓ ↓↓↓↓ ↓

Shard 1   5% load
Shard 2   10% load
Shard 3   80%  HOTSPOT!
Shard 4   5% load

Problem: Adding more shards won't help - the hot key still goes to one shard!
```

---

# 💡 Key Takeaways

* ✓ Hotspot occurs when one shard receives disproportionate traffic (80% instead of expected 10%), causing latency spike from 10ms to 500ms on that shard while other shards remain underutilized
* ✓ Hash based partitioning distributes keys evenly but cannot prevent access skew; celebrity accounts or viral content can generate 1,000× more traffic than average users, concentrating load on a single shard
* ✓ Application level caching for hot keys: detect entities exceeding 1,000 queries per second (QPS) threshold and cache in Redis with short Time To Live (TTL), absorbing traffic spikes before they hit the database shard
* ✓ Key salting replicates hot entities across multiple shards (user:12345:replica_0, user:12345:replica_1, user:12345:replica_2) and randomly picks replica for reads, spreading load at cost of write complexity updating all replicas
* ✓ Monitor per shard metrics and alert when any shard exceeds 2× average load or distribution variance exceeds 50% of mean; hotspots often emerge gradually as usage patterns shift over weeks or months

---

# 📌 Interview Tips

1. When discussing sharding, always mention potential hotspots:
   *"If we shard by user_id, celebrity accounts could create hotspots."* This shows real-world awareness.

2. For time-based data, explain why timestamp sharding fails:
   *"All writes hit todays partition."* Suggest composite keys mixing time with entity ID.

3. Know detection methods: per-shard metrics showing 10x load imbalance, partition keys appearing in 20%+ of queries. Monitoring is as important as prevention.
