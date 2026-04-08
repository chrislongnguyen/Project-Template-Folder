---
version: "1.6"
status: draft
last_updated: 2026-04-08
name: dsbv
description: "Run the DSBV sub-process (Design → Sequence → Build → Validate) within any APEI workstream. Guides L2-L4 users through structured artifact production with human gates, readiness checks, and multi-agent Build support."
---
# /dsbv — Design, Sequence, Build, Validate

Run the 4-phase DSBV process to produce a workstream's artifacts. DSBV applies to 4 workstreams: **ALIGN, PLAN, EXECUTE, IMPROVE**. DSBV defines HOW you produce work; the workstream defines WHAT you produce.

<HARD-CONSTRAINT>
**LEARN (2-LEARN/) does NOT use DSBV.** LEARN uses the learning pipeline (Input → Research → Specs → Output → Archive). DESIGN.md, SEQUENCE.md, and VALIDATE.md must NEVER be created in 2-LEARN/. If a user requests `/dsbv` for LEARN, explain that LEARN uses the pipeline and suggest appropriate pipeline actions instead. See: `.claude/rules/filesystem-routing.md` (Mode B).
</HARD-CONSTRAINT>

## Sub-Commands

| Command | What it does |
|---|---|
| `/dsbv` | Full guided flow — all 4 phases with human gates between each |
| `/dsbv design [workstream]` | Design phase only — define what the workstream must produce and why |
| `/dsbv sequence [workstream]` | Sequence phase only — order the work, size tasks, map dependencies |
| `/dsbv build [workstream]` | Build phase only — execute the approved sequence |
| `/dsbv validate [workstream]` | Validate phase only — verify workstream output enables the next workstream |
| `/dsbv status` | Show current DSBV state: which workstream, which phase, what is done |

If `[workstream]` is omitted, ask the user which workstream (ALIGN, PLAN, EXECUTE, IMPROVE). **Never offer LEARN as a DSBV option.**

<HARD-GATE>
1. Cannot start Sequence without an approved DESIGN.md.
2. Cannot start Build without an approved SEQUENCE.md.
3. Cannot mark a workstream complete without Validate passing.
4. Multi-agent Build requires explicit human approval before launching (show cost estimate first).
5. Running a single-phase sub-command (e.g., `/dsbv build`) on a workstream that lacks the prerequisite artifact is an error — tell the user what is missing and how to produce it.
</HARD-GATE>

## Meta-Rules (re-injected — compensates for LT-2 context degradation)

These are always in effect. They override any conflicting behavior:

1. **MODEL AS SYSTEM:** Before any phase, identify the 7-CS components in play (EP, Input, EOP, EOE, EOT, Agent, EA). If a component is missing or misconfigured, flag it.
   (Source: agent-system.md §5)

2. **UBS BEFORE UDS:** What blocks this workstream? Answer BEFORE asking what drives it. Identify risks, dependencies, and constraints first.
   (Source: general-system.md §5 — Force Analysis)

3. **SUSTAINABILITY FIRST:** Risk-mitigated > efficient > scalable. A fragile fast artifact is worse than a slow reliable one.
   (Source: general-system.md §6 — S > E > Sc priority)

4. **VANA DECOMPOSE:** Every requirement = Verb + Adverb + Noun + Adjective. If you cannot decompose it, you do not understand it.
   (Source: general-system.md §8 — ESD Phase 3)

5. **DEFINE DONE:** Every acceptance criterion must be binary, deterministic, testable. "Good quality" is not an AC. "All DESIGN.md artifacts have a success rubric with ≥1 binary criterion" is.
   (Source: general-system.md §7 — Layer 3 Eval Spec)

## Readiness Check (C1-C6)

Before ANY phase, verify these conditions. If any is RED, tell the user what is missing and how to fix it. Do not proceed until all are GREEN.

