---
type: ues-deliverable
version: "2.0"
status: draft
last_updated: 2026-04-04
work_stream: 4-EXECUTE
stage: design
sub_system: 3-DA
ues_version: prototype
owner: "Long Nguyen"
---
# API Documentation — Portfolio Dashboard Internal API

## Overview

Node.js middleware exposes REST + WebSocket endpoints consumed by the React front-end.

**Base URL (staging):** `https://dashboard-staging.ltcpartners.internal/api/v1`

## REST Endpoints

### GET /portfolio/nav

Returns current NAV for a fund.

| Parameter | Type | Required | Description |
|-----------|------|----------|-------------|
| fund_id | string | Yes | Fund identifier (e.g., `LTC-EQ-01`) |

**Response:**
```json
{
  "fund_id": "LTC-EQ-01",
  "nav_usd": 142500000,
  "nav_delta_1d": 0.0034,
  "as_of": "2026-04-04T09:32:00+07:00"
}
```

### GET /portfolio/risk

Returns latest CVaR and VaR for a fund.

| Parameter | Type | Required |
|-----------|------|----------|
| fund_id | string | Yes |
| confidence | number | No (default: 0.95) |

**Response:**
```json
{
  "fund_id": "LTC-EQ-01",
  "var_95": 2100000,
  "cvar_95": 3400000,
  "computed_at": "2026-04-04T09:30:00+07:00"
}
```

## WebSocket Events

**Endpoint:** `wss://dashboard-staging.ltcpartners.internal/ws`

| Event | Payload | Frequency |
|-------|---------|-----------|
| `tick` | `{ ticker, price, ts }` | On Bloomberg tick |
| `nav_update` | `{ fund_id, nav_usd, ts }` | Derived from tick |
| `stale_warning` | `{ ticker, last_tick_age_s }` | When age > 30s |

## Status

- GET /nav — Implemented, tested
- GET /risk — Stub only; awaiting Risk Engine integration
- WebSocket events — Partial; `stale_warning` not yet implemented

## Links

- [[DA-visualization-spec]]
- [[portfolio-data-ingestion]]
- [[ARCHITECTURE]]
