# Real World Latency and Throughput Numbers Every Engineer Should Know

## Latency Reference Table

Here is the latency table every engineer should memorize:

| Operation | Latency (ns) |
| --- | --- |
| L1 cache reference | 0.5 ns |
| L2 cache reference | 3 ns |
| Branch mispredict | 5 ns |
| Mutex lock/unlock (uncontended) | 15 ns |
| Main memory reference | 50 ns |
| Compress 1K bytes with Snappy | 1,000 ns |
| Read 4KB from SSD | 20,000 ns |
| Round trip within same datacenter | 50,000 ns |
| Read 1MB sequentially from memory | 64,000 ns |
| Read 1MB over 100 Gbps network | 100,000 ns |
| Read 1MB from SSD | 1,000,000 ns |
| Disk seek | 5,000,000 ns |
| Read 1MB sequentially from disk | 10,000,000 ns |
| Send packet CA to Netherlands to CA | 150,000,000 ns |

## Key Patterns to Notice

* **1000x jumps:** Memory to SSD is 1,000x slower. SSD to disk is another 10x. Network round trip across continents is 3,000x slower than same datacenter.
* **Sequential vs random:** Reading 1MB sequentially from SSD (1ms) is 50x faster than random 4KB reads at the same total data.

> **Key Insight:** Memorize these orders of magnitude. In interviews, being able to say "cross-region is about 150ms round trip" or "SSD random read is 20 microseconds" demonstrates practical systems knowledge.

---

## 💡 Key Takeaways

* RAM access (100ns) to SSD (100μs) is 1000x slower; SSD to spinning disk is another 100x; this hierarchy drives all caching decisions
* Cross-region latency is 40 to 70ms, cross-continent 80 to 120ms; speed of light sets hard physical limits around 40ms US coast to coast
* Cache hit rate dramatically affects average latency: 95% hits = 3.45ms average, 99% hits = 1.49ms average when cache is 1ms and database is 50ms
* Single server benchmarks: web app 1k to 10k RPS, database 10k to 50k simple queries/sec, Redis 100k+ ops/sec

---

## 📌 Interview Tips

1. Quote specific latency numbers in design discussions; saying 'Redis adds about 1ms' or 'cross-region is 50ms' shows you understand real constraints
2. Use throughput numbers for capacity planning; if you need 100k RPS, explain why you need 10+ application servers or load balancing
3. When calculating cache benefit, show the math: 95% hit rate with 1ms cache and 50ms database yields 3.45ms average