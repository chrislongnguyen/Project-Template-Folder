---
version: "1.1"
status: draft
last_updated: 2026-04-12
---

# Agent Harness System — Flow Charts

> Companion to `agent-harness-system.md`. Shows HOW the 8 components interact.
> Grounded in: System Thinking & Design Notes V2, Agent System 8-CS, Harness Engineering Research (28 sources).
> Use for: **building** (what connects to what), **measuring** (where to observe), **diagnosing** (which edge failed).
> **Portability note:** Parts 1, 2, 4 (model, edges, metrics) are platform-agnostic. Part 3 (execution flows) uses Claude Code as the reference implementation — map hook names and model tiers to your platform's equivalents.

---

## Notation

| Symbol | Meaning |
|--------|---------|
| `──▶` | Data/information flow (directed edge) |
| `══▶` | Control flow (governance, enforcement) |
| `─ ─▶` | Feedback flow (loop back) |
| `[ ]` | Node (component or sub-component) |
| `{ }` | Measurement point (observable metric) |
| `⊗` | Gate (human or automated checkpoint) |

---

# PART 1 — HIGH-LEVEL FLOW

---

## 1.1 The 8-Component System Map

8 nodes. 14 directed edges. 6 controllable components. 2 emergent. This is the complete system.

```
 ┌─────────────────────────────────────────────────────────────────────────────────┐
 │                                                                                 │
 │   DIRECT CONTROL (we author/configure)         INDIRECT CONTROL (we shape)      │
 │   ─────────────────────────────────────         ─────────────────────────────    │
 │                                                                                 │
 │                ┌────────┐                                                       │
 │                │   EP   │ ◄─── Constitution                                     │
 │                │        │      (governs all)                                    │
 │                └───┬────┘                                                       │
 │         ┌──────────┼──────────┬──────────┐                                      │
 │         │ E3       │ E4       │ E5       │                                      │
 │         ║          ║          ║          │                                      │
 │         ▼          ▼          ▼     E2   ▼                                      │
 │    ┌────────┐ ┌────────┐ ┌────────┐ ║  ┌─────────────────────────────────┐     │
 │    │  EOE   │ │  EOT   │ │  EOP   │ ║  │                                 │     │
 │    │        │ │        │ │        │ ║  │        EI (THE GATEWAY)          │     │
 │    │Temporal│ │Inspect │ │Orchest.│ ║  │                                 │     │
 │    │Spatial │ │Discover│ │Execute │ ║  │  All 4 direct-control           │     │
 │    │Quantit│ │Modify  │ │Verify  │ ║  │  components feed INTO here.     │     │
 │    │Author. │ │Interact│ │Recover │ ║  │  EU sees ONLY what passes      │     │
 │    └───┬────┘ └───┬────┘ └───┬────┘ ║  │  through EI.                   │     │
 │        │ E7       │          │      ║  │                                 │     │
 │        ╠═════════▶│          │      ║  │  ┌───────────┐ ┌───────────┐   │     │
 │        │          │          │      ║  │  │ Directive  │ │Contextual │   │     │
 │        │ E6       │ E8       │ E9   ║  │  │ (what to   │ │(what to   │   │     │
 │        │          │          │      ▼  │  │  do)       │ │ know)     │   │     │
 │        ▼          ▼          ▼         │  └───────────┘ └───────────┘   │     │
 │    ┌───────────────────────────────────┤  ┌───────────┐                 │     │
 │    │                                   │  │ Corrective │                 │     │
 │    │        EU (Agent / Model)     ◄───┤  │ (what to   │                 │     │
 │    │                                   │  │  fix)      │                 │     │
 │    │  Capability × Configuration       │  └───────────┘                 │     │
 │    │  within 8 LT constraints      E1 │                                 │     │
 │    │                            ◄──────┤                                 │     │
 │    └────────────┬──────────────────────┘─────────────────────────────────┘     │
 │                 │ E14(invokes)                                                  │
 │                 │ E10(produces)                                                 │
 │                 │                                                               │
 └─────────────────┼───────────────────────────────────────────────────────────────┘
                   │
                   │
   EMERGENT        │        (observe and measure — do not configure)
   ─────────       │
                   ▼
            ┌────────────┐
            │     EA     │ ◄─── Trace, Quality, Efficiency
            │  (observe) │
            └─────┬──────┘
                  │ E11
                  ▼
            ┌────────────┐          ┌──────────────────────────────────────┐
            │     EO     │── E12 ──▶│  EI (Corrective feedback for next   │
            │  (measure) │          │  turn enters as Corrective input)    │
            │            │── E13 ──▶│  EP/EOE/EOT/EOP (improvement signal │
            │ S × E × Sc │          │  informs harness evolution)          │
            └────────────┘          └──────────────────────────────────────┘
```

---

## 1.2 Edge Catalog — All 14 Interactions

Every edge is a relationship that can be measured, tuned, or broken. Each edge has a dedicated or grouped diagram in Part 2.

