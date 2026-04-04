---
status: unprocessed
tags: [competitor-research, dashboard-design, ux]
date_captured: 2026-04-02
source: "Web clip — FT Adviser article"
---
# Competitor Dashboard Analysis — FT Adviser Clip

## Source

Article: "How top asset managers are using real-time dashboards in 2026" — FT Adviser, 2026-03-28

## Key Observations

- Top 3 competitors (Vinacapital, Dragon Capital, SSIAM) all use red/amber/green VaR gauges — VaR > threshold triggers amber; CVaR breach triggers red
- None show CVaR by default — it is a drill-down. VaR is the headline number.
- Sector allocation shown as treemap in 2 out of 3 — confirms our P02 design decision
- Dragon Capital dashboard refreshes every 30 seconds — not real-time WebSocket

## Potential Actions

- [ ] Consider RAG (red/amber/green) gauge for P03 VaR panel — discuss with Frontend Dev
- [ ] Confirm our real-time approach is a differentiator vs Dragon Capital's 30s polling
- [ ] Check if FT Adviser article cites any specific tech stack

## Processing Status

Not yet reviewed with team. Needs triage in next planning session.
