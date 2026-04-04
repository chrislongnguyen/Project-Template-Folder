---
type: ues-deliverable
version: "2.1"
status: in-progress
last_updated: 2026-04-04
work_stream: 4-execute
stage: build
sub_system: 2-DP
iteration: I2
owner: "Long Nguyen"
---
# Portfolio Data Ingestion — Implementation Notes

## Component: Bloomberg B-PIPE WebSocket Client

Implements Pattern A from `2-LEARN/research/DP-data-pipeline-patterns.md`.

## Implementation Status

| Task | Status | Notes |
|------|--------|-------|
| WebSocket connection + auth | Done | B-PIPE credentials injected via env var |
| Subscription to position tickers | Done | 42 tickers subscribed; all active |
| Reconnect with exponential backoff | In Progress | Base delay 1s, max 60s |
| SSE fallback path | Not Started | Blocked by UBS-002 resolution |
| Stale-data detection (> 30s) | Not Started | |

## Key Design Decisions

- All secrets (Bloomberg API key, client ID) loaded from `.env` — never hardcoded
- Middleware is stateless: each WebSocket message processed and forwarded; no local cache
- Tick normalization: raw Bloomberg fields mapped to internal schema `{ ticker, price, ts, volume }`

## Known Issues

- BBCOMM reconnection on market open (09:00 HCM) occasionally takes 8–10s — investigating
- Tick deduplication needed when multiple subscriptions overlap on same ticker

## Next Steps

1. Complete exponential backoff reconnect
2. Implement SSE fallback (UBS-002 mitigation)
3. Load test with 42 concurrent ticker subscriptions

## Links

- [[DP-data-pipeline-patterns]]
- [[ARCHITECTURE]]
- [[UBS_REGISTER]]
