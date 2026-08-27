## API Evolution and Backward Compatibility Strategies

APIs are long term contracts that outlive any single deployment. Once published, clients depend on your exact field names, types, error codes, and semantics. Breaking changes force coordinated updates across independent teams and external customers, often impossible at scale. The solution is designing for evolution from day one: make additive changes only, use explicit versioning as a last resort, and maintain compatibility budgets.

Additive evolution means you can add optional fields, new endpoints, and new enum values without breaking existing clients. Clients ignore unknown fields (must tolerate extras), provide defaults for missing inputs, and never repurpose existing fields. Shopify adds features to their APIs continuously but almost never versions: new fields appear with defaults, old fields remain stable for years. When removal is necessary, they deprecate first: mark fields deprecated in schema, emit warnings in responses, document sunset timeline (typically 12 to 24 months), monitor usage, then finally remove.

Versioning is unavoidable for true breaking changes: changing field types (string to integer), removing fields clients depend on, or altering semantics (changing what a status code means). URI versioning is most common: /v1/users versus /v2/users. It is explicit and easy to route but proliferates code and splits caches. Header versioning (Accept: application/vnd.myapi.v2+json) keeps URLs stable but is less discoverable. Stripe uses URI versioning but with dated versions (2023-10-16) and compatibility layers: clients opt into changes by date, and old API versions remain supported for years.

The key metric is compatibility coverage: what percentage of client requests would break if you deployed a change? Measure it with contract testing against recorded production traffic. Maintain a compatibility budget: allow no more than 0.1% of clients to break per release, and never more than 1% total across supported versions. Use schema linters to catch breaking changes in code review: adding required fields, removing endpoints, changing response types. Google's Protocol Buffers enforce this at the compiler level: removing a field number is an error, changing types requires new field numbers.

```
Evolution Timeline: Deprecating a Field

Month 0: Add new field, keep old field -> Month 6: Mark deprecated, emit warnings -> Month 18: Remove field, monitor usage

Compatibility Rule: Old field usage must drop below 1% of requests before removal.
If still at 5% after 18 months, extend timeline or keep indefinitely.
```

---

### 💡 Key Takeaways
- ✓ Additive only changes keep APIs stable: adding optional fields, new endpoints, or enum values is safe. Never remove fields, change types (string to int), or repurpose existing field meanings
- ✓ Deprecation cycle gives clients time to migrate: announce change, emit warnings in API responses, monitor usage for 12 to 24 months, remove only when usage drops below 1% of requests
- ✓ URI versioning (/v1/users vs /v2/users) is explicit and easy to route but splits caching and multiplies code paths. Stripe uses dated versions (2023-10-16) with multi year support windows
- ✓ Schema linters catch breaking changes in code review: enforcing rules like no required fields added, no response types changed, no endpoints removed prevents accidental breakage before deploy
- ✓ Compatibility budgets set hard limits: allow maximum 0.1% of clients to break per release, maximum 1% across all supported versions. Exceed budget and you must delay or redesign change

---

### 📌 Interview Tips
1. Shopify adds new GraphQL fields continuously: product.metafields added in 2020 returns empty array for old clients (they ignore it), new clients query it explicitly. Zero breaking changes, seamless rollout
2. Stripe version migration: client using API version 2022-11-15 continues to work unchanged. New features (like expanded payment methods) only available in 2023-10-16. Client opts in by changing version header, runs side by side testing, then switches
3. Breaking change handled wrong: API changes user.age from string ("25") to integer (25). Clients parsing as string crash immediately. Correct approach: add user.age_numeric as integer, deprecate user.age string over 12 months
4. Google Protocol Buffers enforcement: message User { string name = 1; int32 age = 2; }. Developer tries to change age to string, compiler rejects: cannot change field type. Must add new field age_string = 3 and deprecate old one
