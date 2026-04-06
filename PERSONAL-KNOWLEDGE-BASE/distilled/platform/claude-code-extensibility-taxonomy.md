---
version: "2.0"
status: Draft
last_updated: 2026-04-05
topic: platform
source: captured/claude-code-docs-full.md
review: true
review_interval: 7
questions_answered:
  - so_what_relevance
  - what_is_it
  - what_else
  - how_does_it_work
  - why_does_it_work
  - why_not
  - so_what_benefit
  - now_what_next
---

# Claude Code Extensibility Taxonomy

Claude Code ships with a built-in agentic loop and file/search/execution tools that cover most coding tasks. When those defaults are not enough, an extension layer lets you customize what Claude knows, connect it to external services, and automate workflows. This page maps that extension layer: the six features, how they compare, how they layer, and how they combine.

## L1 — Knowledge

### So What? (Relevance)

Every custom behavior you want from Claude Code must be delivered through one of six extension points. Choosing the wrong one wastes context, breaks automation, or creates unnecessary friction. A mental model of the taxonomy lets you reach for the right tool on the first attempt — no trial-and-error between "should I use a skill or a hook?" or "why is my CLAUDE.md bloated?"

### What Is It?

The extension layer consists of six features that plug into different parts of the agentic loop:

| Feature | What it does | When to use |
|---------|-------------|-------------|
| **CLAUDE.md** | Persistent context loaded every session | Project conventions, "always do X" rules |
| **Skills** | Instructions, knowledge, and invocable workflows | Reusable content, reference docs, repeatable tasks |
| **MCP** | Protocol connecting Claude to external services | External data or actions (database, Slack, browser) |
| **Subagents** | Isolated execution context returning a summary | Context isolation, parallel tasks, specialized workers |
| **Agent teams** | Multiple independent Claude Code sessions coordinating | Parallel research, competing hypotheses, large feature work |
| **Hooks** | Deterministic scripts triggered by lifecycle events | Predictable automation with no LLM involved |

**Plugins** are the packaging layer — a plugin bundles skills, hooks, subagents, and MCP servers into one installable unit with namespaced commands (e.g., `/my-plugin:review`).

### What Else?

**Skills are the most flexible extension.** A skill is a markdown file containing knowledge, workflows, or instructions. It can be invoked explicitly (`/deploy`), loaded automatically by Claude when relevant, or run in isolated context via a subagent.

**Rules (`.claude/rules/`)** are a sub-feature of the CLAUDE.md system — they extend always-on context with path-scoping so language- or directory-specific guidelines only load when relevant files are opened.

**Marketplaces** allow plugins to be distributed and discovered. The packaging + distribution stack is: skill/hook/MCP → plugin → marketplace.

### How Does It Work?

**Feature selection:** Each extension plugs into a distinct slot in the loop:
- CLAUDE.md / Rules → system context, always-on
- Skills → knowledge/workflow layer, on-demand
- MCP → tool layer, external connections
- Subagents / Agent teams → execution layer, isolated context
- Hooks → event layer, outside the loop entirely

**Layering rules** (when the same feature is defined at multiple levels):

| Feature | Layering behavior |
|---------|-----------------|
| CLAUDE.md files | Additive — all levels contribute simultaneously; more specific wins on conflict |
| Skills | Override by name — managed > user > project priority |
| Subagents | Override by name — managed > CLI flag > project > user > plugin |
| MCP servers | Override by name — local > project > user |
| Hooks | Merge — all registered hooks fire regardless of source |

**Comparison: features that seem similar**

*CLAUDE.md vs Skill:* CLAUDE.md loads every session automatically; a skill loads on demand. CLAUDE.md cannot trigger workflows; a skill can via `/<name>`. Rule of thumb: CLAUDE.md under 200 lines — move reference material to skills.

*CLAUDE.md vs Rules vs Skill:* Rules add path-scoping to always-on content. Skills are task-specific and on-demand only.

*Skill vs Subagent:* A skill is reusable content that loads into any context. A subagent is an isolated worker — it may preload specific skills, do extensive work, and return only a summary to the main session.

*Subagent vs Agent team:* Subagents report only to their caller; the main agent manages all work. Agent teammates message each other directly and self-coordinate via a shared task list. Agent teams cost more (each teammate is a separate Claude instance) but handle collaborative, multi-hypothesis work.

*MCP vs Skill:* MCP provides the capability to interact with an external system. A skill provides the knowledge of how to use that system effectively. They solve different problems and combine naturally.

## L2 — Understanding

### Why Does It Work?

The taxonomy works because each feature is scoped to a distinct concern: persistence vs. on-demand, deterministic vs. probabilistic, external vs. internal, isolated vs. shared. Because there is minimal overlap in what each feature does well, combining them produces additive value with little conflict.

The layering rules (additive for CLAUDE.md, override-by-name for skills and MCP, merge for hooks) are consistent with each feature's nature: context benefits from accumulation, named capabilities need a single winner to avoid ambiguity, and automation side-effects should all fire.

### Why Not?

**Failure mode — wrong feature for the job:**
- Using CLAUDE.md for content Claude only needs occasionally bloats every request and degrades context quality.
- Using a skill when a hook is appropriate introduces LLM variability into what should be deterministic automation.
- Using a subagent when a skill suffices creates unnecessary token cost.

**Failure mode — over-extension:**
Too many skills, MCP servers, or rules fill the context window. Claude may fail to trigger the right skill (vague descriptions, overlapping names), miss conventions (noise drowning signal), or hallucinate MCP tool calls for tools that silently disconnected.

**Failure mode — agent teams prematurely:**
Agent teams are experimental and disabled by default. Token cost is significantly higher. Use subagents until you hit context limits or find subagents need to communicate with each other — then transition.

## L3 — Application

### So What? (Benefit)

The taxonomy eliminates decision fatigue for custom workflows. Given a goal, map it to the correct slot in one step: "always-on? → CLAUDE.md / rules. On-demand knowledge or trigger? → skill. External service? → MCP. Context isolation or parallel? → subagent. Deterministic side effect? → hook."

### Now What? (Next Actions)

For any new customization need, run this decision tree:
1. Should Claude always know this? → CLAUDE.md (core) or rules (path-scoped)
2. Is it reference material or a triggerable workflow Claude needs sometimes? → skill
3. Does it require connecting to an external service? → MCP (+ optional skill for usage knowledge)
4. Does it need context isolation or parallel execution? → subagent (isolated result) or agent team (collaborative)
5. Is it a deterministic side effect with no LLM involvement? → hook
6. Reusing across repos or distributing? → plugin

Combination patterns to internalize:
- CLAUDE.md + skills: always-on rules + on-demand reference
- Skill + MCP: workflow knowledge + external capability
- Skill + subagent: skill spawns isolated workers for parallel audit
- Hook + MCP: deterministic trigger → external action (e.g., Slack on file edit)

## Sources

- Claude Code docs — "Extend Claude Code" (features overview): `captured/claude-code-docs-full.md` lines 10375–10666
- Direct URL: https://code.claude.com/docs/en/features-overview

## Links

[[claude-code-context-costs]]
[[claude-code-fullscreen-rendering]]
[[claude-code-skills]]
[[claude-code-hooks]]
[[claude-code-mcp]]
