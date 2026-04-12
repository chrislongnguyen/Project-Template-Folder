---
version: "1.0"
status: draft
last_updated: 2026-04-12
---

# Agent Harness System — Flow Charts

> Companion to `agent-harness-system.md`. Shows HOW components interact at high-level and detail-level.
> Grounded in: System Thinking & Design Notes V2 (Nodes & Edges, Feedback Loops, Leverage Points),
> Agent System (7-CS/8-CS), and 28-source Harness Engineering Research (2026).
> Use for: building (what connects to what), measuring (where to observe), diagnosing (which edge failed).

---

## Notation

```
──▶   Data/information flow (directed edge)
══▶   Control flow (governance, enforcement)
- - ▶ Feedback flow (loop back)
[  ]  Node (component or sub-component)
{  }  Measurement point (observable metric)
⊗     Gate (human or automated checkpoint)
```

---

# PART 1 — HIGH-LEVEL FLOW

## 1.1 The 8-Component System Map

8 nodes, 14 directed edges. This is the complete system at its simplest.

```
                               GOVERNANCE PLANE
                    ┌─────────────────────────────────────────┐
                    │                                         │
                    │              ┌──────┐                   │
                    │              │  EP  │                   │
                    │              │      │                   │
                    │              └──┬───┘                   │
                    │        ┌───────┼───────┬────────┐      │
                    │        │  ════▶│══════▶│════════▶│      │
                    │        ▼       ▼       ▼        ▼      │
   ┌──────┐        │   ┌──────┐ ┌──────┐ ┌──────┐          │        ┌──────┐
   │  EI  │──▶─────│──▶│  EOE │ │  EOT │ │  EOP │          │──▶─────│  EO  │
   │      │        │   └──┬───┘ └──┬───┘ └──┬───┘          │        │      │
   │Input │  ──▶───│──────│limits  │extends │orchestrates   │        │Result│
   └──┬───┘        │      ▼        ▼        ▼               │        └──┬───┘
      │            │   ┌────────────────────────────┐       │           │
      │    feeds   │   │                            │       │           │
      └──────▶─────│──▶│      EU (Agent/Model)      │       │           │
                   │   │                            │       │           │
                   │   └─────────────┬──────────────┘       │           │
                   │                 │ produces              │           │
                   │                 ▼                       │           │
                   │           ┌──────────┐                 │           │
                   │           │    EA    │                  │           │
                   │           │ (observe)│                  │           │
                   │           └────┬─────┘                  │           │
                   │                │ yields                  │           │
                   └────────────────┼─────────────────────────┘           │
                                    └──────────────▶─────────────────────┘
                                                                         │
                  ◄──── ─ ─ ─ ─ ─ ─ ─ ─ ─ ─ ─ ─ ─ ─ ─ ─ ─ ─ ─ ─ ─ ─ ┘
                  Corrective feedback (EO informs next EI)
```

## 1.2 Edge Catalog — All 14 Interactions

Every edge in the system is a relationship that can be measured, tuned, or broken.

| # | From | To | Edge Type | Mechanism | Measurable Signal |
|---|------|-----|-----------|-----------|-------------------|
| E1 | EI | EU | feeds | Directive + Contextual + Corrective input loaded | Token count, signal-to-noise ratio |
| E2 | EP | EU | governs | Behavioral principles constrain agent actions | Rule compliance rate |
| E3 | EP | EOE | governs | Structural principles define hook/permission config | Config-to-rule alignment |
| E4 | EP | EOT | governs | Structural principles define tool descriptions/contracts | Tool description quality |
| E5 | EP | EOP | governs | Relational principles define workflow gates/handoffs | Gate coverage per procedure |
| E6 | EOE | EU | limits | Temporal + Spatial + Quantitative + Authorization bounds | Permission denial rate, context utilization |
| E7 | EOE | EOT | limits | Authorization bounds restrict which tools are available | Tool availability per agent |
| E8 | EOT | EU | extends | Inspection/Discovery/Modification/Interaction capabilities | Tool call success rate |
| E9 | EOP | EU | orchestrates | Orchestration/Execution/Verification/Recovery sequences | Steps per task, gate pass rate |
| E10 | EU | EA | produces | Agent inference + tool calls → observable actions | (EA is the observation itself) |
| E11 | EA | EO | yields | Actions produce measurable outcomes | S x E x Sc metrics |
| E12 | EO | EI | feedback | Corrective signal: what worked, what failed | Feedback incorporation rate |
| E13 | EO | EP/EOE/EOT/EOP | improvement | Outcome data informs harness evolution | Iteration-over-iteration EO delta |
| E14 | EU | EOT | invokes | Agent calls tools during execution | Tool calls per task |

