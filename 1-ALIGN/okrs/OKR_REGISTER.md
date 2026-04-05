---
type: ues-deliverable
version: "2.2"
status: in-progress
last_updated: 2026-04-04
work_stream: 1-align
stage: build
sub_system: 1-PD
ues_version: prototype
owner: "Long Nguyen"
---
# OKR Register — LTC Portfolio Dashboard, I2

## OKR Register Identity

| Field | Value |
|-------|-------|
| Sub-system | PD (Problem Diagnosis) |
| Iteration | I2 |
| Review cadence | Weekly (Fridays) |
| Owner | Long Nguyen |

## Objectives

### Objective 1 — Deliver a Live Portfolio Dashboard PMs Actually Use

PMs have a single, trusted screen to monitor portfolio health in real time, replacing the current Excel morning routine.

| Key Result | Baseline | Target | Formula / Measurement | Status |
|------------|----------|--------|-----------------------|--------|
| KR 1.1 — PM time-to-NAV retrieval | 15 min | < 2 min | Timed UAT session average | In Progress |
| KR 1.2 — Daily active PM users | 0 | 5 of 6 PMs | Login analytics (weekly avg) | Draft |
| KR 1.3 — Dashboard uptime | N/A | 99.5% | Uptime monitoring tool | Draft |

### Objective 2 — Establish Reliable Bloomberg Data Pipeline

The data pipeline delivers accurate, sub-second market data with defined fallback behavior under failure.

| Key Result | Baseline | Target | Formula / Measurement | Status |
|------------|----------|--------|-----------------------|--------|
| KR 2.1 — Data freshness (P95 latency) | N/A | < 500ms | Pipeline telemetry logs | In Progress |
| KR 2.2 — Pipeline error rate | N/A | < 0.5% / day | Error log count / total requests | Draft |
| KR 2.3 — Fallback activation rate | N/A | < 2 events / week | Incident log | Draft |

## Scoring Guide

| Score | Meaning |
|-------|---------|
| 0.0–0.3 | Failed — rethink approach |
| 0.4–0.6 | Partial — acceptable if stretch target |
| 0.7–1.0 | Achieved — meeting bar or exceeded |

> OKRs are not performance reviews. A 0.7 is a success. 1.0 every cycle = targets were not ambitious enough.

## Version Advancement Check

> To be completed during 5-IMPROVE Validate at end of I2.

| KR | Score | GO / NO-GO |
|----|-------|-----------|
| KR 1.1 | — | — |
| KR 1.2 | — | — |
| KR 2.1 | — | — |

## Links

- [[CHARTER]]
- [[METRICS_BASELINE]]
