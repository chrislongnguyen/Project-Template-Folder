---
type: ues-deliverable
version: "2.2"
status: validated
last_updated: 2026-04-04
work_stream: 1-ALIGN
stage: validate
sub_system: 1-PD
ues_version: prototype
owner: "Long Nguyen"
---
# ADR-001 — Data Source Selection: Bloomberg vs Reuters

## Context

The Portfolio Dashboard requires real-time market data. Two enterprise providers were evaluated: Bloomberg B-PIPE and Refinitiv (Reuters) Eikon API.

## Decision

**Selected: Bloomberg B-PIPE**

## Evaluation

| Criterion | Bloomberg B-PIPE | Refinitiv Eikon |
|-----------|-----------------|-----------------|
| Data latency | < 50ms | 100–200ms |
| Coverage (instruments) | 35M+ | 28M+ |
| LTC existing contract | Yes — enterprise seat | No — new procurement |
| API maturity | REST + WebSocket | REST only |
| Annual cost delta | $0 (existing) | +$120K |

## Rationale

LTC already holds an enterprise Bloomberg seat. Switching to Refinitiv would add $120K annually with no material coverage benefit for our Vietnam-focused portfolio. Bloomberg WebSocket support also enables the real-time push updates required for the live NAV panel.

## Consequences

- Data pipeline team must implement Bloomberg B-PIPE WebSocket client
- Fallback to REST polling if WebSocket connection drops (UBS-002)
- Vendor lock-in risk accepted — reviewed in UBS_REGISTER

## Status History

| Date | Status | Note |
|------|--------|------|
| 2026-03-10 | Draft | Initial comparison |
| 2026-03-18 | In-review | Presented to Anh Vinh |
| 2026-03-20 | Validated | Approved by sponsor |

## Links

- [[CHARTER]]
- [[UBS_REGISTER]]
