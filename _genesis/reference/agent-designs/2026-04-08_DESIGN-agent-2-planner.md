---
version: "1.0"
status: draft
last_updated: 2026-04-08
type: design-spec
work_stream: 0-GOVERN
iteration: 1
agent: planner
title: "DESIGN: Agent 2 — ltc-planner (Architect)"
---

# DESIGN: Agent 2 — ltc-planner (Architect)

> **Purpose:** Complete 8-component system design for ltc-planner — the Architect agent that owns DSBV stage 1 (Design) and Stage 2 (Sequence). Defines what to build and in what order.
>
> **Parent document:** `inbox/2026-04-08_agent-system-8component-design.md` (pipeline-level design)
> **Agent file:** `.claude/agents/ltc-planner.md` (v1.4, 2026-04-06)
> **Governing equation:** Success = Efficient & Scalable Management of Failure Risks (UT#5)
> **Evaluation criteria:** Sustainability > Efficiency > Scalability (DT#1)

---

## CRITICAL: EP-13 Contradiction

**This is the highest-priority finding in this document.**

The current ltc-planner agent file (v1.4) contains the following claim under EP-13:

```
You are the declared orchestrator for DSBV flow. You MAY dispatch ltc-builder,
ltc-reviewer, and ltc-explorer as part of DSBV orchestration — this is the authorized pattern.
```

**This is FALSE.** ltc-planner has no `Agent()` tool. It cannot dispatch anyone. The claim:

1. **Violates EP-13 itself** — "Exactly one orchestrator owns decomposition and synthesis." The orchestrator is the main session (Agent 0), not a sub-agent. Two entities claiming orchestrator authority violates RACI (UT#9: exactly one A).
2. **Violates the tool whitelist** — Agent tools are `Read, Grep, WebFetch, mcp__exa__web_search_exa, mcp__qmd__query`. No `Agent()`. The claim is structurally impossible.
3. **Creates confusion** — If planner believes it can dispatch, it will attempt to do so, fail silently, and produce output that assumes dispatched agents completed work that never happened.

**Correction required in ltc-planner.md EP-13 section:**

```
### EP-13: Orchestrator Authority

NEVER call the Agent() tool. You are a leaf node in the agent hierarchy.
Reason: ltc-planner is Responsible (R) for DESIGN.md and SEQUENCE.md content.
Accountable (A) is the Human Director. The main session is the orchestrator —
it dispatches you, receives your output, writes it to disk, and dispatches
downstream agents (builder, reviewer). You advise; you do not command.
```

**Impact:** Until fixed, every planner invocation operates under a false self-model. The agent believes it has authority it does not possess. This is a category error in EP (Effective Principles) — the foundational component.

---

## Dispatch Modes

Planner is NOT limited to the DSBV chain. It operates in multiple modes:

| Mode | Trigger | EI Source | EO Destination | Context Weight |
|------|---------|-----------|----------------|----------------|
| **DSBV Design** | `/dsbv design [workstream]` | Orchestrator (5-field package + charter + research) | Orchestrator → writes DESIGN.md | Full |
| **DSBV Sequence** | `/dsbv sequence [workstream]` | Orchestrator (5-field + approved DESIGN.md) | Orchestrator → writes SEQUENCE.md | Full |
| **Synthesis** | Multi-agent build complete | Orchestrator (N builder drafts + DESIGN.md criteria) | Orchestrator → writes synthesized artifact | Full |
| **Ad-hoc architecture** | "Design a system for X" or "How should we structure Y?" | Orchestrator (lighter: question + constraints) | Main session directly | Medium |
| **Brainstorming** | `/ltc-brainstorming` diverge→converge | Brainstorming skill | Main session (synthesis stage) | Light |

**Key insight:** In ad-hoc mode, planner returns architectural recommendations directly to main session — no DESIGN.md written, no downstream builder handoff. The formal handoff contracts apply ONLY in DSBV chain mode.

---

## Pipeline Position

```
                 ┌─────────────────── DSBV Pipeline ───────────────────┐
                 │                                                      │
  Human  ──EI──→ Explorer ──EO/EI──→ [PLANNER] ──EO/EI──→  Builder  ──EO/EI──→  Reviewer  ──EO──→  Human
  Director       (haiku)             ★ (opus) ★            (sonnet)              (opus)             Director
                 Research            Design+Seq            Artifacts             VALIDATE.md
                 │                   │                     │                      │
                 └─ Pre-DSBV         └─ Stage 1+2          └─ Stage 3             └─ Stage 4
```

**Role:** Architect — receives research (Explorer EO), produces the construction blueprint (DESIGN.md) and work plan (SEQUENCE.md). Does NOT execute (Builder) or verify (Reviewer). Does NOT orchestrate (Main Session).

---

## 1. EI — Effective Input

### Current State

| Input Source | Content | Delivery Method |
|---|---|---|
| Explorer EO | Research findings: themed results, source citations, confidence levels, flagged unknowns | Context-packaged by orchestrator into planner's prompt |
| Charter | `1-ALIGN/charter/` — project EO, stakeholders, success criteria, scope | Read tool (planner loads directly) |
| Prior decisions | `1-ALIGN/decisions/` — ADRs, rationale | Read tool |
| DSBV process doc | `_genesis/templates/dsbv-process.md` — stage definitions, gate criteria | Read tool |
| Reference specs | Workstream-specific docs, framework files from `_genesis/` | Read tool |
| Design template | `_genesis/templates/design-template.md` — DESIGN.md structure | Read tool |

### Gap Analysis

| # | Gap | Impact | Category |
|---|-----|--------|----------|
| GAP-EI-1 | Explorer output has no formal schema — structure varies per invocation | Planner must parse unstructured text, may miss unknowns that were buried in prose | Technical |
| GAP-EI-2 | No file-existence verification — planner cannot confirm input files exist before reading | Read failures mid-design disrupt flow; planner has no Glob to pre-check | Technical |
| GAP-EI-3 | Context budget not enforced — orchestrator may overload planner with reference docs | Opus 1M context is large but attention degrades with volume (LT-2, LT-4) | Temporal |

### S x E x Sc

| Pillar | Score | Evidence |
|--------|-------|----------|
| Sustainability | 7/10 | Context packaging protocol provides structured input. But: no schema enforcement on Explorer EO. Planner trusts what it receives (EP-12 gap) |
| Efficiency | 6/10 | Planner loads files directly via Read — efficient. But: no Glob means blind reads (may fail). No budget enforcement means potential overload |
| Scalability | 7/10 | Input sources are well-defined. Scales to new workstreams without redesign. But: context-packaged prompt is per-invocation, not cached |

### UBS / UDS

| Type | ID | Description | Category | Impact |
|------|-----|-------------|----------|--------|
| UBS | UBS-EI-1 | No Explorer output schema — planner parses unstructured text | Technical | Medium |
| UBS | UBS-EI-2 | No Glob tool — cannot verify input files exist before Read | Technical | Low |
| UDS | UDS-EI-1 | Context packaging protocol structures the handoff (5-field template) | Technical | High |
| UDS | UDS-EI-2 | Opus 1M context window accommodates large design inputs | Technical | Medium |

---

## 2. EU — Effective User

### Current State

| Attribute | Value |
|---|---|
| Model | Claude Opus 4.6 (1M context) |
| RACI | **R** — Responsible for DESIGN.md and SEQUENCE.md content |
| | **C** — Consulted by orchestrator on design decisions |
| | **A** = Human Director (never the planner) |
| Tier | Highest reasoning. Most expensive per token |
| Leaf node | Yes — cannot dispatch further agents |

### Why Opus?

Design is the highest-stakes stage in DSBV. Architectural decisions compound — a wrong design produces wrong sequences, wrong builds, and wrong validations. The cost of an Opus invocation for design (~$2-5/session) is trivial compared to the cost of rebuilding from a flawed design (~$20-50 in wasted builder/reviewer cycles).

**LT compensation:**
- LT-3 (complex task decomposition) — Opus handles multi-constraint design best
- LT-5 (plausible but wrong) — Opus has lowest plausibility-without-truth rate
- LT-1 (hallucination) — Still present; mitigated by EP-12 (verified handoff from explorer)

### Gap Analysis

No gaps. Model selection is correct for the role.

### S x E x Sc

| Pillar | Score | Evidence |
|--------|-------|----------|
| Sustainability | 9/10 | Opus quality prevents cascade of design errors downstream |
| Efficiency | 6/10 | Most expensive model, but justified by stakes. Overspend risk if invoked for trivial tasks |
| Scalability | 5/10 | Single planner per design. Cannot parallel-dispatch planners (designs are inherently sequential) |

### UBS / UDS

| Type | ID | Description | Category | Impact |
|------|-----|-------------|----------|--------|
| UBS | UBS-EU-1 | Opus cost makes it expensive for trivial planning tasks (e.g., simple SEQUENCE.md edits) | Economic | Low |
| UDS | UDS-EU-1 | Highest reasoning tier prevents cascading design errors | Technical | High |
| UDS | UDS-EU-2 | 1M context window handles full charter + research + references simultaneously | Technical | Medium |

---

## 3. EA — Effective Action

### Current State

The planner performs 4 distinct actions:

**Action 1: Draft DESIGN.md**
```
Inputs: charter + research + reference specs
Process:
  1. Identify all artifacts the workstream must produce
  2. Define binary acceptance criteria per artifact
  3. Define success rubrics (testable, not vibes)
  4. Run alignment check: every condition ↔ artifact (zero orphans)
  5. Define out-of-scope explicitly
Output: DESIGN.md content (text, returned to orchestrator)
```

**Action 2: Draft SEQUENCE.md**
```
Inputs: DESIGN.md (approved at G1) + workstream constraints
Process:
  1. Map artifact dependencies (DAG)
  2. Order tasks by dependency, then by S > E > Sc priority
  3. Size each task (≤1hr human-equivalent)
  4. Assign Read/Write labels to file paths per task
  5. Define VERIFY checks per task (deterministic where possible)
Output: SEQUENCE.md content (text, returned to orchestrator)
```

**Action 3: Synthesis (Multi-Agent Build Output)**
```
Inputs: N builder drafts + their self-assessment tables
Process:
  1. Score per criterion per draft (not holistic "which is better")
  2. Select best element per criterion (not best draft overall)
  3. Resolve conflicts between selected elements
  4. Produce synthesis with per-section attribution
Output: Synthesized artifact with traceability
```

**Action 4: Learn Pipeline Orchestration**
```
Inputs: Learning topic + research scope
Process:
  1. Map 6-state pipeline: Input → Research → Specs → Output → Archive
  2. Stage transitions (NOT DSBV — LEARN uses its own pipeline)
Output: Pipeline stage recommendations (advisory)
```

### Gap Analysis

| # | Gap | Impact | Category |
|---|-----|--------|----------|
| GAP-EA-1 | **EP-13 contradiction — planner believes it can dispatch agents** | Planner may attempt orchestration actions it cannot perform, producing confused output | Technical (CRITICAL) |
| GAP-EA-2 | No structured output format — DESIGN.md content returned as freeform text | Orchestrator must parse and extract, introducing LT-2 (lossy handoff) risk | Technical |
| GAP-EA-3 | Alignment check is advisory (agent judgment) — not scriptable | Planner may skip or perform shallow alignment check under context pressure | Human |
| GAP-EA-4 | Synthesis requires loading ALL N drafts into context simultaneously | Expensive for large N. 1M context helps but attention still degrades at scale | Temporal |

### S x E x Sc

| Pillar | Score | Evidence |
|--------|-------|----------|
| Sustainability | 5/10 | EP-13 contradiction actively degrades reliability. Alignment check prevents orphan criteria but is advisory only. Synthesis protocol is rigorous |
| Efficiency | 5/10 | Returns text → orchestrator parses → orchestrator writes = double token cost for handoff. No structured output contract |
| Scalability | 4/10 | Single planner bottleneck. Synthesis loads all N drafts (memory pressure). Cannot parallelize design (inherently sequential) |

### UBS / UDS

| Type | ID | Description | Category | Impact |
|------|-----|-------------|----------|--------|
| UBS | UBS-EA-1 | EP-13 false claim — planner believes it orchestrates (CRITICAL) | Technical | High |
| UBS | UBS-EA-2 | Freeform text output — orchestrator must parse and extract | Technical | Medium |
| UBS | UBS-EA-3 | Alignment check is advisory, not deterministic | Human | Medium |
| UBS | UBS-EA-4 | Synthesis requires all N drafts in context simultaneously | Temporal | Low |
| UDS | UDS-EA-1 | 4 well-defined action types with clear input/output specs | Technical | High |
| UDS | UDS-EA-2 | Alignment check (condition-artifact mapping) prevents orphans | Technical | High |
| UDS | UDS-EA-3 | Per-criterion scoring in synthesis prevents "best overall" bias | Technical | Medium |

---

## 4. EO — Effective Output

### Current State

| Output | Consumer | Delivery | Format |
|---|---|---|---|
| DESIGN.md content | Orchestrator (main session) | Returned as text in agent response | Markdown (freeform) |
| SEQUENCE.md content | Orchestrator (main session) | Returned as text in agent response | Markdown (freeform) |
| Synthesis output | Orchestrator (main session) | Returned as text in agent response | Markdown with per-section attribution |
| Pipeline recommendations | Orchestrator (main session) | Returned as text | Advisory prose |

**Critical constraint:** Planner has no Write/Edit tools. All output is text returned to the orchestrator. The orchestrator is responsible for:
1. Presenting to Human Director for approval (G1/G2 gate)
2. Writing to disk (if approved)
3. Dispatching downstream agents (builder)

### Gap Analysis

| # | Gap | Impact | Category |
|---|-----|--------|----------|
| GAP-EO-1 | No Write tool — 2-step handoff (planner returns text → orchestrator writes) is lossy (LT-2) | Content may be truncated, reformatted, or silently modified during extraction | Technical |
| GAP-EO-2 | No output schema — structure varies per invocation | Orchestrator must visually inspect to know where DESIGN.md content starts/ends | Technical |
| GAP-EO-3 | No completion report standard — unlike builder's `DONE:` format | Orchestrator cannot programmatically determine if planner succeeded | Technical |

### Proposed: Typed Output Contract

```
PLANNER OUTPUT CONTRACT:

For DESIGN.md:
  --- BEGIN DESIGN.md ---
  [full DESIGN.md content with YAML frontmatter]
  --- END DESIGN.md ---
  STATUS: complete | partial
  ALIGNMENT_CHECK: <conditions_mapped>/<total_conditions> | zero orphans: yes/no
  BLOCKERS: none | <list>

For SEQUENCE.md:
  --- BEGIN SEQUENCE.md ---
  [full SEQUENCE.md content with YAML frontmatter]
  --- END SEQUENCE.md ---
  STATUS: complete | partial
  TASK_COUNT: N
  MAX_TASK_SIZE: ≤1hr | OVER (list violations)
  BLOCKERS: none | <list>

For Synthesis:
  --- BEGIN SYNTHESIS ---
  [synthesized content with per-section attribution]
  --- END SYNTHESIS ---
  DRAFT_SCORES: [per-criterion table]
  ATTRIBUTION: [per-section: "from Draft N"]
  CONFLICTS: none | <list with resolution rationale>
```

### S x E x Sc

| Pillar | Score | Evidence |
|--------|-------|----------|
| Sustainability | 5/10 | 2-step handoff is fragile. No schema means silent degradation. But: human gate between planner output and disk write adds safety |
| Efficiency | 4/10 | Double token cost: planner generates full content, orchestrator re-processes to extract and write. No caching |
| Scalability | 5/10 | Same pattern works for any workstream (scales horizontally). But: text-based handoff doesn't scale with artifact size |

### UBS / UDS

| Type | ID | Description | Category | Impact |
|------|-----|-------------|----------|--------|
| UBS | UBS-EO-1 | No Write tool — 2-step handoff loses content (LT-2) | Technical | High |
| UBS | UBS-EO-2 | No output schema — orchestrator parses freeform text | Technical | Medium |
| UBS | UBS-EO-3 | No completion report format for planner | Technical | Low |
| UDS | UDS-EO-1 | Human gate between output and disk write — prevents bad designs from landing | Human | High |
| UDS | UDS-EO-2 | Text-based output is model-portable (works with any orchestrator) | Technical | Low |

### Write/Edit Tool Question

**Should planner get Write/Edit tools to directly produce DESIGN.md/SEQUENCE.md?**

| Option | Sustainability | Efficiency | Scalability | Verdict |
|--------|---------------|------------|-------------|---------|
| A: No Write (current) | HIGH — human gate prevents bad writes | LOW — double token cost, lossy handoff | MEDIUM — text-based, portable | Status quo |
| B: Add Write/Edit | MEDIUM — removes human gate (planner writes directly) | HIGH — single-step, no handoff loss | MEDIUM — same | Risky |
| C: Add Write but require G1/G2 BEFORE writing | HIGH — gate preserved, write is post-approval | HIGH — single-step after approval | MEDIUM — same | **Recommended** |

**Recommendation: Option C.** Add Write/Edit to planner's tool whitelist, but update the EOP to require: (1) planner returns DESIGN.md content as text, (2) orchestrator presents to human at G1/G2, (3) on approval, orchestrator re-invokes planner with "write approved content to disk" instruction. This preserves the human gate while eliminating the lossy extraction step.

**Trade-off acknowledged:** Option C adds one extra planner invocation (content generation + disk write = 2 calls instead of 1). Token cost increase is ~10-15%. But it eliminates the LT-2 handoff loss, which is the higher risk.

**Deferred decision.** This requires Human Director approval (changes tool whitelist = MEDIUM risk). Flagged for discussion.

---

## 5. EP — Effective Principles

### Current State

| EP | Statement | How Planner Applies It |
|---|---|---|
| EP-03 | Two Operators, One System | Planner advises (R); Human decides (A). Planner never self-approves designs |
| EP-05 | Gates Before Guides | G1 (Design approval) and G2 (Sequence approval) are human gates. Planner presents, does not bypass |
| EP-09 | Decompose Before Delegate | SEQUENCE.md breaks work into <=1hr tasks. Planner decomposes before orchestrator delegates to builder |
| EP-10 | Define Done | Every artifact in DESIGN.md has binary ACs. Every task in SEQUENCE.md has a VERIFY check |
| EP-12 | Verified Handoff | Planner must verify Explorer citations before treating as ground truth |
| EP-13 | Orchestrator Authority | **CURRENTLY WRONG.** Claims planner is orchestrator. Must be corrected to: planner is leaf node, main session orchestrates |

### EP-13 Correction (Restated)

The following text MUST replace the current EP-13 section in `ltc-planner.md`:

```markdown
### EP-13: Orchestrator Authority

NEVER call the Agent() tool. You are a leaf node in the agent hierarchy.
Reason: ltc-planner is Responsible (R) for DESIGN.md and SEQUENCE.md content.
Accountable (A) is the Human Director. The main session is the orchestrator —
it dispatches you, receives your output, writes it to disk, and dispatches
downstream agents (builder, reviewer). You advise; you do not command.

If you need research to complete a design, STOP and report to the orchestrator:
"BLOCKED: Need research on [topic]. Request ltc-explorer dispatch."
The orchestrator will dispatch the explorer and return findings to you.
```

**Files requiring EP-13 correction:**
- `.claude/agents/ltc-planner.md` — lines 65-71 (the "You MAY dispatch" claim)
- Agent file "Scope Boundary" — line 20 "Orchestrate DSBV flow transitions" should become "Advise on DSBV flow transitions"
- Agent file "Scope Boundary" — line 23 "Orchestrate learn pipeline stages" should become "Advise on learn pipeline stages"
- Agent file description (frontmatter line 5) — remove "orchestrating DSBV flow"

### Gap Analysis

| # | Gap | Impact | Category |
|---|-----|--------|----------|
| GAP-EP-1 | EP-13 false claim — planner believes it is the orchestrator (CRITICAL) | Every invocation operates under a false self-model | Technical |
| GAP-EP-2 | EP-12 not enforced — planner has no mechanism to verify Explorer citations | Research hallucinations (LT-1) pass through unchecked | Technical |
| GAP-EP-3 | EP-14 (Script-First) not applied — alignment check could be partially scriptable | Agent burns tokens on deterministic checks (e.g., "does every AC reference an artifact?") | Technical |

### S x E x Sc

| Pillar | Score | Evidence |
|--------|-------|----------|
| Sustainability | 4/10 | EP-13 contradiction is a foundational error. Principles are well-chosen but one is actively wrong. EP-12 enforcement gap allows hallucinated research to pass through |
| Efficiency | 7/10 | EP-09 and EP-10 produce well-decomposed, well-defined output. EP-04 keeps context lean |
| Scalability | 8/10 | Principles are workstream-agnostic — apply to any DESIGN.md/SEQUENCE.md regardless of domain |

### UBS / UDS

| Type | ID | Description | Category | Impact |
|------|-----|-------------|----------|--------|
| UBS | UBS-EP-1 | EP-13 claims orchestrator authority (CRITICAL) | Technical | High |
| UBS | UBS-EP-2 | EP-12 not enforced — no citation verification mechanism | Technical | Medium |
| UBS | UBS-EP-3 | EP-14 not applied — alignment check should be partially scripted | Technical | Low |
| UDS | UDS-EP-1 | EP-09 + EP-10 produce well-structured, verifiable output | Technical | High |
| UDS | UDS-EP-2 | EP-05 gates (G1, G2) prevent bad designs from reaching builder | Human | High |

---

## 6. EOE — Effective Operating Environment (DEGRADED)

This section documents the planner's actual operating environment as a sub-agent. Sub-agents in Claude Code operate in a **degraded environment** compared to the main session. Every layer must be evaluated for what is present, what is absent, and what is different.

### Layer 1 — Platform

| Attribute | Value |
|---|---|
| Runtime | Claude Code CLI |
| OS | macOS (Darwin) |
| Shell | zsh |
| Invocation | `Agent()` call from main session |
| Lifecycle | Created per-invocation. No persistence between dispatches |

**Constraint:** Planner has no awareness of prior invocations. Every dispatch is a fresh context. If planner was invoked yesterday to draft DESIGN.md, today's invocation to draft SEQUENCE.md has zero memory of yesterday's design session (LT-6).

### Layer 2 — Permissions

| Permission | Status | Enforcement |
|---|---|---|
| `settings.json` deny/allow lists | ENFORCED at platform level | Claude Code applies tool restrictions before agent sees them |
| Tool whitelist | `Read, Grep, WebFetch, mcp__exa, mcp__qmd` | Planner cannot invoke tools outside this list |
| Write access | DENIED | No Write, Edit, or Bash tools |
| Agent dispatch | DENIED | No Agent() tool |
| File system | READ-ONLY | Can Read files, cannot modify |

**Note:** `settings.json` permissions are the ONLY deterministic enforcement layer that works in sub-agents. This is the most reliable defense.

### Layer 3 — Hooks

| Hook | Fires in Sub-Agent? | Relevance to Planner |
|---|---|---|
| PreToolUse | NO | Irrelevant — planner uses only Read/Grep (low-risk) |
| PostToolUse | NO | Irrelevant |
| SubagentStop | YES (fires when planner completes) | `verify-deliverables.sh` runs to check planner output |
| SessionStart | NO | Planner does not get session-start context injection |
| UserPromptSubmit | NO | Planner does not receive standing-context injection |
| FileChanged | NO | Planner cannot change files |

**Critical gap:** PreToolUse hooks that enforce naming, versioning, and routing rules DO NOT fire inside the planner. This is a Claude Code SDK limitation (GitHub issue #40580). The planner relies entirely on:
1. Its agent file text (EP — probabilistic, ~85-95% reliable)
2. `settings.json` tool restrictions (EOE — deterministic)
3. SubagentStop verification (EOT — deterministic but post-hoc)

### Layer 4 — Context

| Attribute | Value |
|---|---|
| Context window | 1M tokens (Opus) |
| Auto-recall (QMD) | NOT available — QMD injection is a main-session hook, does not fire in sub-agents |
| Memory vault | NOT available — `~/.claude/projects/*/memory/` not auto-loaded |
| CLAUDE.md | Loaded by Claude Code platform (confirmed) |
| .claude/rules/ | **UNCLEAR** — sub-agent rule loading is not documented. Assumed loaded but unverified |
| Conversation history | NONE — planner sees only the current dispatch prompt |

**Gap:** Planner cannot access project memory or prior session context. The orchestrator must include all relevant context in the dispatch prompt. If the orchestrator forgets to include a critical reference, the planner operates without it — there is no fallback.

### Layer 5 — Agent Coordination

| Attribute | Current | Correct |
|---|---|---|
| Self-model | "Declared orchestrator for DSBV flow" | Leaf node — returns content to main session |
| Dispatch capability | Claims MAY dispatch agents | CANNOT dispatch — no Agent() tool |
| Coordination pattern | Supervisor (claimed) | Worker/Specialist (actual) |
| Communication | Returns text to orchestrator | Correct — this is the only option |

**This layer contains the EP-13 contradiction.** The planner's self-model (Layer 5) does not match its actual capabilities (Layer 2 permissions, Layer 7 tools). When self-model and reality diverge, the agent produces outputs that assume capabilities it does not have. This is a category of failure unique to LLM agents — the agent cannot introspect its own tool list at runtime.

### Layer 6 — Rules

| Rule Source | Loaded? | Evidence |
|---|---|---|
| Agent file (`.claude/agents/ltc-planner.md`) | YES | Loaded as agent identity prompt |
| CLAUDE.md (project root) | YES | Claude Code platform loads this for all sessions |
| `.claude/rules/*.md` (always-on rules) | UNVERIFIED | Sub-agent rule loading is undocumented. Likely loaded by platform but not confirmed |
| `_genesis/` frameworks | NO (unless Read explicitly) | Must be loaded via Read tool if needed |

**Gap:** If `.claude/rules/` files are NOT loaded in sub-agents, the planner misses: versioning rules, naming rules, filesystem routing, ALPEI chain-of-custody, git conventions. These are critical for producing correct DESIGN.md content. Testing needed.

### Layer 7 — MCP Servers

| Server | Available | Used For |
|---|---|---|
| mcp__exa__web_search_exa | YES | External web search for design context |
| mcp__qmd__query | YES | Local markdown knowledge base search |
| WebFetch | YES | Retrieve specific URLs |
| Notion MCP | NO | Cannot update WMS task status |
| ClickUp MCP | NO | Cannot update secondary WMS |
| Playwright | NO | Cannot verify web artifacts |

**Gap:** Planner cannot update WMS to mark design tasks as in-progress or complete. The orchestrator must handle WMS updates.

### Layer 8 — Filesystem Access

| Capability | Status |
|---|---|
| Read files | YES (Read tool) |
| Search file contents | YES (Grep tool) |
| Discover files by pattern | NO (no Glob tool) |
| Verify file existence | NO (must attempt Read and handle error) |
| Write files | NO |
| Edit files | NO |
| Run scripts | NO (no Bash tool) |

**Gap:** No Glob tool means the planner cannot:
- Discover what files exist in a workstream directory
- Verify that referenced file paths in DESIGN.md/SEQUENCE.md actually exist
- Find existing DESIGN.md files to check for conflicts
- Survey the codebase structure before designing

The planner must rely on the orchestrator to provide file listings in the dispatch prompt, or attempt Read calls and infer from errors.

### EOE Summary Table

```
Layer  Component                Status    Enforcement Level
─────  ─────────────────────    ────────  ──────────────────────────────────
  1    Platform (Claude Code)   OK        Deterministic (platform)
  2    Permissions (settings)   OK        Deterministic (platform)
  3    Hooks                    DEGRADED  Only SubagentStop fires
  4    Context                  DEGRADED  No auto-recall, no memory, no history
  5    Agent Coordination       BROKEN    EP-13 false self-model
  6    Rules                    UNKNOWN   .claude/rules/ loading unverified
  7    MCP Servers              PARTIAL   3/6+ servers available, no WMS
  8    Filesystem               DEGRADED  Read-only, no discovery (no Glob)
```

### S x E x Sc

| Pillar | Score | Evidence |
|--------|-------|----------|
| Sustainability | 4/10 | Layer 5 (EP-13) is broken. Layer 3 (hooks) degraded. Layer 6 (rules) unverified. Three degraded layers compound — planner operates with incomplete guardrails |
| Efficiency | 5/10 | Layer 4 (no auto-recall) means orchestrator must manually package all context. Layer 8 (no Glob) means blind file references. Extra round-trips when files don't exist |
| Scalability | 6/10 | Layers 1, 2, 7 are stable and workstream-agnostic. Degraded layers don't worsen with scale — they're consistently degraded |

### UBS / UDS

| Type | ID | Description | Category | Impact |
|------|-----|-------------|----------|--------|
| UBS | UBS-EOE-1 | Layer 5: EP-13 false self-model (CRITICAL) | Technical | High |
| UBS | UBS-EOE-2 | Layer 3: PreToolUse hooks don't fire — no runtime enforcement | Technical | Medium |
| UBS | UBS-EOE-3 | Layer 6: .claude/rules/ loading unverified in sub-agents | Technical | Medium |
| UBS | UBS-EOE-4 | Layer 4: No auto-recall, no memory — cold start every dispatch | Technical | Medium |
| UBS | UBS-EOE-5 | Layer 8: No Glob — cannot discover or verify file existence | Technical | Low |
| UDS | UDS-EOE-1 | Layer 2: settings.json permissions are deterministic — strongest enforcement | Technical | High |
| UDS | UDS-EOE-2 | Layer 1: Opus 1M context compensates for cold-start by accepting large prompts | Technical | Medium |
| UDS | UDS-EOE-3 | Layer 3: SubagentStop fires — post-hoc verification works | Technical | Medium |

---

## 7. EOT — Effective Operating Tools

### Current Tool Inventory

| # | Tool | Type | Purpose | Frequency |
|---|------|------|---------|-----------|
| 1 | Read | File I/O | Load specific files by known path | High — every invocation |
| 2 | Grep | Search | Search file contents by regex pattern | Medium — validation, discovery |
| 3 | WebFetch | Network | Retrieve specific URLs verbatim | Low — when URL is known |
| 4 | mcp__exa__web_search_exa | MCP | External web search (open-ended) | Low — design context |
| 5 | mcp__qmd__query | MCP | Local markdown knowledge base (sessions, decisions, daily logs) | Medium — prior decisions |

**Total: 5 tools.** All read-only or search-only. Zero write capability. Zero dispatch capability.

### Tool Gap Analysis

| Missing Tool | Impact | Should Add? | Rationale |
|---|---|---|---|
| **Glob** | Cannot discover files by pattern. Must know exact paths or use Grep workarounds | YES (Low risk) | Read-only tool. No write capability. Enables file existence verification and directory surveys. Zero security risk |
| **Write/Edit** | Cannot write DESIGN.md/SEQUENCE.md to disk. 2-step handoff via orchestrator | CONDITIONAL (see EO section) | Option C recommended: add but gate behind human approval. Deferred decision |
| **Bash** | Cannot run validation scripts (template-check.sh, skill-validator.sh) | NO | Planner produces content, not artifacts. Validation is reviewer's job. Bash introduces execution risk |
| **Agent()** | Cannot dispatch sub-agents. EP-13 falsely claims this exists | NO — NEVER | Planner is a leaf node (EP-13 corrected). Main session orchestrates. Adding Agent() creates untracked nesting |

### Tool Usage Patterns

```
Design stage (DESIGN.md):
  Read(charter)  →  Read(research)  →  Read(template)  →  QMD(prior decisions)  →  [produce content]
       ↓                 ↓                  ↓                     ↓
  Project EO     Explorer findings   DESIGN structure      Historical context

Sequence stage (SEQUENCE.md):
  Read(DESIGN.md)  →  Grep(existing artifacts)  →  Read(process doc)  →  [produce content]
       ↓                      ↓                         ↓
  Artifact list       Current state survey         Task sizing rules

Synthesis Stage:
  Read(draft 1)  →  Read(draft 2)  →  ...  →  Read(draft N)  →  [score + synthesize]
       ↓                 ↓                          ↓
  Per-criterion scoring across all drafts simultaneously
```

### S x E x Sc

| Pillar | Score | Evidence |
|--------|-------|----------|
| Sustainability | 7/10 | Read-only tools prevent damage. MCP servers provide research capability. But: missing Glob creates blind spots |
| Efficiency | 5/10 | 5 tools cover core needs. But: no Glob means wasted Read attempts on nonexistent files. No Write means double-processing via orchestrator |
| Scalability | 7/10 | Tool set is stable across workstreams. MCP servers scale to new knowledge bases |

### UBS / UDS

| Type | ID | Description | Category | Impact |
|------|-----|-------------|----------|--------|
| UBS | UBS-EOT-1 | No Glob — cannot discover files or verify existence | Technical | Medium |
| UBS | UBS-EOT-2 | No Write — 2-step handoff required (content loss risk) | Technical | Medium |
| UBS | UBS-EOT-3 | Agent file falsely claims Agent() capability | Technical | High |
| UDS | UDS-EOT-1 | All tools read-only — structurally cannot damage the project | Technical | High |
| UDS | UDS-EOT-2 | QMD + Exa cover internal + external knowledge search | Technical | Medium |
| UDS | UDS-EOT-3 | WebFetch enables loading specific reference docs by URL | Technical | Low |

---

## 8. EOP — Effective Operating Procedures

### Current Procedures

**Procedure 1: Design Process (DESIGN.md production)**

```
Step 1: Load charter (1-ALIGN/charter/) — establish EO
Step 2: Load explorer research output — establish problem space
Step 3: Load design template (_genesis/templates/design-template.md)
Step 4: Draft artifact inventory — what must be produced
Step 5: Draft acceptance criteria — binary per artifact
Step 6: Run alignment check:
         - Forward: every completion condition → maps to artifact
         - Reverse: every artifact → maps to condition
         - Result: zero orphans (conditions without artifacts OR artifacts without conditions)
Step 7: Define out-of-scope explicitly
Step 8: Return DESIGN.md content to orchestrator
```

**Procedure 2: Sequence Process (SEQUENCE.md production)**

```
Step 1: Load approved DESIGN.md (must pass G1 gate)
Step 2: Map dependencies between artifacts (DAG)
Step 3: Order tasks: dependency order first, then S > E > Sc priority
Step 4: Size each task: ≤1hr human-equivalent
Step 5: Assign per-task:
         - Task ID (sequential)
         - Input files (Read labels)
         - Output files (Write labels)
         - Binary ACs
         - VERIFY checks (deterministic where possible — EP-14)
Step 6: Return SEQUENCE.md content to orchestrator
```

**Procedure 3: Synthesis Protocol (Multi-Agent Build)**

```
Step 1: Load all N drafts from competing builders
Step 2: Load self-assessment tables from each builder
Step 3: Create per-criterion scoring matrix:
         Criterion × Draft → score (1-5)
Step 4: For each criterion: select the element from the highest-scoring draft
Step 5: Resolve conflicts between selected elements (incompatible assumptions, etc.)
Step 6: Produce synthesis with per-section attribution:
         "Charter §Purpose from Draft 2, UBS from Draft 4"
Step 7: Present to Human Director via orchestrator
```

**Procedure 4: Gate Presentations**

```
G1 (Design Gate):
  Present: DESIGN.md content + alignment check results
  Human decides: approve / revise / reject
  If approved: orchestrator writes to disk, proceeds to Sequence

G2 (Sequence Gate):
  Present: SEQUENCE.md content + dependency diagram + sizing justification
  Human decides: approve / revise / reject
  If approved: orchestrator writes to disk, proceeds to Build
```

### Gap Analysis

| # | Gap | Impact | Category |
|---|-----|--------|----------|
| GAP-EOP-1 | No pre-design checklist — planner jumps to drafting without verifying inputs are complete | May design against incomplete research or missing charter sections | Human |
| GAP-EOP-2 | Alignment check is freeform — no template or script to enforce thoroughness | Under context pressure, planner may perform shallow check | Technical |
| GAP-EOP-3 | No "blocked" protocol — when planner needs info it doesn't have, behavior is undefined | Planner may hallucinate answers instead of stopping and requesting explorer dispatch | Human |
| GAP-EOP-4 | No post-design self-verification step — planner doesn't check its own output against EP standards before returning | Catches fewer errors than builder (which has explicit AC self-check) | Technical |

### Proposed: Pre-Design Checklist

Before starting any DESIGN.md draft, planner should verify:

```
PLANNER PRE-FLIGHT:
[ ] Charter loaded and EO identified
[ ] Explorer research loaded (if applicable)
[ ] Prior decisions checked (1-ALIGN/decisions/)
[ ] Design template loaded
[ ] Workstream identified (which ALPEI stage?)
[ ] Upstream dependency met (ALPEI chain-of-custody)
[ ] LEARN exclusion confirmed (if 2-LEARN/ involved: pipeline, NOT DSBV)
```

### Proposed: Blocked Protocol

```
When planner lacks information needed for design:

1. STOP — do not hallucinate or assume
2. Report: "BLOCKED: Need [specific information] for [specific design decision]"
3. Recommend: "Request ltc-explorer dispatch for [research question]"
4. Return partial output if possible: "DESIGN.md is [X]% complete. Blocked at [section]"
5. Orchestrator dispatches explorer, returns findings, re-invokes planner
```

### S x E x Sc

| Pillar | Score | Evidence |
|--------|-------|----------|
| Sustainability | 6/10 | Design and synthesis procedures are rigorous. But: no pre-flight, no blocked protocol, no self-verification. Alignment check is advisory |
| Efficiency | 7/10 | Procedures are sequential and clear. Gate presentations are well-defined. But: no checklist means occasional re-work when inputs were incomplete |
| Scalability | 8/10 | All 4 procedures are workstream-agnostic. Same process for ALIGN, PLAN, EXECUTE, IMPROVE |

### UBS / UDS

| Type | ID | Description | Category | Impact |
|------|-----|-------------|----------|--------|
| UBS | UBS-EOP-1 | No pre-design checklist — inputs not verified before drafting | Human | Medium |
| UBS | UBS-EOP-2 | Alignment check is freeform — no enforcement template | Technical | Medium |
| UBS | UBS-EOP-3 | No blocked protocol — planner may hallucinate instead of stopping | Human | High |
| UBS | UBS-EOP-4 | No post-design self-verification against EP standards | Technical | Low |
| UDS | UDS-EOP-1 | 4 well-defined procedures covering all planner actions | Technical | High |
| UDS | UDS-EOP-2 | Gate presentations (G1, G2) enforce human approval | Human | High |
| UDS | UDS-EOP-3 | Per-criterion synthesis prevents "best overall" bias | Technical | Medium |

---

## Handoff Contracts

### Upstream: Explorer --> Planner (via Orchestrator)

```
Explorer EO (research findings)  ──→  Planner EI (design context)
─────────────────────────────────────────────────────────────────
EXPLORER MUST PROVIDE:           │  PLANNER EXPECTS:
• Structured findings by theme   │  • Clear answer to research Q
• Source citations per claim     │  • Confidence levels per claim
• Confidence: high/medium/low    │  • Unknowns explicitly flagged
• Unknowns explicitly listed     │  • Sources for verification
─────────────────────────────────────────────────────────────────
EP-12 CHECK: Planner must verify citations exist before treating
research as ground truth. LT-1 risk: explorer (haiku) has highest
hallucination rate. Cross-validation required.

FAILURE MODE: If explorer provides unstructured findings without
confidence levels, planner treats all claims as equally reliable.
This cascades: high-confidence and low-confidence claims get equal
weight in DESIGN.md. Builder then executes on uncertain foundations.

MITIGATION: Planner pre-flight checks for confidence levels in
explorer output. If absent: BLOCKED (request re-dispatch with
structured output instructions).
```

### Downstream: Planner --> Builder (via Orchestrator)

```
Planner EO (DESIGN.md + SEQUENCE.md)  ──→  Builder EI (task to execute)
──────────────────────────────────────────────────────────────────────────
PLANNER MUST PROVIDE:                  │  BUILDER EXPECTS:
• Per-artifact binary ACs              │  • Clear task ID from SEQUENCE.md
• Task ordering with dependencies      │  • Input files with Read/Write labels
• Sizing (≤1hr human-equivalent/task)  │  • Budget (token/scope boundary)
• File paths for Read + Write targets  │  • Constraints (what NOT to do)
• VERIFY checks (deterministic)        │  • VERIFY commands (script-first)
──────────────────────────────────────────────────────────────────────────
EP-12 CHECK: Builder must verify DESIGN.md and SEQUENCE.md exist on
disk before starting. If missing = handoff failed. STOP + report.

FAILURE MODE: If planner provides vague ACs ("looks good", "is correct"),
builder cannot self-verify. The builder-reviewer loop becomes meaningless
because there is nothing concrete to validate against.

MITIGATION: Planner alignment check enforces binary ACs. Every AC must
be testable by: (a) file existence, (b) grep pattern, (c) script exit
code, or (d) human visual inspection. "Vibes" ACs are rejected.

FRONTIER PATTERN (ADK output_key): Each task in SEQUENCE.md should have
a unique output_key — a named artifact path that downstream agents
reference by key, not by searching.
```

---

## Consolidated Force Analysis

### UBS Register (What Blocks)

| ID | Description | Category | Impact | Component | Priority |
|----|-------------|----------|--------|-----------|----------|
| UBS-P1 | EP-13 claims orchestrator authority — FALSE | Technical | HIGH | EP, EA, EOE | **P0** |
| UBS-P2 | No Write/Edit tools — 2-step lossy handoff | Technical | HIGH | EO, EOT | P1 |
| UBS-P3 | No Glob tool — cannot discover/verify files | Technical | MEDIUM | EOT, EOE | P1 |
| UBS-P4 | No output schema — freeform text handoff | Technical | MEDIUM | EO, EA | P1 |
| UBS-P5 | No blocked protocol — may hallucinate vs stop | Human | HIGH | EOP | P1 |
| UBS-P6 | Hooks don't fire in sub-agents (SDK limitation) | Technical | MEDIUM | EOE | Accept |
| UBS-P7 | .claude/rules/ loading unverified in sub-agents | Technical | MEDIUM | EOE | P1 |
| UBS-P8 | No pre-design checklist | Human | MEDIUM | EOP | P2 |
| UBS-P9 | Alignment check is freeform/advisory | Technical | MEDIUM | EOP, EA | P2 |
| UBS-P10 | No auto-recall/memory in sub-agent context | Technical | MEDIUM | EOE | Accept |
| UBS-P11 | Single planner bottleneck for synthesis | Temporal | LOW | EA, EU | P2 |

### UDS Register (What Drives)

| ID | Description | Category | Leverage | Component |
|----|-------------|----------|----------|-----------|
| UDS-P1 | Opus model — best reasoning for high-stakes design | Technical | HIGH | EU |
| UDS-P2 | Alignment check prevents orphan criteria | Technical | HIGH | EA, EOP |
| UDS-P3 | Per-criterion synthesis (not holistic) | Technical | HIGH | EA, EOP |
| UDS-P4 | Context packaging protocol (5-field) | Technical | HIGH | EI |
| UDS-P5 | Human gates G1/G2 prevent bad designs from landing | Human | HIGH | EOP, EP |
| UDS-P6 | Read-only tools — cannot damage project | Technical | HIGH | EOT, EOE |
| UDS-P7 | settings.json permissions — deterministic enforcement | Technical | HIGH | EOE |
| UDS-P8 | 4 well-defined procedures covering all actions | Technical | MEDIUM | EOP |
| UDS-P9 | SubagentStop fires — post-hoc verification works | Technical | MEDIUM | EOE |

---

## Aggregate S x E x Sc

| Component | S | E | Sc | Primary Blocker |
|-----------|---|---|-----|----------------|
| EI | 7 | 6 | 7 | No explorer output schema |
| EU | 9 | 6 | 5 | Opus cost, single-planner bottleneck |
| EA | 5 | 5 | 4 | EP-13 contradiction, freeform output |
| EO | 5 | 4 | 5 | No Write tool, no output schema |
| EP | 4 | 7 | 8 | EP-13 false claim (CRITICAL) |
| EOE | 4 | 5 | 6 | EP-13 false self-model, hooks degraded |
| EOT | 7 | 5 | 7 | No Glob, no Write |
| EOP | 6 | 7 | 8 | No blocked protocol, no pre-flight |
| **Avg** | **5.9** | **5.6** | **6.3** | |

**Weakest link:** EP (4/10 Sustainability) and EOE (4/10 Sustainability) — both degraded by the EP-13 contradiction. Fixing EP-13 is the single highest-leverage improvement. It raises EP Sustainability from 4 to 7+ and EOE Sustainability from 4 to 6+.

**Governing equation check:** Success = Efficient & Scalable Management of Failure Risks. The planner's primary failure risk is EP-13 (false self-model). Managing it requires a single edit to the agent file. Cost: ~5 minutes. Impact: raises the floor of the weakest components.

---

## Improvement Roadmap

| Priority | Action | Component | Effort | Impact |
|----------|--------|-----------|--------|--------|
| **P0** | Fix EP-13 in ltc-planner.md (remove orchestrator claim, add leaf-node statement) | EP, EA, EOE | 5 min | HIGH — fixes foundational contradiction |
| **P1** | Add Glob to planner tool whitelist | EOT, EOE | 5 min | MEDIUM — enables file discovery |
| **P1** | Define typed output contract (BEGIN/END markers + metadata) | EO, EA | 30 min | MEDIUM — eliminates lossy handoff parsing |
| **P1** | Add blocked protocol to agent file EOP section | EOP | 15 min | HIGH — prevents hallucination on missing info |
| **P1** | Test .claude/rules/ loading in sub-agents | EOE | 15 min | MEDIUM — confirms or denies Layer 6 gap |
| **P2** | Add pre-design checklist to agent file | EOP | 15 min | MEDIUM — catches incomplete inputs early |
| **P2** | Partially script alignment check (orphan detection) | EOP, EA | 1 hr | MEDIUM — EP-14 compliance |
| **P2** | Evaluate Option C (Write tool with gate) | EO, EOT | Decision | HIGH potential — eliminates 2-step handoff |
| Accept | Hook limitation (SDK) | EOE | N/A | Mitigated by settings.json + SubagentStop |
| Accept | No auto-recall in sub-agents | EOE | N/A | Mitigated by context packaging |

---

## Review Status (2026-04-08)

**Verdict:** G1 APPROVED with P0 fix.
**Aggregate:** S=5.9, E=5.6, Sc=6.3 — weakest at EP (4/10 S) due to EP-13 contradiction.
**P0 fix required before BUILD:**
1. Fix EP-13 false orchestrator claim in `ltc-planner.md` (4 locations: lines 65-71 EP-13 section, line 20 "Orchestrate DSBV flow", line 23 "Orchestrate learn pipeline", frontmatter line 5)

**Deferred decisions:**
- Add Glob to planner tool list? (P1 — recommended YES, low risk)
- Add Write/Edit with gate (Option C)? (P2 — needs human approval, changes tool whitelist)

**Cross-agent dependency:** Planner EI depends on Explorer output schema (Proposal E3). If E3 is built, Planner EI gap analysis improves.

## Links

- [[2026-04-08_agent-system-8component-design]]
- [[AGENTS]]
- [[BLUEPRINT]]
- [[CLAUDE]]
- [[DESIGN]]
- [[EP-03]]
- [[EP-04]]
- [[EP-05]]
- [[EP-09]]
- [[EP-10]]
- [[EP-12]]
- [[EP-13]]
- [[EP-14]]
- [[SEQUENCE]]
- [[SKILL]]
- [[VALIDATE]]
- [[architecture]]
- [[blocker]]
- [[charter]]
- [[design-template]]
- [[dsbv-process]]
- [[iteration]]
- [[ltc-builder]]
- [[ltc-explorer]]
- [[ltc-planner]]
- [[ltc-reviewer]]
- [[project]]
- [[roadmap]]
- [[schema]]
- [[security]]
- [[simple]]
- [[standard]]
- [[task]]
- [[versioning]]
- [[workstream]]
