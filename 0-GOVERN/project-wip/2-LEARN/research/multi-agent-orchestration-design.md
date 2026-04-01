---
version: "1.1"
last_updated: 2026-03-30
owner: "Long Nguyen"
status: "Draft"
---
# Multi-Agent Orchestration Design — APEI Project Template

**EO (Expected Outcome):** Enable LTC Members (L1-L5) to operate their AI agents most effectively through deterministic enforcement, identity-separated agents, disciplined tool routing, and hypothesis-driven validation — grounded in the 7-CS framework.

**Input Research:**
- Report 1 (Opus): `~/Documents/MultiAgent_Orchestration_Research_20260329/report.md` — 40 sources
- Report 2 (Sonnet): `~/Documents/MultiAgent_Orchestration_Research_Sonnet_20260329/report.md` — 28 sources
- ADR-001: `1-ALIGN/decisions/ADR-001_dsbv-multi-agent-pattern.md` — Competing Hypotheses + Synthesis
- AMT Session 3: Input Engineering — context packaging principles
- AMT Session 6: Tools research — tool selection discipline
- System Thinking v2 (Notion): Nodes & Edges, feedback loops, leverage points

**Branch:** `feat/multi-agent-orchestration`
**Worktree:** `.claude/worktrees/multi-agent-orchestration`

---

## 1. Architectural Principle (GAN Verdict)

A GAN (Blue-Red team) analysis debated whether orchestration logic belongs in skills or agent files. The verdict is a clean 7-CS decomposition — neither report's position, but a synthesis grounded in the framework:

```
SEPARATION OF CONCERNS (7-CS Aligned)

  SKILLS own PROCESS        (EOP layer)
    What to do, when, in what order
    Phase gates, context packaging, acceptance criteria

  AGENTS own IDENTITY       (EOE layer)
    Who does it, with what model, what tools, what scope
    Deterministic enforcement via platform constraints

  HOOKS own ENFORCEMENT     (EOE layer)
    Guaranteed behavior regardless of who invoked what
    100% reliability — no alignment drift

  RULES own CONSTRAINTS     (EP layer)
    Always-on boundaries, tool routing, model routing

  TOOLS own CAPABILITY      (EOT layer)
    Best-in-class per task, ≤7 per agent
    Descriptions engineered for selection accuracy
```

**Grounding:** EP-05 (Gates Before Guides) — non-negotiable rules use deterministic mechanisms (hooks, agent file `tools:` allowlists). Judgment-dependent rules use probabilistic mechanisms (skills, CLAUDE.md).

---

## 2. Component Impact Map

All 7 components audited top-down against the 7-CS framework, EP Registry, EOP-GOV, AMT Sessions 3 and 6, and System Thinking v2 (Nodes & Edges, leverage points, feedback loops).

