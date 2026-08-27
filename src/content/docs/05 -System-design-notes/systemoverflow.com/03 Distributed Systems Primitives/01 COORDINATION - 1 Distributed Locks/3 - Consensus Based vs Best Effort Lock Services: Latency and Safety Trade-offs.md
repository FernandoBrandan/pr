---
title: title
description: description
---

## Consensus Based vs Best Effort Lock Services: Latency and Safety Trade-offs

Two fundamentally different architectures dominate production distributed lock implementations, each with distinct latency, safety, and availability characteristics. Consensus based lock services built on Paxos or Raft (like Google Chubby or etcd) replicate lock state across 3 to 5 nodes and require quorum agreement for acquisitions. Every lock acquisition involves at least one or two quorum round trips plus durable writes, resulting in p50 latencies of 2 to 5 milliseconds and p99 of 10 to 50 milliseconds within a region. The benefit is strong safety: even during network partitions within the quorum, at most one client holds the lock as observed by any majority. Leader failover takes several seconds (often 5 to 15 seconds) causing temporary unavailability, but recovery is predictable and correct.

Best effort locks use eventually consistent stores or in memory caches (like Redis or DynamoDB) with conditional writes and expirations. Acquisition is a single atomic operation against one or a few nodes, delivering p50 latencies under 1 millisecond and p99 of 1 to 3 milliseconds within an availability zone, handling hundreds of thousands to millions of operations per day. However, safety degrades during network partitions or node failures: two clients can simultaneously believe they hold the lock if nodes disagree or if failover races occur. Production teams mitigate this by always pairing best effort locks with fencing tokens and idempotent operations, treating the lock as an advisory hint rather than an absolute guarantee.

Choosing between them depends on your latency budget and blast radius. Google systems place only control plane operations like master election on Chubby, never high queries per second (QPS) data path operations, because single digit to tens of milliseconds overhead is acceptable for infrequent coordination but would cripple request serving. For low risk critical sections like deduplicating scheduled jobs or rate limiting, teams often use Redis backed locks with sub millisecond latency, accepting that occasional duplicate work may occur but ensuring conflicting writes are fenced at the resource. The key insight is that no lock service alone provides perfect safety; you must always implement fencing and idempotency at the protected resource regardless of which service you choose.

### 💡 Key Takeaways

- Consensus based locks (Paxos/Raft with 3 to 5 nodes) provide strong safety during partitions with p50 latency of 2 to 5 milliseconds and p99 of 10 to 50 milliseconds, plus 5 to 15 second failover windows
- Best effort locks (Redis, DynamoDB) deliver sub millisecond p50 and 1 to 3 millisecond p99 latency but can allow overlapping holders during partitions or failover races
- Consensus clusters sustain 10,000 to 20,000 write operations per second; best effort stores can handle hundreds of thousands to millions of lock operations per day per instance
- Google Chubby serves thousands of clients with cached reads in microseconds to sub millisecond, but writes and uncached reads hit the leader and take single digit to tens of milliseconds
- Production practice places only control plane operations (master election, configuration changes) on consensus locks, never hot data path operations that require sub millisecond latency
- Best effort locks require mandatory fencing tokens and idempotent operations to mitigate safety gaps, treating the lock as advisory rather than absolute guarantee of mutual exclusion

### 📌 Interview Tips

1. Kubernetes etcd clusters with 3 to 5 members: median lease write 2 to 5 milliseconds, p99 10 to 50 milliseconds, 10,000 to 20,000 ops/second sustained throughput for leader election
2. Redis based application locks achieving p50 under 1 millisecond within availability zone, used for deduplicating scheduled jobs with idempotency to handle rare overlaps
3. Google Chubby: control plane only usage for Bigtable master election and Google File System (GFS) master coordination, avoiding high QPS data path operations that cannot tolerate multi millisecond overhead