# Failure Modes: Tail Latency Amplification, Queuing Collapse, and Retry Storms

## Tail Latency Amplification

In distributed systems, a single request often fans out to multiple services. If any downstream call is slow, the entire request is slow. This is tail latency amplification: the more services you call, the higher your effective tail latency.

If each of 5 services has p99 latency of 100ms, and you call all 5 in parallel, your p99 is not 100ms. With independent services, the probability that at least one is slow is:

$$1 - (0.99)^5 = 4.9\%$$

Your effective p99 becomes closer to p95 of each service. With 100 parallel calls, nearly every request hits at least one slow service.

## Queuing Collapse

Queuing collapse happens when a temporary spike causes queues to grow, and the system never recovers. The spike passes, but the queue is so deep that requests timeout before being processed. Dead requests keep occupying queue space. New requests join a queue of mostly dead work.

The fix requires active queue management. Set queue length limits and reject requests when full (load shedding). Set request deadlines so workers skip requests that have already timed out from the client perspective. Without these protections, a 30 second spike can cause hours of degraded service.

## Retry Storms

When a service is slow, clients timeout and retry. Each retry adds more load. The service, already struggling, gets even more requests. More timeouts, more retries. This positive feedback loop can turn a minor slowdown into complete system failure.

A service at 90% capacity experiences a GC pause. Response time spikes. 10% of requests timeout and retry. Load jumps to 99%. More requests timeout. 30% retry. Load exceeds capacity. Queues explode. Now 80% of requests timeout. Retry rate overwhelms everything.

> **Key Trade-off:** Retries improve reliability for transient failures but amplify load during sustained problems. Always implement exponential backoff (wait longer between retries) and retry budgets (limit total retry attempts per time window).

## Coordinated Omission

Most load testing tools have a bug called coordinated omission. They wait for a response before sending the next request. If a request takes 5 seconds, they pause for 5 seconds. This hides the true impact of slow responses.

In reality, users do not stop sending requests when your service is slow. Real load is constant. A proper load test sends requests at a fixed rate regardless of response time. The difference is dramatic: tools with coordinated omission might show p99=50ms when true p99 is 5000ms.

---

## 💡 Key Takeaways

* Tail latency amplifies with fan-out: calling N services in parallel means your p99 approaches p(100-100/N) of each individual service
* Queuing collapse occurs when temporary spikes create backlogs of dead requests; protect with queue limits and request deadlines
* Retry storms create positive feedback loops; implement exponential backoff and retry budgets to prevent 10% slowdown from becoming 100% outage
* Most load testing tools suffer from coordinated omission; true latency under load is often 100x worse than naive benchmarks show

---

## 📌 Interview Tips

1. When discussing microservices, mention tail latency amplification; explain why a system calling 10 services has worse p99 than any individual service
2. Describe retry storm prevention: exponential backoff starting at 100ms doubling to max 30s, plus retry budget of 10% additional traffic
3. Mention coordinated omission when discussing load testing; suggest constant rate load generation instead of waiting for responses