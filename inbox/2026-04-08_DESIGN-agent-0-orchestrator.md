---
version: "1.0"
status: draft
last_updated: 2026-04-08
type: design-proposal
work_stream: 0-GOVERN
agent: orchestrator
---

# DESIGN: Agent 0 --- Orchestrator (Main Session)

## Identity

Agent 0 is the Claude Code main session --- the user's direct conversation partner and the sole entity authorized to decompose work, dispatch sub-agents, and synthesize their outputs. It is NOT a sub-agent; it IS the session itself. It runs on Opus (highest reasoning tier), holds all tools including Agent(), and is the only entity in the hierarchy for which all hooks, rules, memory, MCP servers, and context management mechanisms fire. Its RACI role is Consulted (C): it advises the Human Director (Accountable) and orchestrates the four Responsible sub-agents. Per EP-13, exactly one orchestrator owns decomposition and synthesis --- this is it.

## Pipeline Position

```
                       HUMAN DIRECTOR (A)
                             |
                         [intent]
                             |
                             v
    +================================================+
    |          AGENT 0 --- ORCHESTRATOR               |
    |          (Main Session, Opus, ALL tools)         |
    |                                                  |
    |  EOE: hooks + memory + MCP + compaction          |
    |  EA:  decompose -> dispatch -> synthesize        |
    +====+========+========+========+=================+
         |        |        |        |
    [research] [design]  [build]  [validate]
         |        |        |        |
         v        v        v        v
    +---------+--------+--------+---------+
    |EXPLORER |PLANNER |BUILDER |REVIEWER |
    | haiku   | opus   | sonnet | opus    |
    | read-   | read + | write  | read +  |
    |  only   | search | tools  | verify  |
    +---------+--------+--------+---------+
         |        |        |        |
         v        v        v        v
      [findings][DESIGN] [artifacts][VALIDATE]
         \        |        |        /
          \       |        |       /
           +------+--------+------+
                  |
                  v
           AGENT 0 receives EO
           synthesizes -> presents
                  |
                  v
           HUMAN DIRECTOR approves

    Nesting depth: 2 (Agent 0 + 1 sub-agent)
    Flow direction: Explorer -> Planner -> Builder -> Reviewer
    Each agent's EO becomes the next agent's EI
```

## 8-Component Design

---

### EI --- Effective Input

**Current State**

Agent 0 receives the richest input of any entity in the system. Seven distinct input channels:

| Channel | Source | Mechanism | Frequency |
|---------|--------|-----------|-----------|
| User messages | Human Director | Direct conversation | Every turn |
| CLAUDE.md | Project repo | Auto-loaded at session start | Once per session |
| Always-on rules | `.claude/rules/` (12 files) | Auto-loaded at session start | Once per session |
| Memory system | `~/.claude/projects/{project}/memory/` | MEMORY.md + topic files | On-demand + auto-recall |
| Auto-recall | UserPromptSubmit hook -> QMD query | Injected every user message, 2000 token budget | Every turn |
| SessionStart output | 3 hooks: resume-check, session-reconstruct, pkb-lint | Shell script output | Once per session |
| Sub-agent reports | ltc-explorer/planner/builder/reviewer | Completion text returned to main session | Per dispatch |
| Version registry | `_genesis/version-registry.md` | Read on demand | Per task |

The always-on rules form the structural skeleton of Agent 0's behavior:

```
agent-dispatch.md           <- sub-agent invocation protocol
alpei-chain-of-custody.md   <- workstream ordering constraint
alpei-template-usage.md     <- template-first artifact creation
enforcement-layers.md       <- 4x3 enforcement matrix reference
naming-rules.md             <- UNG separator grammar
obsidian-security.md        <- CVE hard-block + hybrid sweep
filesystem-routing.md       <- 4-mode write routing
memory-format.md            <- 3-section MEMORY.md structure
sub-agent-output.md         <- completion report format
git-conventions.md          <- commit format + staging rules
versioning.md               <- MAJOR.MINOR + status lifecycle
example-api-conventions.md  <- API pattern reference
```

**Frontier Standard (from research)**

Best-practice orchestrators (Jan-Apr 2026) implement:
- Structured intent parsing: user message -> {goal, constraints, scope, urgency} tuple before any action
- Semantic deduplication: detect when user restates a prior request to avoid redundant work
- Dynamic context prioritization: rank loaded rules by relevance to current task, evict low-relevance content
- Pipeline state recovery: session state file that survives context rotation (e.g., `.claude/state/pipeline.json`)

**Gap Analysis**

| Gap ID | Description | Impact | Priority |
|--------|-------------|--------|----------|
| EI-G1 | No structured intent parsing --- user messages arrive as raw text | Agent may misinterpret ambiguous requests (LT-8) | P1 |
| EI-G2 | Auto-recall is unfiltered --- 2000 tokens injected regardless of relevance | Token waste + attention dilution (LT-2, LT-4) | P1 |
| EI-G3 | No pipeline state persistence --- if session dies mid-pipeline, Agent 0 loses progress | Manual reconstruction required (LT-6) | P0 |
| EI-G4 | Sub-agent reports are free-text (sub-agent-output.md enforces format, but not validated) | Inconsistent report quality (LT-8) | P2 |

**S x E x Sc Score**

| Dimension | Score | Rationale |
|-----------|-------|-----------|
| S (Sustainability) | 7/10 | Session reconstruction + memory exist, but pipeline state is lost on crash |
| E (Efficiency) | 5/10 | Auto-recall injects 2000 tokens/turn even when irrelevant; 12 rule files load regardless of task |
| Sc (Scalability) | 6/10 | Adding more rules degrades attention (LT-2); no prioritization mechanism |

**UBS/UDS**

| Force | Category | Description |
|-------|----------|-------------|
| UBS-1 | Technical | LT-2 (lossy context) --- 12 rules + 200-line CLAUDE.md + auto-recall + memory compete for attention budget |
| UBS-2 | Technical | LT-6 (no persistent memory) --- session death = total amnesia; reconstruction is lossy |
| UBS-3 | Temporal | Auto-recall latency adds ~1s per turn; QMD embedding drift means stale results |
| UDS-1 | Technical | 1M context window is the largest available --- more headroom than any competing model |
| UDS-2 | Technical | Memory vault + auto-recall provide cross-session continuity rare in agent systems |
| UDS-3 | Technical | SessionStart hooks pre-load critical state, reducing cold-start risk |

---

### EU --- Effective User

**Current State**

The "user" of the orchestrator system is Claude Opus (the model executing inside Agent 0). In the 7-CS framework, EU = Agent (the LLM) --- uncontrollable, only characterizable via UBS/UDS.

| Property | Value |
|----------|-------|
| Model | Claude Opus 4.6 (1M context) |
| Reasoning tier | Highest available |
| RACI role | C (Consulted) --- advises Human Director |
| Cost | Highest per-token in the LTC model roster |
| Context window | 1,000,000 tokens |

**8 LLM Truths as EU constraints:**

| LT | Structural Constraint | Impact on Orchestrator | Primary Compensation |
|----|----------------------|----------------------|---------------------|
| LT-1 | Hallucination is structural | May fabricate file paths, claim sub-agents succeeded when they didn't | VERIFY section in context packaging; deterministic checks (Bash, Grep) |
| LT-2 | Context compression is lossy | At 1M tokens, early context degrades; rules loaded first may be forgotten | PreCompact hook; strategic-compact.sh; context budgeting |
| LT-3 | Reasoning degrades on complex tasks | Multi-step DSBV orchestration with 4 agents is complex | EP-09: decompose before delegate; single-task sub-agent dispatch |
| LT-4 | Retrieval is fragile under noise | Finding the right rule among 12 files + CLAUDE.md + memory + auto-recall | EP-04: load what you need; EP-08: signal over volume |
| LT-5 | Plausibility != truth | May declare pipeline "complete" based on plausible reasoning, not evidence | VERIFY steps; ltc-reviewer as independent checker |
| LT-6 | No persistent memory | Every session starts from zero; pipeline state lost | SessionStart hooks; memory vault; auto-recall |
| LT-7 | Cost scales with tokens | Opus is most expensive; every dispatched sub-agent adds cost | Model routing (Haiku for research, Sonnet for build); budget fields in context packaging |
| LT-8 | Alignment is approximate | May drift from rules under complex prompts; hooks may not fully constrain | Gates before guides (EP-05); PreToolUse hooks as hard enforcement |

