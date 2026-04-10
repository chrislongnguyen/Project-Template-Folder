---
version: "1.2"
status: draft
last_updated: 2026-04-11
work_stream: 3-PLAN
sub_system: _cross
stage: design
type: design
---
# DESIGN.md — DSBV Subsystem Scoping v2.1.0

> DSBV stage 1 artifact. This document is the contract. If it is not here, it is not in scope.

---

## Scope Check

| Question                                        | Answer                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                             |
| ----------------------------------------------- | ------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------ |
| Q1: Are upstream workstream outputs sufficient? | YES — Option A decided (DSBV scope = workstream x subsystem). Vocabulary fix ("phase" -> "stage") shipped across 187 files. Subsystem dirs already exist in filesystem (`{W}-{WS}/{S}-{SUB}/`). BLUEPRINT v2.4, SOP v2.1, and VANA-SPEC v2.0 shipped as upstream prerequisites.                                                                                                                                                                                                                                                                                                                                  |
| Q2: What is in scope for this design?           | 10 MUST-HAVE items migrating DSBV from workstream-level to subsystem-level scoping. See Artifact Inventory.                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                        |
| Q2b: What is explicitly OUT of scope?           | (a) New subsystem creation (no new dirs beyond PD/DP/DA/IDM/_cross). (b) LEARN pipeline changes (Mode B untouched). (c) Iteration advancement logic (iteration-bump.sh unchanged). (d) Obsidian Bases view changes (downstream of registry format). (e) New agent roles or model changes. (f) WS-level DESIGN.md cleanup/removal (separate cleanup task post-migration). (g) **Operational exception dirs** — `charter/`, `decisions/`, `okrs/` in `1-ALIGN/` predate subsystem layout and are exempt from subsystem DSBV routing. They are not subsystem-scoped and not subject to DD-1 path pattern enforcement. |
| Q3: Go/No-Go                                    | GO                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                 |

---

## Iteration/Version Context

| Field | Value |
|-------|-------|
| Current iteration | Iteration 1 (concept) |
| UES version ceiling | v1.x — correct + safe only |
| Scope boundary | All 10 items produce correct subsystem-scoped behavior. Performance optimization and edge-case polish deferred to I2. |
| Version convention | New file in Iteration 1 -> `version: "1.0"`. Bump minor on each committed edit. |

---

## Design Decisions

**Intent:** Migrate all DSBV enforcement, state tracking, and artifact generation from workstream-level to subsystem-level scoping so that each subsystem (PD, DP, DA, IDM) progresses through I0->I4 independently within each workstream.

**Key constraints:**
- All 10 items share a single canonical path pattern (defined below). Divergence = silent enforcement gap.
- `_cross` is an optional 5th lane. It gets DSBV only when PM explicitly initiates — scripts must not auto-scaffold `_cross` DSBV files.
- `_cross` is a **named exception** to the `{S}-{SUB}` numeric prefix convention. Where DD-1 specifies `{S}-{SUB}` = `1-PD | 2-DP | 3-DA | 4-IDM`, `_cross` uses an underscore prefix with no number. All scripts accepting `{S}-{SUB}` MUST also accept `_cross` as a valid value.
- Backward compatibility: existing WS-level state files (`.claude/state/dsbv-{ws}.json`) must not break during migration. Scripts should check subsystem-level first, fall back to WS-level, then warn.

### DD-1: Canonical Path Pattern (Single Source of Truth)

All 10 items MUST reference this pattern. No script may hardcode a variant.

```
DSBV artifact:  {W}-{WS}/{S}-{SUB}/DESIGN.md
                {W}-{WS}/{S}-{SUB}/SEQUENCE.md
                {W}-{WS}/{S}-{SUB}/VALIDATE.md
Build artifact: {W}-{WS}/{S}-{SUB}/{sub_prefix}-{name}.md
State file:     .claude/state/dsbv-{ws_lower}-{sub_lower}.json

Where:
  {W}-{WS}     = 1-ALIGN | 3-PLAN | 4-EXECUTE | 5-IMPROVE
  {S}-{SUB}    = 1-PD | 2-DP | 3-DA | 4-IDM | _cross
  {W}          = workstream number (1, 3, 4, 5)
  {S}          = subsystem number (1, 2, 3, 4) — not applicable for _cross
  {ws_lower}   = align | plan | execute | improve
  {sub_lower}  = pd | dp | da | idm | cross
  {sub_prefix} = pd- | dp- | da- | idm- | cross-

Note: _cross breaks the {S}-{SUB} numeric convention — it uses an
underscore prefix with no number. Scripts MUST accept _cross alongside
numbered subsystem values.

Examples:
  1-ALIGN/1-PD/DESIGN.md
  3-PLAN/2-DP/SEQUENCE.md
  .claude/state/dsbv-align-pd.json
  4-EXECUTE/3-DA/da-dashboard-config.md
  1-ALIGN/_cross/DESIGN.md
  .claude/state/dsbv-align-cross.json
```

