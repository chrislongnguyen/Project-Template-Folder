---
version: "1.0"
status: Draft
last_updated: 2026-04-05
owner: Long Nguyen
workstream: GOVERN
iteration: I2
type: ues-deliverable
work_stream: 0-GOVERN
stage: sequence
---
# SEQUENCE.md — GOVERN: EP-12/EP-13 Layer 1 Enforcement

> DSBV Phase 2 artifact. Approved DESIGN.md (v1.0) is the input.

## Dependency Graph

```
D1 (verify-deliverables.sh) ──┐
D2 (nesting-depth-guard.sh) ──┤──→ D4 (settings.json wire)
D3 (agent file constraints) ──┘
```

D1, D2, D3 are independent — build in any order. D4 must follow D2 (needs script on disk before wiring).

## Task Sequence

| # | Task | Artifact | Depends On | ACs |
|---|------|----------|-----------|-----|
| T1 | Extend verify-deliverables.sh — add EP-12 Blockers gate | `.claude/hooks/verify-deliverables.sh` v1.2 | None | AC-1 to AC-6 |
| T2 | Write nesting-depth-guard.sh — EP-13 PostToolUse observer | `.claude/hooks/nesting-depth-guard.sh` v1.0 | None | AC-7 to AC-10 |
| T3 | Add EP-13 constraint block to 3 leaf agent files | `ltc-builder.md`, `ltc-reviewer.md`, `ltc-explorer.md` | None | AC-11 to AC-13 |
| T4 | Add EP-13 orchestrator exception to ltc-planner | `ltc-planner.md` | None | AC-14 |
| T5 | Wire nesting-depth-guard into settings.json PostToolUse | `.claude/settings.json` | T2 | AC-15 to AC-17 |
