---
version: "1.0"
status: draft
last_updated: 2026-04-08
type: sequence
work_stream: 0-GOVERN
agent: planner
parent: inbox/2026-04-08_DESIGN-agent-2-planner.md
scope: all-proposals
---

# SEQUENCE B: Agent 2 — ltc-planner (All Proposals)

> **DESIGN:** `inbox/2026-04-08_DESIGN-agent-2-planner.md`
> **Scope:** 7 actionable proposals (2 accepted/no-action excluded).
> **Path:** MOSTLY INDEPENDENT — one cross-ref (rule loading test shares result with SEQ-A T-E6).
> **Execution mode:** Main session Opus direct.
> **Effort:** ~2 hrs total.

---

## Dependency DAG

```
T-P1 (EP-13 fix)          ─── independent (CRITICAL, do first)
T-P2 (Add Glob)           ─── independent
T-P3 (Typed output)       ─── independent
T-P4 (Blocked protocol)   ─── depends on T-P1 (EP-13 must be leaf-node before BLOCKED makes sense)
T-P5 (Rule loading test)  ─── cross-ref SEQ-A T-E6 (same test, shared result)
T-P6 (Pre-design checklist) ── depends on T-P4 (checklist references blocked protocol)
T-P7 (Alignment script)   ─── depends on T-P6 (script automates parts of checklist)
T-PS (Sub-Agent Safety)   ─── depends on T-P1
T-PD (Write/Edit decision)─── DECISION ONLY, no code — depends on T-P3 (output contract informs whether Write is needed)
```

---

## Tasks

### T-P1: Fix EP-13 False Orchestrator Claim [P0, 10 min]

**File (Write):** `.claude/agents/ltc-planner.md`
**DESIGN source:** Agent 2 § CRITICAL: EP-13 Contradiction

**Changes (4 locations):**
- Line 5: description — "orchestrating" → "advising on"
- Line 20: "Orchestrate DSBV flow" → "Advise on DSBV flow"
- Line 23: "Orchestrate learn pipeline" → "Advise on learn pipeline"
- Lines 65-72: Replace entire EP-13 section with leaf-node constraint + BLOCKED protocol

**ACs:**
1. `grep -c 'Orchestrate' .claude/agents/ltc-planner.md` = 0
2. `grep -c 'MAY dispatch' .claude/agents/ltc-planner.md` = 0
3. `grep -c 'leaf node' .claude/agents/ltc-planner.md` ≥1
4. `grep -c 'NEVER call' .claude/agents/ltc-planner.md` ≥1

---

### T-P2: Add Glob to Tool Whitelist [P1, 5 min]

**File (Write):** `.claude/agents/ltc-planner.md`
**DESIGN source:** Agent 2 § EOT Gap — Glob

**Changes:**
- Line 7: `tools:` add Glob → `Read, Glob, Grep, WebFetch, mcp__exa__web_search_exa, mcp__qmd__query`
- Tool Guide table: add Glob row

**ACs:**
1. `grep -c 'Glob' .claude/agents/ltc-planner.md` ≥2 (tools field + guide)

---

### T-P3: Typed Output Contract [P1, 20 min]

**File (Write):** `.claude/agents/ltc-planner.md`
**DESIGN source:** Agent 2 § EO Proposed Typed Output Contract

**Change:** Add `## Output Contract` section:
```
For DESIGN.md:
  --- BEGIN DESIGN.md ---
  [content]
  --- END DESIGN.md ---
  STATUS: complete | partial
  ALIGNMENT_CHECK: <mapped>/<total> | zero orphans: yes/no
  BLOCKERS: none | <list>

For SEQUENCE.md:
  --- BEGIN SEQUENCE.md ---
  [content]
  --- END SEQUENCE.md ---
  STATUS: complete | partial
  TASK_COUNT: N
  BLOCKERS: none | <list>

For Synthesis:
  --- BEGIN SYNTHESIS ---
  [content with per-section attribution]
  --- END SYNTHESIS ---
  DRAFT_SCORES: [table]
  CONFLICTS: none | <list>
```

**ACs:**
1. `grep -c 'Output Contract' .claude/agents/ltc-planner.md` ≥1
2. `grep -c 'BEGIN DESIGN' .claude/agents/ltc-planner.md` ≥1
3. `grep -c 'ALIGNMENT_CHECK' .claude/agents/ltc-planner.md` ≥1

---

### T-P4: Blocked Protocol [P1, 10 min]

**Depends on:** T-P1 (must be leaf node first)
**File (Write):** `.claude/agents/ltc-planner.md`
**DESIGN source:** Agent 2 § EOP Proposed Blocked Protocol

