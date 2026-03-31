---
version: "1.0"
iteration: "I1: Concept"
status: Draft
last_updated: 2026-03-29
owner: Long Nguyen
---
# SEQUENCE — Learn-Skill Refactor

> Build order for the 10 artifacts defined in DESIGN.md v1.1.
> Dependency-resolved. Derisk-first (Sustainability before Efficiency).
> A2 pre-completed. A9 deferred to I2. 8 tasks remain for I1.

---

## Dependency Graph

```
PHASE 1 — Prerequisites (no downstream skill depends on these being wrong)
┌─────────────────────────────────────────────────────────┐
│  T1: A1 (methodology)    ← MUST complete before T4     │
│  T2: A2 (verify import)  ← PRE-COMPLETED, verify only  │
└─────────────────────────────────────────────────────────┘
          │
          ▼
PHASE 2 — Independent skills (no cross-dependencies, parallelizable)
┌─────────────────────────────────────────────────────────┐
│  T3: A4 (input)      ← independent                     │
│  T4: A5 (research)   ← depends on T1 (references A1)   │
│  T5: A6 (structure)  ← benefits from T2 (EL framework)  │
│  T6: A7 (review)     ← independent                     │
│  T7: A8 (spec)       ← independent                     │
└─────────────────────────────────────────────────────────┘
          │
          ▼
PHASE 3 — Orchestrator (must know all sub-skill names/paths)
┌─────────────────────────────────────────────────────────┐
│  T8: A3 (orchestrator) ← depends on T3-T7 complete     │
└─────────────────────────────────────────────────────────┘
          │
          ▼
PHASE 4 — Cleanup (after all new skills confirmed)
┌─────────────────────────────────────────────────────────┐
│  T9: A10 (legacy cleanup) ← depends on T3-T8 complete  │
└─────────────────────────────────────────────────────────┘

DEFERRED — I2
┌─────────────────────────────────────────────────────────┐
│  T10: A9 (visualize) ← after I1 complete                │
└─────────────────────────────────────────────────────────┘
```

---

## Task Breakdown

### PHASE 1 — Prerequisites

#### T1: Extract Research Methodology (A1)

| Field | Value |
|---|---|
| Artifact | `_shared/templates/RESEARCH_METHODOLOGY.md` |
| Input | `skills/deep-research/reference/methodology.md` (main repo root) |
| Action | Read 8-phase pipeline → restructure into 3 concern-based sections: (1) Multi-Angle Search Protocol, (2) Source Verification Protocol, (3) Anti-Hallucination Protocol. Strip deep-research-specific references (CODE questions, mode-specific thresholds, source_evaluator.py). |
| Size | ~30 min |
| AC | C1: File exists; 3 concern sections present; no deep-research-specific references |
| Checkpoint | Commit after validator confirms no stale references |

#### T2: Verify Advanced EL Import (A2)

| Field | Value |
|---|---|
| Artifact | `_shared/reference/ADVANCED-EL-SYSTEM.md` |
| Input | Already imported — verify only |
| Action | Director quick-scan: confirm 9 sections present, spot-check 2-3 term replacements (UDO→EO, EPS→EP), confirm no dropped content. |
| Size | ~5 min (human review) |
| AC | C2: PRE-COMPLETED — Director confirms during Build |
| Checkpoint | Human approval gate |

---

### PHASE 2 — Independent Skills

> These 5 tasks have no cross-dependencies within Phase 2. They CAN be built in parallel (sub-agents), but single-agent sequential is the default pattern per DESIGN. Build order within phase is derisk-first: research (has most constraints) → input → structure → review → spec.

#### T3: Build Input Skill (A4)

| Field | Value |
|---|---|
| Artifact | `1-ALIGN/learning/skills/learn-input/SKILL.md` + gotchas.md + references/ |
| Input | Legacy `learn-input/SKILL.md` (preserve 9-question format, one-at-a-time gate) |
| Action | Refactor legacy skill. Add: EO validation gate with [User][desired state][constraint] check, escape hatch (3 example EOs), update to EOP-GOV structure. |
| Size | ~30 min |
| AC | C5: EO gate present + 3 examples. C6: `skill-validator.sh` = 23/23 |
| Checkpoint | Commit after validator passes |

