---
version: "1.0"
status: draft
last_updated: 2026-04-08
type: design-proposal
work_stream: 0-GOVERN
iteration: 1
title: "Agent System 8-Component Design — Full Pipeline Redesign"
---

# Agent System 8-Component Design

> **Purpose:** Define each LTC agent as a complete effective system (UT#1) using the 8-component model. Each agent's EO is the next agent's EI — the pipeline is only as strong as its weakest handoff.
>
> **Format:** CODE learning framework (Knowledge → Understanding → Wisdom → Expertise)
>
> **Research base:** Internal usage audit (QMD sessions, git history, 2013 session logs) + frontier patterns (20+ sources, Jan-Apr 2026: Google ADK, Anthropic Claude SDK, OpenAI Agents SDK, LangGraph, CrewAI, AutoGen, Ruflo)
>
> **Governing equation:** Success = Efficient & Scalable Management of Failure Risks (UT#5)
> **Evaluation criteria:** Sustainability > Efficiency > Scalability (DT#1)
> **RACI:** Human Director = A, Main Session = C (orchestrator), Sub-Agents = R

---

## C1: KNOWLEDGE — What Is the Agent System?

### The Pipeline

```
                    ┌─────────────────── DSBV Pipeline ───────────────────┐
                    │                                                      │
  Human    ──EI──→  Explorer  ──EO/EI──→  Planner  ──EO/EI──→  Builder  ──EO/EI──→  Reviewer  ──EO──→  Human
  Director          (haiku)               (opus)               (sonnet)              (opus)             Director
                    Research              Design+Seq           Artifacts             VALIDATE.md
                    │                     │                    │                      │
                    └─ Pre-DSBV           └─ Phase 1+2         └─ Phase 3             └─ Phase 4
```

**Orchestrator:** The main Claude Code session (Opus, all tools including Agent()). This is NOT a sub-agent — it IS the supervisor. All 4 agents are leaf nodes dispatched by the main session.

**Pattern match:** Supervisor/Hierarchical (68% of production systems — dominant pattern per frontier research). Contains:
- Sequential pipeline (DSBV phases)
- Parallel fan-out (competing hypotheses in Build; multi-topic in Learn)
- Generator/Critic loop (Builder→Reviewer until VALIDATE passes)

### The 4+1 Agents

| # | Agent | Model | Role | Pipeline Position | Tools |
|---|-------|-------|------|-------------------|-------|
| 0 | **Main Session** (orchestrator) | Opus | Decompose, dispatch, synthesize, approve | Root — supervises all | All (incl. Agent()) |
| 1 | **ltc-explorer** | Haiku | Scout — find information fast and cheap | Pre-DSBV + LEARN pipeline | Read, Glob, Grep, Exa, QMD |
| 2 | **ltc-planner** | Opus | Architect — define what to build and in what order | DSBV Phase 1 (Design) + Phase 2 (Sequence) | Read, Grep, WebFetch, Exa, QMD |
| 3 | **ltc-builder** | Sonnet | Maker — produce artifacts per approved sequence | DSBV Phase 3 (Build) | Read, Edit, Write, Bash, Grep |
| 4 | **ltc-reviewer** | Opus | Judge — verify output against DESIGN.md criteria | DSBV Phase 4 (Validate) | Read, Glob, Grep, Bash |

### Current State (2026-04-08)

Agents are dispatched regularly (near-daily) by the Human Director across sessions. The internal audit incorrectly concluded "zero dispatches" by searching for formal completion reports in QMD — a methodological error (absence of evidence ≠ evidence of absence). Agent dispatches occur within conversation sessions and are not logged to QMD in a structured format. The `draft` status in version-registry refers to the agent *file* status, not deployment status.

---

## C2: UNDERSTANDING — How Does Each Agent Work?

### Agent 0: Main Session (Orchestrator)

> Not a sub-agent. This is the user's conversation partner — the root of the hierarchy.

#### 8-Component Design

| Component | Current State | Frontier Standard | Gap |
|-----------|--------------|-------------------|-----|
| **EI** (Input) | User messages + CLAUDE.md + rules/ + memory + hooks | Explicit orchestration state tracking (ADK session.state, LangGraph graph state) | **GAP:** No formal orchestration state. Main session relies on conversation history — lossy (LT-2) and expensive (LT-7). Pipeline progress lives in the user's head or in version-registry.md |
| **EU** (User) | Claude Opus 4.6 (1M context). RACI: C (Consulted by sub-agents, orchestrates R agents). A = Human Director | Same | — |
| **EA** (Action) | Reads user intent → decomposes into DSBV phases → dispatches agents → receives EO → synthesizes → presents for human approval | ADK: AutoFlow routing based on agent descriptions. LangGraph: explicit state machine transitions | **GAP:** Dispatch is ad-hoc (user invokes /dsbv, main session follows skill). No state machine. No automatic routing. |
| **EO** (Output) | Synthesized artifacts + VALIDATE.md approval recommendation | Same + metrics dashboard (token cost, success rate per agent) | **GAP:** No cost tracking, no success metrics |
| **EP** (Principles) | CLAUDE.md (200-line routing index) + 12 always-on rules + 14 EPs | Same | Adequate — but 6 rule files referenced in CLAUDE.md don't exist (agent-system.md, tool-routing.md, agent-diagnostic.md, general-system.md, security-rules.md, brand-identity.md) |
| **EOE** (Environment) | Claude Code CLI + hooks + settings.json permissions | Same + orchestration state store (persistent across dispatches) | **GAP:** No persistent orchestration state between dispatches |
| **EOT** (Tools) | All tools (Agent, Read, Write, Edit, Bash, Grep, Glob, MCP servers) | Same | Adequate |
| **EOP** (Procedure) | /dsbv skill (4-phase guided flow with G1-G4 gates) | Same + circuit breaker (auto-escalate to human if agent failure rate > threshold) | **GAP:** No circuit breaker. If builder fails repeatedly, user must notice manually |

#### S×E×Sc Evaluation

| Pillar | Score | Evidence |
|--------|-------|----------|
| **Sustainability** | 7/10 | Human gates (G1-G4) prevent cascade. But: no circuit breaker, no error budget tracking. If an agent hallucinates, the main session may not catch it. |
| **Efficiency** | 5/10 | No orchestration state → repeated context loading. No cost tracking → unknown budget burn. 6 missing rule files = incomplete EP → main session reads what's available, guesses the rest. |
| **Scalability** | 6/10 | 4 MECE agents scale horizontally (parallel builders). But: no agent pooling (each dispatch is fresh), no handoff schema validation. |

#### UBS (What Blocks)

| UBS | Category | Impact | Mitigation |
|-----|----------|--------|------------|
| UBS-O1: No orchestration state | Technical | Main session forgets pipeline progress on context rotation | Add /dsbv status as formal state check; consider persistent state file |
| UBS-O2: 6 missing rule files | Technical | EP is incomplete — orchestrator can't enforce what it hasn't loaded | Create the 6 missing rule files |
| UBS-O3: No cost/success metrics | Economic | Can't optimize what you don't measure. Daily dispatches accumulate cost without visibility | Add per-dispatch cost logging |
| UBS-O4: No circuit breaker | Temporal | Agent failure loops burn tokens until human notices | Add max-retry + auto-escalation to /dsbv build |

#### UDS (What Drives)

| UDS | Category | Leverage |
|-----|----------|---------|
| UDS-O1: Context packaging protocol | Technical | 5-field template standardizes handoffs — already best-in-class vs. industry |
| UDS-O2: Human gates (G1-G4) | Human | Director approval at each phase boundary prevents cascade (aligns with ADK Human-in-Loop pattern) |
| UDS-O3: MECE agent roster | Technical | 4 agents with zero overlap = no "Bag of Agents" anti-pattern |

---

### Agent 1: ltc-explorer (Scout)

#### 8-Component Design

| Component | Current State | Frontier Standard | Gap |
|-----------|--------------|-------------------|-----|
| **EI** (Input) | Context-packaged prompt: EO + research question + files to read + search terms + budget | ADK: task description + output_key + search scope | Adequate — context packaging is more structured than ADK's approach |
| **EU** (User) | Haiku model. RACI: R (research). Cannot dispatch further agents (leaf node) | Same | — |
| **EA** (Action) | Multi-source search: Exa (external) → QMD (internal) → Grep (exact match). Cross-validates findings. Reports with confidence levels | ADK: tool-based routing with description-matching | **BUG:** Agent file claims "WebSearch" available but it's not in tool list. Tool Guide table missing Glob entry |
| **EO** (Output) | Structured research report: themes + sources + confidence + unknowns. Full content (not trimmed — orchestrator needs it) | Same + typed output contract (explicit schema) | **GAP:** No formal output schema. Report structure varies per invocation |
| **EP** (Principles) | EP-10 (Define Done), EP-01 (Brake Before Gas). "Scout, not Decision-Maker" | Same | Adequate |
| **EOE** (Environment) | Haiku model, read-only tools, no file creation | Same | Adequate — cheapest tier for discovery |
| **EOT** (Tools) | Read, Glob, Grep, mcp__exa__web_search_exa, mcp__qmd__query | Same + potentially obsidian-cli for graph traversal | **CONSIDER:** Add obsidian-cli for backlink traversal? Currently only available via /obsidian skill |
| **EOP** (Procedure) | 5-step research protocol: scope → search wide → cross-validate → report → flag unknowns | ADK: tool description + AutoFlow routing | Adequate |

#### S×E×Sc Evaluation

| Pillar | Score | Evidence |
|--------|-------|----------|
| **Sustainability** | 8/10 | Read-only tools prevent damage. Haiku = cheap to retry. Leaf node = no nesting risk. |
| **Efficiency** | 7/10 | Haiku is cost-optimal for search. But: no output schema means orchestrator must parse unstructured text. |
| **Scalability** | 9/10 | Parallel dispatch works (learn-research spawns N explorers). Haiku handles high throughput. |

#### UBS/UDS

| Force | ID | Description | Category |
|-------|----|-------------|----------|
| UBS | UBS-E1 | WebSearch claim in agent file is false — tool doesn't exist | Technical |
| UBS | UBS-E2 | No output schema — report structure varies | Technical |
| UBS | UBS-E3 | Glob missing from Tool Guide table (tool IS available) | Technical |
| UDS | UDS-E1 | Cheapest agent (Haiku) — cost-optimal for wide-net search | Economic |
| UDS | UDS-E2 | Parallel dispatch proven (learn-research skill) | Technical |
| UDS | UDS-E3 | 5 research tools cover internal + external knowledge | Technical |

#### Handoff Contract: Explorer → Planner

```
Explorer EO (research findings)  ──→  Planner EI (design context)
─────────────────────────────────────────────────────────────────
MUST PROVIDE:                    │  PLANNER EXPECTS:
• Structured findings by theme   │  • Clear answer to research Q
• Source citations per claim     │  • Confidence levels per claim
• Confidence: high/medium/low    │  • Unknowns explicitly flagged
• Unknowns explicitly listed     │  • Sources for verification
─────────────────────────────────────────────────────────────────
EP-12 CHECK: Planner must verify citations exist before treating
research as ground truth. LT-1 risk: explorer may hallucinate
sources (haiku has highest hallucination rate of the 3 tiers).
```

---

### Agent 2: ltc-planner (Architect)

#### 8-Component Design

| Component | Current State | Frontier Standard | Gap |
|-----------|--------------|-------------------|-----|
| **EI** (Input) | Explorer research output + charter + prior decisions + DSBV process doc + reference specs | ADK: supervisor task description + output_key + routing table | Adequate |
| **EU** (User) | Opus model. RACI: C (Consulted — synthesizes and advises, human decides). Cannot write files | Same | — |
| **EA** (Action) | Draft DESIGN.md (artifact inventory + success rubrics + ACs). Draft SEQUENCE.md (dependency map + task ordering + sizing) | ADK: supervisor routing + task decomposition | **BUG:** EP-13 claims "orchestrator authority — MAY dispatch agents" but agent has NO Agent() tool. False claim creates confusion |
| **EO** (Output) | DESIGN.md + SEQUENCE.md content returned to main session. Main session writes to disk | ADK: supervisor returns typed output + routing decision | **GAP:** No Write tool → planner returns content as text, main session must extract and save. This is a 2-step process where text could be lost (LT-2) |
| **EP** (Principles) | EP-10 (Define Done), EP-05 (Gates Before Guides), EP-09 (Decompose). Alignment check: condition↔artifact mapping | Same | Adequate |
| **EOE** (Environment) | Opus model, read-only + research tools | Same | **CONSIDER:** Should planner have Write/Edit to directly produce DESIGN.md/SEQUENCE.md? Or is the 2-step handoff (planner returns → main session writes) intentional for human gate? |
| **EOT** (Tools) | Read, Grep, WebFetch, Exa, QMD | Same | **Missing:** No Glob for file discovery. Planner can't verify if referenced files exist on disk |
| **EOP** (Procedure) | 5-step design process + alignment check. Synthesis protocol for multi-agent output (score per criterion per draft) | ADK: supervisor pattern + description-based routing | Adequate |

#### S×E×Sc Evaluation

| Pillar | Score | Evidence |
|--------|-------|----------|
| **Sustainability** | 6/10 | EP-13 contradiction creates confusion. No Write tool = 2-step handoff (fragile). But: Opus model = highest reasoning quality |
| **Efficiency** | 5/10 | Opus for design is appropriate (high-stakes). But: returns full content as text → main session must parse and write → double token cost. No Glob = can't verify file existence |
| **Scalability** | 4/10 | Single planner bottleneck. Cannot dispatch agents despite EP-13 claim. Synthesis requires loading ALL drafts into one context (expensive) |

#### UBS/UDS

| Force | ID | Description | Category |
|-------|----|-------------|----------|
| UBS | UBS-P1 | EP-13 claims orchestrator authority but Agent() tool not available — **BUG** | Technical |
| UBS | UBS-P2 | No Write/Edit tools → 2-step handoff to main session for file creation | Technical |
| UBS | UBS-P3 | No Glob tool → can't verify file existence during design | Technical |
| UBS | UBS-P4 | Single planner = bottleneck for synthesis of N builder drafts | Temporal |
| UDS | UDS-P1 | Opus model = best reasoning for design decisions | Technical |
| UDS | UDS-P2 | Alignment check (condition↔artifact mapping) prevents orphan criteria | Technical |
| UDS | UDS-P3 | Synthesis protocol (score per criterion, not holistic) is best practice | Technical |

#### Handoff Contract: Planner → Builder

```
Planner EO (DESIGN.md + SEQUENCE.md)  ──→  Builder EI (task to execute)
──────────────────────────────────────────────────────────────────────────
MUST PROVIDE:                          │  BUILDER EXPECTS:
• Per-artifact binary ACs              │  • Clear task ID from SEQUENCE.md
• Task ordering with dependencies      │  • Input files with Read/Write labels
• Sizing (≤1hr human-equivalent/task)  │  • Budget (token/scope boundary)
• File paths for Read + Write targets  │  • Constraints (what NOT to do)
──────────────────────────────────────────────────────────────────────────
EP-12 CHECK: Builder must verify DESIGN.md and SEQUENCE.md exist on
disk before starting. If missing = handoff failed. STOP + report.

FRONTIER PATTERN (ADK output_key): Each task in SEQUENCE.md should
have a unique output_key equivalent — a named artifact path that
downstream agents reference by key, not by searching.
```

---

### Agent 3: ltc-builder (Maker)

#### 8-Component Design

| Component | Current State | Frontier Standard | Gap |
|-----------|--------------|-------------------|-----|
| **EI** (Input) | Context-packaged: EO + SEQUENCE.md task + input files + budget + constraints | ADK: task description + input_key + output_key + tool whitelist | Adequate — our context packaging is equivalent to ADK's typed input |
| **EU** (User) | Sonnet model. RACI: R (builds). Leaf node — no dispatch | Same | — |
| **EA** (Action) | Execute tasks from SEQUENCE.md in order. Self-verify against ACs. Checkpoint commit | ADK: agent executes tool calls, writes output to output_key | Adequate |
| **EO** (Output) | Produced artifacts + completion report: `DONE: <path> \| ACs: <pass>/<total> \| Blockers: <list>` | ADK: typed output + output_key. OpenAI: tool result + metadata | **GAP:** Completion report is text-only. No structured metadata (execution time, token cost, tool calls count) |
| **EP** (Principles) | EP-10 (Define Done), EP-05 (Gates). Versioning rule, brand identity, routing boundaries | Same + EP-14 (Script-First — delegate deterministic checks to scripts) | **GAP:** Builder runs scripts manually. Could auto-run skill-validator.sh, template-check.sh as post-build hooks |
| **EOE** (Environment) | Sonnet model, full write tools, no research tools | Same | Adequate — Sonnet is cost-optimal for execution |
| **EOT** (Tools) | Read, Edit, Write, Bash, Grep | Same + potentially Glob for file discovery | **CONSIDER:** Add Glob so builder can discover files by pattern (currently must know exact paths) |
| **EOP** (Procedure) | Per-task: dispatch → self-verify ACs → checkpoint commit. Multi-agent: N parallel builders + Opus synthesis | ADK: parallel agents with unique output_keys + gather step | Adequate |

#### S×E×Sc Evaluation

| Pillar | Score | Evidence |
|--------|-------|----------|
| **Sustainability** | 7/10 | Self-verification against ACs. Routing boundaries prevent writes to wrong dirs. But: no auto-rollback on AC failure, no circuit breaker |
| **Efficiency** | 8/10 | Sonnet = good balance of speed/quality/cost. Context packaging limits token budget. No research tools = focused on execution |
| **Scalability** | 8/10 | Parallel dispatch proven (competing hypotheses pattern). N builders produce drafts simultaneously. Synthesis by Opus |

#### UBS/UDS

| Force | ID | Description | Category |
|-------|----|-------------|----------|
| UBS | UBS-B1 | No Glob tool → can't discover files by pattern | Technical |
| UBS | UBS-B2 | No auto-rollback on AC failure — builder continues or stops, but doesn't undo | Technical |
| UBS | UBS-B3 | Completion report lacks structured metadata (cost, duration) | Technical |
| UBS | UBS-B4 | No auto-validation scripts in EOP — must remember to run skill-validator.sh | Human |
| UDS | UDS-B1 | Sonnet = optimal cost/quality for execution (Anthropic's sweet spot) | Economic |
| UDS | UDS-B2 | Tool whitelist prevents scope creep (no research, no dispatch) | Technical |
| UDS | UDS-B3 | Competing hypotheses pattern for design-heavy workstreams | Technical |

#### Handoff Contract: Builder → Reviewer

```
Builder EO (artifacts + completion report)  ──→  Reviewer EI (artifacts to validate)
──────────────────────────────────────────────────────────────────────────────────────
MUST PROVIDE:                               │  REVIEWER EXPECTS:
• All artifacts at declared file paths       │  • DESIGN.md (the contract)
• Completion report with AC pass/fail        │  • All produced artifacts on disk
• Version frontmatter on every artifact      │  • Completion report with blockers
• No DSBV files in 2-LEARN/                  │  • Files at paths declared in SEQUENCE.md
──────────────────────────────────────────────────────────────────────────────────────
EP-12 CHECK: Reviewer must independently verify every artifact exists
on disk (Glob). Do NOT trust builder's completion report as ground
truth. LT-1: builder may claim "DONE: path" without writing the file.

FRONTIER PATTERN (Generator/Critic loop — ADK LoopAgent):
Builder→Reviewer should loop until VALIDATE passes or max_iterations
reached. Currently: single-pass (build once → validate once). Industry
best practice: loop with exit_condition + max_iterations (default: 3).
```

**This is the highest-leverage improvement opportunity.** The Generator/Critic loop is the exact pattern used in 68% of production multi-agent systems (per frontier research). Our current single-pass (build → validate → human decides) leaves the human to manually trigger re-build on FAIL. A formal loop with `max_iterations: 3` and exit on `all_ACs_pass` would:
- Reduce human intervention for fixable issues (Efficiency ↑)
- Cap token spend on unfixable issues (Sustainability ↑)
- Match the ADK LoopAgent pattern (Scalability ↑)

---

### Agent 4: ltc-reviewer (Judge)

#### 8-Component Design

| Component | Current State | Frontier Standard | Gap |
|-----------|--------------|-------------------|-----|
| **EI** (Input) | DESIGN.md + all produced artifacts + validation template | ADK: criteria document + output to validate + scoring rubric | Adequate |
| **EU** (User) | Opus model. RACI: R (validates). Leaf node — no dispatch | Same | — |
| **EA** (Action) | Compare every artifact against DESIGN.md criteria line by line. Produce per-criterion PASS/FAIL/PARTIAL with file-path evidence | ADK: scoring per criterion + evidence-based judgment | Adequate — our protocol is more rigorous than most industry standards |
| **EO** (Output) | VALIDATE.md: per-criterion verdict table + evidence column. Consumed by human (approval gate) and builder (fix list) | Same + structured quality metrics (task success rate, instruction following %) | **GAP:** VALIDATE.md is binary verdicts only. No aggregate quality score, no trend tracking |
| **EP** (Principles) | EP-10 (Define Done), EP-01 (Brake Before Gas). "Judge, not Advocate" — report neutrally | Same | Adequate — the neutrality constraint is critical |
| **EOE** (Environment) | Opus model, read-only + Bash (for scripts). No file modification | Same | Adequate — Opus gives best judgment quality. Read-only prevents reviewer from "fixing" |
| **EOT** (Tools) | Read, Glob, Grep, Bash | Same | Adequate — minimal but sufficient for validation |
| **EOP** (Procedure) | 7-step: load DESIGN.md → check completeness → check quality → check coherence → check downstream readiness → produce VALIDATE.md → report | ADK: Generator/Critic pattern with exit_condition | **GAP:** No formal feedback loop to builder. Reviewer produces report; human decides re-build. Should: FAIL items auto-feed as builder EI for retry |

#### S×E×Sc Evaluation

| Pillar | Score | Evidence |
|--------|-------|----------|
| **Sustainability** | 9/10 | Read-only = can't damage. Opus = best judgment. Evidence-based verdicts prevent rubber-stamping. Criterion count check (VALIDATE ≥ DESIGN count) |
| **Efficiency** | 6/10 | Opus for validation is expensive. But: validation is high-stakes (mistakes here compound downstream). No aggregate scoring = human must read entire VALIDATE.md |
| **Scalability** | 5/10 | Single reviewer per workstream. No parallel validation. No auto-retry loop with builder |

#### UBS/UDS

| Force | ID | Description | Category |
|-------|----|-------------|----------|
| UBS | UBS-R1 | No auto-retry loop with builder — human must manually trigger re-build | Human |
| UBS | UBS-R2 | VALIDATE.md has no aggregate score — human must read every row | Human |
| UBS | UBS-R3 | Expensive (Opus) — but validation is high-stakes, can't downgrade | Economic |
| UDS | UDS-R1 | Evidence-based verdicts with file paths = auditable, traceable | Technical |
| UDS | UDS-R2 | Criterion count check prevents rubber-stamping | Technical |
| UDS | UDS-R3 | Read-only tools = structurally impossible to "fix" artifacts (maintains neutrality) | Technical |

#### Handoff Contract: Reviewer → Human

```
Reviewer EO (VALIDATE.md)  ──→  Human EI (approval decision)
──────────────────────────────────────────────────────────────
MUST PROVIDE:                │  HUMAN EXPECTS:
• Per-criterion verdicts     │  • Clear PASS/FAIL/PARTIAL
• File-path evidence         │  • Evidence they can verify
• Criterion count = DESIGN   │  • Aggregate summary (NEW)
• FAIL items with severity   │  • Recommended action per FAIL
──────────────────────────────────────────────────────────────
HUMAN DECISION:
  ALL PASS → approve workstream complete (G4)
  ANY FAIL → (a) re-dispatch builder with FAIL items as EI
             (b) override with justification
             (c) descope the failing criterion
```

---

## C3: WISDOM — Why Does It Work This Way?

### The Pipeline as an Effective System (UT#1)

The 4-agent pipeline IS a system (UT#1). Each agent is a component. The system's EO is a validated workstream. Applying the 8-component model to the pipeline itself:

```
Pipeline EI   = Human Director's intent (1-3 sentences)
Pipeline EU   = Main Session (Opus orchestrator)
Pipeline EA   = DSBV phases (Design→Sequence→Build→Validate)
Pipeline EO   = Validated workstream artifacts ready for next workstream
Pipeline EP   = 14 EPs + 8 LTs + 10 UTs (the philosophical stack)
Pipeline EOE  = Claude Code + hooks + settings.json + git
Pipeline EOT  = Agent() dispatching + 5-field context packaging
Pipeline EOP  = /dsbv skill (guided flow with G1-G4 gates)
```

### Why 4 Agents, Not 1 or 10?

**UT#5 + DT#1 (S>E>Sc) answer:**

| Option | Sustainability | Efficiency | Scalability | Verdict |
|--------|---------------|------------|-------------|---------|
| 1 agent (all-in-one) | LOW — single point of failure, scope creep (LT-3, LT-8) | HIGH — no handoff overhead | LOW — can't parallelize | ❌ Fragile |
| 4 agents (MECE) | HIGH — each scoped, failures isolated, retryable | MEDIUM — handoff overhead but focused context | HIGH — parallel dispatch, independent scaling | ✅ Current |
| 10 agents (fine-grained) | MEDIUM — "Bag of Agents" anti-pattern (17x error trap) | LOW — coordination overhead dominates | LOW — exponential complexity | ❌ Overengineered |

**EP-09 (Decompose Before Delegate):** 4 maps exactly to DSBV's 4 phases. Each agent owns ONE phase. This is MECE by construction.

**EP-11 (Agent Role Separation):** Tool whitelists enforce boundaries deterministically. Explorer can't write. Builder can't research. Reviewer can't fix.

### Why This Agent Order?

**UT#5 (derisk before drive) determines the sequence:**

```
Explorer (what could go wrong?) → Planner (how do we avoid it?) → Builder (execute safely) → Reviewer (did we succeed?)
   UBS identification                UBS mitigation plan              Controlled execution        Verification
```

This mirrors the ALPEI workstream sequence: ALIGN (right outcome) → LEARN (understand risks) → PLAN (mitigate risks) → EXECUTE (controlled build) → IMPROVE (learn from outcome).

### The Handoff Problem (EP-12)

**Frontier data (Towards Data Science, 2026-01-30):** In multi-agent pipelines, errors compound at a 17x rate by handoff 5. A 95% accurate agent produces 77% accuracy after 5 handoffs (0.95^5 = 0.77). With 4 agents at 90% each: 0.9^4 = 65.6% end-to-end accuracy.

**Our compensation (context packaging):**
- Explicit input/output contracts at each boundary
- Binary ACs that agents self-verify before reporting done
- Deterministic VERIFY checks (file existence, grep, script exit code)
- Human gates (G1-G4) as circuit breakers at phase boundaries

**Gap:** We have the contracts but no enforcement. PreToolUse hooks don't fire inside sub-agents (Anthropic SDK limitation, GitHub issue #40580). Enforcement is advisory (agent file text), not deterministic (hook).

### Why These Models?

**EP-02 (Know the Physics — 8 LLM Truths) determines model selection:**

| Agent | Model | Why This Model | LT Compensated |
|-------|-------|----------------|----------------|
| Explorer | Haiku | Research = high volume, low stakes. Speed + cost matter most. Hallucination risk (LT-1) mitigated by cross-validation protocol + confidence levels | LT-7 (cost), LT-2 (volume) |
| Planner | Opus | Design = high stakes, low volume. Quality of reasoning matters most. Architectural decisions compound — wrong design = wrong everything | LT-3 (reasoning), LT-5 (plausibility) |
| Builder | Sonnet | Build = medium stakes, medium volume. Balance of speed + quality. Well-defined tasks with clear ACs reduce need for top-tier reasoning | LT-3 (decomposed tasks), LT-7 (cost) |
| Reviewer | Opus | Validate = high stakes, low volume. Judgment quality is critical — rubber-stamping defeats the purpose. Must catch what builder missed | LT-5 (plausibility ≠ truth), LT-1 (hallucination detection) |

---

## C4: EXPERTISE — How to Make It World-Class

### Gap Analysis: Current State vs. Frontier

| # | Gap | Current | Frontier (best-in-class) | Impact | Effort | Priority |
|---|-----|---------|--------------------------|--------|--------|----------|
| G1 | **No Generator/Critic loop** | Build once → Validate once → human decides | Builder↔Reviewer loop with max_iterations + exit_condition (ADK LoopAgent) | HIGH — reduces human intervention for fixable issues | Medium | **P0** |
| G2 | **EP-13 planner contradiction** | Claims orchestrator authority but no Agent() tool | Clear RACI: main session = orchestrator, planner = advisor | HIGH — creates confusion in agent file | Low | **P0** |
| G3 | **Explorer tool bugs** | WebSearch claim (false), Glob missing from guide | Accurate tool documentation matching actual tools | Medium | Low | **P0** |
| G4 | **No orchestration state** | Pipeline progress in conversation history (lossy) | Persistent state file or /dsbv status as formal checkpoint | Medium — context rotation loses progress | Medium | **P1** |
| G5 | **No output schemas** | Agent reports vary in structure | Typed output contracts (ADK output_key, LangGraph typed state) | Medium — orchestrator parses unstructured text | Medium | **P1** |
| G6 | **6 missing rule files** | CLAUDE.md references rules that don't exist | All referenced rules exist and are loaded | Medium — EP is incomplete | Medium | **P1** |
| G7 | **No cost/success metrics** | No tracking of tokens, duration, success rate per agent | Per-dispatch telemetry (Ruflo pattern) | Low — optimization is blind | Low | **P2** |
| G8 | **No circuit breaker** | Builder failures loop until human notices | Max retry count + auto-escalation (ADK error recovery) | Medium — burns tokens on unfixable issues | Low | **P1** |
| G9 | **Hook enforcement gap** | PreToolUse hooks don't fire in sub-agents | Advisory enforcement (agent file) + post-dispatch verification (VERIFY field) | Low — mitigated by VERIFY field | N/A (SDK limitation) | **Accept** |
| G10 | **Planner can't verify files** | No Glob tool in planner | Add Glob so planner can check if referenced files exist | Low | Low | **P2** |

### Improvement Proposals

#### Proposal 1: Formalize the Generator/Critic Loop (P0)

**What:** Add a BUILD→VALIDATE loop to the /dsbv skill with configurable `max_iterations` (default: 3) and exit condition (all ACs pass).

**Why (S×E×Sc):**
- **S:** Capped iterations prevent infinite loops (top 3 production failure per frontier research)
- **E:** Auto-retry for fixable issues saves human intervention time
- **Sc:** Same pattern works for any workstream (ALIGN, PLAN, EXECUTE, IMPROVE)

**Implementation:**

```
/dsbv build [workstream] → dispatches builder(s) →
  → dispatches reviewer →
    IF all PASS → G4 (human approval)
    IF any FAIL + iterations < max →
      → re-dispatch builder with FAIL items as EI → loop
    IF any FAIL + iterations = max →
      → escalate to human with full failure context
```

**EP grounding:** EP-01 (Brake Before Gas — cap iterations). EP-10 (Define Done — binary exit condition). EP-09 (Decompose — FAIL items become individual retry tasks).

**Frontier pattern:** ADK LoopAgent + Generator/Critic. 68% of production systems use this pattern.

---

#### Proposal 2: Fix EP-13 Across All Agent Files (P0)

**What:** Rewrite EP-13 in ltc-planner to clarify it is NOT the orchestrator. The main session is. All 4 agents are leaf nodes dispatched by the main session.

**Current (wrong):**
```
You **MAY** dispatch ltc-builder, ltc-reviewer, and ltc-explorer
```

**Proposed:**
```
You are a leaf node in the agent hierarchy. The main session (orchestrator)
dispatches you and receives your output. You do NOT dispatch other agents.
Your output (DESIGN.md / SEQUENCE.md content) is consumed by the
orchestrator, who writes it to disk and dispatches builders/reviewers.
```

**Why:** EP-13 (Orchestrator Authority) says "exactly one orchestrator." That orchestrator is the main session, not a sub-agent. Having two entities claiming orchestrator authority violates RACI (UT#9: R ≠ A, and there must be exactly one A).

---

#### Proposal 3: Define Typed Output Contracts (P1)

**What:** Add an `OUTPUT_CONTRACT` section to each agent file that specifies the exact structure of the agent's EO. This is the ADK `output_key` discipline applied to Claude Code.

**Explorer OUTPUT_CONTRACT:**
```yaml
output_contract:
  sections:
    - findings: "Themed research results with source citations"
    - sources: "List of ≥3 URLs/titles"
    - confidence: "Per-claim: high/medium/low"
    - unknowns: "Explicitly flagged knowledge gaps"
  format: markdown
  min_sources: 3
```

**Builder OUTPUT_CONTRACT:**
```yaml
output_contract:
  completion_report: "DONE: <path> | ACs: <pass>/<total> | Blockers: <list>"
  artifacts: "Files at paths declared in SEQUENCE.md"
  metadata:
    version_frontmatter: required
    brand_compliance: required_if_visual
```

**Why (frontier):** ADK's #1 multi-agent bug is "opaque state keys" — agents pass data without schema, downstream agents misinterpret. Typed contracts prevent this.

---

#### Proposal 4: Add Orchestration State File (P1)

**What:** `/dsbv status` currently reads version-registry.md. Enhance to include per-dispatch state:

```yaml
# .claude/state/dsbv-pipeline.yaml (auto-generated, git-ignored)
current_workstream: 1-ALIGN
current_phase: build
dispatches:
  - agent: ltc-builder
    task: T1.3
    status: complete
    ac_pass: 4/4
    tokens: 12340
    duration_sec: 45
  - agent: ltc-reviewer
    task: validate
    status: pending
iteration: 1
max_iterations: 3
```

**Why:** The main session loses pipeline progress on context rotation (LT-2, LT-6). A persistent state file survives context compression.

---

#### Proposal 5: Add Circuit Breaker to /dsbv Build (P1)

**What:** If builder fails on the same task 2 consecutive times (different errors), auto-escalate to human instead of retrying.

**Implementation:**
```
IF builder_failure_count(task_id) >= 2:
  STOP
  Report: "Builder failed twice on {task_id}. Errors: {error_1}, {error_2}.
           Possible causes: [EP→Input→EOP→EOE→EOT→Agent diagnostic order]
           Options: (a) simplify task (b) provide more context (c) skip task"
  WAIT for human decision
```

**EP grounding:** EP-01 (Brake Before Gas). EP-02 (Know the Physics — LT-3: reasoning degrades, retrying won't fix a fundamentally too-complex task).

**Frontier pattern:** Circuit breaker (40% of production systems). ADK error recovery pattern.

---

### Skill→Agent Interaction Map

The agent system doesn't operate in isolation — skills invoke agents. Here's the complete call graph:

```
Skills that dispatch agents:
─────────────────────────────
/dsbv build      → ltc-builder (1 or N parallel)
/dsbv validate   → ltc-reviewer (1)
/dsbv design     → ltc-planner (1) [proposed — currently main session drafts]
/learn-research  → ltc-explorer (N parallel, 1 per topic)
/deep-research   → ltc-explorer (N parallel for retrieval)

Skills consumed by agents (loaded as EI):
─────────────────────────────────────────
ltc-builder reads:
  - /dsbv (SEQUENCE.md tasks)
  - /ltc-brand-identity (visual artifacts)
  - /ltc-naming-rules (naming validation)
  - /git-save (commit protocol)

ltc-reviewer reads:
  - /dsbv (DESIGN.md criteria)
  - /ltc-rules-compliance (cross-cutting checks)
  - /template-check (template conformance)

ltc-explorer reads:
  - /deep-research (research methodology)
  - /root-cause-tracing (causal chain protocol)
  - /obsidian (graph traversal — if available)

ltc-planner reads:
  - /dsbv (DSBV process)
  - /ltc-brainstorming (divergent thinking)
  - /ltc-naming-rules (naming validation)
```

---

## Summary: Priority Actions

| Priority | Action | Agents Affected | Effort |
|----------|--------|-----------------|--------|
| **P0** | Fix EP-13 in ltc-planner (leaf node, not orchestrator) | planner | 10 min |
| **P0** | Fix ltc-explorer bugs (WebSearch, Glob guide) | explorer | 10 min |
| **P0** | Design Generator/Critic loop in /dsbv (BUILD↔VALIDATE) | builder, reviewer, dsbv skill | 2-3 hrs |
| **P1** | Create 6 missing rule files (agent-system, tool-routing, agent-diagnostic, general-system, security-rules, brand-identity) | all agents (EP completeness) | 2-3 hrs |
| **P1** | Add typed output contracts to agent files | all 4 agents | 1 hr |
| **P1** | Add circuit breaker to /dsbv build | builder, dsbv skill | 1 hr |
| **P1** | Add orchestration state file (.claude/state/) | orchestrator, dsbv skill | 1-2 hrs |
| **P2** | Add cost/success metrics logging | all agents | 2-3 hrs |
| **P2** | Add Glob to ltc-planner and ltc-builder tools | planner, builder | 30 min |
| **Accept** | PreToolUse hooks in sub-agents (Anthropic SDK gap) | all agents | N/A — SDK limitation |

---

## Sources

### Internal Audit
- QMD sessions corpus (2013 documents, 37 conversations)
- Git history: `.claude/agents/`, `.claude/rules/`, `.claude/skills/dsbv/`
- Memory files: `learned_patterns.md`, `project_model_routing.md`, `project_i1_decisions.md`
- Version registry: `_genesis/version-registry.md`

### Frontier Research (20+ sources, Jan-Apr 2026)
- Google ADK multi-agent patterns (PKB distilled + Exa updates)
- Anthropic Claude Agent SDK practical guides (Claude Lab, 2026-03)
- OpenAI Agents SDK (production release, 2026-03)
- LangGraph state machine patterns (AI VOID, Abstract Algorithms, 2026-03)
- CrewAI/AutoGen framework comparisons (DEV Community, Yoyo Blog, 2026-02)
- Ruflo orchestration platform (28K GitHub stars, 2026-03)
- Production failure post-mortems: "17x Error Trap" (TDS), "3 Production Failures" (DEV), error recovery patterns
- Agent evaluation: ICSE 2026 Agent Workshop, Galileo AI metrics framework
- Context management: Zylos Research, AI Agents Plus, LogRocket (2026-03)
- Anti-patterns: "Agent-to-Agent is Anti-Pattern" (LinkedIn), "Multi-Agent Chaos" (Agent Patterns)

### Philosophical Foundation
- 10 Ultimate Truths (UT#1-10): `_genesis/frameworks/ltc-10-ultimate-truths.md`
- 8-Component ESD Model: `_genesis/frameworks/ltc-effective-system-design-blueprint.md`
- 14 Effective Principles (EP-01 to EP-14): `_genesis/reference/ltc-effective-agent-principles-registry.md`
- 8 LLM Truths (LT-1 to LT-8): EP-02 in EP registry
- S×E×Sc (DT#1): `_genesis/frameworks/ltc-10-ultimate-truths.md` §DT#1
- DSBV Process: `_genesis/templates/dsbv-process.md`
- Context Packaging: `.claude/skills/dsbv/references/context-packaging.md`

## Links

- [[AGENTS]]
- [[CLAUDE]]
- [[DESIGN]]
- [[EP-01]]
- [[EP-02]]
- [[EP-05]]
- [[EP-09]]
- [[EP-10]]
- [[EP-11]]
- [[EP-12]]
- [[EP-13]]
- [[EP-14]]
- [[SEQUENCE]]
- [[SKILL]]
- [[VALIDATE]]
- [[agent-diagnostic]]
- [[agent-system]]
- [[anti-patterns]]
- [[brand-identity]]
- [[charter]]
- [[context-packaging]]
- [[dashboard]]
- [[documentation]]
- [[dsbv-process]]
- [[general-system]]
- [[iteration]]
- [[learned_patterns]]
- [[ltc-10-ultimate-truths]]
- [[ltc-builder]]
- [[ltc-effective-agent-principles-registry]]
- [[ltc-effective-system-design-blueprint]]
- [[ltc-explorer]]
- [[ltc-planner]]
- [[ltc-reviewer]]
- [[methodology]]
- [[schema]]
- [[security-rules]]
- [[standard]]
- [[task]]
- [[tool-routing]]
- [[version-registry]]
- [[versioning]]
- [[workstream]]
