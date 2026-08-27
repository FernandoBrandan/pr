---
title: title
description: description
---

# Implementation Patterns: Latency Budgets, Hedging, and BDP Aware Tuning

## Latency Budgets

A latency budget divides your total allowed latency across all operations in a request path. If users tolerate 200ms total, and you call 4 services, each gets roughly 50ms. But budgets are not just division; they require tracking remaining budget through each hop.

Pass remaining budget as a request header or context parameter. Service A starts with 200ms, spends 30ms, passes 170ms to Service B. Service B spends 40ms, passes 130ms to Service C. Each service knows whether to attempt optional operations (cache population, logging) or skip them to meet the budget. Services can also use remaining budget to set appropriate timeouts on downstream calls.

## Hedged Requests

Hedging sends duplicate requests to multiple backends simultaneously or after a delay. The first response wins, others are discarded. This cuts tail latency at the cost of increased load.

Simple hedging doubles load but dramatically improves tail latency. Delayed hedging is more efficient: wait for p90 latency (say 50ms), then send a second request only if the first has not returned. If the first request was going to hit p99 (200ms), the hedged request likely returns at median (20ms). You improve p99 from 200ms to 70ms while only adding 10% extra load.

## Bandwidth Delay Product Tuning

Bandwidth Delay Product (BDP) is bandwidth multiplied by round trip time. It represents how much data can be in flight between sender and receiver:

$$\text{BDP} = \text{bandwidth} \times \text{RTT}$$

For a 1 Gbps link with 50ms RTT:

$$\text{BDP} = 1,000,000,000 \text{ bits/sec} \times 0.05 \text{ sec} = 50,000,000 \text{ bits} = 6.25 \text{ MB}$$

Your TCP buffers and in-flight data must accommodate 6.25 MB to fully utilize the link. Default buffer sizes (often 64KB) waste 99% of capacity on high-latency links.

## Connection Pooling

Connection establishment is expensive: TCP handshake takes one RTT, TLS handshake adds one to two more RTTs. A cross-region request with 100ms RTT spends 200 to 300ms just connecting before any data transfer.

Connection pools maintain open connections for reuse. Size the pool using Little's Law:

$$\text{pool\_size} = \text{throughput} \times \text{latency}$$

For 100 RPS with 50ms latency, you need at least 5 connections. Add headroom for bursts: 2x to 3x the calculated minimum.

> **Key Insight:** These patterns share a theme: spending resources (extra requests, larger buffers, maintained connections) to improve latency. Each has a throughput cost. Use them where latency matters most.

---

## 💡 Key Takeaways

* Pass remaining latency budget through request chain; services can skip optional work or set appropriate timeouts based on remaining time
* Delayed hedging waits until p90 latency before sending duplicate request; improves p99 dramatically while only adding 10% extra load
* BDP = bandwidth × RTT determines required buffer size; default 64KB buffers waste 99% of capacity on high-latency gigabit links
* Size connection pools as throughput × latency × 2; a 100 RPS service with 50ms latency needs at least 10 pooled connections

---

## 📌 Interview Tips

1. Describe latency budget implementation: deadline header propagated through services, each hop subtracts its processing time before forwarding
2. Explain hedging trade-offs: simple hedging doubles load, delayed hedging (trigger at p90) adds only 10% load with similar p99 improvement
3. When discussing cross-region communication, calculate BDP and explain why default TCP settings underperform on high-latency links