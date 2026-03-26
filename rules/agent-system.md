<!-- Zone 0 agent-facing copy. Human-readable version: _shared/frameworks/AGENT_SYSTEM.md -->
# LTC Agent System

> Source of truth: Doc-9 (OPS_OE.6.0 research/amt/), Session 0 & Session 1 (Notion ALIGN Wiki)
> Distilled for agent and practitioner use. Load when configuring or diagnosing an AI agent.
> Last synced: 2026-03-18

---

## 1. Notation

| Abbreviation | Full Name |
| ------------ | ---------------------------------------------------------------- |
| 7-CS | The Agent's 7-Component System |
| EP | Effective Principles |
| EOP | Effective Operating Procedures |
| EOE | Effective Operating Environment |
| EOT | Effective Operating Tools |
| EU | Effective User (the Doer — solved for R and A roles per RACI) |
| EA | Effective Action (observable execution, emergent from all components) |
| EO | Effective Outcome (the desired state the EU aims to achieve) |
| UBS | Ultimate Blocking System (forces preventing desired outcome) |
| UDS | Ultimate Driving System (forces driving toward desired outcome) |
| LT-N | LLM Truth #N (the 8 fundamental limits of LLM models) |
| UT#N | Ultimate Truth #N (from the 10 Universal Truths framework) |
| RACI | Responsible, Accountable, Consulted, Informed |
| A.C. | Acceptance Criteria (binary, deterministic) |

---

## 2. Purpose and Three Principles

**What this doc is:** Canonical reference for configuring an AI agent's 7-CS. Defines the 8 structural limits of LLM models, the two operators, and the 7 components that compensate for those limits. The Agent is the EU (Effective User) in this AI-centric system.
**When to load it:** When configuring, understanding, or diagnosing an AI agent.

### Principle 1: Brake Before Gas [DERISK]

For every action — per component, per task, per system — identify and reduce failure risks first (release the brake), then maximise output second (hit the gas). Grounded in UT#5 (Real-World Success = efficient and scalable management of risks). Skipping step 1 is the single most common failure mode for both humans and AI agents.

### Principle 2: Know the Physics [DERISK]

The 8 LLM Truths are structural constraints, not bugs. Every component in the 7-CS exists to compensate for at least one. Learn what cannot change so you stop trying to change it. Grounded in LT-1 through LT-8 — from transformer architecture, training objectives, and mathematical proofs.

### Principle 3: Two Operators, One System [OUTPUT]

The Human Director and the LLM Agent have complementary failure modes and complementary strengths. The Human's weaknesses are cognitive shortcuts (System 1); the Agent's weaknesses are the 8 LTs. Neither can compensate for their own blind spots, but each can compensate for the other's. The 7-CS integrates them.

### The System Formula

```
EO = f(EP, Input, EOP, EOE, EOT, Agent, EA)
```

The Human Director is not a component — they are the Accountable party who owns the outcome, provides judgment, and approves results.

For level-specific guidance on applying these principles (see Doc-9 §4.4, SFIA progression L1-L5).

---

## 3. The 8 LLM Fundamental Truths

Structural constraints baked into how LLMs work. Not patched away by the next model release. The other 6 components exist to compensate for these 8 limits.

> **Note on LT-2/3/4:** All three involve "the model struggles when there's too much" but differ in WHAT dimension: LT-2 = VOLUME of info loaded, LT-3 = NUMBER OF REASONING STEPS, LT-4 = PRECISION of retrieval from noisy context. Different bottlenecks, different compensations.

### LT-1 — Hallucination is structural
**Bottleneck:** Factual accuracy.
For any model, there exist prompts where P(hallucination) > 0. It predicts the most plausible next word, and plausible is not true. Five independent papers (2024-2025) prove this from different mathematical angles.
**Mechanism:** Diagonalization guarantees inputs where any computable predictor must fail. Undecidable queries create infinite failure sets.
**Compensated by:** EP (validation rules), EOT (fact-checking), Input (provide source material).