| ID | Condition | How to check |
|----|-----------|--------------|
| C1 | **Clear scope** | Workstream identified. In-scope and out-of-scope are written down. |
| C2 | **Input materials curated** | Reading list assembled — prior workstream output, reference docs, research. No "go find it yourself." |
| C3 | **Success rubric defined** | Per-artifact criteria exist, not vibes. |
| C4 | **Process definition loaded** | `_genesis/templates/dsbv-process.md` is in context. |
| C5 | **Prompt engineered** | Context fits within effective window. Irrelevant material removed. |
| C6 | **Evaluation protocol defined** | How outputs will be compared (multi-agent) or reviewed (single-agent). |

Report readiness as a table: `C1: GREEN | C2: RED — missing prior workstream output | ...`

**Practical execution guidance:** Read [references/phase-execution-guide.md](references/phase-execution-guide.md) for quality patterns per phase — what good DESIGN.md looks like, dependency ordering by workstream, Build quality checkpoints, Validate evidence standards.

## Agent Dispatch Protocol

Every `Agent()` call in **ANY phase** (Design, Sequence, Build, Validate) MUST use the 5-field context packaging template. This is always-on — not phase-specific.

**Template:** `.claude/skills/dsbv/references/context-packaging.md` (EO, INPUT, EP, OUTPUT, VERIFY)

**Rule:** `.claude/rules/agent-dispatch.md` — enforced via PreToolUse hook; ad-hoc Agent() calls without the 5-field structure are blocked.

**Why:** Context degradation (LT-2) causes sub-agents to drift from scope when given unstructured prompts. The 5-field template is the minimum viable context package that compensates. An Agent() call is only as good as the context it receives.

---

## Phase 1: DESIGN

**What this does:** Defines WHAT the workstream must produce and WHY — before any work begins. This is the contract. If it is not in DESIGN.md, it is not in scope.

**Why it matters:** Skipping Design is the #1 cause of wasted work. An hour of Design saves days of rework (Principle 1: Brake Before Gas).

**Steps:**
1. Ask the user for their high-level intent (1-3 sentences about what this workstream should accomplish)
2. Look up the Design template: grep `## Routing: {workstream}` in
   `_genesis/frameworks/alpei-dsbv-process-map.md`, Design row, Template column.
   Default: `design-template.md` if routing table not yet populated for this workstream.
3. **Dispatch to ltc-planner.** Context-package the design problem using the 5-field template (`references/context-packaging.md`): EO = workstream intent, INPUT = charter + template + prior decisions, EP = design quality checks from planner agent file, OUTPUT = DESIGN.md in output contract envelope, VERIFY = alignment check (zero orphans). The planner drafts DESIGN.md — do NOT produce it inline.
4. Write the planner's returned DESIGN.md content to `{workstream-number}-{WORKSTREAM}/DESIGN.md`
5. Present DESIGN.md to the user for review

**EXCEPTION:** If the workstream has ≤2 artifacts AND the user has already stated the full design intent in this session, the orchestrator MAY produce DESIGN.md inline after confirming with the user: "This is a simple design — produce inline or dispatch planner?"

**Output:** `{workstream-number}-{WORKSTREAM}/DESIGN.md` (e.g., `1-ALIGN/DESIGN.md`)

**Gate G1:** "I have completed the Design phase. Here is what I produced: [artifact list with summary]. Alignment check: [N conditions, N artifacts, 0 orphans]. Ready to proceed to Sequence?"
Wait for explicit human approval. If the user requests changes, revise and re-present.

## Phase 2: SEQUENCE

**What this does:** Orders the work — what depends on what, what gets built first, how large each task is. This prevents the agent from jumping around or attempting work whose inputs do not exist yet.

**Why it matters:** Without sequencing, agents attempt tasks in arbitrary order and fail on dependencies (LT-3: reasoning degrades on complex tasks). Explicit ordering compensates.