**Change:** Add to EP-13 section or as standalone:
```
When you lack information needed for design:
1. STOP — do not hallucinate or assume
2. Report: "BLOCKED: Need [specific information] for [design decision]"
3. Recommend: "Request ltc-explorer dispatch for [research question]"
4. Return partial output if possible: "DESIGN.md is X% complete. Blocked at [section]"
```

**ACs:**
1. `grep -c 'BLOCKED' .claude/agents/ltc-planner.md` ≥1
2. `grep -c 'do not hallucinate' .claude/agents/ltc-planner.md` ≥1

---

### T-P5: Rule Loading Test [P1, 15 min]

**Cross-ref:** Same test as SEQ-A T-E6. If SEQ-A runs first, reuse result. If not, run test here.
**DESIGN source:** Agent 2 § EOE Layer 6 (UNKNOWN status)

**Method:** Dispatch planner with a task that would violate versioning.md. Check compliance without versioning.md in context package.

**ACs:**
1. Finding documented (LP entry in learned_patterns.md)
2. Binary result: "rules load" or "rules don't load"

---

### T-P6: Pre-Design Checklist [P2, 15 min]

**Depends on:** T-P4 (references blocked protocol)
**File (Write):** `.claude/agents/ltc-planner.md`
**DESIGN source:** Agent 2 § EOP Proposed Pre-Design Checklist

**Change:** Add `## Pre-Design Checklist`:
```
Before starting any DESIGN.md draft:
[ ] Charter loaded and EO identified
[ ] Explorer research loaded (if applicable)
[ ] Prior decisions checked (1-ALIGN/decisions/)
[ ] Design template loaded
[ ] Workstream identified
[ ] Upstream dependency met (ALPEI chain-of-custody)
[ ] LEARN exclusion confirmed (2-LEARN/ = pipeline, NOT DSBV)
```

**AC:** `grep -c 'Pre-Design Checklist' .claude/agents/ltc-planner.md` ≥1

---

### T-P7: Partially Script Alignment Check [P2, 45 min]

**Depends on:** T-P6
**File (Write):** `scripts/alignment-check.sh` (new)
**DESIGN source:** Agent 2 § EOP Gap GAP-EOP-2

**Change:** Create script that checks:
- Every completion condition in DESIGN.md maps to an artifact
- Every artifact maps to a condition
- Report orphans (conditions without artifacts, artifacts without conditions)

**ACs:**
1. `test -f scripts/alignment-check.sh` exits 0
2. `bash -n scripts/alignment-check.sh` exits 0
3. Script accepts DESIGN.md path as argument

---

### T-PS: Sub-Agent Safety Section [P0, 5 min]

**Depends on:** T-P1
**File (Write):** `.claude/agents/ltc-planner.md`

**Change:** Add `## Sub-Agent Safety`:
```
- Read-only agent: most hook constraints are irrelevant (no Write/Edit/Bash)
- NEVER set status: validated in output content
- Verify file paths exist (via Read) before referencing in DESIGN.md/SEQUENCE.md
- If blocked on missing information, STOP and report — do not hallucinate
```

**AC:** `grep -c 'Sub-Agent Safety' .claude/agents/ltc-planner.md` = 1

---

### T-PD: Write/Edit Decision [P2, DECISION ONLY]

**Depends on:** T-P3 (output contract shows whether lossy handoff is acceptable)
**DESIGN source:** Agent 2 § EO Write/Edit Tool Question — Option C

**Deliverable:** Record decision in `inbox/` or `1-ALIGN/decisions/`:
- Option A (no Write) — keep status quo
- Option B (add Write) — risky, removes human gate
- Option C (add Write, gate behind approval) — recommended by DESIGN

**AC:** Decision documented with rationale.

---

## Execution Order

```
Round 1 (parallel):
  T-P1  EP-13 fix               [10m]   P0  CRITICAL
  T-P2  Add Glob                [5m]    P1

Round 2 (depends on T-P1):
  T-PS  Sub-Agent Safety        [5m]    P0
  T-P3  Typed output contract   [20m]   P1
  T-P4  Blocked protocol        [10m]   P1

Round 3 (depends on T-P4):
  T-P5  Rule loading test       [15m]   P1  (or reuse SEQ-A T-E6)
  T-P6  Pre-design checklist    [15m]   P2

Round 4 (depends on T-P6):
  T-P7  Alignment script        [45m]   P2

Round 5 (depends on T-P3):
  T-PD  Write/Edit decision     [10m]   P2  DECISION

Total: ~2 hrs
```

## Version Bumps

| File | Current | New |
|------|---------|-----|
| `.claude/agents/ltc-planner.md` | 1.4 | 1.5 |
| `scripts/alignment-check.sh` | new | 1.0 |
