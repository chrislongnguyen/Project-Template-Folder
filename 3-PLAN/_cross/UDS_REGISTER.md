---
version: "1.0"
status: draft
last_updated: 2026-04-07
work_stream: 3-PLAN
sub_system: _cross
stage: build
type: driver-register
iteration: 1
---

# Driver Register (UDS) — PLAN Workstream

> Cross-subsystem driver register for 3-PLAN. Covers all 4 sub-systems (PD, DP, DA, IDM).
> Populate during DSBV Build stage for each sub-system.
> Sub-system registers: `1-PD/pd-driver-register.md`, `2-DP/dp-driver-register.md`, `3-DA/da-driver-register.md`, `4-IDM/idm-driver-register.md`

## UDS Framework

UDS = Unified Driver System. Forces acting on this workstream's deliverables:
- **Driving forces** — push toward the EO (desired state)
- **Restraining forces** — oppose progress toward EO
- Force analysis: leverage points where small changes create large system movement

## Driver Register

| ID | Type | Force | Strength (1-3) | Description |
|----|------|-------|----------------|-------------|
| D-001 | Driving | Human adoption urgency | 3 | Teams need a working template now — strong pull toward completing scaffold |
| D-002 | Driving | Agent efficiency gain | 2 | Well-structured ALPEI + hooks reduces per-session setup overhead |
| D-003 | Driving | Consistency across repos | 2 | Single canonical template eliminates ad-hoc per-project decisions |
| D-004 | Restraining | Learning curve | 2 | DSBV + ALPEI + UBS/UDS is complex — onboarding friction for new teams |
| D-005 | Restraining | Maintenance overhead | 2 | Every framework update requires template-sync to all downstream repos |
| D-006 | Restraining | Scope ambiguity | 1 | Boundary between template scaffold and project-specific content is unclear to users |

## Force Analysis

```
DRIVING FORCES                    RESTRAINING FORCES
──────────────────────────────    ──────────────────────────────
D-001: Human adoption urgency →→→  ← D-004: Learning curve
D-002: Agent efficiency gain  →→   ← D-005: Maintenance overhead
D-003: Consistency across repos →  ← D-006: Scope ambiguity

Net force: Driving > Restraining → proceed, but address D-004 first (S > E > Sc)
```

## Leverage Strategy

| Force | Leverage Point | Action |
|-------|---------------|--------|
| D-004 (Learning curve) | `/setup` skill + Iteration 2 training deck | Reduce onboarding time to <30 min |
| D-005 (Maintenance overhead) | `template-sync` skill v2 | Automate propagation to downstream repos |
| D-006 (Scope ambiguity) | BLUEPRINT.md + README per dir | Clear "what goes here" in every directory |

## Links

- [[BLUEPRINT]]
- [[README]]
- [[SKILL]]
- [[da-driver-register]]
- [[dp-driver-register]]
- [[friction]]
- [[idm-driver-register]]
- [[iteration]]
- [[pd-driver-register]]
- [[workstream]]
