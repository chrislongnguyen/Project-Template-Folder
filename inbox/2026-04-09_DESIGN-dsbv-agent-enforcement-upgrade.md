---
version: "2.0"
status: draft
last_updated: 2026-04-09
type: dsbv-design
tags: [agent-enforcement, hooks, dsbv-upgrade, 8-component, sota]
---

# DESIGN — DSBV Agent Orchestration SOTA Upgrade

> **EO:** A Human PM runs `/dsbv` and every agent interaction produces the intended outcome —
> predictably, reliably, repeatably, cost-efficiently — across all 4 subsystems (PD→DP→DA→IDM)
> and all 5 workstreams, by moving every critical behavior from instruction compliance
> to hook/script/state enforcement.
>
> **Scope:** Operational infrastructure. Affects: `.claude/hooks/`, `.claude/settings.json`,
> `.claude/agents/`, `.claude/skills/dsbv/`, `.claude/state/`, `scripts/`,
> `.claude/rules/agent-dispatch.md`, `.claude/rules/enforcement-layers.md`.
>
> **Predecessor:** Agent 0-4 eight-component designs (2026-04-08), oh-my-claudecode analysis,
> status lifecycle automation design+test (2026-04-09), 13-CP integration test findings.
>
> **Constraint:** S > E > Sc. Every component risk-mitigated first.
>
> **Single cycle:** ALL gaps addressed in this design. No "deferred to I2" items.

---

## 1. Problem Statement

### 1.1 The Number

**9 of 23 DSBV behaviors are enforced. The other 14 rely on the agent choosing to comply.**

The DSBV skill has 500 lines of instructions describing correct behavior. But instructions
are the weakest enforcement tier. The PM cannot trust that `status: validated` means
"a human approved this" — because no hook verifies it. The PM cannot trust that agents
use the right model — because no hook checks. The PM cannot trust that build won't
loop forever — because no circuit breaker exists outside prose.

### 1.2 Enforcement Audit Summary

```
CURRENT STATE (9/23 = 39%)              TARGET STATE (21/23 = 91%)
═══════════════════════════              ═══════════════════════════
Tier 1 (Tool):      1                   Tier 1 (Tool):      1
Tier 2 (Hook):      7 + 1 partial       Tier 2 (Hook):     16  (+9 new)
Tier 3 (State):     1 partial           Tier 3 (State):      4  (+3 new)
Tier 4 (EP only):  13  ← ALL GAPS      Tier 4 (EP only):    2  (platform-blocked)
```

The 2 remaining Tier 4 are: (a) structured gate presentation format (cosmetic, not safety-critical),
(b) SEQUENCE.md dependency graph validation (requires DAG parser — disproportionate effort vs risk).

### 1.3 Root Causes (16, all addressed)

| ID | Root Cause | Component | Fix | Component # |
|----|-----------|-----------|-----|-------------|
| RC-01 | Approval detection EP-only | EOP→EOE | Gate signal detector hook | C-01 |
| RC-02 | 14 hooks lost on sub-agent dispatch | EOE | 3-layer hook compensation | C-12, C-14 |
| RC-03 | No pipeline state persistence | EOE | DSBV pipeline state file | C-10 |
| RC-04 | Status T2 (IP→IR) EP-only | EOP→EOE | Gate state file + SKILL.md protocol | C-09, C-11 |
| RC-05 | No circuit breaker in Build | EOP | Build circuit breaker hook | C-06 |
| RC-06 | Model routing not enforced | EOT→EOE | Model routing enforcer hook | C-03 |
| RC-07 | Tool allowlists not hook-enforced | EOT→EOE | Agent file declares, CC enforces (ADR-01) | N/A (CC-native) |
| RC-08 | No structured intent parsing | EI | Intent filter in gate-signal-detector | C-01 |
| RC-09 | Approval record not verified | EOP→EOE | Approval record verifier hook | C-02 |
| RC-10 | Sub-agent reports not validated | EI | Context packaging 5/5 + output schema | C-04, C-15 |
| RC-11 | Reviewer input not pre-flight checked | EI | Reviewer preflight hook | C-05 |
| RC-12 | No cost/success metrics | EA | Dispatch logger hook | C-17 |
| RC-13 | Auto-recall unfiltered | EI | Gate-aware recall suppression | C-01 (side-effect) |
| RC-14 | iteration-bump.sh mapfile bug | EOT | Bash 3 compatibility fix | C-16 |
| RC-15 | Agent deviates without asking | EA | Pipeline state + circuit breaker | C-06, C-10 |
| RC-16 | No historical FAIL data | EI | Dispatch log + FAIL aggregation | C-17, C-18 |

