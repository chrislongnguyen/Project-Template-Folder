---
type: ues-deliverable
version: "2.0"
status: in-progress
last_updated: 2026-04-04
work_stream: 2-learn
stage: build
sub_system: 2-DP
iteration: I2
owner: "Long Nguyen"
---
# Research — Data Pipeline Patterns for Real-Time Market Data

## Research Question

What pipeline architecture best supports sub-500ms Bloomberg data delivery to the dashboard front-end?

## Patterns Under Review

### Pattern A: Direct WebSocket Pass-Through

Bloomberg B-PIPE WebSocket → Node.js proxy → Browser WebSocket

- Lowest latency (tested at ~80ms P95)
- No persistence — data lost on disconnect
- Simple; fits I2 scope

### Pattern B: Message Queue (Kafka)

Bloomberg B-PIPE → Kafka topic → Consumer → API → Browser

- Durable; enables replay and audit log
- Adds 150–300ms latency
- Operational complexity exceeds I2 scope

### Pattern C: Server-Sent Events (SSE)

Bloomberg B-PIPE WebSocket → Node.js → SSE → Browser

- One-way push; no bidirectional overhead
- Browser-native; no WebSocket library needed
- Slightly higher latency than Pattern A (~110ms P95)

## Preliminary Finding

Pattern A preferred for I2. Pattern B flagged for I3 when audit log requirements emerge.

## Open Questions

- Q1: Does Bloomberg B-PIPE WebSocket handle reconnection automatically?
- Q2: What is the max concurrent subscription count on our enterprise license?

## Links

- [[ADR-001_data-source-selection]]
- [[ARCHITECTURE]]
- [[portfolio-data-ingestion]]
