---
version: "1.0"
status: draft
last_updated: 2026-04-09
type: dsbv-sequence
stage: sequence
---

# SEQUENCE: DSBV Agent Orchestration SOTA Upgrade

## Summary

- **Total components:** 18 (C-01 through C-18)
- **Total tasks:** 24
- **Build waves:** 6
- **ACs covered:** 35 (AC-30 skipped in DESIGN)
- **Reviewer dispatches:** 4 (R1 after Wave 1, R2 after Wave 3, R3 after Wave 4, R4 after Wave 5)
- **Estimated builder dispatches:** 15 (B-01 through B-15)

## Dependency Graph

```
C-14 (bash3)  ─────────────────────────────────────────────────────┐
C-01 (state machine) ──┬── C-02 (dispatch hook) ──┬── C-04 (gate precheck)  │
                       │   C-07 (model routing) ──┘                          │
                       │   C-13 (5/5 fields) ────┘                           │
                       │   C-17 (exec mode) ─────┘                           │
                       │                                                      │
                       ├── C-09 (gate presentation) ── C-04 ─────────────────┤
                       │                                                      │
                       └── C-08 (circuit breaker) ── C-03 (SubagentStop) ────┤
                                                                              │
C-05 (status T2) ─────────────────────────────────────────────────────────┤
C-06 (approval verify) ──────────────────────────────────────────────────┤
C-03 (SubagentStop) ──┬── C-16 (FAIL data) ── C-12 (reviewer enhance) ──┤
                       └── C-11 (builder enhance) ───────────────────────┤
C-10 (registry sync) ────────────────────────────────────────────────────┤
C-15 (auto-recall) ──────────────────────────────────────────────────────┤
C-18 (LP-6 patterns) ────────────────────────────────────────────────────┤
                                                                           │
                                   SKILL.md rewrite ◄─────────────────────┘
                                   settings.json ◄──────────────────────────
                                         │
                                   Integration tests
```

---

## Wave 0 — Foundation (no upstream dependencies)

### Theme
Create the gate state machine and fix bash 3 compatibility. These are zero-dependency foundation pieces that everything else builds on.

### Dependencies
None. Both tasks are independent of each other and of all existing artifacts.

### Tasks

| Task | Component | Artifact(s) | AC Coverage | Effort |
|------|-----------|-------------|-------------|--------|
| T0.1 | C-01: Gate state machine | `scripts/gate-state.sh`, `.claude/state/` dir, state schema | AC-01, AC-02, AC-03, AC-32 | Medium |
| T0.2 | C-14: Bash 3 compatibility audit + fixes | All scripts in `scripts/` and `.claude/hooks/`, new `scripts/bash3-compat-test.sh` | AC-26, AC-27 | Small-Med |

**T0.1 spec:**
- Create `scripts/gate-state.sh` with subcommands: `init`, `read`, `advance`, `reset`
- Bash 3 compatible (no mapfile, no associative arrays)
- JSON schema per DESIGN.md §3.2 (workstream, subsystem, current_phase, gates G1-G4, loop_state)
- `init` creates `.claude/state/dsbv-{workstream}.json` from template
- `read` outputs current state as JSON
- `advance` transitions gate status (pending → approved, locked → pending)
- State transitions enforced: cannot skip gates, approved is terminal

**T0.2 spec:**
- Audit all `.sh` files in `scripts/` and `.claude/hooks/` for `mapfile` and `declare -A`
- Known hit: `scripts/validate-memory-structure.sh` (S-25 FAIL)
- Replace `mapfile` with `while IFS= read -r` loops
- Replace `declare -A` with case statements or positional variables
- Run `bash -n` on all scripts to verify syntax validity
- Create `scripts/bash3-compat-test.sh` that greps for bash 4+ patterns and runs `bash -n`

**Parallelism:** T0.1 and T0.2 are fully independent. Dispatch both simultaneously.

### BA Check — Wave 0

After Wave 0, these L1 checks should flip from FAIL to PASS:

| Check | Current | Expected | Component |
|-------|---------|----------|-----------|
| S-20 | FAIL | PASS | C-01 — `scripts/gate-state.sh` exists |
| S-25 | FAIL | PASS | C-14 — no bash 4+ features in scripts |
| Sc-01 | FAIL | PASS | C-01 — `.claude/state/` directory exists |

**Verification command:** `python3 scripts/dsbv-benchmark-l1.py | grep -E 'S-20|S-25|Sc-01'`
**Expected:** 3 checks flip FAIL→PASS. Baseline 27/44 → 30/44 (68.2%).

---

## Wave 1 — Core Hooks + Small Scripts (depends on Wave 0)

### Theme
Build the hook upgrades and small utility scripts that form the enforcement backbone. These consume the state machine from Wave 0.

### Dependencies
- T1.1 depends on T0.1 (reads gate state file)
- T1.2, T1.3, T1.4, T1.5 have no dependency on T0.1 (independent scripts)

### Tasks

