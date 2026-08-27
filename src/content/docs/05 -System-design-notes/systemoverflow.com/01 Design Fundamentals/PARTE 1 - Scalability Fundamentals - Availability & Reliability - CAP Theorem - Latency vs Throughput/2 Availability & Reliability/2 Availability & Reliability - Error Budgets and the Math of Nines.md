# Error Budgets and the Math of Nines

## Core Concept

An error budget is the maximum downtime or errors allowed while meeting your SLA. If you promise 99.9% availability, your budget is 0.1% of time: 8.76 hours per year to spend on outages, deployments, or experiments.

---

## THE MATH OF NINES

Minutes per year: 365 × 24 × 60 = 525,600

* 99% = 1% downtime = 5,256 min = 3.65 days
* 99.9% = 0.1% downtime = 526 min = 8.76 hours
* 99.99% = 0.01% downtime = 52.6 min
* 99.999% = 0.001% downtime = 5.26 min

Going from 99.9% to 99.99% means reducing allowed downtime from 8.76 hours to 52 minutes, a 10x reduction requiring dramatically different architecture.

---

## SPENDING YOUR BUDGET

A 99.9% SLA gives 8.76 hours/year. How do you spend it?

* Planned maintenance: Database migrations, patches. 2 hours quarterly = 8 hours.
* Deployments: If each deploy risks 5 minutes and you deploy daily, that is 30 hours/year. Too much. Either deploy less or make deploys safer.
* Unplanned outages: Whatever remains after planned work.

> **The Trade-off:** Spending budget on risky deploys accelerates features but leaves less buffer for outages. Conservative teams bank budget. Aggressive teams spend it on velocity.

---

## WHEN BUDGET RUNS OUT

Exhaust your budget? Freeze non-critical changes. Focus on reliability until budget recovers. This creates natural pressure: ship fast when healthy, stabilize when depleted.

---

## Serial Dependencies Erode Availability

```id="q4m2sj"
Service A
99.9% available
↓ (× 0.999)

Service B
99.9% available
↓ (× 0.999)

Service C
99.9% available
↓
Composite Result
99.7% available

Lost a nine! 129.6 min/month downtime
```

---

# 💡 Key Takeaways

* ✓ Error budget is the allowed failure time within your SLO. 99.9% monthly SLO gives 43.2 minutes budget, 99.99% gives 4.32 minutes, 99.999% gives only 26 seconds.
* ✓ Composite availability multiplies across serial dependencies. Three services at 99.9% each yield 99.7% end to end (0.999 cubed), tripling your downtime from 43 to 130 minutes monthly.
* ✓ SRE teams freeze risky changes when error budgets are exhausted, balancing feature velocity against stability. This creates objective negotiation between product and operations.
* ✓ Each additional nine typically doubles infrastructure cost and operational complexity. Going from 99.9% to 99.99% requires multi region redundancy, automated failover, stricter change control, and 24/7 coverage.
* ✓ Choose SLOs based on business impact, not arbitrary targets. Internal tools can accept 95% to 99%, while payments and authentication need 99.99%+ because downtime has direct revenue and security consequences.

---

# 📌 Interview Tips

1. Calculate error budget live:
   *"99.9% SLA means 0.1% downtime. 525,600 minutes per year times 0.001 equals 526 minutes, about 8.76 hours."*

2. Explain the spending model:
   *"We budget error time like money. Deploys cost 5 minutes each. Maintenance windows cost hours. We track spend against our annual budget."*

3. Mention the freeze policy:
   *"When error budget is exhausted, we freeze feature work and focus on reliability until budget recovers. This creates natural balance."*
