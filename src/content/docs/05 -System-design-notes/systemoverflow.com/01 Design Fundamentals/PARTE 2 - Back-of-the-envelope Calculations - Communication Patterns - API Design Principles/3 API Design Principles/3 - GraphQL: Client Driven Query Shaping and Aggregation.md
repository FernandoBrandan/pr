
## GraphQL: Client Driven Query Shaping and Aggregation

GraphQL flips the API contract: instead of servers defining fixed endpoints, clients specify exactly what data they need in a single request using a query language. You define a schema with types and relationships, then clients traverse the graph requesting nested fields. A mobile app loading a user profile can request user name, last 5 posts, and comment counts in one round trip instead of 12 separate REST calls.

This eliminates over fetching and under fetching. REST endpoints often return 20 fields when you need 3 (wasting bandwidth on mobile), or force multiple calls to assemble a view (killing latency). Shopify's Storefront API serves millions of online stores: a product page needs product details, variant inventory, related products, and reviews. With REST that is 4 calls and 300ms; with GraphQL it is 1 query and 80ms. Mobile clients save 70% of bandwidth by requesting only fields they render.

The cost is complexity and less caching. Every GraphQL query is a POST to a single endpoint, so URL based caching does not work. Servers must parse queries, validate against schema, resolve each field (potentially hitting different backends), and compose results. Malicious or naive clients can craft expensive queries (deeply nested, wide fan outs) that exhaust server resources. Shopify's GraphQL API uses cost based rate limiting: each field has a cost, queries cannot exceed 1000 points, and the budget refills over time.

Use GraphQL when clients have diverse, evolving data needs (mobile apps, multiple frontends), bandwidth is expensive (mobile networks), or you need strong typing and introspection. Avoid it for simple CRUD where REST caching wins, or when query complexity controls and monitoring overhead outweigh flexibility gains.

**Loading Product Page**

| REST: 4 requests                | GraphQL: 1 query                      |
|---------------------------------|---------------------------------------|
| GET /product/123                | query { product(id:123) { name       |
| GET /inventory/123              |   inventory related reviews           |
| GET /related/123                | } }                                   |
| GET /reviews/123                |                                       |
| **Total:** 300ms                | **Total:** 80ms                       |
| **Bandwidth:** 45 KB            | **Bandwidth:** 12 KB                  |

---

### 💡 Key Takeaways
- ✓ Single request aggregation eliminates round trip latency: loading a complex view drops from 300ms (4 REST calls at 75ms each) to 80ms with one GraphQL query
- ✓ Mobile bandwidth savings reach 70% by requesting only needed fields: a user profile with 30 fields in REST becomes 9 fields in GraphQL, cutting payload from 8 KB to 2.4 KB
- ✓ Query complexity attacks are a real threat: deeply nested queries (10 levels) with wide selections (50 fields per level) can generate 10,000+ database queries and exhaust memory in seconds
- ✓ Cost based rate limiting controls abuse: Shopify assigns each field a cost (simple fields 1 point, complex aggregations 10+ points), caps queries at 1000 points, refills budget gradually
- ✓ Caching requires custom solutions: cannot use CDN URL caching, must implement persisted queries (map query hash to server side query), Apollo cache, or field level caching in resolvers

---

### 📌 Interview Tips
1. Shopify Storefront API: query { product(id: "gid://123") { title variants(first: 5) { edges { node { price inventory } } } related(first: 3) { title } } } returns everything for a product page in 80ms vs 300ms with REST
2. GitHub GraphQL API: query { viewer { repositories(first: 10) { nodes { name issues(first: 5) { totalCount } } } } } fetches user repos with issue counts. Equivalent REST requires 1 call for repos, then 10 more for issue counts per repo
3. Malicious query: { user { posts { comments { author { posts { comments { ... nested 20 levels deep } } } } } } } causes exponential resolver fanout, hitting database with 1 million queries before timeout
4. Cost tracking example: Shopify field costs: product.title = 1, product.variants = 3, variant.inventory (requires external call) = 10. Query requesting product with 5 variants and inventory = 1 + 3 + (5 * 10) = 54 cost units