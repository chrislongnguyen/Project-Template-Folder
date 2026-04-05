---
type: ues-deliverable
version: "2.1"
status: in-review
last_updated: 2026-04-04
work_stream: 3-plan
stage: build
sub_system: 1-PD
ues_version: prototype
owner: "Long Nguyen"
---
# Architecture — LTC Portfolio Dashboard

## Architecture Identity

| Field | Value |
|-------|-------|
| Sub-system | PD — governs overall system design |
| Version | I2 |
| Owner | Long Nguyen |
| Last reviewed | 2026-04-03 |

## Architecture Summary

Three-tier architecture: Bloomberg B-PIPE as data source, a Node.js middleware layer for WebSocket fan-out and risk model orchestration, and a React+D3 front-end. The middleware is stateless — all persistence delegated to a PostgreSQL positions database updated nightly from internal OMS exports.

## Components

| Component | Responsibility | Owner |
|-----------|---------------|-------|
| Bloomberg B-PIPE Client | WebSocket subscription; raw tick data ingestion | Data Engineer |
| Risk Engine (Python) | CVaR / VaR calculation on position snapshots | Quant Analyst |
| Node.js Middleware | WebSocket fan-out, REST API for historical queries | Backend Dev |
| React+D3 Front-End | Dashboard rendering, panel layout, user interactions | Frontend Dev |
| PostgreSQL DB | Nightly position snapshots, historical P&L | Data Engineer |

## Interfaces

| From | To | Data / Signal | Protocol |
|------|----|---------------|----------|
| Bloomberg B-PIPE | Node.js Middleware | Tick data (price, volume) | WebSocket |
| Node.js Middleware | React Front-End | Live NAV, P&L updates | WebSocket (SSE fallback) |
| Node.js Middleware | Risk Engine | Position snapshot | REST POST |
| Risk Engine | Node.js Middleware | CVaR / VaR result | REST JSON response |
| PostgreSQL DB | Node.js Middleware | Historical positions | SQL query |

## Data Flows

```
Bloomberg B-PIPE
      |
      v (WebSocket)
Node.js Middleware ──► React+D3 Front-End (live panels)
      |
      v (REST)
Risk Engine (Python) ──► Node.js ──► React (VaR panel)
      |
PostgreSQL DB ──► Node.js (historical queries)
```

## Effective Principle Mapping

| Decision | Governing EP | Source |
|----------|-------------|--------|
| CVaR as primary metric | EP-PD-01 | 2-LEARN/research/PD-portfolio-risk-models.md |
| WebSocket pass-through (Pattern A) | EP-DP-01 | 2-LEARN/research/DP-data-pipeline-patterns.md |
| Stateless middleware | EP-PD-02 | 2-LEARN/research/PD-portfolio-risk-models.md |

## UBS Mitigation References

| UBS Entry | Mitigation in Architecture | Register Ref |
|-----------|---------------------------|-------------|
| Bloomberg WebSocket drop | SSE fallback + stale-data warning in UI | UBS-002 |
| Risk engine timeout | 30s timeout; cached last-known VaR displayed | UBS-003 |

## Open Questions

- Q1: Should the Risk Engine run as a sidecar or a separate service?
- Q2: PDF export — headless Chrome or server-side canvas?

## Links

- [[ADR-001_data-source-selection]]
- [[ADR-002_dashboard-framework]]
- [[UBS_REGISTER]]