| # | From | To | Type | Mechanism | Measurable Signal | Diagram |
|---|------|----|------|-----------|-------------------|---------|
| E1 | EI | EU | feeds | Directive + Contextual + Corrective input loaded | Token count, signal-to-noise | §2.1 |
| E2 | EP | EU | governs | Behavioral principles constrain agent actions | Rule compliance rate | §2.2 |
| E3 | EP | EOE | governs | Structural principles define hook/permission config | Config-to-rule alignment | §2.2 |
| E4 | EP | EOT | governs | Structural principles define tool descriptions/contracts | Tool description quality | §2.2 |
| E5 | EP | EOP | governs | Relational principles define workflow gates/handoffs | Gate coverage per procedure | §2.2 |
| E6 | EOE | EU | limits | Temporal + Spatial + Quantitative + Authorization bounds | Permission denial rate, context % | §2.3 |
| E7 | EOE | EOT | limits | Authorization bounds restrict tool availability per agent | Tool availability per agent | §2.4 |
| E8 | EOT | EU | extends | Inspection/Discovery/Modification/Interaction capabilities | Tool call success rate | §2.5 |
| E9 | EOP | EU | orchestrates | Orchestration/Execution/Verification/Recovery sequences | Steps per task, gate pass rate | §2.6 |
| E10 | EU | EA | produces | Agent inference + tool calls produce observable actions | Trace completeness | §2.7 |
| E11 | EA | EO | yields | Actions produce measurable outcomes | S × E × Sc metrics | §2.8 |
| E12 | EO | EI | feedback | Corrective signal: what worked, what failed | Feedback incorporation rate | §2.8 |
| E13 | EO | Harness | improvement | Outcome data informs harness evolution | Iteration-over-iteration EO delta | §2.9 |
| E14 | EU | EOT | invokes | Agent calls tools during execution | Tool calls per task | §2.5 |

---

## 1.3 Feedback Loops

From System Thinking & Design Notes V2: every loop is either Balancing or Reinforcing.

### 1.3.1 Reinforcing Loop — Compounding Improvement

```
  ┌──────────────────────────────────────────────────────────────┐
  │                                                              │
  ▼                                                              │
[Better EP/EOE/EOT/EOP]                                         │
  │                                                              │
  ├──▶ shapes better EI (gateway receives higher-quality input)  │
  │                                                              │
  ▼                                                              │
[Better EU inference] ──▶ [Better EA] ──▶ [Better EO]           │
                                              │                  │
                                              ├──▶ E12: Better  │
                                              │    Corrective EI │
                                              │                  │
                                              └──▶ E13: Better  │
                                                   harness ─────┘

  Type:    REINFORCING — success compounds
  Trigger: First good output that generates positive Corrective feedback
  Risk:    Works in reverse — bad output → less trust → less investment → worse output
  Ref:     System Thinking V2, §Layer 2 — Reinforcing loops
```

### 1.3.2 Balancing Loop — Quality Gate

```
  ┌──────────────────────────────────────────┐
  │                                          │
  ▼                                          │
[EU produces EA]                             │
  │                                          │
  ▼                                          │
[EOP-Verification checks against criteria]   │
  │                                          │
  ├── PASS ──▶ [EO emitted]                 │
  │                                          │
  └── FAIL ──▶ [EOP-Recovery]               │
                  │                          │
                  ▼                          │
              [EU retries with               │
               Corrective input] ────────────┘

  Type:    BALANCING — output below criteria triggers correction
  Purpose: Prevents error compounding (95% per-step = 59% at 10 steps)
  Ref:     Meadows' leverage point #8 — balancing loop strength sets quality floor
```

### 1.3.3 The Delay Risk

```
  FREQUENT gates (per-step):            INFREQUENT gates (per-task):

  [Step 1] ──▶ ⊗ ──▶ [Step 2]          [Step 1] ──▶ [Step 2] ──▶ ... ──▶ [Step 10]
                                                                              │
  Error caught at step 1.                                                     ▼
  Cost: 1 step of rework.                                              ⊗ (too late)
                                                                              │
                                        Error from step 1 compounded          ▼
                                        through 9 more steps.          [Expensive
                                        Cost: full rework.              rework]

  Implication: Verification gates MUST fire per-step, not per-task.
  Ref: System Thinking V2, §Delays — a balancing loop with long delay produces oscillation.
```

---

## 1.4 The Multiplicative Function

From System Thinking V2: the output function is multiplicative, not additive. If any component goes to zero, EO goes to zero.

```
  EO = EP_eff × EI_eff × EOP_eff × EOE_eff × EOT_eff × EU_eff

  Where each component's effectiveness follows a sigmoid (Hill function):

      C_eff = C^n / (C^n + K^n)

      C = current investment/quality
      K = half-max (center of leverage zone)
      n = steepness of transition
```

### Sigmoid Zone Assessment

```
  ┌──────────┬──────────┬──────────┬──────────┬──────────┬──────────┐
  │  EP_eff  │  EI_eff  │ EOP_eff  │ EOE_eff  │ EOT_eff  │  EU_eff  │
  │          │          │          │          │          │          │
  │     ╭──  │     ╭──  │     ╭──  │     ╭──  │     ╭──  │     ╭──  │
  │   ╱      │   ╱      │   ╱      │   ╱      │   ╱      │   ╱      │
  │  ╱       │  ╱       │  ╱       │  ╱       │  ╱       │  ╱       │
  │ ╱        │ ╱        │ ╱        │ ╱        │ ╱        │ ╱        │
  │╱         │╱         │╱         │╱         │╱         │╱         │
  └──────────┴──────────┴──────────┴──────────┴──────────┴──────────┘
  Investment   Investment  Investment  Investment  Investment  Investment

  Zone:   ?          ?          ?          ?          ?          ?
  Action: Invest where sigmoid is STEEPEST (leverage zone).
          First component below threshold is the current bottleneck.
```

### Cross-Component Threshold Modulation

```
  Strong EP  ──▶ lowers K for EI  (agent needs LESS context when rules are clear)
  Strong EOE ──▶ lowers K for EOP (procedures need LESS detail when hooks enforce)
  Weak EP    ──▶ raises K for ALL (every other component must compensate)

  Highest leverage: strengthen component X to lower component Y's threshold (synergy).
  Ref: System Thinking V2, §Cross-Component Interactions
```

---

# PART 2 — DETAILED FLOW (Sub-Component Level)

All 14 edges from the catalog, each with a dedicated diagram.

