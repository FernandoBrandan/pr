
## Critical Failure Modes and Mitigation Strategies

Production distributed lock systems fail in predictable patterns that must be explicitly designed for. The most severe is split brain holder scenarios: a client experiences a 2 to 5 second garbage collection pause or network partition, its lease expires, a new client acquires the lock, and the old client resumes writing. Without mitigation, this causes data corruption, inventory errors, or financial discrepancies. Mandatory mitigation is fencing tokens verified by the protected resource on every write, combined with idempotent operations so retries after rejection produce correct state. Google prevents Bigtable tablet split brain by requiring masters to present Chubby sequence numbers with every tablet operation.

Clock skew and time based expiration create subtle bugs when systems rely on client clocks to compute lease expiration. A client with a fast clock may believe its lease is valid while the server already expired it, or vice versa. Production systems must rely exclusively on server side monotonic time for lease state and avoid trusting client absolute time. Long garbage collection pauses and operating system scheduler stalls (2 to 5 seconds or more) can exceed short leases, causing unintended preemption mid operation. Set lease Time To Live (TTL) with headroom for worst case pauses, renew proactively at 25 to 33 percent of TTL, and emit renewal slack metrics to detect when renewals happen dangerously close to expiration.

Network partitions and leader failover cause consensus clusters to take seconds (often 5 to 15 seconds) to elect new leaders, during which lock acquisitions fail or timeout. Clients must handle transient unavailability with retries using jittered exponential backoff and must not assume acquisitions succeed quickly. Budget for acquisition latencies spiking to seconds during failovers in your Service Level Objectives (SLOs). Multi region topology dramatically worsens this: cross region consensus increases p99 latency to 100 to 300 milliseconds even in healthy state, and regional partitions can strand holders indefinitely. Prefer regional locks protecting regional resources, using global locks only when cross region serialization is strictly required. Test with chaos engineering: inject delays, pause processes for 1 to 10 seconds, drop packets, simulate leader failover, and verify no split brain writes occur and progress resumes within your failover budget.

### 💡 Key Takeaways

- Split brain holder is the most severe failure: old holder pauses for 2 to 5 seconds due to garbage collection or partition, lease expires, new holder acquires, old holder resumes writing and corrupts data without mandatory fencing
- Clock skew between clients and servers causes incorrect lease expiration decisions; production systems must use server side monotonic time exclusively and never trust client absolute time for lease state
- Garbage collection pauses of 2 to 5 seconds can exceed short leases; set TTL to at least 2 to 3 times worst case operation time, renew at 25 to 33 percent of TTL, emit renewal slack metrics
- Consensus cluster leader failover causes 5 to 15 second unavailability windows during which acquisitions fail; client code must retry with exponential backoff and budget failover time in SLOs
- Multi region consensus increases p99 to 100 to 300 milliseconds healthy state and risks indefinite partition; prefer regional locks for regional resources, global locks only when absolutely required
- Herding and thundering wake ups occur when many waiters wake simultaneously on lock release, spiking contention; mitigate with queueing or fairness mechanisms and jittered backoff

### 📌 Interview Tips

1. Google Bigtable: masters must present Chubby sequence number with every tablet operation; stale sequence rejected prevents split brain tablet serving after master lease expires during pause
2. Kubernetes leader election: 10 to 15 second lease period plus detection jitter results in 5 to 15 second failover; controllers must tolerate multi second acquisition spikes during etcd leader changes
3. Chaos testing scenario: pause lock holding process for 5 seconds, verify new holder acquires lock, old holder's writes rejected by fencing token check at protected resource