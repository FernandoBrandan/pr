---
title: title
description: description
---

# CAP Failure Modes and Edge Cases

## Failure Mode

Split brain happens when a partition causes both sides to think they are the majority. If both sides accept writes, you get divergent histories requiring manual reconciliation.

## PREVENTING SPLIT BRAIN

CP implementations use term numbers (epoch counters). Each leader election increments the term. Nodes reject requests from stale terms. Quorum math prevents split brain: in a 5 node cluster, both sides cannot have 3 nodes, so only one can accept writes.

## SLOW NETWORKS AS PARTITIONS

CAP assumes binary state: working or partitioned. If RTT spikes to 500ms or a GC pause blocks for 3 seconds, this looks like a partition to algorithms with 300ms timeouts. Production sees RTT spikes above 100ms daily in large clusters.

Solution: adaptive timeouts using recent p99 RTT. Partial connectivity (can reach 2 of 3 nodes) needs different handling than total isolation.

Gray Failures: Soft partitions from congestion are more common than hard failures. Fixed timeouts cause unnecessary failovers.

## EVENTUAL CONSISTENCY CONFLICTS

Last-write-wins has a bug. Two clients update the same cart in partitioned zones. Zone A writes at timestamp 1000, Zone B at 1001 but its clock is 200ms behind (records 801). On reconciliation, 1001 wins and 801 is lost silently.

Better: version vectors. Each write includes which replicas have seen which versions. Conflicts detected and merged with application logic rather than dropped.

PACELC: If Partition, choose A or C. Else (normal), choose Latency or Consistency. Even without partitions, strong consistency costs 5-10ms latency.

## Split Brain: The Dangerous Failure Mode

```
Normal: 3-node cluster, Node B is leader (term 5)
A
B ★
C

↓ NETWORK PARTITION ↓

Side 1: Node A alone
A ★
Thinks it's isolated
Elects self leader
Term 6

Side 2: Nodes B + C
B ★
C
Still has old leader
Continues operation
Term 5

Problem: Both sides accept writes → divergent histories!
Solution: Quorum prevents this. Node A alone (1/3) cannot form majority. Only B+C (2/3) can accept writes.
```

# 💡 Key Takeaways

✓ Split brain occurs when both partition sides think they're majority. Proper CP systems use term numbers to detect stale leaders and reject conflicts.

✓ Slow networks (RTT spikes to 500ms) look like partitions to systems with 200ms to 300ms timeouts. This causes false failovers reducing availability.

✓ AP systems using last write wins lose data when clock skew exceeds 200ms during concurrent updates. Version vectors detect conflicts but require merge logic.

✓ PACELC extends CAP: during partitions choose A or C, during normal operation choose latency or consistency. Spanner is PC/EC, Cassandra is PA/EL.

# 📌 Interview Tips

1. When discussing CAP, mention PACELC to show depth: "CAP only covers partitions. PACELC adds the latency vs consistency trade-off during normal operation."

2. Know split brain prevention: "Each leader election increments a term number. Nodes reject commands from stale terms." This shows you understand the mechanism.

3. Mention gray failures: "Soft partitions from GC pauses or network congestion are more common than hard failures. Adaptive timeouts handle these better than fixed values."