---

## 2.1 Edge E1: EI → EU (feeds)

The gateway. All harness effects converge here before reaching the agent.

```
  EI (THE GATEWAY)                                 EU
  ┌────────────────────────────────────┐           ┌──────────────────┐
  │                                    │           │                  │
  │  ┌──────────────────┐             │           │                  │
  │  │ Directive         │   Task      │           │  ┌────────────┐ │
  │  │                   │   prompt,   │    E1     │  │ Selection  │ │
  │  │ Goals, criteria,  │───budget───▶│─────────▶│  │ (model)    │ │
  │  │ constraints       │            │           │  └────────────┘ │
  │  └──────────────────┘             │           │                  │
  │                                    │           │                  │
  │  ┌──────────────────┐             │           │  ┌────────────┐ │
  │  │ Contextual        │   Memory,  │           │  │ Config     │ │
  │  │                   │   rules,   │           │  │ (tuning)   │ │
  │  │ History, state,   │───files,──▶│─────────▶│  └────────────┘ │
  │  │ domain knowledge  │   git ctx  │           │                  │
  │  └──────────────────┘             │           │                  │
  │                                    │           │  ┌────────────┐ │
  │  ┌──────────────────┐             │           │  │ Limitations│ │
  │  │ Corrective        │   Errors,  │           │  │ (8 LTs —   │ │
  │  │                   │   prior    │           │  │  design    │ │
  │  │ Eval results,     │───fails,──▶│─────────▶│  │  around)   │ │
  │  │ user corrections  │   lessons  │           │  └────────────┘ │
  │  └──────────────────┘             │           │                  │
  │                                    │           │                  │
  │  ◄── EP loads rules into here      │           │                  │
  │  ◄── EOE hooks inject context here │           │                  │
  │  ◄── EOT results enter here        │           │                  │
  │  ◄── EOP templates loaded here     │           │                  │
  └────────────────────────────────────┘           └──────────────────┘

  {M1}  Token count of Directive input (lean or bloated?)
  {M2}  Freshness of Contextual input (last_updated age in days)
  {M3}  Corrective signal strength (was prior failure's lesson captured? binary)
```

---

## 2.2 Edges E2+E3+E4+E5: EP → EU, EOE, EOT, EOP (governs)

EP is the constitution. Its 3 categories each govern different downstream components.

```
  EP
  ┌────────────────────────────────────────────────────────────────────┐
  │                                                                    │
  │  ┌────────────────┐     ┌────────────────┐     ┌────────────────┐ │
  │  │   Behavioral   │     │   Structural   │     │   Relational   │ │
  │  │                │     │                │     │                │ │
  │  │ What to DO and │     │ How ARTIFACTS  │     │ How ACTORS     │ │
  │  │ NOT DO         │     │ are shaped     │     │ interact       │ │
  │  └───────┬────────┘     └───────┬────────┘     └───────┬────────┘ │
  │          │                      │                      │          │
  └──────────┼──────────────────────┼──────────────────────┼──────────┘
             │                      │                      │
     ┌───────┴───────┐      ┌──────┴──────┐       ┌───────┴───────┐
     │  E2: EU       │      │ E3: EOE     │       │ E5: EOP       │
     │  Safety,      │      │ Hook config,│       │ Gate criteria,│
     │  forbidden    │      │ permission  │       │ handoff rules,│
     │  actions,     │      │ patterns,   │       │ escalation    │
     │  scope limits │      │ budget      │       │ triggers      │
     └───────────────┘      │ allocation  │       └───────────────┘
                            │             │
                            │ E4: EOT     │
                            │ Tool        │
                            │ contracts,  │
                            │ descriptions│
                            └─────────────┘

  {M4}  Rule coverage — rules loaded / rules available (target: 100% for always-on)
  {M5}  Rule violation rate — EP violations per session (target: 0 for Behavioral)
  {M6}  Rule-to-hook ratio — critical EP rules backed by EOE hooks (target: 100%)
```

---

## 2.3 Edge E6: EOE → EU (limits)

EOE sets hard ceilings. 4 orthogonal dimensions. Hooks fire deterministically.

```
  EOE                                                        EU
  ┌──────────────────────────────────────┐                   ┌──────────────┐
  │                                      │                   │              │
  │  ┌────────────────┐                  │                   │              │
  │  │ Temporal        │    fires at     │    blocks or      │              │
  │  │ (hooks)         │────lifecycle───▶│────allows────────▶│  Agent       │
  │  │                 │    events       │    actions        │  inference   │
  │  │ SessionStart    │                 │                   │  + tool use  │
  │  │ PreToolUse      │                 │                   │              │
  │  │ PostToolUse     │                 │                   │              │
  │  │ UserPromptSubmit│                 │                   │              │
  │  │ SubagentStop    │                 │                   │              │
  │  │ PreCompact      │                 │                   │              │
  │  │ Stop            │                 │                   │              │
  │  └────────────────┘                  │                   │              │
  │                                      │                   │              │
  │  ┌────────────────┐                  │                   │              │
  │  │ Spatial         │    bounds       │    restricts      │              │
  │  │ (sandbox)       │────file/net────▶│────access────────▶│              │
  │  │                 │    scope        │                   │              │
  │  │ Working dir     │                 │                   │              │
  │  │ Worktree isol.  │                 │                   │              │
  │  │ Shell env       │                 │                   │              │
  │  └────────────────┘                  │                   │              │
  │                                      │                   │              │
  │  ┌────────────────┐                  │                   │              │
  │  │ Quantitative    │    caps         │    forces         │              │
  │  │ (budget)        │────token/cost──▶│────compact───────▶│              │
  │  │                 │    limits       │    or stop        │              │
  │  │ Context window  │                 │                   │              │
  │  │ Token ceiling   │                 │                   │              │
  │  │ Cost envelope   │                 │                   │              │
  │  │ Timeout         │                 │                   │              │
  │  └────────────────┘                  │                   │              │
  │                                      │                   │              │
  │  ┌────────────────┐                  │                   │              │
  │  │ Authorization   │    gates        │    requires       │              │
  │  │ (permissions)   │────tool calls──▶│────approval──────▶│              │
  │  │                 │                 │    or denies      │              │
  │  │ Permission modes│                 │                   │              │
  │  │ Allow/deny lists│                 │                   │              │
  │  │ Approval gates  │                 │                   │              │
  │  └────────────────┘                  │                   │              │
  └──────────────────────────────────────┘                   └──────────────┘

  {M7}   Hook execution latency (ms per hook — perf cost of enforcement)
  {M8}   Permission denial rate (too restrictive → friction; too permissive → risk)
  {M9}   Context utilization % (used tokens / available tokens)
  {M10}  Compaction events per session (context pressure indicator)
```