**Steps:**
1. Read the approved DESIGN.md
2. **Dispatch to ltc-planner.** Context-package using the 5-field template (`references/context-packaging.md`): EO = order the work for this workstream, INPUT = approved DESIGN.md + workstream context, EP = dependency mapping + sizing from planner agent file, OUTPUT = SEQUENCE.md in output contract envelope, VERIFY = all DESIGN.md artifacts have ≥1 task, no circular dependencies. The planner drafts SEQUENCE.md — do NOT produce it inline.
3. Write the planner's returned SEQUENCE.md content to `{workstream-number}-{WORKSTREAM}/SEQUENCE.md`
4. Present SEQUENCE.md to the user

**EXCEPTION:** Same as Phase 1 — if ≤2 artifacts and user confirms inline, orchestrator may produce directly.

**Output:** `{workstream-number}-{WORKSTREAM}/SEQUENCE.md`

**Gate G2:** "I have completed the Sequence phase. Here is the task order: [numbered list with sizes]. Ready to proceed to Build?"

## Phase 3: BUILD

**What this does:** Executes the work following the approved sequence. Each task is completed, self-verified against its acceptance criteria, and committed before moving to the next.

**Why it matters:** This is where artifacts are actually produced. The pattern varies by workstream type to balance quality with cost.

**Workstream-aware behavior:**

For the current workstream's Build-phase template and agent, look up:
`_genesis/frameworks/alpei-dsbv-process-map.md` § `## Routing: {WORKSTREAM}`, Build row.

| Workstream type | Default pattern | Why |
|---|---|---|
| Design-heavy (ALIGN, PLAN) | Competing Hypotheses + Synthesis: 3 Sonnet agents produce parallel drafts, 1 Opus synthesizes | Open-ended work benefits from diverse perspectives. Missing a risk in ALIGN has high blast radius. |
| Execution-heavy (EXECUTE, IMPROVE) | Single agent, sequential tasks | Output is more deterministic — diversity adds cost, not quality. |

**Model configuration (user-overridable):**
- Default teams: Sonnet for breadth, Opus for synthesis, current model for other phases
- Override: `/dsbv build align --model opus --teams 3`
- Cost guidance shown before multi-agent launch:
  ```
  Multi-agent Build: ~3 Sonnet runs ($5-8) + 1 Opus synthesis ($2-5) = ~$10-13
  Single-agent Build: ~1 Opus run ($3-5)
  Proceed with multi-agent? [y/n]
  ```

**Agent dispatch:** When spawning sub-agents for Build, use the `ltc-builder` agent file (`.claude/agents/ltc-builder.md`). This ensures Sonnet model, tool allowlist (Read, Edit, Write, Bash, Grep), and scope constraints are enforced deterministically via the agent file — not inline prompt. **Context packaging:** Every Agent() call must use the 5-field template in `references/context-packaging.md` (EO, INPUT, EP, OUTPUT, VERIFY).

**Steps (single-agent):**
1. For each task in SEQUENCE.md in order:
   a. Dispatch to `ltc-builder` with context package (see `references/context-packaging.md`)
   b. ltc-builder self-verifies against task acceptance criteria
   c. Checkpoint commit
2. When all tasks complete, run Generator/Critic loop (see below)

If Build fails (tool error, agent confusion, repeated failures): Stop. Do NOT retry more than once. Report to user with: what was attempted, what failed, the error output. User decides whether to retry, simplify scope, or skip to next artifact.

**Steps (multi-agent):**
1. Show cost estimate. Wait for human approval.
2. Launch N `ltc-builder` agents in parallel, each producing a complete draft for the task set
3. Opus synthesizes: selects best elements from each draft, resolves conflicts
4. Present synthesis to the user
5. Checkpoint commit
6. Run Generator/Critic loop on synthesized output (see below)

### Generator/Critic Loop

After Build completes (single or multi-agent), dispatch `ltc-reviewer` to validate. If FAIL items exist, re-dispatch `ltc-builder` to fix them. Repeat until all PASS or max iterations reached.