**Frontier Standard**

Production orchestrators (2026) implement:
- Model self-assessment: orchestrator rates its confidence before presenting output, triggering human review when < threshold
- Cognitive load monitoring: track reasoning chain depth and trigger decomposition when complexity exceeds model capacity
- Cost-aware routing: orchestrator considers remaining budget before choosing dispatch model

**Gap Analysis**

| Gap ID | Description | Impact | Priority |
|--------|-------------|--------|----------|
| EU-G1 | No confidence self-assessment --- Agent 0 presents all output with equal implied confidence | Human Director cannot triage review effort (LT-5) | P1 |
| EU-G2 | No cost tracking --- Agent 0 cannot see token spend across dispatched sub-agents | Budget overruns are invisible until billing (LT-7) | P2 |
| EU-G3 | No reasoning depth monitoring --- Agent 0 may attempt synthesis requiring more logical steps than Opus handles reliably | Subtle reasoning errors in complex orchestration (LT-3) | P1 |

**S x E x Sc Score**

| Dimension | Score | Rationale |
|-----------|-------|-----------|
| S (Sustainability) | 8/10 | Opus is the most capable model; 8 LTs are well-characterized and compensated |
| E (Efficiency) | 5/10 | Most expensive model; used for every user interaction including trivial ones |
| Sc (Scalability) | 7/10 | 1M context handles large projects; but cost scales linearly with usage |

**UBS/UDS**

