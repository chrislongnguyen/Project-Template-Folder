---
version: "1.6"
iteration: 1
iteration_name: concept
status: draft
last_updated: 2026-04-10
owner: ""
type: template
work_stream: 0-GOVERN
stage: design
sub_system: 
---
# DSBV Process — Design, Sequence, Build, Validate

> **Authority boundary:** This document is the **conceptual overview** for PM training and process context loading.
> `SKILL.md` (`.claude/skills/dsbv/SKILL.md`) is the **execution authority** — it contains the exact commands,
> loop protocols, and gate scripts that agents run. When this doc and SKILL.md conflict, SKILL.md wins.

## Overview

DSBV is the **sub-process executed WITHIN each APEI workstream** (ALIGN, PLAN, EXECUTE, IMPROVE). Every workstream runs one DSBV cycle to produce its artifacts.

**Why DSBV exists:** APEI defines WHAT each workstream does. DSBV defines HOW an AI agent + Human Director produce that workstream's output. Separating the two eliminates the confusion of recursive APEI naming.

**When to use:** Every time a workstream is activated. No workstream artifact is produced outside DSBV.

```
APEI Workstream (WHAT)          DSBV Phase (HOW)
─────────────────    ×    ─────────────────
ALIGN                     Design
PLAN                      Sequence
EXECUTE                   Build
IMPROVE                   Validate
```

Each workstream runs all 4 DSBV phases internally. The workstream determines the content; DSBV determines the workflow.

---

## How to Use

- Run `/dsbv` to start a guided DSBV cycle on any workstream
- Run `/dsbv design align` to run just the Design phase on the ALIGN workstream
- Run `/dsbv status` to see current progress across all workstreams
- Run `./scripts/dsbv-gate.sh` to manually check workstream-boundary readiness
- Skill definition: `.claude/skills/dsbv/SKILL.md` | Context template: `_genesis/templates/dsbv-context-template.md` | Evaluation template: `_genesis/templates/dsbv-eval-template.md`

---

## Phase 1: DESIGN

### Scope Check (Design Stage Preamble)

Before entering DESIGN, answer three questions:
- Q1: Are upstream workstream outputs sufficient? (Criterion 1-6 readiness check)
- Q2: What's in scope / out of scope for this workstream-iteration?
- Q3: Go/No-Go — proceed to DESIGN.md?

If any answer is NO → return to upstream workstream. Do not design on shaky inputs.

> Scope Check is a preamble **within** Design — not a 5th DSBV stage. DSBV is exactly 4 stages.

**Purpose:** Define WHAT the workstream must produce and WHY.

| Item | Detail |
|------|--------|
| **Input** | Workstream scope, prior workstream output (if any), reference materials |
| **Output** | `DESIGN.md` — structured spec for all workstream artifacts |
| **Who** | Human Director writes high-level intent; Agent expands into structured spec with sections, acceptance criteria, and artifact list |
| **Activities** | 1. Human states intent (1-3 sentences) 2. Agent drafts DESIGN.md with unified artifact-condition table 3. Agent runs alignment check (see below) 4. Human reviews, challenges, refines |
| **Pre-gate scripts** | `bash scripts/gate-precheck.sh G1 {workstream}` — verify prerequisites; `bash scripts/set-status-in-review.sh {artifact}` — mark artifact in-review |
| **Exit Gate** | Human approves DESIGN.md. Alignment check passes. No work proceeds until approved. |

**Key principle:** DESIGN.md is the contract. If it is not in DESIGN.md, it is not in scope.

### Execution Strategy (Design Stage)

Every workstream's DESIGN.md must include an Execution Strategy section that defines:

