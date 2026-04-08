<!-- GOVERN workstream agent-facing copy. Human-readable version: _genesis/frameworks/ltc-effective-system-design-blueprint.md -->
# LTC General System

> Source of truth: ESD Framework (OPS_OE.6.1 templates/), 10 Ultimate Truths (BOOK-00), Spec-Gap-Analysis (OPS_OE.6.1 research/), Whiteboard Template (ClickUp)
> Distilled for agent and practitioner use. Load when designing or building any system.
> Last synced: 2026-03-18

---

## 1. Notation

| Abbreviation | Full Name |
|---|---|
| UT#N | Ultimate Truth #N (from the 10 Universal Truths framework) |
| EO | Effective Outcome (the desired state the EU aims to achieve) |
| EI | Effective Inputs (triggers, data, upstream resources entering the system) |
| UBS | Ultimate Blocking System (forces preventing desired outcome) |
| UDS | Ultimate Driving System (forces driving toward desired outcome) |
| EP | Effective Principles (rules governing correct, efficient, scalable operation) |
| EOP | Effective Operating Procedures |
| EOE | Effective Operating Environment (workspace configuration, permissions, limits) |
| EOT | Effective Operating Tools (instruments available during execution) |
| EU | Effective User (the Doer — solved for R and A roles per RACI) |
| EA | Effective Action (observable execution, emergent from all components) |
| ESD | Effective System Design (3-phase design methodology) |
| ELF | Effective Learning Framework (7-layer learning methodology) |
| VANA | Verb-Adverb-Noun-Adjective (requirements grammar) |
| RACI | Responsible, Accountable, Consulted, Informed |
| A.C. | Acceptance Criteria (binary, deterministic pass/fail) |
| MECE | Mutually Exclusive, Collectively Exhaustive |
| OE | Operational Excellence (Layer 2 — the systems that build systems) |
| UE | User Enablement (Layer 3 — the systems that serve users) |

---

## 2. Purpose & Foundation

This document is the canonical reference for designing and building any system within LTC. It distills the universal system model, force analysis, principle design, and boundary specification into a single loadable resource.

**When to load:** When designing or building a UE product, OE process, workflow, or agent team. This is the starting point for all system work.

**UT#1 — Every system has the same 8 components that produce an Outcome.**

The universal system formula:

```
EO = f(EI, EU, EA, EP, EOE, EOT, EOP)
```

7 arguments producing EO — 8 named components total.

Every system — regardless of domain, scale, or technology — is composed of these eight elements. If any component is missing or misconfigured, the EO degrades. There are no exceptions.

**Derisk-first principle applied to systems:** For every action at every level — per component, per task, per system: (1) identify and reduce failure risks first (release the brake), then (2) maximize value within remaining constraints (hit the gas). Skipping step 1 is among the most common failure modes for both humans and AI agents.

**Relationship to agent-system.md:** The AI Agent's 7-Component System (7-CS) in agent-system.md (see §5) is a specialization of this universal 8-component model. In the 7-CS: EU becomes "Agent" (the LLM — uncontrollable, only observe UBS/UDS), EA is emergent/observable-only (unlike human EA), EI becomes "Input" (what you feed the agent), and EO is the outcome rather than a configurable component — yielding 7 configurable components: EP, Input, EOP, EOE, EOT, Agent, EA.

---

## 3. The Universal System Model

From UT#1 and the system formula, every system is composed of eight components. The table below defines each, its role, and what happens when it is absent.

| Component | Definition | Role in System | What Happens When Missing |
|---|---|---|---|
| **EI (Effective Inputs)** | Triggers, data, and upstream resources entering the system | Feeds the EU with task-specific information; sets the ceiling for output quality | System never activates, or EU fills gaps with assumptions — producing wrong output |
| **EU (Effective User)** | Who performs the work (human or agent) | Executes the cognitive or physical work within the system | No execution occurs; the system is inert |
| **EA (Effective Action)** | The observable execution that emerges from all components interacting | Produces the EO; the diagnostic surface for system health | No observable work; nothing to measure or diagnose |
| **EO (Effective Outcome)** | The desired state the system aims to achieve | Defines success; every other component exists to produce this | No target — system operates without direction; no way to evaluate success or failure |
| **EP (Effective Principles)** | Rules governing correct, efficient, scalable operation | Constrain all components; prevent harm and ensure quality | Unconstrained operation — errors compound, quality is random, risk is unmanaged |
| **EOE (Effective Operating Environment)** | Workspace configuration, permissions, limits | Sets hard ceilings for EU and EOT; no component can exceed what EOE allows | No operating context; EU cannot access EOT, data, or workspace |
| **EOT (Effective Operating Tools)** | Instruments available during execution | Extend the EU's capabilities beyond what they can do alone | EU is limited to native capability; throughput and accuracy capped |
| **EOP (Effective Operating Procedures)** | Sequential gated steps with per-step RACI | Orchestrate the order, conditions, and gates for execution | Ad-hoc execution; no repeatability, no handoff points, no quality gates |

