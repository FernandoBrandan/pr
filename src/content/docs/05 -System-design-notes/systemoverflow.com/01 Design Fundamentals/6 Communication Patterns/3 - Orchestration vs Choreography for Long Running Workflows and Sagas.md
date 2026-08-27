---
title: title
description: description
---


## Orchestration vs Choreography for Long Running Workflows and Sagas

Long running workflows that span multiple services and involve compensating actions for partial failures are implemented with either orchestration or choreography. Orchestration centralizes workflow logic in a coordinator (Saga orchestrator) that explicitly sequences steps, issues compensations on failure, and maintains durable state. Uber built Cadence (now evolved into Temporal foundation) to orchestrate ride lifecycle workflows: trip creation, payment authorization, receipt generation, and driver payout. Each step is modeled as an idempotent action with a corresponding idempotent compensation. The orchestrator persists progress after each step, enabling automatic retries with exponential backoff and guaranteeing exactly once semantics for side effects even under process crashes.

Choreography distributes workflow logic across services that react to events without a central coordinator. When an order is placed, the order service publishes an OrderCreated event. Inventory service consumes it, reserves stock, and publishes InventoryReserved. Payment service then charges the card and publishes PaymentCompleted. Each service is autonomous and the overall behavior emerges from event driven reactions. This approach excels at extensibility; adding a new concern like fraud scoring requires only a new consumer of OrderCreated without modifying existing services. However, reasoning about global behavior is hard, cycles can form (service A reacts to B, B reacts to A), and debugging requires tracing correlation IDs across many event logs.

The trade off is operational complexity versus coupling. Orchestration simplifies reasoning, debugging, and versioning of the workflow as a unit, but the orchestrator is a critical dependency and a potential bottleneck. Netflix uses orchestrated workflows for account signup and subscription changes where sequencing and rollback are critical. Choreography reduces coupling and single points of failure but creates emergent complexity; LinkedIn uses it for profile update propagation where hundreds of downstream systems react to change events, each with its own lag and retry logic. Choose orchestration when you need clear ownership, audit trails, and compensating transactions (payments, bookings). Choose choreography when you need extensibility, low coupling, and can tolerate eventual consistency and emergent failures.

---

### 💡 Key Takeaways
- ✓ Orchestration centralizes workflow logic in a coordinator (Uber Cadence, Temporal) that sequences steps, handles retries with exponential backoff, and issues idempotent compensations on failure; simplifies reasoning and debugging but creates a critical dependency
- ✓ Choreography allows services to react to events autonomously without a central coordinator; great for extensibility (add new consumers without changing producers) but global behavior is emergent and debugging is distributed across event logs
- ✓ Uber models each Saga step as idempotent action plus idempotent compensation; orchestrator persists workflow state durably so in flight executions survive process crashes and resume with exactly once side effect semantics
- ✓ Orchestrated workflows are versioned as a unit; in flight executions continue on the version they started, avoiding mid flight schema changes that could corrupt state or skip compensations
- ✓ Choreography risks cyclic dependencies (event spaghetti) where service A publishes event consumed by B, which publishes event consumed by A, creating infinite loops unless sequence numbers or TTLs applied
- ✓ Choose orchestration for workflows with compensating transactions, strict sequencing, and audit requirements (payments, bookings); choose choreography for high fan out, extensibility, and loose coupling (notifications, analytics, profile updates)

---

### 📌 Interview Tips
1. Uber ride workflow orchestrator: step 1 create trip record, step 2 authorize payment with 30 second timeout, step 3 dispatch driver; if payment fails, compensate by canceling trip and notifying rider; orchestrator retries each step with exponential backoff and persists progress
2. LinkedIn profile update choreography: ProfileService publishes ProfileUpdated event; FeedService, SearchIndexer, NotificationService, and AnalyticsPipeline each consume independently with their own lag; adding RecommendationService requires only new consumer subscription
3. Netflix account signup orchestration: step 1 validate email, step 2 create account, step 3 provision entitlements, step 4 send welcome email; each step has timeout and retry policy; if entitlement provision fails, compensate by deleting account and marking email as failed signup