---

## 1.3 The Two Feedback Loops

From System Thinking & Design Notes V2: every loop is either Balancing or Reinforcing.

### Reinforcing Loop (Compounding Improvement)

```
  ┌───────────────────────────────────────────────────────┐
  │                                                       │
  ▼                                                       │
[Better EP/EOE/EOT/EOP] ──▶ [Better EA] ──▶ [Better EO] │
                                                    │     │
                                                    ▼     │
                                          [Better EI]     │
                                          (Corrective     │
                                           feedback       │
                                           improves       │
                                           next cycle)    │
                                                    │     │
                                                    └─────┘

 Type: REINFORCING — more success → more trust → more investment → more success
 Trigger: First good output that generates positive Corrective feedback
 Risk: Also works in reverse — bad output → less trust → less investment → worse output
```

### Balancing Loop (Quality Gate)

```
  ┌─────────────────────────────────────┐
  │                                     │
  ▼                                     │
[EU produces EA] ──▶ [EOP Verification] │
                           │            │
                      PASS │  FAIL      │
                           ▼            │
                      [EO emitted]   [EOP Recovery]
                                        │
                                        ▼
                                   [EU retries]
                                        │
                                        └────┘

 Type: BALANCING — output exceeds criteria → pass; output below → correct and retry
 Purpose: Prevents error compounding (the mathematical certainty: 95%^10 = 59%)
 Leverage: This is Meadows' #8 — balancing loop strength sets quality floor
```

### The Delay Risk

```
  Without delay:                    With delay (dangerous):

  [EU acts] ──▶ [Gate catches     [EU acts] ──▶ ... (no gate) ...
                  error quickly]              ──▶ [error compounds]
                        │                     ──▶ [more errors]
                        ▼                     ──▶ [Gate catches too late]
                 [EU corrects]                         │
                                                       ▼
                                              [Expensive rework]

  Implication: Verification gates must fire FREQUENTLY (per-step, not per-task).
  A gate at the end of 10 steps catches errors after they've compounded.
```

---

## 1.4 The Multiplicative Function (Why Every Component Matters)

From System Thinking V2: the function is multiplicative, not additive.

```
                    EO = EP_eff × EI_eff × EOP_eff × EOE_eff × EOT_eff × EU_eff

  Where each component's effectiveness follows a sigmoid:

    C_eff = C^n / (C^n + K^n)

  If ANY component goes to zero → EO goes to zero.
  If ALL components are in their leverage zone → EO is multiplicatively high.

  ┌──────────┬──────────┬──────────┬──────────┬──────────┬──────────┐
  │ EP_eff   │ EI_eff   │ EOP_eff  │ EOE_eff  │ EOT_eff  │ EU_eff   │
  │          │          │          │          │          │          │
  │  ╱──     │   ╱──    │  ╱──     │  ╱──     │  ╱──     │   ╱──    │
  │ ╱        │  ╱       │ ╱        │ ╱        │ ╱        │  ╱       │
  │╱         │ ╱        │╱         │╱         │╱         │ ╱        │
  └──────────┴──────────┴──────────┴──────────┴──────────┴──────────┘
  Investment   Investment  Investment  Investment  Investment  Investment

  Current zone: ?        ?           ?          ?          ?         ?
  Action:       Invest where sigmoid is STEEPEST (leverage zone)
```