**Output vs Outcome:** Output is the concrete artifact a system produces (a report, a dataset, a decision). Outcome is the state change the system creates — the movement toward or away from the EO. Output is what you ship; Outcome is what matters.

**System vs Workstream:** A workstream is a system that operates as a concurrent sub-system within a parent system. Every workstream is a system; not every system is a workstream. The distinction is deployment context, not structure. Both have the same 8 components.

---

## 4. RACI — Who Does What

From ESD Phase 1 (§3.1): establish R (Responsible) and A (Accountable) BEFORE analyzing forces. The same system has different blockers depending on who is R vs A.

| Role | Actor | Perspective for UBS/UDS |
|---|---|---|
| **R (Responsible)** | Who does the work (e.g., AI Agent) | UBS(R): what blocks R from executing; UDS(R): what drives R to succeed |
| **A (Accountable)** | Who owns the outcome (e.g., Human Director) | UBS(A): what blocks A from ensuring quality; UDS(A): what drives A to ensure quality |
| **C (Consulted)** | Domain expert or upstream provider | Provides input before action |
| **I (Informed)** | Downstream consumer, team, logs | Receives outcome after action |

**When R = AI Agent:** Behavioral boundaries (Always/Ask/Never) become part of the RACI contract — what the Agent always does (safe actions, no approval needed), what requires Human Director approval (high-impact actions), and what is prohibited (hard stops, violation = immediate halt). These boundaries are a specialization of EP for the agent context (see agent-system.md §5, EP component card).

**UBS/UDS analysis must cover both perspectives:** UBS(R), UBS(A), UDS(R), UDS(A). A system designed only from R's perspective ignores A's blockers, and vice versa.

Per-step RACI refines system-level RACI in EOP — each step assigns R, A, C, I independently.

---

## 5. Force Analysis — UBS then UDS

> *UBS is analyzed first because derisk always precedes driving output (see agent-system.md §2, Principle 1). This inverts the ESD framework's section ordering (ESD §3.3 UDS before §3.4 UBS) but aligns with the operating principle that governs all LTC system design.*

**UT#2 — Every system has forces blocking it (UBS) and driving it (UDS).**

Forces are structural — they exist whether you identify them or not. Unidentified forces still degrade the system. Force analysis makes them visible so EP can address them.

### UBS — The Blocking System (derisk first)

The root system of forces preventing the EU from reaching the EO. Analyzed from both RACI perspectives:

- **UBS(R)** — what blocks the doer from executing (e.g., ambiguous input, missing tools, capability gaps)
- **UBS(A)** — what blocks the owner from ensuring quality (e.g., cognitive biases, lack of visibility, decision fatigue)

**Recursive notation:** Forces have internal structure. UBS contains sub-forces that either strengthen or weaken it:

