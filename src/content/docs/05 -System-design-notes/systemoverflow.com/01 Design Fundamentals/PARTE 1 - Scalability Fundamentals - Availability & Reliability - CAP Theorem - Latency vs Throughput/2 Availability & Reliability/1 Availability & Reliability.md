# Availability vs Reliability: The Critical Distinction

## Definition

Availability answers: can users reach the system? Reliability answers: when they reach it, does it behave correctly? These are independent. You can have one without the other.

---

## WHY THE DISTINCTION MATTERS

An ATM that is always powered on has high availability. But if it dispenses wrong amounts, it has low reliability. An ATM that works perfectly but is only accessible 4 hours daily has high reliability, low availability.

Your dashboard might show 100% uptime while customers report wrong data. That is available but unreliable. The fixes differ: availability needs redundancy, reliability needs better validation and error handling.

---

## AVAILABILITY: THE NINES

| SLA     | Downtime/Year | Use Case                    |
| ------- | ------------- | --------------------------- |
| 99%     | 3.65 days     | Internal tools, batch jobs  |
| 99.9%   | 8.76 hours    | Standard web apps, SaaS     |
| 99.99%  | 52.6 minutes  | E-commerce, databases       |
| 99.999% | 5.26 minutes  | Payment processors, trading |

Each additional nine costs roughly 10x more to achieve.

---

## RELIABILITY: MTBF AND MTTR

MTBF (Mean Time Between Failures): How long before something breaks. Higher is better.

MTTR (Mean Time To Recovery): How long to fix it. Lower is better.

A system with 30 day MTBF and 2 hour MTTR beats one with 7 day MTBF and 6 hour MTTR.

---

## Key Insight

High availability without reliability is dangerous. A payment system up 99.99% but occasionally double-charging destroys trust faster than occasional downtime with perfect transactions.

---

## Availability vs Reliability: The ATM Example

```id="0a6t9m"
ATM on Every Corner
Always powered on
Often gives wrong amount
HIGH Availability, LOW Reliability

Perfect ATM, Limited Hours
Only open 4 hours/day
Always correct when used
LOW Availability, HIGH Reliability

You need BOTH for a good system
```

---

# 💡 Key Takeaways

* ✓ Availability is uptime divided by total time. 99.9% allows 43.2 minutes downtime monthly, 99.99% allows 4.32 minutes, 99.999% allows only 26 seconds.
* ✓ Reliability is probability of correct operation without failure, measured by MTBF (time between failures) and MTTR (time to repair). Formula: Availability ≈ MTBF / (MTBF + MTTR).
* ✓ Different failure patterns yield same availability percentage. Frequent brief outages (low MTBF, low MTTR) versus rare long outages (high MTBF, high MTTR) both can hit 99.9%.
* ✓ A service can be available but unreliable by returning incorrect or stale data, or reliable but unavailable due to network partitions cutting off access.
* ✓ Each additional "nine" of availability costs disproportionately more in redundancy, testing, and operational complexity. Choose targets based on actual business impact, not arbitrary goals.

---

# 📌 Interview Tips

1. Define both clearly upfront:
   *"Availability is can users reach us. Reliability is do we behave correctly when reached. We need both but they fail differently."*

2. Memorize the nines:
   99.9% is 8.76 hours/year, 99.99% is 52 minutes/year. Interviewers will ask you to calculate downtime budgets.

3. Mention MTBF and MTTR when discussing reliability:
   *"We track mean time between failures and mean time to recovery. High MTBF plus low MTTR equals high reliability."*