**Cross-component threshold modulation:**
```
  Strong EP → lowers K for EI (agent needs LESS context when rules are clear)
  Strong EOE → lowers K for EOP (procedures need LESS detail when hooks enforce)
  Weak EP → raises K for EVERYTHING (every other component must compensate)
```

---

# PART 2 — DETAILED FLOW

## 2.1 Detailed Edge Map — Sub-Component Level

Each of the 14 edges from Part 1 decomposes into specific sub-component interactions.

### Edge E1: EI → EU (feeds)

```
  EI                                      EU
  ┌──────────────────┐                    ┌──────────────────┐
  │                  │                    │                  │
  │  ┌─────────────┐ │    Task prompt     │  ┌────────────┐ │
  │  │ Directive   │─┼───────────────────▶│  │ Selection  │ │
  │  │             │ │    Goals, budget    │  │ (model)    │ │
  │  └─────────────┘ │                    │  └────────────┘ │
  │                  │                    │                  │
  │  ┌─────────────┐ │    Memory, files   │  ┌────────────┐ │
  │  │ Contextual  │─┼───────────────────▶│  │ Config     │ │
  │  │             │ │    History, state   │  │ (tuning)   │ │
  │  └─────────────┘ │                    │  └────────────┘ │
  │                  │                    │                  │
  │  ┌─────────────┐ │    Error feedback   │                  │
  │  │ Corrective  │─┼───────────────────▶│  (adjusts next  │
  │  │             │ │    Prior failures   │   inference)     │
  │  └─────────────┘ │                    │                  │
  └──────────────────┘                    └──────────────────┘

  {M1} Token count of Directive input
  {M2} Freshness of Contextual input (last_updated age)
  {M3} Corrective signal strength (was prior failure addressed?)
```

### Edge E2+E3+E4+E5: EP → Everything (governs)

```
  EP
  ┌──────────────────────────────────────────────────────────┐
  │                                                          │
  │  ┌──────────────┐     ┌──────────────┐     ┌──────────────┐
  │  │  Behavioral  │     │  Structural  │     │  Relational  │
  │  │              │     │              │     │              │
  │  │ "what to do  │     │ "how artifacts│     │ "how actors  │
  │  │  and not do" │     │  are shaped"  │     │  interact"   │
  │  └──────┬───────┘     └──────┬───────┘     └──────┬───────┘
  │         │                    │                    │        │
  └─────────┼────────────────────┼────────────────────┼────────┘
            │                    │                    │
            ▼                    ▼                    ▼
  ┌─────────────────┐  ┌─────────────────┐  ┌─────────────────┐
  │ EU: constrains  │  │ EOE: defines    │  │ EOP: defines    │
  │ agent actions   │  │ hook configs,   │  │ gate criteria,  │
  │ (safety, scope) │  │ tool permission │  │ handoff rules,  │
  │                 │  │ patterns,       │  │ escalation      │
  │ EOT: defines    │  │ context budget  │  │ triggers        │
  │ tool contracts  │  │ allocation      │  │                 │
  └─────────────────┘  └─────────────────┘  └─────────────────┘

  {M4} Rules loaded vs rules available (coverage)
  {M5} Rules violated per session (compliance)
  {M6} Rule-to-hook pairing ratio (enforcement depth)
```

### Edge E6: EOE → EU (limits)

```
  EOE                                          EU
  ┌──────────────────────────────┐             ┌──────────────┐
  │                              │             │              │
  │  ┌──────────┐    fires at    │  blocks or  │              │
  │  │ Temporal  │───lifecycle───▶│──allows────▶│  Agent       │
  │  │ (hooks)   │    events     │  actions    │  inference   │
  │  └──────────┘               │             │  + tool use  │
  │                              │             │              │
  │  ┌──────────┐    bounds      │  restricts  │              │
  │  │ Spatial   │───file/net────▶│──access────▶│              │
  │  │ (sandbox) │    scope      │             │              │
  │  └──────────┘               │             │              │
  │                              │             │              │
  │  ┌──────────┐    caps        │  forces     │              │
  │  │ Quantit. │───token/cost──▶│──compact───▶│              │
  │  │ (budget)  │    limits     │  or stop    │              │
  │  └──────────┘               │             │              │
  │                              │             │              │
  │  ┌──────────┐    gates       │  requires   │              │
  │  │ Authoriz.│───tool calls──▶│──approval──▶│              │
  │  │ (perms)  │               │  or denies  │              │
  │  └──────────┘               │             │              │
  └──────────────────────────────┘             └──────────────┘

  {M7} Hook execution time (latency cost)
  {M8} Permission denial rate (too restrictive? too permissive?)
  {M9} Context utilization % (budget efficiency)
  {M10} Compaction events per session (context pressure)
```

