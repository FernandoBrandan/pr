---
title: title
description: description
---

# How CP and AP Systems Work

## Core Concept

CP systems use leader-based replication with quorum protocols. AP systems use leaderless replication with tunable consistency. The mechanisms differ fundamentally.

## HOW CP SYSTEMS WORK

A single leader accepts all writes. The leader replicates each write to followers and only commits when a majority acknowledges. In a 5 node cluster, majority is 3. Writes require 2 follower acknowledgments before returning success.

During a partition isolating 2 nodes from 3, only the 3 node side can form a majority. The isolated 2 nodes refuse writes and return errors. Clients see reduced availability, but the system never creates conflicting data.

Latency cost: Inter-region RTT of 50ms means writes take 50ms to 100ms. Within a region (1-2ms RTT), writes cost 5ms to 10ms at p99.

## HOW AP SYSTEMS WORK

Data replicates to N nodes (commonly 3). You configure write consistency W and read consistency R. Setting W=1 and R=1 gives maximum availability: writes return after one node acknowledges (1-2ms), reads return from whichever replica responds first.

During partitions, all nodes continue accepting requests locally. Clients get sub-10ms responses even when zones cannot communicate. The trade-off: writes in an isolated zone will not immediately appear elsewhere. Systems reconcile later using background sync processes that compare replica states and fix inconsistencies.

Key Insight: CAP trade-offs apply during partitions. When the network is healthy, many systems provide both consistency AND availability. The choice only matters when failures occur.

## THE NUMBERS

CP write latency: 5-30ms within region (quorum). AP write latency: 1-5ms (single node). This latency difference is measurable in every request.

## CP vs AP: How They Handle Partitions

```
CP System (5 nodes)
✓
✓
✓
✗
✗
3 nodes = majority ✓ | 2 nodes = minority ✗
Majority side: Accepts writes
Minority side: Returns errors
Latency: +50-100ms (quorum)

AP System (3 replicas)
✓
✓
✓
All zones keep serving (may diverge)
All zones: Accept writes locally
Later: Reconcile conflicts
Latency: 1-5ms (single node)
```

Key insight: Trade-offs only apply during partitions. Normal operation can have both C and A.

# 💡 Key Takeaways

✓ CP systems use majority quorum: in 5 node cluster, 3 must agree. Isolated minority (2 nodes) refuses writes to prevent conflicts.

✓ CP write latency within region is 5ms to 10ms at p99 for consensus. Cross region adds 50ms to 150ms RTT overhead.

✓ AP systems with W equals 1, R equals 1 provide 1ms to 2ms write latency and continue working even when most replicas are unreachable.

✓ AP systems reconcile conflicts after partitions heal using anti entropy, hinted handoff, and version vectors or last write wins.

# 📌 Interview Tips

1. When explaining CP vs AP, use concrete latency numbers: "CP adds 5-30ms for quorum writes, AP returns in 1-5ms but may serve stale data."

2. If asked how leader election works, explain: "Nodes vote, majority wins, each election increments a term number. Nodes reject commands from stale leaders."

3. For AP systems, mention conflict resolution: "Last-write-wins risks data loss with clock skew. Version vectors detect conflicts for application-level merging."
