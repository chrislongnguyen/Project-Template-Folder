---
type: ues-deliverable
version: "2.2"
status: validated
last_updated: 2026-04-04
work_stream: 4-execute
stage: design
sub_system: 2-DP
iteration: I2
owner: "Long Nguyen"
---
# DESIGN.md — Execute Workstream, I2

> DSBV Phase 1 artifact. This document is the contract. If it is not here, it is not in scope.

---

## Scope Check

| Question | Answer |
|----------|--------|
| Q1: Are upstream workstream outputs sufficient? | YES — ALIGN charter validated; PLAN architecture in-review (approved for build start) |
| Q2: What is in scope for this workstream-iteration? | Bloomberg ingestion client, Node.js middleware, React front-end panels (NAV, P&L, VaR), API documentation |
| Q2b: What is explicitly OUT of scope? | PDF export (I3), user auth/login (I3), mobile responsive layout |
| Q3: Go/No-Go — proceed? | GO |

---

## Design Decisions

**Intent:** Build the working dashboard prototype: data pipeline connected to front-end, all 5 panels rendering live Bloomberg data. PMs can use it daily by end of I2.

**Key constraints:**
- Must use Bloomberg B-PIPE WebSocket (ADR-001 committed)
- React+D3 front-end pending ADR-002 approval — start with React, defer D3 custom charts to Sprint 3
- No hardcoded secrets anywhere in the codebase

---

## Artifact Inventory

| # | Artifact | Path | Purpose (WHY) | Acceptance Conditions |
|---|----------|------|---------------|-----------------------|
| A1 | Data Ingestion Module | `4-EXECUTE/src/portfolio-data-ingestion.md` | Implements Bloomberg WebSocket client | AC-1: All 42 tickers subscribed and delivering ticks in staging |
| A2 | API Documentation | `4-EXECUTE/docs/api-documentation.md` | Contract between middleware and front-end | AC-2: All endpoints documented with example responses |
| A3 | Front-End Panels | `4-EXECUTE/src/` | Dashboard UI — 5 panels defined in DA-visualization-spec | AC-3: All panels render with live data in staging UAT |

---

## Execution Strategy

| Field | Value |
|-------|-------|
| Pattern | Sequential build — data layer first, then API, then front-end |
| Why this pattern | Dependencies are linear: front-end cannot render without API; API requires data pipeline |
| Agent config | Single builder (Minh Tran) coordinating 3 specialists |
| Git strategy | Feature branches per component; merge to `I2/execute` when tested |
| Human gates | G3 = Minh Tran + Anh Vinh UAT sign-off |

---

## Human Gates

| Gate | Trigger | Decision Required |
|------|---------|-------------------|
| G1 | Design complete | Approve DESIGN.md — DONE (2026-03-22) |
| G3 | Build complete | All panels pass UAT — pending 2026-04-14 |

---

## Readiness Conditions (C1-C6)

| ID | Condition | Status |
|----|-----------|--------|
| C1 | Clear scope — in/out written down | GREEN |
| C2 | Input materials curated — LEARN research + PLAN architecture | GREEN |
| C3 | Success rubric defined — VANA in CHARTER + panel ACs | GREEN |
| C4 | DSBV process loaded | GREEN |
| C5 | Prompt engineered | GREEN |
| C6 | Evaluation protocol — UAT session with PMs | GREEN |

## Links

- [[CHARTER]]
- [[ARCHITECTURE]]
- [[DA-visualization-spec]]