### Edge E8+E14: EU ←→ EOT (extends + invokes)

```
  EU                                          EOT
  ┌──────────────────┐                        ┌──────────────────────┐
  │                  │     read-only calls     │                     │
  │  Agent needs     │────────────────────────▶│  ┌───────────────┐ │
  │  information     │                         │  │ Inspection    │ │
  │                  │◀────── results ─────────│  │ (local read)  │ │
  │                  │                         │  └───────────────┘ │
  │                  │     external queries    │                     │
  │  Agent needs     │────────────────────────▶│  ┌───────────────┐ │
  │  external data   │                         │  │ Discovery     │ │
  │                  │◀────── results ─────────│  │ (external read)│ │
  │                  │                         │  └───────────────┘ │
  │                  │     write commands      │                     │
  │  Agent needs     │────────────────────────▶│  ┌───────────────┐ │
  │  to change state │                         │  │ Modification  │ │
  │                  │◀────── confirmation ────│  │ (local write) │ │
  │                  │                         │  └───────────────┘ │
  │                  │     outbound actions    │                     │
  │  Agent needs to  │────────────────────────▶│  ┌───────────────┐ │
  │  communicate out │                         │  │ Interaction   │ │
  │                  │◀────── response ────────│  │ (external act)│ │
  │                  │                         │  └───────────────┘ │
  └──────────────────┘                        └──────────────────────┘

  {M11} Tool calls per task (efficiency)
  {M12} Tool error rate (reliability)
  {M13} Tool selection accuracy (right tool for right job)

  Concurrency rule:
    Inspection + Discovery   → parallel (read-only, safe)
    Modification + Interaction → serial (state-changing, must sequence)
```

### Edge E9: EOP → EU (orchestrates)

```
  EOP                                          EU
  ┌──────────────────────────────┐             ┌──────────────┐
  │                              │             │              │
  │  ┌──────────────┐  decomposes│  assigns    │              │
  │  │ Orchestration│───task────▶│──steps─────▶│  Step 1      │
  │  │ (plan)       │           │             │  Step 2      │
  │  └──────────────┘           │             │  Step N      │
  │                              │             │              │
  │  ┌──────────────┐  provides  │  defines    │              │
  │  │ Execution    │───skill───▶│──actions───▶│  Do the step │
  │  │ (do)         │  template  │             │              │
  │  └──────────────┘           │             │              │
  │                              │             │              │
  │  ┌──────────────┐  checks   │     ⊗       │              │
  │  │ Verification │───output──▶│──GATE──────▶│  Next step   │
  │  │ (check)      │  criteria  │  pass/fail  │  or STOP     │
  │  └──────────────┘           │             │              │
  │                              │             │              │
  │  ┌──────────────┐  handles  │  routes     │              │
  │  │ Recovery     │───failure─▶│──retry/────▶│  Retry or    │
  │  │ (adjust)     │           │  escalate   │  Escalate    │
  │  └──────────────┘           │             │              │
  └──────────────────────────────┘             └──────────────┘

  {M14} Steps per task (decomposition quality)
  {M15} Gate pass rate per step (verification coverage)
  {M16} Recovery success rate (resilience)
  {M17} Steps requiring human escalation (autonomy level)
```

### Edge E11: EA → EO (yields) + Edge E12: EO → EI (feedback)