**Parameters:**
- `max_iterations`: 3 (builder + reviewer = 1 iteration)
- `exit_condition`: all criteria PASS in VALIDATE.md
- `cost_cap`: ~$0.06 per iteration (Sonnet builder + Opus reviewer)

**Loop flow:**

```
iteration = 0
WHILE iteration < max_iterations:
  1. Dispatch ltc-reviewer with:
     - DESIGN.md (the contract)
     - All produced artifacts
     - Context package per references/context-packaging.md
  2. Reviewer produces VALIDATE.md v2 (Aggregate Score + FAIL items)
  3. IF all PASS → EXIT loop → proceed to Gate G3
  4. IF FAIL items exist:
     a. Format FAIL items as builder EI:
        - For each FAIL-{N}: file, criterion, expected, actual, fix instruction, severity, AC
        - Include only FAIL items (not PASS — builder already produced those correctly)
     b. Dispatch ltc-builder with:
        - FAIL items as structured INPUT
        - Original SEQUENCE.md task context
        - EP: "Fix ONLY the listed FAIL items. Do NOT modify passing artifacts."
     c. Builder fixes and reports completion
     d. iteration += 1
  5. IF iteration == max_iterations AND FAIL items remain:
     ESCALATE to Human Director:
       "Generator/Critic loop exhausted after {max_iterations} iterations.
        Remaining FAIL items: {list with FAIL-{N} details}
        Diagnostic: {circuit breaker analysis — see below}
        Action required: human decision to fix, override, or descope."
```

**Cost tracking:** Log per-iteration cost (builder tokens + reviewer tokens). If cumulative cost exceeds 3x cost_cap, warn before next iteration.

### Circuit Breaker + Error Classification

Prevents infinite loops and classifies errors for intelligent retry decisions.

**Error types:**

| Type | Description | Action | Example |
|------|-------------|--------|---------|
| SYNTACTIC | Formatting, structure, missing field | Auto-retry (builder can fix) | Missing frontmatter, broken markdown |
| SEMANTIC | Wrong content, misunderstood requirement | Escalate to orchestrator | Builder implemented wrong algorithm |
| ENVIRONMENTAL | Tool failure, file system issue | Fix environment + retry | Permission denied, disk full, script not found |
| SCOPE | Requirement exceeds agent capability | Escalate to human | Task needs research (builder cannot do) |

**Hard stops (circuit breakers):**
1. **Same FAIL persists 2 iterations** → ESCALATE. The builder cannot fix this issue — it needs human or planner intervention.
2. **2 consecutive agent failures** (tool errors, crashes, empty output) → STOP pipeline. Environment is likely degraded.
3. **All FAIL items are SEMANTIC** → ESCALATE immediately (do not retry). Semantic errors indicate misunderstanding, not execution failure.

**Diagnostic order** (when circuit breaker trips):
```
EP → Input → EOP → EOE → EOT → Agent
1. EP:    Were the principles clear? Did builder receive the right constraints?
2. Input: Was the context package complete? Were file paths correct?
3. EOP:   Was the procedure correct? Did SEQUENCE.md have the right steps?
4. EOE:   Is the environment healthy? Do scripts exist and run?
5. EOT:   Are tools working? Did Read/Write/Edit succeed?
6. Agent: Is the model producing coherent output? (Last resort — blame the model only after ruling out 1-5)
```

**Gate G3:** "Build is complete. All tasks in SEQUENCE.md are done. Generator/Critic loop: {iterations} iterations, {pass}/{total} criteria PASS. Here is what was produced: [file list]. Ready to proceed to Validate?"

## Phase 4: VALIDATE

**What this does:** Verifies that the workstream's output is complete, correct, coherent, and enables the next workstream to start. This is the quality gate before a workstream is marked done.

**Why it matters:** Without validation, errors compound across workstreams. A flawed ALIGN produces a flawed PLAN produces a flawed EXECUTE (LT-3: errors cascade through reasoning chains).