### 1.4 Documented Failures (11, all addressed)

| Incident | Date | What Failed | Fix |
|----------|------|-------------|-----|
| LP-6: Obsidian CLI 32 ACs passed, all commands failed | 2026-04-01 | No live smoke test AC | C-13 (smoke test runner) |
| LP-7: Sub-agent hooks don't fire | 2026-04-08 | Platform constraint | C-12, C-14 (compensation) |
| DSBV agent not spawned | 2026-03-27 | Skill not invoked | C-10 (pipeline state tracks phase) |
| Agent self-set validated | 2026-04-06 | No approval verification | C-02 (approval record verifier) |
| 13-CP test: took over 9/13 CPs | 2026-04-09 | Agent deviated from execution mode | C-06 (circuit breaker), memory rule |
| CCR doesn't route sub-agents | 2026-04-02 | Model routing unenforceable via proxy | C-03 (PreToolUse hook) |
| 43/51 skills lack model declarations | 2026-04-02 | No enforcement mechanism | C-03 (enforces at dispatch) |
| Planner EP-13 contradiction | 2026-04-08 | False orchestrator claim | FIXED in v1.5 |
| Reviewer started without DESIGN.md | Various | No preflight check | C-05 (reviewer preflight) |
| Builder failure loops | Various | No iteration limit | C-06 (circuit breaker) |
| Registry drift from reality | Various | Manual sync forgotten | C-07 (auto-sync on validated) |

---

## 2. Architecture

### 2.1 Three-Layer Enforcement Model

Every DSBV behavior is enforced by at least TWO of three layers:

```
┌─────────────────────────────────────────────────────────┐
│  LAYER 1: HOOKS (deterministic, code-enforced)          │
│  UserPromptSubmit, PreToolUse, PostToolUse, SessionStart │
│  → System DOES the thing. Agent cannot bypass.           │
├─────────────────────────────────────────────────────────┤
│  LAYER 2: STATE (.claude/state/)                         │
│  dsbv-gate-active.json, dsbv-pipeline.json,              │
│  dispatch-log.json                                       │
│  → System REMEMBERS the thing. Survives /compress.       │
├─────────────────────────────────────────────────────────┤
│  LAYER 3: INSTRUCTIONS (SKILL.md, agent files, rules)    │
│  → Agent KNOWS the thing. Documentation + guidance.      │
│  → BACKED by Layer 1 + Layer 2 for critical behaviors.   │
└─────────────────────────────────────────────────────────┘
```

**Sub-agent hook compensation (ADR-02):**
Since PostToolUse hooks don't fire for sub-agents (GitHub #40580), each agent file
includes a `## Hook Compensation` section instructing the agent to call specific
hooks via Bash after Write/Edit operations. This is Layer 3 compensating for
Layer 1's platform constraint — imperfect but best achievable.

### 2.2 DSBV State Machine

```
.claude/state/dsbv-pipeline.json tracks:
{
  "workstream": "1-ALIGN",
  "subsystem": "1-PD",
  "phase": "design",
  "phase_status": "presenting_gate",
  "iteration": { "current": 1, "build_attempts": 0, "critic_loops": 0 },
  "gates": {
    "G1": { "status": "pending", "presented_at": null, "resolved_at": null },
    "G2": { "status": "not_started" },
    "G3": { "status": "not_started" },
    "G4": { "status": "not_started" }
  },
  "updated_at": "2026-04-09T12:00:00Z"
}
```

**Written by:** SKILL.md at phase transitions (Layer 3).
**Read by:** Hooks at every event (Layer 1).
**Survives:** /compress and session restart (Layer 2).

### 2.3 PM Workflow (unchanged surface, new enforcement underneath)

