# Designing for Availability and Reliability

## Design Principle

Availability comes from redundancy (no single points of failure). Reliability comes from correctness guarantees (validation, transactions, testing). Different problems, different techniques.

---

## DESIGNING FOR AVAILABILITY

* **Redundancy:** Run multiple instances. If one dies, others handle traffic. Minimum 3 instances for critical services (survives 1 failure while keeping quorum).

* **Failover:** Detect failures and route around them automatically. Health checks every 5-10 seconds, remove unhealthy nodes within 30 seconds.

* **Geographic distribution:** Spread across zones or regions. Zone outage should not take you down. Requires data replication and smart traffic routing.

---

## DESIGNING FOR RELIABILITY

* **Input validation:** Reject bad data at the boundary. Do not let garbage propagate.

* **Idempotency:** Make operations safe to retry. Payment timeout and retry should not double-charge. Use idempotency keys.

* **Transactions:** Group related operations atomically. All succeed or all fail. No partial state.

* **Testing:** Unit tests for logic, integration tests for interfaces, chaos engineering for resilience.

> **Trade-off:** Reliability techniques can hurt availability. Transactions lock data causing timeouts. Strict validation rejects requests loose validation accepts. Balance based on requirements.

---

## GRACEFUL DEGRADATION

Under stress, shed load gracefully. Return cached data instead of failing. Disable non-critical features. Show simpler pages. Partial functionality beats total failure.

---

## Multi-AZ Active-Active Deployment

```id="9s3k2f"
AZ-1 (us-east-1a)
API Servers (3)
33% traffic
50% CPU util
DB Replica
Read traffic

AZ-2 (us-east-1b)
API Servers (3)
33% traffic
50% CPU util
DB Primary
Write traffic

AZ-3 (us-east-1c)
API Servers (3)
33% traffic
50% CPU util
DB Replica
Read traffic

After AZ-2 Failure:
AZ-1 and AZ-3 each handle 50% traffic at 75% CPU
DB replica in AZ-1 or AZ-3 promoted to primary (RTO: 30s)
```

---

# 💡 Key Takeaways

* ✓ Deploy across independent failure domains (Availability Zones with separate power, network, cooling). Maintain 30% to 50% surge headroom so remaining zones absorb traffic when one fails without overload.
* ✓ Active-active serves from all replicas simultaneously with zero failover time but requires conflict free state and costs 2x to 3x capacity. Active-passive is simpler and cheaper but has 30 second to several minute failover delay and cold cache performance hit.
* ✓ MTTR dominates availability. MTBF of 6 months with MTTR of 4 hours gives 99.91%, reduce MTTR to 10 minutes and availability jumps to 99.998%. Automate failover to achieve sub minute Recovery Time Objective (RTO).
* ✓ Synchronous replication doubles write latency (1 to 5ms added) and reduces availability during partitions, but guarantees zero data loss (RPO of 0). Asynchronous replication keeps writes fast but risks seconds to minutes of data loss on primary failure.
* ✓ Health checks must test actual request paths (database, cache, dependencies), not just process liveness. Use readiness checks (remove from load balancer) separate from liveness checks (restart process). Check every 1 to 2 seconds for sub 10 second failure detection.

---

# 📌 Interview Tips

1. Separate the concerns:
   *"Redundancy gives availability, validation gives reliability. We need both but they are different techniques."*

2. Mention idempotency for payments:
   *"Every payment API must be idempotent. Retries after timeout should not double-charge. We use idempotency keys."*

3. Discuss graceful degradation:
   *"Under load, we shed non-critical features and serve cached data. Partial functionality beats total failure."*
