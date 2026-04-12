---
version: "1.0"
status: draft
last_updated: 2026-04-12
---

# The 8-Component Agent Harness System

> Foundational blueprint for designing, building, and operating AI agentic systems.
> Derived from LTC's 7-CS framework, validated against 28 industry sources (2025-2026).
> Audience: Human Directors and AI Agents. Load when configuring, diagnosing, or building any agent system.

---

## 1. The Core Insight

An AI agent is a model plus a harness. The model is commodity. The harness determines outcomes.

Identical models show 60% vs 98% task completion rates based entirely on harness quality. OpenAI shipped ~1,000,000 lines of code with 3 engineers and zero manually-written code — by investing in harness infrastructure, not model tuning. Prompt optimization has diminishing returns past ~85% task completion; past that point, improvements come from harness engineering.

**Harness engineering** is the discipline of designing the constraints, feedback loops, documentation structures, enforcement mechanisms, and lifecycle management systems that allow AI agents to operate reliably. It is meta-engineering: engineering the environment in which engineering happens.

The harness is everything you can control. The model is what you are given.

---

## 2. The System Formula

```
EO = f(EP, EI, EOP, EOE, EOT, EU, EA)
```

Every Effective Outcome is a function of 7 interacting components. Together with EO, they form the 8-Component System: 6 controllable, 2 emergent.

### Relationship to 7-CS

This document extends the 7-Component System defined in `rules/agent-system.md`. Three intentional changes:

| 7-CS (agent-system.md) | 8-CS (this document) | Rationale |
|------------------------|---------------------|-----------|
| "Input" | **EI** (Effective Input) | Aligns naming with the E-prefix convention used by all other components (EP, EOE, EOT, EOP). Input remains the same concept. |
| "Agent" | **EU** (Effective User) | Aligns with the Effective System Design framework where the doer is always the "User" — in AI systems, the model IS the user of the harness. |
| 7 components (EO is outcome, not component) | **8 components** (EO promoted to full component) | EO is measured and designed for, not merely received. Promoting it to a component makes the evaluation framework explicit: vary harness → measure EO delta. |

The 7-CS dependency graph shows EP governing Input directly. This document maintains that relationship — EP's Structural category (naming, formatting) constrains how EI is organized, and EP's Behavioral category constrains what the agent does with EI. The Section 5 dependency graph focuses on the 4 direct-control subsystems; EP governs EI through its Structural principles.

### The Flow

```
                         ┌──────────────────────────────────┐
                         │     HARNESS  (4 direct control)   │
                         │                                   │
                         │  ┌────┐   ┌─────┐   ┌─────┐     │
                         │  │ EP │   │ EOE │   │ EOT │     │
                         │  └──┬─┘   └──┬──┘   └──┬──┘     │
                         │     │governs  │limits    │extends │
                         │     ▼         ▼          ▼       │
 ┌──────┐  shapes   ┌───────────────────────────────────┐   │     ┌──────┐
 │  EI  │◀══════════│  All 4 harness components feed    │   │     │  EO  │
 │      │           │  INTO EI — EI is the GATEWAY      │   │────▶│      │
 │ THE  │──────────▶│                                   │   │     │Result│
 │GATE- │ feeds     │  ┌───────────────────────────┐    │   │     └──────┘
 │ WAY  │           │  │      EU (Agent/Model)      │    │   │  Sustainability
 └──────┘           │  │  sees ONLY what passes     │    │   │  Efficiency
                    │  │  through EI                │    │   │  Scalability
                    │  └──────────┬────────────────┘    │   │
                    │             │ executes via         │   │
                    │       ┌─────┐   ┌─────┐          │   │
                    │       │ EOP │   │ EA  │          │   │
                    │       └─────┘   └─────┘          │   │
                    └───────────────────────────────────┘   │
                                                           │
 ◄── ─ ─ ─ ─ ─ ─ ─ ─ ─ feedback ─ ─ ─ ─ ─ ─ ─ ─ ─ ─ ─ ─┘

 CONTROLLABLE (6):
   Direct control:   EP + EOE + EOT + EOP   ← we author and configure
   Indirect control: EI + EU                 ← we shape through the above
 EMERGENT (2):
   EA + EO                                   ← observe and measure
```

