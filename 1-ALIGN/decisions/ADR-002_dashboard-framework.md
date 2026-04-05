---
type: ues-deliverable
version: "2.1"
status: in-review
last_updated: 2026-04-04
work_stream: 1-ALIGN
stage: build
sub_system: 3-DA
owner: "Long Nguyen"
---
# ADR-002 — Dashboard Framework: React+D3 vs Streamlit

## Context

The front-end framework determines developer velocity, chart flexibility, and long-term maintainability. Two options evaluated: React with D3.js charting vs Python Streamlit.

## Decision (Pending Review)

**Leaning: React + D3.js** — awaiting Anh Vinh sign-off

## Evaluation

| Criterion | React + D3.js | Streamlit |
|-----------|--------------|-----------|
| Real-time WebSocket | Native support | Limited, requires workarounds |
| Custom chart types | Full control | Constrained to Altair/Plotly |
| Dev team skill match | 2 React devs on team | 1 Python data scientist |
| Time to first prototype | 3 weeks | 1 week |
| Long-term flexibility | High | Medium |

## Rationale

Bloomberg WebSocket integration and custom risk chart layouts favor React+D3. The 2-week time-to-prototype gap is acceptable given the I2 timeline. Streamlit would limit chart customization needed for the sector allocation treemap.

## Open Questions

- Q1: Can we prototype the NAV panel in Streamlit first as a proof-of-concept?
- Q2: Do we need server-side rendering for PDF export?

## Consequences

- Requires React dev environment setup (see `4-EXECUTE/config/`)
- PDF export may require headless Chrome (Puppeteer) — adds infra complexity

## Links

- [[CHARTER]]
- [[ARCHITECTURE]]
- [[ADR-001_data-source-selection]]
