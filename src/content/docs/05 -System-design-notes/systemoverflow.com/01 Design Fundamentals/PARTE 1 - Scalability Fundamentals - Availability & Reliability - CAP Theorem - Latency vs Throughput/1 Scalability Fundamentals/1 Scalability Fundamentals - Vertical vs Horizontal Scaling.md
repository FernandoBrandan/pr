# Vertical vs Horizontal Scaling: The Two Core Motions

## Definition

Scalability is a system's ability to handle growing load (more users, data, requests) while keeping response times acceptable.
You scale by making machines bigger (vertical) or adding more machines (horizontal).

## VERTICAL SCALING: BIGGER MACHINES

Upgrade hardware. Move from 4 cores to 32 cores, 16GB to 256GB RAM. A database handling 2,000 QPS might handle 10,000 QPS on beefier hardware. The appeal: zero code changes, no distributed coordination. A single PostgreSQL on high end hardware can serve 100,000+ TPS for simple queries.

The ceiling: largest cloud instances offer around 384 to 448 vCPUs and up to 24TB RAM. Beyond that, hardware does not exist. One machine also means one failure domain. If it dies, everything dies.

## HORIZONTAL SCALING: MORE MACHINES

Add machines instead of upgrading. Ten 4 core servers behind a load balancer match one 40 core server, often cheaper. Need more? Add another. Machine dies? Nine others keep serving. Scale to thousands of nodes handling millions of RPS.

> Complexity Tax: Horizontal forces hard problems. How do you split data (sharding)? Keep data consistent across nodes? Where does session state live? These distributed problems do not exist with one big machine.

## DECISION FRAMEWORK

Start vertical: early stage, under 10,000 RPS, team lacks distributed expertise, data fits on one machine.

Go horizontal: approaching hardware limits, need geographic distribution, require high availability, or data exceeds single machine capacity.

> Key Insight: Most systems combine both. Scale vertically until limits, then horizontally. A 10 node cluster of 32 core machines beats 100 nodes of 4 core machines due to fewer network hops.

---

## Vertical vs Horizontal Scaling

| Vertical (Scale Up) | Horizontal (Scale Out)
| --- | --- |
| 🖥️ | 🖥️🖥️🖥️🖥️🖥️ +more |
| Bigger Machine: 4 → 64 cores,16GB → 1TB RAM | - | 
| ✓ Simple					| ✓ Near-infinite scale  |
| ✓ No code changes			| ✓ Fault tolerant  |
| ✗ Hardware limits			| ✗ More complex  |
| ✗ Single point of failure	| ✗ Stateless required  |

Modern default: Design for horizontal scaling from day one. 

---

# 💡 Key Takeaways
- ✓ Vertical scaling upgrades a single machine (8 to 32 cores) for simplicity but hits hard limits around 448 cores and creates a single point of failure
- ✓ Horizontal scaling adds more machines (1 to 10 servers) for unlimited growth and high availability but requires solving distribution problems like session management and data partitioning
- ✓ Cost tradeoff: Ten 4 core servers at $200 each costs $2,000 per month with redundancy versus one 32 core server at $1,000 per month but total outage on failure
- ✓ Performance ceiling: A single PostgreSQL instance tops out around 100,000 writes per second while horizontally scaled Cassandra handles millions of writes per second across a cluster
- ✓ Start vertical for simplicity under 10,000 requests per second, switch to horizontal when approaching hardware limits, needing multi region deployment, or requiring 99.99% availability with automated failover

# 📌 Interview Tips
1. When asked about scaling strategy, first ask clarifying questions: expected QPS, data size, latency requirements. This shows you think before jumping to horizontal scaling.
2. Mention the cost of horizontal scaling upfront: distributed transactions, consistency lag, operational complexity. Interviewers love candidates who understand trade-offs.
3. If discussing a system under 10K RPS, suggest vertical scaling first. Saying "start simple, scale when needed" demonstrates pragmatism over over-engineering.