**Target state:** WS-level DSBV files (`1-ALIGN/DESIGN.md`) are NOT generated, NOT expected, NOT validated. Only subsystem-level files exist.

### DD-2: `/dsbv` Skill Signature

```
Current:  /dsbv [stage] [workstream]
New:      /dsbv [stage] [workstream] [subsystem]

Valid subsystem values: pd | dp | da | idm | cross
```

Progressive prompting UX:
1. `/dsbv` with no args -> ask workstream, then subsystem, then stage
2. `/dsbv design` -> ask workstream, then subsystem
3. `/dsbv design align` -> ask subsystem
4. `/dsbv design align pd` -> proceed immediately
5. `/dsbv status` -> show all workstream x subsystem states (no subsystem prompt needed)

### DD-3: Chain-of-Custody at Subsystem Level

**Cross-workstream rule:** Workstream W, subsystem S cannot start Build until workstream W-1, subsystem S has >=1 validated artifact.

```
Example: 3-PLAN/1-PD/ Build requires 1-ALIGN/1-PD/ to have >=1 validated artifact.
         3-PLAN/2-DP/ Build requires 1-ALIGN/2-DP/ to have >=1 validated artifact.
         (Each subsystem chain is independent.)
```

**LEARN exception (LEARN->PLAN transition):** LEARN (2-LEARN/) does NOT use subsystem-scoped DSBV artifacts — it uses the 6-state learning pipeline. For the LEARN->PLAN transition, each subsystem in `3-PLAN/` requires `2-LEARN/` to have >=1 validated artifact in ANY location (not subsystem-scoped). This preserves the existing `dsbv-gate.sh` LEARN special case (lines 108-127), which checks `_cross/output/` and `*/specs/` for validated status regardless of the target subsystem in `3-PLAN/`.

**Cross-subsystem rule (within a workstream):** PD -> DP -> DA -> IDM ordering. Subsystem S cannot start Build until subsystem S-1 in the SAME workstream has its DESIGN.md (not necessarily validated — just exists, proving Design stage was entered).

**`_cross` exception:** `_cross` has no upstream subsystem dependency. It only requires the workstream W-1 `_cross` chain (if it exists) or no dependency if W-1 has no `_cross` DSBV.

### DD-4: `_cross` Handling

- Scripts MUST NOT auto-scaffold `_cross/DESIGN.md` during `/dsbv` init flows
- `_cross` gets DSBV only when user explicitly runs `/dsbv design {ws} cross`
- `validate-blueprint.py` MUST NOT flag missing DSBV files in `_cross/` as errors (warn only)
- `generate-registry.sh` includes `_cross` rows only if `_cross/DESIGN.md` exists

### DD-5: Backward Compatibility Strategy

Migration order: state files first, then enforcement scripts, then skill UX.

```
Stage 1: gate-state.sh creates subsystem-scoped files, reads both formats
Stage 2: guard scripts check subsystem-level paths first, WS-level fallback with deprecation warning
Stage 3: /dsbv skill prompts for subsystem parameter
Stage 4: validate-blueprint.py stops expecting WS-level files
```

---

## Risk Assessment (UBS)