```
PM types: /dsbv design align
  │
  ├─ SessionStart: pipeline state loaded (if exists)
  ├─ SKILL.md: readiness check C1-C6 (reads state + disk)
  ├─ SKILL.md: dispatches ltc-planner (Opus)
  │   ├─ PreToolUse(Agent): context packaging validated (5/5)
  │   ├─ PreToolUse(Agent): model=opus validated
  │   └─ PostToolUse(Agent): dispatch logged
  ├─ Planner returns DESIGN.md content
  ├─ SKILL.md: writes DESIGN.md to disk
  │   └─ PostToolUse(Write): inject-frontmatter → status: draft
  ├─ SKILL.md: presents G1 gate
  │   └─ SKILL.md: writes .claude/state/dsbv-gate-active.json
  │
PM types: "looks good"
  │
  ├─ UserPromptSubmit: gate-signal-detector reads gate state
  │   └─ Injects: <GATE_SIGNAL tier=1 signal="looks good" gate=G1-Design>
  ├─ SKILL.md: reads injected signal → executes Gate Approval Protocol
  │   ├─ Step 1: approval record written
  │   ├─ Step 2: status: validated set
  │   │   └─ PostToolUse(Edit): approval-record-verifier checks ## Approval Log
  │   ├─ Step 3: generate-registry.sh auto-triggered
  │   ├─ Step 4: gate state file deleted
  │   └─ Step 5: pipeline state updated (G1: approved)
  ├─ SKILL.md: creates SEQUENCE.md → advances to Phase 2
  │
  ... (repeat for G2, G3, G4)
```

---

## 3. Architecture Decision Records

### ADR-01: Unified /dsbv Skill (No Split)

**Decision:** Keep one `/dsbv` skill with sub-commands, not 4 separate phase skills.

**Alternatives considered:**
- A) 4 skills: `/dsbv-design`, `/dsbv-sequence`, `/dsbv-build`, `/dsbv-validate`
- B) Unified skill with sub-commands (current)
- C) OMC-style team mode with pipeline stages

**Why B:** (a) Single state file manages all phases — splitting requires cross-skill state sharing.
(b) Gate Approval Protocol spans phases (G1 approval creates SEQUENCE.md) — splitting breaks this.
(c) PM muscle memory already on `/dsbv`. (d) Sub-commands (`/dsbv design`, `/dsbv build`) give
phase-specific entry when needed.

**Risk:** Skill file grows large (currently 500 lines, may reach 700+). Mitigated by phase-execution-guide.md reference file keeping phase-specific detail out of the main skill.

### ADR-02: Three-Layer Hook Compensation

**Decision:** Sub-agents call hooks via Bash as compensation for platform constraint #40580.

**Alternatives considered:**
- A) Wait for CC to fix sub-agent hook firing
- B) Move all work to main session (no sub-agents)
- C) Agent files instruct sub-agents to call hooks via Bash

**Why C:** (a) Platform fix timeline unknown. (b) Moving to main session loses MECE agent separation.
(c) Compensation is 2-3 lines in each agent file and covers 80% of critical hooks.

**What compensation covers:** inject-frontmatter.sh (T1/T4), generate-registry.sh.
**What it cannot cover:** PreToolUse hooks (naming-lint, dsbv-skill-guard) — these only fire in main session.

### ADR-03: Agent() Over Team Mode

**Decision:** Continue using Agent() sub-agent dispatch, not Claude Code experimental Agent Teams.

**Alternatives considered:**
- A) Agent Teams (teammates communicate via mailbox)
- B) Agent() sub-agents (orchestrator dispatches, receives output)

**Why B:** (a) 13-CP test proved Agent Teams adds 2.8x overhead per checkpoint.
(b) PostToolUse hooks don't fire for teammates either — no enforcement advantage.
(c) PM doesn't need agent-to-agent communication — orchestrator mediates all handoffs.
(d) Agent() is stable; Teams is experimental.

**When to revisit:** If Claude Code stabilizes Teams AND hooks fire for teammates, team mode
becomes viable for parallel Build (N builders working concurrently with task claiming).

### ADR-04: File-Based State at .claude/state/

**Decision:** DSBV phase state persists to `.claude/state/` directory, read by hooks and SessionStart.