---

## 2.4 Edge E7: EOE → EOT (limits)

EOE's Authorization category restricts which tools are available to each agent.

```
  EOE                                              EOT
  ┌──────────────────────────┐                     ┌──────────────────────┐
  │                          │                     │                     │
  │  ┌────────────────────┐  │   tool allowlists   │  ┌───────────────┐ │
  │  │ Authorization      │  │   per agent from    │  │ Inspection    │ │
  │  │                    │──┼──settings.json──────▶│  │ (available?)  │ │
  │  │ - Permission modes │  │                     │  └───────────────┘ │
  │  │   (default/auto/   │  │   tool denylists    │                     │
  │  │    plan/bypass)    │  │   from settings     │  ┌───────────────┐ │
  │  │                    │──┼──────────────────── ▶│  │ Discovery     │ │
  │  │ - Tool allowlists  │  │                     │  │ (available?)  │ │
  │  │   (glob patterns)  │  │   agent-specific    │  └───────────────┘ │
  │  │                    │  │   tool restrictions  │                     │
  │  │ - Tool denylists   │──┼──from .claude/      │  ┌───────────────┐ │
  │  │   (glob patterns)  │  │  agents/*.md────────▶│  │ Modification  │ │
  │  │                    │  │                     │  │ (available?)  │ │
  │  │ - 7-stage pipeline │  │                     │  └───────────────┘ │
  │  │   (Enterprise →    │  │                     │                     │
  │  │    Project → User  │  │                     │  ┌───────────────┐ │
  │  │    → Session →     │  │                     │  │ Interaction   │ │
  │  │    Tool → Glob →   │  │                     │  │ (available?)  │ │
  │  │    Hook override)  │  │                     │  └───────────────┘ │
  │  └────────────────────┘  │                     │                     │
  └──────────────────────────┘                     └──────────────────────┘

  {M25}  Tool availability per agent (tools allowed / tools total)
  {M26}  Agent-to-tool mismatch rate (agent attempts denied tool)
```

---

## 2.5 Edges E8+E14: EU ↔ EOT (extends + invokes)

Bidirectional. EU invokes (E14), EOT extends (E8). 2×2 tool matrix by effect × scope.

```
  EU                                                EOT
  ┌────────────────────┐                            ┌────────────────────────┐
  │                    │                            │                        │
  │                    │    read-only, local        │  ┌──────────────────┐  │
  │  Agent needs       │────────────────────E14───▶│  │ Inspection       │  │
  │  local state       │                            │  │ Read, Glob, Grep │  │
  │                    │◀───────────────────E8──────│  │ git status       │  │
  │                    │    results                 │  └──────────────────┘  │
  │                    │                            │                        │
  │                    │    read-only, external     │  ┌──────────────────┐  │
  │  Agent needs       │────────────────────E14───▶│  │ Discovery        │  │
  │  external data     │                            │  │ WebSearch, Exa   │  │
  │                    │◀───────────────────E8──────│  │ QMD, API GET     │  │
  │                    │    results                 │  └──────────────────┘  │
  │                    │                            │                        │
  │                    │    write, local            │  ┌──────────────────┐  │
  │  Agent needs to    │────────────────────E14───▶│  │ Modification     │  │
  │  change state      │                            │  │ Write, Edit,     │  │
  │                    │◀───────────────────E8──────│  │ Bash (write)     │  │
  │                    │    confirmation            │  └──────────────────┘  │
  │                    │                            │                        │
  │                    │    write, external         │  ┌──────────────────┐  │
  │  Agent needs to    │────────────────────E14───▶│  │ Interaction      │  │
  │  communicate out   │                            │  │ API POST, push,  │  │
  │                    │◀───────────────────E8──────│  │ send message     │  │
  │                    │    response                │  └──────────────────┘  │
  └────────────────────┘                            └────────────────────────┘

  Concurrency rule (from Claude Code architecture):
    Inspection + Discovery    → up to 10 parallel (read-only, safe)
    Modification + Interaction → serial (state-changing, must sequence)

  {M11}  Tool calls per task (efficiency — fewer is better for same quality)
  {M12}  Tool error rate (reliability — tool failures / tool calls)
  {M13}  Tool selection accuracy (right tool for right job — correct / total)
```

---

## 2.6 Edge E9: EOP → EU (orchestrates)

EOP's 4 PDCA categories structure how the agent works.