### LT-2 — Context compression is lossy
**Bottleneck:** Volume of information loaded.
The effective context window is much smaller than the nominal one. Information in the middle gets lost — "lost in the middle" is a geometric property of causal decoder architecture.
**Mechanism:** Positional under-training, encoding attenuation, and softmax crowding degrade retrieval as context grows.
**Compensated by:** EOE (context budget), Input (load only what is needed), EP (concise rules).

### LT-3 — Reasoning degrades on complex tasks
**Bottleneck:** Number of logical steps required.
A 3-step task works well; a 12-step task breaks down. At 90% per-step, 0.9^7 ~= 48% end-to-end. Errors become increasingly random at longer chains.
**Mechanism:** Likelihood-based training favors pattern completion over inference. Degrades as chain length increases beyond training distribution.
**Compensated by:** EOP (smaller steps with checkpoints), Input (decompose before sending), EOE (compute for extended thinking).

### LT-4 — Retrieval is fragile under token limits
**Bottleneck:** Precision in noisy context.
Different from LT-2 (total volume). LT-4 is the needle-in-a-haystack problem — even in a reasonable window, when information is messy, the model grabs something close enough instead of the exact fact.
**Mechanism:** Attention-based retrieval suffers from semantic drift. Accuracy degrades with distractor density and decreasing needle-to-context ratio.
**Compensated by:** Input (label and structure clearly), EOT (dedicated search), EOE (reduce noise).

### LT-5 — Prediction optimises plausibility, not truth
**Bottleneck:** Truth vs sounding right.
Trained to predict the most likely next word. Optimises for "sounds right" not "is right." Root cause of LT-1.
**Mechanism:** Next-token prediction produces statistically likely continuations with no native truth-detection mechanism.
**Compensated by:** EP (require evidence/citations), EOT (external verification), Human judgment.

### LT-6 — No persistent memory across sessions
**Bottleneck:** Memory between sessions.
Every new conversation starts blank. Zero memory of yesterday's work. Everything it knows comes from what you load into this session.
**Mechanism:** All state must be externally provided via Input, EP, or EOT. Nothing carries between sessions without external storage.
**Compensated by:** Input (load session state/history), EOT (memory vault systems), EP (rules for what to load at session start).

### LT-7 — Cost scales with token count
**Bottleneck:** Budget.
More words in/out = more money. Attention scales superlinearly. Wasted tokens waste budget AND worsen LT-2.
**Mechanism:** Billing scales linearly with tokens; attention scales superlinearly. Every unnecessary token is wasted resource.
**Compensated by:** Input (lean context), EP (concise rules), EOE (budget limits).

### LT-8 — Alignment is approximate
**Bottleneck:** Rule compliance under pressure.
Safety training makes the model mostly behave, but "mostly" is not "always." It can drift, game criteria, or find loopholes. Probabilistic, not deterministic.
**Mechanism:** RLHF/Constitutional AI shape behavior probabilistically. May optimize for proxy metrics (length, agreeableness) over the desired outcome.
**Compensated by:** EP (behavioral boundaries), EOP (verification gates), Human oversight.

### Quick-Reference Summary Table

| # | Truth | Bottleneck | Compensated by |
| ---- | ------------------------------------------- | ------------------------------ | ------------------------------ |
| LT-1 | Hallucination is structural | Factual accuracy | EP, EOT, Input |
| LT-2 | Context compression is lossy | Volume of info loaded | EOE, Input, EP |
| LT-3 | Reasoning degrades on complex tasks | Number of logical steps | EOP, Input, EOE |
| LT-4 | Retrieval is fragile under token limits | Precision in noisy context | Input, EOT, EOE |
| LT-5 | Prediction optimises plausibility, not truth | Truth vs sounding right | EP, EOT, Human judgment |
| LT-6 | No persistent memory across sessions | Memory between sessions | Input, EOT, EP |
| LT-7 | Cost scales with token count | Budget | Input, EP, EOE |
| LT-8 | Alignment is approximate | Rule compliance under pressure | EP, EOP, Human oversight |

## 4. The Two Operators

Every component is shaped by two actors with fundamentally different failure modes.