```
┌─────────────────────────────────────────────────────────────────┐
│                    7-CS COMPONENT AUDIT                         │
│            Current State → Multi-Agent Target                   │
├─────────────────────────────────────────────────────────────────┤
│                                                                 │
│  EP (Principles)          ← MODERATE                            │
│  ├─ CLAUDE.md             → +model_routing table (5 lines)      │
│  ├─ EP Registry           → +3 multi-agent EPs (EP-11,12,13)   │
│  ├─ EP-03                 → Extend for multi-agent RACI         │
│  ├─ agent-system.md       → Cards 1+6 multi-agent scope        │
│  └─ ADR-002               → Architecture decision record        │
│  WHY: EP-03 assumes single agent. No principle governs          │
│  cross-agent handoff (LT-1 cascade), role separation            │
│  (LT-8 per-agent drift), or orchestrator authority (UT#9).      │
│                                                                 │
│  Input (Context)          ← MODERATE                            │
│  ├─ Context packaging template for sub-agent invocation         │
│  │   (5 required fields: scope, files, constraints, ACs, verify)│
│  ├─ memory: project on planner + reviewer agents                │
│  └─ PreCompact hook fills compaction gap                        │
│  WHY: Sub-agents get ZERO parent history. Session 3 says        │
│  "prompt is 5% of tokens, 95% is where failures originate."    │
│  Without structured packaging, skills spawning agents pass      │
│  ad-hoc context — violating EP-07 (Amnesia-First) and          │
│  EP-08 (Signal Over Volume).                                    │
│                                                                 │
│  EOP (Skills)             ← MODERATE                            │
│  ├─ /dsbv                 → Reference agent files, not inline   │
│  ├─ /ltc-brainstorming    → Reference ltc-planner agent         │
│  ├─ /deep-research        → Prefer Exa, reference ltc-explorer  │
│  ├─ /ltc-execution-planner→ Demote to sub-skill of /dsbv build  │
│  ├─ /ltc-task-executor    → Demote to sub-skill of /dsbv build  │
│  └─ /ltc-writing-plans    → Demote to sub-skill of /dsbv seq    │
│  WHY: Skills keep orchestration logic (EOP governance intact).  │
│  Change is HOW they spawn agents — reference files instead of   │
│  inline definitions. 3 skills become sub-skills of /dsbv to     │
│  eliminate user confusion about entry points.                   │
│                                                                 │
│  EOE (Environment)        ← MAJOR ⚡                            │
│  ├─ .claude/agents/       → 4 agent role files (NEW directory)  │
│  ├─ .claude/hooks/        → +3 new bash scripts                 │
│  ├─ .claude/settings.json → hooks + Agent Teams flag + model env│
│  └─ Permissions           → Update for agent tool scopes        │
│  WHY: This is the main work. Enforcement moves from ~85%        │
│  (CLAUDE.md) to 100% (hooks + agent files). EP-05 demands it.  │
│                                                                 │
│  EOT (Tools)              ← MODERATE                            │
│  ├─ rules/tool-routing.md → Task → best tool + fallback + cost  │
│  ├─ Agent file allowlists → ≤7 tools per agent                 │
│  ├─ Skill updates         → deep-research, learn-research → Exa│
│  └─ Tool descriptions     → "when to use / when NOT to use"    │
│  WHY: Session 6: "3-7 well-scoped tools outperform 15+."       │
│  Tool routing IS model routing's counterpart — both reduce      │
│  tokens consumed. Together = full cost discipline layer.         │
│                                                                 │
│  Agent (Model)            ← MODERATE                            │
│  ├─ Model routing enforcement (agent file model: fields)        │
│  ├─ CLAUDE_CODE_SUBAGENT_MODEL or documented absence            │
│  ├─ Multi-provider ADR position                                 │
│  │   Safe now: tool layer (Gemini via AntiGravity, Exa MCP)    │
│  │   Safe with ADR: sub-agent layer (needs LT-8 audit/provider)│
│  │   Deferred I2: GLM 5.1, Kimi 2.5, etc.                     │
│  └─ agent-system.md Card 6 update                              │
│  WHY: Routing is prose-only (~85% reliability). LT-7 is         │
│  materializing (Anthropic usage squeeze). Framework already     │
│  lists GPT-4o/Gemini in Card 6 — not Claude-only by design.    │
│  But LT-8 profiles differ per provider — unsafe without audit.  │
│                                                                 │
│  EA (Action)              ← NONE (emergent)                     │
│  └─ Improved EA is the OUTCOME of fixing all above              │
│                                                                 │
└─────────────────────────────────────────────────────────────────┘
```

---

## 3. MECE Agent Roster

Four agents, mapped to DSBV phases, with clear scope boundaries:

| Agent | DSBV Phase | Cognitive Mode | Model | Tools (≤7) |
|---|---|---|---|---|
| `ltc-planner` | Design + Sequence | Architect | Opus | Read, Grep, Exa, QMD, WebFetch |
| `ltc-builder` | Build | Craftsman | Sonnet | Read, Edit, Write, Bash, Grep |
| `ltc-reviewer` | Validate | Judge | Opus | Read, Glob, Grep, Bash |
| `ltc-explorer` | Pre-DSBV | Scout | Haiku | Read, Glob, Grep, QMD, Exa |

### Scope Boundaries (MECE)

```
ltc-planner   DSBV Design + Sequence; writing-plans; execution-planner (Stage 4);
              WMS sync; naming; skill-creator; session mgmt; learn orchestration

ltc-builder   DSBV Build (all zones); task-executor (Stage 5); learn:visualize;
              brand-identity enforcement; all artifact production

ltc-reviewer  DSBV Validate; rules-compliance; learn:review; feedback capture;
              all quality gates

ltc-explorer  Pre-DSBV; deep-research; learn:research; root-cause tracing;
              brainstorming (search + diverge phase only)
```

### Skill Consolidation

Three skills become sub-skills of `/dsbv` (keep files, remove standalone triggers):

| Skill | Current | After |
|---|---|---|
| `/ltc-execution-planner` | Standalone entry point | Sub-skill of `/dsbv build execute` |
| `/ltc-task-executor` | Standalone entry point | Sub-skill of `/dsbv build execute` |
| `/ltc-writing-plans` | Standalone entry point | Sub-skill of `/dsbv sequence` |

---

## 4. New EP Principles

### EP-11: Agent Role Separation [DERISK]

**Component:** EOE (multi-agent coordination)
**Statement:** Each agent has a declared scope boundary; cross-boundary actions require explicit handoff protocol.
**Grounded in:** LT-8 (alignment drift per agent) + LT-3 (reasoning degrades when scope is too broad)
**Without this:** ltc-builder starts doing design work because nothing enforces scope. Two agents modify the same file concurrently.
**Compensated by:** Agent file `tools:` allowlist (deterministic), skill routing (probabilistic).

