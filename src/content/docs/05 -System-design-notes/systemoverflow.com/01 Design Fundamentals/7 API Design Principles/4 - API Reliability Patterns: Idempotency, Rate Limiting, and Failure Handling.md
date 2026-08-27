---
title: title
description: description
---

## API Reliability Patterns: Idempotency, Rate Limiting, and Failure Handling

Production APIs operate in a hostile environment: network packets drop, clients timeout and retry, concurrent requests race, and malicious actors probe for weaknesses. Reliability is not optional. Start with idempotency for unsafe operations. When a client POSTs a payment but times out after 5 seconds, did the charge succeed? Without idempotency keys, retrying risks double charging. Stripe requires clients to send Idempotency-Key headers; the first request with a key executes and stores the result for 24 hours. Retries with the same key return the cached result, preventing duplicate charges even if the client retries 10 times.

Rate limiting protects your backend from overload and noisy neighbors in multi tenant systems. Token bucket algorithms are common: you have a bucket with capacity (say 100 tokens) that refills at a steady rate (10 tokens per second). Each request costs 1 token. Clients can burst up to 100 requests instantly, then sustain 10 per second long term. GitHub uses this: 5000 requests per hour per authenticated user equals roughly 1.4 requests per second sustained, but you can burst. The alternative, leaky bucket, smooths bursts by processing requests at a fixed rate and queuing excess, better for protecting downstream services but worse for client experience.

Optimistic concurrency prevents lost updates when two clients modify the same resource simultaneously. Without it, last write wins and you lose data. The pattern: GET returns a version field or ETag. PATCH requires If-Match header with that version. If another client updated in between, the version changed and your update gets 409 Conflict, forcing you to retry with fresh data. Amazon DynamoDB uses this extensively: every item has a version attribute, and conditional updates with wrong versions fail immediately instead of silently corrupting data.

Combine these with proper timeout configuration, exponential backoff with jitter on retries, circuit breakers to stop cascading failures, and pagination limits to bound response sizes. Slack enforces 3 second response deadlines for slash commands; work taking longer must be async. Unbounded queries without pagination can return 10 MB responses that blow client memory and network buffers. Always enforce max page sizes (GitHub caps at 100 items) and return 413 Payload Too Large for oversized requests.

```
Token Bucket Rate Limiting

Bucket Capacity: 100 tokens (Max burst) -> Refill Rate: 10/second (Sustained rate)

Scenario: Client sends 150 requests instantly
• First 100: Success (bucket drains)
• Next 50: 429 Too Many Requests
• After 5 seconds: 50 tokens refilled, can send 50 more
```

---

### 💡 Key Takeaways
- ✓ Idempotency keys prevent duplicate side effects: Stripe stores results keyed by (method, route, key) for 24 hours, handling client retries after timeouts without double charging customers
- ✓ Token bucket rate limiting allows bursts (100 requests instantly) then sustained rate (10 per second long term): GitHub gives 5000 requests per hour with burst capacity for bursty workflows
- ✓ Optimistic concurrency with version checks prevents lost updates: two clients GET resource at version 5, first PATCH succeeds and bumps to version 6, second PATCH with version 5 gets 409 Conflict
- ✓ Cost based rate limiting for variable complexity: Shopify GraphQL assigns field costs (inventory lookup = 10 points), caps queries at 1000 points, prevents expensive queries from exhausting resources
- ✓ Cascade failure prevention: circuit breakers stop calling failing dependencies after 5 consecutive failures, wait 30 seconds before retry, preventing thread pool exhaustion across entire system

---

### 📌 Interview Tips
1. Stripe payment idempotency: POST /v1/charges with Idempotency-Key: req_abc123 and amount: 5000. Request times out after 5s. Client retries with same key, gets 200 OK with same charge ID ch_xyz789 from first attempt, customer charged once
2. DynamoDB conditional update: UpdateItem with ConditionExpression: attribute_exists(version) AND version = :v5. If item was modified by another client (version now 6), update fails with ConditionalCheckFailedException, preventing lost update
3. GitHub rate limit headers: X-RateLimit-Limit: 5000, X-RateLimit-Remaining: 4850, X-RateLimit-Reset: 1640000000 (unix timestamp). Client monitors remaining and pauses before hitting zero, resumes after reset time
4. Slack slash command timeout: command invoked, server takes 10 seconds to process. Slack shows error after 3 seconds. Solution: immediately return 200 with response_type: in_channel, do work async, post result via response_url webhook within 30 minutes