```
  EOP                                                EU
  ┌──────────────────────────────────────┐           ┌────────────────┐
  │                                      │           │                │
  │  ┌────────────────────┐              │           │                │
  │  │ Orchestration      │  decomposes  │  assigns  │                │
  │  │ (PLAN)             │──task───────▶│──steps───▶│  Step 1        │
  │  │                    │              │           │  Step 2        │
  │  │ Workflows, dispatch│              │           │  ...           │
  │  │ dependency graphs  │              │           │  Step N        │
  │  └────────────────────┘              │           │                │
  │                                      │           │                │
  │  ┌────────────────────┐              │           │                │
  │  │ Execution          │  provides    │  defines  │                │
  │  │ (DO)               │──skill──────▶│──action──▶│  Do the step   │
  │  │                    │  template    │           │                │
  │  │ Skills, scripts,   │              │           │                │
  │  │ agent definitions  │              │           │                │
  │  └────────────────────┘              │           │                │
  │                                      │           │                │
  │  ┌────────────────────┐              │    ⊗      │                │
  │  │ Verification       │  checks     │  GATE     │                │
  │  │ (CHECK)            │──output────▶│──pass?───▶│  Next step     │
  │  │                    │  criteria   │  fail?    │  or STOP       │
  │  │ Gates, ACs,        │              │           │                │
  │  │ review protocols   │              │           │                │
  │  └────────────────────┘              │           │                │
  │                                      │           │                │
  │  ┌────────────────────┐              │           │                │
  │  │ Recovery           │  handles    │  routes   │                │
  │  │ (ADJUST)           │──failure───▶│──retry/──▶│  Retry or      │
  │  │                    │              │  escalate │  Escalate      │
  │  │ Retry logic,       │              │           │                │
  │  │ rollback, escalate │              │           │                │
  │  └────────────────────┘              │           │                │
  └──────────────────────────────────────┘           └────────────────┘

  {M14}  Steps per task (decomposition quality — fewer complex steps = higher risk)
  {M15}  Gate pass rate per step (verification coverage — low = quality problem)
  {M16}  Recovery success rate (resilience — recovered / total failures)
  {M17}  Human escalation rate (autonomy — escalated / total tasks)
```

---

## 2.7 Edge E10: EU → EA (produces)

The boundary between controllable and emergent. What the agent DOES becomes what we OBSERVE.

```
  EU (controllable)                      EA (emergent — observe only)
  ┌──────────────────────┐               ┌──────────────────────────┐
  │                      │               │                          │
  │  Model inference     │               │  ┌────────────────────┐  │
  │  ┌───────────────┐   │   reasoning   │  │ Trace              │  │
  │  │ Capability    │   │───chains─────▶│  │ What happened?     │  │
  │  │ (what it can  │   │   tool calls  │  │ Tool call sequence │  │
  │  │  do)          │   │───decisions──▶│  │ Files modified     │  │
  │  └───────────────┘   │               │  │ Agents dispatched  │  │
  │                      │               │  └────────────────────┘  │
  │  ┌───────────────┐   │               │                          │
  │  │ Configuration │   │   output      │  ┌────────────────────┐  │
  │  │ (how it's     │   │───quality────▶│  │ Quality            │  │
  │  │  tuned)       │   │               │  │ How well?          │  │
  │  └───────────────┘   │               │  │ Correctness        │  │
  │                      │               │  │ Rule compliance    │  │
  │  ┌───────────────┐   │               │  └────────────────────┘  │
  │  │ Limitations   │   │   resource    │                          │
  │  │ (8 LTs —      │   │───usage──────▶│  ┌────────────────────┐  │
  │  │  constrain    │   │               │  │ Efficiency         │  │
  │  │  output)      │   │               │  │ How economically?  │  │
  │  └───────────────┘   │               │  │ Tokens, time,      │  │
  │                      │               │  │ steps consumed     │  │
  └──────────────────────┘               │  └────────────────────┘  │
                                         │                          │
                                         │  When EA fails, root     │
                                         │  cause is NEVER here.    │
                                         │  Trace back: EP → EI →   │
                                         │  EOP → EOE → EOT → EU   │
                                         └──────────────────────────┘

  {M27}  Trace completeness (all tool calls logged? all reasoning visible?)
  {M28}  Quality drift indicator (compliance rate trending down over session?)
```

---

## 2.8 Edges E11+E12: EA → EO (yields) + EO → EI (feedback)

The output path and the learning loop.

```
  EA                              EO                             EI
  ┌──────────────┐                ┌──────────────┐               ┌──────────────┐
  │              │                │              │               │              │
  │ ┌──────────┐│   correctness  │ ┌──────────┐│  Corrective   │ ┌──────────┐│
  │ │ Trace    ││───────────────▶│ │ Sustain. ││──signal──────▶│ │Corrective││
  │ │(what)    ││                │ │ (S)      ││  "fix this"   │ │(feedback)││
  │ └──────────┘│                │ │ Correct? ││               │ └──────────┘│
  │              │                │ │ Safe?    ││               │              │
  │ ┌──────────┐│   economy      │ └──────────┘│               │ ┌──────────┐│
  │ │ Quality  ││───────────────▶│ ┌──────────┐│  Context      │ │Contextual││
  │ │(how well)││                │ │ Effic.   ││──update──────▶│ │(knowledge)│
  │ └──────────┘│                │ │ (E)      ││  "know this"  │ └──────────┘│
  │              │                │ │ Cheap?   ││               │              │
  │ ┌──────────┐│   repeatab.    │ └──────────┘│               │ ┌──────────┐│
  │ │Efficiency││───────────────▶│ ┌──────────┐│  Goal         │ │Directive ││
  │ │(how much)││                │ │ Scalab.  ││──refine──────▶│ │(next task)│
  │ └──────────┘│                │ │ (Sc)     ││  "do this"    │ └──────────┘│
  │              │                │ │ Repeat?  ││               │              │
  │              │                │ └──────────┘│               │              │
  └──────────────┘                └──────────────┘               └──────────────┘

  {M18}  Task completion rate (S — completed / total)
  {M19}  Token cost per task (E — tokens / completed tasks)
  {M20}  Cross-run consistency (Sc — std_dev across identical runs)
  {M21}  Feedback incorporation rate (loop health — lessons captured / lessons available)
```

