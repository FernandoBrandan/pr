## Multi Tenant Fairness, Replay Windows, and Noisy Neighbor Isolation in Event Platforms

Multi tenant event platforms like Salesforce platform events must enforce fairness to prevent a single high volume tenant from starving others. Shared Kafka partitions or message brokers can be saturated by one tenant publishing millions of events per hour, consuming bandwidth and broker CPU that delays delivery for all other tenants. Mitigation requires per tenant quotas (maximum events per hour, maximum message size), per subscription throttling (max delivery rate per consumer), and partition affinity or tenant specific partitions to isolate blast radius. Salesforce enforces rate limits per tenant and per event type, shedding low priority traffic first and providing backpressure signals (429 errors) so publishers can retry with exponential backoff.

Replay windows allow consumers to recover from failures by re consuming events from a known offset over a retention period. Salesforce provides 72 hour replay for platform events; if a consumer crashes or falls behind, it can replay from its last committed offset without operator escalation. This shifts operational burden from manual recovery (restore from backup, replay logs) to self service. LinkedIn Kafka retains messages for days to weeks depending on topic criticality, with typical retention of 7 days for application events and longer for audit logs. Consumers track offsets per partition; on restart, they resume from the last committed offset. At least once delivery semantics require idempotent consumers since replayed messages may duplicate recent processing.

Noisy neighbor problems arise when one tenant or event type dominates shared resources. A tenant publishing profile updates at 10000 events per second can saturate a partition that also serves low volume tenants publishing critical alerts at 10 events per second. Partition keys must balance load; hashing tenant ID spreads tenants across partitions, but a single large tenant can still hotspot a partition. Solutions include dedicated partitions for high volume tenants, key splitting (shard large tenant across multiple logical keys), and priority lanes (separate partitions for critical vs bulk events). Salesforce uses per tenant and per event type quotas with automated subscription throttling; consumers that lag excessively trigger alerts and can be automatically paused to prevent backpressure collapse.

---

### 💡 Key Takeaways
- ✓ Multi tenant event platforms enforce per tenant quotas (max events per hour, max message size) and per subscription throttling (max delivery rate per consumer) to prevent one tenant from saturating shared partitions and starving others
- ✓ Salesforce platform events provide 72 hour replay window; consumers recover by replaying from last committed offset without operator escalation, shifting recovery from manual (restore backup) to self service
- ✓ Replay with at least once delivery produces duplicates; consumers must be idempotent using dedupe keys or inbox pattern to handle replayed messages that may duplicate recent processing
- ✓ Noisy neighbor isolation requires partition affinity or tenant specific partitions; hashing tenant ID spreads load but single large tenant can still hotspot partition, requiring key splitting or dedicated partitions for high volume tenants
- ✓ Priority lanes separate critical events from bulk; critical alerts on dedicated partition with low latency SLO, bulk analytics on separate partition with higher lag tolerance, preventing bulk from delaying critical delivery
- ✓ LinkedIn Kafka retains messages for 7 days for application events, longer for audit logs; consumers track offsets per partition and resume from last committed offset on restart, enabling recovery and reprocessing without data loss

---

### 📌 Interview Tips
1. Salesforce tenant publishing 10000 profile change events per hour hits per tenant quota; subsequent publishes return 429 error with retry after header, forcing publisher to back off and preventing saturation of shared partition
2. LinkedIn consumer processing ProfileUpdated events crashes; on restart, resumes from last committed Kafka offset 3 hours prior, replays 3 hours of events with idempotent handler that skips already applied updates using version numbers
3. Multi tenant SaaS with shared Kafka: tenant A publishes 1000 events per second, tenant B publishes 10 per second; partition key is tenant ID, but tenant A hotspots partition 5, delaying tenant B; solution splits tenant A across 10 logical keys to distribute load