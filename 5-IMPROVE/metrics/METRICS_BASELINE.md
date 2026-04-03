---
version: "1.0"
status: draft
last_updated: 2026-04-02
workstream: IMPROVE
owner: "{{OWNER}}"
---

> Source template: `_genesis/templates/metrics-baseline-template.md`

# Metrics Baseline

> Populate during IMPROVE Design and IMPROVE Build phases.
> Three Pillars priority: Sustainability (S) → Efficiency (E) → Scalability (Sc).
> Do NOT overwrite baseline snapshot rows — append new readings as new rows.

## Metrics Baseline Identity

| Field | Value |
|-------|-------|
| Sub-system | _[name]_ |
| Iteration | _[I1 / I2 / I3 / I4]_ |
| Baseline date | _[YYYY-MM-DD]_ |
| Owner | _[name]_ |

## Pillar Metrics

> Only measure pillars active at your current iteration (I1=S, I2=S+E, I3=S+E, I4=S+E+Sc).

### Sustainability Metrics

| Metric | Current Value | Target | Formula | Measurement Method | Cadence |
|--------|--------------|--------|---------|-------------------|---------|
| _[name]_ | _[value + unit]_ | _[value + unit]_ | _[how calculated]_ | _[how collected]_ | _[weekly / sprint]_ |
| _[name]_ | _[value + unit]_ | _[value + unit]_ | _[how calculated]_ | _[how collected]_ | _[weekly / sprint]_ |

### Efficiency Metrics (I2+)

| Metric | Current Value | Target | Formula | Measurement Method | Cadence |
|--------|--------------|--------|---------|-------------------|---------|
| _[name]_ | _[value + unit]_ | _[value + unit]_ | _[how calculated]_ | _[how collected]_ | _[weekly / sprint]_ |

### Scalability Metrics (I4+)

| Metric | Current Value | Target | Formula | Measurement Method | Cadence |
|--------|--------------|--------|---------|-------------------|---------|
| _[name]_ | _[value + unit]_ | _[value + unit]_ | _[how calculated]_ | _[how collected]_ | _[weekly / sprint]_ |

## Measurement Runbook

> How to collect each metric — exact steps, tool used, who runs it.

| Metric | Tool | Steps | Responsible |
|--------|------|-------|-------------|
| _[name]_ | _[tool]_ | _[1. ... 2. ...]_ | _[role]_ |

## Baseline Snapshot

> One-time reading taken before improvement work begins. Do not overwrite — append new readings as a new row.

| Date | Metric | Actual Value | Notes |
|------|--------|-------------|-------|
| _[YYYY-MM-DD]_ | _[name]_ | _[value]_ | _[context]_ |