**Agent dispatch:** When spawning a sub-agent for Validate, use the `ltc-reviewer` agent file (`.claude/agents/ltc-reviewer.md`). This ensures Opus model, read-only tool allowlist (Read, Glob, Grep, Bash), and evidence-based review protocol are enforced via the agent file. **Context packaging:** Use `references/context-packaging.md` template (EO, INPUT, EP, OUTPUT, VERIFY).

**Steps:**
1. Dispatch to `ltc-reviewer` with: DESIGN.md, list of produced artifacts, workstream context
2. ltc-reviewer loads the Validate-phase template from
   `_genesis/frameworks/alpei-dsbv-process-map.md` § `## Routing: {WORKSTREAM}`, Validate row, Template column.
   Default: `dsbv-eval-template.md` if routing table not yet populated for this workstream.
3. Check **Completeness** — all artifacts listed in DESIGN.md are present
4. Check **Quality** — each artifact passes its success rubric
5. Check **Coherence** — artifacts do not contradict each other
6. Check **Downstream readiness** — the next workstream can start with these outputs
7. Produce a validation report: pass/fail per criterion with file-path evidence

**Output:** `{workstream-number}-{WORKSTREAM}/VALIDATE.md` — validation report with pass/fail per criterion

**Gate G4:** "Validation complete. Results: [pass/fail summary]. [If all pass:] Ready to mark this workstream as complete? [If any fail:] These items need attention: [list]. Want to fix them now?"

### Structured Gate Reports

Every gate presentation (G1-G4) MUST use this template for consistent human review:

```
GATE: G{N} ({phase}) | Workstream: {name}
ACs: {pass}/{total} | Risk flags: {count}
Action: APPROVE / REVISE / ESCALATE

[If REVISE or ESCALATE:]
  Items requiring attention:
  - {item 1}: {reason} (severity: blocker/cosmetic)
  - {item 2}: {reason} (severity: blocker/cosmetic)

[Cost summary if multi-agent:]
  Builder dispatches: {N} | Reviewer dispatches: {M}
  Loop iterations: {K} | Estimated token cost: ~${X.XX}
```

**Gate-specific additions:**
- **G1 (Design):** Include alignment table (conditions vs artifacts, 0 orphans)
- **G2 (Sequence):** Include dependency count and critical path length
- **G3 (Build):** Include Generator/Critic loop summary (iterations, FAIL items fixed)
- **G4 (Validate):** Include Aggregate Score from VALIDATE.md v2

## Status Command

`/dsbv status` reads `_genesis/version-registry.md` and renders the 20-row cell-level progress table.

**Full output format:**

```
DSBV Status — I1 (YYYY-MM-DD)
┌─────────────────────────┬──────────────────────────┬─────────┬─────────────┬──────────┐
│ Workstream × Phase            │ Deliverable              │ Version │ Status      │ AC Pass  │
├─────────────────────────┼──────────────────────────┼─────────┼─────────────┼──────────┤
│ 1-ALIGN × Design        │ DESIGN.md                │ 1.4     │ Draft       │ —        │
│ 1-ALIGN × Sequence      │ SEQUENCE.md              │ 1.3     │ Draft       │ —        │
│ 1-ALIGN × Build         │ Charter+ADRs+OKRs        │ 1.x     │ In Progress │ 28/30    │
│ 1-ALIGN × Validate      │ VALIDATE.md              │ 1.2     │ Draft       │ 28/30    │
│ 2-LEARN × Pipeline       │ input/research/specs/out │ 1.x     │ In Progress │ —        │
│ (LEARN uses pipeline, not DSBV — no DESIGN/SEQUENCE/VALIDATE rows)           │          │
│ 3-PLAN × Design         │ DESIGN.md                │ —       │ Pending     │ —        │
│ 3-PLAN × Sequence       │ SEQUENCE.md              │ —       │ Pending     │ —        │
│ 3-PLAN × Build          │ UBS/UDS/Architecture     │ —       │ Pending     │ —        │
│ 3-PLAN × Validate       │ VALIDATE.md              │ —       │ Pending     │ —        │
│ 4-EXECUTE × Design      │ DESIGN.md                │ 1.2     │ Draft       │ —        │
│ 4-EXECUTE × Sequence    │ SEQUENCE.md              │ —       │ Not Started │ —        │
│ 4-EXECUTE × Build       │ src/tests/config/docs    │ —       │ Not Started │ —        │
│ 4-EXECUTE × Validate    │ VALIDATE.md              │ —       │ Not Started │ —        │
│ 5-IMPROVE × Design      │ DESIGN.md                │ —       │ Pending     │ —        │
│ 5-IMPROVE × Sequence    │ SEQUENCE.md              │ —       │ Pending     │ —        │
│ 5-IMPROVE × Build       │ CHANGELOG/metrics/retros │ 1.0     │ Pending     │ —        │
│ 5-IMPROVE × Validate    │ VALIDATE.md              │ —       │ Pending     │ —        │
└─────────────────────────┴──────────────────────────┴─────────┴─────────────┴──────────┘
Active workstream: 2-LEARN × Build (In Progress)
Next gate: 2-LEARN × Validate → human approval required
```