**Alternatives considered:**
- A) In-context only (current — lost on /compress)
- B) File-based state in `.claude/state/`
- C) MCP state server (like OMC's state_read/state_write)

**Why B:** (a) PM uses /compress at 30-40%, but pipeline state must survive it.
(b) File-based is simplest — hooks read JSON with jq, no MCP overhead.
(c) SessionStart hook already exists for reconstruction — just add state file reading.
(d) `.claude/state/` is gitignored (session-local, not committed).

### ADR-05: WARN Over BLOCK for Non-Critical Enforcement

**Decision:** New hooks use WARN (exit 0 + stderr message) for non-safety items,
BLOCK (exit 1) only for safety-critical items.

**BLOCK (exit 1):** model routing mismatch, context packaging missing, agent calling blocked tool.
**WARN (exit 0 + stderr):** missing approval record, registry not synced, gate format deviation.

**Why:** Aggressive blocking causes approval fatigue (OMC community lesson). PM workflow
should never be STOPPED by a cosmetic enforcement — only by a safety violation.

---

## 4. Component Inventory (18 components)

### Layer 1: Hooks (9 new/upgraded hooks)

#### C-01: gate-signal-detector [P0 — RC-01, RC-04, RC-08, RC-13]

**What:** UserPromptSubmit hook. When `.claude/state/dsbv-gate-active.json` exists, classifies human
message against Tier 1-4 approval signal catalog and injects result as `<system-reminder>`.

**Script:** `.claude/hooks/gate-signal-detector.sh`

**Behavior:**
```
IF .claude/state/dsbv-gate-active.json exists:
  Read gate context (gate name, workstream, artifact)
  Match user message against signal patterns:
    Tier 1 keywords: approved, validated, looks good, sounds good, lgtm, confirmed, ship it
    Tier 2 keywords: proceed to, go ahead, build it, continue, next, ready for, yes (after gate Q)
    Tier 4 keywords: wait, hold on, stop, no, not yet, revise, redo, rework
    Default (no match): Tier 3 (ambiguous)
  Intent filter: if message contains "what does", "how does", "explain", "help" → suppress (no signal)
  Inject: <system-reminder>GATE_SIGNAL: tier={N}, signal="{phrase}", gate={gate}</system-reminder>
ELSE:
  Exit 0 silently (no gate active)
```

**Tier escalation:** Approval detection moves from Tier 4 → Tier 2.
**Addresses:** RC-01 (approval EP-only), RC-04 (T2 EP-only), RC-08 (intent parsing), RC-13 (recall noise reduced when gate active).

**S×E×Sc:** S=9 (deterministic classification) | E=8 (runs only when gate active) | Sc=8 (catalog in JSON, extensible)

#### C-02: approval-record-verifier [P1 — RC-09]

**What:** PostToolUse hook on Edit. When `status: validated` is written to a `.md` file,
checks that `## Approval Log` section exists in the file.

**Script:** `.claude/hooks/approval-record-verifier.sh`

**Behavior:** WARN (not BLOCK) per ADR-05. Emits stderr warning if approval log missing.

**S×E×Sc:** S=8 | E=9 (fires only on status:validated edits) | Sc=8

#### C-03: model-routing-enforcer [P1 — RC-06]

**What:** Extends existing `verify-agent-dispatch.sh`. On PreToolUse(Agent), reads `model` param
from tool input and validates against agent file frontmatter.

**Script:** `.claude/hooks/verify-agent-dispatch.sh` (upgrade from v1.0 to v2.0)

**Behavior:** BLOCK if model mismatch. Reads agent name from `subagent_type` param, looks up
expected model from `.claude/agents/{name}.md` frontmatter `model:` field.

**Map:** ltc-explorer→haiku, ltc-planner→opus, ltc-builder→sonnet, ltc-reviewer→opus.

**S×E×Sc:** S=9 (prevents cost blowup) | E=9 (string comparison, <100ms) | Sc=9 (reads from agent files)

#### C-04: context-packaging-complete [P1 — RC-10]

**What:** Upgrade `verify-agent-dispatch.sh` to validate all 5 fields (currently 3/5).

**Current:** Checks `## 1. EO`, `## 2. INPUT`, `## 5. VERIFY`.
**Upgrade:** Also check `## 3. EP`, `## 4. OUTPUT`.

**Behavior:** BLOCK if any field missing (all 5 are required per context-packaging.md).

**S×E×Sc:** S=9 | E=9 | Sc=9

#### C-05: reviewer-preflight [P2 — RC-11]

**What:** PreToolUse hook on Agent() when `subagent_type=ltc-reviewer`. Checks that the
prompt includes a DESIGN.md reference (file path or content).

**Script:** `.claude/hooks/reviewer-preflight.sh`

**Behavior:** WARN if no DESIGN.md reference found. Prevents wasted Opus invocation on incomplete input.

**Pattern match:** Prompt must contain `DESIGN.md` or the file content of a DESIGN.md.

**S×E×Sc:** S=8 (saves Opus tokens) | E=7 (string search in prompt) | Sc=7

#### C-06: build-circuit-breaker [P1 — RC-05, RC-15]

**What:** The DSBV skill tracks build attempts and critic loops in `.claude/state/dsbv-pipeline.json`.
After each builder dispatch, increment counter. SKILL.md checks counter before next dispatch.

**Enforcement:** This is Layer 2 (state) + Layer 3 (skill reads state). No hook needed — the state
file IS the enforcement mechanism. Skill refuses to dispatch if:
- `build_attempts >= 3` for same task
- `critic_loops >= 3` for same workstream
- 2 consecutive SEMANTIC failures (circuit breaker per existing SKILL.md design)

**Escalation:** Skill presents: "Circuit breaker tripped. {N} attempts, {failures} remaining.
Diagnostic: {EP→Input→EOP→EOE→EOT→Agent trace}. Human decision required."

**S×E×Sc:** S=9 (prevents token burn) | E=8 (counter check) | Sc=8

#### C-07: registry-auto-sync [P2 — RC-09 related]

**What:** PostToolUse hook on Edit. When `status: validated` is set in a workstream file,
auto-runs `./scripts/generate-registry.sh`.

**Script:** `.claude/hooks/registry-auto-sync.sh`

**Behavior:** Runs silently. If generate-registry.sh fails, logs warning but doesn't block.

**S×E×Sc:** S=7 (prevents drift) | E=6 (runs script, adds ~2s latency) | Sc=9

#### C-08: stale-gate-cleanup [P3 — defensive]

**What:** SessionStart hook. Checks `.claude/state/dsbv-gate-active.json` — if older than 24h, deletes it.

**Script:** `.claude/hooks/stale-gate-cleanup.sh`

**Rationale:** If DSBV skill crashes mid-gate, the state file is orphaned. C-01 would fire incorrectly.

**S×E×Sc:** S=9 (prevents stale state) | E=9 (stat check + delete) | Sc=9

#### C-09: dispatch-logger [P2 — RC-12, RC-16]

**What:** PostToolUse hook on Agent(). Logs dispatch metadata to `.claude/state/dispatch-log.jsonl`.

**Script:** `.claude/hooks/dispatch-logger.sh`

**Log entry:**
```json
{"ts":"2026-04-09T12:00:00Z","agent":"ltc-builder","model":"sonnet","workstream":"1-ALIGN","phase":"build","task":"charter-draft"}
```

**Enables:** Cost tracking (count dispatches × model tier), historical FAIL pattern detection,
success metrics aggregation.

**S×E×Sc:** S=7 | E=8 (append-only, fast) | Sc=9 (JSONL, grep-able)

### Layer 2: State Files (3 new)

#### C-10: DSBV pipeline state [P0 — RC-03, RC-04]

**File:** `.claude/state/dsbv-pipeline.json` (schema in §2.2)

**Written by:** DSBV skill at every phase transition.
**Read by:** DSBV skill at session start (via SessionStart reconstruction), C-06 (circuit breaker).
**Gitignored:** Yes — session-local, not committed.

**S×E×Sc:** S=9 (survives /compress) | E=8 | Sc=9

#### C-11: DSBV gate state [P0 — enables C-01]

**File:** `.claude/state/dsbv-gate-active.json` (schema in §2.2)

**Written by:** DSBV skill at gate presentation.
**Deleted by:** DSBV skill after gate resolution (approval/rejection/park).
**Read by:** C-01 (gate-signal-detector) on every UserPromptSubmit.

**S×E×Sc:** S=9 | E=9 | Sc=9

#### C-12: Dispatch log [P2 — enables RC-12, RC-16]

**File:** `.claude/state/dispatch-log.jsonl`

**Written by:** C-09 (dispatch-logger hook).
**Read by:** `/dsbv status` (cost summary), IMPROVE retros (pattern analysis).

**S×E×Sc:** S=7 | E=8 | Sc=9

### Layer 3: Skill + Agent Upgrades (6)

#### C-13: SKILL.md Gate Approval Protocol v2 [P0 — RC-01, RC-04]

**Changes to SKILL.md § Gate Approval Protocol:**

| Step | Current | Upgraded |
|------|---------|---------|
| Step 0 (NEW) | — | Write `.claude/state/dsbv-gate-active.json` |
| Step 1 | Detect signal (agent judgment) | Read `<GATE_SIGNAL>` from hook injection (C-01) |
| Step 2 | Write approval record | Write approval record (unchanged) |
| Step 3 | Set status: validated | Set status: validated (unchanged) |
| Step 4 | Run generate-registry.sh | Auto-triggered by C-07 hook (removed from skill) |
| Step 5 | Create next phase artifact | Create next phase artifact (unchanged) |
| Step 6 (NEW) | — | Delete `.claude/state/dsbv-gate-active.json` |
| Step 7 (NEW) | — | Update `.claude/state/dsbv-pipeline.json` gate status |

**Key change:** Step 1 no longer requires agent to parse human message. The hook (C-01)
already classified it. Agent reads the injected `<GATE_SIGNAL>` tag and acts on the tier.

#### C-14: Sub-agent hook compensation protocol [P1 — RC-02]

**Add to each agent file a `## Hook Compensation` section:**

**ltc-builder.md:**
```markdown
## Hook Compensation (GitHub #40580)
After every Write or Edit to a workstream file ([1-5]-*/), run:
  CLAUDE_FILE_PATH="<absolute-path>" ./.claude/hooks/inject-frontmatter.sh
This compensates for PostToolUse hooks not firing in sub-agent context.
```

**ltc-reviewer.md:**
```markdown
## Hook Compensation
No Write/Edit operations — no compensation needed.
Before starting: verify DESIGN.md path is accessible (Read it). If not, report:
"BLOCKED: DESIGN.md not in context. Request re-dispatch with DESIGN.md path."
```

#### C-15: Sub-agent output schema [P2 — RC-10]

**Standardize sub-agent completion reports:**

```
DONE: <artifact-path>
ACs: <pass>/<total>
Blockers: <none | list>
Model: <haiku|sonnet|opus>
Tokens: <estimated input+output>
```

Already partially defined in `rules/sub-agent-output.md`. Upgrade to include `Model` and `Tokens`
fields. C-04 validates OUTPUT field exists in context packaging.

#### C-16: Smoke test runner script [P1 — LP-6]

**Script:** `scripts/smoke-test-runner.sh`

**What:** Given a file path and test type, runs a live syntax/execution check.

**Supported types:**
```
smoke-test-runner.sh --type bash   <file>  → bash -n <file> (syntax check)
smoke-test-runner.sh --type python <file>  → python3 -m py_compile <file>
smoke-test-runner.sh --type html   <file>  → tidy -errors <file> 2>&1
smoke-test-runner.sh --type shell  <file>  → shellcheck <file>
smoke-test-runner.sh --type live   <cmd>   → runs command, checks exit code
```

**Integration:** ltc-reviewer.md Smoke Test Protocol references this script.
Builder can self-check with `--type bash/python` before reporting done.

#### C-17: Bash 3 compatibility fixes [P2 — RC-14]

**Files affected:**
- `scripts/iteration-bump.sh` line 176: `mapfile` → `while IFS= read -r`
- Audit ALL scripts for bash 4+ features (associative arrays, mapfile, `${var,,}` case conversion)

**Script:** `scripts/bash3-audit.sh` (one-time audit tool)

```bash
grep -rn 'mapfile\|declare -A\|${[^}]*,,}\|${[^}]*^^}' scripts/ .claude/hooks/
```

#### C-18: verify-agent-dispatch.sh v2.0 [P1 — RC-06, RC-10]

**Upgrade existing script (currently v1.0, 41 lines) to:**

1. Validate all 5 context packaging fields (currently 3/5) — adds `## 3. EP`, `## 4. OUTPUT`
2. Validate `model` parameter matches agent file frontmatter
3. Validate `subagent_type` is one of: ltc-explorer, ltc-planner, ltc-builder, ltc-reviewer

**Consolidates:** C-03 + C-04 into one script upgrade. Single PreToolUse(Agent) hook.

---

## 5. Acceptance Criteria (36, all binary/testable)

### Hook Enforcement (AC-01 to AC-12)

| AC | Criterion | Test Method |
|----|-----------|-------------|
| AC-01 | gate-signal-detector classifies "looks good" as Tier 1 | Create gate state, send phrase, verify `<GATE_SIGNAL tier=1>` injected |
| AC-02 | gate-signal-detector classifies "proceed to sequence" as Tier 2 | Create gate state, send phrase, verify `<GATE_SIGNAL tier=2>` injected |
| AC-03 | gate-signal-detector classifies "ok" (standalone) as Tier 3 | Create gate state, send "ok", verify `<GATE_SIGNAL tier=3>` injected |
| AC-04 | gate-signal-detector classifies "wait, revise" as Tier 4 | Create gate state, send phrase, verify `<GATE_SIGNAL tier=4>` injected |
| AC-05 | gate-signal-detector does NOT fire without gate state file | Send "looks good" without gate state → no GATE_SIGNAL injection |
| AC-06 | gate-signal-detector intent filter: "how does approval work?" → no signal | Create gate state, send info query → suppressed |
| AC-07 | approval-record-verifier WARNs on missing Approval Log | Edit file to validated without log → stderr warning |
| AC-08 | approval-record-verifier silent when Approval Log exists | Edit file to validated with log → no warning |
| AC-09 | model-routing-enforcer BLOCKs ltc-explorer with model=opus | Dispatch explorer with opus → exit 1 |
| AC-10 | model-routing-enforcer PASSes ltc-explorer with model=haiku | Dispatch explorer with haiku → exit 0 |
| AC-11 | context-packaging validates 5/5 fields | Dispatch agent missing EP field → BLOCK |
| AC-12 | registry-auto-sync runs generate-registry.sh after validated set | Edit status:validated → registry updated within 5s |

### State Management (AC-13 to AC-18)

| AC | Criterion | Test Method |
|----|-----------|-------------|
| AC-13 | DSBV skill writes pipeline state on phase transition | Run /dsbv, advance to Sequence → dsbv-pipeline.json shows phase=sequence |
| AC-14 | Pipeline state survives /compress | Write state, run /compress, new session reads state → phase preserved |
| AC-15 | Gate state file created at gate presentation | Present G1 → .claude/state/dsbv-gate-active.json exists |
| AC-16 | Gate state file deleted after gate resolution | Approve G1 → gate file deleted |
| AC-17 | Stale gate cleanup: file >24h old deleted at SessionStart | Create stale file, start session → file deleted |
| AC-18 | Dispatch log appended on every Agent() call | Dispatch 3 agents → 3 lines in dispatch-log.jsonl |

### Skill + Agent Upgrades (AC-19 to AC-28)

| AC | Criterion | Test Method |
|----|-----------|-------------|
| AC-19 | Gate Approval Protocol reads GATE_SIGNAL instead of parsing human message | Present G1, PM says "looks good" → skill reads injected tier, not raw message |
| AC-20 | Circuit breaker trips after 3 build attempts on same task | Simulate 3 failures → skill refuses 4th dispatch, presents diagnostic |
| AC-21 | Circuit breaker trips on 2 consecutive SEMANTIC failures | Simulate 2 semantic FAILs → immediate escalation |
| AC-22 | Builder hook compensation: inject-frontmatter.sh called after Write | Builder creates file → runs hook via Bash → frontmatter injected |
| AC-23 | Reviewer preflight: warns if DESIGN.md not in context | Dispatch reviewer without DESIGN.md path → WARN |
| AC-24 | Sub-agent output includes Model and Tokens fields | Builder completes → report has Model: sonnet, Tokens: ~NNNN |
| AC-25 | Smoke test runner validates bash syntax | Run on valid .sh → exit 0. Run on invalid .sh → exit 1 with error |
| AC-26 | Smoke test runner validates python syntax | Run on valid .py → exit 0. Run on invalid .py → exit 1 |
| AC-27 | LP-6 live test: at least 1 AC per DESIGN.md tests real command | Review DESIGN template → live test AC field exists |
| AC-28 | All scripts pass bash 3 compatibility audit | Run bash3-audit.sh → 0 findings |

### End-to-End (AC-29 to AC-36)

| AC | Criterion | Test Method |
|----|-----------|-------------|
| AC-29 | Full DSBV cycle: /dsbv design → PM approves → DESIGN.md validated | Run /dsbv design, say "looks good" → DESIGN.md status:validated + approval log |
| AC-30 | Full DSBV cycle: /dsbv sequence → PM approves → SEQUENCE.md validated | Run /dsbv sequence, say "approved" → SEQUENCE.md validated |
| AC-31 | Full DSBV cycle: /dsbv build → artifacts produced → Generator/Critic passes | Run /dsbv build → artifacts created, VALIDATE.md all PASS |
| AC-32 | Full DSBV cycle: /dsbv validate → PM approves → workstream complete | Run /dsbv validate, say "ship it" → all artifacts validated |
| AC-33 | Pipeline state tracks all 4 phases correctly at end of full cycle | Read dsbv-pipeline.json → G1-G4 all approved, phase=complete |
| AC-34 | Enforcement score ≥ 21/23 (91%) in re-audit | Re-run enforcement audit → 21+ behaviors at Tier 2+ |
| AC-35 | /dsbv status shows dispatch cost summary from log | Run /dsbv status → includes "Dispatches: N, Est. cost: $X.XX" |
| AC-36 | Full cycle runs without PM encountering a single unintended BLOCK | PM reports zero false-positive blocks during full DSBV cycle |

---

## 6. Sequencing (6 Build Rounds)

```
ROUND 1 — Foundation (no dependencies)              ~1 hr
  C-10  Pipeline state file (schema + .gitignore)
  C-11  Gate state file (schema)
  C-17  Bash 3 compatibility fixes
  C-08  Stale gate cleanup hook

ROUND 2 — Core Hooks (depends on Round 1)            ~3 hr
  C-01  gate-signal-detector hook
  C-18  verify-agent-dispatch.sh v2.0 (model + 5/5 fields)

ROUND 3 — Secondary Hooks (depends on Round 1)       ~2 hr
  C-02  approval-record-verifier hook
  C-07  registry-auto-sync hook
  C-05  reviewer-preflight hook
  C-09  dispatch-logger hook

ROUND 4 — Skill + Agent Upgrades (depends on R1+R2)  ~2 hr
  C-13  SKILL.md Gate Approval Protocol v2
  C-14  Agent file hook compensation sections
  C-15  Sub-agent output schema upgrade
  C-16  Smoke test runner script

ROUND 5 — Circuit Breaker (depends on R1+R4)         ~1 hr
  C-06  Build circuit breaker (state-based)

ROUND 6 — End-to-End Validation                       ~2 hr
  Run AC-29 through AC-36 (full DSBV cycle)
  Re-run enforcement audit (AC-34)
  PM experience test (AC-36)
```

**Total estimated effort:** ~11 hours across 6 rounds. Rounds 2+3 can run in parallel.

---

## 7. UBS Analysis

| Risk | Category | Severity | Mitigation |
|------|----------|----------|------------|
| C-01 false positive: "good point" classified as approval | Human | HIGH | Tier 3 default (ambiguous). Intent filter catches info queries. Test with 20+ edge cases in AC-01–06 |
| C-01 false negative: unusual approval phrasing missed | Human | MEDIUM | Extensible JSON catalog. PM can always use explicit Tier 1 words |
| Hook latency: 9 new hooks add cumulative delay | Technical | MEDIUM | All hooks <3s timeout. C-01 only on gate active. C-02/C-07 only on validated. Most are <100ms string checks |
| Pipeline state file corruption | Technical | LOW | JSON validated on read. Stale cleanup (C-08). File is gitignored — safe to delete |
| Builder ignores hook compensation instructions | Human | MEDIUM | Layer 3 (EP) weakness. Mitigated by C-04 (output schema forces structured report) and C-06 (circuit breaker catches bad output) |
| Approval fatigue from too many WARNs | Human | MEDIUM | ADR-05: only BLOCK on safety. WARN is stderr only — doesn't interrupt PM flow |
| /dsbv status cost display inaccurate | Economic | LOW | Dispatch log is approximate (estimated tokens, not actual). Labeled as "Est." |
| Large skill file (700+ lines) | Technical | LOW | ADR-01: keep unified. Phase detail in reference files. Main skill file stays ~600 lines |

---

## 8. Force Analysis

```
DESIRED EO: PM runs /dsbv → 4 subsystems produced correctly every time

DRIVING FORCES (+)                     BLOCKING FORCES (-)
═══════════════════                    ═════════════════════
+ EP complete (12 rules, 14 EPs)       - 14/23 behaviors are Tier 4 ← CLOSING
+ 8 existing Tier 2 hooks              - Sub-agents lose 14 hooks (platform)
+ Human gates at G1-G4                 - No gate state for hook context ← CLOSING
+ Agent designs documented (0-4)       - No pipeline state ← CLOSING
+ Builder is only writer (scope sep)   - No circuit breaker ← CLOSING
+ Status lifecycle scripts (6)         - Model routing unenforced ← CLOSING
+ OMC patterns researched              - No cost visibility ← CLOSING
+ 1M context + /compress workflow      - Approval detection EP-only ← CLOSING

INTERVENTION: 18 components across 3 layers.
  Hooks:   9 (new/upgraded)
  State:   3 (new files)
  Skill:   6 (upgrades)

Enforcement: 39% → 91%. Remaining 9% = 2 behaviors where platform makes
Tier 2 impossible (structured gate format, DAG dependency validation).
```

---

## Links

- [[2026-04-08_DESIGN-agent-0-orchestrator]]
- [[2026-04-08_DESIGN-agent-1-explorer]]
- [[2026-04-08_DESIGN-agent-2-planner]]
- [[2026-04-08_DESIGN-agent-3-builder]]
- [[2026-04-08_DESIGN-agent-4-reviewer]]
- [[2026-04-09_RESULT-status-lifecycle-roleplay]]
- [[enforcement-layers]]
- [[hook-enforcement-patterns]]
- [[oh-my-claudecode]]
