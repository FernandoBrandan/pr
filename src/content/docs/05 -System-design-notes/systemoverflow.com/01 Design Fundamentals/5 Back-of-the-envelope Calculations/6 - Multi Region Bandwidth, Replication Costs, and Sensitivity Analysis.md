---
title: title
description: description
---


## Multi Region Bandwidth, Replication Costs, and Sensitivity Analysis

### Cross-Region Bandwidth Costs
Bandwidth within the same region is essentially free at cloud scale. Bandwidth between regions (US East to US West, or US to Europe) costs money: roughly $0.02-$0.10 per GB depending on provider and distance. This adds up fast.

Calculate cross-region costs: 1M requests/day × 10KB average = 10GB/day. Single region: negligible cost. Replicate data to 3 regions for disaster recovery: 30GB/day cross-region = $0.60-$3/day = $18-$90/month. At 100M requests/day: $1,800-$9,000/month just for bandwidth.

Latency also matters. Cross-region communication adds 50-150ms per round trip. If you wait for data to be confirmed in all regions before acknowledging a write (synchronous replication), every write pays this latency cost. Most multi-region systems use asynchronous replication instead: acknowledge the write immediately, copy data to other regions in the background, accepting that a region failure might lose the most recent few seconds of writes.

### Replication Cost Math
When you replicate a database across 3 copies: storage triples (1TB becomes 3TB), write traffic triples (each write goes to all copies), but read capacity triples too (reads can go to any copy). For write-heavy workloads, replication multiplies your costs.

Network cost calculation: 10,000 writes/sec × 3 replicas × 1KB = 30MB/sec network traffic. Within same datacenter: free. Across regions: 30MB/sec × 3600 sec × 24 hr × $0.05/GB = $130/day. The math is simple but often overlooked until the bill arrives.

### Sensitivity Analysis
Your estimates depend on assumptions. What happens if those assumptions are wrong? Sensitivity analysis identifies which assumptions matter most so you know where to build margin.

Example: system sized for 10,000 RPS with 95% cache hit rate means database handles 500 RPS. If cache effectiveness drops to 80%, database load jumps to 2,000 RPS (a 4x increase). But if traffic grows 50% to 15,000 RPS with same cache hit rate, database only sees 750 RPS (1.5x increase). Cache effectiveness is more sensitive than traffic growth.

> **Key Insight:** Present estimates as ranges, not single numbers. Say "we need 10 servers at baseline, 20 if traffic doubles, 40 if cache fails." This shows you understand uncertainty and builds confidence in your capacity planning.

---

### 💡 Key Takeaways
- ✓ Cross-region bandwidth costs $0.02 to $0.10 per GB; 100M requests/day at 10KB = $1,800 to $9,000/month for 3-region replication
- ✓ 3 replicas = 3x storage, 3x write amplification, but reads scale linearly; factor replication into capacity math
- ✓ Sensitivity analysis: check 2x traffic, 2x slowdown, and dependency failure scenarios to identify tight margins
- ✓ Cache hit rate often more sensitive than traffic: 95% to 80% hit rate = 4x database load; 1.5x traffic at same hit rate = only 1.5x load

---

### 📌 Interview Tips
1. Calculate replication costs: '10k writes/sec × 3 replicas × 1KB × $0.05/GB cross-region = $130/day; factor this into budget'
2. Present estimates as ranges: 'Baseline 10 servers, 20 if traffic doubles, 40 if cache effectiveness degrades'
3. Identify sensitive assumptions: 'Our design depends on 95% cache hit; at 80% we need 4x database capacity; let us discuss cache warming strategy'