| Task | Component | Artifact(s) | AC Coverage | Effort |
|------|-----------|-------------|-------------|--------|
| T1.1 | C-02 + C-07 + C-13 + C-17: Enhanced Agent dispatch hook | `.claude/hooks/verify-agent-dispatch.sh` (upgrade) | AC-04, AC-05, AC-06, AC-07 | Medium |
| T1.2 | C-03 + C-16: Enhanced SubagentStop hook | `.claude/hooks/verify-deliverables.sh` (upgrade), `.claude/logs/dsbv-metrics.jsonl` | AC-08, AC-09, AC-10, AC-11 | Medium |
| T1.3 | C-05: Status T2 transition script | `scripts/set-status-in-review.sh` | AC-14 | Small |
| T1.4 | C-06: Approval record verify script | `scripts/verify-approval-record.sh` | AC-15, AC-16 | Small |
| T1.5 | C-08: Circuit breaker classify-fail script | `scripts/classify-fail.sh` | AC-17, AC-18 (partial) | Small |

**T1.1 spec (C-02/C-07/C-13/C-17 bundled):**
- Extend `verify-agent-dispatch.sh` to check ALL 5 context packaging markers: `## 1. EO`, `## 2. INPUT`, `## 3. EP`, `## 4. OUTPUT`, `## 5. VERIFY`
- Add model routing check: extract agent name from prompt → read `.claude/agents/{name}.md` frontmatter `model:` → WARN if mismatch (non-blocking per ADR-05)
- Add gate state check: read `.claude/state/dsbv-{workstream}.json` → if dispatching builder, require G2=approved; reviewer requires G3=approved; planner-for-sequence requires G1=approved
- Add budget field validation: grep for `### Budget` or `max_tool_calls` in prompt → WARN if missing
- Add phase-agent compatibility: read `current_phase` from state → WARN if dispatching planner during build phase
- **G-02 addressed here:** Model routing check spec is the agent name → frontmatter lookup → WARN flow

**T1.2 spec (C-03/C-16 bundled):**
- Enhance `verify-deliverables.sh`:
  - Parse DONE line: extract `<path>`, `<pass>/<total>`, `<blockers>` — validate all 3 fields present and well-formed; exit 1 on malformed schema
  - Verify artifact path exists on disk: `test -f "$ARTIFACT_PATH"` — exit 1 if missing
  - Log metrics to `.claude/logs/dsbv-metrics.jsonl` on every dispatch return (PASS or FAIL)
  - Log FAIL verdicts with criterion text and error_type when available
  - AC count match: if DESIGN.md path is extractable from context, compare `<total>` against actual count; WARN on mismatch

**T1.3 spec (C-05):**
- Create `scripts/set-status-in-review.sh`: takes file path, sets `status: in-review` via sed
- Bash 3 compatible
- Idempotent: if already `in-review`, no-op
- Updates `last_updated` to today's date

**T1.4 spec (C-06):**
- Create `scripts/verify-approval-record.sh`: takes file path, greps for approval record row
- Pattern: table row containing date (YYYY-MM-DD format) + signal text + tier classification
- Exit 0 if found, exit 1 if not found
- Error message: "Approval record not found in {file}. Verify manually before setting status: validated."

**T1.5 spec (C-08 partial):**
- Create `scripts/classify-fail.sh`: takes FAIL text as argument, returns classification
- Classifications: SYNTACTIC (missing/format/frontmatter/structure), SEMANTIC (wrong/incorrect/misunderstood/content), ENVIRONMENTAL (not found/permission/script failed/exit code), SCOPE (not in SEQUENCE/out of scope/needs research)
- Rule-based: keyword grep against the input text
- Default: SYNTACTIC if no keywords match
- Bash 3 compatible

**Parallelism:** T1.1 depends on T0.1. T1.2, T1.3, T1.4, T1.5 are all independent of each other and independent of T0.1. Dispatch T1.2-T1.5 immediately after Wave 0 completes. Dispatch T1.1 after T0.1 specifically completes.

### BA Check — Wave 1

After Wave 1, these L1 checks should flip from FAIL to PASS:

| Check | Current | Expected | Component |
|-------|---------|----------|-----------|
| S-14 | FAIL | PASS | C-02/C-13 — hook checks all 5 fields |
| S-22 | FAIL | PASS | C-06 — `scripts/verify-approval-record.sh` exists |
| S-23 | FAIL | PASS | C-08 — `scripts/classify-fail.sh` exists |
| S-24 | FAIL | PASS | C-05 — `scripts/set-status-in-review.sh` exists |
| E-02 | FAIL | PASS | C-07 — dispatch hook has model routing check |
| E-08 | FAIL | PASS | C-02 — dispatch hook has budget field check |
| Sc-07 | FAIL | PASS | C-17 — phase-agent compatibility guard in dispatch hook |

**Verification command:** `python3 scripts/dsbv-benchmark-l1.py | grep -E 'S-14|S-22|S-23|S-24|E-02|E-08|Sc-07'`
**Expected:** 7 checks flip FAIL→PASS. Running total: 37/44 (84.1%).

### Reviewer Dispatch Point — R1 (after Wave 1)

Dispatch `ltc-reviewer` against Wave 0 + Wave 1 artifacts.

**ACs to review:** AC-01 through AC-11, AC-14, AC-15, AC-16, AC-17 (partial), AC-26, AC-27, AC-32.
**DESIGN.md section:** §4 (C-01 through C-08, C-13, C-16, C-17) and §5 (corresponding ACs).
**Circuit breaker:** Max 3 iterations. If same FAIL persists 2 iterations → ESCALATE to PM.

---

## Wave 2 — Integration Layer (depends on Wave 1)

