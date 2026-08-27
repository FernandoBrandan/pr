---
title: title
description: description
---

## What are Distributed Locks and Why Do They Need Leases?

Distributed locks provide mutual exclusion across multiple processes and machines by coordinating access to a named resource via an external coordination service. Unlike simple in-process mutexes, distributed locks must handle unreliable networks, partial failures, and process pauses that are impossible in single machine scenarios. The core safety property is ensuring at most one active holder for a lock name at any instant as observed by the protected resource.

Production systems use leases rather than indefinite ownership to handle failures gracefully. A client acquires a lock with a time bounded lease (typically 10 to 15 seconds) and must renew it periodically every 2 to 5 seconds. If the client crashes, experiences a long garbage collection pause, or becomes network partitioned, the lease expires automatically and another client can acquire the lock. Without leases, a crashed holder would block the resource indefinitely until manual intervention. Google Chubby uses session timeouts of 10 to 12 seconds with keepalives every few seconds, allowing thousands of clients per cell while automatically releasing locks from failed holders.

The challenge is balancing failover speed against false preemption. Shorter lease times (like 5 seconds) mean faster recovery when a holder truly fails, but risk unnecessary preemption during brief garbage collection pauses or network jitter. Longer leases (like 15 seconds) tolerate transient issues better but slow down failover. Most production systems converge on 10 to 15 second leases with renewal every 2 to 5 seconds, providing enough buffer for typical runtime pauses while keeping failover time acceptable for control plane operations.

### 💡 Key Takeaways

- Distributed locks coordinate access across machines and must tolerate network failures, process crashes, and pauses that never occur with single machine mutexes
- Leases with time bounded ownership (typically 10 to 15 seconds) automatically release locks from failed holders without requiring manual intervention or indefinite blocking
- Clients renew leases proactively every 2 to 5 seconds to maintain ownership, exposing renewal slack metrics to detect when renewal happens dangerously close to expiration
- Shorter lease times enable faster failover (5 to 10 seconds) but increase risk of false preemption during garbage collection pauses, while longer leases do the opposite
- Google Chubby demonstrates production viability with thousands of clients per cell using 10 to 12 second session timeouts and automatic release on disconnect
- Lease duration should be at least 2 to 3 times the worst case operation time plus p99 network and garbage collection pause budget to prevent premature expiration

### 📌 Interview Tips

1. Google Chubby running 5 Paxos replicas per cell with 10 to 12 second session timeouts, serving thousands of clients with automatic lock release on session expiration
2. Kubernetes leader election using etcd with 10 to 15 second lease periods and renewal every few seconds, resulting in 5 to 15 second failover windows during leader crashes
3. Amazon DynamoDB based locks using conditional writes with per item Time To Live (TTL), requiring periodic heartbeats to maintain ownership and automatic expiration on client failure