**Single-workstream summary (backward-compatible):** `/dsbv status [workstream]` filters to 4 rows for that workstream only, preserving the same column structure.

**Data source:** All values read from `_genesis/version-registry.md` — never hardcoded in the skill. Edit the registry row, re-run `/dsbv status` → output reflects the change.

**Status vocabulary (6 values only):** `Not Started` | `Pending` | `Draft` | `Review` | `In Progress` | `Approved`
- `Pending` = upstream workstream not Approved — this cell cannot start yet
- `Not Started` = upstream is ready but this cell's primary artifact does not exist
- `Approved` = human-set only; agents never self-approve

## If the User Seems Lost

When the user expresses confusion or asks "what should I do next?":
1. Run `/dsbv status` to show where they are
2. Explain the current phase in 2-3 plain sentences
3. Suggest the specific next action: "You are in the Design phase for ALIGN. The next step is to tell me what you want ALIGN to accomplish in 1-3 sentences, and I will draft the DESIGN.md for your review."

## Gotchas

- **#1 failure mode: skipping Design** — agent rationalizes scope is "obvious" and jumps to Build. No DESIGN.md = no acceptance criteria = no way to Validate. Even a 10-line DESIGN.md is better than none.
- **Validate as rubber stamp** — agent marks all checks PASS without comparing against DESIGN.md criteria line by line. If VALIDATE.md has fewer checks than DESIGN.md has criteria, it was faked.
- **Multi-agent Build without cost confirmation** — agent spawns parallel sub-agents for design-heavy workstreams without showing estimate or getting human go.

Full list (5 patterns): [gotchas.md](gotchas.md)

## Process Reference

Full process specification: `_genesis/templates/dsbv-process.md`

**GATE — Verify:** At phase completion, confirm artifact exists on disk using Glob/Read. If the file does not exist, the phase is NOT complete. See gotchas.md for LT-1 hallucination pattern.

## Parallel Dispatch Protocol

When tasks in SEQUENCE.md are marked independent (no dependency edges between them), they MAY be dispatched simultaneously to reduce wall-clock time.

**Independence declaration in SEQUENCE.md:**
Tasks are independent when they have no shared Write targets and no data dependency. SEQUENCE.md should mark this explicitly:

```markdown
## Round N — {description} (parallel)
- T-{X}: {task} [independent]
- T-{Y}: {task} [independent]
- T-{Z}: {task} [depends on T-{X}]  ← sequential within round
```

**Dispatch rules:**
1. Only dispatch tasks marked `[independent]` in parallel
2. Each parallel task gets its own `ltc-builder` dispatch with full context package
3. Tasks with `[depends on ...]` wait for their dependency to complete
4. If ANY parallel task fails, other parallel tasks continue — failures are collected and reported together
5. Generator/Critic loop runs AFTER all parallel tasks in a round complete (not per-task)