### Theme
Build the gate pre-check system, circuit breaker state integration, registry sync hook, and auto-recall filtering. These components consume hooks and scripts from Wave 1.

### Dependencies
- T2.1 depends on T0.1 (C-01 state file) + T1.2 (C-03 metrics log)
- T2.2 depends on T0.1 (C-01 state file) + T1.2 (C-03 metrics log) + T1.5 (classify-fail.sh)
- T2.3 has no upstream dependency (new PostToolUse hook)
- T2.4 has no upstream dependency (new UserPromptSubmit hook)

### Tasks

| Task | Component | Artifact(s) | AC Coverage | Effort |
|------|-----------|-------------|-------------|--------|
| T2.1 | C-04: Gate pre-check script | `scripts/gate-precheck.sh` | AC-12, AC-13, AC-33 | Small |
| T2.2 | C-08 (full): Circuit breaker state integration | SKILL.md circuit breaker section draft, state file `loop_state` update | AC-17, AC-18, AC-19 | Medium |
| T2.3 | C-10: Registry sync PostToolUse hook | `scripts/registry-edit-tracker.sh`, `.claude/state/registry-dirty.json` | AC-25 | Small |
| T2.4 | C-15: Auto-recall relevance filtering | UserPromptSubmit hook update (intent parsing + token budget) | AC-28, AC-29 | Medium |

**T2.1 spec (C-04):**
- Create `scripts/gate-precheck.sh`: takes gate ID (G1-G4) and workstream as args
- G1 prerequisites: DESIGN.md exists in workstream root, `grep -c 'AC-' DESIGN.md` > 0
- G2 prerequisites: SEQUENCE.md exists, `grep -c 'Task\|T[0-9]' SEQUENCE.md` > 0
- G3 prerequisites: All tasks from SEQUENCE.md have completion records in `.claude/logs/dsbv-metrics.jsonl`
- G4 prerequisites: VALIDATE.md exists, grep for aggregate score line
- Exit 0 if all prerequisites met, exit 1 with specific error if not
- Bash 3 compatible
- **G-01 addressed here (partial):** Gate pre-check is Step 1 of the 6-step gate approval sequence

**T2.2 spec (C-08 full):**
- Draft circuit breaker protocol section for SKILL.md integration in Wave 4 (T4.1)
- After each reviewer return: parse VALIDATE.md FAIL items, classify each via `classify-fail.sh`
- Hard-stop rules: same FAIL persists 2 iterations → ESCALATE; 2 consecutive agent failures → STOP; all-SEMANTIC → ESCALATE immediately
- Cost tracking: update `loop_state.cost_tokens` in state file per iteration
- **G-04 addressed here:** Hard-stop classification table: SYNTACTIC=retry, SEMANTIC=escalate immediately, ENVIRONMENTAL=fix then retry, SCOPE=escalate immediately

**T2.3 spec (C-10):**
- Create `scripts/registry-edit-tracker.sh`: PostToolUse hook
- Triggered on Write/Edit: check if path matches `[1-5]-*/` workstream artifact pattern
- If match: check `.claude/state/registry-dirty.json` for session tracking
- If registry not yet updated this session: WARN "Workstream artifact edited but registry not yet updated"
- Bash 3 compatible

**T2.4 spec (C-15):**
- Update or create UserPromptSubmit hook for auto-recall filtering
- Parse intent from user prompt: keywords map to categories (design/build/validate/research/general)
- Pass intent to QMD query as parameter — include "intent" keyword in hook file (for E-05 check)
- Token budget: relevance >= 0.5 → 2000 tokens; relevance < 0.5 → 1000 tokens; no results → skip
- Both thresholds (2000, 1000) must appear in hook file (for E-06 check)

**Parallelism:** T2.1 and T2.2 share dependency on T0.1 + T1.2 but don't depend on each other. T2.3 and T2.4 are fully independent. All 4 tasks can be dispatched in parallel once their upstream tasks complete.

### BA Check — Wave 2

After Wave 2, these L1 checks should flip from FAIL to PASS:

| Check | Current | Expected | Component |
|-------|---------|----------|-----------|
| S-21 | FAIL | PASS | C-04 — `scripts/gate-precheck.sh` exists |
| E-05 | FAIL | PASS | C-15 — hooks contain intent-based filtering |
| E-06 | FAIL | PASS | C-15 — hooks contain both 2000 and 1000 thresholds |

**Verification command:** `python3 scripts/dsbv-benchmark-l1.py | grep -E 'S-21|E-05|E-06'`
**Expected:** 3 checks flip FAIL→PASS. Running total: 40/44 (90.9%).

---

## Wave 3 — Agent File Updates (depends on Waves 1-2)

### Theme
Update the 4 agent files with enhanced inline protocols. These reference scripts and data files created in earlier waves.

### Dependencies
- T3.1 depends on T1.5 (classify-fail.sh) + T1.2 (C-03 report schema)
- T3.2 depends on T1.2 (C-03 metrics file path) + T2.2 (circuit breaker protocol)
- T3.3 has no hard dependency but logically follows the DESIGN

### Tasks

| Task | Component | Artifact(s) | AC Coverage | Effort |
|------|-----------|-------------|-------------|--------|
| T3.1 | C-11: Builder agent file enhancement | `.claude/agents/ltc-builder.md` | AC-20, AC-21 | Small |
| T3.2 | C-12: Reviewer agent file enhancement | `.claude/agents/ltc-reviewer.md` | AC-22, AC-23 | Small |
| T3.3 | C-18: LP-6 live test patterns + planner update | `.claude/agents/ltc-planner.md`, `.claude/skills/dsbv/references/live-test-patterns.md` | AC-24 | Small |