```
  EA                            EO                           EI
  ┌──────────────┐              ┌──────────────┐             ┌──────────────┐
  │              │              │              │             │              │
  │ ┌──────────┐│   quality    │ ┌──────────┐│  Corrective │ ┌──────────┐│
  │ │ Trace    ││─────────────▶│ │ Sustain. ││──signal────▶│ │Corrective││
  │ │(what)    ││              │ │ (correct?)││  "fix this" │ │(feedback)││
  │ └──────────┘│              │ └──────────┘│             │ └──────────┘│
  │              │              │              │             │              │
  │ ┌──────────┐│   economy    │ ┌──────────┐│  Context    │ ┌──────────┐│
  │ │ Quality  ││─────────────▶│ │ Efficienc││──update────▶│ │Contextual││
  │ │(how well)││              │ │ (cheap?) ││  "know this"│ │(knowledge)│
  │ └──────────┘│              │ └──────────┘│             │ └──────────┘│
  │              │              │              │             │              │
  │ ┌──────────┐│   repeat-    │ ┌──────────┐│  Goal       │ ┌──────────┐│
  │ │Efficiency││───ability───▶│ │ Scalabil.││──refine────▶│ │Directive ││
  │ │(how much)││              │ │ (repeat?)││  "do this"  │ │(next task)│
  │ └──────────┘│              │ └──────────┘│             │ └──────────┘│
  └──────────────┘              └──────────────┘             └──────────────┘

  {M18} Task completion rate (S)
  {M19} Token cost per task (E)
  {M20} Consistency across repeated runs (Sc)
  {M21} Feedback incorporation rate (loop health)
```

---

# PART 3 — THE COMPLETE AGENT EXECUTION CYCLE

## 3.1 Single-Turn Execution Flow

One complete cycle from input to output, showing every component involved:

```
 ┌─────────────────────────────────────────────────────────────────────────┐
 │                        SINGLE TURN EXECUTION                            │
 │                                                                         │
 │  ┌──────┐     ┌─────────────────────────────────────────────────────┐  │
 │  │  EI  │     │              HARNESS                                │  │
 │  │      │     │                                                     │  │
 │  │ Dir. │──1──│──▶ EP loaded? ─yes─▶ EOE hooks fire ─allowed?──┐   │  │
 │  │ Ctx. │     │       │              (SessionStart,             │   │  │
 │  │ Cor. │     │       │no             PreToolUse)           yes │   │  │
 │  └──────┘     │       ▼                                     │   │  │
 │               │   ⊗ STOP:                                   ▼   │  │
 │               │   missing rules                                 │  │
 │               │                   ┌──────────────────────┐      │  │
 │               │              2    │    EU (inference)     │◀─────┘  │
 │               │                   │                      │         │
 │               │                   │  EOP provides skill  │◀──3──┐  │
 │               │                   │  EU follows steps    │      │  │
 │               │                   │                      │      │  │
 │               │                   │  EU calls EOT tools  │──4──▶│  │
 │               │                   │                      │      │  │
 │               │                   │  EOE checks each call│◀──5──│  │
 │               │                   │  (PreToolUse hook)   │      │  │
 │               │                   │                      │      │  │
 │               │                   │  Tool executes       │──6──▶│  │
 │               │                   │  (PostToolUse hook)  │◀──7──│  │
 │               │                   │                      │      │  │
 │               │                   └──────────┬───────────┘      │  │
 │               │                              │                  │  │
 │               │                         8    ▼                  │  │
 │               │                   ┌──────────────┐              │  │
 │               │                   │      EA      │              │  │
 │               │                   │  (observed)  │              │  │
 │               │                   └──────┬───────┘              │  │
 │               │                          │                      │  │
 │               │                     9    ▼                      │  │
 │               │                   ┌──────────────┐              │  │
 │               │                   │ EOP Verify   │──── ⊗ GATE  │  │
 │               │                   │ (check)      │  pass? fail?│  │
 │               │                   └──────┬───────┘      │      │  │
 │               │                     pass │          fail │      │  │
 │               │                          ▼              ▼      │  │
 │               └──────────────────────────┼─── EOP Recovery ────┘  │
 │                                          │   (retry/escalate)     │
 │  ┌──────┐                           10  │                        │
 │  │  EO  │◀───────────────────────────────┘                        │
 │  │      │                                                         │
 │  │ S    │── {M18} task complete?                                  │
 │  │ E    │── {M19} tokens used?                                    │
 │  │ Sc   │── {M20} repeatable?                                     │
 │  └──┬───┘                                                         │
 │     │ 11                                                          │
 │     └─── ─ ─ ─ ─ feedback ─ ─ ─ ─ ─ ─ ─ ─ ─▶ EI (next turn)    │
 └─────────────────────────────────────────────────────────────────────┘

 Step sequence:
  1. EI feeds EU (Directive prompt + Contextual state + Corrective feedback)
  2. EU begins inference within harness
  3. EOP provides procedure (skill/workflow/template)
  4. EU invokes EOT tool
  5. EOE PreToolUse hook fires — checks permission, enforces policy
  6. Tool executes (Inspection/Discovery/Modification/Interaction)
  7. EOE PostToolUse hook fires — logs, validates, triggers follow-on
  8. EA emerges (observable: what tool was called, what it returned)
  9. EOP Verification gate checks output against criteria
 10. If PASS → EO emitted. If FAIL → EOP Recovery (retry or escalate).
 11. EO feeds back into EI as Corrective input for next turn.
```

