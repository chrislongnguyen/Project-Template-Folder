---
type: ues-deliverable
version: "2.0"
status: draft
last_updated: 2026-04-04
work_stream: 5-IMPROVE
stage: design
sub_system: 4-IDM
owner: "Long Nguyen"
---
# Metrics Baseline — LTC Portfolio Dashboard, I2

## Metrics Baseline Identity

| Field | Value |
|-------|-------|
| Sub-system | IDM (Insights & Decision Making) |
| Iteration | I2 |
| Baseline date | 2026-04-04 |
| Owner | Long Nguyen |

## Pillar Metrics

> I2 activates Sustainability (S) + Efficiency (E) metrics.

### Sustainability Metrics

| Metric | Current Value | Target | Formula | Measurement Method | Cadence |
|--------|--------------|--------|---------|-------------------|---------|
| Dashboard uptime | N/A (not live) | 99.5% | (total minutes - downtime) / total minutes | Uptime monitoring (UptimeRobot) | Daily |
| PM daily active users | 0 | 5 of 6 | Unique logins / 6 PMs | Auth log query | Weekly |
| Data freshness (P95 tick latency) | N/A | < 500ms | P95 of tick-to-render timestamps | Middleware telemetry | Per sprint |

### Efficiency Metrics (I2+)

| Metric | Current Value | Target | Formula | Measurement Method | Cadence |
|--------|--------------|--------|---------|-------------------|---------|
| PM time-to-NAV | 15 min (Excel baseline) | < 2 min | Timed UAT session average | Stopwatch during UAT | Per UAT session |
| Pipeline error rate | N/A | < 0.5% / day | Error events / total requests | Error log count | Daily |

## Measurement Runbook

| Metric | Tool | Steps | Responsible |
|--------|------|-------|-------------|
| Uptime | UptimeRobot | 1. Check dashboard URL every 60s. 2. Alert Minh if downtime > 2 min | Data Engineer |
| PM time-to-NAV | Manual stopwatch | 1. PM opens fresh browser. 2. Navigate to NAV panel. 3. Record time to confirmed number | Long Nguyen (UAT facilitator) |
| Tick latency | Middleware logs | 1. Extract `ts_bloomberg` and `ts_render` from logs. 2. Compute P95 in Python | Data Engineer |

## Baseline Snapshot

| Date | Metric | Actual Value | Notes |
|------|--------|-------------|-------|
| 2026-04-04 | PM time-to-NAV | 15 min | Excel baseline (pre-dashboard) |
| 2026-04-04 | PM daily users | 0 | Dashboard not yet live |

## Links

- [[OKR_REGISTER]]
- [[RETRO-I1]]
- [[CHARTER]]
