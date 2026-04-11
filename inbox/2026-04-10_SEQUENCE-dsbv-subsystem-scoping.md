---
version: "1.0"
status: draft
last_updated: 2026-04-11
work_stream: 3-PLAN
sub_system: _cross
stage: sequence
type: sequence
---
# SEQUENCE.md — DSBV Subsystem Scoping v2.1.0

> DSBV stage 2 artifact. Prerequisite: DESIGN.md approved at G1.
> This document orders the work. Every task in DESIGN.md Artifact Inventory must appear here.
> Produced by ltc-planner. Consumed by ltc-builder during Build stage.

---

## Scope Check

| Question | Answer |
|----------|--------|
| Q1: Is DESIGN.md approved (G1 gate passed)? | YES — 2026-04-11 user directed sequence stage |
| Q2: How many artifacts are in the DESIGN.md Artifact Inventory? | 11 (A0 complete, A1-A10 to build) |
| Q3: Does every artifact below map to >=1 task here? | YES — 10 tasks for A1-A10 |
| Q4: Are there circular dependencies? | NO |

---

## Dependency Map

```
T-01 (A4: gate-state.sh)          ← Foundation — no upstream
  ├→ T-02 (A3: dsbv-skill-guard.sh)
  ├→ T-03 (A8: dsbv-provenance-guard.sh)
  └→ T-04 (A9: dsbv-gate.sh)
       ↓
T-05 (A1: /dsbv skill)            ← Depends on T-02,T-03,T-04
T-06 (A2: template scaffold)      ← Depends on T-05
T-07 (A5: process map P3)         ← Depends on T-02,T-03,T-04 (docs, parallel)
T-08 (A6: context packaging)      ← Depends on T-02,T-03,T-04 (docs, parallel)
T-09 (A7: validate-blueprint.py)  ← Depends on T-02,T-03,T-04 (after guards)
T-10 (A10: generate-registry.sh)  ← Depends on T-01 (reads state format)
```

| ID | Task | Depends-on | Input | Output |
|----|------|------------|-------|--------|
| T-01 | gate-state.sh subsystem scoping (A4) | — | `scripts/gate-state.sh`, DD-1 pattern | `scripts/gate-state.sh` (updated), `.claude/state/dsbv-{ws}-{sub}.json` (new format) |
| T-02 | dsbv-skill-guard.sh update (A3) | T-01 | `scripts/dsbv-skill-guard.sh`, DD-1 pattern | `scripts/dsbv-skill-guard.sh` (updated) |
| T-03 | dsbv-provenance-guard.sh path update (A8) | T-01 | `.claude/hooks/dsbv-provenance-guard.sh`, DD-1 pattern | `.claude/hooks/dsbv-provenance-guard.sh` (updated) |
| T-04 | dsbv-gate.sh chain-of-custody update (A9) | T-01 | `scripts/dsbv-gate.sh`, DD-3 rules | `scripts/dsbv-gate.sh` (updated) |
| T-05 | /dsbv skill update (A1) | T-02, T-03, T-04 | `.claude/skills/dsbv/SKILL.md`, DD-2 signature | `.claude/skills/dsbv/SKILL.md` (updated) |
| T-06 | Template scaffolding removal (A2) | T-05 | Skill behavior from T-05, `_genesis/reference/archive/scripts/populate-blueprint.py` | Skill generates `{W}-{WS}/{S}-{SUB}/DESIGN.md` only |
| T-07 | Process map P3 update (A5) | T-02, T-03, T-04 | `_genesis/frameworks/alpei-dsbv-process-map-p3.md` | `_genesis/frameworks/alpei-dsbv-process-map-p3.md` (updated) |
| T-08 | Context packaging update (A6) | T-02, T-03, T-04 | `.claude/skills/dsbv/references/context-packaging.md` | `.claude/skills/dsbv/references/context-packaging.md` (updated) |
| T-09 | validate-blueprint.py Check 5 update (A7) | T-02, T-03, T-04 | `scripts/validate-blueprint.py`, DD-1, DD-4 | `scripts/validate-blueprint.py` (updated) |
| T-10 | generate-registry.sh + registry format (A10) | T-01 | `scripts/generate-registry.sh`, `_genesis/version-registry.md` | `scripts/generate-registry.sh`, `_genesis/version-registry.md` (format updated) |

---

## Task Table