---

## 2.9 Edge E13: EO → Harness (improvement)

The long-range learning loop. Distinct from E12 (per-turn feedback to EI).

```
  EO                                        HARNESS COMPONENTS
  ┌──────────────┐                          ┌───────────────────────────────────┐
  │              │                          │                                   │
  │  Measured    │   "Rules need            │  ┌──────┐                        │
  │  outcomes    │────updating" ───E13a────▶│  │  EP  │  Revise principles    │
  │  reveal:     │                          │  └──────┘                        │
  │              │   "Hooks need            │                                   │
  │  - Which     │────tuning" ────E13b────▶│  ┌──────┐                        │
  │    rules     │                          │  │  EOE │  Adjust enforcement    │
  │    were      │   "Tools need            │  └──────┘                        │
  │    violated  │────fixing" ────E13c────▶│                                   │
  │              │                          │  ┌──────┐                        │
  │  - Which     │   "Workflows need        │  │  EOT │  Fix tool contracts   │
  │    tools     │────improving" ─E13d────▶│  └──────┘                        │
  │    failed    │                          │                                   │
  │              │                          │  ┌──────┐                        │
  │  - Which     │                          │  │  EOP │  Refine procedures    │
  │    steps     │                          │  └──────┘                        │
  │    broke     │                          │                                   │
  └──────────────┘                          └───────────────────────────────────┘

  {M29}  Iteration-over-iteration EO delta (is the system improving over time?)
  {M30}  Harness change frequency (how often are EP/EOE/EOT/EOP modified?)
  {M31}  Change-to-improvement ratio (changes that improved EO / total changes)

  Ref: System Thinking V2, §Reinforcing Loop — this is the compounding mechanism.
  Without E13, the system is static. With E13, every failure makes the harness stronger.
```

---

# PART 3 — THE COMPLETE AGENT EXECUTION CYCLE

---

## 3.1 Single-Turn Execution Flow

One complete cycle from input to output. All 8 components. 11 numbered steps.

```
  ┌────────────────────────────────────────────────────────────────────────────┐
  │                         SINGLE TURN EXECUTION                              │
  │                                                                            │
  │                                                                            │
  │  ┌──────────┐      ┌─────────────────────────────────────────────────┐    │
  │  │          │      │               HARNESS                           │    │
  │  │    EI    │      │                                                 │    │
  │  │          │      │                                                 │    │
  │  │ Directive│──1──▶│  EP loaded into EI?                             │    │
  │  │ Context. │      │     │                                           │    │
  │  │ Correct. │      │     ├── no ──▶ ⊗ STOP (missing rules)          │    │
  │  │          │      │     │                                           │    │
  │  └──────────┘      │     └── yes                                     │    │
  │                    │            │                                     │    │
  │                    │     2      ▼                                     │    │
  │                    │     EOE SessionStart hooks fire                  │    │
  │                    │     (inject git context, auto-recall into EI)    │    │
  │                    │            │                                     │    │
  │                    │     3      ▼                                     │    │
  │                    │     ┌──────────────────────────┐                 │    │
  │                    │     │    EU begins inference    │                 │    │
  │                    │     │    (processes EI)         │                 │    │
  │                    │     └────────────┬─────────────┘                 │    │
  │                    │                  │                               │    │
  │                    │     4            ▼                               │    │
  │                    │     EOP provides skill/template                  │    │
  │                    │     EU follows procedure steps                   │    │
  │                    │                  │                               │    │
  │                    │     5            ▼                               │    │
  │                    │     EU invokes EOT tool ──────────────────┐     │    │
  │                    │                                            │     │    │
  │                    │     6    EOE PreToolUse hook fires ◄───────┘     │    │
  │                    │          Permission check: allowed?              │    │
  │                    │          │                                       │    │
  │                    │          ├── denied ──▶ EU adjusts approach      │    │
  │                    │          │                                       │    │
  │                    │          └── allowed                             │    │
  │                    │                  │                               │    │
  │                    │     7            ▼                               │    │
  │                    │     Tool executes (Inspect/Discover/Modify/      │    │
  │                    │     Interact — result enters EI as new context)  │    │
  │                    │                  │                               │    │
  │                    │     8    EOE PostToolUse hook fires              │    │
  │                    │          (log, validate, ripple-check)           │    │
  │                    │                  │                               │    │
  │                    │     9            ▼                               │    │
  │                    │     ┌──────────────────────────┐                 │    │
  │                    │     │    EA emerges             │                 │    │
  │                    │     │    (observable action)    │                 │    │
  │                    │     └────────────┬─────────────┘                 │    │
  │                    │                  │                               │    │
  │                    │    10            ▼                               │    │
  │                    │     EOP Verification gate ──── ⊗                 │    │
  │                    │          │                     │                 │    │
  │                    │          │ PASS                │ FAIL            │    │
  │                    │          ▼                     ▼                 │    │
  │                    │     continue              EOP Recovery           │    │
  │                    │                          (retry / escalate)      │    │
  │                    │                               │                 │    │
  │                    │                               └──▶ back to 3    │    │
  │                    └─────────────────────────────────────────────────┘    │
  │                               │                                          │
  │  ┌──────────┐            11   │                                          │
  │  │          │◀────────────────┘                                          │
  │  │    EO    │                                                            │
  │  │          │                                                            │
  │  │ {M18} S  │── task complete?                                           │
  │  │ {M19} E  │── tokens used?                                             │
  │  │ {M20} Sc │── repeatable?                                              │
  │  │          │                                                            │
  │  └────┬─────┘                                                            │
  │       │                                                                  │
  │       ├── E12 ─ ─ ─ ─ Corrective feedback ─ ─ ─ ─▶ EI (next turn)      │
  │       │                                                                  │
  │       └── E13 ─ ─ ─ ─ Improvement signal ─ ─ ─ ─ ▶ EP/EOE/EOT/EOP      │
  │                                                     (next iteration)     │
  └──────────────────────────────────────────────────────────────────────────┘

  Step Summary:
   1  EI loaded (Directive + Contextual + Corrective)
   2  EOE SessionStart hooks inject additional context into EI
   3  EU begins inference — processes everything in EI
   4  EOP provides procedure — skill/workflow enters EI as Contextual
   5  EU invokes EOT tool
   6  EOE PreToolUse hook — deterministic permission check
   7  Tool executes — result enters EI as new Contextual input
   8  EOE PostToolUse hook — log, validate, trigger follow-on
   9  EA emerges — observable trace, quality, efficiency
  10  EOP Verification gate — PASS continues, FAIL triggers Recovery
  11  EO measured — feeds back as E12 (Corrective to EI) + E13 (improvement to harness)
```