| Field | Description |
|-------|-------------|
| Pattern | Agent pattern from the 9-pattern catalog (see reference below) |
| Why this pattern | Which LTs (Limitation/Threat risks) does it compensate? |
| Why NOT simpler | What fails with single agent / sequential? |
| Agent config | How many agents, which models, roles, handoff protocol |
| Git strategy | Branches, worktrees, merge plan |
| Human gates | Which decisions pause for human approval |
| EP validation | How EPs are satisfied (see `_genesis/reference/ltc-effective-agent-principles-registry.md` for full EP-01 through EP-14 list) |
| Cost estimate | Expected token/$ spend |

**Alignment check (mandatory before G1):**
- Every completion condition maps to a named artifact (orphan conditions = 0)
- Every artifact has at least one condition (orphan artifacts = 0 or justified)
- Artifact count in DESIGN.md = deliverable count in context package Section 6
- Violated 3x in Iteration 1 ALIGN runs: OKR omission, ADR omission, DESIGN.md omission. Root cause: EP-09 (incomplete decomposition) + EP-10 (done not fully defined). Fix: unified table eliminates the gap between "what to produce" and "how to verify."

---

### Agent Pattern Catalog (9 Patterns)

Unified from Google ADK + Anthropic "Building Effective Agents":

| # | Pattern | Core Idea | Complexity |
|---|---------|-----------|------------|
| 1 | Sequential Pipeline | A → B → C. Linear chain with gates. | Low |
| 2 | Routing / Dispatcher | Classify → route to specialist. | Low |
| 3 | Parallel Fan-Out / Gather | N agents parallel → synthesizer. | Medium |
| 4 | Orchestrator-Workers | Central LLM dynamically decomposes → delegates. | Medium |
| 5 | Generator / Critic | Generate → validate → loop until pass. | Medium |
| 6 | Iterative Refinement | Generate → Critique → Refine. Multi-pass. | High |
| 7 | Autonomous Agent | LLM plans independently, tools in loops, checkpoints. | High |
| 8 | Human-in-the-Loop | Agent groundwork → human gate at high stakes. | Low |
| 9 | Composite | Mix-and-match any above. | Varies |

**Selection rule:** Start with the simplest pattern that adequately compensates for the task's LT risks.

---

## Phase 2: SEQUENCE

**Purpose:** ORDER the work — dependencies, build sequence, task sizing.

| Item | Detail |
|------|--------|
| **Input** | Approved DESIGN.md |
| **Output** | `SEQUENCE.md` — ordered task list with dependencies and acceptance criteria per task |
| **Who** | Agent drafts; Human reviews ordering and sizing |
| **Activities** | 1. Identify artifact dependencies (what must exist before what) 2. Decompose into tasks using ADaPT-style adaptive decomposition: start coarse, decompose further only on failure 3. Size each task to ≤1 hour human-equivalent (METR 80% reliability horizon) 4. Assign acceptance criteria per task |
| **Pre-gate scripts** | `bash scripts/gate-precheck.sh G2 {workstream}` — verify prerequisites; `bash scripts/set-status-in-review.sh {artifact}` — mark artifact in-review |
| **Exit Gate** | Human approves task ordering and sizing. |

**Task sizing rule:** If an agent cannot complete a task in one shot, the task is too large — decompose it, do not retry the same scope.

### Git Lifecycle per DSBV

| DSBV Stage | Git Action | Branch Pattern |
|------------|-----------|----------------|
| DESIGN | Plan branching strategy | Decided in Execution Strategy |
| SEQUENCE | Map tasks to branches | Parallel-safe → separate worktrees |
| BUILD | Create branches/worktrees | `feat/{workstream}-I{n}-{scope}` |
| VALIDATE | PR → review → merge → cleanup | Worktrees removed, branches deleted |

---

## Phase 3: BUILD

**Purpose:** EXECUTE the work following the approved sequence.