| Force | Category | Description |
|-------|----------|-------------|
| UBS-1 | Economic | Opus cost per token is 5-15x Haiku --- every orchestrator turn is expensive |
| UBS-2 | Technical | LT-3 reasoning degradation on multi-step orchestration chains |
| UBS-3 | Human | Human Director may over-rely on Opus quality, reducing own oversight (UT#6 bias) |
| UDS-1 | Technical | Highest reasoning capability enables synthesis that Sonnet/Haiku cannot perform |
| UDS-2 | Technical | 1M context window allows holding full pipeline state in a single session |
| UDS-3 | Technical | Extended thinking capability for complex decomposition tasks |

---

### EA --- Effective Action

**Current State**

Agent 0 performs five categories of action:

```
1. INTERPRET ---- Parse user intent, identify workstream, check pre-flight protocol
2. DECOMPOSE ---- Break work into DSBV phases, identify sub-agent assignments
3. DISPATCH ----- Invoke Agent() with context-packaged 5-field prompts
4. SYNTHESIZE --- Receive sub-agent EO, merge, resolve conflicts, check coherence
5. PRESENT ------ Show results to Human Director at DSBV gate points (G1-G4)
```

The DSBV gate sequence maps to these actions:

| Gate | Action | Agent 0 Role | Sub-Agent |
|------|--------|-------------|-----------|
| Pre-DSBV | Research | Dispatch + receive findings | ltc-explorer (haiku) |
| G1 (Design) | Plan | Dispatch + review DESIGN.md | ltc-planner (opus) |
| G2 (Sequence) | Order | Dispatch + review SEQUENCE.md | ltc-planner (opus) |
| G3 (Build) | Produce | Dispatch + verify artifacts | ltc-builder (sonnet) |
| G4 (Validate) | Review | Dispatch + present VALIDATE.md | ltc-reviewer (opus) |

Direct action (no sub-agent dispatch) occurs for:
- Session management (/resume, /compress)
- Simple edits (single file, low complexity)
- Memory operations (read/update MEMORY.md and topic files)
- Git operations (status, commit, log)
- Skill invocation that does not require delegation

**Frontier Standard**

- Generator/Critic loop: Builder produces -> Reviewer validates -> if FAIL, Builder retries (max 2 iterations) -> if still FAIL, escalate to human. The orchestrator manages this loop.
- Circuit breaker: after 2 consecutive sub-agent failures on the same task, stop dispatching and escalate with full diagnostic.
- Parallel dispatch: when sub-agent tasks are independent, dispatch simultaneously (e.g., Explorer researching topic A while Builder produces artifact B).

**Gap Analysis**

| Gap ID | Description | Impact | Priority |
|--------|-------------|--------|----------|
| EA-G1 | No Builder/Reviewer retry loop --- if Builder output fails validation, human must manually re-dispatch | Slow iteration; human bottleneck on mechanical retries | P0 |
| EA-G2 | No circuit breaker --- Agent 0 may keep dispatching failing sub-agents indefinitely | Token waste; frustration; no escalation signal | P0 |
| EA-G3 | No parallel dispatch protocol --- all sub-agents dispatched sequentially | Slower pipelines when tasks are independent | P2 |
| EA-G4 | Pre-flight protocol (9 checks in CLAUDE.md) not automated --- relies on agent compliance | Checks skipped under complex prompts (LT-8) | P1 |

**S x E x Sc Score**

| Dimension | Score | Rationale |
|-----------|-------|-----------|
| S (Sustainability) | 5/10 | No retry loop or circuit breaker; failure handling is entirely manual |
| E (Efficiency) | 6/10 | Context packaging protocol reduces miscommunication, but no parallel dispatch |
| Sc (Scalability) | 6/10 | 4 sub-agents cover MECE roles, but sequential dispatch limits throughput |

**UBS/UDS**

| Force | Category | Description |
|-------|----------|-------------|
| UBS-1 | Technical | No retry/circuit breaker means failures cascade without automatic recovery |
| UBS-2 | Human | Human Director must manually re-dispatch after sub-agent failure --- attention cost |
| UBS-3 | Temporal | Sequential dispatch adds latency to multi-phase pipelines |
| UDS-1 | Technical | 5-field context packaging standardizes every dispatch --- reduces miscommunication |
| UDS-2 | Technical | MECE agent roster eliminates scope overlap --- each agent has clear boundaries |
| UDS-3 | Technical | verify-agent-dispatch.sh PreToolUse hook enforces packaging compliance |

---

### EO --- Effective Output

**Current State**

Agent 0 produces four categories of output:

| Output Type | Consumer | Format | Gate |
|-------------|----------|--------|------|
| Synthesized artifacts | Human Director | Merged sub-agent outputs, presented with traceability | G1-G4 |
| Gate presentations | Human Director | DESIGN.md/SEQUENCE.md/VALIDATE.md summaries with pass/fail status | G1-G4 |
| Direct artifacts | Human Director | Files written directly (simple edits, memory ops, session management) | None (immediate) |
| Session summaries | Future sessions | Saved via Stop hook -> session-summary.sh | Session end |

The sub-agent-output.md rule enforces completion report format:
```
DONE: <artifact-path> | ACs: <pass>/<total> | Blockers: <none or list>
```

But Agent 0's own output to the Human Director has no enforced format --- it is free-text conversation.

**Frontier Standard**

- Structured gate reports: every gate presentation includes a standard header (workstream, phase, AC summary, risk flags, recommended action)
- Confidence-tagged output: each substantive claim tagged with confidence level (high/medium/low)
- Audit trail: every output traces to an input (user message ID, sub-agent report, or rule reference)

**Gap Analysis**

| Gap ID | Description | Impact | Priority |
|--------|-------------|--------|----------|
| EO-G1 | No structured format for Agent 0's output to Human Director | Inconsistent presentation quality; human must parse free-text | P1 |
| EO-G2 | No confidence tagging on orchestrator's own claims | Human cannot triage review effort (LT-5 compensation) | P2 |
| EO-G3 | Session summaries (Stop hook) are not validated for completeness | Future sessions may reconstruct poorly from incomplete summaries (LT-6) | P1 |

**S x E x Sc Score**

| Dimension | Score | Rationale |
|-----------|-------|-----------|
| S (Sustainability) | 6/10 | Session summaries exist but are not validated; gate reports are ad-hoc |
| E (Efficiency) | 6/10 | Sub-agent output format is enforced; orchestrator output is not |
| Sc (Scalability) | 5/10 | No structured output means adding more consumers (dashboards, CI) is hard |

**UBS/UDS**

| Force | Category | Description |
|-------|----------|-------------|
| UBS-1 | Technical | LT-1 means Agent 0 may present synthesized results that include hallucinated sub-agent success |
| UBS-2 | Technical | Free-text output cannot be machine-parsed for automated downstream consumption |
| UDS-1 | Technical | Sub-agent output format (sub-agent-output.md) provides structured input for synthesis |
| UDS-2 | Technical | verify-deliverables.sh (SubagentStop hook) validates sub-agent output exists on disk |

---

### EP --- Effective Principles

**Current State**

Agent 0 operates under the full EP registry (EP-01 through EP-14). Unlike sub-agents, which receive only 2-3 applicable EPs per dispatch, the orchestrator carries all 14 at all times.

**Principle Application Map:**

| EP | Name | Tag | Orchestrator Application |
|----|------|-----|------------------------|
| EP-01 | Brake Before Gas | DERISK | Pre-flight protocol before every task; derisk checklist before dispatch |
| EP-02 | Know the Physics | DERISK | Awareness of 8 LTs; design compensations into every sub-agent dispatch |
| EP-03 | Two Operators | OUTPUT | Human Director = A, Agent 0 = C, Sub-agents = R; never self-approve |
| EP-04 | Load What You Need | DERISK | Context packaging budget field; do not dump all files into sub-agent |
| EP-05 | Gates Before Guides | DERISK | DSBV gates G1-G4 are deterministic; skills are probabilistic guides |
| EP-06 | Derisk-First Setup | DERISK | Permissions (deny rules) before capabilities (allow rules) in settings.json |
| EP-07 | Amnesia-First Design | DERISK | Every sub-agent dispatch includes full context --- assume zero prior knowledge |
| EP-08 | Signal Over Volume | DERISK | Auto-recall budget (2000 tokens); rule files kept concise |
| EP-09 | Decompose Before Delegate | DERISK | Break complex tasks into single-agent-digestible pieces before Agent() call |
| EP-10 | Define Done | OUTPUT | ACs in every context packaging OUTPUT section; binary pass/fail |
| EP-11 | Agent Role Separation | DERISK | MECE agent roster; no scope overlap; cross-boundary = explicit handoff |
| EP-12 | Verified Handoff | DERISK | Sub-agent output verified before treated as ground truth |
| EP-13 | Orchestrator Authority | OUTPUT | Agent 0 is the SOLE orchestrator; sub-agents are leaf nodes |
| EP-14 | Script-First Delegation | DERISK | Deterministic checks -> shell scripts; judgment -> agent |

**Priority EPs for Orchestrator (S > E > Sc per DT#1):**

```
Tier 1 (Sustainability --- non-negotiable):
  EP-01  Brake Before Gas
  EP-05  Gates Before Guides
  EP-13  Orchestrator Authority

Tier 2 (Efficiency --- high-value):
  EP-09  Decompose Before Delegate
  EP-07  Amnesia-First Design
  EP-04  Load What You Need

Tier 3 (Scalability --- important):
  EP-11  Agent Role Separation
  EP-14  Script-First Delegation
```

**Grounding in Ultimate Truths:**

| UT | Application to Agent 0 |
|----|----------------------|
| UT#1 | Agent 0 is a system with 8 components --- this document |
| UT#3 | UBS (8 LTs) and UDS (model capabilities) are always present |
| UT#5 | Risk management before output maximization (S > E > Sc) |
| UT#8 | Human-related biases (UT#6) + LLM structural limits = the orchestrator's two-front war |
| UT#10 | ALPEI workstreams are concurrent, not sequential --- Agent 0 must manage parallel state |

**Frontier Standard**

- Principle activation: only load EPs relevant to current task type (research, design, build, validate) rather than all 14
- Principle conflict resolution: explicit priority order when EPs conflict (e.g., EP-04 "load less" vs EP-07 "include full context for amnesia-first")
- Principle effectiveness measurement: track which EPs prevented failures vs which are unused noise

**Gap Analysis**

| Gap ID | Description | Impact | Priority |
|--------|-------------|--------|----------|
| EP-G1 | All 14 EPs loaded simultaneously --- no task-type filtering | Attention dilution (LT-2, LT-4) | P2 |
| EP-G2 | No explicit resolution protocol when EPs conflict (EP-04 vs EP-07) | Agent makes ad-hoc tradeoffs (LT-8) | P1 |
| EP-G3 | No measurement of EP effectiveness | Cannot prune unused EPs or strengthen weak ones | P2 |

**S x E x Sc Score**

| Dimension | Score | Rationale |
|-----------|-------|-----------|
| S (Sustainability) | 8/10 | 14 EPs cover all 7-CS components; DERISK:OUTPUT ratio is 11:3 per UT#5 |
| E (Efficiency) | 6/10 | All EPs loaded always; no task-type filtering; potential conflict unresolved |
| Sc (Scalability) | 7/10 | Registry is extensible; new EPs can be added with clear grounding |

**UBS/UDS**

| Force | Category | Description |
|-------|----------|-------------|
| UBS-1 | Technical | 14 EPs + 10 UTs + 8 LTs = dense principle space; retrieval under noise is fragile (LT-4) |
| UBS-2 | Human | Human Director may not know which EPs to invoke when reviewing orchestrator behavior |
| UDS-1 | Technical | Every EP is grounded in a specific LT/UT --- no unanchored rules |
| UDS-2 | Technical | DERISK-first distribution (11:3) aligns with UT#5 priority |

---

### EOE --- Effective Operating Environment

This is the most critical section. The orchestrator's EOE is dramatically richer than any sub-agent's, and this asymmetry is the defining architectural feature of the system.

**Layer 1 --- Platform Runtime**

| Component | Value |
|-----------|-------|
| Runtime | Claude Code CLI |
| OS | macOS Darwin 25.3.0 |
| Shell | zsh |
| Python | python3 (script execution) |
| Node.js | Available (npm scripts) |
| Git | Available (version control) |
| Working directory | `/Users/longnguyen/LTC/LongHNguyen/OPS_OE.6.4.LTC-PROJECT-TEMPLATE` |

**Layer 2 --- Permission System (settings.json)**

Permissions are the ONLY EOE layer that sub-agents inherit. They define hard boundaries that even the orchestrator cannot bypass.

Deny rules (12 --- hard blocks):
```
Read(.env)                    <- secret protection
Read(.env.local)              <- secret protection
Read(.env.production)         <- secret protection
Read(.env.*)                  <- secret protection (wildcard)
Bash(rm -rf *)                <- destructive operation block
Bash(sudo *)                  <- privilege escalation block
Bash(npm publish)             <- deployment block
Bash(git push --force *)      <- force push block
```

Allow rules (8 --- pre-approved operations):
```
Bash(npm run *)               <- project scripts
Bash(npm test *)              <- test execution
Bash(npx *)                   <- tool execution
Bash(git status)              <- read-only git
Bash(git diff *)              <- read-only git
Bash(git log *)               <- read-only git
Bash(git add *)               <- staging
Bash(git commit *)            <- commits (hooks still fire)
Bash(./scripts/dsbv-gate.sh)  <- DSBV validation
```

**Layer 3 --- Hooks (15 hooks across 6 events)**

Hooks are the primary enforcement mechanism. They fire ONLY for the main session (Agent 0). Sub-agents lose all hooks --- this is the biggest EOE degradation.

```
EVENT: SessionStart (3 hooks)
+---------------------------------------------------+
| resume-check.sh          | Detect resumed session  |
| session-reconstruct.sh   | Rebuild session state   |
| pkb-lint.sh              | Validate PKB health     |
+---------------------------------------------------+

EVENT: PreToolUse (12 hooks)
+---------------------------------------------------+
| MATCHER: Write                                     |
|   naming-lint.sh         | Filename convention     |
+---------------------------------------------------+
| MATCHER: Bash(git commit *)                        |
|   dsbv-gate.sh           | Workstream boundaries   |
|   skill-validator.sh     | Skill quality (staged)  |
|   link-validator.sh      | Broken wikilinks        |
|   registry-sync-check.sh | Version registry sync   |
|   status-guard.sh        | Block self-approve      |
|   validate-blueprint.py  | Filesystem routing      |
|   changelog check        | CHANGELOG.md updated    |
+---------------------------------------------------+
| MATCHER: Write|Edit                                |
|   dsbv-skill-guard.sh    | DESIGN.md prerequisite  |
|   dsbv-gate.sh --pretool | ALPEI chain-of-custody  |
+---------------------------------------------------+
| MATCHER: Agent                                     |
|   verify-agent-dispatch  | Context packaging check |
+---------------------------------------------------+
| MATCHER: (global, all tools)                       |
|   strategic-compact.sh   | Context saturation warn |
+---------------------------------------------------+

EVENT: PostToolUse (5 hooks)
+---------------------------------------------------+
| MATCHER: Write                                     |
|   naming-lint.sh         | Frontmatter casing      |
+---------------------------------------------------+
| MATCHER: Agent                                     |
|   nesting-depth-guard.sh | EP-13 depth limit       |
+---------------------------------------------------+
| MATCHER: Write|Edit                                |
|   inject-frontmatter.sh  | Auto-inject metadata    |
|   state-saver.sh         | Save session state      |
|   ripple-check.sh        | Backlink impact check   |
+---------------------------------------------------+

EVENT: SubagentStop (1 hook)
+---------------------------------------------------+
| verify-deliverables.sh   | Confirm artifact exists |
+---------------------------------------------------+

EVENT: PreCompact (1 hook)
+---------------------------------------------------+
| save-context-state.sh    | Persist before rotation |
+---------------------------------------------------+

EVENT: Stop (3 hooks)
+---------------------------------------------------+
| session-summary.sh       | Save session summary    |
| pkb-ingest-reminder.sh   | Flag uningested content |
| pkb-lint.sh              | PKB health check        |
+---------------------------------------------------+
```

**Layer 4 --- Context Management**

| Mechanism | Description | Trigger |
|-----------|-------------|---------|
| 1M context window | Largest available; holds full pipeline state | Always active |
| Auto-recall injection | UserPromptSubmit hook -> QMD semantic search -> 2000 token injection | Every user message |
| Context compaction | PreCompact -> save-context-state.sh preserves critical state before Claude Code rotates context | Automatic at threshold |
| Session reconstruction | SessionStart -> session-reconstruct.sh rebuilds state from saved artifacts | Session start |
| Memory vault | Google Drive persistence for session summaries, daily notes | Stop hook |
| Strategic compact | Global PreToolUse hook warns when context is saturating | Every tool call |

**Layer 5 --- Agent Coordination**

| Property | Value |
|----------|-------|
| Sub-agent count | 4 (MECE: explorer, planner, builder, reviewer) |
| Nesting depth limit | 2 (Agent 0 + 1 sub-agent; no further nesting) |
| Dispatch protocol | 5-field context packaging (EO, INPUT, EP, OUTPUT, VERIFY) |
| Dispatch enforcement | PreToolUse: verify-agent-dispatch.sh |
| Completion enforcement | SubagentStop: verify-deliverables.sh |
| Nesting enforcement | PostToolUse: nesting-depth-guard.sh |

Agent roster and tool allocation:

```
+-------------+--------+-----------------------------------+
| Agent       | Model  | Tools                             |
+-------------+--------+-----------------------------------+
| ltc-explorer| haiku  | Read, Glob, Grep, Exa, QMD       |
| ltc-planner | opus   | Read, Grep, WebFetch, Exa, QMD   |
| ltc-builder | sonnet | Read, Edit, Write, Bash, Grep     |
| ltc-reviewer| opus   | Read, Glob, Grep, Bash            |
+-------------+--------+-----------------------------------+
```

**Layer 6 --- Rules (12 always-on)**

All rules live in `.claude/rules/` and auto-load at session start. They form the EP layer of the 7-CS --- documentation-level enforcement that the agent reads and follows probabilistically (LT-8).

```
agent-dispatch.md            -> EP-11, EP-13 (sub-agent invocation)
alpei-chain-of-custody.md    -> EP-01 (workstream ordering)
alpei-template-usage.md      -> EP-07 (template-first creation)
enforcement-layers.md        -> EP-05 (4x3 enforcement matrix)
naming-rules.md              -> EP-14 (UNG convention)
obsidian-security.md         -> EP-06 (CVE hard-block)
filesystem-routing.md        -> EP-05 (4-mode write routing)
memory-format.md             -> EP-07 (3-section MEMORY.md)
sub-agent-output.md          -> EP-10 (completion report format)
git-conventions.md           -> EP-14 (commit format)
versioning.md                -> EP-10 (version lifecycle)
example-api-conventions.md   -> EP-14 (API patterns)
```

**Layer 7 --- MCP Servers**

| Server | Purpose | Agent 0 Access | Sub-Agent Access |
|--------|---------|---------------|-----------------|
| Exa | Structured web search | Yes | Explorer, Planner only |
| QMD | Local knowledge search (2188 docs) | Yes | Explorer, Planner only |
| ClickUp | Task tracking (primary WMS) | Yes | No |
| Playwright | Browser automation | Yes | No |

**Layer 8 --- Filesystem and Git**

```
Project root: OPS_OE.6.4.LTC-PROJECT-TEMPLATE/
|
+-- 1-ALIGN/      (charter, decisions, OKRs)
+-- 2-LEARN/      (learning pipeline --- NO DSBV files)
+-- 3-PLAN/       (architecture, risks, drivers)
+-- 4-EXECUTE/    (src, tests, config, docs)
+-- 5-IMPROVE/    (changelog, metrics, retros)
+-- _genesis/     (frameworks, templates, reference --- read-only for projects)
+-- .claude/      (agents, rules, hooks, skills, settings)
+-- inbox/        (incoming captures)
+-- scripts/      (validation and utility scripts)
+-- CLAUDE.md     (200-line routing index)
+-- CHANGELOG.md  (PR-level changelog)
+-- VERSION       (repo version)
```

Git state: branch main, clean working tree, 20 commits ahead of remote.

---

**CRITICAL: Main Session vs Sub-Agent EOE Comparison**

This table is the single most important artifact in this document. The EOE asymmetry between Agent 0 and sub-agents defines the entire system's failure surface.

```
+---------------------------+-------------------+-------------------+
| EOE Layer                 | Agent 0           | Sub-Agents        |
|                           | (Main Session)    | (Dispatched)      |
+---------------------------+-------------------+-------------------+
| L1: Platform Runtime      | Full access       | Full access       |
+---------------------------+-------------------+-------------------+
| L2: Permissions           | Full (12 deny,    | INHERITED ---     |
|     (settings.json)       |  8 allow)         | same deny/allow   |
+---------------------------+-------------------+-------------------+
| L3: Hooks                 | ALL 15 hooks fire | NONE fire (LP-7)  |
|     (15 hooks, 6 events)  |                   | verified: 2026-04 |
+---------------------------+-------------------+-------------------+
| L4: Context Management    | Full:             | NONE:             |
|     - Auto-recall         |   yes             |   no              |
|     - Compaction hooks    |   yes             |   no              |
|     - Session reconstruct |   yes             |   no              |
|     - Memory vault        |   yes             |   no              |
+---------------------------+-------------------+-------------------+
| L5: Agent Coordination    | Agent() tool      | NO Agent() tool   |
|                           | (sole dispatcher) | (leaf nodes only) |
+---------------------------+-------------------+-------------------+
| L6: Rules                 | 12 always-on      | Agent file only   |
|     (auto-loaded)         | rules loaded      | (scope boundary)  |
+---------------------------+-------------------+-------------------+
| L7: MCP Servers           | All 5 servers     | Per agent file:   |
|                           |                   | Explorer: Exa,QMD |
|                           |                   | Planner: Exa,QMD  |
|                           |                   | Builder: none     |
|                           |                   | Reviewer: none    |
+---------------------------+-------------------+-------------------+
| L8: Filesystem & Git      | Full read/write   | Per agent tools:  |
|                           | (subject to L2)   | Builder: write    |
|                           |                   | Others: read-only |
+---------------------------+-------------------+-------------------+
```

**Decision D7 (2026-04-08):** WMS integration (Gap #4) dropped from I2/I3 agent improvement roadmap. ClickUp is primary WMS; ClickUp MCP quality too poor for automated agent→WMS sync. Manual WMS updates acceptable at I1-I3.

**Implications of EOE degradation (LP-7 learned pattern):**

1. **Hooks don't fire for sub-agents.** This means: naming-lint does not check sub-agent writes, dsbv-gate does not check sub-agent commits, status-guard does not block sub-agent self-approval, inject-frontmatter does not auto-inject metadata into sub-agent-created files. Every enforcement that hooks provide must be DUPLICATED in the agent file as a written constraint, or the orchestrator must post-verify after sub-agent completion.

2. **No memory access for sub-agents.** Sub-agents cannot read MEMORY.md or topic files. Every relevant fact must be explicitly included in the context packaging INPUT section. This is why EP-07 (Amnesia-First Design) exists.

3. **No auto-recall for sub-agents.** The QMD semantic search that injects 2000 tokens of relevant context per turn only fires for Agent 0. Sub-agents operate with only what was explicitly provided.

4. **No context compaction for sub-agents.** If a sub-agent hits its context limit, it truncates --- no save-context-state.sh fires, no strategic-compact.sh warns. The orchestrator must set appropriate budget limits in context packaging.

5. **No session lifecycle for sub-agents.** No SessionStart reconstruction, no Stop summary. Sub-agents are ephemeral --- they exist for one task and return.

**Frontier Standard**

- Hook mirroring: critical hooks (naming-lint, DSBV-gate) should have equivalent constraints baked into agent files, not just hook scripts
- Sub-agent sandboxing: explicit filesystem scope per agent (beyond tool-level read/write)
- EOE versioning: track which EOE configuration a sub-agent operated under for audit

**Gap Analysis**

| Gap ID | Description | Impact | Priority |
|--------|-------------|--------|----------|
| EOE-G1 | Hooks don't fire for sub-agents (LP-7) --- 15 enforcement mechanisms silently disabled | Sub-agent writes bypass naming-lint, DSBV-gate, status-guard, frontmatter injection | P0 |
| EOE-G2 | No hook-equivalent constraints in all agent files | Agent files have scope boundaries but not all hook-level checks as written rules | P0 |
| EOE-G3 | No sub-agent filesystem sandboxing beyond tool restrictions | Builder has Write tool but no path restriction in settings.json | P1 |
| EOE-G4 | MCP server access is inconsistent --- Builder has no search, Reviewer has no search | Builder cannot look up context; Reviewer cannot verify external claims | P2 |
| EOE-G5 | No EOE version tracking --- cannot audit which configuration a sub-agent operated under | Debugging sub-agent failures requires reconstructing EOE state | P2 |

**S x E x Sc Score**

| Dimension | Score | Rationale |
|-----------|-------|-----------|
| S (Sustainability) | 6/10 | Rich orchestrator EOE, but sub-agent EOE degradation is the #1 systemic risk |
| E (Efficiency) | 7/10 | 8-layer design is comprehensive; hooks are targeted with matchers |
| Sc (Scalability) | 6/10 | Adding hooks is easy; but no mechanism to propagate constraints to sub-agents |

**UBS/UDS**

| Force | Category | Description |
|-------|----------|-------------|
| UBS-1 | Technical | LP-7: hooks silent for sub-agents --- largest single enforcement gap in the system |
| UBS-2 | Technical | Sub-agent context is a strict subset of orchestrator context --- information loss at every dispatch |
| UBS-3 | Temporal | 15 hooks add latency to every tool call (~1-5s each); compounds over long sessions |
| UBS-4 | Technical | MCP servers not available to Builder/Reviewer --- they cannot self-verify external facts |
| UDS-1 | Technical | 8-layer design is the most comprehensive agent EOE documented in LTC |
| UDS-2 | Technical | Permission system (L2) is inherited --- the one guarantee that holds for sub-agents |
| UDS-3 | Technical | SubagentStop + verify-deliverables.sh provides post-hoc validation of sub-agent output |

---

### EOT --- Effective Operating Tools

**Current State**

Agent 0 has access to ALL tools in the Claude Code platform. No other entity in the system has this breadth.

| Tool Category | Tools | Orchestrator Exclusive? |
|---------------|-------|----------------------|
| File I/O | Read, Write, Edit | No (shared with sub-agents per agent file) |
| Search | Grep, Glob | No (shared) |
| Execution | Bash | No (Builder, Reviewer have it) |
| Agent Dispatch | Agent() | YES --- orchestrator only |
| Task Management | TaskCreate, TaskUpdate | YES --- orchestrator only |
| Notebook | NotebookEdit | YES --- orchestrator only |
| Web | WebFetch, WebSearch | Partially (Planner has WebFetch) |
| MCP: Search | mcp__exa__*, mcp__qmd__* | No (Explorer, Planner share) |
| MCP: WMS | mcp__notion__*, mcp__clickup__* | YES --- orchestrator only |
| MCP: Browser | mcp__playwright__* | YES --- orchestrator only |

**Tool-to-LT Compensation Map:**

| Tool | Primary LT Compensated | How |
|------|----------------------|-----|
| Grep, Glob | LT-4 (fragile retrieval) | Deterministic file search vs agent guessing |
| Bash (scripts) | LT-8 (approximate alignment) | Deterministic script execution vs probabilistic rule-following |
| Agent() | LT-3 (reasoning degradation) | Decompose complex tasks to specialized models |
| MCP: QMD | LT-6 (no persistent memory) | Semantic search over past sessions |
| MCP: Notion | LT-6 (no persistent memory) | Access authoritative task state |
| Read | LT-1 (hallucination) | Verify file contents instead of guessing |

**Frontier Standard**

- Tool usage analytics: track which tools are called, by whom, success rate, to identify underused or failing tools
- Tool composition: allow chaining tools declaratively (e.g., "Grep -> Read -> Edit" as a single macro)
- Sub-agent tool budget: limit total tool calls per sub-agent dispatch to prevent runaway execution

**Gap Analysis**

| Gap ID | Description | Impact | Priority |
|--------|-------------|--------|----------|
| EOT-G1 | No tool call budget per sub-agent dispatch | Runaway Builder could make hundreds of tool calls | P1 |
| EOT-G2 | No tool usage analytics | Cannot identify failing or underused tools | P2 |
| EOT-G3 | Agent() tool has no built-in retry mechanism | Orchestrator must manually re-dispatch on failure | P1 |

**S x E x Sc Score**

| Dimension | Score | Rationale |
|-----------|-------|-----------|
| S (Sustainability) | 7/10 | Comprehensive tool set; deterministic tools compensate for LT-1/4/8 |
| E (Efficiency) | 6/10 | No tool budgets; no composition; manual retry |
| Sc (Scalability) | 7/10 | MCP server architecture allows adding new tools without code changes |

**UBS/UDS**

| Force | Category | Description |
|-------|----------|-------------|
| UBS-1 | Technical | Agent() has no retry/timeout --- failed sub-agent = manual intervention |
| UBS-2 | Economic | Each tool call consumes tokens; no budget enforcement at tool level |
| UDS-1 | Technical | Agent() is the most powerful tool --- enables the entire multi-agent architecture |
| UDS-2 | Technical | Deterministic tools (Grep, Bash) compensate for 3 of 8 LTs |

---

### EOP --- Effective Operating Procedure

**Current State**

Agent 0's procedures are encoded in skills (interactive workflows) and rules (passive constraints).

**Active Skills (orchestrator-relevant):**

| Skill | Trigger | Procedure |
|-------|---------|-----------|
| /dsbv | DSBV lifecycle management | Guided G1-G4 flow with context-packaged Agent() calls |
| /resume | Session resumption | Load memory, reconstruct state, identify pending work |
| /compress | Session compression | Save critical state, compact context, continue |
| /learn | Learning pipeline | Orchestrate 6-state LEARN pipeline (not DSBV) |
| /deep-research | Deep research dispatch | Configure and dispatch ltc-explorer with depth budget |
| /git-save | Git operations | Classify, stage, commit with conventions |
| /ltc-skill-creator | Skill creation | Guided EOP-GOV-compliant skill creation |
| /ltc-feedback | Feedback capture | Structured GitHub Issue with 7-CS force analysis |

**Context Packaging Protocol (per dispatch):**

```
Step 1: Define EO (what success looks like)
Step 2: Structure INPUT (context + files + budget)
Step 3: State EP (2-3 applicable principles + constraints)
Step 4: Define OUTPUT (deliverable + acceptance criteria)
Step 5: Define VERIFY (deterministic post-checks)
```

Enforcement: verify-agent-dispatch.sh fires PreToolUse on every Agent() call.

**DSBV Gate Procedure:**

```
G1 (Design gate):   Human approves DESIGN.md before Sequence
G2 (Sequence gate):  Human approves SEQUENCE.md before Build
G3 (Build gate):     Human approves artifacts before Validate
G4 (Validate gate):  Human approves VALIDATE.md -> workstream complete
```

Each gate requires explicit human approval. Agent 0 presents; Human Director decides.

**Pre-Flight Protocol (9 checks, from CLAUDE.md):**

```
1. WORKSTREAM    -> /dsbv status
2. ALIGNMENT     -> charter + EO
3. RISKS         -> UBS register
4. DRIVERS       -> UDS register
5. TEMPLATES     -> process map routing
6. LEARNING      -> 2-LEARN/ check
7. VERSION       -> metadata consistency
8. EXECUTE       -> S > E > Sc
9. DOCUMENT      -> decisions in 1-ALIGN/
```

**Execution Mode Decision Tree (MISSING — CRITICAL GAP)**

The /dsbv skill hard-codes 2 execution modes only (competing hypotheses vs single agent).
This is insufficient. The orchestrator must evaluate ALL 6 modes against 8 LTs before choosing:

```
SEQUENCE Phase Step 0: Choose Execution Mode
─────────────────────────────────────────────
For each task, score 4 dimensions:

  EOE sensitivity:  Does it need hooks/memory/rules?     HIGH → main session or agent team
  Independence:     Can it run without other tasks' EO?   HIGH → parallel
  Complexity:       >1hr human-equivalent?                HIGH → decompose further
  Stakes:           Blast radius if wrong?                HIGH → Opus, not Sonnet

Mode selection matrix:

  ┌──────────────────────┬──────────────┬───────────────────────────────────────────┐
  │ Mode                 │ When         │ LT Compensated                            │
  ├──────────────────────┼──────────────┼───────────────────────────────────────────┤
  │ Main session direct  │ EOE-HIGH +   │ LT-8 (all hooks fire), LT-3 (Opus        │
  │ (no sub-agent)       │ Stakes-HIGH  │ reasoning), LT-2 (full context mgmt)      │
  ├──────────────────────┼──────────────┼───────────────────────────────────────────┤
  │ Agent team           │ EOE-HIGH +   │ LT-8 (full hooks per session) +           │
  │ (parallel full       │ Independent  │ LT-3 (parallel independent reasoning)     │
  │  sessions)           │              │ Cost: highest. Use for critical parallel   │
  ├──────────────────────┼──────────────┼───────────────────────────────────────────┤
  │ Parallel sub-agents  │ EOE-LOW +    │ LT-5 (diverse perspectives),              │
  │ (competing hyp.)     │ Independent  │ LT-3 (decomposed). Degraded EOE accepted  │
  ├──────────────────────┼──────────────┼───────────────────────────────────────────┤
  │ Single sub-agent     │ EOE-LOW +    │ LT-3 (focused), LT-7 (cheapest).          │
  │ (sequential)         │ Simple       │ Well-scoped tasks with clear ACs           │
  ├──────────────────────┼──────────────┼───────────────────────────────────────────┤
  │ Hybrid               │ Mixed needs  │ Team for EOE-sensitive tasks,              │
  │ (team + sub-agents)  │ per task     │ sub-agents for rest. Best S×E×Sc for       │
  │                      │              │ complex workstreams                        │
  ├──────────────────────┼──────────────┼───────────────────────────────────────────┤
  │ Human direct         │ Judgment-    │ UT#6 (human bias awareness), UT#5          │
  │ (no AI execution)    │ only tasks   │ (some decisions need human System 2 only)  │
  └──────────────────────┴──────────────┴───────────────────────────────────────────┘
```

**Current state:** Only modes 3 and 4 are documented in /dsbv. Modes 1, 2, 5, 6 are used in practice but never formalized. The planner/SEQUENCE phase has no decision tree — it picks from a 2-row table.

**Frontier Standard**

- Execution mode decision tree evaluated per-task at SEQUENCE time (above)
- Automated pre-flight: script that runs all 9 checks and returns pass/fail matrix before task start
- Generator/Critic loop: orchestrator-managed Builder -> Reviewer -> Builder retry with max_iterations=3 and exit_condition (all ACs pass OR circuit breaker)
- Pipeline state machine: explicit state transitions with persistence
- Error classification: syntactic (format wrong) / semantic (content wrong) / environmental (tool failed) triage before deciding retry vs escalate

**Gap Analysis**

| Gap ID | Description | Impact | Priority |
|--------|-------------|--------|----------|
| EOP-G0 | **No execution mode decision tree** --- /dsbv hard-codes 2 modes, ignores 4 others (main session, agent teams, hybrid, human-only) | Orchestrator can't choose optimal mode per task; defaults to sub-agents even when full EOE is needed | **P0** |
| EOP-G1 | Pre-flight protocol is manual --- relies on agent reading CLAUDE.md and following 9 checks | Checks skipped under complex prompts (LT-8); no enforcement | P0 |
| EOP-G2 | No Builder/Reviewer retry loop procedure | Manual re-dispatch on every validation failure | P0 |
| EOP-G3 | No error classification taxonomy | Agent 0 retries semantic errors that need redesign, or escalates fixable format issues | P1 |
| EOP-G4 | No pipeline state machine --- DSBV flow is procedural knowledge in /dsbv skill, not persistent state | Session death = pipeline progress lost | P1 |

**S x E x Sc Score**

| Dimension | Score | Rationale |
|-----------|-------|-----------|
| S (Sustainability) | 6/10 | DSBV gates and context packaging exist; but pre-flight is unenforced and no retry loop |
| E (Efficiency) | 5/10 | Manual re-dispatch on failures; 9-check pre-flight is overhead without automation |
| Sc (Scalability) | 6/10 | Skill system is extensible; but adding new procedures = more agent reading (LT-2 pressure) |

**UBS/UDS**

| Force | Category | Description |
|-------|----------|-------------|
| UBS-1 | Technical | Pre-flight protocol is probabilistic enforcement only (LT-8) |
| UBS-2 | Human | Human Director must manually trigger retry cycles --- attention cost |
| UBS-3 | Technical | No persistent pipeline state --- session rotation loses progress |
| UDS-1 | Technical | Context packaging is the strongest EOP mechanism --- standardizes every dispatch |
| UDS-2 | Technical | DSBV gate structure provides 4 human checkpoints per workstream |
| UDS-3 | Technical | EOP-GOV codex provides quality standards for all skills |

---

## Handoff Contracts

### Upstream: Human Director -> Orchestrator

| Property | Specification |
|----------|--------------|
| Input format | Natural language messages (unstructured) |
| Expected content | Intent (what to achieve), scope (which workstream/artifact), constraints (time, quality, budget) |
| Minimum viable input | A clear EO statement: "{verb} {noun} {constraint}" |
| Orchestrator obligation | Parse intent, run pre-flight protocol, identify DSBV phase, propose plan before executing |
| Human obligation | Approve/reject at G1-G4 gates; provide validated status when satisfied |
| Escalation path | If intent is ambiguous, orchestrator asks clarifying questions before proceeding |

### Downstream: Orchestrator -> Sub-Agents

**Universal contract (all sub-agents):**

| Property | Specification |
|----------|--------------|
| Dispatch format | 5-field context packaging (EO, INPUT, EP, OUTPUT, VERIFY) |
| Enforcement | verify-agent-dispatch.sh PreToolUse hook |
| Sub-agent obligation | Execute within scope, return completion report, never spawn further agents |
| Orchestrator obligation | Provide sufficient context (EP-07), define done (EP-10), verify output (VERIFY section) |
| Completion format | `DONE: <path> | ACs: <pass>/<total> | Blockers: <none or list>` |
| Post-completion | verify-deliverables.sh (SubagentStop hook) confirms artifact exists |

**Per-agent contract specifics:**

| Agent | EI from Orchestrator | EO to Orchestrator | Failure Mode |
|-------|---------------------|-------------------|-------------|
| ltc-explorer | Research question + depth budget + search terms | Structured findings with sources + confidence levels + unknowns | Unsourced claims; exceeds depth budget; hallucinates URLs |
| ltc-planner | Workstream context + reference docs + synthesis criteria | DESIGN.md or SEQUENCE.md with completion conditions mapped to artifacts | Orphan conditions; non-testable criteria; scope creep |
| ltc-builder | SEQUENCE.md task + input files + acceptance criteria | Artifact at specified path + completion report | Missing frontmatter; broken brand; skipped ACs |
| ltc-reviewer | DESIGN.md criteria + all produced artifacts | VALIDATE.md with per-criterion verdicts + file-path evidence | Rubber-stamping; missing criteria; verdicts without evidence |

---

## Improvement Proposals

Prioritized by S > E > Sc (DT#1). Each proposal grounded in a specific gap, EP, and frontier pattern.

### P0 --- Must-Fix (Sustainability)

**P0-1: Builder/Reviewer Retry Loop**
- Gap: EA-G1, EOP-G2
- EP: EP-01 (Brake Before Gas), EP-13 (Orchestrator Authority)
- Frontier: Generator/Critic loop pattern (68% of production orchestrators)
- Proposal: Implement a managed retry procedure in /dsbv skill:
  ```
  Builder produces -> Reviewer validates -> if any FAIL:
    Iteration 1: re-dispatch Builder with FAIL items + Reviewer evidence
    Iteration 2: re-dispatch Builder with updated guidance
    Iteration 3: STOP -> escalate to Human Director with full diagnostic
  max_iterations = 2 (before escalation)
  exit_condition = all ACs PASS in VALIDATE.md
  ```
- Implementation: Update `.claude/skills/dsbv/SKILL.md` Build phase section

**P0-2: Circuit Breaker**
- Gap: EA-G2
- EP: EP-01 (Brake Before Gas), EP-05 (Gates Before Guides)
- Frontier: Circuit breaker pattern (error classification + escalation)
- Proposal: After 2 consecutive failures on the same task by the same sub-agent:
  ```
  1. Classify error: syntactic / semantic / environmental
  2. If syntactic: retry with explicit format correction
  3. If semantic: escalate to Human Director (content problem, not agent problem)
  4. If environmental: fix environment, then retry
  5. If 2nd retry fails: hard stop, present full diagnostic
  ```
- Implementation: Add error classification to /dsbv skill + escalation procedure

**P0-3: Hook Constraint Mirroring in Agent Files**
- Gap: EOE-G1, EOE-G2
- EP: EP-05 (Gates Before Guides), EP-14 (Script-First Delegation)
- Frontier: Hook mirroring pattern
- Proposal: For every PreToolUse hook that enforces a constraint, add the equivalent written constraint to all agent files whose tools match the hook's matcher. Priority hooks to mirror:
  ```
  naming-lint.sh    -> Builder agent file: "Follow UNG naming for all created files"
  dsbv-gate.sh      -> Builder agent file: "Verify DSBV boundary before git commit"
  status-guard.sh   -> All agent files: "NEVER set status: validated"
  inject-frontmatter -> Builder agent file: "Include version/status/last_updated frontmatter"
  ```
- Implementation: Edit `.claude/agents/ltc-builder.md`, `ltc-reviewer.md`, etc.

**P0-4: Pre-Flight Automation**
- Gap: EOP-G1
- EP: EP-14 (Script-First Delegation), EP-05 (Gates Before Guides)
- Proposal: Create `scripts/pre-flight.sh` that runs the 9 CLAUDE.md checks deterministically. Add as SessionStart hook or PreToolUse on first Write|Edit per session.
- Implementation: New script + settings.json hook entry

### P1 --- Should-Fix (Efficiency)

**P1-1: Pipeline State Persistence**
- Gap: EI-G3, EOP-G4
- EP: EP-07 (Amnesia-First Design)
- Frontier: Orchestration state persistence pattern
- Proposal: Create `.claude/state/pipeline.json` tracking:
  ```json
  {
    "workstream": "4-EXECUTE",
    "phase": "build",
    "task_id": "T3.2",
    "completed_tasks": ["T1.1", "T1.2", ...],
    "last_sub_agent": "ltc-builder",
    "last_result": "PASS",
    "updated": "2026-04-08T14:30:00Z"
  }
  ```
  Update after every sub-agent completion. Read at SessionStart for reconstruction.
- Implementation: state-saver.sh update + session-reconstruct.sh integration

**P1-2: Auto-Recall Relevance Filtering**
- Gap: EI-G2
- EP: EP-08 (Signal Over Volume), EP-04 (Load What You Need)
- Proposal: Add intent-based filtering to auto-recall: extract current task type from user message, pass as `intent` parameter to QMD query, reduce injection from 2000 to 1000 tokens when confidence < 0.5.
- Implementation: Update UserPromptSubmit hook with intent extraction

**P1-3: Structured Gate Reports**
- Gap: EO-G1
- EP: EP-10 (Define Done)
- Proposal: Standardize orchestrator gate presentations:
  ```
  GATE: G{N} ({phase}) | Workstream: {name}
  ACs: {pass}/{total} | Risk flags: {count}
  Action: APPROVE / REVISE / ESCALATE
  ---
  [details]
  ```
- Implementation: Add template to /dsbv skill

**P1-4: Error Classification Taxonomy**
- Gap: EOP-G3
- EP: EP-01 (Brake Before Gas)
- Proposal: Define three error classes with distinct handling:
  ```
  SYNTACTIC  -> format/structure wrong  -> retry with format correction
  SEMANTIC   -> content/logic wrong     -> escalate to human or redesign
  ENVIRONMENTAL -> tool/config failure  -> fix env, then retry
  ```
- Implementation: Add to /dsbv skill references/

### P2 --- Nice-to-Have (Scalability)

**P2-1: Sub-Agent Tool Call Budgets**
- Gap: EOT-G1
- Proposal: Add `budget: {max_tool_calls: N}` to context packaging. Builder default: 50. Explorer default: 20.

**P2-2: EP Task-Type Filtering**
- Gap: EP-G1
- Proposal: Map task types to applicable EPs. Research tasks load EP-01/04/08. Build tasks load EP-01/05/10/14. Reduce from 14 -> 3-5 per task.

**P2-3: Parallel Sub-Agent Dispatch**
- Gap: EA-G3
- Proposal: When tasks are independent (e.g., Explorer researching topic A while Builder produces artifact B), dispatch both simultaneously. Requires explicit independence declaration in SEQUENCE.md.

**P2-4: EOE Version Tracking**
- Gap: EOE-G5
- Proposal: Log EOE configuration hash at each sub-agent dispatch for audit trail.

---

## S x E x Sc Summary

```
+-----------+-----+-----+-----+-------------------------------------------+
| Component | S   | E   | Sc  | Primary Risk                              |
+-----------+-----+-----+-----+-------------------------------------------+
| EI        | 7   | 5   | 6   | Pipeline state lost on session death      |
| EU        | 8   | 5   | 7   | Opus cost; no confidence self-assessment  |
| EA        | 5   | 6   | 6   | No retry loop or circuit breaker          |
| EO        | 6   | 6   | 5   | Unstructured orchestrator output          |
| EP        | 8   | 6   | 7   | 14 EPs always loaded; no conflict rules   |
| EOE       | 6   | 7   | 6   | LP-7: hooks silent for sub-agents         |
| EOT       | 7   | 6   | 7   | No tool call budgets; no Agent() retry    |
| EOP       | 6   | 5   | 6   | Pre-flight unenforced; no retry procedure |
+-----------+-----+-----+-----+-------------------------------------------+
| AGGREGATE | 6.6 | 5.8 | 6.3 |                                           |
+-----------+-----+-----+-----+-------------------------------------------+

Weakest dimension: Efficiency (5.8)
  Root cause: Manual re-dispatch cycles, unfiltered auto-recall, no parallel dispatch.

Weakest component: EA (5/6/6)
  Root cause: No automated failure recovery. Every sub-agent failure
  requires human intervention to retry.

Strongest component: EP (8/6/7)
  Root cause: 14 EPs grounded in LTs/UTs with 11:3 DERISK:OUTPUT ratio.

System health: FUNCTIONAL but FRAGILE on failure paths.
  Happy path (no sub-agent failures) works well.
  Unhappy path (sub-agent fails) degrades to manual orchestration.
```

**Overall Assessment (grounded in UT#5):**

Success = efficient and scalable management of failure risks. Agent 0's happy path is well-designed (context packaging, DSBV gates, MECE agents). But its failure path --- what happens when sub-agents produce wrong output --- is almost entirely manual. The top priority is P0-1 (retry loop) and P0-2 (circuit breaker), which transform the orchestrator from a single-shot dispatcher into a resilient pipeline manager.

---

## Cross-Agent Review (2026-04-08, Phase 1 Review)

### Aggregate Scorecard

```
Agent     │ S    │ E    │ Sc   │ Weakest Component      │ Critical Finding
──────────┼──────┼──────┼──────┼────────────────────────┼──────────────────────────
0 Orch    │ 6.6  │ 5.8  │ 6.3  │ EA (5/6/6)             │ No retry loop, no circuit breaker
1 Explorer│ 7.6  │ 7.0  │ 8.4  │ EO (6/5/7)             │ WebSearch false claim (BUG-1/2/3/4)
2 Planner │ 5.9  │ 5.6  │ 6.3  │ EP (4/10 S), EOE(4/10) │ EP-13 false orchestrator claim
3 Builder │ 5.9  │ 6.9  │ 7.3  │ EOE (3/6/5)            │ 14 of 15 hooks lost — CRITICAL
4 Reviewer│  ~8  │  ~6  │  ~6  │ EOP (8/5/4)            │ No auto-retry loop, no aggregate score
```

### Cross-Agent Inconsistencies

| # | Issue | Agents | Fix At |
|---|-------|--------|--------|
| 1 | WMS reference corrected: ClickUp primary, Notion removed, WMS integration dropped (D7) | Orchestrator | DONE (this edit) |
| 2 | Planner Action 4 mentions "Learn Pipeline Orchestration" — LEARN interaction not fully designed | Planner | Defer to I2 |
| 3 | Reviewer proposes VALIDATE.md v2 format but Orchestrator EOP doesn't reference it | Orch ↔ Reviewer | Build phase |
| 4 | Builder proposes handoff.json but no agent explicitly handles receiving it | Builder ↔ all | Build phase |

### Cross-Agent Consistency Verified

- 8-component structure: ✓ All 5
- S×E×Sc per component: ✓ All 5
- Dispatch modes section: ✓ All 5
- Handoff contracts (E→P→B→R→Human): ✓ Full chain
- EP-13 leaf node: ✓ 3 of 4 (Planner bug documented, P0 fix)
- Hook degradation: ✓ All 4 sub-agents
- Generator/Critic loop: ✓ Agents 0, 3, 4 consistent
- Rules loading status: ✓ Consistently UNCLEAR

### Consolidated P0 Fixes (SEQUENCE must include all)

| # | Fix | Agent | Effort | File(s) |
|---|-----|-------|--------|---------|
| 1 | Fix EP-13 false orchestrator claim (4 locations) | Planner | 5 min | `.claude/agents/ltc-planner.md` |
| 2 | Remove WebSearch false claims | Explorer | 10 min | `ltc-explorer.md`, `deep-research/SKILL.md`, `learn-research/SKILL.md` |
| 3 | Add Glob to explorer Tool Guide table | Explorer | 5 min | `ltc-explorer.md` |
| 4 | Generator/Critic loop in `/dsbv` skill | Orchestrator | 1-2 hrs | `.claude/skills/dsbv/SKILL.md` |
| 5 | Circuit breaker (error classification + escalation) | Orchestrator | 30 min | `.claude/skills/dsbv/SKILL.md` |
| 6 | Hook constraint mirroring in all 4 agent files | All sub-agents | 30 min | All 4 agent `.md` files |
| 7 | Pre-flight automation script | Orchestrator | 30 min | `scripts/pre-flight.sh`, `settings.json` |
| 8 | Explicit validation scripts in builder EOP | Builder | 15 min | `.claude/agents/ltc-builder.md` |

### 5 Deferred Gaps — Confirmed I2+

1. Sub-system layer (PD→DP→DA→IDM) — not addressed ✓ I2
2. LEARN pipeline agent interaction — briefly mentioned, not designed ✓ I2
3. Cross-project usage — not addressed ✓ I2
4. Real dispatch data — not addressed ✓ I2
5. VANA specs — proposals in prose, not VANA format ✓ I2

### Decision D8 (2026-04-08): Agent SDK Ceiling

Claude Code Agent() + Agent SDK reaches I3 without external frameworks. Hard limits: no nested sub-agents (depth=1), no peer negotiation. I4 requires LangGraph/Agno. For I1-I2, native Agent() is sufficient. SDK is "nice to have at I3."

### Review Verdict

**G1 APPROVED with 8 P0 fixes.** DESIGNs are thorough, internally consistent, and correctly scoped for I1. Proceed to SEQUENCE.md then BUILD.

---

The EOE asymmetry (LP-7) is the deepest structural risk. It means that every enforcement mechanism invested in hooks (15 of them) provides zero protection for sub-agent execution. P0-3 (hook constraint mirroring) partially mitigates this, but the fundamental architecture --- hooks fire only for the main session --- is a platform constraint, not a configuration choice.