#### T4: Build Research Skill (A5)

| Field | Value |
|---|---|
| Artifact | `1-ALIGN/learning/skills/learn-research/SKILL.md` + gotchas.md + references/ |
| Input | Legacy `learn-research/SKILL.md` + T1 output (`_shared/templates/RESEARCH_METHODOLOGY.md`) |
| Depends on | **T1** (must reference shared methodology) |
| Action | Refactor legacy skill. Replace embedded methodology with `> Load _shared/templates/RESEARCH_METHODOLOGY.md` reference. Add: source count gate (≥8), URL spot-check (≥2 URLs), escape hatches for EXA/WebSearch/QMD failure. |
| Size | ~40 min |
| AC | C7: References methodology (grep confirms). C8: Source gate documented. C9: 3 escape hatches. C10: `skill-validator.sh` = 23/23 |
| Checkpoint | Commit after validator passes |

#### T5: Build Structure Skill (A6)

| Field | Value |
|---|---|
| Artifact | `1-ALIGN/learning/skills/learn-structure/SKILL.md` + gotchas.md + references/ |
| Input | Legacy `learn-structure/SKILL.md` + `_shared/reference/ADVANCED-EL-SYSTEM.md` (for EL framework understanding) |
| Action | Refactor legacy skill. Enforce: per-topic scope (1 topic per invocation, load only that topic's research), Opus model fork instruction, mermaid companion blocks. Preserve: CAG prefixes, 17-column format, P0-P5 page set, validation checkpoint. |
| Size | ~45 min (most complex skill) |
| AC | C11: Per-topic scope instruction. C12: Opus fork instruction. C13: `skill-validator.sh` = 23/23 |
| Checkpoint | Commit after validator passes |

#### T6: Build Review Skill (A7)

| Field | Value |
|---|---|
| Artifact | `1-ALIGN/learning/skills/learn-review/SKILL.md` + gotchas.md + references/ |
| Input | Legacy `learn-review/SKILL.md` |
| Action | Refactor legacy skill. Add: per-topic scope ("ONE topic at a time"), active learning (1 comprehension Q per page, answer required before approval), causal spine table presentation. Preserve: frontmatter approval status (`approved`/`needs-revision`). |
| Size | ~30 min |
| AC | C14: Comprehension Q + answer-required gate. C15: Per-topic scope. C16: `skill-validator.sh` = 23/23 |
| Checkpoint | Commit after validator passes |

#### T7: Build Spec Skill (A8)

| Field | Value |
|---|---|
| Artifact | `1-ALIGN/learning/skills/learn-spec/SKILL.md` + gotchas.md + references/ |
| Input | Legacy `spec-extract/SKILL.md` |
| Action | Refactor from spec-extract. Add: DSBV Readiness Package generation (C1-C6 checklist), P-page→zone mapping table (P0→system context, P1→UBS, P2→UDS, P3→EP candidates, P4→component map, P5→sequence hints). Preserve: VANA extraction from P-pages, T0 prerequisite gate. |
| Size | ~40 min |
| AC | C17: 6-row mapping table. C18: C1-C6 checklist instruction. C19: `skill-validator.sh` = 23/23 |
| Checkpoint | Commit after validator passes |

---

### PHASE 3 — Orchestrator

#### T8: Build Orchestrator Skill (A3)

| Field | Value |
|---|---|
| Artifact | `1-ALIGN/learning/skills/learn/SKILL.md` + gotchas.md |
| Input | All Phase 2 skill names/paths (T3-T7 must be complete) |
| Depends on | **T3, T4, T5, T6, T7** (must know actual sub-skill directory names) |
| Action | NEW skill. State derivation logic (file system scan), routing table (5 states), ASCII flow diagram. No stored state file. References all sub-skills by their actual paths. |
| Size | ~30 min |
| AC | C3: 5-state routing table. C4: `skill-validator.sh` = 23/23 (or documented deviation in gotchas.md) |
| Checkpoint | Commit after validator passes |

**5-state routing table:**

| State | File System Condition | Route |
|---|---|---|
| 1 | No `learn-input-*.md` in `1-ALIGN/learning/input/` | → `/learn:input` |
| 2 | Input exists, no `research/{slug}/` directory | → `/learn:research` |
| 3 | Research exists, topics lack P0-P5 or `status: approved` | → `/learn:structure` + `/learn:review` per topic |
| 4 | All topics approved, no `specs/{slug}/vana-spec.md` | → `/learn:spec` |
| 5 | VANA-SPEC exists | → "Pipeline complete" message + suggest `/learn:visualize` or `/dsbv design` |

---

### PHASE 4 — Cleanup

#### T9: Legacy Cleanup (A10)

| Field | Value |
|---|---|
| Artifact | (removal of old directories) |
| Input | All new skills confirmed working (T3-T8 complete) |
| Depends on | **T3, T4, T5, T6, T7, T8** |
| Action | Remove `learn-pipeline/` directory. Remove `spec-extract/` directory (replaced by `learn-spec/`). Grep all new skills for `learn-pipeline` and `spec-extract` references → remove orphans. Verify no broken references remain. |
| Size | ~10 min |
| AC | C23: Grep for legacy names = 0 hits. C24: `ls` shows only new directory names. |
| Checkpoint | Commit after grep confirms clean |

---

### DEFERRED — I2

#### T10: Build Visualize Skill (A9)

| Field | Value |
|---|---|
| Artifact | `1-ALIGN/learning/skills/learn-visualize/SKILL.md` + gotchas.md + references/ |
| Input | Approved P-pages (requires I1 pipeline to be functional) |
| Depends on | I1 complete |
| Action | NEW skill. React+Vite interactive system map spec. LTC brand (Midnight Green #004851, Gold #F2C75C, Inter font). Nodes from P-page table entries, edges from causal references. Click-to-drill, hover for detail, filter by S/E/Sc. Export as PNG. |
| Size | ~45 min |
| AC | C20: Brand hex codes + Inter font. C21: Interactive features listed. C22: `skill-validator.sh` = 23/23 |
| Checkpoint | Commit after validator passes |

---

## Execution Summary

| Phase | Tasks | Dependencies | Total Est. |
|---|---|---|---|
| 1 — Prerequisites | T1, T2 | None (T2 = verify only) | ~35 min |
| 2 — Independent skills | T3, T4, T5, T6, T7 | T4 depends on T1 | ~3h 5min |
| 3 — Orchestrator | T8 | T3-T7 | ~30 min |
| 4 — Cleanup | T9 | T3-T8 | ~10 min |
| **I1 Total** | **9 tasks** | | **~4h 20min** |
| I2 (deferred) | T10 | I1 complete | ~45 min |

### Parallelization Opportunity

Phase 2 tasks T3, T5, T6, T7 are independent and could run as parallel sub-agents. T4 depends on T1 but not on the others. If the Director approves parallel Build:
- Wave 1: T1 (methodology extraction)
- Wave 2: T3 + T5 + T6 + T7 (parallel) + T4 (after T1)
- Wave 3: T8 (orchestrator)
- Wave 4: T9 (cleanup)

This would reduce wall-clock from ~4h 20min to ~2h 30min at the cost of N× tokens.

---

## Checkpoint Protocol

After each task:
1. Self-verify against task ACs (binary pass/fail)
2. Run `./scripts/skill-validator.sh {skill-dir}` → must show 23/23 (or document deviation)
3. Commit to `feat/learn-skill-refactor` branch
4. Report status before proceeding to next task

If any task fails validation twice → stop, report to Director, do not proceed.
