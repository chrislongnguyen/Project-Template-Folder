---
version: "2.0"
status: draft
last_updated: 2026-04-05
work_stream: 3-PLAN
stage: build
type: dependency-map
sub_system: _cross
iteration: 2
---

# Cross-Subsystem Dependency Map

Canonical record of inter-subsystem dependencies within the 3-PLAN workstream. Use this
map to sequence build work and identify critical path constraints.

## Dependency Matrix

| Source     | Target     | Interface                  | Data Flow                              | Coupling Level |
|------------|------------|----------------------------|----------------------------------------|----------------|
| 1-PD       | 2-DP       | Output Schema (JSON)       | Problem records → ingestion spec       | High           |
| 1-PD       | 3-DA       | Diagnostic taxonomy        | Problem categories → analytical scope  | High           |
| 1-PD       | 4-IDM      | Decision taxonomy          | Problem types → report taxonomy        | Medium         |
| 2-DP       | 3-DA       | Data contract (SLA + schema) | Cleaned data → analytics input       | High           |
| 2-DP       | 4-IDM      | Pipeline status feed       | Run metadata → delivery dashboard      | Low            |
| 3-DA       | 4-IDM      | Analytical output schema   | Metrics + insights → reporting layer   | High           |
| 3-PLAN/_cross | All    | Filesystem blueprint       | Directory structure → artifact routing | Structural     |

Coupling levels: High = breaking changes require coordinated release | Medium = interface versioned separately | Low = informational only

## Critical Path

```
1-PD architecture APPROVED
        |
        +──→ 2-DP architecture (blocked until PD output schema locked)
        |           |
        |           +──→ 3-DA architecture (blocked until DP data contract defined)
        |                       |
        +──────────────────────→ 4-IDM architecture (blocked until DA output schema + PD taxonomy)
```

Critical path length: 4 sequential gates. No subsystem can reach EXECUTE Build until
all upstream architecture docs are at minimum Review status.

## Interface Lock Protocol

When a High-coupling interface changes after downstream PLAN is in Review:
1. Raise an ADR in `1-ALIGN/decisions/`
2. Notify affected downstream subsystem leads
3. Reset downstream artifact to Draft, bump version

## Links

- [[BLUEPRINT]]
- [[SEQUENCE]]
- [[adr]]
- [[architecture]]
- [[dashboard]]
- [[iteration]]
- [[schema]]
- [[workstream]]
