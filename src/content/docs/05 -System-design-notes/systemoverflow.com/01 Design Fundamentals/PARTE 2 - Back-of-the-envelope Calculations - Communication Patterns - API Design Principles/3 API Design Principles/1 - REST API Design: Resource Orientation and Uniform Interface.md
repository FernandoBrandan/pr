## REST API Design: Resource Orientation and Uniform Interface

Representational State Transfer (REST) APIs model your system as resources (nouns like users, orders, payments) accessed through a uniform interface. Each resource has a stable URL (Uniform Resource Locator), and you manipulate it using standard HTTP (Hypertext Transfer Protocol) methods. This creates a predictable contract: GET retrieves without side effects, POST creates, PUT replaces entirely, PATCH updates partially, and DELETE removes.

The power lies in simplicity and caching. Because GET requests are stateless and safe, intermediaries like Content Delivery Networks (CDNs) and browsers can cache responses aggressively. GitHub's REST API leverages this: conditional requests using Entity Tags (ETags) return 304 Not Modified responses, cutting bandwidth by orders of magnitude for unchanged data. A typical repository sync that would transfer 5 MB drops to a few hundred bytes when nothing changed.

REST trades flexibility for uniform semantics. You cannot batch arbitrary operations in one call without breaking the model. Systems that need complex, nested queries (like a mobile app fetching a user profile plus their last 10 posts plus comment counts) end up making multiple round trips. For a social feed, this might mean 1 request for the user, 1 for posts, and 10 more for each post's comments, totaling 12 round trips and 600ms of latency on a 50ms connection. Netflix originally hit this wall and moved to Backends For Frontends (BFFs) to collapse those calls.

REST shines for resource Create Read Update Delete (CRUD) operations with broad client support and when intermediary caching matters. Choose it when your data model maps cleanly to resources and clients need stable, cacheable endpoints. Avoid it when clients require highly customized aggregations or low latency internal service calls.

| Method   | Description                                                  |
|----------|--------------------------------------------------------------|
| GET      | Retrieve resource (safe, cacheable)                          |
| POST     | Create new resource (not idempotent)                         |
| PUT      | Replace entire resource (idempotent)                         |
| PATCH    | Partial update (requires version check)                      |
| DELETE   | Remove resource (idempotent)                                 |

---

### 💡 Key Takeaways
- ✓ REST uses stable resource URLs and standard HTTP methods, enabling transparent caching by CDNs and browsers which can reduce bandwidth by 95% for unchanged data
- ✓ GET requests must be safe (no side effects) and idempotent; PUT and DELETE are idempotent (repeated calls have same effect); POST creates resources and is not idempotent
- ✓ PATCH enables partial updates but requires optimistic locking with ETags or version fields to prevent lost updates when two clients modify concurrently
- ✓ Multiple round trips for complex views kill performance: fetching a social feed with 10 posts and comments requires 12 requests and adds 600ms latency on a 50ms network
- ✓ GitHub REST API demonstrates production scale: 5,000 requests per hour per authenticated user, with conditional requests via ETags reducing typical sync payloads from 5 MB to under 1 KB

---

### 📌 Interview Tips
1. GET /users/12345 returns user data with ETag: "abc123". Next request sends If-None-Match: "abc123" and receives 304 Not Modified (zero payload) if unchanged, saving 4 KB and 50ms of processing
2. POST /payments with {amount: 1000, currency: "USD"} creates a charge. Retry without idempotency key creates duplicate charge. With Idempotency-Key: "req_xyz" header, Stripe returns same charge ID on retry within 24 hours
3. PATCH /orders/789 with {status: "shipped"} fails with 409 Conflict if If-Match: "v5" header does not match current ETag "v6", preventing overwrite of concurrent update
4. Netflix mobile app originally made 20+ REST calls per screen load (user profile, recommendations, continue watching, each title's metadata). Migrated to device specific BFFs that returned tailored aggregations in 1-2 calls, cutting startup time from 8 seconds to 2 seconds