## 3.2 Multi-Agent Execution Flow

When EU dispatches sub-agents (Orchestrator → Executor pattern):

```
                     ┌─────────────────────────────────────┐
                     │         ORCHESTRATOR (EU-0)          │
                     │  Model: Opus | Role: Plan + Synth   │
                     │                                     │
                     │  EOP-Orchestration decomposes:      │
                     │  Task → Step 1, Step 2, Step 3      │
                     └──────────┬──────────┬───────────────┘
                                │          │
                           Step 1      Step 2
                                │          │
                     ┌──────────▼──┐  ┌────▼──────────┐
                     │ EXECUTOR    │  │ EXECUTOR       │
                     │ (EU-1)      │  │ (EU-2)         │
                     │             │  │                │
                     │ Model:Sonnet│  │ Model:Haiku    │
                     │ Role:Build  │  │ Role:Explore   │
                     │             │  │                │
                     │ Own EP ────▶│  │◀──── Own EP   │
                     │ Own EOE ───▶│  │◀──── Own EOE  │
                     │ Own EOT ───▶│  │◀──── Own EOT  │
                     │ Own EOP ───▶│  │◀──── Own EOP  │
                     │             │  │                │
                     │ Isolated:   │  │ Isolated:      │
                     │ own context │  │ own context    │
                     │ own worktree│  │ own worktree   │
                     └──────┬──────┘  └─────┬──────────┘
                            │               │
                       EA-1 │          EA-2 │
                            ▼               ▼
                     ┌──────────────────────────────┐
                     │  ⊗  EOP-Verification (EU-0)  │
                     │     Orchestrator checks:      │
                     │     - EA-1 meets AC?           │
                     │     - EA-2 meets AC?           │
                     │     - Coherent together?       │
                     └──────────────┬───────────────┘
                                    │
                                    ▼
                              [EO emitted]

  KEY PRINCIPLE (EP-13): Only EU-0 (orchestrator) dispatches.
  Sub-agents NEVER call Agent(). Chain depth = 1.

  {M22} Sub-agent count per task (should be ≤ 4)
  {M23} Sub-agent AC pass rate
  {M24} Orchestrator synthesis quality
```

---

# PART 4 — MEASUREMENT FRAMEWORK

## 4.1 All 24 Measurement Points

Every `{Mn}` from the diagrams above, organized by what they measure:

### EO Metrics (the dependent variable)

| ID | Metric | Pillar | Formula | Target |
|----|--------|--------|---------|--------|
| M18 | Task completion rate | S | completed_tasks / total_tasks | > 95% |
| M19 | Token cost per task | E | total_tokens / completed_tasks | trending down |
| M20 | Cross-run consistency | Sc | std_dev(quality) across N identical runs | < 10% variance |

