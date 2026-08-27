## Capacity Sizing and Latency Budgeting Across System Tiers

### Server Capacity Benchmarks
A single application server handles 1,000-10,000 RPS depending on request complexity.
- Simple API returning cached data: 10,000 RPS.
- Complex business logic with database queries: 1,000 RPS.
- CPU intensive processing: 100-500 RPS.

Web servers (serving static files): 50,000-100,000 RPS.
Load balancers: 100,000-1,000,000 connections.

These establish your baseline: if you need 50,000 RPS for an API, plan for 5 to 50 application servers depending on complexity.

### Database Capacity
- Single SQL database: 10,000-50,000 simple reads/sec, 1,000-5,000 writes/sec.
- Complex queries with joins drop read capacity to 1,000-5,000/sec.
- Writes are bottlenecked by disk durability requirements.

Read replicas multiply read capacity linearly: 3 replicas = 3x read throughput. Write capacity does not scale this way; writes must go to primary and replicate to followers. This is why read-heavy workloads scale easier than write-heavy ones.

### Cache Capacity
- Redis single instance: 100,000+ ops/sec.
- Memcached: similar throughput.

A single cache server often handles more load than 10 database servers, which is why caching is so powerful.

**Memory sizing:**
- 1M items × 1KB = 1GB.
- Add overhead (Redis uses ~2x raw data size for structures) = 2GB.
- For 100 million items: 200GB, likely needs clustering across multiple nodes.

### Latency Budget Allocation
Total user-facing latency target: typically 100-300ms.

Break down across tiers:
- CDN/edge: 5-20ms
- Load balancer: 1-5ms
- Application server: 10-50ms
- Cache lookup: 1-5ms
- Database query: 10-50ms
- Response serialization: 5-10ms

Network round trips add up. Same datacenter: 0.5ms per hop. Cross-region: 50ms per hop. A request hitting 3 services adds 1.5ms in datacenter but 150ms cross-region. Minimize hops, colocate services that communicate frequently.

> **Key Trade-off:** Capacity and latency compete. Running servers at 80% capacity increases latency due to queuing. Budget for 60-70% utilization to maintain consistent latency under normal load.

---

### 💡 Key Takeaways
- ✓ Application server: 1k to 10k RPS depending on complexity; database: 10k to 50k simple reads, 1k to 5k writes per second
- ✓ Redis handles 100k ops/sec, often 10x more than database servers; this is why caching dramatically improves capacity
- ✓ Read replicas scale reads linearly but writes must go to primary; write-heavy workloads are fundamentally harder to scale
- ✓ Latency budget: 100 to 300ms total divided across tiers; cross-region hops add 50ms each, same datacenter adds 0.5ms

---

### 📌 Interview Tips
1. Size a system quickly: 'We need 10k RPS, complex logic means 1k per server, so about 10 application servers plus margin'
2. Justify caching: 'Database handles 10k QPS, cache handles 100k. Cache hit rate of 90% lets one DB support 100k effective QPS'
3. Allocate latency budget: '200ms target minus 50ms network minus 20ms CDN leaves 130ms for application and database combined'