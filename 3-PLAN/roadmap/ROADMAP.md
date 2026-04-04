---
type: ues-deliverable
version: "2.0"
status: draft
last_updated: 2026-04-04
work_stream: 3-plan
stage: sequence
sub_system: 1-PD
iteration: I2
owner: "Long Nguyen"
---
# Roadmap — LTC Portfolio Dashboard, I2

## Iteration Summary

I2 scope: Prototype (correct + efficient). Deliver working dashboard used daily by at least 5 of 6 PMs by end of I2.

## Milestones

| Milestone | Target Date | Status | Owner |
|-----------|-------------|--------|-------|
| M1 — Bloomberg B-PIPE integration live | 2026-03-21 | Done | Data Engineer |
| M2 — Risk engine CVaR calculation validated | 2026-03-28 | Done | Quant Analyst |
| M3 — NAV + P&L panels in staging | 2026-04-07 | In Progress | Frontend Dev |
| M4 — Full dashboard UAT with PM team | 2026-04-14 | Not Started | Minh Tran |
| M5 — Production deployment | 2026-04-21 | Not Started | Backend Dev |
| M6 — I2 retrospective + metrics baseline | 2026-04-25 | Not Started | Minh Tran |

## Sprint Plan

### Sprint 1 (2026-03-10 – 2026-03-21)
- Set up Bloomberg B-PIPE WebSocket client
- Build Node.js middleware skeleton
- Charter + ADR-001 validated

### Sprint 2 (2026-03-24 – 2026-04-04)
- Risk engine implementation (CVaR/VaR)
- NAV panel front-end
- Architecture document drafted

### Sprint 3 (2026-04-07 – 2026-04-18)
- Sector allocation treemap
- VaR dashboard panel
- UAT sessions with PM leads

## Dependencies

| Dependency | Source | Required By |
|------------|--------|-------------|
| Bloomberg B-PIPE credentials | Bloomberg Rep | M1 — DONE |
| Staging server provisioning | IT Ops | M3 |
| PM availability for UAT | Anh Vinh (schedule approval) | M4 |

## Links

- [[CHARTER]]
- [[ARCHITECTURE]]
- [[OKR_REGISTER]]
