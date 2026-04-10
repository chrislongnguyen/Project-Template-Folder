---
version: "1.0"
status: draft
last_updated: 2026-04-09
type: dsbv-design
stage: design
---

# DESIGN: DSBV Agent Orchestration — SOTA Upgrade

---

## 1. EO — Effective Outcome

Upgrade the LTC DSBV agent orchestration system from 39% enforcement (9/23 behaviors enforced) to ≥95% enforcement, making it predictable,
reliable, repeatable, cost-efficient, and fully tamed — so the Human PM can trust that every `/dsbv` invocation produces the expected
outcome with no agent drift, no silent failures, and no wasted tokens.

**"Better" defined:** Work as intended, 100% tamed, EO always as expected, predictable, reliable, repeatable, cost-efficient, fast,
scalable.

**Priority:** Sustainability > Efficiency > Scalability.

---

## 2. Problem Statement

### Current State (39% enforcement)

Of 23 DSBV agent behaviors audited, only 9 are enforced at Tier 2 (hooks) or above. The remaining 14 rely on Tier 4 (instructions only) —
meaning the agent follows them when convenient and drifts when context degrades, which it always does.

```
Enforcement Tier Distribution:
  Tier 1 (tool restriction):  1  behavior  (tool allowlists in agent files)
  Tier 2 (hooks):             8  behaviors (inject-frontmatter, status-guard, etc.)
  Tier 3 (partial):           1  behavior  (workstream N-1 validated — partial)
  Tier 4 (instructions only): 13 behaviors ← THE PROBLEM
  ─────────────────────────────────────────
  Total enforced at Tier 2+:  9/23 = 39%
```

### Why This Matters

1. **PM trust is zero-sum.** Every agent drift (status set incorrectly, gate skipped, model misrouted) erodes PM confidence. Once the PM
starts double-checking every output, the system is slower than manual work.
2. **Instruction-only enforcement fails under context pressure.** At 30-40% context usage (when /compress fires), Tier 4 rules are the first
 to degrade (LT-2). The behaviors that matter most — gates, approvals, status transitions — are exactly the ones that vanish.
