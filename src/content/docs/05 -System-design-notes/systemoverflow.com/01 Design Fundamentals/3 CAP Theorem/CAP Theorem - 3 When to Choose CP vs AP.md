---
title: title
description: description
---

# When to Choose CP vs AP

## The Key Question

The choice between CP and AP is not about which is better. It is about matching system behavior to business requirements: What happens if users see stale data? What happens if requests fail?

## CHOOSE CP WHEN MISTAKES ARE EXPENSIVE

Financial transactions: Bank balances, payments. Duplicate charges violate regulations and cost money.

Inventory and bookings: Concert tickets, hotel rooms. Overselling creates customer service nightmares.

Configuration: Feature flags. Inconsistent configs across servers can break functionality.

CP Cost: During a partition isolating 40% of nodes, those nodes return errors. Overall availability drops from 99.99% to roughly 99.5% during incidents.

## CHOOSE AP WHEN SPEED TRUMPS ACCURACY

Social feeds: Users want something in under 200ms. Missing recent posts temporarily is acceptable.

Search and recommendations: Slightly stale results beat nothing. 2 second index lag is invisible.

Analytics: Aggregations lagging by seconds is preferable to blocking writes.

AP Cost: You need conflict resolution. With last-write-wins, 200ms clock skew causes lost updates. At scale, roughly 0.01% of concurrent updates are lost without careful handling.

## THE NUMBERS

Payment service at 50K TPS: CP gives 75ms p99 writes, 40% error rate during partitions. AP gives 5ms p99 but may create duplicates. For payments, occasional errors beat complex reconciliation.

## Decision Framework: CP vs AP

```
What's worse during a partition?

Choose CP if...
Errors < Duplicates
Money is involved
Regulations apply
Overselling = nightmare
During partition:
40% error rate

Choose AP if...
Speed > Accuracy
Stale data is OK
UX trumps correctness
Can merge conflicts
During partition:
99.99% available
```

CP: Payments, Inventory, Config
AP: Feeds, Search, Analytics

# 💡 Key Takeaways

✓ Choose CP when correctness errors are expensive: payments, inventory, bookings. Accept occasional 40% error rate during partitions over data conflicts.

✓ Choose AP when speed and availability matter more: social feeds, recommendations, logs. Accept seconds of inconsistency over blocking requests.

✓ CP write latency is 50ms to 150ms cross region for consensus versus 1ms to 5ms for AP single node writes. This affects your throughput capacity.

✓ AP requires conflict resolution: last write wins loses data with clock skew over 200ms, version vectors need merge logic. CP avoids this complexity.

# 📌 Interview Tips

1. Frame the decision around business impact: "If we show stale data, users see wrong inventory. If we return errors, users retry. Which is worse for this use case?"

2. Know specific use cases cold: payments need CP (compliance), social feeds can use AP (speed matters more), inventory needs CP (overselling is expensive).

3. Mention the availability math: "CP drops to 99.5% during partitions, AP maintains 99.99%. The 10x difference determines our SLA commitments."
