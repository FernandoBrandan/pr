# Failure Modes That Break Availability and Reliability

## Key Insight

Systems fail in predictable ways. Understanding failure modes helps you design defenses before incidents, not after.

---

## HARDWARE FAILURES

* Disks: 0.5-2% annual failure rate. In a 1,000 disk cluster, expect 5-20 failures yearly. Use replication or erasure coding.

* Servers: 2-4% annual failure rate. Memory errors, power supplies, motherboards. Mitigate with redundant servers and automatic failover.

* Network: Switch failures, cable cuts. Often cause partial outages where some servers cannot reach others.

---

## SOFTWARE FAILURES

* Memory leaks: Gradual degradation until OOM kill. Metrics look fine until sudden death.

* Deadlocks: System appears up but stops processing. Health checks pass, requests hang forever.

* Bad deployments: New code with bugs. Often the #1 outage cause. Fix with canary deploys, feature flags, quick rollback.

---

## CASCADING FAILURES

Service A slows down. Callers timeout and retry. Retries add load. More timeouts, more retries. A collapses. Now its callers fail. Failure cascades upstream until everything is down.

Prevention: circuit breakers (stop calling failing services), bulkheads (isolate failures), load shedding (reject excess traffic).

> **The Danger:** Cascading failures turn small problems into total outages. One slow database query can take down your entire system without circuit breakers.

---

## HUMAN ERROR

60-80% of outages involve human error: misconfigs, wrong commands, accidental deletions. Mitigate with automation, infrastructure code review, and easy rollback.

---

## Cascading Failure Timeline

```id="9y1q2x"
t=0s
Service B: Database query slows to 5s

t=10s
Service A: Thread pool 80% full waiting on B

t=25s
Service A: Queue full, requests timing out

t=40s
Clients: Aggressive retries, A receives 3x traffic

t=60s
Total collapse: A, B, and dependent services C, D all down
```

---

# 💡 Key Takeaways

* ✓ Gray failures pass health checks but misbehave in production (slow responses, corrupted data). Mitigate with multi signal health (success rate, p99 latency, saturation) and synthetic canaries testing real request paths.
* ✓ Cascading failures occur when one slow service saturates upstream thread pools and queues. Prevent with bounded queues, request deadlines, circuit breakers, and bulkheads isolating failure domains.
* ✓ Retry storms amplify load during recovery. Use exponential backoff with jitter, server-side concurrency limits, and idempotency keys. Distinguish transient errors (retry) from permanent errors (fail immediately).
* ✓ Split brain during partitions creates dual primaries accepting conflicting writes. Use consensus protocols with quorum rules and fencing tokens. Data corruption replicates quickly; implement end to end checksums, read after write verification, and background reconciliation.
* ✓ Brownouts are technically available but too slow to be useful (p99 latency 30 seconds, all requests return HTTP 200). Track latency SLOs, not just uptime. Implement load shedding and request deadlines to fail fast when overwhelmed.

---

# 📌 Interview Tips

1. Categorize failures in your design:
   *"Hardware fails randomly, software fails on deploy, cascading failures amplify small issues. Each needs different defenses."*

2. Mention specific rates:
   *"Disks fail at 0.5-2% annually, servers at 2-4%. In a 1000 node cluster, plan for weekly hardware failures."*

3. Emphasize cascading failures:
   *"A slow dependency without circuit breakers can take down everything. This is the most dangerous failure mode."*