### Human Director (Accountable)

Owns decision quality, provides domain judgment, approves outputs. UBS analyzed first (derisk), then UDS (drive).

**System 1 UBS — Cognitive Shortcuts (Bio-Efficient Forces)**

| Bias | Mechanism | Design Threat |
| ---------------------------- | ------------------------------------------------------------ | -------------------------------------------------------------------- |
| Availability Heuristic | Judges frequency/likelihood by ease of recall | Overweights recent or vivid failures; ignores base rates |
| Representativeness Heuristic | Matches patterns to prototypes, underweighting statistics | Stereotypes solutions; skips edge cases |
| Anchoring | Over-relies on first piece of information encountered | Initial estimates lock in; subsequent evidence under-adjusts |
| Affect Heuristic | Gut feeling substitutes for analysis | Accepts "feels right" outputs; rejects uncomfortable correct ones |
| Confirmation Bias | Seeks information that confirms existing beliefs | Ignores disconfirming evidence from Agent outputs |
| Self-Serving Attribution | Credits success to self; externalizes failure | Attributes Agent errors to Agent even when Input was the cause |

**Governing meta-force:** Bio-Efficient Forces — the brain conserves energy by defaulting to heuristics. Time pressure, fatigue, and cognitive load amplify System 1.

**System 2 UDS — Deliberate Strengths**

| Strength | Mechanism |
| ------------------ | ---------------------------------------------------------------------- |
| Domain expertise | Pattern recognition grounded in years of contextual experience |
| Strategic judgment | Evaluating trade-offs that require values, not just data |
| Risk intuition | Sensing danger from incomplete signals (when calibrated by experience) |
| Ethical oversight | Moral reasoning that algorithms cannot own |
| Creative direction | Defining what SHOULD exist, not just what COULD exist |

### LLM Agent (Responsible)

Executes cognitive work. Weaknesses: the 8 LLM Fundamental Truths (see §3). Strengths are architectural:

**Architectural Strengths**

| Strength | Mechanism |
| ---------------------------------- | ----------------------------------------------------------------------------------------------------------------- |
| Orchestrated parallelism | Evaluate multiple hypotheses across parallel calls; no fatigue bottleneck |
| Exhaustive analysis within context | No bio-efficiency pressure to "wrap it up" — examines every angle if instructed |
| No ego investment | Analyzes failure without defensive distortion (though sycophancy tendencies exist) |
| High recall within context window | Information broadly accessible without availability heuristic, subject to positional bias |
| Programmatic enforcement | Rules loaded via EP applied consistently, not selectively |
| Consistent instruction following | Loaded procedures (EOP) execute the same way every time, within alignment bounds |

### Shared Forces

- **Compute-Efficient Forces (Agent)** mirror **Bio-Efficient Forces (Human)** — both default to shortcuts under pressure. Agent skips deep reasoning unless prompted; Human skips analysis when tired.
- **Orchestration System Belief (Agent)** mirrors **Support System Belief (Human)** — both perform better in structured frameworks. The 7-CS itself is one such structure.

## 5. The 7-Component System

### Dependency Graph

```
                    ┌─────────┐
                    │   EP    │ ← Constitution (constrains ALL below)
                    └────┬────┘
                         │ governs
              ┌──────────┼──────────┐
              ▼          ▼          ▼
         ┌─────────┐ ┌─────────┐   │
         │  Input  │ │   EOP   │   │
         └────┬────┘ └────┬────┘   │
              │ feeds     │ orchestrates
              ▼          ▼          │
         ┌─────────────────────┐   │
         │     AGENT           │◄──┘ (EP constrains Agent directly)
         │  (executes within   │
         │   EOE + EOT)        │
         └────────┬────────────┘
                  │ produces
                  ▼
         ┌──────────────┐
         │      EA       │ ← Emergent (observe, do not configure)
         └──────┬───────┘
                │ yields
                ▼
         ┌──────────────┐
         │      EO       │
         └──────┬───────┘
                │ feedback
                ▼
    ┌───────────────────────┐
    │  Informs future:      │
    │  Input (next task)    │
    │  EP (rule revision)   │
    │  EOP (process update) │
    └───────────────────────┘

Lateral dependencies:
  EOE ──sets hard ceilings for──→ Agent, EOT
  EOT ──extend capabilities of──→ Agent
  Agent ──operates within──→ EOE
```

