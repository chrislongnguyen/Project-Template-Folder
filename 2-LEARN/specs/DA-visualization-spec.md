---
type: ues-deliverable
version: "2.0"
status: draft
last_updated: 2026-04-04
work_stream: 2-learn
stage: design
sub_system: 3-DA
ues_version: prototype
owner: "Long Nguyen"
---
# Visualization Spec — Dashboard Data Analysis Layer

## Purpose

Define what charts, panels, and data representations the DA sub-system must produce. This spec is the contract between the data pipeline (DP) and the front-end (DA).

## Panel Inventory

| Panel ID | Name | Chart Type | Data Source | Update Frequency |
|----------|------|-----------|-------------|-----------------|
| P01 | Total NAV | KPI card + sparkline | Bloomberg positions | Real-time (WebSocket) |
| P02 | Sector Allocation | Treemap | Position data | On demand / 60s |
| P03 | VaR Summary | Gauge + table | Risk model output | Every 5 min |
| P04 | Top 10 Holdings | Horizontal bar | Position data | On demand |
| P05 | P&L Today | KPI card + delta indicator | Bloomberg B-PIPE | Real-time |

## Data Contract

Each panel receives a typed JSON payload from the DP layer:

```
P01 payload: { nav_usd: number, nav_delta_1d: number, ts: ISO8601 }
P03 payload: { var_95: number, var_99: number, cvar_95: number, as_of: ISO8601 }
```

## Acceptance Conditions

- AC-1: All panels render with sample data in Storybook before integration
- AC-2: P03 VaR panel shows stale-data warning if data age > 10 min
- AC-3: Treemap (P02) must handle up to 40 sectors without label overlap

## Open Questions

- Q1: Should P01 sparkline show 1-day or 5-day history?
- Q2: Color coding for P&L delta — use LTC Gold/Ruby or traffic light (green/red)?

## Links

- [[DP-data-pipeline-patterns]]
- [[ADR-002_dashboard-framework]]
- [[api-documentation]]