3. **Sub-agent hook loss (GitHub #40580)** means the builder — the ONLY agent that writes to the codebase — operates with 14/15 hooks
disabled. Every write is unguarded.
4. **LP-6 lesson:** The Obsidian CLI project passed all 32 ACs structurally but failed every live command. DESIGN→Build→Validate succeeded
on paper but failed in reality because no AC tested the live system.

### 16 Root Causes

| ID | Root Cause | Category | Impact |
|----|-----------|----------|--------|
| RC-01 | Approval detection is instruction-only | EOP | PM can't trust `status: validated` |
| RC-02 | 14/15 hooks lost on sub-agent dispatch | EOE | Builder writes unguarded |
| RC-03 | No pipeline state persistence | EOE | Crash = restart from zero (mitigated by 1M + /compress) |
| RC-04 | Status T2 (in-progress → in-review) is EP-only | EOP | Status transitions unreliable |
| RC-05 | No circuit breaker automation in Build | EOP | Infinite retry loops possible |
| RC-06 | Model routing not enforced | EOE | Wrong model = wrong quality/cost |
| RC-07 | Tool allowlists not enforced by hooks | EOE | Agents could use unauthorized tools |
| RC-08 | No structured intent parsing | EI | Agent guesses PM intent |
| RC-09 | Approval record not verified post-write | EOP | Approval claims may be hallucinated |
| RC-10 | Sub-agent reports not schema-validated | EOP | Builder can claim PASS without evidence |
| RC-11 | Reviewer input not pre-flight checked | EI | Wasted Opus on missing DESIGN.md |
| RC-12 | No cost/success metrics | EOE | No visibility into system health |
| RC-13 | Auto-recall unfiltered (2000 tok/turn noise) | EI | Token waste on irrelevant context |
| RC-14 | iteration-bump.sh mapfile bash 3 bug | EOT | Script fails silently on macOS |
| RC-15 | Agent deviates from execution mode without asking | EOP | Agent changes plan mid-stream |
| RC-16 | No historical FAIL data across sessions | EI | Same FAILs recur without visibility |

---

## 3. Architecture

### 3.1 Design Principle: Defense in Depth with Compensation Layers

The fundamental constraint is **GitHub #40580: hooks do not fire in sub-agents.** This means the builder (the only writer) operates in a degraded environment. The architecture compensates through 3 layers:

```
Layer 1: PRE-DISPATCH (orchestrator-side, all hooks active)
  ├── Intent parsing → structured command
  ├── Gate state verification → prerequisites met
  ├── Context packaging validation → 5-field complete
  ├── Model routing verification → correct agent
  └── Cost estimation → PM-approved budget

Layer 2: INLINE AGENT PROTOCOL (agent file instructions, Tier 3)
  ├── Builder self-check checklist (14 items, inlined in agent file)
  ├── Reviewer pre-flight validation (4 items, inlined in agent file)
  ├── Circuit breaker rules (error classification + hard stops)
  └── Structured completion report format

Layer 3: POST-RETURN (orchestrator-side, all hooks active)
  ├── SubagentStop: verify-deliverables.sh (enhanced)
  ├── Completion report schema validation
  ├── Artifact existence verification (Glob/Read)
  ├── Approval record verification (post-write grep)
  ├── Registry sync verification
  └── Gate state file update → next phase unlock
```

### 3.2 Gate State Machine

Introduce a file-based state machine that tracks DSBV phase progression deterministically. This replaces instruction-only sequencing.

**File:** `.claude/state/dsbv-{workstream}.json`

```json
{
  "workstream": "1-ALIGN",
  "subsystem": null,
  "current_phase": "design",
  "gates": {
    "G1": { "status": "pending", "approved_date": null, "signal": null, "tier": null },
    "G2": { "status": "locked",  "approved_date": null, "signal": null, "tier": null },
    "G3": { "status": "locked",  "approved_date": null, "signal": null, "tier": null },
    "G4": { "status": "locked",  "approved_date": null, "signal": null, "tier": null }
  },
  "loop_state": {
    "iteration": 0,
    "max_iterations": 3,
    "fail_history": [],
    "cost_tokens": 0
  },
  "updated": "2026-04-09T10:00:00Z"
}
```

> **Note:** `subsystem` is reserved for future PD→DP→DA→IDM chain-of-custody enforcement. When `null`, gate checks operate at workstream level only. When set (e.g., `"2-DP"`), gate checks can enforce sub-system sequencing (downstream sub-system cannot exceed upstream version). This field is not enforced in this upgrade — see Section 10 (Out of Scope).

**State transitions:**

```
pending  → approved  (human signal at Tier 1 or confirmed Tier 2)
locked   → pending   (when preceding gate reaches "approved")
approved → (terminal for that gate)
```

**Phase sequencing enforced by hook:**
- `PreToolUse(Agent)` reads `.claude/state/dsbv-{workstream}.json`
- If dispatching a builder but `G2.status != "approved"` → BLOCK
- If dispatching a reviewer but `G3.status != "approved"` → BLOCK

### 3.3 Skill Architecture Decision: Unified Orchestrator Playbook

The `/dsbv` skill remains a single file (`SKILL.md`). It is NOT split into 4 phase-specific skills. See ADR-01 below for rationale.

The skill is restructured internally:

```
SKILL.md (~600 lines)
├── Phase definitions (Design/Sequence/Build/Validate)
├── Gate Approval Protocol (consolidated)
├── Approval Signal Detection (Tier catalog)
├── Generator/Critic Loop Protocol
├── Parallel Dispatch Protocol
├── Pipeline State Persistence Schema
└── Auto-Recall Relevance Filtering Spec

references/
├── context-packaging.md    (5-field template + per-agent examples)
├── phase-execution-guide.md (quality patterns per phase)
├── gotchas.md              (failure patterns)
└── gate-prechecks.md       (NEW: per-gate prerequisite checklists)
```

### 3.4 Enforcement Upgrade Map

```
                 Current              Target
                 ─────────            ──────────
Gate pre-checks      Tier 4 (EP)     →   Tier 2 (PreToolUse hook)
Status T2 transition Tier 4 (EP)     →   Tier 2 (PostToolUse hook on git commit)
Status T3 transition Tier 4 (EP)     →   Tier 3 (gate-advance.sh called by skill)
Approval detection   Tier 4 (EP)     →   Tier 3 (orchestrator skill protocol)
Approval record      Tier 4 (EP)     →   Tier 3 (skill protocol + post-write verify)
Gate presentation    Tier 4 (EP)     →   Tier 3 (skill protocol with template)
Model routing        Tier 4 (EP)     →   Tier 2 (PreToolUse hook on Agent)
Circuit breaker      Tier 4 (EP)     →   Tier 3 (state file + skill logic)
Registry sync        Tier 4 (EP)     →   Tier 2 (PostToolUse hook on Write/Edit)
Phase sequencing     Tier 4 (EP)     →   Tier 2 (PreToolUse hook reads state file)
Smoke tests          Tier 4 (EP)     →   Tier 3 (builder inline + reviewer verify)
Validate complete    Tier 4 (EP)     →   Tier 3 (reviewer pre-flight + AC count match)
Pre-flight readiness Tier 4 (EP)     →   Tier 2 (PreToolUse hook on Agent)
Context packaging    Tier 2 (3/5)    →   Tier 2 (5/5 fields validated)
Agent dispatch hook  Tier 2 (partial)→   Tier 2 (full: model + fields + state)
```

### 3.5 PM Workflow

The PM's interaction with the upgraded system:

```
PM: /dsbv build ALIGN
         │
         ▼
Orchestrator:
1. Parse intent: { phase: build, workstream: ALIGN }
2. Read state: .claude/state/dsbv-1-ALIGN.json
3. Check G2.status == "approved"?
   NO → "Cannot start Build — Sequence (G2) not yet approved.
         Current state: G1=approved, G2=pending.
         Run /dsbv sequence ALIGN first."
   YES ↓
4. Read SEQUENCE.md → task list
5. Show cost estimate: "3 tasks, single-agent Build.
   Estimated: 3 builder dispatches (~$0.06) + 1 reviewer (~$0.03) = ~$0.09.
   Proceed? [y/n]"
6. PM: "y"
7. For each task in sequence:
   a. Pre-dispatch: validate context package (5/5 fields)
   b. Pre-dispatch: verify model = sonnet
   c. Dispatch ltc-builder
   d. Post-return: validate completion report schema
   e. Post-return: verify artifact exists on disk
   f. Checkpoint: update state file
8. Generator/Critic loop:
   a. Dispatch ltc-reviewer
   b. Parse VALIDATE.md
   c. If FAILs: re-dispatch builder (max 3 iterations)
   d. Circuit breaker: classify errors, hard-stop if semantic or recurring
9. Gate G3 presentation:
   "GATE: G3 (Build) | Workstream: ALIGN
    ACs: 12/12 | Risk flags: 0
    Builder dispatches: 3 | Reviewer dispatches: 1
    Loop iterations: 1 | Estimated cost: ~$0.09
    Action: APPROVE / REVISE / ESCALATE"
10. PM: "approved"
11. Gate Approval Protocol:
    a. Classify signal: Tier 1 (explicit)
    b. Write approval record to DESIGN.md (date, signal text, tier)
    c. Post-write: grep confirms record exists (C-06 verify step)
    d. Set status: validated — `status-guard.sh` allows the write because
       it detects a verified approval record in the file (the record IS
       the human authorization, not a bypass flag)
    e. Sync registry (generate-registry.sh)
    f. Update state: G3.status = "approved", G4 = "pending"
    g. Create VALIDATE.md scaffold
12. "Build approved. VALIDATE phase ready. Run /dsbv validate ALIGN?"
```

---

## 4. Component Inventory

### C-01: Gate State Machine

**What:** File-based DSBV phase state tracking at `.claude/state/dsbv-{workstream}.json`

**Root causes addressed:** RC-01 (approval detection), RC-05 (circuit breaker), RC-03 (pipeline state)

**Artifacts:**
- `scripts/gate-state.sh` — CLI to read/write/advance gate state (bash 3 compatible)
- `.claude/state/` directory with per-workstream JSON files
- State schema documented in SKILL.md (existing § Pipeline State Persistence, adapted)

**Current tier → target:** Tier 4 → Tier 2 (hook reads state before allowing Agent dispatch)

**S x E x Sc:** S=9 (deterministic, crash-recoverable), E=8 (one file read per check), Sc=8 (per-workstream, scales to any project)

**Effort:** Medium — script + hook integration + SKILL.md update

---

### C-02: Enhanced PreToolUse Agent Dispatch Hook

**What:** Upgrade `verify-agent-dispatch.sh` to validate all 5 context packaging fields + model routing + gate state

**Root causes addressed:** RC-06 (model routing), RC-08 (intent parsing partial), RC-11 (pre-flight check)

**Current behavior:** Checks 3/5 fields (EO, INPUT, VERIFY). Does not check model or gate state.

**Target behavior:**
1. Validate all 5 context packaging markers: `## 1. EO`, `## 2. INPUT`, `## 3. EP`, `## 4. OUTPUT`, `## 5. VERIFY`
2. Extract agent name from prompt, look up expected model from `.claude/agents/{name}.md` frontmatter `model:` field, compare against
`tool_input.model` (if available) — WARN if mismatch (cannot BLOCK because CCR ignores model param)
3. Read `.claude/state/dsbv-{workstream}.json` — if dispatching builder, require G2=approved; if dispatching reviewer, require G3=approved;
if dispatching planner for sequence, require G1=approved
4. Validate budget field presence in INPUT section (grep for `### Budget` or `max_tool_calls`)

**Artifacts:** Updated `.claude/hooks/verify-agent-dispatch.sh`

**Current tier → target:** Tier 2 (3/5 fields) → Tier 2 (5/5 fields + model + state + budget)

**S x E x Sc:** S=9 (blocks bad dispatches deterministically), E=8 (fast jq + grep), Sc=9 (any agent count)

**Effort:** Medium — extend existing script

---

### C-03: Enhanced SubagentStop Verification Hook

**What:** Upgrade `verify-deliverables.sh` to validate completion report schema, verify artifact existence on disk, and log metrics

**Root causes addressed:** RC-09 (approval record not verified), RC-10 (sub-agent reports not schema-validated), RC-12 (no cost metrics)

**Current behavior:** Checks DONE format, blocks on non-none Blockers, warns on missing context packaging markers.

**Target behavior:**
1. **Schema validation:** Parse DONE line: extract `<path>`, `<pass>/<total>`, `<blockers>`. Validate all 3 fields are present and
well-formed.
2. **Artifact existence:** For builder dispatches, verify the artifact path in DONE line exists on disk (`test -f`). If not → exit 1 with
"Artifact claimed but not found on disk."
3. **AC count match:** If dispatching for a specific DESIGN.md, compare reported `<total>` against actual criterion count in DESIGN.md. WARN
 if mismatch.
4. **Metrics logging:** Append to `.claude/logs/dsbv-metrics.jsonl`:
   ```json
   {"timestamp":"ISO","agent":"ltc-builder","workstream":"1-ALIGN","phase":"build","task":"T1.3","acs_pass":4,"acs_total":4,"blockers":"none","tokens_approx":null}
   ```
5. **Approval record verification:** After gate approval protocol writes `status: validated`, grep the file to confirm the approval record table
row exists. If not → WARN.

**Artifacts:** Updated `.claude/hooks/verify-deliverables.sh`, new `.claude/logs/dsbv-metrics.jsonl` (auto-created)

**Current tier → target:** Tier 2 (partial) → Tier 2 (full schema + existence + metrics)

**S x E x Sc:** S=9 (catches hallucinated completions), E=7 (disk I/O per return), Sc=8 (log file grows linearly)

**Effort:** Medium — extend existing script

---

### C-04: Gate Pre-Check Hook

**What:** Orchestrator-side script that runs gate prerequisite checks before presenting a gate to the PM

**Root causes addressed:** RC-01 (approval detection prerequisites), RC-11 (reviewer pre-flight)

**How it works:** Before the orchestrator presents any gate (G1-G4), the SKILL.md protocol calls `scripts/gate-precheck.sh` inline. The script reads the gate state file to determine which gate is active, then checks prerequisites:

- G1 prerequisites: DESIGN.md exists and has ≥1 acceptance criterion
- G2 prerequisites: SEQUENCE.md exists and has ≥1 task
- G3 prerequisites: All SEQUENCE.md tasks have builder completion reports (from metrics log)
- G4 prerequisites: VALIDATE.md exists and has aggregate score line

If any prerequisite fails, the script exits non-zero and the orchestrator does not present the gate.

**Artifacts:** `scripts/gate-precheck.sh`, referenced in SKILL.md gate protocol

**Current tier → target:** Tier 4 → Tier 3 (script called by skill protocol)

**S x E x Sc:** S=9 (prevents presenting gates with missing prerequisites), E=8 (fast file checks), Sc=8

**Effort:** Small — new script, straightforward checks

---

### C-05: Status T2 Transition Automation

**What:** Automate the `in-progress` → `in-review` status transition when the orchestrator presents a gate

**Root causes addressed:** RC-04 (status T2 is EP-only)

**Mechanism:** When the orchestrator presents a gate (G1-G4), the SKILL.md protocol:
1. Sets all relevant artifacts to `status: in-review`
2. Updates `last_updated` to today
3. This is a skill-level action (the orchestrator has all hooks active, so `inject-frontmatter.sh` fires normally)

The existing `inject-frontmatter.sh` already handles T1 (`draft` → `in-progress` on edit). T2 requires an explicit skill-level action because it's
 a semantic state change ("I'm done editing, ready for review"), not triggered by file edit.

**Implementation:** Add a `set-status-in-review.sh` script that takes a file path and sets `status: in-review` via sed. Called by the SKILL.md gate
protocol before presenting each gate.

**Artifacts:** `scripts/set-status-in-review.sh`, SKILL.md gate protocol update

**Current tier → target:** Tier 4 → Tier 3 (script called by skill protocol)

**S x E x Sc:** S=8 (deterministic sed), E=9 (one sed call), Sc=9

**Effort:** Small

---

### C-06: Approval Record Write + Verify Protocol

**What:** Formalize the approval record writing as a verified 2-step protocol: write then verify

**Root causes addressed:** RC-09 (approval record not verified post-write)

**Current behavior:** SKILL.md Gate Approval Protocol Step 2 says to write an approval record. No verification.

**Target behavior:**
1. Write approval record to artifact (date, signal text, tier classification)
2. Immediately after write, `verify-approval-record.sh` greps the file for the approval record table row
3. If grep fails → WARN: "Approval record write may have failed. Verify manually." Do NOT proceed.
4. Only if Step 2 succeeds: set `status: validated`. The `status-guard.sh` hook allows this write because it detects a verified approval record in the file — the approval record IS the human authorization, not a bypass flag. This satisfies the versioning rule ("Human ONLY sets validated") because the record traces to an explicit human gate approval signal.
5. SubagentStop hook (C-03) also verifies approval record presence post-gate

**Artifacts:** SKILL.md Gate Approval Protocol update, `scripts/verify-approval-record.sh`

**Current tier → target:** Tier 4 → Tier 3 (script verification inline in skill protocol)

**S x E x Sc:** S=9 (prevents orphaned `status:validated` without record), E=9 (one grep), Sc=9

**Effort:** Small

---

### C-07: Model Routing Verification

**What:** Verify that `Agent()` dispatches use the correct model for each agent

**Root causes addressed:** RC-06 (model routing not enforced)

**Platform constraint:** CCR does not honor the `model:` parameter in `Agent()` calls. The model used is determined by the agent file's `model:`
frontmatter, but there's no hook that can enforce this at runtime.

**Compensation strategy:**
1. PreToolUse Agent hook (C-02) extracts agent name from prompt, reads agent file frontmatter, and WARNs if the declared model doesn't match
 the expected model. This is a Tier 2 warning, not a block (because CCR bypass means we can't actually enforce).
2. The SKILL.md protocol explicitly states which model each agent uses — this is Tier 3 reinforcement.
3. The agent files themselves declare `model:` in frontmatter — this is Tier 1 (the platform reads this).
4. SubagentStop hook logs the agent type and dispatched model to metrics (C-03) for post-session audit.

**Net enforcement:** Tier 1 (agent file) + Tier 2 (warning) + Tier 3 (skill protocol). This is the maximum achievable given platform
constraints.

**Artifacts:** C-02 hook update (model check), agent file frontmatter already correct, metrics logging in C-03

**Current tier → target:** Tier 4 → Tier 1+2+3 (multi-layer compensation)

**S x E x Sc:** S=7 (WARN not BLOCK due to platform), E=9 (no additional cost), Sc=9

**Effort:** Small (bundled into C-02)

---

### C-08: Generator/Critic Circuit Breaker Automation

**What:** Implement the circuit breaker as a state-tracked protocol with automatic error classification

**Root causes addressed:** RC-05 (no circuit breaker automation)

**Current behavior:** SKILL.md documents circuit breaker rules but they're instruction-only. No state tracking, no automatic error
classification.

**Target behavior:**
1. Gate state file (C-01) tracks `loop_state`: iteration count, fail history, cost tokens
2. After each reviewer dispatch, the orchestrator:
   a. Parses VALIDATE.md FAIL items
   b. Classifies each: SYNTACTIC / SEMANTIC / ENVIRONMENTAL / SCOPE
   c. Checks hard stops:
      - Same FAIL persists 2 iterations → ESCALATE
      - 2 consecutive agent failures → STOP
      - All FAIL items SEMANTIC → ESCALATE immediately
   d. Updates `loop_state` in state file
   e. If hard stop triggered → present to PM with diagnostic
3. Cost tracking: sum approximate tokens per iteration, warn at 3x `cost_cap`

**Classification heuristic (rule-based, no ML):**
- **SYNTACTIC:** FAIL criterion mentions "missing", "format", "frontmatter", "structure"
- **SEMANTIC:** FAIL criterion mentions "wrong", "incorrect", "misunderstood", "content"
- **ENVIRONMENTAL:** FAIL mentions "not found", "permission", "script failed", "exit code"
- **SCOPE:** FAIL mentions "not in SEQUENCE.md", "out of scope", "needs research"

**Artifacts:** `scripts/classify-fail.sh` (takes FAIL text, returns type), SKILL.md Generator/Critic loop update, C-01 state file schema update

**Current tier → target:** Tier 4 → Tier 3 (automated classification + state tracking via scripts)

**S x E x Sc:** S=9 (prevents infinite loops and wasted tokens), E=8 (rule-based classification is fast), Sc=8

**Effort:** Medium

---

### C-09: Structured Gate Presentation Enforcement

**What:** Ensure every gate presentation follows the structured template, not free-form text

**Root causes addressed:** RC-01 (approval detection depends on consistent gate format)

**Mechanism:** The SKILL.md already defines a gate presentation template. To enforce it:
1. Gate pre-check script (C-04) validates that the gate presentation text matches the template structure before it's shown to the PM
2. The approval signal detection (existing Tier catalog in SKILL.md) only activates in the context of a properly formatted gate — if the
gate wasn't structured, signals are treated as Tier 3 (ambiguous)
3. Gate state file (C-01) records whether a gate is "active" — approval signals only count when a gate is active

**Artifacts:** SKILL.md gate template (already exists, no change needed), C-04 integration, C-01 state file `active_gate` field

**Current tier → target:** Tier 4 → Tier 3 (skill protocol + state tracking)

**S x E x Sc:** S=8 (consistent PM experience), E=9 (no additional cost), Sc=9

**Effort:** Small (bundled into C-01 and C-04)

---

### C-10: Registry Sync Verification Hook

**What:** PostToolUse hook that warns when a workstream artifact is edited but `_genesis/version-registry.md` is not updated

**Root causes addressed:** RC-12 (registry drift)

**Current behavior:** `registry-sync-check.sh` runs at `PreToolUse(git commit)` — but only catches drift at commit time. The agent may have already
produced multiple files without updating the registry.

**Target behavior:** Add `PostToolUse(Write|Edit)` trigger: when a workstream artifact (path matches `[1-5]-*/`) is written, check if
`_genesis/version-registry.md` has been modified in this session (track via `.claude/state/registry-dirty.json`). If not, emit WARN: "Workstream
 artifact edited but registry not yet updated. Update before commit."

**Artifacts:** `scripts/registry-edit-tracker.sh` (PostToolUse hook), `.claude/state/registry-dirty.json`

**Current tier → target:** Tier 2 (commit-time) → Tier 2 (write-time + commit-time)

**S x E x Sc:** S=7 (WARN not BLOCK at write-time, BLOCK at commit), E=8, Sc=8

**Effort:** Small

---

### C-11: Builder Inline Self-Check Enhancement

**What:** Enhance the builder agent file's 14-item self-check checklist with smoke test requirements and structured completion report

**Root causes addressed:** RC-02 (hook loss compensation), RC-10 (report schema), LP-6 (live smoke tests)

**Current behavior:** Builder agent file has 14 items in "Sub-Agent Safety" section. Completion report format is `DONE: <path> | ACs: <pass>/<total> | Blockers: <none or list>`.

**Target additions:**
1. Add smoke test requirement: "Before reporting DONE, run the appropriate smoke test for the artifact type (`bash -n` for .sh, `ast.parse` for
.py, `skill-validator.sh` for skills). If smoke test fails, report FAIL."
2. Add LP-6 requirement: "If the DESIGN.md for this task includes an AC that references an external system or live command, execute the live
 test (within read-only safety bounds). Report the actual output."
3. Enhance completion report with optional fields: `assumptions:`, `uncertain_fields:`, `confidence_score:`
4. Add error classification awareness: "If you encounter a FAIL, classify it as SYNTACTIC/SEMANTIC/ENVIRONMENTAL/SCOPE in your report."

**Artifacts:** Updated `.claude/agents/ltc-builder.md`

**Current tier → target:** Tier 3 (inline instructions, enhanced) — this is the maximum achievable for sub-agent behavior without hooks

**S x E x Sc:** S=8 (comprehensive self-check), E=7 (adds ~2 minutes per task for smoke tests), Sc=9

**Effort:** Small — agent file update

---

### C-12: Reviewer Pre-Flight Validation Enhancement

**What:** Enhance the reviewer agent file's pre-flight validation to include historical FAIL data and strict criterion count matching

**Root causes addressed:** RC-11 (reviewer input not pre-flight checked), RC-16 (no historical FAIL data)

**Current behavior:** Reviewer has 4-item pre-flight (DESIGN.md present, criterion count > 0, artifact paths accessible, SEQUENCE.md available).

**Target additions:**
1. Strict criterion count: "Count criteria in DESIGN.md. Count checks in your VALIDATE.md. If they don't match, your validation is
incomplete."
2. Historical FAIL data: "Read `.claude/logs/dsbv-metrics.jsonl` for this workstream. If previous FAIL patterns exist, prioritize checking
those criteria first." (This file is written by C-03.)
3. Pre-flight blocking: "If DESIGN.md is NOT in your context, STOP and report BLOCKED. Do NOT produce a partial VALIDATE.md."

**Artifacts:** Updated `.claude/agents/ltc-reviewer.md`

**Current tier → target:** Tier 3 (inline instructions, enhanced with data source)

**S x E x Sc:** S=9 (catches incomplete validation), E=7 (metrics file read adds minor overhead), Sc=8

**Effort:** Small — agent file update

---

### C-13: Context Packaging Full Validation

**What:** Upgrade `verify-agent-dispatch.sh` to check all 5 fields, not just 3

**Root causes addressed:** RC-08 (no structured intent parsing partial)

Already bundled into C-02. Calling it out separately for traceability.

**Current:** Checks `## 1. EO`, `## 2. INPUT`, `## 5. VERIFY`
**Target:** Adds `## 3. EP`, `## 4. OUTPUT`

**S x E x Sc:** S=9, E=9, Sc=9

**Effort:** Trivial — 2 additional grep checks in C-02

---

### C-14: Bash 3 Compatibility Audit + Fixes

**What:** Audit all scripts for bash 4+ features (`mapfile`, associative arrays, process substitution edge cases) and fix them for macOS bash 3

**Root causes addressed:** RC-14 (iteration-bump.sh mapfile bash 3 bug)

**Scope:**
- `scripts/iteration-bump.sh` — known mapfile bug
- All other scripts in `scripts/` and `.claude/hooks/` — audit for bash 4+ features
- Replace `mapfile` with `while IFS= read -r` loops
- Replace associative arrays with simple case statements or tmp files
- Test all scripts with `/bin/bash --version` to confirm bash 3 compatibility

**Artifacts:** Updated scripts, new `scripts/bash3-compat-test.sh` (runs all scripts with `bash -n` and checks for bash 4+ patterns via grep)

**Current tier → target:** N/A (bug fix, not enforcement tier)

**S x E x Sc:** S=9 (scripts actually work on macOS), E=9 (no runtime cost), Sc=9

**Effort:** Small-Medium — grep + fix known patterns

---

### C-15: Auto-Recall Relevance Filtering

**What:** Implement intent-based filtering for QMD auto-recall to reduce token waste from 2000 tok/turn to contextually appropriate levels

**Root causes addressed:** RC-13 (auto-recall unfiltered noise)

**Mechanism:** (already spec'd in SKILL.md § Auto-Recall Relevance Filtering)
1. UserPromptSubmit hook parses intent: design/build/validate/research/general
2. QMD query includes intent parameter to weight results
3. Token budget: ≥0.5 relevance → 2000 tokens; <0.5 → 1000 tokens; no results → skip

**Artifacts:** Updated UserPromptSubmit hook (e.g., `thinking-modes.sh` or dedicated auto-recall hook)

**Current tier → target:** Tier 4 (spec only) → Tier 2 (hook implementation)

**S x E x Sc:** S=7 (reduces noise), E=9 (saves ~1000 tokens/turn on irrelevant recalls), Sc=8

**Effort:** Medium — hook script with intent parsing

---

### C-16: Historical FAIL Data Persistence

**What:** Persist FAIL data from Generator/Critic loops across sessions for trend analysis

**Root causes addressed:** RC-16 (no historical FAIL data across sessions)

**Mechanism:**
1. C-03 (SubagentStop hook) logs every FAIL item to `.claude/logs/dsbv-metrics.jsonl`
2. C-12 (reviewer pre-flight) reads this file to prioritize known-failing criteria
3. C-08 (circuit breaker) reads this file to detect cross-session recurring FAILs
4. `/dsbv status` can optionally show "Top recurring FAILs" from this data

**Data schema:**
```json
{"timestamp":"ISO","workstream":"1-ALIGN","phase":"build","task":"T1.3","criterion":"AC-03","verdict":"FAIL","error_type":"SEMANTIC","description":"Wrong algorithm","iteration":2}
```

**Artifacts:** `.claude/logs/dsbv-metrics.jsonl` (created by C-03), read by C-12, C-08, `/dsbv status`

**Current tier → target:** Tier 4 (no data) → Tier 3 (persistent data + agent reads)

**S x E x Sc:** S=8 (learn from past failures), E=7 (file I/O per dispatch), Sc=7 (log grows, need periodic rotation)

**Effort:** Small (data already flows from C-03; this is the read path)

---

### C-17: Execution Mode Guard

**What:** Prevent the agent from changing execution mode (e.g., switching from Build to Design) without PM approval

**Root causes addressed:** RC-15 (agent deviates from execution mode without asking)

**Mechanism:**
1. Gate state file (C-01) tracks `current_phase`
2. If the orchestrator attempts to dispatch an agent for a phase that doesn't match `current_phase` (e.g., dispatching planner when
`current_phase` is "build"), the PreToolUse hook (C-02) WARNs: "Current phase is Build but dispatching planner (Design/Sequence). Confirm with
 PM."
3. Exception: dispatching reviewer during Build (Generator/Critic loop) is always allowed
4. Exception: dispatching explorer at any phase is always allowed (research doesn't advance state)

**Artifacts:** C-02 hook update (phase-agent compatibility check)

**Current tier → target:** Tier 4 → Tier 2 (hook warning)

**S x E x Sc:** S=8 (prevents scope drift), E=9 (one check), Sc=9

**Effort:** Small (bundled into C-02)

---

### C-18: Live Smoke Test AC Requirement

**What:** Require that any DESIGN.md integrating an external system includes ≥1 AC with a live system test

**Root causes addressed:** LP-6 (Obsidian CLI passed all structural ACs but failed live)

**Mechanism:**
1. When ltc-planner drafts a DESIGN.md, the planner agent file includes a check: "If the EO references an external system (CLI, API,
service), at least one AC must include a live invocation test. If unsure whether something is external, include a smoke test AC."
2. When ltc-reviewer validates, any DESIGN.md without a live test AC for an external integration gets a PARTIAL verdict with a warning.
3. New reference file: `references/live-test-patterns.md` — examples of live test ACs for common integrations (CLI tools, APIs, file systems)

**Artifacts:** Updated `.claude/agents/ltc-planner.md` (design quality check), updated `.claude/agents/ltc-reviewer.md` (validation check), new
`references/live-test-patterns.md`

**Current tier → target:** Tier 4 → Tier 3 (agent instructions with pattern reference)

**S x E x Sc:** S=9 (prevents LP-6 class failures), E=8 (one additional AC per external integration), Sc=9

**Effort:** Small

---

## 5. Acceptance Criteria

Every AC is binary and testable. Grouped by component.

### State Machine (C-01)

- **AC-01:** `.claude/state/dsbv-{workstream}.json` is created when `/dsbv design {workstream}` is first invoked. Verify: `test -f .claude/state/dsbv-1-ALIGN.json` returns 0.
- **AC-02:** Gate transitions are recorded: after PM approves G1, `jq '.gates.G1.status' .claude/state/dsbv-1-ALIGN.json` returns `"approved"` and G2 status becomes `"pending"`.
- **AC-03:** Phase sequencing is blocked: attempting to dispatch ltc-builder when `G2.status != "approved"` produces an error message containing "G2" and "not yet approved".

### Agent Dispatch Hook (C-02, C-07, C-13, C-17)

- **AC-04:** All 5 context packaging fields are validated. Dispatch with missing `## 3. EP` → hook exits non-zero with message containing "EP".
- **AC-05:** Model routing warning: dispatch ltc-builder with wrong model declaration → hook emits WARN containing "model mismatch" (non-blocking).
- **AC-06:** Phase-agent compatibility: dispatch ltc-planner when `current_phase` is "build" → hook emits WARN containing "phase mismatch" (non-blocking, exception for explorer/reviewer-in-loop).
- **AC-07:** Budget field validation: dispatch without `### Budget` → hook emits WARN containing "budget" (non-blocking).

### SubagentStop Verification (C-03, C-16)

- **AC-08:** Completion report schema validated: builder returns malformed DONE line (missing ACs field) → hook exits non-zero with message containing "schema".
- **AC-09:** Artifact existence verified: builder claims `DONE: path/to/file.md` but file does not exist → hook exits non-zero with message containing "not found on disk".
- **AC-10:** Metrics logged: after successful builder return, `.claude/logs/dsbv-metrics.jsonl` contains a new line with the correct workstream and task.
- **AC-11:** Historical FAIL data: after a FAIL verdict, `.claude/logs/dsbv-metrics.jsonl` contains a line with `"verdict":"FAIL"` and the criterion text.

### Gate Pre-Checks (C-04)

- **AC-12:** G1 pre-check: presenting G1 when DESIGN.md has 0 acceptance criteria → script outputs error containing "no acceptance criteria".
- **AC-13:** G4 pre-check: presenting G4 when VALIDATE.md has no aggregate score line → script outputs error containing "no aggregate score".

### Status Transitions (C-05, C-06)

- **AC-14:** Status T2: when gate is presented, relevant artifacts have `status: in-review`. Verify: `grep 'status: in-review' {artifact}` returns 0.
- **AC-15:** Approval record verified: after gate approval, `grep 'APPROVED' {artifact}` returns a line containing the date and signal text.
- **AC-16:** Approval record → status sequence: `status: validated` is NOT set if approval record grep fails. (Test: mock a failed write, verify status remains `in-review`.)

### Circuit Breaker (C-08)

- **AC-17:** Same FAIL persists 2 iterations → escalation message to PM containing "persists" and "escalate".
- **AC-18:** All-SEMANTIC FAILs → immediate escalation (no retry). Message contains "semantic" and "escalate".
- **AC-19:** Cost tracking: after 3 iterations, `loop_state.cost_tokens > 0` in state file.

### Builder/Reviewer Enhancements (C-11, C-12, C-18)

- **AC-20:** Builder agent file contains smoke test requirement. Verify: `grep -i 'smoke test' .claude/agents/ltc-builder.md` returns ≥1 match.
- **AC-21:** Builder agent file contains LP-6 live test requirement. Verify: `grep 'LP-6' .claude/agents/ltc-builder.md` returns ≥1 match.
- **AC-22:** Reviewer agent file contains historical FAIL data read instruction. Verify: `grep 'dsbv-metrics' .claude/agents/ltc-reviewer.md` returns ≥1 match.
- **AC-23:** Reviewer agent file contains strict criterion count matching. Verify: `grep -i 'criterion count' .claude/agents/ltc-reviewer.md` returns ≥1 match.
- **AC-24:** Planner agent file contains LP-6 live test AC requirement for external integrations. Verify: `grep 'LP-6' .claude/agents/ltc-planner.md` returns ≥1 match.

### Registry Sync (C-10)

- **AC-25:** Editing a workstream artifact without updating registry → WARN message containing "registry" at write-time.

### Bash 3 Compatibility (C-14)

- **AC-26:** `grep -rn 'mapfile\|declare -A' scripts/ .claude/hooks/` returns 0 matches (no bash 4+ features).
- **AC-27:** `bash -n scripts/*.sh .claude/hooks/*.sh` exits 0 for all scripts (syntax valid under bash 3).

### Auto-Recall (C-15)

- **AC-28:** UserPromptSubmit hook contains intent parsing logic. Verify: `grep -i 'intent' {hook-file}` returns ≥1 match.
- **AC-29:** Token budget varies by relevance score. Verify: hook file contains both "2000" and "1000" token thresholds.

### Live Smoke Test (LP-6 End-to-End)

- **AC-31:** Run `/dsbv status` and confirm it reads from `_genesis/version-registry.md` (not hardcoded). Verify: modify a version in registry, re-run status, output reflects change. (LIVE SYSTEM TEST — LP-6)
- **AC-32:** Run `scripts/gate-state.sh read 1-ALIGN` and confirm it returns valid JSON. (LIVE SYSTEM TEST — LP-6)
- **AC-33:** Run `scripts/gate-precheck.sh G1 1-ALIGN` against a workstream with no DESIGN.md → exits non-zero. (LIVE SYSTEM TEST — LP-6)
- **AC-34:** Run `scripts/classify-fail.sh "Missing frontmatter field"` → returns "SYNTACTIC". (LIVE SYSTEM TEST — LP-6)

### Integration (End-to-End)

- **AC-35:** Full `/dsbv design ALIGN` → G1 → `/dsbv sequence ALIGN` → G2 flow works with state file tracking each transition. Verify state file has G1=approved, G2=approved after both gates pass.
- **AC-36:** Full Generator/Critic loop: builder produces artifact with known FAIL, reviewer catches it, builder fixes it in iteration 2, reviewer confirms PASS. Verify `loop_state.iteration = 2` in state file.

---

## 6. Sequencing — Build Order

### Round 0 — Foundation (no dependencies)

| Task | Component | Dependencies | Effort |
|------|-----------|--------------|--------|
| T0.1 | C-14: Bash 3 compatibility audit + fixes | None | Small-Med |
| T0.2 | C-01: Gate state machine (schema + script) | None | Medium |

### Round 1 — Core Hooks (depends on C-01)

| Task | Component | Dependencies | Effort |
|------|-----------|--------------|--------|
| T1.1 | C-02: Enhanced Agent dispatch hook | C-01 (reads state) | Medium |
| T1.2 | C-03: Enhanced SubagentStop hook | None (but informed by C-01 schema) | Medium |
| T1.3 | C-05: Status T2 transition script | None | Small |
| T1.4 | C-06: Approval record verify script | None | Small |

T1.1 and T1.2 are independent of each other. T1.3 and T1.4 are independent of each other and of T1.1/T1.2.

### Round 2 — Integration Layer (depends on Round 1)

| Task | Component | Dependencies | Effort |
|------|-----------|--------------|--------|
| T2.1 | C-04: Gate pre-check script | C-01, C-03 | Small |
| T2.2 | C-08: Circuit breaker automation | C-01, C-03 | Medium |
| T2.3 | C-10: Registry sync PostToolUse hook | None | Small |
| T2.4 | C-15: Auto-recall relevance filtering | None | Medium |

T2.3 and T2.4 are independent of everything in Round 2.

### Round 3 — Agent File Updates (depends on Round 1-2)

| Task | Component | Dependencies | Effort |
|------|-----------|--------------|--------|
| T3.1 | C-11: Builder agent file enhancement | C-08 (error classification), C-03 (report schema) | Small |
| T3.2 | C-12: Reviewer agent file enhancement | C-16 (metrics file), C-03 | Small |
| T3.3 | C-18: LP-6 live test patterns + planner update | None | Small |

### Round 4 — Skill Update + Settings (depends on all above)

| Task | Component | Dependencies | Effort |
|------|-----------|--------------|--------|
| T4.1 | SKILL.md update: integrate C-01 through C-18 | All above | Medium |
| T4.2 | settings.json update: wire new hooks | All hooks (C-02, C-03, C-10) | Small |
| T4.3 | C-09: Gate presentation template enforcement | C-01, C-04 | Small |

### Round 5 — Verification

| Task | Component | Dependencies | Effort |
|------|-----------|--------------|--------|
| T5.1 | Live smoke tests (AC-31 through AC-34) | All above | Small |
| T5.2 | Integration test: full DSBV flow (AC-35, AC-36) | All above | Medium |

### Critical Path

```
T0.2 (state machine) → T1.1 (dispatch hook) → T2.1 (gate precheck) → T4.1 (SKILL.md) → T5.2 (integration)
                      → T1.2 (SubagentStop)  → T2.2 (circuit breaker) ↗
```

Estimated total: 18 tasks across 6 rounds. Rounds 0-3 have parallelism. Round 4-5 are sequential.

---

## 7. UBS Analysis — Risks of the Upgrade Itself

| ID | Risk | Category | Probability | Impact | Mitigation |
|----|------|----------|-------------|--------|------------|
| UBS-01 | Hook complexity causes false positives that block legitimate work | Technical | Medium | High | Every new hook has a `--force` bypass flag. PM can override any block. |
| UBS-02 | State file corruption (malformed JSON) breaks all gate checks | Technical | Low | High | `gate-state.sh` validates JSON on read. If corrupt, recreate from filesystem state (DESIGN.md/SEQUENCE.md/VALIDATE.md existence). |
| UBS-03 | Builder agent file becomes too long (>200 lines) with inline checks | Human | Medium | Medium | Keep inline checks as a numbered checklist, not prose. Reference scripts by path, not by embedding logic. |
| UBS-04 | Auto-recall intent parsing misclassifies and injects wrong context | Technical | Medium | Low | Fallback: if intent is unclear, default to "general" (current behavior). No worse than status quo. |
| UBS-05 | Metrics log grows unbounded | Temporal | High | Low | Add log rotation: keep last 1000 lines. Old data archived to `.claude/logs/archive/`. |
| UBS-06 | Upgrade introduces regression in existing hooks | Technical | Medium | High | Round 5 integration tests verify the full flow. All existing hook tests remain passing. |
| UBS-07 | PM workflow becomes slower due to additional checks | Human | Low | Medium | Most checks are sub-second (file reads, grep). Gate pre-checks add <1s per gate. Cost estimate shown once per Build. |
| UBS-08 | Too many WARNs desensitize PM (warning fatigue) | Human | Medium | Medium | WARNs are specific and actionable. Consolidate related WARNs into single messages. Only WARN on new issues, not repeated ones. Note: warning consolidation behavior is not covered by a dedicated AC in this iteration — track as follow-on if fatigue materializes in practice. |

---

## 8. Force Analysis

### Driving Forces (UDS)

| ID | Force | Category | Leverage |
|----|-------|----------|----------|
| UDS-01 | PM has experienced repeated agent drift → high motivation for enforcement | Human | HIGH |
| UDS-02 | 1M context + /compress mitigation → pipeline state persistence is viable | Technical | HIGH |
| UDS-03 | Existing hook infrastructure (7 PreToolUse, SubagentStop) → incremental upgrade, not greenfield | Technical | MEDIUM |
| UDS-04 | Agent files already declare model + tools → Tier 1 enforcement exists | Technical | MEDIUM |
| UDS-05 | SKILL.md already documents most protocols → Tier 3 upgrade is low effort | Technical | MEDIUM |
| UDS-06 | OMC patterns proven at scale (24K stars) → validated architectural patterns | Technical | MEDIUM |
| UDS-07 | All 16 root causes are documented → targeted fixes, not guesswork | Technical | HIGH |

### Blocking Forces (UBS)

| ID | Force | Category | Leverage |
|----|-------|----------|----------|
| UBS-F1 | GitHub #40580: sub-agent hooks don't fire | Technical | HIGH (non-negotiable constraint) |
| UBS-F2 | CCR doesn't route Agent() model param | Technical | MEDIUM (compensated by agent files) |
| UBS-F3 | macOS bash 3 default | Technical | LOW (fixable, C-14) |
| UBS-F4 | Single DSBV cycle budget | Temporal | MEDIUM (must be comprehensive) |
| UBS-F5 | Hook complexity ceiling (too many hooks = slow, fragile) | Technical | MEDIUM (mitigated by consolidation) |

### Net Assessment

Driving forces outweigh blocking forces. The primary blocker (#40580) is a known platform constraint with a proven 3-layer compensation
architecture. All other blockers are addressable. The single-cycle budget constraint (UBS-F4) is the main execution risk — addressed by
comprehensive sequencing with parallelism.

---

## 9. Architecture Decision Records

### ADR-01: Keep /dsbv as a Unified Skill (Do NOT Split)

**Context:** The question of splitting `/dsbv` into 4 phase-specific skills (`/dsbv-design`, `/dsbv-sequence`, `/dsbv-build`, `/dsbv-validate`) was
considered.

**Decision:** Keep as unified skill.

**Rationale:**
1. Cross-phase state: The gate state machine, approval protocol, and circuit breaker span phases. Splitting forces either duplication or a
shared library — both add complexity without benefit.
2. PM mental model: PM invokes `/dsbv` and the skill manages phase progression. Split skills force PM to manually track "which skill do I run
next?" — this is exactly what the state machine automates.
3. Token cost: A single SKILL.md loaded once is cheaper than 4 files loaded in sequence. The skill's internal branching (phase sections) is
well-structured.
4. OMC precedent: oh-my-claudecode uses compound skills with internal routing, not phase-split skills, for its team pipeline.
5. User explicitly rejected this option (recorded in memory: "/dsbv skill split REJECTED — orchestrator playbook stays unified").

**Consequences:** SKILL.md stays at ~600 lines. Internal structure must be clear (phase sections, protocol sections, reference files). The
references/ directory offloads detail.

---

### ADR-02: 3-Layer Compensation for Sub-Agent Hook Loss

**Context:** GitHub #40580 means 14/15 hooks don't fire for sub-agents. The builder (only writer) is most affected.

**Decision:** Implement a 3-layer compensation architecture: Pre-dispatch hooks (Layer 1) + Inline agent protocols (Layer 2) + Post-return hooks
 (Layer 3).

**Rationale:**
1. Layer 1 (pre-dispatch) catches 60% of issues before they happen: wrong model, missing context, wrong phase, missing gate approval. All
hooks fire because the orchestrator (main session) makes the dispatch call.
2. Layer 2 (inline) is the weakest link (Tier 3/4 instructions) but is the only option inside the sub-agent. Enhanced checklists, smoke
tests, and structured reports maximize its effectiveness.
3. Layer 3 (post-return) catches what Layers 1-2 missed: hallucinated artifacts, malformed reports, missing approval records. SubagentStop
hook fires in the main session context.

**Alternatives considered:**
- "Wait for Anthropic to fix #40580" — rejected, timeline unknown
- "Move all writes to orchestrator" — rejected, defeats purpose of sub-agents (orchestrator context bloats)
- "Use team mode instead of Agent()" — investigated, team mode has different tradeoffs (see ADR-03)

**Consequences:** Some behaviors remain at Tier 3 (instructions). This is the best achievable given platform constraints. The target is not 100%
 Tier 2 — it's "every behavior at the highest tier the platform allows."

---

### ADR-03: Agent() Sub-Agents over Team Mode

**Context:** Claude Code supports both `Agent()` dispatch and team mode (agent-to-agent messaging). OMC uses team mode for its pipeline.

**Decision:** Continue using `Agent()` sub-agents, not team mode.

**Rationale:**
1. Control: `Agent()` gives the orchestrator full control over dispatch timing, context packaging, and return handling. Team mode introduces
autonomous agent-to-agent communication that's harder to audit.
2. Hook leverage: `PreToolUse(Agent)` and `SubagentStop` fire for `Agent()` calls. Team mode message hooks are less mature.
3. Cost predictability: `Agent()` dispatches have predictable token costs (one invocation = one context package). Team mode agents may
converse back and forth, multiplying cost unpredictably.
4. Existing investment: 5 hooks, 4 agent files, context packaging template, SKILL.md protocol — all designed for `Agent()` dispatch. Switching
 to team mode would require rewriting all of this.
5. User feedback (memory: `feedback_agent_teams_mode.md`): "Agent teams ≠ sub-agents; use teams for agent-to-agent conversation" — teams are
for a different use case.

**When to reconsider:** If Anthropic adds hook support for sub-agents (#40580 fix), the compensation layers become redundant and the
architecture simplifies. At that point, team mode's benefits (autonomous collaboration) may outweigh `Agent()` control.

---

### ADR-04: File-Based State Over In-Memory State

**Context:** Pipeline state could be tracked in-memory (conversation context) or on disk (JSON files).

**Decision:** File-based state at `.claude/state/`.

**Rationale:**
1. Crash recovery: If the session crashes or rotates (PreCompact), file state survives. In-memory state is lost.
2. Hook access: Hooks are shell scripts that can read files but cannot access conversation context. File-based state enables hooks to
enforce phase sequencing.
3. Auditability: File-based state can be inspected by the PM (`cat .claude/state/dsbv-1-ALIGN.json`) and by CI/CD.
4. OMC precedent: `.omc/` directory pattern for persistent state, proven at scale.

**Trade-off:** File I/O adds ~50ms per state read. Acceptable for gate checks that happen a few times per session.

---

### ADR-05: WARN Over BLOCK for Model Routing

**Context:** CCR doesn't honor the model param in `Agent()` calls, so we can't block wrong-model dispatches.

**Decision:** WARN (non-blocking) for model mismatches.

**Rationale:**
1. Agent files declare `model:` in frontmatter — the platform reads this for actual model selection (Tier 1).
2. The hook can detect a mismatch between the prompt's agent name and the expected model, but blocking would prevent the dispatch entirely —
 which may be worse than proceeding with the right model (agent file wins).
3. WARN gives the PM visibility without blocking correct behavior.

**Monitoring:** Metrics log (C-03) records dispatched agent type, enabling post-session audit of model routing accuracy.

---

## 10. Out of Scope

These items are explicitly NOT part of this upgrade:

1. Changes to the 7-CS framework or 8 LLM Truths — these are foundational axioms, not implementation details.
2. Changes to the ALPEI workstream structure (5 workstreams, their order, or DSBV applicability rules).
3. New agent roles — the 4-agent roster (explorer, planner, builder, reviewer) is MECE and sufficient.
4. CI/CD pipeline — this upgrade focuses on the agent orchestration system, not GitHub Actions.
5. Obsidian integration — PKB/vault operations are separate from DSBV.
6. Cross-repo template sync (Issue #17) — separate initiative.
7. LEARN pipeline changes — LEARN uses its own pipeline, not DSBV.
8. Sub-system sequencing enforcement (PD→DP→DA→IDM chain-of-custody) — deferred to a follow-on DESIGN cycle. The gate state machine schema reserves a `subsystem` field (C-01) for forward compatibility, but no hooks, scripts, or ACs enforce sub-system ordering in this upgrade. Rationale: get workstream×DSBV enforcement to ≥95% first (the burning problem); sub-system enforcement is the next layer once the foundation is solid.

---

## 11. Alignment Check

### Conditions → Artifacts Mapping

| Completion Condition | Artifact(s) | AC(s) |
|----------------------|-------------|-------|
| Gate state machine works | `scripts/gate-state.sh`, `.claude/state/` schema | AC-01, AC-02, AC-03, AC-32 |
| All 5 context packaging fields validated | `.claude/hooks/verify-agent-dispatch.sh` | AC-04 |
| Model routing detected | `.claude/hooks/verify-agent-dispatch.sh` | AC-05 |
| Phase sequencing enforced | `.claude/hooks/verify-agent-dispatch.sh` | AC-06 |
| Completion reports schema-validated | `.claude/hooks/verify-deliverables.sh` | AC-08, AC-09 |
| Metrics logged | `.claude/logs/dsbv-metrics.jsonl` | AC-10, AC-11 |
| Gate pre-checks work | `scripts/gate-precheck.sh` | AC-12, AC-13, AC-33 |
| Status T2 automated | `scripts/set-status-in-review.sh` | AC-14 |
| Approval records verified | `scripts/verify-approval-record.sh` | AC-15, AC-16 |
| Circuit breaker automated | `scripts/classify-fail.sh`, state file | AC-17, AC-18, AC-19, AC-34 |
| Builder enhanced | `.claude/agents/ltc-builder.md` | AC-20, AC-21 |
| Reviewer enhanced | `.claude/agents/ltc-reviewer.md` | AC-22, AC-23 |
| LP-6 live test requirement | `.claude/agents/ltc-planner.md`, `references/live-test-patterns.md` | AC-24 |
| Registry sync at write-time | `scripts/registry-edit-tracker.sh` | AC-25 |
| Bash 3 compatible | All scripts | AC-26, AC-27 |
| Auto-recall filtered | UserPromptSubmit hook | AC-28, AC-29 |
| Full DSBV flow works | Integration test | AC-35, AC-36 |
| Live system tests pass | Scripts | AC-31, AC-32, AC-33, AC-34 |

Orphan check: 18 components × 35 ACs. Every component has ≥1 AC. Every AC maps to ≥1 component. Zero orphans. (C-17 Execution Mode Guard is tested by AC-06 under the Agent Dispatch Hook group.)

---

## 12. Root Cause → Component Traceability

| Root Cause | Component(s) | AC(s) |
|------------|-------------|-------|
| RC-01: Approval detection EP-only | C-01, C-06, C-09 | AC-02, AC-15, AC-16 |
| RC-02: 14/15 hooks lost on sub-agent | C-11, C-03 (3-layer compensation) | AC-08, AC-09, AC-20, AC-21 |
| RC-03: No pipeline state persistence | C-01 | AC-01, AC-02 |
| RC-04: Status T2 is EP-only | C-05 | AC-14 |
| RC-05: No circuit breaker automation | C-08 | AC-17, AC-18, AC-19 |
| RC-06: Model routing not enforced | C-07 (via C-02) | AC-05 |
| RC-07: Tool allowlists not enforced | Agent file `tools:` allowlist (Tier 1, platform-enforced). C-02 validates context packaging but does not enforce tool restrictions. | AC-04 (indirect — validates dispatch structure) |
| RC-08: No structured intent parsing | C-13 (via C-02) | AC-04, AC-07 |
| RC-09: Approval record not verified | C-06 | AC-15, AC-16 |
| RC-10: Sub-agent reports not validated | C-03 | AC-08, AC-09 |
| RC-11: Reviewer input not pre-flighted | C-12, C-04 | AC-12, AC-22, AC-23 |
| RC-12: No cost/success metrics | C-03, C-16 | AC-10, AC-11 |
| RC-13: Auto-recall unfiltered | C-15 | AC-28, AC-29 |
| RC-14: mapfile bash 3 bug | C-14 | AC-26, AC-27 |
| RC-15: Agent deviates from mode | C-17 (via C-02) | AC-06 |
| RC-16: No historical FAIL data | C-16 (via C-03, C-12) | AC-11, AC-22 |

Coverage: 16/16 root causes have ≥1 component and ≥1 AC. Zero gaps.

---

## 13. Gap → Component Traceability

All 13 Tier 4 gaps from the enforcement audit are addressed:

| Tier 4 Gap | Component | Target Tier |
|------------|-----------|-------------|
| Gate pre-checks (G1/G2/G4) | C-04 | Tier 3 |
| Status T2 (in-progress → in-review) | C-05 | Tier 3 |
| Status T3 (in-review → validated) | C-06 | Tier 3 |
| Approval signal detection | C-09 (via C-01 state) | Tier 3 |
| Approval record writing | C-06 | Tier 3 |
| Structured gate presentation | C-09 | Tier 3 |
| Model routing per agent | C-07 (via C-02) | Tier 1+2+3 |
| Generator/Critic circuit breaker | C-08 | Tier 3 |
| Registry sync after validation | C-10 | Tier 2 |
| DSBV phase sequencing state machine | C-01 (via C-02) | Tier 2 |
| Smoke tests during Build | C-11 | Tier 3 |
| Validate completeness check | C-12 | Tier 3 |
| Pre-flight readiness check | C-04 + C-02 | Tier 2+3 |

Coverage: 13/13 gaps addressed. Zero deferred.

---

## 14. Failure Incident Coverage

| Incident | Description | Addressed By |
|----------|-------------|--------------|
| LP-6 | Obsidian CLI: all ACs pass structurally, all live commands fail | C-18 (live test AC requirement), AC-31 through AC-34 |
| RC-01 | PM can't trust status:validated | C-01 + C-06 (state machine + verified approval) |
| RC-02 | Builder writes unguarded | 3-layer compensation (C-02, C-11, C-03) |
| RC-05 | Infinite retry loops | C-08 (circuit breaker with hard stops) |
| RC-06 | Wrong model dispatched | C-07 (multi-layer: agent file + hook WARN + skill protocol) |
| RC-08 | Agent guesses PM intent | C-02 (5/5 field validation + budget) |
| RC-09 | Hallucinated approval record | C-06 (write + verify protocol) |
| RC-10 | Builder claims PASS without evidence | C-03 (schema validation + disk check) |
| RC-11 | Wasted Opus on missing DESIGN.md | C-04 + C-12 (gate pre-check + reviewer pre-flight) |
| RC-13 | 2000 tok/turn noise | C-15 (intent-based filtering) |
| RC-14 | mapfile bash 3 bug | C-14 (bash 3 compatibility audit) |

Coverage: All 11 documented failure incidents addressed. Zero gaps.
