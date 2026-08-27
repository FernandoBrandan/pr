---
title: title
description: description
---

## When to Use Distributed Locks vs Alternatives

Distributed locks introduce coordination overhead, latency, and operational complexity that are unnecessary for many problems. Before reaching for locks, consider whether simpler alternatives meet your requirements. Idempotency combined with deduplication handles many coordination problems: make operations safe to retry by using unique request IDs and deduplication windows, eliminating the need for locks around external API calls or job scheduling. Optimistic concurrency using version numbers or compare and swap operations works well when conflicts are rare and retries are cheap, avoiding coordination entirely in the common case and only retrying the occasional conflict.

Single writer partitioning through actors, queues, or consistent hashing serializes updates per resource key without explicit locks. Route all operations for inventory SKU 12345 to a single worker process or queue partition; that worker has implicit exclusive access without distributed coordination. This pattern scales linearly by adding partitions and avoids lock service bottlenecks. Transactional databases with conditional updates provide both mutual exclusion and atomicity when the protected resource already lives in the database; use database transactions with `WHERE version equals expected_version` rather than separate lock acquisition, especially when contention is low to moderate.

Use consensus backed distributed locks when violating the invariant has high blast radius (money movement, inventory correctness, schema migrations, master election) and 5 to 50 millisecond added latency is acceptable for control plane operations. Use best effort locks with mandatory fencing for coarse grained application coordination where occasional duplicate work is tolerable but conflicting writes must be rejected by the resource. Avoid locks entirely for high QPS data path operations: Google does not take Chubby locks on Bigtable read or write paths, only for infrequent master operations. The operational cost of running, monitoring, and debugging distributed locks is high; justify that cost with clear safety requirements and evidence that simpler alternatives are insufficient.

### 💡 Key Takeaways

- Idempotency with unique request IDs and deduplication windows eliminates lock needs for external API calls, job scheduling, and retry scenarios where operations are naturally retryable
- Optimistic concurrency using version checks or compare and swap avoids coordination overhead when conflicts are rare; only the occasional conflict pays retry cost
- Single writer partitioning via actors, queues, or consistent hashing gives implicit exclusive access per key, scaling linearly without lock service bottlenecks or coordination
- Transactional databases with conditional updates provide both mutual exclusion and atomicity when the resource is already stored there, avoiding separate lock acquisition for low to moderate contention
- Use consensus locks for high blast radius invariants (money, inventory, master election) where 5 to 50 millisecond control plane latency is acceptable; never for high QPS data path operations
- Operational cost of distributed locks is high (deployment, monitoring, debugging, capacity planning); justify with clear safety requirements and proof simpler alternatives insufficient

### 📌 Interview Tips

1. Idempotency example: job scheduler assigns unique run ID to each execution attempt, worker checks run ID in database before processing to deduplicate retries without locks
2. Optimistic concurrency: update inventory `SET quantity = new_value WHERE sku = X AND version = 42`; retry if version mismatch, avoiding lock acquisition overhead
3. Single writer partitioning: Kafka partitions orders by customer ID, giving each consumer partition exclusive access to its customer subset without distributed lock coordination
4. Database transactions: transfer money using `BEGIN; UPDATE accounts SET balance = balance - 100 WHERE id = A; UPDATE accounts SET balance = balance + 100 WHERE id = B; COMMIT;` provides mutual exclusion without external lock