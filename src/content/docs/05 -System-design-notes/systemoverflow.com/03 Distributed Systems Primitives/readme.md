En un sistema distribuido, el problema no es simplemente "tener muchos servidores". 
El problema es que no podés asumir memoria compartida, ejecución atómica, orden global, comunicación confiable ni que un nodo que no responde esté realmente muerto.

Y cada primitive ataca una parte:
"No sé quién coordina"        → Leader Election
"No sé si podemos acordar"        → Consensus
"Dos nodos quieren hacer X"        → Distributed Lock
"Falló después de ejecutar"        → Idempotency
"La red falló temporalmente"        → Retry + Timeout
"Tengo que modificar varios servicios"        → Saga / 2PC
"No sé qué ocurrió antes"        → Causality / Vector Clocks
"Necesito IDs sin coordinación"        → UUID / Snowflake
"Tengo miles de nodos"        → Gossip
"No sé quién está vivo"        → Failure Detection


12. Qué problema resuelve cada uno
Primitive			Pregunta que responde
Distributed Lock	¿Quién puede modificar este recurso ahora?
Leader Election		¿Quién coordina al cluster?
Consensus			¿Cómo acordamos una decisión entre nodos?
2PC					¿Cómo hago commit coordinado entre sistemas?
Saga				¿Cómo manejo una operación distribuida sin una transacción global?
Idempotency			¿Cómo evito efectos duplicados?
Retry				¿Qué hago ante un fallo temporal?
Vector Clocks		¿Qué eventos son causalmente anteriores/concurrentes?
UUID				¿Cómo genero IDs únicos sin coordinación central?
Snowflake			¿Cómo genero IDs distribuidos, compactos y ordenables?
Gossip				¿Cómo propago información entre muchos nodos?
Failure Detection	¿Qué nodos parecen estar fallando?

13. Cómo lo estudiaría como backend developer
No empezaría por Paxos.
El orden que te recomiendo es:
1. Distributed Systems Fundamentals ↓
2. Timeouts / Retries / Idempotency ↓
3. Unique IDs ↓
4. Distributed Locks ↓
5. Leader Election ↓
6. Failure Detection ↓
7. Gossip ↓
8. Distributed Transactions ├── 2PC Saga ↓
9. Consensus ├── Raft Paxos ↓
10. Causality ├── Lamport clocks Vector clocks