### EP-12: Verified Handoff [DERISK]

**Component:** Input (inter-agent context)
**Statement:** Output passing between agents must pass the receiving agent's acceptance criteria before being treated as ground truth.
**Grounded in:** LT-1 (hallucination in Agent A becomes ground truth for Agent B) + LT-5 (plausible ≠ true across agent boundaries)
**Without this:** Agent A hallucinates a requirement. Agent B builds it faithfully. The defect is invisible until human review.
**Compensated by:** SubagentStop hook (deterministic verification), context packaging template (structured handoff).

### EP-13: Orchestrator Authority [OUTPUT]

**Component:** Agent (multi-agent governance)
**Statement:** Exactly one orchestrator agent owns task decomposition and result synthesis. Sub-agents are Responsible only, never Accountable. Human Director remains Accountable.
**Grounded in:** UT#9 (R ≠ A) + EP-03 extension for multi-agent RACI.
**Without this:** Two agents both decompose the same task differently. No single point of synthesis. Outputs conflict.
**Compensated by:** DSBV skill as orchestrator (EOP), lead agent model selection (EOE).

---

## 5. Delivery Approach: Hypothesis-Driven with Eval Gates (Approach D)

Nothing ships without evidence. Each slice is framed as a hypothesis with a measurable test.

### Phase 0: Baseline Capture

Before any changes, run control measurements:
- One `/deep-research` cycle (current WebSearch, current inline spawning)
- Record: token count, tool calls, search retries, wall-clock time, cost ($)
- Store in `5-IMPROVE/metrics/multi-agent-eval/baseline.md`

### Foundation: EOE Enforcement Layer

| # | Artifact | File Path |
|---|---|---|
| F1 | SubagentStop hook | `.claude/hooks/verify-deliverables.sh` |
| F2 | PreCompact hook | `.claude/hooks/save-context-state.sh` |
| F3 | SessionStart hook | `.claude/hooks/resume-check.sh` |
| F4 | settings.json updates | `.claude/settings.json` |
| | ├─ 3 hook event registrations | |
| | ├─ Agent Teams flag | |
| | └─ CLAUDE_CODE_SUBAGENT_MODEL | |
| F5 | Baseline capture | `5-IMPROVE/metrics/multi-agent-eval/baseline.md` |

### Slice 1: Build + Review Pair

| # | Artifact | File Path |
|---|---|---|
| S1.1 | ltc-builder agent file | `.claude/agents/ltc-builder.md` |
| S1.2 | ltc-reviewer agent file | `.claude/agents/ltc-reviewer.md` |
| S1.3 | /dsbv skill update | `.claude/skills/dsbv/SKILL.md` |
| S1.4 | /ltc-execution-planner demote | `.claude/skills/process/ltc-execution-planner/SKILL.md` |
| S1.5 | Multi-agent build reference | `.claude/skills/dsbv/references/multi-agent-build.md` |

**HYPOTHESIS 1:** Agent files with `tools:` allowlists reduce token waste vs inline definitions.
- A = `/dsbv build` with current inline spawning (control)
- B = `/dsbv build` using agent file spawning (treatment)
- **Gate:** B ≥ A on 3/5 metrics (tokens, tool accuracy, model compliance, quality, time)

### Slice 2: Planner + Explorer Pair

| # | Artifact | File Path |
|---|---|---|
| S2.1 | ltc-planner agent file | `.claude/agents/ltc-planner.md` |
| S2.2 | ltc-explorer agent file | `.claude/agents/ltc-explorer.md` |
| S2.3 | /ltc-brainstorming update | `.claude/skills/process/ltc-brainstorming/SKILL.md` |
| S2.4 | /deep-research update (Exa) | `.claude/skills/research/deep-research/SKILL.md` |
| S2.5 | /learn-research update (Exa) | `.claude/skills/learning/learn-research/SKILL.md` |

**HYPOTHESIS 2:** Exa MCP + QMD reduce search tokens vs WebSearch + Grep for research tasks.
- A = `/deep-research` using WebSearch + Grep (control)
- B = `/deep-research` using Exa + QMD (treatment)
- **Gate:** ≥30% token reduction on search operations

### Slice 3: Input & Context Engineering

| # | Artifact | File Path |
|---|---|---|
| S3.1 | Context packaging template | `.claude/skills/dsbv/references/context-packaging.md` |
| S3.2 | Update all agent-spawning skills | (5 skills referenced in Slice 1 + 2) |

