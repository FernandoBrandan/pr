# CAP Choices Per Subsystem: Mixing CP and AP

## Key Insight

In production systems, you rarely make one global CAP choice. Instead, you pick CP or AP per subsystem based on correctness requirements and latency targets.

## SUBSYSTEMS THAT NEED CP

Payments and ordering: Double-charging or overselling costs money and trust. These services use CP with leader-based replication. During partitions, the system rejects orders rather than risk inconsistency. Config: 5 replicas, 3 acknowledgments required, 15-30ms write latency.

Inventory management: Selling the last item twice creates problems. Strong consistency prevents this, even if some orders are rejected during network issues.

## SUBSYSTEMS THAT CAN USE AP

Product catalog: Showing a product that went out of stock 2 seconds ago is fine. AP semantics with 10-20ms reads. During partitions, all zones serve, clients may see slightly stale data.

Recommendations: User preferences lagging by seconds is invisible. Speed matters more than perfect freshness.

Tunable Consistency: Modern databases let you choose consistency per operation. Session storage might default to AP (5ms) but use CP for checkout (15ms). Tune based on data importance.

## AVAILABILITY MATH

CP at 99.9% = 8 hours downtime per year. AP at 99.99% = 52 minutes per year. The 10x availability difference is the cost of strong consistency. Choose based on what your subsystem can tolerate.

## E-Commerce: Mixed CP + AP Architecture

```
User Request
↓
CP (Consistency)
Payments
No double-charging
Inventory
No overselling
Order Service
Exactly-once
15-30ms | Errors during partition

AP (Availability)
Product Catalog
Stale data OK
Recommendations
Speed > freshness
Session/Cart
Merge conflicts later
1-5ms | Always responds
```

Result: Same app uses CP for money, AP for browsing. Pick per subsystem, not globally.

# 💡 Key Takeaways

✓ Production systems make CP versus AP choices per subsystem, not globally. Financial data uses CP, user content feeds use AP.

✓ At 200k requests per second peak, even 10ms of added latency from CP consensus costs capacity. You pay for consistency with throughput.

✓ Tunable consistency lets you choose per operation: eventually consistent reads at 5ms p99, strongly consistent reads at 15ms p99 with lower availability.

✓ Systems like Netflix use AP stores for viewing history (tolerate seconds of lag) but CP for billing (cannot miss or duplicate charges).

# 📌 Interview Tips

1. When designing a complex system, explicitly call out which subsystems are CP vs AP: "Payments need CP for consistency, product catalog can be AP for speed."

2. Mention per-operation tuning: "Most reads use eventual consistency for speed, but checkout validation uses strong consistency to prevent overselling."

3. Know the availability math: CP systems at 99.9% availability have 8 hours downtime per year. AP at 99.99% has 52 minutes. The trade-off is quantifiable.