**The Gateway Principle:** The agent sees nothing except what passes through EI. EP rules are loaded into EI. EOE hooks inject context into EI. EOT tool results enter EI. EOP skill templates enter EI. Every harness component's effect on EO is mediated through EI. This makes EI the convergence point — the single highest-leverage node after EP for outcome quality.

The Human Director is not a component — they are the Accountable party who owns the outcome, provides judgment, and approves results. The Agent is the Responsible party who executes within the harness.

---

## 3. The 8 Components — Summary

| # | Component | Nature | Categories | Role |
|---|-----------|--------|------------|------|
| 1 | **EI** — Effective Input | Information entering the system | Directive, Contextual, Corrective | **The Gateway** — convergence point for all harness effects |
| 2 | **EU** — Effective User (Agent) | The cognitive entity performing work | Capability, Configuration, Limitations | Executes within harness |
| 3 | **EP** — Effective Principles | Constraints on system behavior | Behavioral, Structural, Relational | Constitution — governs all |
| 4 | **EOE** — Effective Operating Environment | Boundaries of the workspace | Temporal, Spatial, Quantitative, Authorization | Sandbox — sets hard ceilings |
| 5 | **EOT** — Effective Operating Tools | Instruments extending agent capability | Inspection, Discovery, Modification, Interaction | Force multipliers |
| 6 | **EOP** — Effective Operating Procedures | Prescribed sequences of actions | Orchestration, Execution, Verification, Recovery | Playbook — step-by-step |
| 7 | **EA** — Effective Action | Observable behavior that emerges | Trace, Quality, Efficiency | Diagnostic target |
| 8 | **EO** — Effective Outcome | The measured result | Sustainability, Efficiency, Scalability | What we optimize for |

---

## 4. Component Cards

Each card defines: what the component IS, its MECE categories derived from first principles, what it COMPENSATES FOR in the agent, and how to EVALUATE it.

---

### 4.1 EI — Effective Input (The Gateway)

**Definition:** All information that flows into the system for a specific task. EI is not merely an input pipe — it is the **convergence point** through which every harness component's effect reaches the agent. The agent sees nothing except what passes through EI. This makes EI the de facto gateway to EO.

**Why EI is the highest-leverage node after EP:**

```
EP rules loaded into context ───────────────┐
EOE hooks inject git status, auto-recall ───┤
EOT tool results enter as context ──────────┼──▶  EI  ──▶  EU  ──▶  EA  ──▶  EO
EOP skill templates loaded as context ──────┤
User prompt + memory + history ─────────────┘
```

Every harness component ultimately expresses its effect BY SHAPING WHAT ENTERS EI. A brilliant EP that fails to load into context has zero effect. A powerful EOT whose results are lost in context compression has zero effect. EI quality is the bottleneck — if it is below threshold, no other component compensates (multiplicative function: any zero makes the product zero).

**Derivation:** From control theory, a system receives exactly 3 types of signals.

| Category | Signal Type | What It Contains | Controlled by |
|----------|------------|-----------------|---------------|
| **Directive** | Feedforward — WHAT to do | Task prompt, goals, acceptance criteria, constraints, budget | User (directly) + EOP (templates shape task structure) |
| **Contextual** | State — WHAT to know | Memory, loaded files, domain knowledge, session history, git state | EP (rules loaded) + EOE (hooks inject) + EOT (search/retrieval) |
| **Corrective** | Feedback — WHAT to fix | Error messages, user corrections, eval results, prior failures | EO (feedback loop) + EOP (recovery procedures surface errors) |

**Key principles:**
- Every unnecessary token degrades signal-to-noise (LT-7). Curated 2,000-token context outperforms 100,000-token dumps.
- **Memory and persistent state are Contextual input** — they enter the system via EI, not as a separate mechanism. Memory management IS EI management. The research finding that "memory is the single biggest open problem in agent architecture" is an EI-Contextual problem.
- **Financial resources** (budget, API credits) are Directive input — they constrain the task scope.
- **The EI optimization question:** what to load, when to load it, and how much — answered by EP (what), EOE (when, how much), and EOT (retrieval mechanism).

**Compensates for:** LT-6 (no persistent memory — provide state as Contextual input), LT-2 (lossy context — structure input to resist compression), LT-4 (fragile retrieval — label and organize clearly).

**Controllability:** EI is indirectly controlled through all 4 harness components. The team that masters "what enters the agent's context, when, and in what structure" masters the gateway to outcome quality.

