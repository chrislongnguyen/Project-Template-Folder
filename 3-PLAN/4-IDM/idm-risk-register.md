---
version: "1.0"
last_updated: 2026-04-05
owner: "Long Nguyen"
type: template
work_stream: 3-PLAN
stage: build
sub_system: 4-IDM
status: draft
iteration: 1
---
# RISK ENTRY TEMPLATE
> One entry per UBS blocker. File in `3-PLAN/risks/` and reference from `UBS_REGISTER.md`.
> See `_genesis/frameworks/ltc-ubs-uds-framework.md` for analysis methodology.
> Full UBS register template: `3-PLAN/risks/UBS_REGISTER.md`

## Risk Identity

| Field | Value |
|-------|-------|
| ID | _[UBS-###]_ |
| Description | _[one sentence: what blocks success]_ |
| Probability | _[High / Medium / Low]_ |
| Impact | _[High / Medium / Low]_ |
| Category | _[Human / Technical / Economic / Temporal]_ |
| Owner | _[name / role]_ |
| Detected | _[YYYY-MM-DD]_ |

## Root Cause Analysis

> What is the underlying cause of this risk? Trace to a 7-CS component (EI / EU / EA / EO / EP / EOE / EOT / EOP) if applicable.

_[Describe root cause here.]_

## Mitigation Strategy

> What specific actions reduce probability or impact? List in priority order.

1. _[Mitigation action 1]_
2. _[Mitigation action 2]_

**Residual risk after mitigation:** _[High / Medium / Low — and why]_

## Status

| Date | Update | New Status |
|------|--------|------------|
| _[YYYY-MM-DD]_ | _[what changed]_ | _[Open / Mitigated / Closed]_ |

## Links

- [[ltc-ubs-uds-framework]]
- [[methodology]]
- [[project]]