| ID | Name | Depends-on | Input | Output | AC | Size | Agent |
|----|------|------------|-------|--------|----|------|-------|
| T-01 | gate-state.sh subsystem scoping | — | `scripts/gate-state.sh` | `scripts/gate-state.sh` | AC-11: `gate-state.sh init align pd` creates `.claude/state/dsbv-align-pd.json`. AC-12: State JSON contains `"subsystem": "1-PD"` field. AC-13: `gate-state.sh read align pd` returns subsystem-scoped state. AC-14: `gate-state.sh read align` (no subsystem) returns WS-level state with deprecation warning on stderr. AC-14b: `gate-state.sh init align cross` creates `.claude/state/dsbv-align-cross.json` and accepts `_cross` as valid. | M | ltc-builder |
| T-02 | dsbv-skill-guard.sh update | T-01 | `scripts/dsbv-skill-guard.sh` | `scripts/dsbv-skill-guard.sh` | AC-07: Script extracts subsystem dir from `$FILE_PATH` using `{W}-{WS}/{S}-{SUB}/` pattern. AC-08: When `1-ALIGN/1-PD/DESIGN.md` exists and write targets `1-ALIGN/1-PD/pd-charter.md`, exit 0. AC-09: When `1-ALIGN/1-PD/DESIGN.md` missing and write targets `1-ALIGN/1-PD/pd-charter.md`, exit 2. AC-10: WS-level `1-ALIGN/DESIGN.md` alone does NOT satisfy guard for subsystem writes. | M | ltc-builder |
| T-03 | dsbv-provenance-guard.sh path update | T-01 | `.claude/hooks/dsbv-provenance-guard.sh` | `.claude/hooks/dsbv-provenance-guard.sh` | AC-24: Workstream extraction handles `1-ALIGN/1-PD/DESIGN.md` (extracts both WS and SUB). AC-25: Subsystem included in gate-state auto-init call. AC-25b: Exit code on block is 2 (PreToolUse convention). | M | ltc-builder |
| T-04 | dsbv-gate.sh chain-of-custody update | T-01 | `scripts/dsbv-gate.sh` | `scripts/dsbv-gate.sh` | AC-26: For file in `{W}-{WS}/{S}-{SUB}/`, checks `{W-1}-{WS_PREV}/{S}-{SUB}/` for >=1 validated artifact. AC-26b: LEARN->PLAN transition checks `2-LEARN/` for >=1 validated artifact in ANY location (not subsystem-scoped). AC-27: Cross-subsystem ordering: subsystem S Build requires S-1 DESIGN.md in same workstream. AC-28: `_cross` follows DD-4 exception (no upstream subsystem dependency). | L | ltc-builder |
| T-05 | /dsbv skill update | T-02, T-03, T-04 | `.claude/skills/dsbv/SKILL.md` | `.claude/skills/dsbv/SKILL.md` | AC-01: Grep `[subsystem]` in SKILL.md returns >=1 match in Sub-Commands table. AC-02: Grep `pd\|dp\|da\|idm\|cross` returns valid subsystem enum. AC-03: SKILL.md contains 4 numbered specificity-level examples (0-arg through 3-arg) per DD-2. AC-04: Signature line shows `/dsbv [stage] [workstream] [subsystem]`. | M | ltc-builder |
| T-06 | Template scaffolding removal | T-05 | `_genesis/reference/archive/scripts/populate-blueprint.py`, `.claude/skills/dsbv/SKILL.md` | Updated skill behavior | AC-05: After `/dsbv design align pd`, file exists at `1-ALIGN/1-PD/DESIGN.md`. AC-06: After `/dsbv design align pd`, `1-ALIGN/DESIGN.md` is NOT created. | S | ltc-builder |
| T-07 | Process map P3 update | T-02, T-03, T-04 | `_genesis/frameworks/alpei-dsbv-process-map-p3.md` | `_genesis/frameworks/alpei-dsbv-process-map-p3.md` | AC-15: Step 1 command shows `/dsbv design align pd`. AC-16: Step 1 "Produces" shows `1-ALIGN/1-PD/DESIGN.md`. AC-17: Gate summary contains >=1 path matching `{W}-{WS}/{S}-{SUB}/`. | S | ltc-builder |
| T-08 | Context packaging update | T-02, T-03, T-04 | `.claude/skills/dsbv/references/context-packaging.md` | `.claude/skills/dsbv/references/context-packaging.md` | AC-18: Section "## 2. INPUT" contains subsystem sub-section. AC-19: Example shows `subsystem: 1-PD`. AC-20: At least one full 5-field example with subsystem. | S | ltc-builder |
| T-09 | validate-blueprint.py Check 5 update | T-02, T-03, T-04 | `scripts/validate-blueprint.py` | `scripts/validate-blueprint.py` | AC-21: Check 5 looks for `{W}-{WS}/{S}-{SUB}/DESIGN.md`. AC-22: Check 5 does NOT expect `{W}-{WS}/DESIGN.md`. AC-23: `_cross/` missing DSBV files = WARN not FAIL. | M | ltc-builder |
| T-10 | generate-registry.sh + registry format | T-01 | `scripts/generate-registry.sh`, `_genesis/version-registry.md` | `scripts/generate-registry.sh`, `_genesis/version-registry.md` | AC-29: Registry rows follow `{WS}x{SUB}x{Stage}` pattern. AC-30: `_cross` rows only when `_cross/DESIGN.md` exists. AC-31: `--dry-run` shows subsystem-granular rows. | M | ltc-builder |