---

### 4.2 EU — Effective User (Agent)

**Definition:** The cognitive entity that performs work — its capabilities, configuration, and structural limits. In an AI agentic system, EU is the language model. The other 6 components exist to compensate for EU's limitations while amplifying its strengths.

**Derivation:** An agent is fully described by 3 dimensions.

| Category | Dimension | What It Covers |
|----------|-----------|---------------|
| **Capability** | What the agent CAN do | Model architecture, training data, knowledge cutoff, reasoning depth |
| **Configuration** | How the agent is TUNED | Model selection (tier), effort level, thinking mode, speed tradeoffs |
| **Limitations** | What the agent CANNOT do | The 8 structural constraints (below) |

**The 8 Structural Limitations (LTs):**

These are not bugs. They are structural properties of transformer-based language models, proven from multiple independent mathematical and empirical results.

| # | Limitation | Bottleneck | Harness compensation |
|---|-----------|-----------|---------------------|
| LT-1 | Hallucination is structural | Factual accuracy | EP (validation rules), EOT (fact-checking) |
| LT-2 | Context compression is lossy | Volume of info loaded | EOE (context budget), EI (structured input) |
| LT-3 | Reasoning degrades on complex tasks | Logical step count | EOP (smaller steps with gates), EOE (extended thinking) |
| LT-4 | Retrieval is fragile under noise | Precision in context | EI (labeled sections), EOT (dedicated search) |
| LT-5 | Prediction optimizes plausibility, not truth | Truth vs. sounding right | EP (require evidence), EOT (external verification) |
| LT-6 | No persistent memory across sessions | Cross-session continuity | EI (load state as Contextual input), EOT (memory vault) |
| LT-7 | Cost scales with token count | Budget | EI (lean context), EP (concise rules), EOE (budget limits) |
| LT-8 | Alignment is approximate | Rule compliance under pressure | EP (behavioral constraints), EOP (verification gates) |

**Key principle:** Only Configuration is directly engineerable. Capability and Limitations are given by the model provider. Understanding Limitations determines how you design EP, EOE, EOT, and EOP — the 4 direct-control components exist specifically to compensate for these 8 limits.

---

### 4.3 EP — Effective Principles

**Definition:** Persistent rules that constrain system behavior — the constitution. EP governs all other components. No component may violate EP. Loaded at session start, always active.

**Derivation:** A constraint can only govern one of 3 things: what agents DO, how artifacts are SHAPED, or how actors INTERACT. These are exhaustive and mutually exclusive — every principle falls into exactly one category.

| Category | Governs | Examples |
|----------|---------|---------|
| **Behavioral** | What the agent DOES and DOES NOT DO | Safety rules, forbidden actions, required behaviors, security scanning |
| **Structural** | How ARTIFACTS are shaped | Naming conventions, file format rules, versioning schema, brand identity |
| **Relational** | How ACTORS interact | Human-only approvals, agent scope boundaries, escalation triggers, handoff protocols |

**Design principles for EP:**
- Concise over comprehensive. A 100-line constitution outperforms a 1,000-line one (LT-2, LT-7).
- Use a table-of-contents pattern: short EP file points to on-demand full specifications.
- Every principle should trace to a specific LT it compensates for or a UBS it disables.
- Contradictory principles cause unpredictable behavior (LT-5) — define priority hierarchy.

**Enforcement tier:** Documentation — agent reads and follows. This is the weakest enforcement tier because it depends on model compliance (LT-8). Pair critical behavioral principles with EOE enforcement (hooks).

---

### 4.4 EOE — Effective Operating Environment

**Definition:** The physical and logical boundaries within which the agent operates. EOE sets hard ceilings — no component can exceed what EOE allows. EOE fires deterministically; it does not depend on the model reading and following instructions.

**Derivation:** From systems theory, any environment is fully described by 4 orthogonal dimensions — when, where, how much, and who. These are the fundamental axes of any constrained workspace.

| Category | Dimension | What It Controls |
|----------|-----------|-----------------|
| **Temporal** | WHEN things happen | Lifecycle events (hooks), scheduling, triggers, event sequencing |
| **Spatial** | WHERE things can happen | Sandbox boundaries, file access scope, process isolation, worktrees |
| **Quantitative** | HOW MUCH is available | Context window budget, token limits, cost ceiling, timeout duration |
| **Authorization** | WHO may do WHAT | Permission modes, tool allow/deny lists, approval gates, escalation tiers |

