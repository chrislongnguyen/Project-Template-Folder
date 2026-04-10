---
version: "1.7"
status: draft
last_updated: 2026-04-09
---
# Context Packaging Template — Sub-Agent Invocation

> Every Agent() call MUST use this template. No ad-hoc prompts.
>
> **Grounding:** A sub-agent invocation is a micro-system (UT#1). This template
> maps to the 8-component model from `rules/general-system.md`:
>
> ```
> EO = f(EI, EU, EA, EP, EOE, EOT, EOP)
>         │    │   │   │   │    │    │
>         │    │   │   │   │    │    └─ Handled by: skill that spawns the agent
>         │    │   │   │   │    └───── Handled by: agent file `tools:` field
>         │    │   │   │   └──────── Handled by: agent file (model, isolation)
>         │    │   │   └─────────── This template: §3 EP
>         │    │   └────────────── Emergent — observed via §5 VERIFY
>         │    └───────────────── Handled by: agent file `model:` field
>         └────────────────────── This template: §2 INPUT
> ```
>
> The template covers what the orchestrator controls: **EO, EI, EP, and EA verification.**
> The agent file covers what the platform enforces: **EU, EOE, EOT.**

---

## The 5 Required Fields

```markdown
## 1. EO — Expected Outcome
One sentence: "[Subject] [desired state] without [constraint]."
Reference the SEQUENCE.md task ID. This is the contract — if the
output achieves this state, the task succeeds.

## 2. INPUT — What the Agent Receives
Structured context the agent needs. Three sub-sections:

### Context (EP-07: Amnesia-First)
Project identity + prior decisions the agent MUST know.
The agent has ZERO memory of prior sessions or parent context.
State only what is needed for THIS task — not project history.

### Files (EP-04: Load What You Need)
Before listing files, look up the routing table for this workstream × stage:
  grep `## Routing: {workstream}` in `_genesis/frameworks/alpei-dsbv-process-map.md`
  → Template column = required Read files for this stage
  → Deliverable Path column = Write target
Then list resolved paths explicitly (no relative paths in worktrees — see worktree rule).

Exact file paths with Read/Write labels. No "go find it yourself."
- Read: `path` — why this file is needed
- Write: `path` — what will be produced here

**Worktree rule:** When dispatching from a git worktree, ALL file paths MUST be absolute (e.g., `/full/path/.claude/worktrees/{name}/rules/agent-system.md`). Relative paths like `rules/agent-system.md` resolve to the main repo, not the worktree — sub-agent writes land in the wrong location silently.

### Budget (EP-08: Signal Over Volume)
Token/scope boundary. How much context is appropriate.
e.g., "~30K tokens. Load only the referenced files."

## 3. EP — Principles & Constraints
Which principles apply to THIS task + what the agent must NOT do.
Two sub-sections:

### Applicable EPs
List the 2-3 EPs most relevant. Don't dump all 10+.
e.g., "EP-10 (Define Done), EP-05 (Gates Before Guides)"

### Constraints
Scope boundaries, file restrictions, behavioral limits.
- Do NOT modify files outside scope
- Do NOT skip verification before completing

## 4. OUTPUT — What the Agent Produces + Acceptance Criteria
Two sub-sections:

### Deliverable
What artifact is produced, in what format, at what file path.
Who consumes it downstream (next agent or human).

**Completion report rule (ltc-builder / ltc-reviewer):** Your response IS the
completion report — the orchestrator reads your output directly. Do NOT route
or defer ("report sent to ltc-planner"). Write the report now. Format:
`DONE: <artifact-path> | ACs: <pass-count>/<total> | Blockers: <none or list>`

### Acceptance Criteria (EP-10: Define Done)
Binary tests the agent self-verifies before completing.
Every AC must return PASS/FAIL — no judgment, no "looks good."
- [ ] AC-01: {binary test}
- [ ] AC-02: {binary test}

## 5. VERIFY — EA Confirmation
How the orchestrator confirms the output is real (not hallucinated).
Deterministic checks only — file existence, grep, script exit code.
This compensates for LT-1 (hallucination) and LT-5 (plausibility ≠ truth).
```

---

## Per-Agent Examples

### ltc-builder (Build stage)

```markdown
## 1. EO
Task T1.3 produces an updated /dsbv SKILL.md that references
ltc-builder agent file for Build stage dispatch, without breaking
existing skill behavior or failing EOP-GOV validation.

## 2. INPUT

### Context
LTC Project Template — multi-agent orchestration feature.
4 MECE agents: ltc-builder (Build), ltc-reviewer (Validate),
ltc-planner (Design+Sequence), ltc-explorer (Pre-DSBV).
Skills reference agent files instead of inline definitions.

### Files
- Read: `.claude/agents/ltc-builder.md` — agent file to reference
- Read: `.claude/skills/dsbv/SKILL.md` — file to modify
- Read: `{workstream}/SEQUENCE.md` — task T1.3 acceptance criteria
- Write: `.claude/skills/dsbv/SKILL.md` — modified in place

### Budget
~15K tokens. Only the 3 files above.
max_tool_calls: 50

## 3. EP

### Applicable EPs
- EP-10 (Define Done): ACs below are the contract
- EP-05 (Gates Before Guides): agent file = deterministic enforcement

### Constraints
- Only modify `.claude/skills/dsbv/SKILL.md`
- Do NOT change existing skill triggers or behavior
- Update `version` and `last_updated` frontmatter (versioning rule)

## 4. OUTPUT

### Deliverable
Modified `.claude/skills/dsbv/SKILL.md` with agent dispatch
references in Build and Validate stage sections.
Consumed by: all users invoking `/dsbv build` or `/dsbv validate`.

### Acceptance Criteria
- [ ] `ltc-builder` referenced in Build stage section
- [ ] `ltc-reviewer` referenced in Validate stage section
- [ ] Existing skill triggers unchanged
- [ ] `skill-validator.sh` passes

## 5. VERIFY
- Grep "ltc-builder" in SKILL.md → ≥1 match
- Grep "ltc-reviewer" in SKILL.md → ≥1 match
- Run `./scripts/skill-validator.sh .claude/skills/dsbv/` → exit 0
```

### ltc-explorer (Research)

```markdown
## 1. EO
Research answers "{specific question}" with ≥3 cited sources,
without fabricating citations or exceeding the depth budget.

## 2. INPUT

### Context
{1-2 sentences: project identity + why this research is needed}

### Files
- Read: {existing research or context files, with reason}
- Search: Exa MCP for {search terms}
- Search: QMD for {project knowledge queries}

### Budget
{lite: ~20K tokens, 5 min | mid: ~50K, 15 min | deep: ~100K, 30 min}
max_tool_calls: 20

## 3. EP

### Applicable EPs
- EP-10 (Define Done): ACs below define "answered"
- EP-01 (Brake Before Gas): flag unknowns before claiming certainty

### Constraints
- Read-only — do NOT create or modify project files
- Cite every factual claim with source URL (LT-1 compensation)
- State confidence level per claim (high/medium/low)

## 4. OUTPUT

### Deliverable
Structured research findings: themes, sources, confidence, unknowns.
Consumed by: ltc-planner for synthesis or human for decision-making.

### Acceptance Criteria
- [ ] Question answered with ≥3 sources cited
- [ ] Confidence level stated per claim
- [ ] Unknowns explicitly flagged
- [ ] No unsourced factual claims

## 5. VERIFY
- Output contains "Sources:" section with ≥3 entries
- Grep for unsourced claims (sentences without [N] citation)
```

### ltc-reviewer (Validate)

```markdown
## 1. EO
VALIDATE.md confirms every DESIGN.md criterion is met with
file-path evidence, without rubber-stamping or missing criteria.

## 2. INPUT

### Context
{Workstream name} DSBV Build is complete. {N} artifacts produced.
Review against DESIGN.md success criteria.

### Files
- Read: `{workstream}/DESIGN.md` — the contract (success criteria)
- Read: {list of all produced artifacts, one per line}
- Read: `_genesis/templates/dsbv-eval-template.md` — output format

### Budget
~30K tokens. Load DESIGN.md + all artifacts.
max_tool_calls: 30

## 3. EP

### Applicable EPs
- EP-10 (Define Done): every DESIGN.md criterion = one check
- EP-01 (Brake Before Gas): FAIL items before PASS items

### Constraints
- Read-only — do NOT fix artifacts, only report findings
- Criterion count in VALIDATE.md must equal DESIGN.md count
- Evidence required for every verdict (file path + line number)

## 4. OUTPUT

### Deliverable
`{workstream}/VALIDATE.md` — per-criterion verdict table.
Consumed by: human for gate approval, ltc-builder for fixes.

### Acceptance Criteria
- [ ] VALIDATE.md criterion count = DESIGN.md criterion count
- [ ] Every verdict is PASS / FAIL / PARTIAL (no other values)
- [ ] Every verdict has file-path evidence

## 5. VERIFY
- Count criteria in VALIDATE.md = count in DESIGN.md
- Grep for verdicts without evidence column → must be 0
```

### ltc-planner (Synthesis)

```markdown
## 1. EO
Synthesis of {N} drafts produces one output stronger than any
individual draft, without losing insights from non-winning teams.

## 2. INPUT

### Context
Competing Hypotheses pattern (ADR-001). {N} ltc-builder agents
each produced a complete draft. Synthesize best elements.

### Files
- Read: {paths to all N draft files}
- Read: `{workstream}/DESIGN.md` — scoring criteria

### Budget
~40K tokens. All N drafts + DESIGN.md.
max_tool_calls: 40

## 3. EP

### Applicable EPs
- EP-03 (Two Operators): synthesis is the Opus quality gate
- EP-10 (Define Done): score per criterion, not holistic

### Constraints
- Select best element PER CRITERION, not best draft overall
- Traceability: note which draft each element came from
- Do NOT add content not present in any draft

## 4. OUTPUT

### Deliverable
Synthesized artifact with source attribution per section.
Consumed by: human for final approval.

### Acceptance Criteria
- [ ] Every DESIGN.md criterion addressed
- [ ] Source attribution for each major section
- [ ] No contradictions between combined elements

## 5. VERIFY
- Grep for "Draft" or "Team" attribution markers → ≥1 per section
- Criteria coverage count matches DESIGN.md
```

---

## Tool Call Budgets

Add `max_tool_calls` to the Budget sub-section of INPUT to prevent unbounded tool usage by sub-agents. This caps the number of tool invocations before the agent must report back, preventing runaway loops and token waste.

**Default budgets by agent:**

| Agent | Default max_tool_calls | Rationale |
|-------|----------------------|-----------|
| ltc-builder | 50 | Needs Read + Write + Edit + Grep + Bash for artifact production |
| ltc-reviewer | 30 | Needs Read + Glob + Grep + Bash for evidence gathering |
| ltc-explorer | 20 | Read-only exploration; should be focused and fast |
| ltc-planner | 40 | Read + design synthesis; moderate tool usage |

**Budget field with max_tool_calls:**
```markdown
### Budget
~30K tokens. Only the referenced files.
max_tool_calls: 50
```

**Enforcement:** Agent should self-track tool call count. If approaching the budget limit (80%), prioritize remaining work and report partial completion rather than exceeding the budget silently.

**Override:** Orchestrator may set a custom budget per dispatch when the task is known to be tool-heavy (e.g., large multi-file edits) or tool-light (e.g., single file review).

## EP Task-Type Filtering

Not all EPs apply to every task. Dumping all 10+ EPs into a context package wastes tokens and dilutes focus (EP-04: Signal Over Volume). Map task type to the 2-3 most relevant EPs.

**EP-to-task-type mapping:**

| Task Type | Applicable EPs | Why These |
|-----------|---------------|-----------|
| Research | EP-01 (Brake Before Gas), EP-04 (Signal Over Volume), EP-08 (Economy) | Research needs caution (EP-01), focused scope (EP-04), token efficiency (EP-08) |
| Design | EP-01 (Brake Before Gas), EP-05 (Gates Before Guides), EP-09 (Decompose), EP-10 (Define Done) | Design needs caution (EP-01), deterministic gates (EP-05), decomposition (EP-09), testable criteria (EP-10) |
| Build | EP-01 (Brake Before Gas), EP-05 (Gates Before Guides), EP-10 (Define Done), EP-14 (Script-First) | Build needs stop-on-block (EP-01), routing boundaries (EP-05), AC verification (EP-10), script validation (EP-14) |
| Validate | EP-01 (Brake Before Gas), EP-10 (Define Done), EP-12 (Evidence-Based) | Validate needs caution (EP-01), criterion matching (EP-10), file-path evidence (EP-12) |

**Usage in context package:**
```markdown
## 3. EP — Principles & Constraints

### Applicable EPs
Task type: Build
- EP-10 (Define Done): ACs below are the contract
- EP-05 (Gates Before Guides): routing boundaries enforced
- EP-14 (Script-First): run validation scripts, don't rely on judgment
(Filtered per EP task-type mapping — see context-packaging.md)
```

**Rule:** Include at most 4 EPs per context package. If you need more, the task is likely too broad and should be decomposed (EP-09).

## Anti-Patterns → EP Violations

| Anti-Pattern | EP Violated | What Goes Wrong | Fix |
|-------------|-------------|-----------------|-----|
| "Just do the thing" | EP-10 (no EO) | Agent hallucinates scope | Define EO in one sentence |
| "Here are some files" | EP-07 (no context) | Agent assumes wrong project state | Structure INPUT with Context + Files + Budget |
| No constraints | EP-05 (no gates) | Agent modifies files outside scope | State EP + Constraints explicitly |
| "Make it good" | EP-10 (no ACs) | Agent declares done without evidence | Binary ACs in OUTPUT section |
| Trust the output | LT-1 (hallucination) | Agent claims file exists but didn't create it | VERIFY with deterministic checks |
| Dump all EPs | EP-04 (overload) | Agent drowns in principles, follows none well | List only 2-3 applicable EPs |
| Name-drop references | EP-07 (amnesia) | Agent hasn't seen "AMT Session 3" | Load actual content, not names |
| Use domain terms without definitions | LT-1 (hallucination) | Agent invents plausible names (e.g., "Entry Policy" instead of "Effective Principles") | Include canonical term list in INPUT when output must use exact terminology |
| Relative paths in worktrees | LT-1 (path resolution) | Sub-agent resolves `_genesis/` or `rules/` to main repo, not worktree — writes land in wrong location | Always pass **absolute worktree path** in INPUT Context field: `Working directory: /full/path/to/.claude/worktrees/{name}` |

## Links

- [[ADR-001]]
- [[AGENTS]]
- [[CLAUDE]]
- [[DESIGN]]
- [[EP-01]]
- [[EP-03]]
- [[EP-04]]
- [[EP-05]]
- [[EP-07]]
- [[EP-08]]
- [[EP-09]]
- [[EP-10]]
- [[EP-12]]
- [[EP-14]]
- [[SEQUENCE]]
- [[SKILL]]
- [[VALIDATE]]
- [[agent-system]]
- [[alpei-dsbv-process-map]]
- [[anti-patterns]]
- [[deliverable]]
- [[dsbv-eval-template]]
- [[general-system]]
- [[ltc-builder]]
- [[ltc-explorer]]
- [[ltc-planner]]
- [[ltc-reviewer]]
- [[project]]
- [[task]]
- [[versioning]]
- [[workstream]]
