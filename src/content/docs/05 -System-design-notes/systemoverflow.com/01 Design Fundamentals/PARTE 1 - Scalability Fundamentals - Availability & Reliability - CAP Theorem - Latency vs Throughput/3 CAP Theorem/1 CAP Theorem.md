# What is CAP Theorem?

The CAP Theorem states that a distributed system can provide at most two of three guarantees: Consistency (all nodes see same data), Availability (every request gets a response), and Partition Tolerance (system works despite network failures).

# THE CONCERT TICKET DILEMMA

You are building a ticket booking system with servers in New York and London. One ticket remains for a sold-out concert.

Alice in Boston and Bob in Paris click "Buy" at the same moment. Alice hits New York, Bob hits London. Right then, the network between data centers goes down. The servers cannot communicate.

Choice 1 (Consistency): Both servers say "Cannot complete until I confirm with the other server." Alice and Bob both get errors. Frustrating but fair: nobody gets double-sold.

Choice 2 (Availability): Both servers say "You got it!" and complete the purchase. But there was only 1 ticket. Now you must call one customer and say "actually, we oversold." Terrible experience.

This is CAP. During the partition, you choose: refuse both requests (consistency) or serve both and deal with conflicts later (availability).

# THE THREE GUARANTEES

Consistency: Every read returns the most recent write. Never see stale or conflicting data.

Availability: Every request gets a response. No errors just because freshness is uncertain.

Partition Tolerance: System works when network failures split nodes into groups that cannot communicate.

The Reality: Partitions are inevitable. Cables break, routers fail. Distributed systems must be partition tolerant, leaving only CP (reject some requests) or AP (accept conflicts) as real choices.

# The CAP Trade-off: 1 Ticket, 2 Buyers

```
New York                     London
1 ticket left                1 ticket left
Alice clicks BUY            Bob clicks BUY
        |                           |
        +-------- DOWN --------------+
                |
        Servers can't communicate.
        What should each server do?

CONSISTENCY              AVAILABILITY
Both return ERROR        Both return SUCCESS
"Cannot confirm"         "You got it!"
✓ No overselling         ✗ 2 sold, 1 exists

CAP: During partition, pick C or A. Can't have both.
```

# 💡 Key Takeaways

✓ Consistency means every read sees the latest write, as if there's only one copy of data. No stale reads allowed.

✓ Availability means every request to a working node gets a response within your latency SLO (commonly p99 under 100ms to 200ms).

✓ Partition Tolerance means the system keeps working when network failures prevent nodes from communicating.

✓ Network partitions are inevitable in distributed systems, so the real choice is between CP (refuse some requests to stay consistent) or AP (serve all requests but risk inconsistency).

# 📌 Interview Tips

1. Start your CAP explanation with a concrete scenario: "When the network partitions, do we want users to see stale data or see errors?" This frames the trade-off clearly.

2. Know the difference between CP and AP cold: CP systems reject requests during partitions to stay consistent. AP systems serve requests but may have stale data.

3. When asked about CAP, mention that the choice only matters during partitions. During normal operation, many systems provide both consistency and availability. 