### Summary Table

| # | Component | One-liner | Concrete AI Examples | Priority |
| --- | --------------- | ----------------------------------------------- | ---------------------------------------------- | -------- |
| 1 | **EP** | Persistent rules — always active, all tasks | CLAUDE.md, .cursorrules, GEMINI.md | 1st |
| 2 | **Input** | What you provide for this task | Prompt, context files, RAG retrieval, memory | 2nd |
| 3 | **EOP** | Step-by-step procedures, loaded on demand | SKILL.md, .mdc files, Code Actions | 3rd |
| 4 | **EOE** | Workspace — config, permissions, limits | IDE, terminal, context window, hooks, sandbox | 4th |
| 5 | **EOT** | Instruments the agent can call | MCP servers, APIs, CLI, web search | 5th |
| 6 | **Agent** | The AI model — capabilities and limits | Claude Opus/Sonnet, GPT-4o, Gemini | 6th |
| 7 | **EA** | Observable execution (emergent — diagnose only) | Reasoning chains, tool calls, file edits | 7th |

### Component Cards

#### Card 1: EP — Effective Principles
**Definition:** Persistent rules always active across all tasks — the constitution of the system.
**System role:** Constrains all other components. No component can violate EP.
**Compensates for:** LT-1 (validation rules), LT-5 (truth requirements), LT-8 (behavioral boundaries).
**Guards against:** Confirmation Bias, Self-Serving Attribution, Anchoring.
**Derisk:**
- Too verbose — consumes context budget (LT-7), critical rules drowned in noise
- Contradictory — Agent defaults to plausible interpretation (LT-5)
- Missing constraints — Agent operates without safety bounds (LT-8)
- Not enforced — Agent ignores rules under complex task pressure (LT-3)
**Drive output:**
- Lean, non-redundant rules that fit within token budget
- Clear priority hierarchy when rules conflict
- Principles traced to specific UBS they disable or UDS they enable
- Rules that amplify Agent strengths (e.g., structured output leverages programmatic enforcement)

> **Always/Ask/Never pattern:** When configuring EP, define behavioral boundaries: what the agent always does (safe actions, no approval needed), what requires Human Director approval (high-impact actions), and what is prohibited (hard stops, violation = immediate halt).

#### Card 2: Input
**Definition:** Task-specific information provided for this particular task — prompt, context, data, constraints.
**System role:** Feeds the Agent. Quality of Input sets the ceiling for quality of Output.
**Compensates for:** LT-6 (provides session state), LT-2 (structured Input resists compression loss), LT-4 (precise Input reduces retrieval burden).
**Guards against:** Anchoring, Availability Heuristic.
**Derisk:**
- Too large — exceeds effective context (LT-2)
- Ambiguous — Agent fills gaps with plausible but wrong assumptions (LT-1, LT-5)
- Missing critical context — Agent cannot compensate (LT-6)
- Contradicts EP — Agent resolves conflict incorrectly
**Drive output:**
- Structured, labeled sections the Agent can reference precisely
- Explicit statement of what is NOT in scope
- Relevant context only — every unnecessary token degrades signal-to-noise (LT-7)
- State from previous sessions provided as Input (compensates for LT-6)

#### Card 3: EOP — Effective Operating Procedures
**Definition:** Reusable step-by-step procedures loaded on demand — the playbook.
**System role:** Orchestrates the Agent by decomposing complex tasks into manageable steps with defined inputs, outputs, and gates.
**Compensates for:** LT-3 (breaks reasoning into steps), LT-1 (verification gates), LT-8 (keeps Agent on track).
**Guards against:** Affect Heuristic, Confirmation Bias.
**Derisk:**
- Too rigid — cannot adapt to unexpected variations
- Too vague — Agent interprets freely (LT-1, LT-5)
- Steps too large — exceeds reliable reasoning capacity (LT-3)
- Missing validation gates — errors compound undetected
**Drive output:**
- Each step has explicit input requirements, expected output, and binary A.C.
- Steps sized to fit within Agent's reliable reasoning window
- Validation gates between steps
- Modularity — EOPs compose from reusable sub-procedures