| ID | Risk | Category | Likelihood | Impact | Mitigation |
|----|------|----------|------------|--------|------------|
| UBS-1 | **Path pattern divergence** — any one of 10 scripts uses a different pattern than DD-1 | Technical | HIGH | HIGH — silent enforcement gap where writes bypass guards | AC for every item references DD-1. Code review must grep for hardcoded path patterns. Template-check.sh validates pattern consistency. |
| UBS-2 | **Backward-compat breakage** — existing WS-level state files cause gate-state.sh failures | Technical | MEDIUM | MEDIUM — blocks DSBV flow until manually fixed | DD-5 migration order. gate-state.sh reads both formats with deprecation log. |
| UBS-3 | **`_cross` auto-scaffold** — scripts create unwanted DSBV files in `_cross/` | Human | MEDIUM | LOW — noise, not breakage | DD-4 explicit exclusion. AC tests for absence of auto-created `_cross/DESIGN.md`. |
| UBS-4 | **Chain-of-custody false positives** — subsystem-level check is stricter than WS-level, blocking legitimate work | Human | MEDIUM | MEDIUM — developer friction | Fallback warning mechanism. `/dsbv status` shows per-subsystem readiness. |
| UBS-5 | **Registry row explosion** — 4 WS x 5 SUB x 4 stages = 80 rows overwhelms human scan | Temporal | LOW | LOW — cosmetic | Only emit rows where DESIGN.md exists. Collapse empty subsystems. |
| UBS-6 | **LEARN->PLAN subsystem ambiguity** — subsystem-scoped gate check on `3-PLAN/{S}-{SUB}/` looks for a matching subsystem in `2-LEARN/` that will never have DSBV artifacts | Technical | HIGH | HIGH — blocks all PLAN Build if gate naively checks `2-LEARN/{S}-{SUB}/DESIGN.md` | DD-3 LEARN exception clause. AC-26b tests LEARN->PLAN transition explicitly. `dsbv-gate.sh` already handles this (lines 108-127) — upgrade must preserve, not replace. |

---

## Artifact Inventory

> **Convention:** Every AC references DD-1 canonical path pattern. `{W}` = workstream number, `{S}` = subsystem number, `{WS}` = workstream name, `{SUB}` = subsystem name, per DD-1.

