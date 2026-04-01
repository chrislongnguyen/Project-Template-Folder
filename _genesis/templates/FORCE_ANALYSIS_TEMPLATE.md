---
version: "1.0"
status: Draft
last_updated: 2026-03-31
owner: "Long Nguyen"
type: template
work_stream: align
stage: design
sub_system: 
---
# FORCE ANALYSIS TEMPLATE (T4)
> Stub template — populate during ALIGN Design and PLAN Design phases.
> Cell(s) enabled: 1-ALIGN × Design, 3-PLAN × Design
> Gap justification: RISK_ENTRY_TEMPLATE covers one UBS entry. No template scopes a force analysis session (driving forces + restraining forces + UBS/UDS inventory).

<!-- TODO: Fill in during ALIGN Design or PLAN Design phase -->

## Force Analysis Identity

| Field | Value |
|-------|-------|
| Sub-system | _[name]_ |
| Scope question | _[What change are we analyzing forces for?]_ |
| Facilitator | _[name]_ |
| Date | _[YYYY-MM-DD]_ |

## Scope Question

> State the change or decision being analyzed as a single sentence.

_[e.g., "Adopt a multi-agent DSBV workflow for all LTC projects."]_

---

## Driving Forces (UDS — What Helps)

> Forces pushing toward the change. Each becomes a candidate UDS driver entry.

| # | Force | Strength (1–5) | Root Enabler | Leverage Action |
|---|-------|---------------|-------------|----------------|
| D1 | _[force]_ | _[1–5]_ | _[why it exists]_ | _[how to amplify]_ |
| D2 | _[force]_ | _[1–5]_ | _[why it exists]_ | _[how to amplify]_ |
| D3 | _[force]_ | _[1–5]_ | _[why it exists]_ | _[how to amplify]_ |

---

## Restraining Forces (UBS — What Blocks)

> Forces resisting the change. Each becomes a candidate UBS risk entry.

| # | Force | Strength (1–5) | Root Cause | Mitigation Action |
|---|-------|---------------|-----------|-----------------|
| R1 | _[force]_ | _[1–5]_ | _[why it exists]_ | _[how to reduce]_ |
| R2 | _[force]_ | _[1–5]_ | _[why it exists]_ | _[how to reduce]_ |
| R3 | _[force]_ | _[1–5]_ | _[why it exists]_ | _[how to reduce]_ |

---

## Summary Assessment

| Dimension | Score | Notes |
|-----------|-------|-------|
| Total driving force strength | _[sum]_ | _[comment]_ |
| Total restraining force strength | _[sum]_ | _[comment]_ |
| Net force direction | _[toward / against / balanced]_ | _[recommendation]_ |

## Output Routing

> After analysis, route entries to the appropriate registers.

| Entry type | Destination |
|------------|-------------|
| Restraining forces (UBS) | `3-PLAN/risks/UBS_REGISTER.md` |
| Driving forces (UDS) | `3-PLAN/drivers/UDS_REGISTER.md` |
| Key findings | `1-ALIGN/charter/CHARTER.md` §Design Principles |

## Links

- [[RISK_ENTRY_TEMPLATE]]