| Item | Detail |
|------|--------|
| **Input** | Approved SEQUENCE.md |
| **Output** | All workstream artifacts specified in DESIGN.md |
| **Who** | Agent(s) build; pattern depends on workstream type (see Multi-Agent Configuration below) |
| **Activities** | For each task in SEQUENCE.md: 1. Implement the artifact 2. Self-verify against task acceptance criteria 3. Checkpoint commit (`git commit`) 4. Proceed to next task. After all tasks: run Generator/Critic loop. |
| **Pre-gate scripts** | `bash scripts/gate-precheck.sh G3 {workstream}` — verify prerequisites; `bash scripts/set-status-in-review.sh {artifact}` — mark artifact in-review |
| **Exit Gate** | All tasks complete. Generator/Critic loop passes or escalated. All acceptance criteria met. |

**Design-heavy workstreams (ALIGN, PLAN):** Use Competing Hypotheses + Synthesis per ADR-001. 3-5 Sonnet agents produce complete packages in parallel; Opus synthesizes best elements; Human approves.

**Execution-heavy workstreams (EXECUTE, IMPROVE):** Single agent, sequential task completion. Output is more deterministic — diversity of approach adds less value.

### Generator/Critic Loop

After Build completes (single or multi-agent), a reviewer validates the output. If failures exist, the builder fixes them. This loop continues until all criteria pass or the maximum iteration count is reached.

**Key parameters:**

| Parameter | Value |
|-----------|-------|
| `max_iterations` | 3 (builder + reviewer = 1 iteration) |
| `exit_condition` | All criteria PASS in VALIDATE.md |
| `cost_cap` | ~$0.06 per iteration (Sonnet builder + Opus reviewer) |

**Concept:** `ltc-reviewer` dispatched → produces VALIDATE.md with PASS/FAIL items → FAIL items formatted as structured builder input → `ltc-builder` dispatched to fix FAIL items only → repeat until all PASS or `max_iterations` reached → escalate to Human Director if exhausted.

**Loop state tracking:**
```bash
bash scripts/gate-state.sh update-loop {workstream} iteration {N}
bash scripts/gate-state.sh update-loop {workstream} fail_count {N_new_fails}
```

Full loop protocol (exact pseudocode, escalation template, cost tracking): `.claude/skills/dsbv/SKILL.md` § Generator/Critic Loop.

### Circuit Breaker

Prevents infinite loops and classifies errors for intelligent retry decisions.

**Error types:**

| Type | Description | Action |
|------|-------------|--------|
| SYNTACTIC | Formatting, structure, missing field | Auto-retry (builder can fix) |
| SEMANTIC | Wrong content, misunderstood requirement | Escalate to orchestrator |
| ENVIRONMENTAL | Tool failure, file system issue | Fix environment + retry |
| SCOPE | Requirement exceeds agent capability | Escalate to human |

**Hard stops (circuit breakers):**
1. Same FAIL persists 2 iterations → ESCALATE. The builder cannot fix this issue.
2. 2 consecutive agent failures (tool errors, crashes, empty output) → STOP pipeline. Environment is likely degraded.
3. All FAIL items are SEMANTIC → ESCALATE immediately (do not retry).

**Diagnostic order** when a circuit breaker trips: EP → Input → EOP → EOE → EOT → Agent (blame the model last).

Full circuit breaker protocol: `.claude/skills/dsbv/references/circuit-breaker-protocol.md`

---

## Phase 4: VALIDATE

**Purpose:** VERIFY the workstream output enables the next workstream to start.

| Item | Detail |
|------|--------|
| **Input** | All workstream artifacts from BUILD |
| **Output** | Validation report — pass/fail per criterion |
| **Who** | Agent runs checks; Human Director makes final call |
| **Activities** | 1. **Completeness** — all artifacts listed in DESIGN.md are present 2. **Quality** — each artifact passes its success rubric 3. **Coherence** — artifacts do not contradict each other 4. **Downstream readiness** — the next workstream can start with these outputs |
| **Pre-gate scripts** | `bash scripts/gate-precheck.sh G4 {workstream}` — verify prerequisites; `bash scripts/set-status-in-review.sh {artifact}` — mark artifact in-review |
| **Exit Gate** | Human Director approves. Artifact status changes from in-review to validated (human-only action). |

