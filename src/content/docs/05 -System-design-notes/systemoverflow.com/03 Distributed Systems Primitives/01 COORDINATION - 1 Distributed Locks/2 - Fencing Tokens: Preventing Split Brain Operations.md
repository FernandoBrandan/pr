
## Fencing Tokens: Preventing Split Brain Operations

The most dangerous failure mode in distributed locking occurs when a client's lease silently expires due to a long garbage collection pause or network partition, a new client acquires the lock, but the old holder continues attempting writes to the protected resource. This split brain scenario can corrupt data, violate invariants, or cause financial errors. Simply having leases is insufficient because the old holder has no reliable way to know its lease expired, especially if the pause or partition affects its ability to receive notifications from the lock service.

Fencing tokens solve this by making each successful lock acquisition return a monotonically increasing sequence number. The protected resource (database, object store, or service) persists the highest token it has seen and rejects any operations carrying lower tokens. When the old holder finally wakes up and tries to write with token 42, but the new holder already wrote with token 43, the resource rejects the stale operation. This pushes the safety check to the resource itself rather than relying on the lock holder to correctly detect lease expiration. Amazon's DynamoDB lock client library generates monotonically increasing fencing tokens stored with each acquisition, and Google Chubby provides sequence numbers that clients include with protected operations.

Implementing fencing requires the protected resource to support token comparison. If protecting a database row, store the highest seen token in a column and check it atomically with updates using a compare and swap operation or transaction. If protecting an external API, the service must accept and validate tokens. The performance cost is minimal since it adds only one integer comparison per operation. The operational benefit is enormous: fencing transforms a potentially catastrophic split brain write into a safely rejected stale operation that can be retried with a fresh lock acquisition.

### 💡 Key Takeaways

- Split brain occurs when an old lock holder's lease expires silently (due to garbage collection pause or partition) while it continues writing, overlapping with a new holder who legitimately acquired the lock
- Fencing tokens are monotonically increasing sequence numbers issued with each lock acquisition, allowing resources to reject operations from stale holders by comparing token values
- The protected resource must persist the highest token seen and atomically reject writes with lower tokens, pushing safety enforcement to the resource rather than relying on lock holder awareness
- Amazon DynamoDB lock clients generate and store fencing tokens with each acquisition, while Google Chubby provides sequence numbers that Bigtable and other systems verify on writes
- Implementation requires minimal overhead: one integer comparison per protected operation, but prevents catastrophic data corruption from overlapping lock holders
- Fencing is essential for best effort locks on eventually consistent stores where partition safety is weak, and valuable defense in depth even for consensus backed locks

### 📌 Interview Tips

1. Database row protection: store highest_token column, update using WHERE highest_token < new_token to atomically reject stale writes from old lock holders
2. Amazon DynamoDB locks: conditional write creates lock item with monotonic token; heartbeats verify ownership; protected resources check token before applying mutations
3. Google Chubby sequence numbers: issued on lock acquisition and verified by Bigtable masters before committing tablet assignment changes, preventing split brain tablet serving

---
