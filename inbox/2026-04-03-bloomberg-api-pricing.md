---
status: processing
tags: [bloomberg, contract, vendor, budget]
date_captured: 2026-04-03
source: "Email from Nguyen Duc Minh (Bloomberg Rep)"
---
# Bloomberg API Pricing — Quick Note

## Summary

Bloomberg Rep sent a revised pricing sheet today. Key concern: the enterprise seat we have may cap real-time WebSocket connections at 3 concurrent users, not the 6 we assumed.

## Quote from Email

> "The B-PIPE WebSocket add-on is licensed per concurrent connection. Your current enterprise agreement includes 3 real-time WebSocket slots. Additional slots are $8,500/year each."

## Implication

If all 6 PMs hit the dashboard simultaneously during market open (09:15 HCM), 3 PMs will get REST polling fallback, not real-time WebSocket. This changes the UBS-004 impact assessment.

## Action Required

- [ ] Forward to Anh Vinh for contract review
- [ ] Check actual contract language (not just Rep's interpretation)
- [ ] Update UBS-004 in risk register if confirmed
- [ ] Consider: purchase 3 additional WebSocket slots now vs I3?

## Cost Estimate

3 additional slots × $8,500 = $25,500/year
