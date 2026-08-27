---
title: title
description: description
---

## gRPC and RPC Design: Binary Efficiency for Internal Services

Remote Procedure Call (RPC) systems like gRPC treat APIs as function calls over the network. You define strongly typed service contracts using Protocol Buffers (Protobuf), which compile to client and server code in 10+ languages. The wire format is compact binary, not text like JSON (JavaScript Object Notation), reducing payload sizes by 30 to 80% and parsing overhead by 5 to 10 times compared to REST with JSON.

The real advantage is bidirectional streaming and lower latency for service to service communication. A typical REST call has ~50ms baseline from connection setup, TLS (Transport Layer Security) handshake, and HTTP overhead. gRPC uses HTTP/2 (Hypertext Transfer Protocol version 2) multiplexing over persistent connections, dropping per call overhead to under 1ms after the initial connection. Google uses gRPC internally for services handling billions of queries per second where every millisecond matters: search backends calling ranking services or ad auction services calling bidding engines.

The tradeoff is loss of web nativeness and caching. Load balancers and CDNs built for HTTP/1.1 cannot inspect or cache gRPC frames easily. Most gRPC deployments use Layer 4 load balancing (raw Transmission Control Protocol or TCP) or require specialized Layer 7 proxies like Envoy. Browser support requires gRPC Web, a compatibility layer with extra overhead. Error handling is different too: gRPC status codes map awkwardly to HTTP, and tooling like curl or Postman does not work natively.

Use gRPC for latency sensitive internal microservices where you control both client and server, need streaming (like real time telemetry or log tailing), and strong typing prevents runtime errors. Avoid it for public facing APIs consumed by diverse clients or when you need broad intermediary caching and HTTP ecosystem tools.

| Feature                | REST + JSON                        | gRPC + Protobuf                    |
|------------------------|------------------------------------|------------------------------------|
| Payload Size           | 2.5 KB                             | 0.6 KB                             |
| Parse Time             | 8ms                                | 1ms                                |
| Per-call Overhead      | 50ms                               | <1ms                               |
| Caching                | Full support                       | Complex                            |
| Tools                  | curl, browser                      | Specialized                        |

---

### 💡 Key Takeaways
- ✓ Protobuf binary encoding reduces payload size by 30 to 80% and parsing time by 5 to 10 times compared to JSON, critical for high throughput services handling millions of requests per second
- ✓ HTTP/2 multiplexing over persistent connections drops per call overhead from 50ms (REST with connection setup) to under 1ms, enabling microsecond scale internal service communication
- ✓ Bidirectional streaming supports use cases like real time log tailing or telemetry collection where servers push data to clients over a single long lived connection
- ✓ Standard HTTP load balancers and CDNs cannot cache or inspect gRPC frames, requiring Layer 4 load balancing or specialized proxies like Envoy which adds operational complexity
- ✓ Strong typing via code generation prevents entire classes of runtime errors: mismatched fields, type coercion bugs, and contract drift detected at compile time instead of production

---

### 📌 Interview Tips
1. Google Search backend: ranking service receives query context (200 bytes Protobuf) and returns scored results (5 KB) in under 3ms p99 latency. Equivalent JSON would be 800 bytes request and 15 KB response with 8ms+ parsing
2. Uber's microservices use gRPC for trip dispatch: rider service calls driver matching service 1000 times/second with sub millisecond latency requirements. HTTP/2 connection reuse eliminates per call TLS handshakes saving 40ms each
3. Streaming example: telemetry collector opens bidirectional stream to 100 servers. Each server pushes metrics every 1 second over the same connection for hours, avoiding 360,000 connection setups per hour that REST polling would require
4. Error handling mismatch: gRPC UNAVAILABLE status (service overloaded) does not map cleanly to HTTP 503. Client libraries handle retries differently than HTTP clients, requiring custom retry logic and circuit breakers