---

## 3.2 Multi-Agent Execution Flow

Orchestrator (EU-0) dispatches executors (EU-1..N). Chain depth = 1.

```
                     ┌─────────────────────────────────────────┐
                     │           ORCHESTRATOR (EU-0)            │
                     │                                         │
                     │  Model: Opus | Role: Plan + Synthesize  │
                     │                                         │
                     │  EI-0: Full task context                │
                     │  EP-0: Full rule set                    │
                     │  EOE-0: Full permission set             │
                     │                                         │
                     │  EOP-Orchestration decomposes:          │
                     │  Task ──▶ Step 1, Step 2, Step 3        │
                     └──────────┬──────────┬───────────────────┘
                                │          │
                     ┌──────────▼──┐  ┌────▼──────────┐
                     │  EXECUTOR   │  │  EXECUTOR      │
                     │  (EU-1)     │  │  (EU-2)        │
                     │             │  │                │
                     │ Model:Sonnet│  │ Model:Haiku    │
                     │ Role: Build │  │ Role: Explore  │
                     │             │  │                │
                     │ ISOLATED:   │  │ ISOLATED:      │
                     │ ┌─────────┐│  │┌─────────┐    │
                     │ │Own EI   ││  ││Own EI   │    │
                     │ │Own EP   ││  ││Own EP   │    │
                     │ │Own EOE  ││  ││Own EOE  │    │
                     │ │Own EOT  ││  ││Own EOT  │    │
                     │ │Own EOP  ││  ││Own EOP  │    │
                     │ │Own ctx  ││  ││Own ctx  │    │
                     │ │Own tree ││  ││Own tree │    │
                     │ └─────────┘│  │└─────────┘    │
                     └──────┬──────┘  └─────┬──────────┘
                            │               │
                       EA-1 │          EA-2 │
                            ▼               ▼
                     ┌──────────────────────────────────┐
                     │  ⊗  EOP-Verification (EU-0)      │
                     │                                   │
                     │  Orchestrator validates:          │
                     │  - EA-1 meets acceptance criteria │
                     │  - EA-2 meets acceptance criteria │
                     │  - Outputs are coherent together  │
                     └──────────────┬───────────────────┘
                                    │
                              PASS  │  FAIL
                         ┌──────────┼──────────┐
                         ▼                     ▼
                   [EO emitted]        [EOP-Recovery:
                                        re-dispatch with
                                        Corrective input]

  PRINCIPLE (EP-13): Only EU-0 dispatches. Sub-agents NEVER call Agent().
  PRINCIPLE (EP-12): Every handoff has binary acceptance criteria.
  PRINCIPLE (EP-11): Each agent's tool set is scoped to its role.

  {M22}  Sub-agent count per task (target: ≤ 4, gains plateau beyond this)
  {M23}  Sub-agent AC pass rate (target: > 90% first-pass)
  {M24}  Orchestrator synthesis quality (coherence of combined outputs)
```

---

# PART 4 — MEASUREMENT FRAMEWORK

---

## 4.1 Complete Metric Registry

31 measurement points. Organized by what they measure and where they attach.

### EO Metrics (Dependent Variable — What We Optimize)

| ID | Metric | Pillar | Formula | Target |
|----|--------|--------|---------|--------|
| M18 | Task completion rate | S | completed / total | > 95% |
| M19 | Token cost per task | E | total_tokens / completed | trending ↓ |
| M20 | Cross-run consistency | Sc | std_dev(quality) / N runs | < 10% var |

### EI Metrics (The Gateway — What Enters the Agent)

| ID | Metric | Edge | What It Diagnoses |
|----|--------|------|-------------------|
| M1 | Directive input tokens | E1 | Prompt lean or bloated? |
| M2 | Contextual freshness | E1 | Memory/state current or stale? |
| M3 | Corrective signal strength | E1 | Prior failure's lesson captured? |

### EP Metrics (Constitution — How Well Rules Govern)

| ID | Metric | Edge | What It Diagnoses |
|----|--------|------|-------------------|
| M4 | Rule coverage | E2-E5 | Rules loaded / rules available |
| M5 | Rule violation rate | E2 | How often EU ignores EP |
| M6 | Rule-to-hook ratio | E3 | Critical rules backed by EOE hooks |

### EOE Metrics (Sandbox — How Well Environment Constrains)

