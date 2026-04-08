---
version: "1.0"
status: draft
last_updated: 2026-04-07
work_stream: 3-PLAN
stage: build
type: risk-register
iteration: 1
---

# Risk Register (UBS) — PLAN Workstream

> Cross-subsystem risk register for 3-PLAN. Covers all 4 sub-systems (PD, DP, DA, IDM).
> Populate during DSBV Build phase for each sub-system.
> Sub-system registers: `1-PD/pd-risk-register.md`, `2-DP/dp-risk-register.md`, `3-DA/da-risk-register.md`, `4-IDM/idm-risk-register.md`

## UBS Categories

UBS = Unsatisfied Business Situation. Risk categories follow the UBS framework:
- **Technical** — system design, tooling, infrastructure risks
- **Human** — adoption, skill, behavior risks (S > E > Sc priority)
- **Economic** — budget, resource, ROI risks
- **Temporal** — timeline, deadline, sequencing risks

## Risk Register

| ID | Category | Description | Probability (1-3) | Impact (1-3) | Risk Factor | Mitigation |
|----|----------|-------------|-------------------|--------------|-------------|------------|
| R-001 | Human | Template adoption — teams clone without reading setup guide | 2 | 3 | 6 (Critical) | `/setup` skill + I2 training deck |
| R-002 | Human | Agent self-validates status (bypasses human gate) | 2 | 3 | 6 (Critical) | `status-guard.sh` + `dsbv-gate.sh` hooks |
| R-003 | Technical | ALPEI chain violated — build before design | 2 | 2 | 4 (Medium) | `dsbv-skill-guard.sh` + `dsbv-gate.sh` |
| R-004 | Temporal | I2 scope creep — prototype expands to MVE scope | 2 | 2 | 4 (Medium) | SEQUENCE.md + human gate at each DSBV phase |
| R-005 | Economic | Token waste from unscoped agent sessions | 2 | 2 | 4 (Medium) | Task decomposition + context packaging rules |

## Risk Heat Map

```
Impact
  3 | R-001, R-002 |             |
  2 |              | R-003, R-004, R-005 |
  1 |              |             |
    +---- P=1 ----+---- P=2 ----+---- P=3 ----
                     Probability

Risk Factor = P × I
Critical (6-9): R-001, R-002
Medium (3-5):   R-003, R-004, R-005
Low (1-2):      —
```

## Mitigation Plans

| Risk ID | Mitigation Owner | Action | Status |
|---------|-----------------|--------|--------|
| R-001 | Template | `/setup` skill runs smoke-test on clone; I2 training deck onboards I2 users | draft |
| R-002 | Hooks | `status-guard.sh` blocks `validated` self-set; pre-commit hook enforces | draft |
| R-003 | Hooks | `dsbv-skill-guard.sh` blocks writes without DESIGN.md at PreToolUse | draft |
| R-004 | Process | SEQUENCE.md defines explicit scope; human approves each phase transition | draft |
| R-005 | Process | `rules/token-efficiency.md` + context packaging in agent dispatch | draft |

## Links

- [[DESIGN]]
- [[SEQUENCE]]
- [[SKILL]]
- [[da-risk-register]]
- [[dp-risk-register]]
- [[idm-risk-register]]
- [[iteration]]
- [[pd-risk-register]]
- [[task]]
- [[workstream]]