#### Card 4: EOE — Effective Operating Environment
**Definition:** Workspace configuration — IDE, context window, sandbox, permissions, compute limits.
**System role:** Sets hard ceilings for Agent and EOT. No component can exceed what EOE allows.
**Compensates for:** LT-2 (determines available context), LT-7 (sets compute budget), LT-4 (determines accessible information).
**Guards against:** Anchoring (forces realistic scoping).
**Derisk:**
- Too restrictive — Agent cannot access needed tools or information
- Too permissive — Agent makes destructive changes without safety nets
- Context window misunderstood — Input + EP + EOP exceed effective capacity
- Compute insufficient — Agent shortcuts reasoning (amplifies LT-3)
**Drive output:**
- Context budget explicitly allocated: EP X tokens, Input Y, EOP Z, reasoning the remainder
- Sandboxing that prevents destructive operations while allowing productive ones
- EOE matches task complexity
- Monitoring and logging enabled for feedback loop

#### Card 5: EOT — Effective Operating Tools
**Definition:** Instruments callable by the Agent — MCP servers, APIs, CLI, databases, search, code interpreters.
**System role:** Extends Agent capabilities beyond the model alone. Force multipliers, not governors.
**Compensates for:** LT-6 (external storage/retrieval), LT-1 (fact-checking), LT-3 (formal reasoning, code execution), LT-4 (structured search).
**Guards against:** Availability Heuristic, Representativeness Heuristic.
**Derisk:**
- Unavailable at runtime — workflow halts
- Returns wrong data — Agent trusts it, compounding hallucination (LT-1)
- Too many tools — Agent confused, selects poorly (LT-3)
- Output exceeds context budget — pushes out critical information (LT-2, LT-7)
**Drive output:**
- Each tool has a clear purpose statement and expected output format
- Fallback strategies for tool failures
- Tool output validated before feeding into reasoning chain
- Minimal tool set for the task

#### Card 6: Agent
**Definition:** The AI model — capabilities, training, architecture, version. Configured but not built by the user.
**System role:** Executes cognitive work within constraints set by all other components. The 8 LTs are why the other 6 exist.
**Constrained by:** All 8 LTs constrain the Agent directly.
**Guards against:** All of System 1 — replaces human as Doer, removing psychological biases (but introduces 8 architectural failure modes).
**Derisk:**
- Wrong model — underpowered struggles (LT-3); overpowered wastes resources (LT-7)
- Outside training domain — hallucination spikes (LT-1)
- Extended context treated as reliable — compression loss unaccounted (LT-2)
- Alignment assumed perfect — dangerous in high-stakes domains (LT-8)
**Drive output:**
- Model matched to task complexity and domain
- Strengths leveraged: orchestrated parallelism, exhaustive coverage, ego-free reflection
- Clear separation: Agent decisions (tactical) vs Director decisions (strategic)
- Reasoning monitored for drift indicators

#### Card 7: EA — Effective Action (Emergent Output)
**Definition:** The observable execution from all components interacting. Not configured — it emerges.
**System role:** Produces the EO. When EA fails, root cause is in the other 6 components.
**Compensates for:** N/A (emergent). **Guards against:** N/A (diagnostic only).
**Derisk:**
- Not observed — errors compound silently, discovered only at the end
- Misdiagnosed — blame on EA instead of tracing to root component
- Over-monitored — excessive logging consumes context budget (LT-7)
- Symptoms treated instead of root causes — failures recur
**Drive output:**
- Trace failures back to the 6 input components via the blame diagnostic: EP, Input, EOP, EOE, EOT, Agent (in that order)
- Log key decision points for post-mortem analysis
- Design monitoring that catches failures before they reach EO
