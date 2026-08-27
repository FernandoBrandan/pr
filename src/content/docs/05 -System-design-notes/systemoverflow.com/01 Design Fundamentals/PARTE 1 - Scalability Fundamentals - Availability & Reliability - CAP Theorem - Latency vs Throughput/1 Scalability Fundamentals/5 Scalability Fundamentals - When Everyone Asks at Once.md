Perfecto — lo dejo en **Markdown limpio**, sin modificar absolutamente nada del contenido 👇

---

# Cache Stampede and Thundering Herd: When Everyone Asks at Once

## Failure Mode

A cache stampede (thundering herd) occurs when a cached item expires and hundreds of requests simultaneously regenerate it, overwhelming the backend. This can take down systems that normally handle load easily.

---

## HOW IT HAPPENS

Homepage cached with 60s TTL, serving 50,000 RPS. At second 61, cache expires. Before anyone regenerates, 500 requests arrive, all see cache miss, all query database simultaneously. Database handles 1,000 QPS normally but now gets 500 identical queries in 10ms. Database collapses.

---

## SOLUTION 1: LOCKING

On cache miss, acquire distributed lock before regenerating. Other requests wait or return stale data. Only one hits database.

Implementation: Redis SETNX with short TTL as lock.

* Lock acquired? Regenerate.
* Not acquired? Wait and retry cache.

---

## SOLUTION 2: PROBABILISTIC EARLY EXPIRATION

Regenerate before stampede happens. If TTL is 60s, at 55s randomly decide (10% chance) to regenerate proactively. By TTL expiry, fresh data is already cached. No stampede.

> **Trade-off:** Probabilistic expiration adds some unnecessary regenerations but prevents worst case thundering herd. Worth it for high traffic keys.

---

## SOLUTION 3: STALE WHILE REVALIDATE

Serve stale data while regenerating in background.

* Request comes in
* Cache expired
* Immediately return stale
* Trigger async refresh

User gets old data but instantly. Fresh data lands for next request.

Not suitable for real time data like pricing.

---

## Key Insight

High traffic keys need special handling.

* 10,000 RPS key → needs locking or probabilistic refresh
* 10 RPS key → can just let multiple requests regenerate

---

## Cache Stampede (Thundering Herd)

```id="7uyg9m"
Req 1   Req 2   Req 3   ...   Req N
 ↓↓↓↓
Cache Layer TTL EXPIRED - MISS!
 ↓↓↓↓
All N requests hit database!
  ↓
Database 💥 OVERWHELMED

N identical queries at exactly the same time

---

Solution: Lock + Early Refresh 
First request acquires lock → rebuilds cache → others wait or get stale

```

---

# 💡 Key Takeaways

* ✓ Cache stampede occurs when a popular cache key expires and thousands of concurrent requests all miss simultaneously, overwhelming the backend; at 10,000 requests per second, expiration causes 10,000 queries in one second versus normal 500 queries per second
* ✓ Request coalescing (single flight pattern) ensures only one request fetches from database on cache miss while others wait and share the result, reducing 10,000 simultaneous queries to exactly 1 query
* ✓ Implement coalescing with distributed locks in Redis using SET with NX (not exists) and EX (expiration) flags; first request acquires lock and refreshes, others see lock and wait or serve stale data
* ✓ Probabilistic early expiration formula: if time_remaining < TTL × random × log(requests_per_second), refresh now; this spreads high traffic key refreshes across time instead of synchronized expiration
* ✓ Stale while revalidate pattern serves expired cached data immediately (5ms response) while triggering asynchronous background refresh, sacrificing strict freshness for consistent latency and database protection

---

# 📌 Interview Tips

1. When adding caching to your design, proactively mention cache stampede:
   *"For high-traffic keys, I would use locking or probabilistic early refresh to prevent thundering herd."*

2. Know three solutions cold:

   * distributed locking (one regenerator)
   * probabilistic early expiration (refresh before TTL)
   * stale-while-revalidate (serve old, refresh async)

3. If asked about cache TTL, mention that hot keys need different strategies than cold keys. High-traffic keys warrant the complexity of stampede prevention.