| ID | Metric | Edge | What It Diagnoses |
|----|--------|------|-------------------|
| M7 | Hook latency | E6 | Hooks slowing execution? |
| M8 | Permission denial rate | E6 | Too restrictive or too permissive? |
| M9 | Context utilization % | E6 | Budget efficiency |
| M10 | Compaction events | E6 | Context pressure |
| M25 | Tool availability per agent | E7 | Right tools scoped to right agent? |
| M26 | Agent-to-tool mismatch | E7 | Agent attempts denied tool? |

### EOT Metrics (Instruments — How Well Tools Perform)

| ID | Metric | Edge | What It Diagnoses |
|----|--------|------|-------------------|
| M11 | Tool calls per task | E8/E14 | Efficiency of tool use |
| M12 | Tool error rate | E8 | Tool reliability |
| M13 | Tool selection accuracy | E8 | Right tool for right job? |

### EOP Metrics (Playbook — How Well Procedures Orchestrate)

| ID | Metric | Edge | What It Diagnoses |
|----|--------|------|-------------------|
| M14 | Steps per task | E9 | Decomposition quality |
| M15 | Gate pass rate | E9 | Verification coverage |
| M16 | Recovery success rate | E9 | Resilience |
| M17 | Human escalation rate | E9 | Autonomy level |

### EA Metrics (Emergent — What We Observe)

| ID | Metric | Edge | What It Diagnoses |
|----|--------|------|-------------------|
| M27 | Trace completeness | E10 | All tool calls logged? |
| M28 | Quality drift | E10 | Compliance trending down over session? |

### Feedback Loop Metrics (System Health)

| ID | Metric | Edge | What It Diagnoses |
|----|--------|------|-------------------|
| M21 | Feedback incorporation | E12 | Lessons captured / available |
| M29 | Iteration EO delta | E13 | System improving over time? |
| M30 | Harness change frequency | E13 | How often is harness modified? |
| M31 | Change-to-improvement ratio | E13 | Changes that improved EO / total |

### Multi-Agent Metrics (Orchestration Health)

| ID | Metric | Edge | What It Diagnoses |
|----|--------|------|-------------------|
| M22 | Sub-agent count | E9 | Dispatch efficiency (≤ 4 optimal) |
| M23 | Sub-agent AC pass | E9 | Sub-agent quality |
| M24 | Synthesis quality | E9 | Orchestrator coherence |

---

## 4.2 Evaluation Protocol

```
  FOR EACH harness change (EP, EOE, EOT, or EOP):

  ┌──────────────────────────────────────────────────────────────────┐
  │                                                                  │
  │  1. BASELINE                                                     │
  │     Run 20-50 test cases with current config                     │
  │     Record: EO (M18, M19, M20) + edge metrics (M1-M17, M21-M31)│
  │                                                                  │
  │  2. CHANGE                                                       │
  │     Modify exactly ONE variable in ONE component                 │
  │     Document: what changed, which component, which category      │
  │                                                                  │
  │  3. MEASURE                                                      │
  │     Run SAME 20-50 test cases with new config                    │
  │     Record: same metrics as baseline                             │
  │                                                                  │
  │  4. COMPARE                                                      │
  │     EO delta across S × E × Sc dimensions                       │
  │     Edge metric deltas: which shifted?                           │
  │                                                                  │
  │  5. DIAGNOSE (if EO worsened)                                    │
  │     Blame Diagnostic: EP → EI → EOP → EOE → EOT → EU            │
  │     Classify component zone: Below Threshold / Leverage / Satur. │
  │                                                                  │
  │  6. DECIDE (if EO improved)                                      │
  │     Commit the change                                            │
  │     Update sigmoid zone classification                           │
  │     Check: did this lower K for another component? (synergy)    │
  │                                                                  │
  │  REPEAT — this is E13, the reinforcing loop that compounds.      │
  └──────────────────────────────────────────────────────────────────┘
```

---

## 4.3 Sigmoid Zone Classification

For each of the 6 controllable components:

```
  ┌──────────────────────────────────────────────────────────────────────────┐
  │                                                                          │
  │  Component: _______________     Date: ________     Assessor: __________  │
  │                                                                          │
  │  1. What % of recent failures trace to this component?                  │
  │                                                                          │
  │     □ > 50%   → BELOW THRESHOLD                                         │
  │                  Invest heavily. This is the bottleneck.                 │
  │                  Exponential returns here.                               │
  │                                                                          │
  │     □ 10-50%  → LEVERAGE ZONE                                           │
  │                  Keep investing. Steep part of the sigmoid.              │
  │                  Visible improvement per unit effort.                    │
  │                                                                          │
  │     □ < 10%   → SATURATED                                               │
  │                  Move on. Find the next bottleneck.                      │
  │                  Diminishing returns.                                    │
  │                                                                          │
  │  2. Cross-component synergy check:                                      │
  │     Would strengthening a DIFFERENT component lower THIS                │
  │     component's threshold (K)?                                          │
  │                                                                          │
  │     If yes → cross-component play (highest leverage of all)            │
  │     Which component? _____________                                      │
  │     Mechanism: ___________________________________________________      │
  │                                                                          │
  │  Classification: ________________                                       │
  │                                                                          │
  └──────────────────────────────────────────────────────────────────────────┘
```

---

## Sources

- System Thinking & Design Notes V2 (`OPS_OE.6.0/research/amt/SYSTEM-THINKING-DESIGN-NOTES-v2.md`)
- Agent Harness System blueprint (`inbox/agent-harness-system.md`)
- Harness Engineering Research 2026 (`inbox/research-harness-engineering-2026.md`)
- Agent System 7-CS (`rules/agent-system.md`)

## Links

- [[agent-harness-system]]
- [[agent-system]]
- [[enforcement-layers]]
- [[harness-engineering-research-2026]]
- [[ltc-effective-agent-principles-registry]]