**T3.1 spec (C-11):**
- Add to builder's Sub-Agent Safety section:
  - Smoke test requirement: "Before reporting DONE, run `bash -n` for .sh, `python3 -c 'import ast; ast.parse(open(f).read())'` for .py, `skill-validator.sh` for skills"
  - LP-6 reference: "If DESIGN.md AC references an external system or live command, execute the live test within read-only safety bounds"
  - Error classification awareness: "If you encounter a FAIL, classify as SYNTACTIC/SEMANTIC/ENVIRONMENTAL/SCOPE in your report"
  - Enhanced completion report: optional `assumptions:`, `uncertain_fields:`, `confidence_score:` fields
- Keep under 200 lines (UBS-03 mitigation)

**T3.2 spec (C-12):**
- Add to reviewer's pre-flight section:
  - Strict criterion count: "Count criteria in DESIGN.md. Count checks in your VALIDATE.md. If mismatch, validation is incomplete."
  - Historical FAIL data: "Read `.claude/logs/dsbv-metrics.jsonl` for this workstream. If previous FAIL patterns exist, prioritize checking those criteria first."
  - Pre-flight blocking: "If DESIGN.md is NOT in your context, STOP and report BLOCKED."
  - Reference `dsbv-metrics` by name (for S-08 check)
  - **G-03 addressed here:** Reviewer pre-flight validation section enhanced with 3 additional checks

**T3.3 spec (C-18):**
- Add to planner's Design Quality Checks: "If the EO references an external system (CLI, API, service), at least one AC must include a live invocation test. Cite LP-6."
- Create `.claude/skills/dsbv/references/live-test-patterns.md` with examples: CLI tool smoke test, API endpoint health check, file system operation test, Obsidian REST API test

**Parallelism:** T3.1, T3.2, T3.3 are fully independent (different files). Dispatch all 3 simultaneously.

### BA Check — Wave 3

After Wave 3, these L1 checks should flip from FAIL to PASS:

| Check | Current | Expected | Component |
|-------|---------|----------|-----------|
| S-06 | FAIL | PASS | C-11 — builder has smoke test requirement |
| S-07 | FAIL | PASS | C-11 — builder has LP-6 reference |
| S-08 | FAIL | PASS | C-12 — reviewer has dsbv-metrics reference |
| S-10 | FAIL | PASS | C-18 — planner has LP-6 reference |

**Verification command:** `python3 scripts/dsbv-benchmark-l1.py | grep -E 'S-06|S-07|S-08|S-10'`
**Expected:** 4 checks flip FAIL→PASS. Running total: 44/44 (100%).

**All 17 FAIL checks should now be PASS.** Full L1 score: 44/44 = 100%.

### Reviewer Dispatch Point — R2 (after Wave 3)

Dispatch `ltc-reviewer` against Wave 2 + Wave 3 artifacts.

**ACs to review:** AC-12, AC-13, AC-17 (full), AC-18, AC-19, AC-20, AC-21, AC-22, AC-23, AC-24, AC-25, AC-28, AC-29, AC-33.
**DESIGN.md section:** §4 (C-04, C-08, C-10, C-11, C-12, C-15, C-18) and §5 (corresponding ACs).
**Circuit breaker:** Max 3 iterations.

---

## Wave 4 — SKILL.md Rewrite + Settings (depends on all prior waves)

### Theme
Integrate all components into the unified DSBV skill and wire new hooks into settings.json. This is the convergence wave where scattered scripts and hooks become a cohesive system.

### Dependencies
- T4.1 depends on ALL prior tasks (integrates C-01 through C-18 into skill protocol)
- T4.2 depends on T1.1, T1.2, T2.3, T2.4 (all hooks that need wiring)
- T4.3 depends on T0.1 (C-01 state file) + T2.1 (C-04 gate precheck)

### Tasks

| Task | Component | Artifact(s) | AC Coverage | Effort |
|------|-----------|-------------|-------------|--------|
| T4.1 | C-09 + SKILL.md full rewrite | `.claude/skills/dsbv/SKILL.md`, `.claude/skills/dsbv/references/gate-prechecks.md` | Supports all ACs (orchestration backbone) | Large |
| T4.2 | settings.json hook wiring | `.claude/settings.json` | Supports AC-04 through AC-11, AC-25, AC-28, AC-29 | Small |
| T4.3 | Context packaging reference update | `.claude/skills/dsbv/references/context-packaging.md` | Supports AC-04 (5-field validation) | Small |

**T4.1 spec (SKILL.md rewrite — ~600 lines target):**

Internal structure:
1. **Phase Definitions** (Design/Sequence/Build/Validate) — minor updates
2. **Gate Approval Protocol** — consolidated 6-step sequence:
   - Step 1: `gate-precheck.sh` validates prerequisites (C-04)
   - Step 2: `set-status-in-review.sh` updates artifact status (C-05)
   - Step 3: Present structured gate template (C-09)
   - Step 4: Detect approval signal (existing Tier catalog)
   - Step 5: `verify-approval-record.sh` confirms write (C-06)
   - Step 6: `gate-state.sh advance` updates state (C-01)
   - **G-01 fully addressed here**
