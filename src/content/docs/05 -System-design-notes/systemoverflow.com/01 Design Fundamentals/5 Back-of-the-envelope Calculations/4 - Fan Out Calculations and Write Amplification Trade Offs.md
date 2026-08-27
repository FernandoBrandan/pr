---
title: title
description: description
---

## Fan Out Calculations and Write Amplification Trade Offs

### What is Fan-Out
Fan-out occurs when one operation triggers many downstream operations. A user with 10,000 followers posts an update. Two approaches exist:

- **Fan-out on write:** When the user posts, immediately write a copy to all 10,000 follower feeds. Expensive at write time, but reading a feed is instant (just fetch pre-computed list).

- **Fan-out on read:** Store the post once. When each follower opens their feed, query all accounts they follow and merge the results. Cheap to write, expensive to read.

The trade-off: fan-out on write is expensive at write time but cheap at read time. Fan-out on read is the opposite. Choose based on read/write ratio and latency requirements.

### Fan-Out Math
Consider a social network: 100M users, average 200 followers, 1% post daily. Daily posts: 1M. Fan-out on write: 1M posts × 200 followers = 200M writes/day = 2,300 writes/sec average, 10,000 writes/sec peak.

But distribution matters. Most users have few followers. A celebrity with 10M followers creates 10M writes from one post. At 100k writes/sec, propagation takes 100 seconds. Solution: use fan-out on read for high-follower accounts, fan-out on write for everyone else.

### Write Amplification
Write amplification is the ratio of actual disk/network writes to logical application writes. If storing a 1KB record requires writing 5KB total (to indexes, logs, and replicas), write amplification is 5x.

**Sources of write amplification:**
- **Indexes:** Each index on a table requires an additional write when you insert or update a row.
- **Replication:** 3 database replicas means every write happens 3 times.
- **Write-ahead logs:** Databases write data to a log file first (for crash recovery), then to the actual data file. That is 2x right there.

Calculate total write load: 10,000 writes/sec × 3 replicas × 2 indexes × 2 (log + data) = 120,000 actual writes/sec. This determines whether your storage can handle the load.

> **Key Insight:** Fan-out and amplification multiply. 1000 posts/sec × 1000 followers × 3 replicas × 2 indexes = 6 billion writes/day. Quick math reveals whether a design is feasible before you build it.

---

### 💡 Key Takeaways
- ✓ Fan-out on write: expensive writes, cheap reads; fan-out on read: cheap writes, expensive reads; choose based on read/write ratio
- ✓ Celebrity problem: one user with 10M followers creates 10M writes; use hybrid approach for high-follower accounts
- ✓ Write amplification = actual writes / logical writes; count indexes, replicas, WAL, compaction to get true write load
- ✓ Multiplicative effects compound: 1k posts × 1k followers × 3 replicas × 2 indexes = 6M writes; quick math catches infeasible designs

---

### 📌 Interview Tips
1. Calculate fan-out explicitly: '1M daily posts × 200 average followers = 200M writes/day = 2300 writes/sec, manageable for a single database'
2. Identify celebrity problem: 'Top 1% users have 1M+ followers; fan-out on write for them creates write storms; suggest hybrid approach'
3. Account for write amplification: 'Each user write hits 2 indexes plus 3 replicas = 6x amplification; 10k logical writes becomes 60k actual writes'