| # | Artifact | Path | Purpose (WHY) | Acceptance Conditions |
|---|----------|------|---------------|-----------------------|
| A0 | Upstream prerequisites (complete) | `_genesis/alpei-blueprint.md`, `_genesis/sops/alpei-standard-operating-procedure.md`, `_genesis/templates/vana-spec-template.md` | Canonical upstream documents that A1-A10 build upon | AC-00: All 3 files exist and are committed. Status: COMPLETE. |
| A1 | `/dsbv` skill update | `.claude/skills/dsbv/SKILL.md` | Add required `[subsystem]` parameter so DSBV operates at subsystem granularity | AC-01: Grep `\[subsystem\]` in SKILL.md returns >=1 match in Sub-Commands table. AC-02: Grep `pd\|dp\|da\|idm\|cross` in SKILL.md returns valid subsystem enum. AC-03: SKILL.md contains a section with 4 numbered specificity-level examples (0-arg through 3-arg) matching DD-2. AC-04: Signature line shows `/dsbv [stage] [workstream] [subsystem]`. |
| A2 | Template scaffolding removal | `_genesis/reference/archive/scripts/populate-blueprint.py` + skill behavior | Stop generating WS-level DESIGN.md stubs; only generate at `{W}-{WS}/{S}-{SUB}/DESIGN.md` per DD-1 | AC-05: After running `/dsbv design align pd`, file exists at `1-ALIGN/1-PD/DESIGN.md`. AC-06: After running `/dsbv design align pd`, file `1-ALIGN/DESIGN.md` is NOT created. |
| A3 | `dsbv-skill-guard.sh` update | `scripts/dsbv-skill-guard.sh` | Check subsystem-level DESIGN.md before allowing Build writes | AC-07: Script extracts subsystem dir from `$FILE_PATH` using pattern `{W}-{WS}/{S}-{SUB}/`. AC-08: When `1-ALIGN/1-PD/DESIGN.md` exists and write targets `1-ALIGN/1-PD/pd-charter.md`, exit code = 0 (allow). AC-09: When `1-ALIGN/1-PD/DESIGN.md` is missing and write targets `1-ALIGN/1-PD/pd-charter.md`, exit code = 2 (block). AC-10: WS-level `1-ALIGN/DESIGN.md` alone does NOT satisfy guard for subsystem writes (no fallback to WS-level for Build gate). |
| A4 | `gate-state.sh` subsystem scoping | `scripts/gate-state.sh` | Track DSBV state per workstream x subsystem | AC-11: `gate-state.sh init align pd` creates `.claude/state/dsbv-align-pd.json` per DD-1. AC-12: State JSON contains `"subsystem": "1-PD"` field. AC-13: `gate-state.sh read align pd` returns subsystem-scoped state. AC-14: `gate-state.sh read align` (no subsystem) returns WS-level state if it exists (backward compat) with deprecation warning on stderr. AC-14b: `gate-state.sh init align cross` creates `.claude/state/dsbv-align-cross.json` and `set-subsystem` accepts `_cross` as a valid value. |
| A5 | Process map P3 update | `_genesis/frameworks/alpei-dsbv-process-map-p3.md` | Reflect subsystem-scoped commands and paths in training walkthrough | AC-15: Step 1 command column shows `/dsbv design align pd` (not `/dsbv design align`). AC-16: Step 1 "Produces" column shows `1-ALIGN/1-PD/DESIGN.md` (not `1-ALIGN/DESIGN.md`). AC-17: Gate summary contains >=1 path matching `{W}-{WS}/{S}-{SUB}/` pattern. |
| A6 | Context packaging update | `.claude/skills/dsbv/references/context-packaging.md` | Add `subsystem` to 5-field template so agent dispatch includes subsystem | AC-18: Section "## 2. INPUT" contains a `### Subsystem` or equivalent sub-section. AC-19: Example invocation shows `subsystem: 1-PD` (or equivalent) in the template. AC-20: At least one full example shows all 5 fields with subsystem included. |
| A7 | `validate-blueprint.py` Check 5 update | `scripts/validate-blueprint.py` | Validate DSBV stage files at subsystem level, not WS level | AC-21: Check 5 (or equivalent) looks for `{W}-{WS}/{S}-{SUB}/DESIGN.md` per DD-1. AC-22: Check 5 does NOT expect `{W}-{WS}/DESIGN.md` (WS-level). AC-23: `_cross/` missing DSBV files produces WARN, not FAIL (per DD-4). |
| A8 | `dsbv-provenance-guard.sh` path update | `.claude/hooks/dsbv-provenance-guard.sh` | Match subsystem-level DSBV artifact paths in PreToolUse hook | AC-24: Workstream extraction logic handles paths like `1-ALIGN/1-PD/DESIGN.md` (extracts both WS and SUB). AC-25: Subsystem is included in gate-state auto-init call (if auto-init is triggered). AC-25b: Exit code on block is 2 (not 1) to follow PreToolUse hook convention where exit 2 = block. |
| A9 | `dsbv-gate.sh` chain-of-custody update | `scripts/dsbv-gate.sh` | Check subsystem-level validated artifacts for cross-workstream dependency | AC-26: For a file in `{W}-{WS}/{S}-{SUB}/`, script checks `{W-1}-{WS_PREV}/{S}-{SUB}/` for >=1 validated artifact per DD-3 (where `{W-1}` decrements workstream number, `{S}` is unchanged). AC-26b: For the LEARN->PLAN transition (file in `3-PLAN/{S}-{SUB}/`), script checks `2-LEARN/` for >=1 validated artifact in ANY location per DD-3 LEARN exception — does NOT check `2-LEARN/{S}-{SUB}/DESIGN.md`. AC-27: Cross-subsystem ordering check: subsystem S Build requires subsystem S-1 DESIGN.md to exist in same workstream per DD-3. AC-28: `_cross` follows DD-4 exception rules (no upstream subsystem dependency). |
| A10 | `generate-registry.sh` + registry format | `scripts/generate-registry.sh`, `_genesis/version-registry.md` | Subsystem-granular registry rows for Obsidian Bases queries | AC-29: Registry table rows follow pattern `{WS}×{SUB}×{Stage}` (e.g., `1-ALIGN×1-PD×Design`). AC-30: `_cross` rows appear only when `_cross/DESIGN.md` exists per DD-4. AC-31: `--dry-run` output shows subsystem-granular rows, not WS-aggregate rows. |

**Alignment check (mandatory at G1):**
- [x] Orphan conditions = 0 (every AC maps to an artifact A1-A10)
- [x] Orphan artifacts = 0 (every artifact has >=1 AC)
- [x] Artifact count = 11 (A0-A10)
- [x] AC count = 35 (31 original + AC-14b, AC-25b, AC-26b + AC-00)

---

## Execution Strategy