3. **Approval Signal Detection** — existing Tier catalog, no change
4. **Generator/Critic Loop Protocol** — enhanced with circuit breaker (C-08 from T2.2)
   - Parse VALIDATE.md FAIL items
   - Classify via `classify-fail.sh`
   - Apply hard-stop rules (G-04 classification table)
   - Update `loop_state` in state file
   - Max 3 iterations (circuit breaker)
5. **Parallel Dispatch Protocol** — minor updates
6. **Pipeline State Persistence Schema** — updated to match C-01 state file
7. **Auto-Recall Relevance Filtering Spec** — updated to reference C-15 hook

References to update:
- `references/context-packaging.md` — per-phase examples updated (G-05, handled in T4.3)
- `references/gotchas.md` — add new failure patterns from RC-01 through RC-16
- `references/gate-prechecks.md` — NEW: per-gate prerequisite checklists

**T4.2 spec (settings.json):**
- Wire `PostToolUse` → `registry-edit-tracker.sh` (C-10) — matcher: Write|Edit on `[1-5]-*/` paths
- Wire `UserPromptSubmit` → auto-recall hook (C-15) — new entry or extend existing
- Verify existing entries: PreToolUse Agent → verify-agent-dispatch.sh, SubagentStop → verify-deliverables.sh
- Run `python3 -c "import json; json.load(open('.claude/settings.json'))"` before reporting DONE

**T4.3 spec (context-packaging.md):**
- Update per-phase examples to include all 5 fields (EP and OUTPUT were missing from some examples)
- Add budget field example to each template
- **G-05 addressed here**

**Parallelism:** T4.2 and T4.3 can run in parallel after T4.1 is substantially complete.

### BA Check — Wave 4

No new L1 FAIL→PASS flips expected (all 44 should already PASS after Wave 3). Validate integration:

- Full L1: `python3 scripts/dsbv-benchmark-l1.py` → 44/44 (no regressions)
- Valid JSON: `python3 -c "import json; json.load(open('.claude/settings.json'))"`
- SKILL.md sections: `grep -c 'Gate Approval Protocol\|Circuit Breaker\|Approval Signal\|Pipeline State' .claude/skills/dsbv/SKILL.md` >= 4

### Reviewer Dispatch Point — R3 (after Wave 4)

Dispatch `ltc-reviewer` against Wave 4 artifacts (SKILL.md, settings.json, context-packaging.md).

**Focus:** Structural correctness of the orchestration backbone. Does the 6-step gate protocol flow correctly? Does the circuit breaker classification table match DESIGN? Are all script paths correct?
**Circuit breaker:** Max 3 iterations.

---

## Wave 5 — Live Smoke Tests (depends on all prior waves)

### Theme
Execute live system tests to verify the upgrade works end-to-end, not just structurally. LP-6 lesson applied: test the live system, not just the files.

### Dependencies
All prior waves must be complete.

### Tasks

| Task | Component | Artifact(s) | AC Coverage | Effort |
|------|-----------|-------------|-------------|--------|
| T5.1 | Live smoke tests | Test results documented in report | AC-31, AC-32, AC-33, AC-34 | Small |
| T5.2 | Integration test: full DSBV flow | Test results, state file verification | AC-35, AC-36 | Medium |

**T5.1 spec (live smoke tests):**
- AC-31: Modify version in `_genesis/version-registry.md`, run `/dsbv status`, verify output reflects change
- AC-32: Run `scripts/gate-state.sh read 1-ALIGN` → verify valid JSON output
- AC-33: Run `scripts/gate-precheck.sh G1 1-ALIGN` against workstream with no DESIGN.md → verify exit non-zero
- AC-34: Run `scripts/classify-fail.sh "Missing frontmatter field"` → verify returns "SYNTACTIC"

**T5.2 spec (integration test):**
1. Initialize: `scripts/gate-state.sh init 1-ALIGN`
2. Simulate `/dsbv design ALIGN` → verify state file created with G1=pending
3. Simulate G1 approval → verify G1=approved, G2=pending (AC-35)
4. Simulate `/dsbv sequence ALIGN` → verify G2 advances after approval (AC-35)
5. Simulate builder FAIL → reviewer catches → builder fixes in iteration 2 → reviewer confirms PASS → verify `loop_state.iteration = 2` (AC-36)

**Parallelism:** T5.1 and T5.2 can run in parallel (different test scopes).

### BA Check — Wave 5

- All 4 live smoke tests pass (AC-31 through AC-34)
- Integration flow completes without error (AC-35, AC-36)
- Full L1 benchmark: 44/44 PASS (no regressions)
- Run L2 benchmark for delta: `./scripts/dsbv-benchmark.sh --l2` → compare against baseline (L1=61.4%, L2=4.02)

---

## Build Agent Dispatch Order

### Wave 0 (2 dispatches, parallel)

**B-01: Gate State Machine (T0.1)**
```
EO: Create gate-state.sh + .claude/state/ directory
INPUT: DESIGN.md §C-01, state schema §3.2
EP: Bash 3 compatible, JSON state file, 4 subcommands (init/read/advance/reset)
OUTPUT: scripts/gate-state.sh, .claude/state/ dir
VERIFY: AC-01, AC-02, AC-03, AC-32
Budget: max_tool_calls=30
```