**Enforcement levels:**
- L2 (current): CLAUDE.md rules — agents follow instructions but can drift
- L5 (target): Deterministic hooks — pre-commit/CI gates enforce validation automatically

---

## Structured Gate Reports

Every gate presentation (G1-G4) uses a consistent template so PMs can review at a glance.

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
- **G4 (Validate):** Include Aggregate Score from VALIDATE.md

---

## Approval Signal Detection

The DSBV orchestrator classifies every human message at an active gate (G1-G4) into one of 4 tiers. Gate-based, not word-parsing — approval only counts in the context of an active gate presentation.

**Key rule: When in doubt, ASK. There is no auto-timeout.**

| Tier | Name | Examples | Agent Action |
|------|------|---------|--------------|
| Tier 1 | Explicit Approval | "approved", "lgtm", "looks good", "ship it", "confirmed" | Advance immediately → Gate Approval Protocol |
| Tier 2 | Implicit Approval | "proceed to sequence", "go ahead", "build it", "next", "yes" (after gate question) | Emit confirmation statement → Gate Approval Protocol |
| Tier 3 | Ambiguous | "ok" (standalone), "good", "check this", "fix X then..." | Ask for clarification. Status unchanged. |
| Tier 4 | Rejection | "wait", "no", "revise", "not ready", silence | Stay in current phase. Ask for feedback. |

**Tier 2 confirmation template (statement, not question):**
```
Understood — marking {ARTIFACT} as validated (status: validated, v{X.Y}).
Advancing to {NEXT_PHASE}.
```

Full signal catalog with examples and decision flow: `.claude/skills/dsbv/SKILL.md` § Approval Signal Detection.

---

## Gate Approval Protocol

When a human approves a gate, the DSBV orchestrator executes these steps in order:

1. **Verify prerequisites** — `bash scripts/gate-precheck.sh G{N} {workstream}` (run before presenting gate; exit non-zero = do not present)
2. **Mark artifact in-review** — `bash scripts/set-status-in-review.sh {artifact_path}`
3. **Present gate template** — use Structured Gate Reports template above
4. **Detect and classify approval signal** — Tier 1/2: proceed; Tier 3: clarify; Tier 4: stay in phase
5. **Write approval record** — append to artifact's `## Approval Log`; then set `status: validated`
6. **Advance gate state + sync** — `bash scripts/gate-state.sh advance {workstream} G{N}`; run `./scripts/generate-registry.sh`

**Safety invariants:**
- NEVER set `status: validated` without a logged approval record
- NEVER advance phase without completing Steps 1-5 first
- NEVER self-approve (only Human Director sets validated)

Full protocol with approval log format and safety invariants: `.claude/skills/dsbv/SKILL.md` § Gate Approval Protocol.

---

## Multi-Agent Configuration

| Workstream Type | Pattern | Agents | Rationale |
|-----------|---------|--------|-----------|
| Design-heavy (ALIGN, PLAN) | Competing Hypotheses + Synthesis | 3-5 Sonnet (explore) + 1 Opus (synthesize) + Human (approve) | Open-ended work benefits from diverse perspectives. Missing a risk in ALIGN has high blast radius. |
| Execution-heavy (EXECUTE, IMPROVE) | Single Agent | 1 Opus or Sonnet + Human (review) | Deterministic output. Diversity adds cost, not quality. |
| Fallback (any workstream) | Single Agent (Opus) | 1 Opus + Human (review) | Use when multi-agent infra is unavailable or N=3 outputs converge (diversity is redundant). |

**Cost model:** 5 Sonnet runs (~$5-8) + 1 Opus synthesis (~$2-5) = ~$10-13 per design-heavy workstream. Single Opus = ~$3-5.

---

## Model Configuration