---

## Parallel Dispatch

```
## Round 1 — Foundation (sequential)
- T-01: gate-state.sh subsystem scoping [sequential — no upstream, all T2 depends on it]

## Round 2 — Enforcement + Registry (parallel)
- T-02: dsbv-skill-guard.sh update [independent]
- T-03: dsbv-provenance-guard.sh path update [independent]
- T-04: dsbv-gate.sh chain-of-custody update [independent]
- T-10: generate-registry.sh + registry format [independent — depends only on T-01, no shared files with T-02/T-03/T-04]

## Round 3 — UX + Docs + Validation (parallel)
- T-05: /dsbv skill update [independent]
- T-07: process map P3 update [independent]
- T-08: context packaging update [independent]
- T-09: validate-blueprint.py Check 5 update [independent]

## Round 4 — Template scaffolding (sequential)
- T-06: template scaffolding removal [depends on T-05]
```

**Rules:**
- Only tasks marked `[independent]` are eligible for parallel dispatch
- Each parallel task gets its own ltc-builder dispatch with full context package
- Generator/Critic loop runs after ALL tasks in a round complete, not per-task
- Round 2 has 4 independent tasks — cost estimate: 4 x ~$0.06 = ~$0.24. Within budget.
- Round 3 has 4 independent tasks — cost estimate: 4 x ~$0.06 = ~$0.24. Within budget.

**Mid-Build human check:** After Round 1 (T-01), verify `gate-state.sh` state file format before proceeding to Round 2 (per DESIGN.md Additional Gates).

---

## Critical Path

```
T-01 → T-04 → T-05 → T-06   (length: 4 tasks, est. ~2.5h)
```

| ID | On critical path? | Reason |
|----|-------------------|--------|
| T-01 | YES | Foundation — all downstream depends on it |
| T-02 | NO | Parallel in Round 2; not on longest chain |
| T-03 | NO | Parallel in Round 2; not on longest chain |
| T-04 | YES | Longest T2 task (L size); T-05 depends on it |
| T-05 | YES | Skill update gates T-06 |
| T-06 | YES | Terminal task on critical path |
| T-07 | NO | Docs — parallel in Round 3, no downstream |
| T-08 | NO | Docs — parallel in Round 3, no downstream |
| T-09 | NO | Validation — parallel in Round 3, no downstream |
| T-10 | NO | Registry — parallel in Round 2, no downstream |

---

## Git Strategy

| Field | Value |
|-------|-------|
| Base branch | `main` |
| Feature branch | `feat/dsbv-subsystem-scoping-i1` |
| Worktree path | N/A — single branch, no worktree needed |
| Commit cadence | Atomic commit after each task (T-01, T-02, ...) |
| Merge strategy | Squash-merge to main after G3 approval |
| Conflict risk | Low — each task edits a distinct file. T-10 touches `version-registry.md` (shared) but no other task writes to it. |

---

## Approval Log

| Date | Gate | Decision | Signal | Tier |
|------|------|----------|--------|------|
| 2026-04-11 | G1 — Design approved | APPROVED | User directed sequence stage | T2 |
| | G2 — Sequence approved | | | |
| | G3 — Build complete | | | |
| | G4 — Validate complete | | | |

---

## Alignment Check

- [x] Every artifact in DESIGN.md Artifact Inventory (A1-A10) has >=1 task in Task Table
- [x] Every task has binary, deterministic ACs (34 ACs: AC-01 through AC-31, AC-14b, AC-25b, AC-26b)
- [x] No circular dependencies in Dependency Map
- [x] Critical path identified: 4 tasks, ~2.5h (3+ tiers as required)
- [x] Parallel dispatch rounds use `[independent]` markers correctly
- [x] Git strategy branch name follows naming convention (`feat/` prefix, kebab-case)
- [x] Approval Log has G1 entry (2026-04-11)

## Links

- [[DESIGN]]
- [[SEQUENCE]]
- [[VALIDATE]]
- [[alpei-dsbv-process-map]]
- [[context-packaging]]
- [[dsbv-process]]
- [[enforcement-layers]]
- [[gate-state]]
- [[ltc-builder]]
- [[workstream]]
