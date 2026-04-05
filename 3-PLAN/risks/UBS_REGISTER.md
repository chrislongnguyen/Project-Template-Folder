---
type: ues-deliverable
version: "2.2"
status: in-progress
last_updated: 2026-04-04
work_stream: 3-PLAN
stage: build
sub_system: 1-PD
ues_version: prototype
owner: "Long Nguyen"
---
# UBS Risk Register — LTC Portfolio Dashboard, I2

> User Blockers and Setbacks (UBS) register. One entry per identified risk. Categories: Technical (T), Human (H), Economic (E), Temporal (Te).

## Risk Entries

### UBS-001 — PM Adoption Resistance

| Field | Value |
|-------|-------|
| Category | Human (H) |
| Description | PMs accustomed to Excel may resist switching to a web dashboard, citing trust in their own formulas |
| Probability | Medium |
| Impact | High — renders the entire I2 deliverable unused |
| Mitigation | Co-design 2 sessions with PM leads; keep Excel export available in I2; dashboard shows same numbers as Excel for first 2 weeks |
| Owner | Long Nguyen |
| Status | Open |

### UBS-002 — Bloomberg WebSocket Instability

| Field | Value |
|-------|-------|
| Category | Technical (T) |
| Description | Bloomberg B-PIPE WebSocket connections can drop during market volatility events; reconnection logic is non-trivial |
| Probability | Low–Medium |
| Impact | Medium — dashboard shows stale data without warning |
| Mitigation | Implement SSE fallback; add stale-data banner when last tick > 30s; automated reconnect with exponential backoff |
| Owner | Backend Dev |
| Status | In Progress — fallback implemented, not yet load-tested |

### UBS-003 — Risk Engine Latency Under Load

| Field | Value |
|-------|-------|
| Category | Technical (T) |
| Description | Python CVaR calculation on a 500-position portfolio takes 8–12s; unacceptable for a "real-time" panel |
| Probability | High |
| Impact | Medium — VaR panel becomes misleading if refresh is too slow |
| Mitigation | Pre-compute CVaR on 5-min schedule; serve cached value; show "as of HH:MM" timestamp |
| Owner | Quant Analyst |
| Status | Open — solution designed, not yet implemented |

### UBS-004 — Bloomberg Contract Scope Creep

| Field | Value |
|-------|-------|
| Category | Economic (E) |
| Description | Enterprise Bloomberg seat covers 6 concurrent users; dashboard may exceed this if all PMs + ops team connect simultaneously |
| Probability | Low |
| Impact | Low — additional seat cost ~$18K/year |
| Mitigation | Monitor concurrent sessions in middleware; alert Long Nguyen if > 5 active; negotiate additional seats in I3 if needed |
| Owner | Long Nguyen |
| Status | Monitoring |

## Links

- [[ARCHITECTURE]]
- [[ADR-001_data-source-selection]]
- [[CHARTER]]
