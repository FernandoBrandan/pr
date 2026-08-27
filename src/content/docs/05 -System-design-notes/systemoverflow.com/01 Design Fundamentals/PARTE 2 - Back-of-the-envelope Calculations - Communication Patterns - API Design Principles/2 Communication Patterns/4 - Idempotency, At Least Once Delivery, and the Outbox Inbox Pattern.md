## Idempotency, At Least Once Delivery, and the Outbox Inbox Pattern

Asynchronous messaging systems guarantee at least once delivery, meaning messages can be duplicated under consumer restarts, network partitions, or broker failover. A payment service that charges a card on each message arrival will double charge customers unless the handler is idempotent. Idempotency requires that processing the same message multiple times produces the same side effect as processing it once. Strategies include idempotency keys (unique per request, stored in a database to detect replays), versioned upserts (update entity only if incoming version is newer), and dedupe windows (cache recently processed message IDs for a TTL). LinkedIn handles trillions of Kafka messages daily with at least once semantics; consumers use sequence numbers per aggregate and dedupe keys to ensure idempotent processing.

A common failure mode is the dual write problem: a service updates its database and then publishes an event to a message broker in two separate operations. If the database commit succeeds but the publish fails (broker down, network partition), the system state diverges; the database reflects the change but downstream consumers never learn of it. If the publish succeeds but the database commit fails, consumers process an event for a change that never happened. The outbox pattern solves this by writing the domain change and an outbox record in a single local transaction. A separate relay process polls the outbox table and publishes events, retrying until successful. Consumers use the inbox pattern: record the message ID in an inbox table within the same transaction as applying the change, skipping replay of already processed IDs.

Salesforce enforces at least once delivery with 72 hour replay windows for platform events, allowing consumers to recover from failures by replaying from a known offset. Uber workflow orchestrators use idempotency tokens per step so retrying a failed payment authorization with the same token returns the original result without re charging. Implementing idempotency requires careful design: tokens must be scoped (per user, per order, per workflow instance), stored durably with TTLs, and checked before side effects. Without it, at least once delivery guarantees become at least once side effects, causing financial loss, duplicate notifications, and data corruption.

---

### 💡 Key Takeaways
- ✓ At least once delivery means duplicates are inevitable under consumer restarts and broker failover; non idempotent handlers (charge card, send email) cause real world damage when messages replay
- ✓ Idempotency strategies: idempotency keys stored in database to detect replays, versioned upserts that apply only if incoming version newer, dedupe windows caching processed message IDs with TTL for recent history
- ✓ Outbox pattern writes domain change and outbox record in single local transaction, then separate relay publishes from outbox; avoids dual write where database commit succeeds but event publish fails or vice versa
- ✓ Inbox pattern records processed message IDs in inbox table within same transaction as applying change; on replay, check inbox first and skip if already processed, guaranteeing exactly once side effects
- ✓ Salesforce platform events provide 72 hour replay window so consumers can recover by replaying from offset after failures; delivery is at least once with ordering per partition, requiring idempotent handlers
- ✓ Uber workflow steps use idempotency tokens scoped per workflow instance; retrying a payment authorization with same token returns original result without re charging, enabling safe automatic retries after transient failures

---

### 📌 Interview Tips
1. Payment service using outbox: transaction writes Order status=PAID and outbox row with PaymentCompleted event; relay publishes event to Kafka and deletes outbox row; if relay crashes, event republished on restart, consumers use inbox to dedupe
2. LinkedIn Kafka consumer processing ProfileUpdated event: check inbox table for message ID; if present, skip; else update search index and insert message ID into inbox in single transaction, ensuring index updated exactly once despite message replays
3. Uber trip workflow retries payment authorization step with idempotency token derived from trip ID and step sequence; payment gateway returns 200 with original authorization code if token matches prior successful charge, avoiding double billing
