## Essential Conversion Factors and Mental Models for Quick Calculations

### Time Conversions
- Seconds per day: 86,400 (round to 100,000 for easy math).
- Seconds per month: ~2.5 million.
- Seconds per year: ~30 million.

These let you convert between "per day" and "per second" instantly. 1 million requests/day = 1M / 100k = 10 requests/sec. 100 requests/sec = 100 × 100k = 10 million/day.

### Data Size Conversions
- 1 KB = 1,000 bytes.
- 1 MB = 1,000 KB.
- 1 GB = 1,000 MB.
- 1 TB = 1,000 GB.
- 1 PB = 1,000 TB.

**Common sizes:**
- Character: 1 byte.
- Integer: 4 bytes.
- Timestamp: 8 bytes.
- UUID: 16 bytes.
- Average JSON object: 1KB.
- Small image: 100KB.
- Large image: 1MB.
- Video minute: ~100MB.

### Bandwidth and Storage Speed
Network speeds are in bits, storage in bytes. 1 Gbps = 125 MB/sec (divide by 8). A gigabit network transfers 125MB every second, 450GB per hour.

- SSD sequential write: ~500 MB/sec.
- SSD random operations: ~50,000/sec.
- Traditional hard drive sequential: ~100 MB/sec.
- Hard drive random operations: ~100/sec.

This 500x difference in random operations is why SSDs transformed database performance.

### Powers of 2 Reference
- 2^10 = 1,024 ≈ 1 thousand.
- 2^20 ≈ 1 million.
- 2^30 ≈ 1 billion.
- 2^40 ≈ 1 trillion.

This maps to data sizes: 2^10 bytes = 1KB, 2^20 = 1MB, 2^30 = 1GB, 2^40 = 1TB. When you see "32-bit address space," you know it addresses 2^32 = 4GB of memory.

### Request Size Estimation
- HTTP header: ~500 bytes.
- Simple API response: 1KB.
- List of 100 items: 100KB.

**Bandwidth math:**
- 1000 requests/sec × 1KB = 1 MB/sec = 8 Mbps. One server handles this easily.
- 100,000 requests/sec × 100KB = 10 GB/sec = 80 Gbps. This requires multiple servers and edge caching (servers placed geographically close to users).

> **Best Practice:** Memorize five numbers: 100k seconds/day, 1 Gbps = 125 MB/sec, 2^10 ≈ 1k, 2^20 ≈ 1M, 2^30 ≈ 1B. These unlock most quick calculations.

---

### 💡 Key Takeaways
- ✓ 100k seconds per day simplifies daily to per-second conversion; 1M requests/day = 10 RPS, 100 RPS = 10M/day
- ✓ Network is bits, storage is bytes; 1 Gbps = 125 MB/sec; a gigabit link moves 450GB per hour
- ✓ Powers of 2: 2^10 ≈ 1k, 2^20 ≈ 1M, 2^30 ≈ 1B; maps directly to KB, MB, GB
- ✓ Bandwidth math: 1000 RPS × 1KB = 8 Mbps (trivial), 100k RPS × 100KB = 80 Gbps (needs CDN)

---

### 📌 Interview Tips
1. Convert fluently between daily and per-second: when told '50 million requests per day,' immediately respond '500 RPS average, probably 2000 RPS peak'
2. Estimate bandwidth needs out loud: 'Each response is 10KB, at 1000 RPS that is 10MB/sec or 80 Mbps, well within a single server'
3. Use powers of 2 for memory calculations: 'We need to store 1 million users at 1KB each, that is 2^20 × 2^10 = 2^30 = 1GB, fits in RAM'