### Edge Health Metrics (the independent variables)

| ID | Metric | Edge | What it diagnoses |
|----|--------|------|-------------------|
| M1 | Directive input tokens | E1 | Is the prompt lean or bloated? |
| M2 | Contextual freshness | E1 | Is memory/state current or stale? |
| M3 | Corrective signal strength | E1 | Was prior failure's lesson captured? |
| M4 | Rule coverage | E2-E5 | EP rules loaded vs. available |
| M5 | Rule violation rate | E2 | How often does EU ignore EP? |
| M6 | Rule-to-hook ratio | E3 | Critical rules backed by EOE hooks? |
| M7 | Hook latency | E6 | Hooks slowing down execution? |
| M8 | Permission denial rate | E6 | EOE too restrictive or too permissive? |
| M9 | Context utilization % | E6 | How much of budget is used? |
| M10 | Compaction events | E6 | Context pressure indicator |
| M11 | Tool calls per task | E8 | Efficiency of tool use |
| M12 | Tool error rate | E8 | Tool reliability |
| M13 | Tool selection accuracy | E8 | Right tool for right job? |
| M14 | Steps per task | E9 | Decomposition quality |
| M15 | Gate pass rate | E9 | Verification coverage |
| M16 | Recovery success rate | E9 | Resilience when things fail |
| M17 | Human escalation rate | E9 | Autonomy level |
| M21 | Feedback incorporation | E12 | Loop health — is learning happening? |
| M22 | Sub-agent count | E9 (multi) | Dispatch efficiency |
| M23 | Sub-agent AC pass | E9 (multi) | Sub-agent quality |
| M24 | Synthesis quality | E9 (multi) | Orchestrator coherence |

## 4.2 The Evaluation Protocol

```
  FOR EACH harness change (EP, EOE, EOT, or EOP):

  1. BASELINE — Run 20-50 test cases with current config → record EO (M18, M19, M20)
  2. CHANGE   — Modify exactly ONE variable in ONE component
  3. MEASURE  — Run same 20-50 test cases → record new EO
  4. COMPARE  — EO delta across S × E × Sc dimensions

  5. DIAGNOSE — If EO worsened:
     → Which edge metrics (M1-M17, M21-M24) shifted?
     → Blame Diagnostic: EP → EI → EOP → EOE → EOT → EU
     → Classify component zone: Below Threshold / Leverage / Saturated

  6. DECIDE   — If EO improved:
     → Commit the change
     → Update sigmoid zone classification
     → Check: did this lower K for another component? (synergy)

  REPEAT — This is the reinforcing loop that compounds improvement.
```

## 4.3 Sigmoid Zone Classification Tool

```
  For each component, answer:

  ┌──────────────────────────────────────────────────────────────────┐
  │  Component: ___________                                         │
  │                                                                  │
  │  1. What % of recent failures trace to this component?          │
  │     □ > 50%  → BELOW THRESHOLD (invest heavily)                 │
  │     □ 10-50% → LEVERAGE ZONE (keep investing)                   │
  │     □ < 10%  → SATURATED (move on)                              │
  │                                                                  │
  │  2. Would strengthening another component lower THIS             │
  │     component's threshold (K)?                                   │
  │     If yes → cross-component play (highest leverage of all)     │
  │                                                                  │
  │  Current classification: [________] | Date: [____-__-__]        │
  └──────────────────────────────────────────────────────────────────┘
```

---

## Sources

- System Thinking & Design Notes V2 (`OPS_OE.6.0/research/amt/SYSTEM-THINKING-DESIGN-NOTES-v2.md`)
- Agent Harness System blueprint (`inbox/agent-harness-system.md`)
- Harness Engineering Research (`inbox/research-harness-engineering-2026.md`)
- Agent System 7-CS (`rules/agent-system.md`)

## Links

- [[agent-harness-system]]
- [[agent-system]]
- [[enforcement-layers]]
- [[harness-engineering-research-2026]]
- [[ltc-effective-agent-principles-registry]]