**Design principles for EOE:**
- Enforcement hierarchy: tool restriction (can't) > hook (automatic) > state (persists) > instructions (might).
- If a failure mode matters, do not rely on EP to prevent it. Build the constraint into EOE.
- Hooks are the primary enforcement mechanism — they fire deterministically at tool boundaries regardless of model compliance.
- Context budget must be explicitly allocated: EP X tokens, EI Y, EOP Z, reasoning gets the remainder.

**Enforcement tier:** Automated — hooks fire deterministically. This is the strongest machine enforcement layer.

---

### 4.5 EOT — Effective Operating Tools

**Definition:** Instruments callable by the agent that extend its capabilities beyond the model alone. Tools are force multipliers, not governors — they amplify what the agent can do, subject to EP constraints and EOE limits.

**Derivation:** A tool's fundamental nature is defined by 2 orthogonal axes: its EFFECT on system state (observe vs. transform) and its SCOPE (local vs. external). This yields a 2x2 matrix that is exhaustive by construction.

|  | Local | External |
|---|---|---|
| **Observe** | **Inspection** — read files, search code, check status | **Discovery** — web search, API queries, semantic search |
| **Transform** | **Modification** — write files, edit code, execute commands | **Interaction** — API calls, send messages, push to remote |

**Design principles for EOT:**
- Fewer tools = better results. Production agents work best with 3-7 tools per agent, not 20. Tool selection accuracy degrades sharply as catalogs grow.
- Tool descriptions are interface contracts — invest more time in tool descriptions than in system prompts.
- Concurrency classification matters: Inspection and Discovery tools run in parallel; Modification and Interaction tools run serially.
- Poka-yoke principle: redesign tool arguments to make mistakes structurally impossible rather than instructing the agent to avoid them.

**Enforcement tier:** Mechanical — tools either exist or they don't. Tool allowlists/denylists are EOE Authorization constraints; tool engineering (descriptions, arguments, error handling) is EOT.

---

### 4.6 EOP — Effective Operating Procedures

**Definition:** Prescribed sequences of actions that the agent follows to accomplish work. EOP decomposes complex tasks into manageable steps with defined inputs, outputs, and verification gates. Loaded on demand — not always in context.

**Derivation:** From the PDCA cycle (Plan-Do-Check-Adjust), managing work has exactly 4 phases. These are exhaustive and sequential — every procedure exists to orchestrate, execute, verify, or recover.

| Category | Phase | What It Contains |
|----------|-------|-----------------|
| **Orchestration** | PLAN — decompose and coordinate | Workflow definitions, multi-agent dispatch, build sequencing, dependency graphs |
| **Execution** | DO — perform defined work | Skills, scripts, agent task definitions, templates |
| **Verification** | CHECK — validate against criteria | Gates, acceptance criteria checks, review protocols, compliance tests |
| **Recovery** | ADJUST — handle failures | Retry logic, rollback procedures, escalation paths, error classification |

**Design principles for EOP:**
- Each step must have explicit input requirements, expected output, and binary acceptance criteria.
- Steps sized to fit within the agent's reliable reasoning window — 95% per-step reliability = 59% end-to-end at 10 steps.
- Separate orchestrator from executor: "An orchestrator that can also write code will always take the shortcut of writing code. The constraint of not being able to is what makes it a good manager."
- Progressive disclosure: load only what's needed for the current step, not everything upfront.

**Enforcement tier:** Procedural — the agent follows steps. Mid-tier enforcement that depends on both model compliance (LT-8) and EOE hooks backing critical gates.

---

### 4.7 EA — Effective Action

**Definition:** The observable execution that emerges from all components interacting. EA is not configured — it emerges. When EA fails, the root cause is in the other 6 components.

**Derivation:** From measurement theory, any action is observed along 3 independent dimensions — what happened, how well, and how economically.

| Category | Question | What You Observe |
|----------|----------|-----------------|
| **Trace** | WHAT happened? | Tool call sequence, reasoning steps, files modified, agents dispatched |
| **Quality** | HOW WELL? | Correctness, completeness, rule compliance, coherence |
| **Efficiency** | HOW ECONOMICALLY? | Tokens consumed, time elapsed, steps taken, cost incurred |

**Diagnostic protocol (Blame Diagnostic):**

When EA fails, trace backwards through the 6 input components in this order:

```
EP → EI → EOP → EOE → EOT → EU
```

1. **EP** — Did the agent have the right rules? Were they contradictory?
2. **EI** — Did the agent have the right input? Was it ambiguous? Missing context?
3. **EOP** — Did the procedure decompose the task correctly? Were steps too large?
4. **EOE** — Did the environment allow the right actions? Were hooks misconfigured?
5. **EOT** — Did tools work correctly? Were descriptions misleading?
6. **EU** — Is this a model limitation (LT-1 through LT-8)?

**Key principle:** Treating EA as the problem ("the agent messed up") is always wrong. EA is a symptom — the root cause lives in the buildable components.

---

### 4.8 EO — Effective Outcome

**Definition:** The measured result of the system — the dependent variable. EO is what we optimize for. It is not configured; it is measured.

**Derivation:** From LTC's S x E x Sc framework, outcomes are assessed along 3 pillars in strict priority order — Sustainability first, Efficiency second, Scalability third.

| Category | Pillar | Question | What You Measure |
|----------|--------|----------|-----------------|
| **Sustainability** | S | Is it CORRECT and SAFE? | Artifact quality, error rate, no regressions, no side effects |
| **Efficiency** | E | Was it ECONOMICAL? | Token cost, time to completion, human review effort |
| **Scalability** | Sc | Can it REPEAT and EXTEND? | Consistency across runs, knowledge captured, reusability |

**The Evaluation Framework:**

```
Hold EI constant → vary one of { EP, EOE, EOT, EOP } → measure EO delta
```

This is controlled experimentation on agent system configuration. By holding input constant and changing one harness variable at a time, you isolate what drives outcome improvement. Without this discipline, changes compound unpredictably.

**Priority hierarchy:** A correct but slow outcome (S > E) is always preferred over a fast but incorrect one. An economical but non-repeatable outcome (E > Sc) is preferred over a repeatable but expensive one. This ordering is axiomatic — do not override.

---

## 5. The 6 Controllable Components

Of the 8 components, 6 are controllable — 4 through direct authoring, 2 through indirect shaping. Together they form the engineering surface of any agent harness.

```
CONTROLLABLE (6):
├── Direct control (we author/configure):
│   ├── EP  — rules, constraints, principles
│   ├── EOE — hooks, permissions, budget, sandbox
│   ├── EOT — tools, scripts, MCP servers
│   └── EOP — skills, workflows, agents, templates
│
└── Indirect control (we shape through the above):
    ├── EI  — what enters the agent's context (THE GATEWAY)
    └── EU  — which model, how tuned, what effort level

EMERGENT (2):
├── EA  — what the agent does (observe for diagnosis)
└── EO  — what results (measure for improvement)
```

### The 4 Direct-Control Subsystems

These 4 form the subsystems of the agent harness repo. EI and EU are not separate subsystems — they are the convergence point and the execution engine that the 4 subsystems serve.

```
┌──────────────────────────────────────────────────────────────┐
│                    AGENT HARNESS                              │
│                                                              │
│  ┌─────────────────┐  ┌─────────────────────────────────┐   │
│  │  1-EP            │  │  2-EOE                           │   │
│  │  Effective        │  │  Effective Operating              │   │
│  │  Principles       │  │  Environment                      │   │
│  │                   │  │                                   │   │
│  │  Behavioral       │  │  Temporal (hooks, events)         │   │
│  │  Structural       │  │  Spatial (sandbox, isolation)     │   │
│  │  Relational       │  │  Quantitative (budget, limits)   │   │
│  │                   │  │  Authorization (permissions)      │   │
│  └─────────────────┘  └─────────────────────────────────┘   │
│                                                              │
│  ┌─────────────────┐  ┌─────────────────────────────────┐   │
│  │  3-EOT           │  │  4-EOP                           │   │
│  │  Effective        │  │  Effective Operating              │   │
│  │  Operating Tools  │  │  Procedures                       │   │
│  │                   │  │                                   │   │
│  │  Inspection       │  │  Orchestration (plan)             │   │
│  │  Discovery        │  │  Execution (do)                   │   │
│  │  Modification     │  │  Verification (check)             │   │
│  │  Interaction      │  │  Recovery (adjust)                │   │
│  └─────────────────┘  └─────────────────────────────────┘   │
│                                                              │
└──────────────────────────────────────────────────────────────┘
```

### Dependency Graph Between Subsystems

```
EP ──────────────────── governs all ─────────────────────▶ EOE, EOT, EOP, EU
EOE ─────────────────── limits ──────────────────────────▶ EOT, EU
EOT ─────────────────── extends ─────────────────────────▶ EU
EOP ─────────────────── orchestrates ────────────────────▶ EU (via EOT)
```

EP constrains everything. EOE constrains what EOT and EU can do. EOT provides the instruments EU uses. EOP provides the sequences EU follows. No lateral dependency between EOT and EOP — they are independent subsystems that both serve EU.

### Build Order

Practitioner consensus from 28 industry sources:

| Priority | Subsystem | Rationale |
|----------|-----------|-----------|
| 1st | **EOT** | Tools first — you cannot verify what you cannot instrument |
| 2nd | **EOE** | Harden the sandbox — enforcement before procedures |
| 3rd | **EOP** | Procedures assume working tools in a hardened environment |
| Last | **EP** | Already the most mature in practice; codify and lock last |
| Always | **Eval** | Cross-cutting — measures EO to drive improvement in all 4 |

---

## 6. System Dynamics

### 6.1 The Reinforcing Loop

```
Better EP/EOE/EOT/EOP
        │
        ▼
  Better EA (agent performs better)
        │
        ▼
  Better EO (outcomes improve)
        │
        ▼
  Better EI (more knowledge captured as Corrective + Contextual input)
        │
        ▼
  Better EP/EOE/EOT/EOP (informed by what worked)
        │
        ▼
  ... (compounding improvement)
```

Harness engineering compounds. When you invest in the harness, you improve outcomes, which generates better feedback, which improves the harness. This is why early investment in EOT and EOE pays exponential returns — each improvement makes the next one easier.

### 6.2 The Balancing Loop (Diminishing Returns)

Each component follows an S-curve (sigmoid):

```
  Output
    │          ╭──── Saturated (move on)
    │        ╱
    │      ╱──── Leverage Zone (keep investing)
    │    ╱
    │  ╱
    │╱──────── Below Threshold (invest heavily)
    └──────────── Investment
```

| Zone | Signal | Action |
|------|--------|--------|
| **Below Threshold** | Frequent failures traceable to this component | Invest heavily — highest ROI |
| **Leverage Zone** | Occasional failures, clear improvement path | Keep investing — still compounding |
| **Saturated** | Rare failures, diminishing returns per change | Move to next component |

The Blame Diagnostic identifies which component is in which zone. If 80% of failures trace to EOE, EOE is Below Threshold — invest there, not in EP.

### 6.3 The Anti-Patterns

5 failure modes that destroy harness effectiveness:

| Anti-Pattern | Mechanism | Harness Fix |
|-------------|-----------|-------------|
| **Mega-Prompt** | Single instruction file with every rule degrades agent performance | EP: table-of-contents pattern, on-demand loading |
| **Tool Soup** | Too many tools degrade selection accuracy (>7 per agent) | EOT: minimal tool set per agent, Poka-yoke arguments |
| **Happy Path Only** | No recovery logic = <50% success when tools fail | EOP: Recovery category — explicit error handling per step |
| **Prompt Tinkering** | Endlessly refining prompts for structural problems | EOE: hooks for enforcement, not EP for persuasion |
| **Comprehension Debt** | Gap between AI output volume and human understanding | EOP: Verification category — review gates, classification steps |

---

## 7. Design Principles

4 root principles underpin all harness engineering. They are universal — validated across every credible source in the research.

### Principle 1: Constraints Improve Output

> "Agents don't hallucinate less because you asked nicely. They hallucinate less because you constrained their environment."

Fewer tools, tighter rules, smaller context windows all improve agent performance. This is counterintuitive but empirically verified: removing 80% of tools improved task completion in production. The mechanism: constraints reduce the agent's decision space, which reduces the probability of choosing a wrong action (LT-1, LT-3, LT-5).

**Implication:** EP and EOE are not overhead — they are force multipliers.

### Principle 2: Decomposition Defeats Compounding Error

> "95% reliability per step = 59% end-to-end at 10 steps."

Each probabilistic step multiplies the failure probability. The only structural defense is decomposition: break tasks into smaller steps with verification gates between them. This is not a preference — it is mathematical necessity.

**Implication:** EOP Orchestration and Verification categories are not optional — they are required by the physics of probabilistic systems (LT-3).

### Principle 3: Architectural Enforcement Beats Prompt Instructions

> "If a failure mode matters, do not rely on the prompt to prevent it. Build the constraint into the system."

Rules in EP are documentation-tier enforcement — the weakest layer. Hooks in EOE are automated-tier — they fire deterministically regardless of model compliance. Every critical behavioral rule should have both: EP states the intent; EOE enforces it.

**Implication:** Invest in EOE hooks for every EP principle that, if violated, causes harm.

### Principle 4: Evaluation Is the Compounding Mechanism

> "Absent evals, debugging is reactive."

Without systematic evaluation, improvement is accidental. With it, every change can be measured against baseline. Teams with evaluation pipelines can "determine strengths, tune prompts, and upgrade in days." The build order starts with EOT (you need tools to measure) and the evaluation pipeline spans all 4 subsystems.

**Implication:** The EO → EI feedback loop (better outcomes → better Corrective input → better harness) only works if EO is measured, not guessed.

---

## 8. Applying This Blueprint

### For Designing a New Agent System

1. **Start with EU** — understand the model's Capabilities, Configuration options, and Limitations (8 LTs). The Limitations determine what your harness must compensate for.
2. **Define EI** — what Directive, Contextual, and Corrective input will flow in? Design the input pipeline.
3. **Build EOT first** — what Inspection, Discovery, Modification, and Interaction tools does the agent need? Minimum viable set.
4. **Harden EOE** — what Temporal, Spatial, Quantitative, and Authorization boundaries protect the system?
5. **Design EOP** — what Orchestration, Execution, Verification, and Recovery procedures structure the work?
6. **Codify EP** — what Behavioral, Structural, and Relational principles govern the system?
7. **Measure EO** — establish Sustainability, Efficiency, and Scalability baselines.
8. **Observe EA** — monitor Trace, Quality, and Efficiency signals. Run Blame Diagnostic on failures.

### For Diagnosing a Failing Agent System

Use the Blame Diagnostic:

```
Failure observed in EA
        │
        ▼
    EP → Is a principle missing, contradictory, or too verbose?
        │
        ▼
    EI → Is input ambiguous, missing context, or lacking feedback?
        │
        ▼
    EOP → Are steps too large? Missing verification? No recovery?
        │
        ▼
    EOE → Are hooks misconfigured? Permissions too lax? Budget exceeded?
        │
        ▼
    EOT → Are tools returning errors? Descriptions misleading? Too many tools?
        │
        ▼
    EU → Is this a structural model limitation (LT-1 through LT-8)?
```

The first component in the chain that explains the failure is the root cause. Fix that component — do not compensate downstream.

### For Evaluating an Agent System

The controlled experiment:

```
Control:     Fixed EI → Current EP/EOE/EOT/EOP → Baseline EO
Experiment:  Fixed EI → Modified [one variable]  → New EO
Metric:      EO delta across S × E × Sc dimensions
```

Run 20-50 real failure test cases. Track 3 metrics per agent per task: token cost (E), duration (E), quality gate pass rate (S). Compare over time. This is the evaluation pipeline that converts chaotic development into compounding improvement.

---

## Sources

This document synthesizes:
- LTC's 7-CS framework (`rules/agent-system.md`)
- LTC's Effective System Design methodology (`_genesis/templates/effective-system-design-template.md`)
- Deep research: 28 industry sources, Nov 2025–Apr 2026 (`inbox/research-harness-engineering-2026.md`)
- First-principles MECE derivation session, 2026-04-12

Primary sources: Anthropic Engineering (5), OpenAI Engineering (1), LangChain (3), GitHub (1), independent practitioners (10), analysis sites (8). Average source credibility: 84/100.

---

## Links

- [[agent-system]]
- [[effective-system-design-template]]
- [[enforcement-layers]]
- [[harness-engineering-research-2026]]
- [[ltc-effective-agent-principles-registry]]
- [[ltc-ues-versioning]]
