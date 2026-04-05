---
type: ues-deliverable
version: "2.1"
status: validated
last_updated: 2026-04-04
work_stream: 5-IMPROVE
stage: validate
sub_system: 4-IDM
ues_version: prototype
owner: "Long Nguyen"
---
# Retrospective — I1 (Concept Phase)

## Retro Identity

| Field | Value |
|-------|-------|
| Iteration | I1 |
| Retro date | 2026-03-10 |
| Facilitator | Long Nguyen |
| Participants | Long Nguyen, Anh Vinh, Data Engineer, Quant Analyst |

## What Went Well

| Item | Category | Impact |
|------|----------|--------|
| Charter approved in first review cycle | H — Team alignment | Saved 1 week of back-and-forth |
| Bloomberg contract confirmed as in-scope | E — No new procurement needed | ADR-001 resolved cleanly |
| Risk model research completed ahead of schedule | T — Quant analyst delivered fast | Enabled architecture work to start in sprint 2 |

## What Could Be Better

| Item | Category | Root Cause | UBS Entry |
|------|----------|-----------|-----------|
| PM stakeholders not engaged until G1 gate | H — Late involvement | PMs not invited to alignment sessions | Created UBS-001 |
| Architecture draft took 3 iterations | T — Scope unclear | Execute/PLAN boundary fuzzy | Architecture template updated |
| No staging environment at I1 end | Te — Infra not prioritized | IT Ops ticket raised too late | Added to I2 roadmap M0 |

## Action Items (carried into I2)

| Action | Owner | Due Date | Status |
|--------|-------|----------|--------|
| Invite 2 PM leads to weekly syncs | Long Nguyen | 2026-03-17 | Done |
| Provision staging server before Sprint 1 | Data Engineer | 2026-03-14 | Done |
| Add architecture scope table to DESIGN.md template | Long Nguyen | 2026-03-21 | Done |

## I1 OKR Scoring

| KR | Target | Actual | Score |
|----|--------|--------|-------|
| Charter validated by G1 | Yes | Yes | 1.0 |
| ADR-001 decision made | Yes | Yes | 1.0 |
| Risk model research complete | Yes | Yes | 1.0 |
| Staging environment ready | Yes | No | 0.0 |

**Overall I1 Score:** 0.75 — GO for I2 with staging environment blocker resolved.

## Links

- [[CHARTER]]
- [[METRICS_BASELINE]]
- [[OKR_REGISTER]]
