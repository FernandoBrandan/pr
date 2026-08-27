## Critical Failure Modes: Queue Saturation, Hot Keys, and Cache Cold Start

### Queue Saturation
Queues absorb traffic bursts but have limits. When arrival rate exceeds processing rate for too long, queues fill. Once full, new requests are rejected or latency becomes unbounded.

Calculate queue growth: arrival rate 1,000 RPS, processing rate 800 RPS, deficit 200 RPS. Queue grows by 200 requests/sec. With 10,000 request queue limit, saturation in 50 seconds. If the burst lasts longer, you lose requests.

Prevention requires either increasing processing capacity, rejecting excess load (load shedding), or accepting that bursts beyond X seconds will cause data loss. Back-of-envelope math tells you which bursts you can survive.

### Hot Keys
Even load does not mean even distribution. A viral post might receive 1M reads/minute while everything else gets 1,000. If that post lives on one shard or cache node, that single node is overloaded while others are idle.

Calculate hot key impact: 1M reads/min = 16,666 reads/sec. If a single Redis node handles 100,000 ops/sec, you are at 17% capacity. Sounds fine. But if the hot key is one of 100 keys on that node, and normal distribution expects 1,000 ops/sec per node, this one key adds 16x the expected load.

**Solutions:** replicate hot keys across multiple nodes, cache hot keys at application layer, or use consistent hashing with virtual nodes to spread hot key load.

### Cache Cold Start
Empty cache means every request hits the database. If you normally have 95% cache hit rate handling 10,000 RPS, your database sees 500 RPS. Cold start: database sees 10,000 RPS, 20x normal load. This often crashes the database.

Calculate warming time: 10,000 unique items accessed per second, cache fits 1M items. Cold cache reaches 90% hit rate after 100 seconds (1M items / 10k items/sec). But can your database survive 10x load for 100 seconds?

**Mitigation:** warm cache from backup before switching traffic, gradually shift traffic during warming, or maintain standby cache that stays warm.

> **Key Trade-off:** All three failure modes share a pattern: normal operation hides capacity cliffs. Back-of-envelope math reveals these cliffs before production traffic finds them.

---

### 💡 Key Takeaways
- ✓ Queue saturation: 200 RPS deficit fills 10k queue in 50 seconds; calculate maximum survivable burst duration before design
- ✓ Hot keys concentrate load: one viral item at 16k RPS on node expecting 1k RPS creates 16x overload while other nodes idle
- ✓ Cold cache at 95% hit rate means 20x normal database load; calculate if database survives warming period before deploying
- ✓ Pattern: normal operation hides capacity cliffs; back-of-envelope math reveals them before production traffic does

---

### 📌 Interview Tips
1. Calculate queue saturation: 'At 1000 RPS arrival and 800 RPS processing, we can survive a 50-second burst before queue overflow'
2. Identify hot key risk: 'If one trending item gets 10k RPS and we have 10 cache nodes, even distribution gives 1k per node, but all traffic hits one node'
3. Plan cache warming: '10M items at 10k reads/sec takes 1000 seconds to warm; we need database to handle 10x load for 15+ minutes'

