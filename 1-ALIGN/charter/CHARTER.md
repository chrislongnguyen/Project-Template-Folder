---
type: ues-deliverable
version: "2.3"
status: validated
last_updated: 2026-04-04
work_stream: 1-ALIGN
stage: validate
sub_system: 1-PD
ues_version: prototype
owner: "Long Nguyen"
---
# Charter — LTC Portfolio Dashboard

## Project Identity

| Field | Value |
|-------|-------|
| Project name | LTC Portfolio Dashboard |
| Scope code (UNG) | INVTECH_DA.2.1.LTC-PORTFOLIO-DASHBOARD |
| Owner | Long Nguyen |
| Iteration | I2 |
| Last reviewed | 2026-04-03 |

## Expected Outcome (EO)

A real-time investment portfolio dashboard that consolidates Bloomberg data, internal position files, and risk model outputs into a single interactive view. Portfolio managers can monitor NAV, sector exposure, and VaR at a glance without exporting to Excel. Success = PMs spend less than 2 minutes retrieving any standard portfolio metric.

## Stakeholders

| Role | Name | Involvement |
|------|------|-------------|
| Sponsor | Anh Vinh | Strategic approval, budget sign-off |
| PM | Long Nguyen | Day-to-day ownership, ALPEI coordination |
| Consumer | Investment Team (6 PMs) | Primary dashboard users |

## Scope

### In Scope

- Real-time NAV calculation and display
- Sector and asset class exposure charts
- VaR and CVaR risk metrics panel
- Bloomberg B-PIPE data integration
- Export to PDF snapshot

### Out of Scope

- Trade execution or order management
- Client reporting portal
- Historical backtesting engine

## VANA Criteria

| Criterion | Statement |
|-----------|-----------|
| **V** (Value) | Reduce PM time-to-insight from 15 min (Excel) to under 2 min |
| **A** (Acceptance) | All 6 PMs can retrieve NAV + VaR for any fund in < 2 min during UAT |
| **N** (Needs) | Bloomberg B-PIPE subscription, React dev environment, staging server |
| **A** (Assumptions) | Bloomberg API latency stays under 500ms; PMs have Chrome 120+ |

## Design Principles

- Data freshness over visual complexity — stale data is worse than no data
- One source of truth: Bloomberg is authoritative; no manual overrides in UI

## Approval

| Gate | Approver | Date | Status |
|------|----------|------|--------|
| G1 (Design) | Anh Vinh | 2026-03-15 | Approved |
| G3 (Build final) | Anh Vinh | 2026-04-01 | Approved |

## Links

- [[ADR-001_data-source-selection]]
- [[ADR-002_dashboard-framework]]
- [[OKR_REGISTER]]
- [[ARCHITECTURE]]