| Field | Value |
|-------|-------|
| Pattern | Pattern 1: Single Agent Sequential |
| Why this pattern | All 10 items are edits to existing files with clear specs. No competing hypotheses. |
| Why NOT simpler | Cannot be simpler — single agent is the simplest. |
| Agent config | 1x ltc-builder (Sonnet). Orchestrator dispatches per-task. |
| Generator/Critic | `max_iterations: 3`, `cost_cap: ~$0.06/iter` (Sonnet builder + Opus reviewer at Validate) |
| Git strategy | Single branch. Atomic commits per item or logical group (see Dependencies for grouping). |
| Human gates | G1 (this DESIGN.md), G2 (SEQUENCE.md), G3 (Build output), G4 (Validate) |
| EP validation | EP-01 (Design before Build): this doc. EP-03 (human gates): 4 gates. EP-04 (context): <=3 files per dispatch. EP-09 (chain-of-custody): DD-3 specifies rules. |
| Cost estimate | ~10 builder dispatches x ~$0.06 = ~$0.60 total |

---

## Dependencies

```
A4 (gate-state.sh)          ← Foundation: state file format change
  └→ A3 (skill-guard.sh)    ← Reads subsystem from path, checks DESIGN.md
  └→ A8 (provenance-guard)  ← Auto-inits state, extracts subsystem from path
  └→ A9 (dsbv-gate.sh)      ← Chain-of-custody uses subsystem-scoped checks

A1 (/dsbv skill)            ← UX layer: progressive prompting, new signature
  └→ A2 (template scaffold) ← Skill controls what gets generated

A5 (process map P3)         ← Documentation: can be done in parallel with code
A6 (context packaging)      ← Documentation: can be done in parallel with code

A7 (validate-blueprint.py)  ← Validation: should be done after A3/A9 so tests pass
A10 (generate-registry.sh)  ← Registry: should be done after A4 (reads state format)
```

**Build order (3 tiers):**

| Tier | Items | Rationale |
|------|-------|-----------|
| T1 — Foundation | A4 (gate-state) | State file format is upstream of all enforcement scripts |
| T2 — Enforcement | A3 (skill-guard), A8 (provenance-guard), A9 (dsbv-gate) | Guard scripts depend on state format from T1 |
| T3 — UX + Docs + Validation | A1 (skill), A2 (template), A5 (P3), A6 (context-pkg), A7 (validate-bp), A10 (registry) | Skill UX, docs, and validation tools. A7 runs after guards to verify they work. |

---

## Human Gates

| Gate | Trigger | Decision Required |
|------|---------|-------------------|
| G1 | This DESIGN.md complete | Approve artifact inventory and ACs to proceed to SEQUENCE |
| G2 | SEQUENCE.md complete | Approve task ordering, sizing, and session plan |
| G3 | Build complete (all 10 items) | Approve all ACs pass |
| G4 | Validate complete | Approve migration; all enforcement scripts use DD-1 pattern |

Additional gates:
- **Mid-Build check after T1:** Verify `gate-state.sh` state file format is correct before building T2 enforcement scripts on top of it.

---

## Readiness Conditions (Criterion 1-6)

| ID | Condition | Status |
|----|-----------|--------|
| Criterion 1 | Clear scope — in/out written down | GREEN — Q2/Q2b above |
| Criterion 2 | Input materials curated — reading list assembled | GREEN — all 10 source files read and analyzed |
| Criterion 3 | Success rubric defined — per-artifact criteria | GREEN — 34 ACs across 10 artifacts |
| Criterion 4 | Process definition loaded — dsbv-process.md in context | GREEN — template used |
| Criterion 5 | Prompt engineered — context fits effective window | GREEN — DD-1 canonical pattern reduces per-task context |
| Criterion 6 | Evaluation protocol defined — how Human reviews output | GREEN — AC-by-AC binary pass/fail; `validate-blueprint.py` covers structural checks |

---

## Approval Log

| Date | Gate | Decision | Signal | Tier |
|------|------|----------|--------|------|
| | G1 | | | human |
| | G2 | | | human |
| | G3 | | | human |
| | G4 | | | human |

> Only humans write to this table. Agents NEVER set Decision = Approved.

## Links

- [[AGENTS]]
- [[DESIGN]]
- [[SEQUENCE]]
- [[VALIDATE]]
- [[alpei-dsbv-process-map]]
- [[alpei-dsbv-process-map-p3]]
- [[alpei-chain-of-custody]]
- [[context-packaging]]
- [[dsbv-process]]
- [[enforcement-layers]]
- [[filesystem-routing]]
- [[gate-state]]
- [[ltc-builder]]
- [[ltc-planner]]
- [[naming-rules]]
- [[version-registry]]
- [[versioning]]
- [[workstream]]
