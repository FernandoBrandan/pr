## Choosing the Right API Style: REST vs gRPC vs GraphQL Decision Framework

Selecting an API style is not a matter of preference but of matching technical constraints to architectural goals. REST dominates public APIs because it leverages the HTTP ecosystem: caching via CDNs and browsers, universal client support from curl to mobile SDKs, and human readable JSON for debugging. GitHub serves millions of third party integrations via REST because those clients need stable URLs, transparent caching, and simple tooling. When your API is public facing, clients are diverse (web, mobile, scripts), and resource CRUD operations dominate, REST is the default choice.

gRPC excels in the opposite scenario: internal microservices requiring microsecond latency and high throughput. Google's production infrastructure uses gRPC everywhere internally because binary Protobuf cuts serialization overhead by 80%, HTTP/2 multiplexing eliminates per call connection setup (50ms saved per request), and bidirectional streaming enables real time data pipelines. The cost is operational complexity: you need Layer 7 aware load balancers or service meshes like Istio, monitoring requires specialized tracing for binary protocols, and client library generation becomes part of your build pipeline. Choose gRPC when you control both ends, latency is measured in milliseconds, and throughput exceeds 10,000 requests per second per service.

GraphQL solves the mobile and frontend aggregation problem. When Netflix needed to serve personalized homepages to 230 million subscribers across TVs, phones, and browsers, REST forced each device type to make 20+ backend calls, causing 8 second load times on slow networks. They built device specific GraphQL gateways that collapsed those into 1 to 2 tailored queries, cutting load time to under 2 seconds and bandwidth by 70%. GraphQL makes sense when you have multiple client types with different data needs, mobile bandwidth is expensive, UI requirements change faster than backend APIs, and you can invest in query complexity controls and monitoring.

The hybrid approach is increasingly common: REST for public CRUD APIs, gRPC for internal service mesh, GraphQL as a Backend For Frontend (BFF) aggregating internal services for client consumption. Amazon API Gateway offers all three: external partners use REST, internal microservices use gRPC, and mobile apps hit GraphQL BFFs that orchestrate dozens of internal calls.

---

### 💡 Key Takeaways
- ✓ REST for public APIs: GitHub REST serves millions of integrations because universal caching, simple tooling (curl, Postman), and stable resource URLs outweigh any performance cost
- ✓ gRPC for internal microservices: Google's services gain 80% smaller payloads and sub millisecond overhead with HTTP/2 multiplexing, critical when services exchange billions of requests per day
- ✓ GraphQL for client aggregation: Netflix reduced mobile app startup from 8 seconds to 2 seconds by replacing 20+ REST calls with 1 GraphQL query, saving 70% bandwidth on cellular networks
- ✓ Hybrid architectures are common: use REST for external partners (caching, compatibility), gRPC for service mesh (latency, throughput), GraphQL BFFs for mobile (aggregation, bandwidth)
- ✓ Decision drivers are concrete metrics: choose based on client diversity (REST), latency requirements (gRPC under 5ms p99), round trip reduction needs (GraphQL for 5+ aggregated calls), not abstract preferences

---

### 📌 Interview Tips
1. GitHub: public REST API with 5000 requests/hour, aggressive caching via ETags. Internal services use gRPC for microsecond latency between code search and repository storage services
2. Netflix: external partner API uses REST for simplicity. Device homepages hit GraphQL BFFs that aggregate 50+ internal gRPC service calls into a single client request tailored per device type (TV, phone, tablet)
3. Uber trip dispatch: rider app uses GraphQL to request {user location, nearby drivers, pricing estimate, payment methods} in one query (150ms). Driver matching backend services communicate via gRPC at 10,000 requests/second with 2ms p99
4. Shopify: merchants use REST Admin API for bulk product uploads (simple, cacheable). Storefronts use GraphQL for complex product pages (variants, inventory, reviews). Internal warehouse services use gRPC for real time inventory updates