**HYPOTHESIS 5:** Structured context packaging reduces sub-agent failures vs ad-hoc prompting.
- A = Current inline spawning (no template)
- B = Template-driven spawning (5 required fields)
- **Gate:** Sub-agent retry rate decreases; output quality ≥ A

### Slice 4: Tool Routing & Descriptions

| # | Artifact | File Path |
|---|---|---|
| S4.1 | Tool routing rule | `rules/tool-routing.md` |
| S4.2 | Tool boundary descriptions | (in each agent file's system prompt) |

### Slice 5: EP Evolution & ADR

| # | Artifact | File Path |
|---|---|---|
| S5.1 | EP-11: Agent Role Separation | `_genesis/reference/ltc-effective-agent-principles-registry.md` |
| S5.2 | EP-12: Verified Handoff | (same file) |
| S5.3 | EP-13: Orchestrator Authority | (same file) |
| S5.4 | ADR-002 | `1-ALIGN/decisions/ADR-002_multi-agent-architecture.md` |
| S5.5 | EP-03 extension | (EP Registry) |
| S5.6 | agent-system.md updates | `rules/agent-system.md` |

### Finalize

| # | Artifact | File Path |
|---|---|---|
| FIN.1 | CLAUDE.md model routing table | `CLAUDE.md` |
| FIN.2 | Complete tool routing table | `rules/tool-routing.md` (with measured data) |
| FIN.3 | Eval results | `5-IMPROVE/metrics/multi-agent-eval/` |
| FIN.4 | Interactive HTML visualization | `4-EXECUTE/docs/multi-agent-orchestration-map.html` |
| FIN.5 | CHANGELOG update | `5-IMPROVE/changelog/CHANGELOG.md` |
| FIN.6 | VERSION bump | `VERSION` |

---

## 6. Dependency Chain

```
Foundation (hooks + baseline)
    ↓
Slice 1 ──┐
           ├── can parallelize (independent agent pairs)
Slice 2 ──┘
    ↓
Slice 3 (context template — needs agent files to exist)
    ↓
Slice 4 (tool routing — needs Exa results from H2)
    ↓
Slice 5 (EPs + ADR — needs evidence from all hypotheses)
    ↓
Finalize (aggregate results, visualization, CHANGELOG, VERSION)
```

---

## 7. Visualization Specification

Interactive HTML showing the full 7-CS as Nodes & Edges (per System Thinking v2).

**Nodes:** EP, Input, EOP, EOE, EOT, Agent(×4), EA → EO
**Edges:** Interactions between components (constrains, feeds, orchestrates, enforces, extends, produces, yields, feedback)

**Agent Detail (expandable):**
- ltc-planner → spawns ltc-builder (via /dsbv build)
- ltc-planner → spawns ltc-explorer (via /learn-research)
- ltc-builder → output → ltc-reviewer (via /dsbv validate)
- ltc-explorer → output → ltc-planner (via /learn-structure)

**Progress Tracking per Node:**
- Status: Planned │ In Progress │ Complete
- Hypothesis: which H# tests this component
- Click → artifact list + A/B results

**Leverage Points (highlighted):**
- EOE hooks = balancing loop (prevents drift, LT-8 compensation)
- Agent memory: project = reinforcing loop (agents improve over iterations)
- Tool routing = leverage point (small config → large token savings)

**Brand:** Midnight Green #004851, Gold #F2C75C, Inter font.

---

## 8. Multi-Provider Position

**Framework basis:** agent-system.md Card 6 already lists `GPT-4o, Gemini` alongside Claude. EP-06 Step 7 names cross-platform as a design step. LTC runs Claude Code + AntiGravity (Gemini) today.

**LT-8 constraint:** Each provider has different RLHF training. EP compliance at ~95% on Claude may be ~70% on another provider. Unsafe without per-provider LT audit.

| Scope | Status | Rationale |
|---|---|---|
| Multi-provider at **tool layer** (Exa, AntiGravity) | SAFE NOW | Already validated in LTC practice |
| Multi-provider at **sub-agent layer** (OpenRouter) | NEEDS ADR | LT-8 profiles differ per provider |
| Specific providers (GLM 5.1, Kimi 2.5) | DEFERRED I2 | Requires LT-8 audit + tool compatibility check |

---

## 9. Totals

```
ARTIFACTS:    31 (5 Foundation + 5+5 Slices 1-2 + 2+2+6 Slices 3-5 + 6 Finalize)
HYPOTHESES:   4 (H0 baseline + H1 agent files + H2 Exa/QMD + H5 context packaging)
COMPONENTS:   6 of 7 touched (EP, Input, EOP, EOE, EOT, Agent)
ZONES:        Zone 0 (primary), Zone 1 (ADR), Zone 4 (metrics), Shared (_genesis)
PR:           Single PR from feat/multi-agent-orchestration → APEI-Project-Repo
```