**B-02: Bash 3 Compatibility (T0.2)**
```
EO: Audit and fix all bash 4+ features in scripts + hooks
INPUT: S-25 FAIL detail (validate-memory-structure.sh), all .sh files
EP: Replace mapfile with while-read, declare -A with case, run bash -n on each
OUTPUT: Updated scripts, scripts/bash3-compat-test.sh
VERIFY: AC-26, AC-27
Budget: max_tool_calls=25
```

### Wave 1 (3 dispatches, T1.1 after B-01, others parallel)

**B-03: Enhanced Agent Dispatch Hook (T1.1)** — after B-01
```
EO: Upgrade verify-agent-dispatch.sh — 5/5 fields + model + state + budget + phase
INPUT: Current hook, DESIGN.md §C-02/C-07/C-13/C-17, gate-state.sh from B-01
EP: Extend existing, WARN not BLOCK for model/budget/phase
OUTPUT: .claude/hooks/verify-agent-dispatch.sh
VERIFY: AC-04, AC-05, AC-06, AC-07
Budget: max_tool_calls=25
```

**B-04: Enhanced SubagentStop Hook (T1.2)** — parallel with B-03
```
EO: Upgrade verify-deliverables.sh — schema validation + disk check + metrics
INPUT: Current hook, DESIGN.md §C-03/C-16
EP: Parse DONE line schema, test -f artifact, JSONL append
OUTPUT: .claude/hooks/verify-deliverables.sh, .claude/logs/ dir
VERIFY: AC-08, AC-09, AC-10, AC-11
Budget: max_tool_calls=25
```

**B-05: Small Scripts Bundle (T1.3 + T1.4 + T1.5)** — parallel with B-03/B-04
```
EO: Create 3 utility scripts: set-status-in-review.sh, verify-approval-record.sh, classify-fail.sh
INPUT: DESIGN.md §C-05, §C-06, §C-08
EP: Bash 3 compatible, single-purpose, exit code conventions
OUTPUT: scripts/set-status-in-review.sh, scripts/verify-approval-record.sh, scripts/classify-fail.sh
VERIFY: AC-14, AC-15, AC-16, AC-17, AC-18
Budget: max_tool_calls=20
```

### Wave 2 (3 dispatches, parallel)

**B-06: Gate Pre-Check Script (T2.1)** — after B-01, B-04
```
EO: Create gate-precheck.sh with per-gate G1-G4 prerequisite validation
INPUT: DESIGN.md §C-04, gate-state.sh, dsbv-metrics.jsonl schema
EP: G1-G4 each has specific prereqs, bash 3, exit 0/1
OUTPUT: scripts/gate-precheck.sh
VERIFY: AC-12, AC-13, AC-33
Budget: max_tool_calls=20
```

**B-07: Circuit Breaker Integration (T2.2)** — after B-01, B-04, B-05
```
EO: Draft circuit breaker protocol for SKILL.md integration (T4.1)
INPUT: DESIGN.md §C-08, classify-fail.sh, gate-state.sh loop_state schema
EP: Hard-stop table (SYNTACTIC/SEMANTIC/ENVIRONMENTAL/SCOPE), cost tracking, max 3 iterations
OUTPUT: Protocol section draft (for T4.1), state file loop_state update
VERIFY: AC-17, AC-18, AC-19
Budget: max_tool_calls=20
```

**B-08: Registry Sync + Auto-Recall (T2.3 + T2.4)** — parallel, no Wave 2 upstream deps
```
EO: Create registry-edit-tracker.sh (PostToolUse) + auto-recall intent filter (UserPromptSubmit)
INPUT: DESIGN.md §C-10, §C-15
EP: PostToolUse checks workstream paths, UserPromptSubmit parses intent + both token thresholds
OUTPUT: scripts/registry-edit-tracker.sh, .claude/state/registry-dirty.json, auto-recall hook
VERIFY: AC-25, AC-28, AC-29
Budget: max_tool_calls=25
```

### Wave 3 (3 dispatches, parallel)

**B-09: Builder Agent Enhancement (T3.1)**
```
EO: Add smoke test + LP-6 + error classification to ltc-builder.md
INPUT: DESIGN.md §C-11, current .claude/agents/ltc-builder.md
EP: Keep under 200 lines, reference scripts by path, numbered checklist
OUTPUT: .claude/agents/ltc-builder.md
VERIFY: AC-20, AC-21
Budget: max_tool_calls=15
```

**B-10: Reviewer Agent Enhancement (T3.2)**
```
EO: Add criterion count + dsbv-metrics + pre-flight blocking to ltc-reviewer.md
INPUT: DESIGN.md §C-12, current .claude/agents/ltc-reviewer.md
EP: Reference dsbv-metrics.jsonl by path, strict count matching, blocking on missing DESIGN.md
OUTPUT: .claude/agents/ltc-reviewer.md
VERIFY: AC-22, AC-23
Budget: max_tool_calls=15
```

**B-11: Planner LP-6 + Live Test Patterns (T3.3)**
```
EO: Add LP-6 live test AC requirement to planner + create live-test-patterns.md
INPUT: DESIGN.md §C-18, current .claude/agents/ltc-planner.md
EP: External integration → at least 1 live test AC required, examples in references/
OUTPUT: .claude/agents/ltc-planner.md, .claude/skills/dsbv/references/live-test-patterns.md
VERIFY: AC-24
Budget: max_tool_calls=15
```

