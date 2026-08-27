# Design Fundamentals

## 1 Scalability Fundamentals
- 1 Vertical vs Horizontal Scaling.md
- 2 Stateless Architecture.md
- 3 Latency–Concurrency–Throughput Triangle.md
- 4 When and How to Scale.md
- 5 When Everyone Asks at Once.md
- 6 When One Shard Takes All the Heat.md
## 2 Availability & Reliability
- 1 Availability & Reliability.md
- 2 Error Budgets and the Math of Nines.md
- 3 Failure Modes.md
- 4 Designing.md
## 3 CAP Theorem
- 0 CAP Theorem.md
- 1 How CP and AP Systems Work.md
- 2 CAP Choices Per Subsystem: Mixing CP and AP.md
- 3 When to Choose CP vs AP.md
- 4 Modes and Edge Cases.md
## 4 Latency vs Throughpu
- 1 What Are Latency and Throughput? Core Definitions and Measurement.md
- 2 How Latency and Throughput Interact Through Queuing and Utilization.md
- 3 Trade Offs Between Latency and Throughput in System Design Decisions.md
- 4 Failure Modes: Tail Latency Amplification, Queuing Collapse, and Retry Storms.md
- 5 Implementation Patterns: Latency Budgets, Hedging, and BDP Aware Tuning.md
- 6 Real World Latency and Throughput Numbers Every Engineer Should Know.md
## 5 Back-of-the-envelope Calculations
- 1 - What are Back of the Envelope Calculations and Why Do They Matter?.md
- 2 - Essential Conversion Factors and Mental Models for Quick Calculations.md
- 3 - Capacity Sizing and Latency Budgeting Across System Tiers.md
- 4 - Fan Out Calculations and Write Amplification Trade Offs.md
- 5 - Critical Failure Modes: Queue Saturation, Hot Keys, and Cache Cold Start.md
- 6 - Multi Region Bandwidth, Replication Costs, and Sensitivity Analysis.md
## 6 Communication Patterns
- 1 - Synchronous vs Asynchronous Communication: Temporal Coupling and Latency Trade Offs.md
- 2 - Latency Budgets and Tail Amplification in Multi Hop Synchronous Chains.md
- 3 - Orchestration vs Choreography for Long Running Workflows and Sagas.md
- 4 - Idempotency, At Least Once Delivery, and the Outbox Inbox Pattern.md
- 5 - Circuit Breakers, Bulkheads, and Failure Isolation Under Partial Degradation.md
- 6 - Multi Tenant Fairness, Replay Windows, and Noisy Neighbor Isolation in Event Platforms.md
## 7 API Design Principles
- 1 - REST API Design: Resource Orientation and Uniform Interface.md
- 2 - gRPC and RPC Design: Binary Efficiency for Internal Services.md
- 3 - GraphQL: Client Driven Query Shaping and Aggregation.md
- 4 - API Reliability Patterns: Idempotency, Rate Limiting, and Failure Handling.md
- 5 - API Evolution and Backward Compatibility Strategies.md
- 6 - Choosing the Right API Style: REST vs gRPC vs GraphQL Decision Framework.md 


## Networking & Protocols
DNS & Domain Resolution
HTTP/HTTPS & Protocol Evolution
TCP vs UDP Trade-offs
WebSocket & Real-time Communication
TLS/SSL & Encryption
CDN Architecture & Edge Computing
Streaming Protocols (HLS, DASH, RTMP)
## Distributed Systems Primitives
Distributed Locks
Leader Election
Consensus Algorithms (Raft, Paxos)
Distributed Transactions (2PC, Saga)
Idempotency & Retry Patterns
Vector Clocks & Causality
Unique ID Generation (Snowflake, UUID)
Gossip Protocol & Failure Detection
## Replication & Consistency
Leader-Follower Replication
Multi-Leader Replication
Quorum Replication
Consistency Models
Replication Lag & Solutions
## Partitioning & Sharding
Hash-based Partitioning
Range-based Partitioning
Consistent Hashing
Rebalancing Strategies
Hotspot Detection & Handling
Secondary Indexes with Partitioning
## Caching
Cache Patterns (Aside, Through, Back)
Eviction Policies
Cache Invalidation Strategies
Distributed Caching
CDN Caching
Cache Stampede Problem
Bloom Filters
## Load Balancing
L4 vs L7 Load Balancing
Load Balancing Algorithms
Health Checks & Failure Detection
Sticky Sessions
Global Load Balancing
## Database Design
Relational vs NoSQL
ACID vs BASE
Indexing Strategies
Normalization vs Denormalization
Transaction Isolation Levels
Read-Heavy vs Write-Heavy Optimization
Read Replicas & Query Routing
Key-Value Stores (Redis, DynamoDB)
Document Databases (MongoDB, Firestore)
Wide-Column Stores (Cassandra, HBase)
Column-Oriented Databases (Redshift, BigQuery)
Time-Series Databases (InfluxDB, TimescaleDB)
Graph Databases (Neo4j)
Search Databases (Elasticsearch, Solr)
Distributed SQL (CockroachDB, Spanner)
Database Selection Framework
Choosing Databases by Use Case
## Message Queues & Streaming
Message Queue Fundamentals
Kafka/Event Streaming Architecture
Delivery Guarantees (At-least-once, Exactly-once)
Message Ordering & Partitioning
Consumer Groups & Load Balancing
Dead Letter Queues & Error Handling
Notification System Design (Push Notifications)
## Rate Limiting
Token Bucket Algorithm
Leaky Bucket Algorithm
Fixed vs Sliding Window
Distributed Rate Limiting
Rate Limit Strategies (Per-User, Per-IP, Global)
## Search & Ranking Systems
Inverted Index & Text Search
Search Autocomplete (Trie)
Ranking Algorithms (TF-IDF, BM25)
Fuzzy Search & Typo Tolerance
Query Parsing & Optimization
## Geospatial & Location Services
Geohashing
Quadtree & Spatial Indexing
Proximity Search
Real-time Location Tracking
Map Matching & Routing
## Object Storage & Blob Storage
Block vs Object vs File Storage
Erasure Coding & Durability
Multipart Uploads & Resumable Transfers
Presigned URLs & Access Control
Storage Tiering (Hot/Warm/Cold)
Image/Video Optimization & Serving
## Data Processing Patterns
MapReduce & Batch Processing
Stream Processing (Flink, Kafka Streams)
ETL Pipelines & Data Integration
OLTP vs OLAP
Data Warehousing Architecture
Change Data Capture (CDC)
Newsfeed/Timeline Generation (Fan-out Patterns)
## Resilience & Service Patterns
Circuit Breaker Pattern
API Gateway Patterns
Service Discovery
Bulkhead Pattern
Timeout Patterns
Load Shedding & Backpressure
Graceful Degradation
## OS & Systems Fundamentals
Processes vs Threads
Concurrency vs Parallelism
Memory Management & Virtual Memory
CPU Scheduling & Context Switching
I/O Models (Blocking, Non-blocking, Async)
Garbage Collection Fundamentals