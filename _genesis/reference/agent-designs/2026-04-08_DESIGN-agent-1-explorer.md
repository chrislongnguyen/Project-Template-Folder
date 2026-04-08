---
version: "1.0"
status: draft
last_updated: 2026-04-08
type: design-proposal
work_stream: 0-GOVERN
iteration: 1
title: "DESIGN: Agent 1 — ltc-explorer (Scout)"
agent: explorer
parent: inbox/2026-04-08_agent-system-8component-design.md
---

# DESIGN: Agent 1 — ltc-explorer (Scout)

> **Purpose:** Full 8-component system design for ltc-explorer, the Scout agent.
> Pre-DSBV research + learning pipeline discovery. Haiku model. Read-only. Leaf node.
>
> **Parent document:** `inbox/2026-04-08_agent-system-8component-design.md` (Agent 0-4 overview)
>
> **Governing equation:** Success = Efficient & Scalable Management of Failure Risks (UT#5)
> **Evaluation criteria:** Sustainability > Efficiency > Scalability (DT#1)
> **RACI:** Human Director = A, Main Session = C (orchestrator), ltc-explorer = R (research only)

---

## 1. Agent Identity Card

```
Name:            ltc-explorer
Role:            Scout — fast, cheap, wide-net discovery
Model:           Haiku (cheapest/fastest tier)
Pipeline pos:    Pre-DSBV + LEARN pipeline (first agent dispatched)
RACI:            R only — reports findings, never decides
Agent type:      Leaf node — cannot dispatch sub-agents (EP-13)
Agent file:      .claude/agents/ltc-explorer.md (v1.4)
Tool count:      5 (Read, Glob, Grep, Exa MCP, QMD MCP)
Dispatch skills: /deep-research, /learn-research, /dsbv (indirect)
```

---

## 1b. Dispatch Modes

Explorer is NOT limited to the DSBV chain. It operates in multiple modes:

| Mode | Trigger | EI Source | EO Destination | Context Weight |
|------|---------|-----------|----------------|----------------|
| **DSBV chain** | `/dsbv` pre-Build research | Orchestrator (5-field context package) | Planner (via orchestrator) | Full: EO→INPUT→EP→OUTPUT→VERIFY |
| **Ad-hoc research** | User asks "research X" or "find out about Y" | Orchestrator (lighter: EO + files + constraints) | Main session directly | Light: question + scope + budget |
| **Learn pipeline** | `/learn-research` | Learn skill (1 topic per explorer) | Learn orchestrator (parallel gather) | Medium: topic + methodology + sources |
| **Deep research** | `/deep-research:lite/mid/deep/full` | Deep-research skill (parallel retrieval) | Main session (synthesis) | Medium: query + depth + source types |
| **Audit/explore** | "Check if X exists" or "scan for Y" | Orchestrator (ad-hoc) | Main session directly | Minimal: question only |

**Key insight:** In ad-hoc mode, explorer returns directly to main session — no downstream planner handoff. The handoff contract (Explorer→Planner) applies ONLY in DSBV chain mode. In all other modes, the orchestrator receives and acts on findings directly.

**EOE implications by mode:**
- All modes: degraded sub-agent EOE (no hooks, no memory, no rules)
- Ad-hoc mode: lighter context package is acceptable (no formal ACs needed)
- DSBV chain mode: full 5-field context package required (formal handoff to planner)

---

## 2. Eight-Component Design

### 2.1 EI — Effective Input

#### Current State

Explorer receives a context-packaged prompt using the 5-field template
(EO, INPUT, EP, OUTPUT, VERIFY) from `.claude/skills/dsbv/references/context-packaging.md`.

Typical EI contents:
- Research question (specific, scoped)
- File paths to read (known references, prior research)
- Search terms and query strategies (keyword + semantic + HYDE)
- Budget indicator (lite/mid/deep/full)
- Depth constraint mapping:

```
lite  → 5-10 sources, ~20K tokens,  2-5 min
mid   → 10-20 sources, ~50K tokens, 5-10 min
deep  → 20-30 sources, ~100K tokens, 10-20 min
full  → 30-50 sources, ~200K tokens, 20-45 min
```

Upstream sources:
- Human Director intent (via orchestrator main session)
- `/learn-research` skill (1 explorer per topic, parallel dispatch)
- `/deep-research` skill (N parallel retrieval agents)
- `/dsbv` skill (indirect — pre-DSBV research phase, orchestrator dispatches)

#### Frontier Standard

ADK: task description + output_key + search scope + explicit timeout.
OpenAI Agents SDK: typed tool-call input with JSON schema validation.

#### Gap

| ID | Gap | Impact |
|----|-----|--------|
| GAP-EI-1 | No input schema validation | Malformed context package silently produces garbage output. Orchestrator may forget a required field (LT-2: context is lossy) |
| GAP-EI-2 | No explicit timeout/token cap in EI | Budget indicator is advisory text, not enforced. Explorer can exceed budget without knowing |
| GAP-EI-3 | No input completeness check | Explorer starts searching even if research question is vague or missing |

#### S x E x Sc

| Pillar | Score | Evidence |
|--------|-------|----------|
| Sustainability | 8/10 | Context packaging is more structured than ADK's approach. 5-field template is well-documented. But: no validation = fragile to human error |
| Efficiency | 7/10 | Budget tiers are clear. But: advisory, not enforced — explorer may over-research on a lite task |
| Scalability | 9/10 | Same 5-field template works for all dispatch modes (single, parallel, nested). No per-mode customization needed |

#### UBS (What Blocks)

| ID | Description | Category |
|----|-------------|----------|
| UBS-EI-1 | Vague research question → scattershot search → low-value report | Human |
| UBS-EI-2 | Missing file paths in INPUT → explorer can't cross-reference local context | Technical |
| UBS-EI-3 | No timeout enforcement → budget overrun on lite tasks | Temporal |

#### UDS (What Drives)

| ID | Description | Category |
|----|-------------|----------|
| UDS-EI-1 | 5-field context packaging already exceeds ADK's input structure | Technical |
| UDS-EI-2 | Budget tiers provide clear scoping (even if advisory) | Human |
| UDS-EI-3 | Parallel dispatch proven — same EI template works for N explorers | Technical |

---

### 2.2 EU — Effective User

#### Current State

The "User" of explorer is the **orchestrating main session** (Opus), which consumes
explorer's output for synthesis and routing decisions. RACI: explorer is R (Responsible)
for research execution. Main session is C (Consulted — it dispatches and receives). Human
Director is A (Accountable — approves final decisions based on research).

Explorer operates as a Haiku model instance:
- Cheapest tier in the Claude model family
- Fastest inference time
- Smallest context window (relative to Sonnet/Opus)
- Higher hallucination rate than Sonnet or Opus (LT-1 risk)
- Cannot dispatch further agents — leaf node (EP-13)

#### Frontier Standard

Same — leaf node with cheapest-appropriate model for discovery tasks.

#### Gap

No gap. Haiku for exploration is cost-optimal. The hallucination risk (LT-1) is compensated
by the cross-validation protocol in EA and the EP-12 verification requirement downstream.

#### S x E x Sc

| Pillar | Score | Evidence |
|--------|-------|----------|
| Sustainability | 9/10 | Read-only tools prevent damage. Cheap to retry on failure. Leaf node = no nesting risk |
| Efficiency | 9/10 | Haiku is the most cost-effective model for high-volume, low-stakes search |
| Scalability | 9/10 | N parallel Haiku instances scale linearly. Cost grows linearly, not exponentially |

#### UBS / UDS

| Force | ID | Description | Category |
|-------|----|-------------|----------|
| UBS | UBS-EU-1 | Haiku has highest hallucination rate of 3 tiers (LT-1) | Technical |
| UBS | UBS-EU-2 | Smaller context window limits single-query depth | Technical |
| UDS | UDS-EU-1 | Cheapest agent — cost-optimal for wide-net search | Economic |
| UDS | UDS-EU-2 | Fastest inference — reduces wall-clock time for research | Temporal |

---

### 2.3 EA — Effective Action

#### Current State

Explorer executes a 5-step research protocol:

```
Step 1: SCOPE    — Parse the research question. What specifically needs answering? What depth?
Step 2: SEARCH   — Multiple query strategies: keyword (BM25) + semantic (vector) + HYDE
Step 3: VALIDATE — Cross-validate across sources. Confirming + disconfirming evidence
Step 4: REPORT   — Findings by theme, source citations, confidence levels per claim
Step 5: FLAG     — Explicitly state unknowns, gaps, contradictions
```

Multi-source search hierarchy (per `tool-routing.md` cheatsheet):

```
Priority 1: QMD MCP   — internal knowledge (semantic search over markdown corpus)
Priority 2: Exa MCP   — external research (structured semantic search, fewer tokens)
Priority 3: Grep      — exact match (file content search for specific terms)
Priority 4: Glob      — file discovery (pattern-based file location)
Priority 5: Read      — targeted file loading (known path)
```

Cross-validation discipline: explorer does not trust a single source. Looks for confirming
AND disconfirming evidence. Reports confidence levels (high/medium/low) per claim.

Neutrality constraint: "Scout, not Decision-Maker." Reports findings, does not synthesize
or make judgment calls. Synthesis is the planner's job.

#### Frontier Standard

ADK: tool-based routing with description-matching + AutoFlow for dynamic tool selection.
LangGraph: explicit state machine transitions between search phases.

#### Gap

| ID | Gap | Impact |
|----|-----|--------|
| GAP-EA-1 | **BUG: Agent file claims WebSearch is available (line 42, 53).** WebSearch is NOT in the `tools:` field. The Tool Preferences table lists "WebSearch" as a fallback for Exa. Line 53: "If Exa MCP is unavailable, fall back to WebSearch without stopping." This is a FALSE CLAIM — explorer cannot fall back to a tool it does not have. | HIGH — explorer may attempt WebSearch calls that fail silently, or skip external research entirely when Exa is down |
| GAP-EA-2 | No state machine for research phases — explorer follows a text-based protocol, not enforced transitions | Medium — explorer may skip steps (especially Step 3: cross-validation) under token pressure |
| GAP-EA-3 | **BUG: Tool Guide table (lines 64-70) is missing Glob.** Glob IS in the `tools:` field. But the Tool Guide table only lists 4 tools (Read, Grep, Exa, QMD). Explorer may underutilize Glob for file discovery because the guide doesn't mention it. | Medium — Glob exists but explorer may not use it effectively |
| GAP-EA-4 | No query optimization — explorer generates queries ad hoc, no templated query strategies | Low — works for most cases, but sophisticated research benefits from structured query generation |

#### S x E x Sc

| Pillar | Score | Evidence |
|--------|-------|----------|
| Sustainability | 7/10 | Cross-validation protocol compensates for LT-1 (hallucination). But: WebSearch false claim creates a fragile fallback path. If Exa is down, explorer has NO external search capability (only QMD local) |
| Efficiency | 7/10 | 5-step protocol is lean. But: no query optimization means redundant or poorly-targeted searches on complex topics |
| Scalability | 8/10 | Protocol applies equally to lite/mid/deep/full. But: deep/full modes need more sophisticated search strategies that the current flat protocol doesn't differentiate |

#### UBS / UDS

| Force | ID | Description | Category |
|-------|----|-------------|----------|
| UBS | UBS-EA-1 | WebSearch false claim — no fallback when Exa is down (BUG) | Technical |
| UBS | UBS-EA-2 | Glob missing from Tool Guide — underutilization risk (BUG) | Technical |
| UBS | UBS-EA-3 | No enforced state transitions between research steps | Technical |
| UBS | UBS-EA-4 | Haiku may skip cross-validation under token pressure (LT-3) | Technical |
| UDS | UDS-EA-1 | 5-step protocol covers the research lifecycle end-to-end | Technical |
| UDS | UDS-EA-2 | Multi-source hierarchy prevents single-source dependency | Technical |
| UDS | UDS-EA-3 | Confidence levels per claim enable downstream triage | Technical |

---

### 2.4 EO — Effective Output

#### Current State

Explorer returns a structured research report. Per `sub-agent-output.md`, explorer
output is NOT trimmed — the orchestrator needs full content for synthesis.

Current report structure (observed, not enforced):

```
## Findings
- Theme 1: [finding with source citations]
- Theme 2: [finding with source citations]

## Sources
- [1] URL or file path — title/description
- [2] ...

## Confidence
- Claim X: high (3+ confirming sources)
- Claim Y: medium (1-2 sources, no disconfirming)
- Claim Z: low (single source, uncorroborated)

## Unknowns
- What could not be found or verified
- Questions that remain open
```

Consumed by:
- `ltc-planner` — as design context for DESIGN.md + SEQUENCE.md
- Human Director — directly, for decision-making
- Main session (orchestrator) — for synthesis across N parallel explorers

#### Frontier Standard

ADK: typed output contract with explicit schema (output_key). Each field has a type,
validation rule, and downstream consumer declaration.
LangGraph: typed state with Pydantic models. Each agent's output is schema-validated
before the next node receives it.

#### Gap

| ID | Gap | Impact |
|----|-----|--------|
| GAP-EO-1 | **No formal output schema.** Report structure varies per invocation. Some reports omit Confidence or Unknowns sections. Some use bullet lists, others use tables. Orchestrator must parse unstructured text. | HIGH — downstream agents may misinterpret findings. Orchestrator spends tokens parsing variable formats |
| GAP-EO-2 | No minimum source count enforcement | Medium — lite mode may return 0-2 sources, below the useful threshold |
| GAP-EO-3 | No output size bounds | Low — explorer may return excessively long reports on deep/full, consuming orchestrator context |

#### Proposed Typed Output Contract

```yaml
output_contract:
  format: markdown
  required_sections:
    - name: findings
      description: "Themed research results with inline source citations [N]"
      min_items: 1
    - name: sources
      description: "Numbered list of URLs/file paths with titles"
      min_items: 3
      validation: "Every [N] cited in findings MUST appear in sources"
    - name: confidence
      description: "Per-claim confidence level"
      values: ["high", "medium", "low"]
      rule: "high = 3+ confirming sources; medium = 1-2 sources; low = single uncorroborated"
    - name: unknowns
      description: "Explicitly flagged knowledge gaps and open questions"
      min_items: 0
      note: "Empty unknowns section is valid but must be present"
  optional_sections:
    - name: contradictions
      description: "Sources that disagree — both positions stated"
    - name: recommendations
      description: "Suggested next research steps (NOT design decisions)"
  size_bounds:
    lite: "1000-3000 tokens"
    mid: "3000-8000 tokens"
    deep: "8000-15000 tokens"
    full: "15000-30000 tokens"
```

#### S x E x Sc

| Pillar | Score | Evidence |
|--------|-------|----------|
| Sustainability | 6/10 | Full content return is correct (orchestrator needs it). But: no schema = variable quality. Orchestrator can't programmatically validate output |
| Efficiency | 5/10 | Unstructured text forces orchestrator to spend tokens parsing. A typed schema would enable direct consumption |
| Scalability | 7/10 | N parallel explorers returning same unstructured format creates N parsing problems. Schema would make parallel output composable |

#### UBS / UDS

| Force | ID | Description | Category |
|-------|----|-------------|----------|
| UBS | UBS-EO-1 | No output schema — structure varies per invocation | Technical |
| UBS | UBS-EO-2 | No minimum source count — may return unsupported claims | Technical |
| UBS | UBS-EO-3 | Variable output size complicates orchestrator context budget | Temporal |
| UDS | UDS-EO-1 | Full content return (not trimmed) preserves signal for planner | Technical |
| UDS | UDS-EO-2 | Confidence levels per claim enable downstream triage | Technical |
| UDS | UDS-EO-3 | Unknowns section prevents false completeness | Human |

---

### 2.5 EP — Effective Principles

#### Current State

Explorer is governed by these principles (stated in agent file + rules):

| Principle | Application to Explorer |
|-----------|------------------------|
| EP-01 (Brake Before Gas) | Scope the question BEFORE searching. Don't search everything — search what matters |
| EP-02 (Know the Physics — 8 LTs) | LT-1 (hallucination): cross-validate. LT-7 (cost): use cheapest model. LT-3 (reasoning degrades): keep searches focused |
| EP-10 (Define Done) | Research is done when: question answered OR unknowns explicitly flagged. Not when tokens run out |
| EP-13 (Orchestrator Authority) | Leaf node. NEVER call Agent(). Return findings directly to orchestrator |
| — ("Scout, not Decision-Maker") | Report findings neutrally. Do not make judgments, recommendations, or design decisions |

Additionally, explorer inherits these from the dispatching skill context:
- Citation discipline: every factual claim MUST cite a specific source from a search
  result in the current session. Never from parametric memory.
- Cross-validation: do not trust a single source
- Unknown flagging: explicitly state what could NOT be found

#### Frontier Standard

Same principles apply. The "Scout, not Decision-Maker" constraint is equivalent to ADK's
`agent_type: retrieval` (information gathering only, no decision authority).

#### Gap

No significant EP gap. The principle set is complete for a read-only scout agent.
Minor consideration: EP-08 (Escape Hatches) references WebSearch as a fallback for Exa,
but WebSearch is not available — this creates a false escape hatch.

#### S x E x Sc

| Pillar | Score | Evidence |
|--------|-------|----------|
| Sustainability | 9/10 | Neutrality constraint prevents scope creep. EP-13 prevents nesting. Citation discipline compensates LT-1 |
| Efficiency | 8/10 | Principles are minimal and non-overlapping. No redundant constraints |
| Scalability | 9/10 | Same principles apply regardless of dispatch mode (single, parallel, nested context) |

---

### 2.6 EOE — Effective Operating Environment

> **CRITICAL SECTION.** Explorer operates as a sub-agent in a DEGRADED environment.
> Most enforcement mechanisms that protect the main session DO NOT FIRE inside sub-agents.
> This section documents every layer of the operating environment and its actual status
> when explorer runs.

#### Layer 1 — Platform Runtime

```
Platform:         Claude Code CLI
OS:               macOS (Darwin)
Shell:            zsh
Model:            Haiku (claude-haiku)
Context window:   Smaller than Sonnet/Opus (exact size model-dependent)
Token budget:     Controlled by dispatching skill (lite/mid/deep/full)
Session type:     Sub-agent (spawned via Agent() tool from main session)
Persistence:      NONE — sub-agent has no memory between dispatches
```

Explorer runs inside a Claude Code sub-agent process. It has no awareness of prior
dispatches, no session history, no conversation memory. Every dispatch starts from
zero context. The ONLY information explorer has is what the orchestrator provides
in the context-packaging prompt.

#### Layer 2 — Permission Model (settings.json)

```
Status: ENFORCED at platform level (settings.json deny/allow rules apply to sub-agents)
```

The following deny rules from `.claude/settings.json` apply:
- `Read(.env*)` — blocked (explorer cannot read secrets)
- `Bash(rm -rf *)` — blocked (explorer has no Bash tool, but deny still applies)
- `Bash(sudo *)` — blocked (same)
- `Bash(git push --force *)` — blocked (same)

Explorer has NO Bash tool, so most deny rules are moot. The `.env` read-deny is
the only practically relevant restriction (prevents accidental secret exposure
if a file path containing `.env` is passed in EI).

#### Layer 3 — Hook Enforcement (DEGRADED)

```
Status: MOST HOOKS DO NOT FIRE in sub-agents
Known issue: LP-7 (learned_patterns.md), Anthropic GitHub #40580
```

| Hook | Event | Fires in Sub-Agent? | Impact on Explorer |
|------|-------|--------------------|--------------------|
| `naming-lint.sh` | PreToolUse (Write) | NO | N/A — explorer has no Write tool |
| `dsbv-skill-guard.sh` | PreToolUse (Write/Edit) | NO | N/A — explorer has no Write/Edit tools |
| `inject-frontmatter.sh` | PostToolUse (Write/Edit) | NO | N/A — explorer does not write files |
| `verify-agent-dispatch.sh` | PreToolUse (Agent) | NO | N/A — explorer cannot dispatch agents (no Agent tool) |
| `dsbv-gate.sh` | PreToolUse (git commit) | NO | N/A — explorer has no Bash/git tools |
| `skill-validator.sh` | PreToolUse (git commit) | NO | N/A — same |
| `link-validator.sh` | PreToolUse (git commit) | NO | N/A — same |
| `registry-sync-check.sh` | PreToolUse (git commit) | NO | N/A — same |
| `status-guard.sh` | PreToolUse (git commit) | NO | N/A — same |
| `validate-blueprint.py` | PreToolUse (git commit) | NO | N/A — same |
| `strategic-compact.sh` | PreToolUse (all) | NO | **RELEVANT** — no compaction warning for explorer. If Haiku context fills, no safety net |
| `resume-check.sh` | SessionStart | NO | Sub-agents don't trigger SessionStart |
| `session-reconstruct.sh` | SessionStart | NO | Same |
| `verify-deliverables.sh` | SubagentStop | **YES** | Fires when explorer completes. Verifies output exists |
| `save-context-state.sh` | PreCompact | NO | Sub-agents handle compaction differently |
| `session-summary.sh` | Stop | NO | Sub-agent stop != session stop |

**Net assessment:** Explorer's read-only tool set means most hook gaps are
irrelevant (hooks guard Write/Edit/Bash/Agent which explorer lacks). The ONE
relevant gap is `strategic-compact.sh` not firing — if Haiku context fills during
a deep research task, there is no automatic warning or compaction trigger.

The `verify-deliverables.sh` hook DOES fire on SubagentStop — this is the
primary enforcement point. It checks that explorer actually produced output
before the main session continues.

#### Layer 4 — Context Environment (SEVERELY CONSTRAINED)

```
Status: Sub-agent receives ONLY what orchestrator provides. No auto-enrichment.
```

| Context Source | Available to Main Session | Available to Explorer |
|----------------|--------------------------|----------------------|
| CLAUDE.md | YES (auto-loaded) | NO — not auto-loaded for sub-agents |
| `.claude/rules/` files | YES (auto-loaded) | UNCLEAR — may or may not load. Agent file is loaded as identity, but rules/ loading is not guaranteed |
| Memory vault (`memory/MEMORY.md`) | YES | NO — sub-agents have no memory access |
| Session history | YES (full conversation) | NO — starts from zero context |
| Auto-recall (QMD injection) | YES (hooks inject) | NO — SessionStart hooks don't fire |
| Git status/history | YES (via Bash) | NO — no Bash tool |
| Hook-injected context | YES (PreToolUse etc.) | NO — hooks don't fire |
| Skill files (`.claude/skills/`) | YES (on-demand) | NO — explorer doesn't invoke skills |

**Critical implication:** Explorer's context = ONLY the 5-field package from
the orchestrator. If the orchestrator omits a critical reference file or prior
decision, explorer cannot discover it independently (no memory, no auto-recall,
no session history). This makes context packaging quality the #1 determinant of
explorer output quality.

**Haiku-specific constraint:** Haiku has a smaller effective context window than
Sonnet/Opus. The "lost in the middle" phenomenon (EOP-05) is MORE pronounced
with Haiku. Long context packages risk information loss in the center.

#### Layer 5 — Agent Coordination

```
Status: Leaf node. Cannot dispatch further agents.
```

Explorer is at the bottom of the hierarchy:

```
Human Director
  └── Main Session (Opus, orchestrator)
        ├── ltc-explorer (Haiku, leaf)    ← THIS AGENT
        ├── ltc-planner (Opus, leaf)
        ├── ltc-builder (Sonnet, leaf)
        └── ltc-reviewer (Opus, leaf)
```

- Cannot call `Agent()` — tool not in whitelist
- Cannot invoke skills — no skill activation mechanism in sub-agents
- Cannot escalate — if blocked, must report in output text. Orchestrator reads it
- Parallel instances are independent — N explorers dispatched simultaneously do
  not communicate with each other. Each operates in isolation

#### Layer 6 — Rule Loading

```
Status: UNCERTAIN — agent file is loaded, .claude/rules/ auto-loading unconfirmed
```

What IS loaded:
- Agent file (`.claude/agents/ltc-explorer.md`) — serves as identity + EP + EOP
- Context-packaging prompt (the 5-field template content from orchestrator)

What is PROBABLY loaded (platform behavior, unconfirmed):
- `.claude/rules/` files tagged as "always-on" — may auto-load for sub-agents

What is NOT loaded:
- CLAUDE.md (project-level) — sub-agents don't auto-load project instructions
- `~/.claude/CLAUDE.md` (global) — sub-agents don't auto-load user instructions
- Memory files — sub-agents have no memory system
- Skill files — sub-agents don't activate skills

**Practical implication:** The agent file IS the rules for explorer. Any constraint
not stated in `.claude/agents/ltc-explorer.md` or the context-packaging prompt
is effectively invisible to the explorer.

#### Layer 7 — MCP Server Access

```
Status: 2 MCP servers available (Exa + QMD). All others unavailable.
```

| MCP Server | Available | Purpose |
|------------|-----------|---------|
| `mcp__exa__web_search_exa` | YES | External semantic search (structured content, fewer tokens) |
| `mcp__qmd__query` | YES | Internal knowledge base search (2188 markdown docs) |
| Notion MCP | NO | Task management — explorer has no WMS access |
| ClickUp MCP | NO | Secondary task tracking — not available |
| Playwright MCP | NO | Browser automation — not available |
| GitHub MCP | NO | Repo operations — not available |

**QMD collections available to explorer:**
- `sessions` (2013 docs) — richest source for internal context
- `conversations` (37 docs)
- `decisions` (3 docs)
- `daily` (132 docs)
- `learn` (0 docs), `learn_specs` (0 docs), `distilled` (0 docs) — empty

**Exa capabilities:** Structured semantic search. Returns content snippets + URLs.
Fewer tokens per result than raw web search. Best for: market research, tool
comparisons, technical documentation, academic sources.

**WebSearch:** NOT AVAILABLE. Despite claims in the agent file (line 42: "WebSearch"
as fallback, line 53: "fall back to WebSearch"), WebSearch is not in the `tools:` field.
This is a documented bug (UBS-EA-1). If Exa is unavailable, explorer's only external
search capability is gone.

#### Layer 8 — Filesystem Access

```
Status: READ-ONLY. 3 tools for file access. Cannot create, modify, or delete.
```

| Tool | Capability | Constraint |
|------|-----------|------------|
| Read | Load file by exact path | Cannot read `.env*` (settings.json deny) |
| Glob | Find files by pattern | Read-only discovery — returns paths, not content |
| Grep | Search file contents by regex | Read-only search — returns matches, not modifications |

Explorer cannot:
- Create files (no Write tool)
- Modify files (no Edit tool)
- Run scripts (no Bash tool)
- Commit changes (no git access)
- Delete anything

This is the strongest safety guarantee in the agent system. Explorer is
structurally incapable of causing damage to the filesystem.

#### EOE Summary Table

| Layer | Status | Risk Level |
|-------|--------|------------|
| L1: Platform | Normal | LOW |
| L2: Permissions | Enforced | LOW |
| L3: Hooks | DEGRADED (most don't fire) | LOW (mitigated by read-only tools) |
| L4: Context | SEVERELY CONSTRAINED | **HIGH** (quality depends entirely on orchestrator) |
| L5: Coordination | Leaf node (by design) | LOW |
| L6: Rules | UNCERTAIN (agent file loads, rules/ unknown) | MEDIUM (unconfirmed rule loading) |
| L7: MCP | 2 of 6+ servers | MEDIUM (no WebSearch fallback) |
| L8: Filesystem | Read-only | LOW (strongest safety layer) |

#### S x E x Sc

| Pillar | Score | Evidence |
|--------|-------|----------|
| Sustainability | 8/10 | Read-only filesystem is the strongest safety guarantee. Hook gaps are irrelevant for a read-only agent. But: L4 (context) is a single point of failure — bad context package = bad output, no recovery mechanism |
| Efficiency | 6/10 | Haiku's smaller context window + L4 constraint means the orchestrator must carefully curate the context package. Overhead for orchestrator, not explorer. L7 WebSearch gap wastes the fallback path |
| Scalability | 8/10 | Read-only + leaf node + 2 MCP servers = minimal resource footprint per instance. N parallel instances have zero contention (no shared state, no writes) |

#### UBS / UDS

| Force | ID | Description | Category |
|-------|----|-------------|----------|
| UBS | UBS-EOE-1 | L4: Context entirely dependent on orchestrator quality. No auto-enrichment, no memory, no recall | Human |
| UBS | UBS-EOE-2 | L6: Rule loading uncertain — constraints in .claude/rules/ may not apply | Technical |
| UBS | UBS-EOE-3 | L7: WebSearch not available despite agent file claims (BUG) — no Exa fallback | Technical |
| UBS | UBS-EOE-4 | L3: strategic-compact.sh doesn't fire — no context saturation warning | Technical |
| UDS | UDS-EOE-1 | L8: Read-only tools = structurally impossible to cause damage | Technical |
| UDS | UDS-EOE-2 | L2: settings.json deny rules still enforced — platform-level safety | Technical |
| UDS | UDS-EOE-3 | L3: verify-deliverables.sh fires on SubagentStop — output verification works | Technical |
| UDS | UDS-EOE-4 | L5: Leaf node + no Agent() tool = zero nesting risk | Technical |

---

### 2.7 EOT — Effective Operating Tools

#### Current State

5 tools available (from agent file `tools:` field):

```
1. Read                          — Load file by exact path
2. Glob                          — Discover files by pattern
3. Grep                          — Search file contents by regex
4. mcp__exa__web_search_exa      — External semantic search (Exa MCP)
5. mcp__qmd__query               — Internal knowledge base search (QMD MCP)
```

Tool routing hierarchy (from tool-routing cheatsheet):

```
                    ┌──────────────────────────┐
                    │  What kind of question?   │
                    └───────────┬──────────────┘
                                │
              ┌─────────────────┼──────────────────┐
              │                 │                   │
     Internal KB?       External research?    Exact file match?
              │                 │                   │
         QMD MCP           Exa MCP              Grep/Glob
     (semantic over      (structured         (pattern match
      2188 md docs)      web content)         in codebase)
              │                 │                   │
              └─────────────────┼──────────────────┘
                                │
                           Read (load specific
                           file by known path)
```

#### Known Bugs in Agent File Documentation

| Bug | Location | Actual State | Impact |
|-----|----------|-------------|--------|
| **WebSearch listed as fallback** | Line 42: Tool Preferences table lists "WebSearch" as fallback for Exa. Line 53: "fall back to WebSearch without stopping." | WebSearch is NOT in the `tools:` field. It does not exist as an available tool | HIGH — false fallback path. If Exa fails, explorer has no external search. Agent may attempt WebSearch calls that produce errors or hallucinate results |
| **Glob missing from Tool Guide** | Lines 64-70: Tool Guide table lists 4 tools (Read, Grep, Exa, QMD). Glob is absent | Glob IS in the `tools:` field and IS functional | MEDIUM — explorer may underutilize file discovery. The Tool Guide is the "when to use each tool" reference — omitting Glob means explorer lacks guidance on file discovery strategy |

#### Frontier Standard

ADK: tool whitelists with typed schemas per tool. Each tool has input/output types
declared, enabling the supervisor to validate tool usage.
OpenAI Agents SDK: `allowed_tools` list with JSON schema for each tool's parameters.

#### Gap

| ID | Gap | Impact |
|----|-----|--------|
| GAP-EOT-1 | WebSearch false claim (BUG — documented above) | High |
| GAP-EOT-2 | Glob missing from Tool Guide (BUG — documented above) | Medium |
| GAP-EOT-3 | No tool-specific usage limits (e.g., max Exa calls per budget tier) | Low — Haiku may over-call Exa on lite tasks |
| GAP-EOT-4 | No Obsidian CLI for graph traversal | Low — Obsidian backlinks could enhance internal discovery but not critical |

#### S x E x Sc

| Pillar | Score | Evidence |
|--------|-------|----------|
| Sustainability | 7/10 | 5 tools are sufficient for discovery. All read-only. But: WebSearch bug creates a false safety net. If Exa goes down, explorer is blind to external sources |
| Efficiency | 7/10 | Tool set is minimal — no unused tools consuming context. But: Tool Guide omission of Glob means suboptimal tool selection |
| Scalability | 9/10 | Same 5 tools for all budget tiers. No per-mode tool changes needed. Parallel instances share no tool state |

#### UBS / UDS

| Force | ID | Description | Category |
|-------|----|-------------|----------|
| UBS | UBS-EOT-1 | WebSearch false claim — no external fallback (BUG) | Technical |
| UBS | UBS-EOT-2 | Glob missing from Tool Guide — incomplete documentation (BUG) | Technical |
| UBS | UBS-EOT-3 | No tool usage limits per budget tier | Temporal |
| UDS | UDS-EOT-1 | 5 tools cover internal + external + codebase — minimal but complete for discovery | Technical |
| UDS | UDS-EOT-2 | All tools are read-only — zero damage surface | Technical |
| UDS | UDS-EOT-3 | Exa returns structured content (fewer tokens than raw web) | Economic |

---

### 2.8 EOP — Effective Operating Procedure

#### Current State

Explorer follows a 5-step research protocol (documented in agent file):

```
Step 1: SCOPE THE QUESTION
  - What specifically needs to be answered?
  - What depth? (lite/mid/deep/full)
  - What is NOT in scope?

Step 2: SEARCH WIDE
  - Multiple query strategies per source:
    - QMD: lex (BM25 keyword) + vec (semantic) + hyde (hypothetical document)
    - Exa: structured semantic search with domain filters
    - Grep: exact pattern match across codebase
  - Minimum query count varies by depth tier

Step 3: CROSS-VALIDATE
  - Don't trust a single source
  - Look for confirming AND disconfirming evidence
  - Note contradictions explicitly

Step 4: REPORT STRUCTURED
  - Findings organized by theme
  - Source citations per claim: [N] format
  - Confidence level per claim: high/medium/low

Step 5: FLAG UNKNOWNS
  - What could NOT be found
  - What could NOT be verified
  - What questions remain open
```

Budget tiers constrain the procedure:

| Tier | Min Searches | Min Sources | Report Size |
|------|-------------|-------------|-------------|
| lite | 3-5 | 5 | 1000-3000 tokens |
| mid | 5-8 | 8 | 3000-8000 tokens |
| deep | 8-12 | 12 | 8000-15000 tokens |
| full | 12-20 | 20 | 15000-30000 tokens |

Escape hatches (from agent file + dispatching skills):

```
IF Exa unavailable  → QMD only (flag: local-sources-only)
IF QMD unavailable   → Exa only (flag: no-local-kb)
IF ALL unavailable   → STOP. Report to orchestrator. Do not generate empty research
IF WebSearch needed  → NOT AVAILABLE (BUG — agent file incorrectly claims fallback)
```

#### Frontier Standard

ADK: AutoFlow routing with tool descriptions + LoopAgent for iterative refinement.
LangGraph: state machine with typed transitions and exit conditions.

#### Gap

| ID | Gap | Impact |
|----|-----|--------|
| GAP-EOP-1 | No validation gate between steps. Explorer may skip Step 3 (cross-validation) under token pressure | Medium — uncross-validated claims reach the planner as if confirmed |
| GAP-EOP-2 | No iterative refinement. Explorer makes one pass — if findings are thin, it reports thin findings rather than refining queries | Medium — deep/full modes would benefit from a refinement loop |
| GAP-EOP-3 | False escape hatch: WebSearch fallback doesn't exist | High — see GAP-EA-1 |
| GAP-EOP-4 | No self-check before reporting. Explorer doesn't verify its own output against the output contract | Medium — some reports missing sections |

#### S x E x Sc

| Pillar | Score | Evidence |
|--------|-------|----------|
| Sustainability | 7/10 | 5-step protocol is sound. Escape hatches exist (minus WebSearch bug). But: no validation gates = steps can be skipped. No self-check = quality varies |
| Efficiency | 7/10 | Budget tiers prevent over-research. But: no iterative refinement means deep/full modes are one-shot instead of convergent |
| Scalability | 8/10 | Same protocol for all modes. Budget tiers scale naturally. But: deep/full modes need a refinement loop that lite/mid don't |

#### UBS / UDS

| Force | ID | Description | Category |
|-------|----|-------------|----------|
| UBS | UBS-EOP-1 | No validation gates between research steps | Technical |
| UBS | UBS-EOP-2 | No iterative refinement for deep/full modes | Technical |
| UBS | UBS-EOP-3 | False WebSearch escape hatch (BUG) | Technical |
| UBS | UBS-EOP-4 | No output self-check before reporting | Technical |
| UDS | UDS-EOP-1 | Budget tiers provide clear scoping per mode | Human |
| UDS | UDS-EOP-2 | Escape hatches exist for tool unavailability (minus WebSearch) | Technical |
| UDS | UDS-EOP-3 | 5-step protocol is comprehensive for research lifecycle | Technical |

---

## 3. Handoff Contracts

### 3.1 Upstream: Orchestrator --> Explorer

```
Orchestrator EI (dispatch)  ──→  Explorer (research)
───────────────────────────────────────────────────────
ORCHESTRATOR PROVIDES:        │  EXPLORER EXPECTS:
• Research question (specific) │  • Clear, scoped question
• File paths to read           │  • Exact paths (absolute if worktree)
• Search terms + strategies    │  • At least 1 keyword, 1 semantic
• Budget tier (lite/mid/deep)  │  • Explicit depth indicator
• Constraints (what NOT to do) │  • Scope boundaries
───────────────────────────────────────────────────────
QUALITY GATE:
  If research question is missing or vague:
    Explorer SHOULD scope it from available context
    Explorer SHOULD flag: "Research question was not explicit.
    I interpreted it as: [X]. If wrong, re-dispatch with
    clarified question."
```

### 3.2 Downstream: Explorer --> Planner (or --> Human Director)

```
Explorer EO (research report)  ──→  Planner EI (design context)
─────────────────────────────────────────────────────────────────
EXPLORER PROVIDES:              │  PLANNER EXPECTS:
• Findings by theme             │  • Clear answer to research Q
• Source citations [N] per claim│  • Confidence levels per claim
• Confidence: high/medium/low   │  • Unknowns explicitly flagged
• Unknowns explicitly listed    │  • >=3 cited sources for verification
• Full content (not trimmed)    │  • Structured format (parseable)
─────────────────────────────────────────────────────────────────
EP-12 VERIFICATION REQUIREMENT:
  Planner MUST verify citations exist before treating research as
  ground truth. Haiku has the highest hallucination rate of the 3
  model tiers (LT-1). Sources from explorer MUST be cross-checked.

  Verification protocol:
  1. For URLs: spot-check 2-3 URLs via WebFetch (planner has this tool)
  2. For file paths: verify via Read/Glob (planner has Read/Grep)
  3. For claims marked "low" confidence: treat as unverified hypothesis

HALLUCINATION RISK (LT-1):
  Haiku's hallucination rate means explorer may:
  - Fabricate URLs that look plausible but don't exist
  - Misattribute claims to wrong sources
  - Overstate confidence on single-source claims
  - Generate "sources" from parametric memory, not search results

  Compensation: /deep-research HARD-GATE #1 requires every factual
  claim to cite a specific source from a search result in the current
  session. Never from parametric memory. This constraint is stated in
  the dispatching skill, NOT in the agent file itself.
```

### 3.3 Parallel Dispatch Contract (N explorers)

```
Orchestrator dispatches N explorers simultaneously
──────────────────────────────────────────────────────────
Each explorer:
• Receives independent context package (no shared state)
• Operates in isolation (cannot read other explorers' output)
• Returns to orchestrator independently

Orchestrator responsibility:
• De-duplicate findings across N reports
• Resolve contradictions (same claim, different confidence)
• Synthesize themes across parallel outputs
• Track which explorer covered which subtopic

RACE CONDITION RISK: None for read-only agents. N parallel
readers cannot conflict. No shared mutable state.
```

---

## 4. Known Bugs Summary

| # | Bug | Location | Severity | Fix |
|---|-----|----------|----------|-----|
| BUG-1 | **WebSearch false claim.** Agent file states WebSearch is available as Exa fallback. WebSearch is NOT in the `tools:` field. | `.claude/agents/ltc-explorer.md` line 42 (Tool Preferences table: "WebSearch" as fallback), line 53 ("fall back to WebSearch without stopping") | HIGH — false fallback path creates unsafe assumption | Remove all WebSearch references from agent file. Update fallback: "If Exa unavailable, use QMD only. Flag: local-sources-only." |
| BUG-2 | **Glob missing from Tool Guide.** Tool Guide table (lines 64-70) lists 4 tools but omits Glob, which IS in the `tools:` field. | `.claude/agents/ltc-explorer.md` lines 64-70 (Tool Guide table) | MEDIUM — explorer underutilizes file discovery | Add Glob row to Tool Guide table |
| BUG-3 | **deep-research SKILL.md also claims WebSearch.** Line 9: `tool-preference: "Exa MCP and WebSearch are peers."` Line 14: "WebSearch finds higher-quality sources." | `.claude/skills/deep-research/SKILL.md` lines 9, 14 | MEDIUM — propagates WebSearch false claim to dispatching context | Update deep-research SKILL.md to remove WebSearch references |
| BUG-4 | **learn-research SKILL.md also claims WebSearch.** Line 13: `tool-preference: "Exa MCP and WebSearch are peers for external search."` | `.claude/skills/learn-research/SKILL.md` line 13 | MEDIUM — same propagation | Update learn-research SKILL.md |

---

## 5. Improvement Proposals

### Proposal E1: Fix WebSearch False Claim (P0, 10 min)

**What:** Remove all WebSearch references from:
1. `.claude/agents/ltc-explorer.md` (lines 42, 53)
2. `.claude/skills/deep-research/SKILL.md` (lines 9, 14)
3. `.claude/skills/learn-research/SKILL.md` (line 13)

Replace with accurate fallback chain:
```
IF Exa unavailable → QMD (internal only). Flag: local-sources-only
IF QMD unavailable → Exa (external only). Flag: no-local-kb
IF BOTH unavailable → STOP. Do not generate empty research.
```

**EP grounding:** EP-02 (Know the Physics) — do not claim capabilities that don't exist.
LT-1 risk: false tool claims can cause the agent to hallucinate tool usage.

**S x E x Sc:**
- S: Eliminates false safety net. Actual fallback path is honest.
- E: Removes wasted attempts to call nonexistent tool.
- Sc: Fix propagates to all skills that dispatch explorer.

---

### Proposal E2: Add Glob to Tool Guide Table (P0, 5 min)

**What:** Add this row to the Tool Guide table in `.claude/agents/ltc-explorer.md`:

```
| Glob | Discover files by pattern (e.g., `*.md`, `**/research/*.md`) to map directory structure or locate files across the codebase. | When you already know the exact path; use Read directly. |
```

**EP grounding:** EOP-03 (Gotchas Are Highest Signal) — missing documentation causes
repeated underutilization. EOP-07 (Don't State the Obvious) — Glob has non-obvious
use cases for research (mapping directory trees, finding all files in a subsystem).

---

### Proposal E3: Define Typed Output Contract (P1, 30 min)

**What:** Add an `OUTPUT_CONTRACT` section to `.claude/agents/ltc-explorer.md` that
specifies the exact structure of explorer's research report. See proposed schema in
section 2.4 above.

**Why:** No formal schema means report structure varies per invocation. Orchestrator
spends tokens parsing unstructured text. N parallel explorers returning variable
formats creates N parsing problems.

**EP grounding:** EP-10 (Define Done) — done means the output matches the contract.
Future EOP-13 candidate (Output Format Contract from EOP Governance v2 roadmap).

**S x E x Sc:**
- S: Consistent output = reliable downstream consumption. No more missing sections.
- E: Orchestrator can validate output programmatically instead of parsing text.
- Sc: Same schema for all budget tiers (size bounds vary, structure doesn't).

---

### Proposal E4: Add Input Completeness Check (P1, 15 min)

**What:** Add a "Pre-Flight" section to the explorer agent file that the explorer
executes BEFORE starting research:

```
## Pre-Flight (execute before Step 1)
1. Research question present? If NO → flag in output, attempt to infer from context
2. Budget tier specified? If NO → default to lite, flag in output
3. File paths provided? If NO → proceed with search-only (no local cross-reference)
4. Search terms provided? If NO → generate from research question (acceptable)
```

**EP grounding:** EP-01 (Brake Before Gas) — check inputs before starting.
EP-10 (Define Done) — if inputs are incomplete, define what "done" means given
the constraints.

---

### Proposal E5: Add Self-Check Before Reporting (P2, 15 min)

**What:** Add a "Post-Flight" section to the explorer agent file that the explorer
executes AFTER Step 5, BEFORE returning output:

```
## Post-Flight (execute before returning)
1. Findings section present? (required)
2. Sources section present with >=N citations? (N from budget tier)
3. Every [N] in findings appears in sources? (cross-reference check)
4. Confidence section present? (required)
5. Unknowns section present? (required — even if empty)
IF any check fails → fix before returning. Do not return incomplete output.
```

**EP grounding:** EP-10 (Define Done) — self-verify before claiming done.
EOP-06 (Validation Gates) — gate between research and reporting.

---

### Proposal E6: Clarify Rule Loading for Sub-Agents (P2, research needed)

**What:** Determine definitively whether `.claude/rules/` files auto-load for
sub-agents. Test empirically:

1. Dispatch explorer with a task that would violate an always-on rule
2. Check if explorer follows the rule without it being in the context package
3. Document finding in `learned_patterns.md`

**Why:** L6 (rule loading) is marked UNCERTAIN. If rules don't load, every
constraint must be in the agent file or context package. If they do load,
the agent file can be leaner.

**EP grounding:** EP-02 (Know the Physics) — understand the actual runtime
environment, not the assumed one.

---

## 6. Priority Summary

| Priority | Action | Effort | Agents/Files Affected |
|----------|--------|--------|-----------------------|
| **P0** | Fix WebSearch false claim (Proposal E1) | 10 min | ltc-explorer.md, deep-research SKILL.md, learn-research SKILL.md |
| **P0** | Add Glob to Tool Guide (Proposal E2) | 5 min | ltc-explorer.md |
| **P1** | Define typed output contract (Proposal E3) | 30 min | ltc-explorer.md |
| **P1** | Add input completeness check (Proposal E4) | 15 min | ltc-explorer.md |
| **P2** | Add self-check before reporting (Proposal E5) | 15 min | ltc-explorer.md |
| **P2** | Clarify rule loading for sub-agents (Proposal E6) | 30 min | learned_patterns.md |

---

## 7. Aggregate Scores

| Component | S | E | Sc | Top Risk |
|-----------|---|---|-----|----------|
| EI (Input) | 8 | 7 | 9 | No input validation |
| EU (User) | 9 | 9 | 9 | Haiku hallucination rate (LT-1) |
| EA (Action) | 7 | 7 | 8 | WebSearch false claim (BUG-1) |
| EO (Output) | 6 | 5 | 7 | No output schema (GAP-EO-1) |
| EP (Principles) | 9 | 8 | 9 | False escape hatch (WebSearch) |
| EOE (Environment) | 8 | 6 | 8 | Context entirely orchestrator-dependent (L4) |
| EOT (Tools) | 7 | 7 | 9 | WebSearch bug + Glob doc gap |
| EOP (Procedure) | 7 | 7 | 8 | No validation gates between steps |
| **OVERALL** | **7.6** | **7.0** | **8.4** | **EO (output schema) + EA (WebSearch bug)** |

**Interpretation:** Explorer is strongest on Scalability (parallel dispatch, minimal
footprint, read-only safety) and weakest on Efficiency (unstructured output, WebSearch
bug, missing Tool Guide entry). The highest-impact fixes are P0: WebSearch removal and
P1: typed output contract.

---

## Review Status (2026-04-08)

**Verdict:** G1 APPROVED with P0 fixes.
**Aggregate:** S=7.6, E=7.0, Sc=8.4 — strongest agent by scores.
**P0 fixes required before BUILD:**
1. Fix WebSearch false claim in `ltc-explorer.md` lines 42, 53 (BUG-1)
2. Fix WebSearch propagation in `deep-research/SKILL.md` lines 9, 14 (BUG-3)
3. Fix WebSearch propagation in `learn-research/SKILL.md` line 13 (BUG-4)
4. Add Glob to Tool Guide table in `ltc-explorer.md` lines 64-70 (BUG-2)

**Cross-agent dependency:** Explorer output schema (Proposal E3) is consumed by Planner EI. Build E3 before Planner typed input contract.

---

## Sources

### Internal
- Agent file: `.claude/agents/ltc-explorer.md` (v1.4, 2026-04-08)
- Settings: `.claude/settings.json` (hooks, permissions)
- Skills: `.claude/skills/deep-research/SKILL.md`, `.claude/skills/learn-research/SKILL.md`
- Context packaging: `.claude/skills/dsbv/references/context-packaging.md`
- Sub-agent output rule: `.claude/rules/sub-agent-output.md`
- Enforcement layers: `.claude/rules/enforcement-layers.md`
- EOP Governance: `_genesis/reference/ltc-eop-gov.md`
- Parent design: `inbox/2026-04-08_agent-system-8component-design.md`

### Learned Patterns
- LP-7: PreToolUse/PostToolUse hooks do not fire in sub-agents (Anthropic #40580)

## Links

- [[2026-04-08_agent-system-8component-design]]
- [[AGENTS]]
- [[CLAUDE]]
- [[DESIGN]]
- [[EP-01]]
- [[EP-02]]
- [[EP-08]]
- [[EP-10]]
- [[EP-12]]
- [[EP-13]]
- [[SEQUENCE]]
- [[SKILL]]
- [[VALIDATE]]
- [[context-packaging]]
- [[documentation]]
- [[enforcement-layers]]
- [[gotchas]]
- [[iteration]]
- [[learned_patterns]]
- [[ltc-builder]]
- [[ltc-eop-gov]]
- [[ltc-explorer]]
- [[ltc-planner]]
- [[ltc-reviewer]]
- [[methodology]]
- [[project]]
- [[roadmap]]
- [[schema]]
- [[session-summary]]
- [[standard]]
- [[sub-agent-output]]
- [[task]]
- [[tool-routing]]