### Wave 4 (T4.1 first, then T4.2+T4.3 parallel)

**B-12: SKILL.md Full Rewrite (T4.1)**
```
EO: Integrate all 18 components into unified DSBV skill (~600 lines)
INPUT: DESIGN.md §3-4, all scripts from Waves 0-3, all agent files from Wave 3
EP: 7 protocol sections, 6-step gate sequence, circuit breaker, references/ dir
OUTPUT: .claude/skills/dsbv/SKILL.md, .claude/skills/dsbv/references/gate-prechecks.md
VERIFY: All ACs indirectly (orchestration backbone)
Budget: max_tool_calls=40
```

**B-13: Settings + Context Packaging (T4.2 + T4.3)** — after B-12
```
EO: Wire new hooks into settings.json + update context-packaging.md 5-field examples
INPUT: Current settings.json, DESIGN.md §C-10/C-15 hook specs, current context-packaging.md
EP: Valid JSON output, all 5 fields in per-phase examples, budget field in each template
OUTPUT: .claude/settings.json, .claude/skills/dsbv/references/context-packaging.md
VERIFY: JSON valid, 5-field examples present
Budget: max_tool_calls=20
```

### Wave 5 (2 dispatches, parallel)

**B-14: Live Smoke Tests (T5.1)**
```
EO: Execute and document 4 live smoke tests (AC-31 through AC-34)
INPUT: All scripts from prior waves, test specifications from DESIGN.md §5
EP: Each test shows actual command + actual output + PASS/FAIL verdict
OUTPUT: Test results (in completion report)
VERIFY: AC-31, AC-32, AC-33, AC-34
Budget: max_tool_calls=20
```

**B-15: Integration Test (T5.2)**
```
EO: Execute full DSBV design→sequence flow + generator/critic loop test
INPUT: All artifacts from prior waves, test specifications from DESIGN.md §5
EP: State file must track all transitions, loop_state must show iteration=2
OUTPUT: Test results, state file snapshots
VERIFY: AC-35, AC-36
Budget: max_tool_calls=30
```

**Total: 15 builder dispatches (B-01 through B-15)**

---

## Reviewer Dispatch Points

| Review | After Wave | ACs Reviewed | Focus |
|--------|-----------|-------------|-------|
| R1 | Wave 1 | AC-01 through AC-11, AC-14, AC-15, AC-16, AC-17 (partial), AC-26, AC-27, AC-32 | Foundation + hooks: scripts exist, bash 3 safe, hooks check right things |
| R2 | Wave 3 | AC-12, AC-13, AC-17 (full), AC-18, AC-19, AC-20 through AC-24, AC-25, AC-28, AC-29, AC-33 | Integration + agents: gate prechecks, agent files enhanced, new hooks fire |
| R3 | Wave 4 | SKILL.md structural review, settings.json validity, context-packaging.md completeness, G-01 through G-05 closure | Orchestration backbone: 6-step gate protocol, circuit breaker table, script paths |
| R4 (final) | Wave 5 | AC-31 through AC-36, full L1 regression, L2 delta | End-to-end: live tests pass, L1=44/44, L2 improved from baseline |

**Circuit breaker for all reviews:** Max 3 iterations. Same FAIL across 2 iterations → ESCALATE to PM with diagnostic.

---

## Reviewer Gap Closure Tracker

| Gap | Description | Addressed In | Task |
|-----|-------------|-------------|------|
| G-01 | SKILL.md Gate Approval Protocol needs explicit 6-step sequence | Wave 4 | T4.1 (SKILL.md rewrite, §Gate Approval Protocol) |
| G-02 | verify-agent-dispatch.sh needs model routing check spec | Wave 1 | T1.1 (dispatch hook upgrade, model check) |
| G-03 | ltc-reviewer.md needs pre-flight validation section enhancement | Wave 3 | T3.2 (reviewer agent file, pre-flight additions) |
| G-04 | Generator/Critic loop needs hard-stop classification table | Wave 2 | T2.2 (circuit breaker integration, classification table) |
| G-05 | context-packaging.md needs per-phase examples updated | Wave 4 | T4.3 (context-packaging.md update) |

---

## Risk Register

| ID | Risk | Prob | Impact | Mitigation | Wave |
|----|------|------|--------|------------|------|
| R-01 | Gate state machine too complex for single dispatch | Med | Med | T0.1 is Medium effort. If builder struggles, split into init/read and advance/reset sub-tasks. | 0 |
| R-02 | Dispatch hook grows too large (C-02 bundles 4 components) | Med | Med | T1.1 bundles C-02/C-07/C-13/C-17. If >150 lines, extract helpers into `scripts/dispatch-helpers.sh`. | 1 |
| R-03 | SKILL.md rewrite exceeds 600-line target | High | Med | Move content to `references/` files. Hard cap: 650 lines. | 4 |
| R-04 | Bash 3 compatibility (RC-14) — macOS default shell | Med | High | T0.2 runs first (Wave 0). `bash3-compat-test.sh` runs in every BA check. All new scripts run under `/bin/bash`. | All |
| R-05 | Hook false positives block legitimate work | Med | High | Every new hook WARNs for ambiguous cases, only BLOCKs on clear violations. | 1-2 |
| R-06 | settings.json invalid JSON after T4.2 | Low | High | T4.2 includes JSON validation step. Builder must pass `python3 -c "import json; json.load(open('.claude/settings.json'))"` before DONE. | 4 |
| R-07 | Integration test (T5.2) partial failures hard to diagnose | Med | Med | Fresh state file init. Each step logged. State file snapshot at each step enables bisection. | 5 |
| R-08 | L2 delta modest (baseline already 4.02/5.0) | High | Low | Expected: L1 jumps (61.4% → 100%), L2 improves modestly (4.02 → 4.5+). Value is converting documentation quality into mechanical enforcement. | 5 |
| R-09 | dsbv-metrics.jsonl grows unbounded | Med | Low | Log rotation deferred. Add rotation note in SKILL.md. | 1 |

