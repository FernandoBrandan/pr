---
title: title
description: description
---

# Trade Offs Between Latency and Throughput in System Design Decisions

## The Fundamental Trade-off

Every design decision involves choosing between latency and throughput. They compete for the same resources: CPU cycles, memory bandwidth, network capacity. Optimizing for one necessarily reduces the other. Understanding this trade-off is core to system design.

## Synchronous vs Asynchronous Processing

* **Synchronous:** Request waits for response. User gets immediate feedback. Latency is predictable. But throughput is limited because each request occupies resources until complete.
* **Asynchronous:** Request returns immediately, processing happens later. Throughput is higher because resources are released quickly. But latency includes queue wait time plus processing time, and the user loses immediate feedback.

Choose synchronous for user-facing operations where feedback matters (form submissions, payments). Choose asynchronous for operations where completion time is flexible (email sending, report generation, data aggregation).

## Caching Trade-offs

Caching reduces average latency dramatically but increases throughput complexity. A cache hit returns in 1ms instead of 100ms from the database. But cache misses still hit the database, and now you manage two systems.

* **Write-through caching** (write to cache and database) maintains consistency but doubles write latency.
* **Write-behind** (write to cache, sync later) reduces write latency but risks data loss and consistency issues.
* **Read-aside** (check cache, fallback to database) gives best read latency but creates thundering herd problems when cache expires.

## Database Design Decisions

* **Indexing:** Indexes speed up reads (lower latency) but slow down writes (reduced write throughput). Each index adds write overhead. A table with 5 indexes takes 5x longer to insert than an unindexed table.
* **Normalization:** Normalized schemas require joins, increasing read latency. Denormalized schemas duplicate data, increasing write complexity and storage but reducing read latency.
* **Replication:** Synchronous replication ensures consistency but adds write latency (wait for replicas). Asynchronous replication has lower write latency but risks data loss on failure.

> **Decision Criteria:** Match your optimization target to user needs. Interactive applications (search, checkout) optimize for latency, accepting lower throughput. Batch systems (analytics, data pipelines) optimize for throughput, accepting higher latency.

---

## 💡 Key Takeaways

* Synchronous processing gives predictable latency but limits throughput; asynchronous processing increases throughput but adds queue wait time to latency
* Caching reduces average read latency 100x but introduces write consistency trade-offs; write-through doubles write latency, write-behind risks data loss
* Database indexes improve read latency but each additional index can double write time; 5 indexes means 5x slower inserts
* Match optimization target to user needs; interactive systems prioritize latency, batch systems prioritize throughput

---

## 📌 Interview Tips

1. When designing a feature, explicitly state whether it is latency sensitive or throughput sensitive; this frames every subsequent decision
2. Discuss caching strategy trade-offs; explain why you would choose write-through for financial data but write-behind for analytics
3. Mention the read/write ratio when discussing indexes; a 100:1 read heavy workload justifies more indexes than a 1:1 mixed workload