| Model | Cost/Run | When to Use | Example |
|-------|----------|-------------|---------|
| **Sonnet** | $0.50-1.50 | Breadth/exploration — diverse perspectives, parallel hypothesis generation | Build teams (3-5 competing agents) |
| **Opus** | $2-5 | Synthesis/judgment — combining outputs, evaluating quality, final decisions | Build synthesis + Validate phase |
| **Haiku** | $0.05-0.15 | Simple checks — status queries, readiness verification, formatting | Status checks, gate readiness |

**Default configuration:**
- **Design:** Current model (whatever the session is running)
- **Sequence:** Current model
- **Build teams:** Sonnet (cost-effective breadth)
- **Build synthesis:** Opus (quality judgment)
- **Validate:** Opus (rigorous evaluation)

**Override syntax:** `/dsbv build align --model opus --teams 3`

---

## DSBV Readiness Conditions (Criterion 1-6)

All conditions must be GREEN before starting a DSBV cycle.

| ID | Condition | Check |
|----|-----------|-------|
| Criterion 1 | **Clear scope** | Workstream identified. What is in scope and out of scope is written down. |
| Criterion 2 | **Input materials curated** | Agent reading list assembled — prior workstream output, reference docs, research. No "go find it yourself." |
| Criterion 3 | **Success rubric defined** | How to judge output quality. Per-artifact criteria, not vibes. |
| Criterion 4 | **Process definition loaded** | This document (dsbv-process.md) is in agent context. |
| Criterion 5 | **Prompt engineered** | Context package fits within effective window. Irrelevant material removed. |
| Criterion 6 | **Evaluation protocol defined** | How Opus compares competing outputs (for design-heavy). How Human reviews final output. |

**If any condition is RED:** Fix it before starting. Running DSBV without readiness produces waste.

---

## Quick Reference

```
                         DSBV FLOW
                         =========

  ┌─────────┐    G1     ┌──────────┐    G2     ┌─────────┐    G3     ┌──────────┐    G4
  │ DESIGN  │──────────▶│ SEQUENCE │──────────▶│  BUILD  │──────────▶│ VALIDATE │──────▶ DONE
  │         │  Human    │          │  Human    │         │  All AC   │          │ Human
  │ Spec    │  approves │ Task     │  approves │ Produce │  met +    │ Complete │ approves
  │ WHAT    │  DESIGN   │ ORDER    │  ordering │ HOW     │  Gen/Crit │ CHECK    │ workstream
  └─────────┘  .md      └──────────┘  + sizing └─────────┘  loop     └──────────┘ output

  G = Gate (human approval required)
  Pre-gate: gate-precheck.sh + set-status-in-review.sh run at each gate before presenting
  Gate reports: GATE: G{N} | ACs: {pass}/{total} | Action: APPROVE/REVISE/ESCALATE

  Design-heavy workstreams:  BUILD uses Competing Hypotheses + Synthesis (ADR-001)
  Execution-heavy:     BUILD uses single agent + Generator/Critic loop
```

---

## Lessons Learned

Captured from real DSBV runs. Each lesson traces to a 7-CS root cause component.

