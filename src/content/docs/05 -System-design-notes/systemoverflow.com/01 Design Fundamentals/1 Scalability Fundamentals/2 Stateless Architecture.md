---
title: title
description: description
---

# Stateless Architecture: The Foundation of Horizontal Scaling

## Core Principle

A stateless service stores no client data between requests. Every request contains all information needed to process it. Any server can handle any request, enabling free load balancer routing.

---

## WHY STATELESS ENABLES SCALING

Stateful servers remember things between requests: carts, sessions, cached data. If Server A remembers your cart, you must always return to Server A (sticky sessions).

* Server A fails → Cart vanishes
* Server A overloaded → Cannot shift traffic elsewhere

Stateless servers have none of these problems:

* Add a server → Immediately route traffic to it
* Server fails → Route to another
* No coordination → Each request is self-contained

---

## WHERE DOES STATE GO?

State moves to dedicated stores:

### Session state

* Redis or Memcached
* Sub-millisecond reads
* Automatic expiration
* Any server fetches session from shared store

### Persistent data

* Databases
* Cart items, profiles
* Replicated for durability

### Client state

* JWTs or cookies
* User carries their auth token
* Server verifies signature without database lookup

> **Trade-off:** Externalizing state adds network hops.
> Fetching session from Redis adds **0.5 to 2ms per request**.
> For most applications, this is negligible compared to the scaling flexibility gained.

---

## STATELESS IN PRACTICE

A stateless API:

1. Receives request with JWT
2. Validates signature locally
3. Fetches data from database or cache
4. Computes response
5. Returns it

Remembers nothing → *Process, forget, repeat.*

---

## Key Test

> Can you kill any server at any time without losing user data or breaking sessions?

* **Yes** → You are stateless
* **No** → Find the hidden state and externalize it

---

## Stateless Architecture (Flow)

```
Request + JWT Token
(All context travels with request)
        ↓
   Load Balancer
(Routes to ANY available server)
     ↙   ↓   ↘
 Server1 Server2 Server3
 No state No state No state
     ↓      ↓      ↓
   Redis   PostgreSQL   JWT
 Sessions  Persistent   Self-contained
           Data
```

> **Key insight:** Server crashes? No problem. Load balancer routes to another.

---

# 💡 Key Takeaways

* ✓ Stateless services store no client data between requests, allowing any server to handle any request and enabling linear horizontal scaling without coordination overhead
* ✓ Externalize sessions to Redis (**100K to 300K ops/sec, sub-ms latency**), file uploads to S3 (**unlimited throughput, 99.99% availability**), and job state to message queues
* ✓ Sticky sessions indicate accidental statefulness; they prevent true horizontal scaling and create single points of failure
* ✓ JWTs enable stateless authentication by encoding user identity in signed tokens that any server can verify without querying a central session store
* ✓ The latency cost of external state (**0.5 to 2ms per Redis lookup**) is negligible compared to the scaling flexibility gained

---

# 📌 Interview Tips

1. When designing any web service, explicitly state:
   **"API servers will be stateless"** early. This signals you understand horizontal scaling fundamentals.

2. If asked where session data goes:

   * Redis with TTL for ephemeral state
   * JWTs for auth tokens validated without DB lookups

3. Common follow-up: **"What if Redis fails?"**

   * Session recreation from database
   * Graceful degradation
   * Multi-region Redis replication