- `UBS.UB` — what weakens the blocker (works IN the EU's favor). These are natural allies; EP should amplify them.
- `UBS.UD` — what strengthens the blocker (works AGAINST the EU). These are force multipliers for the blocker; EP must neutralize them.
- Recursion continues: `UBS.UB.UB`, `UBS.UD.UD`, etc. — deeper layers for complex systems.

### UDS — The Driving System (drive output second)

The root system of forces helping the EU reach the EO. Analyzed from both RACI perspectives:

- **UDS(R)** — what drives the doer to succeed (e.g., structured procedures, strong tools, clear input)
- **UDS(A)** — what drives the owner to ensure quality (e.g., domain expertise, strategic judgment, risk intuition)

**Recursive notation:**

- `UDS.UD` — what strengthens the driver (works IN the EU's favor). EP should leverage these.
- `UDS.UB` — what weakens the driver (works AGAINST the EU). These are the silent killers of momentum; EP must disable them.
- Recursion continues: `UDS.UD.UD`, `UDS.UB.UB`, etc.

**Why both sides have internal contradictions:** UBS has forces that weaken it (UBS.UB) — the blocker is not invincible. UDS has forces that weaken it (UDS.UB) — the driver is not guaranteed. Effective system design exploits both: amplify UBS.UB to crack the blocker, disable UDS.UB to protect the driver. EP is the mechanism for both.

**Core rule:** Disable UBS before amplifying UDS. A system that drives output into unmanaged blockers wastes energy. Remove the brake, then hit the gas.

---

## 6. Effective Principles (EP)

From ESD Phase 2 (§4.1): EP exist to disable specific UBS elements or enable specific UDS elements. They are the mechanism that translates force analysis into operational constraints.

**Every principle MUST trace to a force.** Format: `P[n](Pillar)(Role): [Principle] — Disables [UBS element] / Enables [UDS element]`. If a principle cannot be traced to a specific UBS or UDS element, it is noise — cut it.

**Role-tagged notation:**
- `P[n](S)(R)` — constrains the doer (e.g., "Agent must validate every output against schema")
- `P[n](E)(A)` — constrains the owner (e.g., "Director must review within 24 hours")
- `P[n](Sc)(both)` — constrains both roles

**Three pillars of effectiveness:**

| Pillar | Governs | Purpose |
|---|---|---|
| **Sustainability (S)** | Correct, safe, risk-managed operation | Prevents harm, data loss, compounding error. Addressed FIRST — always. |
| **Efficiency (E)** | Fast, lean, frugal operation | Saves time, tokens, cost, cognitive load. Addressed only after S is confirmed. |
| **Scalability (Sc)** | Repeatable, comparable, growth-capable operation | Enables increasing load, domains, complexity without redesign. Addressed only after E is confirmed. |

**Priority hierarchy when principles conflict: Sustainability > Efficiency > Scalability.** A fast system that is unsafe fails. A scalable system that is slow wastes resources at scale. Sustainability gates everything.

**DT#3 — The three pillars of effectiveness (Sustainability > Efficiency > Scalability) apply to ALL 6 work streams, not just the overall system.** Each work stream must independently satisfy S > E > Sc. A system that is sustainable at the top level but has an unsustainable work stream will degrade at that seam. Evaluate pillars per-work-stream, not only in aggregate.

---

## 7. System Boundaries — Input & Output

Progressive disclosure across four layers. Start with Minimum Viable Boundary at design time; add layers as the system matures.

### Minimum Viable Boundary (design time)

**Layer 1 — What Flows:** Five categories flow through ANY system boundary:

1. **Acceptance Criteria** — what "correct" means, bucketed by Sustainability, Efficiency, Scalability
2. **Signal / Data / Information** — the payload the system processes
3. **Physical Resources** — hardware, infrastructure, materials
4. **Human Resources** — people, roles, availability, expertise
5. **Financial Resources** — budget, token spend, API cost, compute

**Layer 2 — How It Flows Reliably:** Six contract fields define each boundary:

| Field | Purpose |
|---|---|
| **Source / Consumer** | Who sends (for input) / who receives (for output) |
| **Schema** | Data shape both sides agree on (JSON Schema, Pydantic model, or equivalent) |
| **Validation** | Rules the payload must satisfy (types, ranges, required fields) |
| **Error** | Behavior when the contract is violated or the source is unavailable |
| **SLA** | Availability and latency expectations |
| **Version** | Contract version; breaking changes require upstream/downstream notification |

**Integration chain:** Systems do not operate in isolation. Each system's output feeds the next system's input:

```
SYS-A OUTPUT --> SYS-B INPUT --> SYS-B OUTPUT --> SYS-C INPUT
```

Without schema-level contracts, each system is designed in isolation. When SYS-A changes its output format, SYS-B breaks silently. Contracts make integration failures loud and early.

### Pre-Build Boundary (prerequisites complete before build starts)

**Layer 3 — How You Verify:** Eval Spec per A.C. Every Acceptance Criterion must have an Eval Spec before building starts. Without automated proof, A.C.s are assertions without evidence.

Three eval types:

| Type | Grader | Best For |
|---|---|---|
| **Deterministic** | Script returns pass/fail | Schema validation, data format checks, Noun A.C.s |
| **Manual** | Human Director reviews with rubric | Subjective quality, UX feel, strategic judgment |
| **AI-Graded** | Second LLM evaluates against rubric | Natural language quality, reasoning checks at scale |

Each A.C. requires four fields: **Type** + **Dataset** + **Grader** + **Threshold**.

Critical sequence — violated at your peril:

```
Write A.C. --> Write Eval Spec --> Build Dataset --> Implement Grader --> Wire CI --> THEN build
```

**MECE applies:** One test per A.C., no gaps, no overlaps. Every A.C. is tested exactly once.

### Production-Ready Boundary (before scaling)

**Layer 4 — How It Fails Gracefully:** Per EOP step, define failure behavior:

| Field | Purpose |
|---|---|
| **Recovery** | What happens on failure (retry, fallback, fail-fast) |
| **Escalation** | Who gets notified and when (e.g., 2nd retry fails -> Human Director) |
| **Degradation** | Is partial output acceptable? How is it marked? (e.g., `[UNVERIFIED]` tags) |
| **Timeout** | Max retries, max wall-clock time before the step is abandoned |

Failure modes are structural — they exist whether you specify them or not. Unspecified failure modes produce silent, cascading failures. Specified failure modes produce loud, contained failures.

---

## 8. The ESD Methodology

ESD is a design methodology, not a document template. It defines HOW to translate learning into engineering requirements. Output documentation uses the System Wiki Template.

### Phase 1 — Problem Discovery

Reconstruct the EU's system from ELF output — before introducing any technology.

- **Who** is the EU? (User Persona + Anti-Persona)
- **What** is their EO? (Carried verbatim from ELF — do not rephrase)
- **What blocks** them? (UBS from both R and A perspectives)
- **What drives** them? (UDS from both R and A perspectives)

No solution language. Phase 1 describes the problem space only.

### Phase 2 — System Design

Define the conceptual solution space based on Phase 1 and ELF.

- **EP** (S/E/Sc) — each traced to a UBS or UDS element, role-tagged
- **EOE** — workspace configuration and constraints
- **EOT** — organized by 3 causal layers (Foundational -> Operational -> Enhancement)
- **Desirable Wrapper** (Iterations 1-2) — minimum viable EOT configuration addressing root-level UBS/UDS. Tests: "Will the EU want to use this?"
- **Effective Core** (Iterations 3-4) — full EOT configuration addressing all recursive UBS/UDS layers. Tests: "Does this actually solve the root cause?"
- **EOP** — sequential gated steps with per-step RACI, staged DERISK then OPTIMIZE

### Phase 3 — User's Requirements

Translate Phase 2 into deterministic engineering requirements using VANA grammar:

- **Verb** — atomic user action from EOP steps where EU = R
- **Adverb** — how the Verb must be performed, bucketed by S/E/Sc (SustainAdv, EffAdv, ScalAdv)
- **Noun** — the UE tool/system built, organized by EOT causal layers
- **Adjective** — qualities the Noun must possess, bucketed by S/E/Sc (SustainAdj, EffAdj, ScalAdj)

Every A.C. must be: Atomic, Binary, Deterministic, Pre-committed, Traceable.

**The flow:**

```
Learn (ELF) --> Design (ESD Phase 1+2) --> Requirements (Phase 3) --> Build --> Test
```

---

## 9. The Value Chain

Every organization operates through a value chain of six interdependent layers. Each layer enables the one above it — causal ordering, not arbitrary stacking.

| Layer | Name | Purpose |
|---|---|---|
| L0 | Strategic Alignment | Defines direction and priorities |
| L1 | People Development | Builds capability to execute |
| L2 | Operational Excellence | The systems that build systems (OE) |
| L3 | User Enablement | The systems that serve users (UE) |
| L4 | Customer Intimacy | Retains and grows relationships |
| L5 | Financial Performance | Measurable outcomes of all layers above |

**OE (L2) builds systems. UE (L3) serves users. Know where your system sits.** OE does not serve the end-user directly — it serves the builder. UE is built BY OE FOR a named User Persona.

**Causal ordering:** You cannot build UE systems (L3) without OE capability (L2). You cannot build OE capability without People Development (L1). You cannot develop people without Strategic Alignment (L0). Each layer enables the one above it; skip a layer and the chain breaks.

## Links

- [[AGENTS]]
- [[DESIGN]]
- [[SEQUENCE]]
- [[VALIDATE]]
- [[agent-system]]
- [[blocker]]
- [[documentation]]
- [[ltc-effective-system-design-blueprint]]
- [[methodology]]
- [[schema]]
- [[task]]
- [[workstream]]