---

## L1 Benchmark Progression Tracker

| Wave | Checks Flipped | Running Total | L1 Score |
|------|---------------|---------------|----------|
| Baseline | — | 27/44 | 61.4% |
| Wave 0 | S-20, S-25, Sc-01 (+3) | 30/44 | 68.2% |
| Wave 1 | S-14, S-22, S-23, S-24, E-02, E-08, Sc-07 (+7) | 37/44 | 84.1% |
| Wave 2 | S-21, E-05, E-06 (+3) | 40/44 | 90.9% |
| Wave 3 | S-06, S-07, S-08, S-10 (+4) | 44/44 | 100% |
| Wave 4 | (regression check — maintain 44/44) | 44/44 | 100% |
| Wave 5 | (regression check + live tests) | 44/44 | 100% |

---

## AC Coverage Matrix

| AC | Task(s) | Wave | Component(s) |
|----|---------|------|-------------|
| AC-01 | T0.1 | 0 | C-01 |
| AC-02 | T0.1 | 0 | C-01 |
| AC-03 | T0.1, T1.1 | 0, 1 | C-01, C-02 |
| AC-04 | T1.1 | 1 | C-02, C-13 |
| AC-05 | T1.1 | 1 | C-02, C-07 |
| AC-06 | T1.1 | 1 | C-02, C-17 |
| AC-07 | T1.1 | 1 | C-02 |
| AC-08 | T1.2 | 1 | C-03 |
| AC-09 | T1.2 | 1 | C-03 |
| AC-10 | T1.2 | 1 | C-03, C-16 |
| AC-11 | T1.2 | 1 | C-03, C-16 |
| AC-12 | T2.1 | 2 | C-04 |
| AC-13 | T2.1 | 2 | C-04 |
| AC-14 | T1.3 | 1 | C-05 |
| AC-15 | T1.4 | 1 | C-06 |
| AC-16 | T1.4 | 1 | C-06 |
| AC-17 | T1.5, T2.2 | 1, 2 | C-08 |
| AC-18 | T1.5, T2.2 | 1, 2 | C-08 |
| AC-19 | T2.2 | 2 | C-08 |
| AC-20 | T3.1 | 3 | C-11 |
| AC-21 | T3.1 | 3 | C-11 |
| AC-22 | T3.2 | 3 | C-12 |
| AC-23 | T3.2 | 3 | C-12 |
| AC-24 | T3.3 | 3 | C-18 |
| AC-25 | T2.3 | 2 | C-10 |
| AC-26 | T0.2 | 0 | C-14 |
| AC-27 | T0.2 | 0 | C-14 |
| AC-28 | T2.4 | 2 | C-15 |
| AC-29 | T2.4 | 2 | C-15 |
| AC-30 | (skipped in DESIGN) | — | — |
| AC-31 | T5.1 | 5 | LP-6 live |
| AC-32 | T5.1 | 5 | C-01 live |
| AC-33 | T5.1 | 5 | C-04 live |
| AC-34 | T5.1 | 5 | C-08 live |
| AC-35 | T5.2 | 5 | Integration |
| AC-36 | T5.2 | 5 | Integration |

**Coverage: 35/35 ACs mapped. All 18 components in at least one task.**

---

## Component → Task Mapping

| Component | Task(s) | Wave |
|-----------|---------|------|
| C-01 | T0.1 | 0 |
| C-02 | T1.1 | 1 |
| C-03 | T1.2 | 1 |
| C-04 | T2.1 | 2 |
| C-05 | T1.3 | 1 |
| C-06 | T1.4 | 1 |
| C-07 | T1.1 (bundled) | 1 |
| C-08 | T1.5, T2.2 | 1, 2 |
| C-09 | T4.1 (bundled) | 4 |
| C-10 | T2.3 | 2 |
| C-11 | T3.1 | 3 |
| C-12 | T3.2 | 3 |
| C-13 | T1.1 (bundled) | 1 |
| C-14 | T0.2 | 0 |
| C-15 | T2.4 | 2 |
| C-16 | T1.2 (bundled) | 1 |
| C-17 | T1.1 (bundled) | 1 |
| C-18 | T3.3 | 3 |

## Links

- [[2026-04-09_DESIGN-planner-dsbv-agent-enforcement-upgrade]]
- [[2026-04-09_RESULT-dsbv-agent-benchmark-baseline]]
- [[AGENTS]]
- [[DESIGN]]
- [[SEQUENCE]]
- [[VALIDATE]]
- [[enforcement-layers]]
- [[ltc-builder]]
- [[ltc-planner]]
- [[ltc-reviewer]]