**Cost estimate for parallel dispatch:**
```
N independent tasks × (1 builder dispatch + potential reviewer loop)
= N × ~$0.02-0.04 per task
Show estimate before dispatch. Wait for human approval if N > 3.
```

**Merge conflicts:** If two parallel builders modify the same file (should not happen if independence is correct), the second commit will conflict. This indicates a SEQUENCE.md dependency error — escalate to planner.

## Pipeline State Persistence

DSBV pipeline state is checkpointed after every phase transition and sub-agent dispatch. This enables crash recovery and session resume.

**Schema** (`pipeline.json` — written by `state-saver.sh`, read by `session-reconstruct.sh`):

```json
{
  "workstream": "4-EXECUTE",
  "phase": "build",
  "task_id": "T3.2",
  "completed_tasks": ["T1.1", "T1.2", "T2.1"],
  "last_sub_agent": "ltc-builder",
  "last_result": "PASS",
  "loop_iteration": 1,
  "fail_items": [],
  "updated": "2026-04-08T14:30:00Z"
}
```

**Fields:**
- `workstream` — current ALPEI workstream (e.g., `1-ALIGN`, `4-EXECUTE`)
- `phase` — current DSBV phase: `design` | `sequence` | `build` | `validate`
- `task_id` — current task from SEQUENCE.md (e.g., `T3.2`)
- `completed_tasks` — list of task IDs that have passed all ACs
- `last_sub_agent` — which agent was last dispatched
- `last_result` — `PASS` | `FAIL` | `PARTIAL` | `ERROR`
- `loop_iteration` — current Generator/Critic loop iteration (0 if not in loop)
- `fail_items` — array of FAIL-{N} items from reviewer (empty if PASS)
- `updated` — ISO 8601 timestamp of last update

**Write path:** `state-saver.sh` (PostToolUse hook) updates the timestamp on every file write. Phase transitions explicitly write the full state.

**Read path:** `session-reconstruct.sh` (SessionStart hook) emits pipeline state as part of session context, enabling the orchestrator to resume mid-pipeline after a crash or context rotation.

## Auto-Recall Relevance Filtering (Spec)

When the UserPromptSubmit hook injects QMD auto-recall context, it should filter by task intent to reduce noise and token waste.

**Intent extraction:** Parse the user message for task-type signals:
- "design", "plan", "what should" → intent: `design`
- "build", "create", "write", "implement" → intent: `build`
- "review", "validate", "check" → intent: `validate`
- "research", "explore", "find" → intent: `research`
- Default → intent: `general`

**QMD query:** Pass `intent` parameter to QMD query to weight results toward relevant topic files.

**Token budget adjustment:**
- Relevance score >= 0.5 → inject up to 2000 tokens of auto-recall context
- Relevance score < 0.5 → reduce injection to 1000 tokens max
- No relevant results → skip injection entirely (save tokens for the actual task)

**Implementation note:** This spec is for the UserPromptSubmit hook script (thinking-modes.sh or a dedicated auto-recall hook). The hook is outside sub-agent scope — orchestrator implements this in the main session hook configuration.

## Links

- [[AGENTS]]
- [[CHANGELOG]]
- [[CLAUDE]]
- [[DESIGN]]
- [[SEQUENCE]]
- [[VALIDATE]]
- [[agent-dispatch]]
- [[agent-system]]
- [[alpei-dsbv-process-map]]
- [[architecture]]
- [[blocker]]
- [[charter]]
- [[context-packaging]]
- [[deliverable]]
- [[design-template]]
- [[dsbv-eval-template]]
- [[dsbv-process]]
- [[filesystem-routing]]
- [[general-system]]
- [[gotchas]]
- [[iteration]]
- [[ltc-builder]]
- [[ltc-planner]]
- [[ltc-reviewer]]
- [[phase-execution-guide]]
- [[schema]]
- [[simple]]
- [[task]]
- [[version-registry]]
- [[workstream]]