| # | Lesson | Root Cause (7-CS) | Mitigation |
|---|--------|-------------------|------------|
| 1 | Context package Section 3 (Required Artifacts) and Section 6 (Agent Deliverables) must be 1:1. In the ALIGN run, OKRs were listed as required but not included in deliverables — agents correctly produced only what was specified. | **Input** — incomplete deliverable list in prompt | Add readiness check: diff artifact list vs deliverable list before launch. If mismatch, BLOCK. |
| 2 | DESIGN.md was not produced by any Build team because it was not in the deliverables list, only implied by the process. | **Input** — assumed artifact not explicitly assigned | Every artifact in DESIGN.md must appear as a named deliverable in the context package. Implicit = missing. |
| 3 | Agents running in worktrees complicated output collection — synthesis agent had to locate and compare files across multiple directories. | **EOE** — worktree isolation created collection overhead | Automate worktree output collection: script that gathers all team outputs into a single comparison directory before synthesis. |
| 4 | Agent skipped /dsbv skill invocation and operated from degraded memory of SKILL.md. Hard Gate #4 (multi-agent prompt) was missed. User not offered single/multi-agent choice. | **Agent + EOP** — LT-2 context degradation + LT-8 rationalization. Rules are probabilistic (~80%). | Deploy `dsbv-skill-guard.sh` hook: blocks workstream artifact writes if DESIGN.md doesn't exist. Enforces OUTCOME (Design phase completed) not PROCESS (skill invoked). |
| 5 | Hook blocked legitimate writes to operational files (retros, changelogs) because no DESIGN.md existed for that workstream. | **EOE** — hook enforcement too broad | Add allowlist in hook for operational files: retrospectives, changelogs, ADRs, metrics, learning outputs, reviews. These are updated incrementally outside DSBV. |
| 6 | Lessons 1, 2, and the ADR gap in the single-agent run all share the same structural cause: DESIGN.md separates artifacts and conditions into two lists with no mapping. Conditions reference artifacts that don't exist in the deliverable list. | **EOP** — EP-09 (incomplete decomposition) + EP-10 (done not fully defined). The template structure itself caused the gap. | Unified artifact-condition table in DESIGN.md and context template. Mandatory alignment check at Gate G1: orphan conditions = 0, orphan artifacts = 0, deliverable count matches. Process fix, not outcome fix. |

> **Patterns:** Lessons 1-2 trace to Input (prompt quality). Lesson 3 traces to EOE (tooling). Lesson 4 traces to Agent+EOP (skill compliance). Lesson 5 traces to EOE (hook design). **Lesson 6 is the structural root cause of 1-2:** the template separated artifacts from conditions, violating EP-09 (decompose completely) and EP-10 (define done fully). Fix: unified table + mandatory alignment check.

---

## References

| Artifact | Path |
|----------|------|
| DSBV Skill (execution authority) | `.claude/skills/dsbv/SKILL.md` |
| Context Packaging Template | `.claude/skills/dsbv/references/context-packaging.md` |
| Circuit Breaker Protocol | `.claude/skills/dsbv/references/circuit-breaker-protocol.md` |
| Context Template | `_genesis/templates/dsbv-context-template.md` |
| Evaluation Template | `_genesis/templates/dsbv-eval-template.md` |
| Workstream-Boundary Gate | `scripts/dsbv-gate.sh` |
| Design-Phase Guard | `scripts/dsbv-skill-guard.sh` |
| Gate Prerequisite Check | `scripts/gate-precheck.sh` |
| Gate State Tracker | `scripts/gate-state.sh` |
| Set Status In-Review | `scripts/set-status-in-review.sh` |
| EP Registry (EP-01 through EP-14) | `_genesis/reference/ltc-effective-agent-principles-registry.md` |
| ALPEI-DSBV Process Map | `_genesis/frameworks/alpei-dsbv-process-map.md` |

---

**Source:** ADR-001 (Competing Hypotheses + Synthesis), DSBV Best Practices Report (2026-03-26, 42 sources)
**Governed by:** 7-CS Agent System, 8 LLM Truths, EP-01 through EP-14 (see `_genesis/reference/ltc-effective-agent-principles-registry.md`)

## Links

- [[AGENTS]]
- [[CLAUDE]]
- [[DESIGN]]
- [[EP-01]]
- [[EP-03]]
- [[EP-04]]
- [[EP-09]]
- [[EP-10]]
- [[EP-14]]
- [[SEQUENCE]]
- [[SKILL]]
- [[VALIDATE]]
- [[adr]]
- [[alpei-dsbv-process-map]]
- [[circuit-breaker-protocol]]
- [[context-packaging]]
- [[deliverable]]
- [[idea]]
- [[iteration]]
- [[ltc-effective-agent-principles-registry]]
- [[okr]]
- [[simple]]
- [[task]]
- [[workstream]]
