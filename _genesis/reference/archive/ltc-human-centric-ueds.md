---
version: "1.0"
last_updated: 2026-03-29
owner: "Long Nguyen"
---

# Document 2: Human-Centric UEDS — Complete Architecture & Weakness Analysis

_Phase B. Capture Facts & Data | Subject: AI-Centric OE System Design_
_Source: UEDS Training Materials (COE EFF Ch.9), 10 Ultimate Truths Codex (Doc 1), Advanced Effective Learning System, Effective System Design Framework, LTC Company Handbook_
_Date: 2026-03-01 | Version: 1.0_
_Purpose: Reconstruct the full human-centric UEDS architecture, then systematically identify every point where human weakness is the bottleneck — creating the gap map that Document 3 (AI-Centric Translation) will fill._

---

## How to Read This File

This document has 5 parts:

1. **Part 1: UEDS Architecture Overview** — The full system reconstructed from source materials with diagrams.
2. **Part 2: The Dual-System Structure** — Developer's System vs. User's System explained.
3. **Part 3: Full Stage-by-Stage Reconstruction** — Every Development Phase, Stage, Step, and Sub-step with all columns populated.
4. **Part 4: Human Weakness Analysis** — For every stage/step, which human UBS weaknesses are the bottleneck, scored by Weakness Exposure.
5. **Part 5: Gap Map for AI-Centric Translation** — Summary of where human limitations create the most friction, prioritized for Doc 3.

Cross-references to Doc 1 use `UT#n` or `DT#n`. UEDS stages use `Phase.Stage.Step` notation (e.g., `A.1.1`).

---

## Part 1: UEDS Architecture Overview

### 1.1 What is the UEDS?

The **User Enablement Delivery System (UEDS)** is the human-centric OE (Operational Excellence) meta-system designed by LTC's COE EFF. It is the concrete implementation of all 10 Ultimate Truths + 2 Derived Truths (Doc 1) as a single, integrated process for building any User Enablement (UE) system.

**Core Identity:**

```
UEDS = The system that builds UE systems
     = OE (Layer 2 in the Value Chain) made concrete
     = UT#9 (6 organizational workstreams) formalized into a repeatable process
     = UT#10 (concurrent workstreams) organized into navigable containers
```

**What it produces:** A domain-specific UE system (e.g., Investment Research Agent, Recruitment Pipeline, Monthly Reporting Dashboard) that enables a specific User to achieve a specific EO.

**What it requires:** Human developers (the "Developer") working through structured phases, stages, and steps — with all activities evaluated through the 3 Pillars (S/E/Sc per DT#1) and the 4 Evaluation Lenses (Derisking, Driving Output, Efficiency, Scalability).

### 1.2 UEDS Root System

```
┌─────────────────────────────────────────────────────────────────────┐
│                        UEDS ROOT SYSTEM                             │
│                                                                     │
│   UBS (Root Blocker):                                               │
│   "Lack of true understanding of Execution Risks"                   │
│    ← Traces to UT#5 (UBS > UDS for valuable outcomes)               │
│    ← Traces to UT#6 (psychological biases) + UT#8 (org biases)      │
│                                                                     │
│   UDS (Root Driver):                                                │
│   "Effective Utilization of Current & Future Resources"              │
│    ← Traces to UT#4 (optimal value creation)                        │
│    ← Traces to UT#5 (but only AFTER risk is managed)                │
│                                                                     │
│   EP (Principles): Best management of current & future resources    │
│    ← Traces to UT#2 (EP derived from UBS/UDS analysis)              │
│                                                                     │
│   EOE: Risk Management culture + Agile culture          │
│   EOT: Risk Mgmt + Resource Mgmt + Work Mgmt tools            │
│                                                                     │
│   EOP (Actions):                                                    │
│    i. Delivery                                                      │
│    ii. Reflection & Learn to Improve                                │
│    iii. Repeat (Align → Plan → Delivery → Reflection & Learn)       │
└─────────────────────────────────────────────────────────────────────┘
```

### 1.3 The 4 Evaluation Lenses

Every cell in the UEDS table is evaluated through 4 lenses. These lenses map directly to the UTs:

```
┌──────────────────────────────────────────────────────────────────┐
│                    4 EVALUATION LENSES                            │
│                                                                  │
│  1. DERISKING        ← disables UBS (UT#2, UT#5)                │
│     "What failure risks does this step manage?"                  │
│                                                                  │
│  2. DRIVING OUTPUT   ← enables UDS (UT#2, UT#4)                 │
│     "What value does this step create?"                          │
│                                                                  │
│  3. EFFICIENCY       ← Pillar 2 (DT#1)                          │
│     "Is this the leanest way to achieve this?"                   │
│                                                                  │
│  4. SCALABILITY      ← Pillar 3 (DT#1)                          │
│     "Does this work for growth without proportional cost?"       │
│                                                                  │
│  PRIORITY ORDER:                                                 │
│  Derisking → Driving Output → Efficiency → Scalability           │
│  (mirrors S → E → Sc from UT#5 / DT#1)                          │
└──────────────────────────────────────────────────────────────────┘
```

### 1.4 The 4 Iterations

The UEDS cycles through 4 progressively deeper iterations. Each iteration adds depth (per UT#5's 3 Pillars):

```
ITERATION PROGRESSION (causal — cannot skip):

┌─────────────────┐    ┌─────────────────┐    ┌─────────────────┐    ┌─────────────────┐
│  ITERATION 1    │    │  ITERATION 2    │    │  ITERATION 3    │    │  ITERATION 4    │
│  CONCEPTUAL     │───→│  PROTOTYPES     │───→│  MVE            │───→│  LEADERSHIP     │
│                 │    │                 │    │  (Min. Viable   │    │                 │
│  Desirable      │    │  Desirable      │    │  Enablement)    │    │  Effective      │
│  Wrapper        │    │  Wrapper        │    │  Effective Core │    │  Core           │
│                 │    │                 │    │                 │    │                 │
│  Test: "Does    │    │  Test: "Can it  │    │  Test: "Does it │    │  Test: "Does it │
│  the User want  │    │  be built       │    │  solve root     │    │  scale and      │
│  this?"         │    │  reliably?"     │    │  cause?"         │    │  endure?"       │
│                 │    │                 │    │                 │    │                 │
│  Gate:          │    │  Gate:          │    │  Gate:          │    │  Gate:          │
│  S A.C.s pass   │    │  S + some E     │    │  S + E + some   │    │  All A.C.s      │
│                 │    │  A.C.s pass     │    │  Sc A.C.s pass  │    │  pass           │
└─────────────────┘    └─────────────────┘    └─────────────────┘    └─────────────────┘

Each iteration runs through ALL 5 Development Phases (A → E).
Each iteration goes DEEPER into UBS/UDS recursive layers.
Iteration 1–2 = Desirable Wrapper (surface UBS/UDS).
Iteration 3–4 = Effective Core (recursive UBS.UB.UB, UDS.UD.UD depth).
```

---

## Part 2: The Dual-System Structure

### 2.1 Developer's System vs. User's System

The UEDS is unique because it explicitly models TWO parallel systems within a single framework. This is a direct application of UT#1 (every action is within a system) applied recursively: the Developer is a User of the UEDS, and the end-User is a User of what the Developer builds.

```
┌────────────────────────────────────────────────────────────────────────────┐
│                          UEDS DUAL-SYSTEM VIEW                             │
│                                                                            │
│  LEFT SIDE: DEVELOPER'S SYSTEM                                             │
│  (User Enablement DELIVERY System)                                         │
│  ┌──────────────────────────────────────────┐                              │
│  │  Who: The Developer/Builder               │                              │
│  │  What: Plans, designs, builds the UE      │                              │
│  │  Columns: Development Phase, Pillar,      │                              │
│  │           Stage, Step, Sub-step,          │                              │
│  │           Desired Outcomes,               │                              │
│  │           EP, EOE, EOT, EOP,    │                              │
│  │           RACI (DOs + DON'Ts × 4 roles)   │                              │
│  │  Output: A designed & built UE system     │                              │
│  └──────────────────────────────────────────┘                              │
│                         │                                                  │
│                         │ produces                                         │
│                         ▼                                                  │
│  RIGHT SIDE: USER'S SYSTEM                                                 │
│  (User Enablement System)                                                  │
│  ┌──────────────────────────────────────────┐                              │
│  │  Who: The End-User                        │                              │
│  │  What: Uses the UE to achieve their EO   │                              │
│  │  Columns: Delivery Phase/Iteration,       │                              │
│  │           Pillar, Desired Outcomes,        │                              │
│  │           Principles (User Reqs),          │                              │
│  │           Environment (User's Env),        │                              │
│  │           Tools (User's Tools),            │                              │
│  │           Process (User's SOP),            │                              │
│  │           Action (User's Actions),         │                              │
│  │           Important Notes                  │                              │
│  │  Output: User achieves their EO          │                              │
│  └──────────────────────────────────────────┘                              │
│                                                                            │
│  BRIDGE (Column 18): Implementation handoff points                         │
│  Feedback loop: User's System outcomes → Developer's System alignment      │
└────────────────────────────────────────────────────────────────────────────┘
```

### 2.2 Column Structure (29 Columns)

**Developer's System — Columns 0–17:**

| Col | Name | Purpose | Maps to UT |
|-----|------|---------|-----------|
| 0 | Development Phase | Which of 5 phases (A–E) | UT#10 (phases as workstream containers) |
| 1 | Pillar of Effectiveness | S, E, or Sc focus | DT#1 |
| 2 | Stage | High-level stage within phase | UT#9 (org workstream structure) |
| 3 | Step | Specific step within stage | UT#9 |
| 4 | Sub-steps | Granular actions | UT#9 |
| 5 | Desired Outcomes | What success looks like | UT#4/UT#5 |
| 6 | Principles (EP) | Governing rules (×4 lenses) | UT#2 |
| 7 | Environment (EOE) | Required conditions (×4 lenses) | UT#1 comp.6 |
| 8 | Tools (EOT) | Required instruments (×4 lenses) | UT#1 comp.5 |
| 9 | Process (EOP) | How to execute (×4 lenses) | UT#1 comp.3 |
| 10 | Responsible DOs | What the Doer MUST do | UT#1 comp.2 |
| 11 | Responsible DON'Ts | What the Doer must NOT do | UT#5 (risk mgmt) |
| 12 | Accountable DOs | What the Owner MUST ensure | UT#9 |
| 13 | Accountable DON'Ts | What the Owner must NOT do | UT#5 |
| 14 | Consulted DOs | Who to ask and what | UT#8 (collective reasoning) |
| 15 | Consulted DON'Ts | Who NOT to ask | UT#8 (avoid shadow systems) |
| 16 | Informed DOs | Who to tell | UT#8 |
| 17 | Important Notes | Developer-side notes | — |

**User's System — Columns 19–28:**

| Col | Name | Purpose | Maps to UT |
|-----|------|---------|-----------|
| 19 | Delivery Phase/Iteration | Which iteration (1–4) + phase label | UT#10 |
| 20 | Pillar of Effectiveness | S, E, or Sc for the User | DT#1 |
| 21 | Desired Outcomes | What the User should achieve | UT#4/UT#5 |
| 22 | Principles (User Reqs) | Requirements the User expects | UT#3 (V-A-N-A) |
| 23 | Environment (User's Env) | Conditions the User needs | UT#1 |
| 24 | Tools (User's Tools) | What the User uses | UT#1 |
| 25 | Process (User's SOP) | How the User operates | UT#1 |
| 26 | Action (User's Actions) | What the User does | UT#1 |
| 27 | Important Notes | User-side guidance | — |

### 2.3 The RACI+ Innovation

The UEDS extends standard RACI with explicit DON'Ts for every role. This is a direct application of UT#5 (risk management) — it's not enough to define what each role does; you must define what each role must NOT do.

```
STANDARD RACI:           UEDS RACI+:
R → DOs                  R → DOs + DON'Ts
A → DOs                  A → DOs + DON'Ts
C → DOs                  C → DOs + DON'Ts
I → DOs                  I → DOs + DON'Ts

Why DON'Ts matter (UT#5):
  Without DON'Ts, scope creep is a RISK.
  Without DON'Ts, role overlap is a RISK.
  Without DON'Ts, the shadow system (UT#8) fills the gap.
```

---

## Part 3: Full Stage-by-Stage Reconstruction

### 3.0 Uniform Column Structure

Every Phase and Stage below uses the same column set for MECE consistency. Where the UEDS source PDF left cells empty (marked `•` with no content), content has been populated from first-principles reasoning based on the 10 UTs. Populated cells are marked `[populated]`.

**Standard columns per Phase/Stage:**

| Column | What it captures |
|--------|-----------------|
| Development Phase | Phase label (A–E) |
| Pillar of Effectiveness | S, E, or Sc (per DT#1) |
| Stage / Step / Sub-steps | Hierarchical decomposition |
| Desired Outcome | What success looks like for this step |
| EP — Derisking | Principles that disable UBS for this step |
| EP — Driving Output | Principles that enable UDS for this step |
| EP — Efficiency | Principles for optimal output at current resources |
| EP — Scalability | Principles for growth without proportional cost |
| EOE — Derisking | Environment conditions that reduce failure risk |
| EOE — Driving Output | Environment conditions that maximize value creation |
| EOE — Efficiency | Environment conditions for lean operation |
| EOE — Scalability | Environment conditions for replicability |
| EOT — Derisking | Tools that reduce failure risk |
| EOT — Driving Output | Tools that enable value creation |
| EOT — Efficiency | Tools that minimize waste |
| EOT — Scalability | Tools that scale |
| EOP — Process | Step-by-step procedure |
| RACI+ | R (DOs/DON'Ts), A (DOs/DON'Ts), C (DOs/DON'Ts), I (DOs/DON'Ts) |
| User's System Mirror | Corresponding User-side columns (Delivery Phase, Pillar, Desired Outcome, User Reqs, User Env, User Tools, User SOP, User Actions) |

### 3.1 The 5 Development Phases

```
DEVELOPMENT PHASES (containers for workstreams per UT#10):

┌─────────────────────────────────────────────────────────────────────────────┐
│                                                                             │
│  PHASE A ─── ALIGNMENT OF SUCCESS DEFINITION                                │
│  │           Primarily: WS1 (Alignment) + WS2 (Risk Mgmt)                  │
│  │           Pillar: SUSTAINABLE                                            │
│  │           Output: Agreed definition of success                           │
│  │                                                                          │
│  ▼                                                                          │
│  PHASE B ─── FINDING THE CONDITIONS TO GENERATE OUTCOMES                    │
│  │           Primarily: WS3 (Learning) + WS2 (Risk Mgmt)                   │
│  │           Pillar: SUSTAINABLE → EFFICIENT                                │
│  │           Output: Premises and conditions identified                     │
│  │                                                                          │
│  ▼                                                                          │
│  PHASE C ─── GENERATE POSSIBLE OUTCOMES                                     │
│  │           Primarily: WS4 (Thinking) + WS2 (Risk Mgmt)                   │
│  │           Pillar: EFFICIENT                                              │
│  │           Output: Set of possible outcomes with feasibility assessment   │
│  │                                                                          │
│  ▼                                                                          │
│  PHASE D ─── PRIORITIZE & CHOOSE OUTCOMES TO EXECUTE                        │
│  │           Primarily: WS5 (Decision) + WS2 (Risk Mgmt)                   │
│  │           Pillar: EFFICIENT → SCALABLE                                   │
│  │           Output: Prioritized execution plan                             │
│  │                                                                          │
│  ▼                                                                          │
│  PHASE E ─── DESIGN & DELIVER                                               │
│              Primarily: WS6 (Execution) + WS2 (Risk Mgmt) + all others     │
│              Pillar: All (S → E → Sc across iterations)                     │
│              Output: Working UE system, iterated and improved               │
│                                                                             │
│  ◄──────── FEEDBACK LOOP: Phase E → Phase A (continuous) ──────────────────►│
│                                                                             │
└─────────────────────────────────────────────────────────────────────────────┘
```

---

### 3.2 Phase A — Alignment of Success Definition

**Phase Purpose:** Define what success looks like before any building begins. This is the most critical derisking step — misaligned success definition is the root cause of wasted effort.

**UT Traceability:** UT#5 (risk mgmt primary), UT#7.WS1 (Alignment), UT#9.WS1 (Org Alignment)

| Column | Content |
|--------|---------|
| **Development Phase** | A. Alignment of Success Definition |
| **Pillar** | SUSTAINABLE (i.e., minimal failure risks) |
| **Stage** | Definition of Success for the Desired Outcomes |
| **Desired Outcome** | Agreed, explicit, testable definition of what "success" means — expressed using V-A-N-A grammar (UT#3) with binary A.C.s |
| **EP — Derisking** | Define what failure looks like FIRST, then success; validate against known UBS failure modes; require binary A.C.s for every success element [populated] |
| **EP — Driving Output** | Success must be measurable and traceable to the EO; every definition must answer "how does the User know they succeeded?" |
| **EP — Efficiency** | Minimum viable definition — define only what is testable at this iteration; defer refinements to later iterations |
| **EP — Scalability** | Definition must work across iterations 1–4 without rewriting; use V-A-N-A grammar so it decomposes naturally as scope grows |
| **EOE — Derisking** | Psychologically safe for dissent (UT#6 UBS.UD.UB: support system belief); no time pressure to "just start building" [populated] |
| **EOE — Driving Output** | All stakeholders present and available; decision-making authority in the room [populated] |
| **EOE — Efficiency** | Single focused session (not spread across weeks); pre-read materials distributed in advance [populated] |
| **EOE — Scalability** | Documented alignment process reusable for next subject/domain; standardized templates [populated] |
| **EOT — Derisking** | V-A-N-A grammar template (UT#3); A.C. validation checklist; failure-mode pre-mortem template [populated] |
| **EOT — Driving Output** | Stakeholder mapping tool; EO articulation template; requirements traceability matrix [populated] |
| **EOT — Efficiency** | Pre-built alignment questionnaire; single-page success definition template [populated] |
| **EOT — Scalability** | Reusable alignment template library; version-controlled definition docs [populated] |
| **EOP** | (1) Stakeholders articulate EO in their own words → (2) Developer translates to V-A-N-A → (3) Developer proposes binary A.C.s → (4) Stakeholders validate each A.C. → (5) Pre-mortem: "What would make this fail?" → (6) Lock definition with sign-off |
| **RACI+ R DOs** | Developer: documents the definition; translates to V-A-N-A; proposes A.C.s |
| **RACI+ R DON'Ts** | Developer: do NOT define success without stakeholder input; do NOT skip A.C. validation; do NOT assume alignment from silence |
| **RACI+ A DOs** | Product Owner/Stakeholder: validates definition; signs off; ensures all relevant perspectives heard |
| **RACI+ A DON'Ts** | Product Owner: do NOT delegate sign-off; do NOT approve ambiguous definitions |
| **RACI+ C DOs** | Subject Expert: advises on feasibility of success criteria; flags unrealistic A.C.s |
| **RACI+ C DON'Ts** | Subject Expert: do NOT override stakeholder intent with technical constraints |
| **RACI+ I DOs** | Team: informed of locked definition after sign-off |
| **RACI+ I DON'Ts** | Team: do NOT begin build before informed of locked definition |

**User's System Mirror (Phase 0.A):**

| Column | Content |
|--------|---------|
| **Delivery Phase** | 0.A. Alignment of Success Definition |
| **Pillar** | SUSTAINABLE |
| **User's Desired Outcome** | User's Definition of Success — what the User considers a successful outcome |
| **User's Requirements (EP)** | User can articulate what success looks like for them in their own language [populated] |
| **User's Environment** | Low-pressure interview/discovery setting; User feels safe to share real needs (not just what they think the Developer wants to hear) [populated] |
| **User's Tools** | Simple articulation aids (examples, visual mockups, reference systems they already use) [populated] |
| **User's SOP** | User answers structured discovery questions; User reviews Developer's translation; User approves or rejects [populated] |
| **User's Actions** | Articulate → Review → Approve/Reject → Sign-off [populated] |
| **Important Notes** | User's definition may evolve across iterations — Phase A recurs with each cycle |

---

### 3.3 Phase B — Finding the Conditions to Generate Outcomes

**Phase Purpose:** Discover the premises, conditions, and constraints that determine which outcomes are possible. This is the learning phase — gathering truths before generating solutions.

**UT Traceability:** UT#7.WS3 (Effective Learning), UT#9.WS3 (Org Learning), UT#2 (understand UBS/UDS)

| Column | Content |
|--------|---------|
| **Development Phase** | B. Finding the Conditions to Generate Outcomes |
| **Pillar** | SUSTAINABLE → EFFICIENT |
| **Stage** | Identify premises and conditions for outcome generation |
| **Desired Outcome** | All relevant conditions, constraints, and premises documented and validated — including UBS/UDS mapping for the target domain |
| **EP — Derisking** | Identify ALL constraints before generating solutions; map UBS/UDS for the domain; seek disconfirming evidence for every assumption (anti-confirmation bias per UT#6) [populated] |
| **EP — Driving Output** | Focus on conditions that unlock the MOST outcomes (Pareto); prioritize conditions that address root UBS, not symptoms [populated] |
| **EP — Efficiency** | Use existing knowledge before researching new; structured research protocol (no open-ended exploration); time-boxed investigation per condition [populated] |
| **EP — Scalability** | Conditions should generalize across similar problems; document conditions in reusable format; build a conditions library for future subjects [populated] |
| **EOE — Derisking** | Access to domain knowledge without gatekeepers; blameless inquiry culture; time allocated for research without delivery pressure [populated] |
| **EOE — Driving Output** | Domain experts accessible and willing to share; cross-functional exposure (avoid silos per UT#8) [populated] |
| **EOE — Efficiency** | Single-focus research sessions; pre-curated information sources; no context-switching during investigation [populated] |
| **EOE — Scalability** | Centralized knowledge base where conditions accumulate across projects; searchable documentation [populated] |
| **EOT — Derisking** | UBS/UDS analysis template; assumption register with evidence requirements; disconfirmation checklist [populated] |
| **EOT — Driving Output** | Domain research tools; expert interview protocol; competitive/comparative analysis framework [populated] |
| **EOT — Efficiency** | Literature review automation; structured note-taking templates; pre-built condition categories [populated] |
| **EOT — Scalability** | Reusable conditions database; cross-project search; tagging taxonomy for conditions [populated] |
| **EOP** | (1) Define what conditions are needed (from Phase A success definition) → (2) Audit existing knowledge → (3) Identify gaps → (4) Research to fill gaps (UBS/UDS mapping, domain study, expert consultation) → (5) Validate conditions with evidence → (6) Document conditions in reusable format → (7) Lock conditions for Phase C |
| **RACI+ R DOs** | Developer: executes research; maps UBS/UDS; documents conditions; flags gaps |
| **RACI+ R DON'Ts** | Developer: do NOT skip UBS/UDS mapping; do NOT rely solely on personal experience (availability heuristic); do NOT assume conditions without evidence |
| **RACI+ A DOs** | Product Owner: validates that conditions are sufficient before proceeding to Phase C; ensures research scope is adequate |
| **RACI+ A DON'Ts** | Product Owner: do NOT rush Phase B ("just start generating"); do NOT accept conditions without evidence |
| **RACI+ C DOs** | Domain Expert: provides domain-specific conditions; validates UBS/UDS mapping; challenges assumptions |
| **RACI+ C DON'Ts** | Domain Expert: do NOT withhold information due to political sensitivity (UT#8 shadow systems) |
| **RACI+ I DOs** | Team: informed of locked conditions |
| **RACI+ I DON'Ts** | Team: do NOT assume conditions are final until informed |

**User's System Mirror (Phase 0.B):**

| Column | Content |
|--------|---------|
| **Delivery Phase** | 0.B. Finding the Conditions to Generate Outcomes |
| **Pillar** | SUSTAINABLE → EFFICIENT |
| **User's Desired Outcome** | Premises (Conditions) to choose Possible Outcomes |
| **User's Requirements (EP)** | User can articulate their constraints, preferences, and non-negotiables [populated] |
| **User's Environment** | Low-pressure discovery setting; User feels safe to share real constraints (including political/cultural ones) [populated] |
| **User's Tools** | Structured constraint-mapping exercises; visual aids for articulating trade-offs [populated] |
| **User's SOP** | User shares constraints → User reviews compiled conditions → User validates completeness [populated] |
| **User's Actions** | Share → Review → Validate [populated] |
| **Important Notes** | User often knows conditions they cannot articulate — use structured questions to surface tacit knowledge |

---

### 3.4 Phase C — Generate Possible Outcomes

**Phase Purpose:** Using the conditions from Phase B, generate the set of possible outcomes. This is the thinking phase — structured ideation, not brainstorming.

**UT Traceability:** UT#7.WS4 (Effective Thinking), UT#4 (value creation), UT#6 (guard against premature closure)

| Column | Content |
|--------|---------|
| **Development Phase** | C. Generate Possible Outcomes |
| **Pillar** | EFFICIENT |
| **Stage** | Structured generation of all viable outcomes from Phase B conditions |
| **Desired Outcome** | Comprehensive set of possible outcomes, each with feasibility assessment and traceability to Phase B conditions |
| **EP — Derisking** | Check each outcome against known failure modes from Phase B; generate at least one "safety" outcome (low-risk, proven approach); include "what could go wrong" for each [populated] |
| **EP — Driving Output** | Maximize the number of viable options BEFORE evaluating; separate generation from evaluation (avoid premature closure per UT#6); each outcome must trace to at least one Phase B condition [populated] |
| **EP — Efficiency** | Generate from conditions (not random brainstorming); use structured ideation frameworks (morphological analysis, SCAMPER, constraint-based generation); time-box generation phase [populated] |
| **EP — Scalability** | Include outcomes that scale beyond the current iteration; consider outcomes that serve multiple User Personas; reusable outcome patterns [populated] |
| **EOE — Derisking** | No judgment during generation phase; psychologically safe for unconventional ideas; separate generation session from evaluation session [populated] |
| **EOE — Driving Output** | Diverse perspectives in the room (cross-functional per UT#8 UDS); access to Phase B conditions document; stimulating but structured environment [populated] |
| **EOE — Efficiency** | Focused, time-boxed sessions; no distractions; Phase B conditions visible as reference [populated] |
| **EOE — Scalability** | Documented generation process reusable for future subjects; outcome library for cross-pollination [populated] |
| **EOT — Derisking** | Failure-mode checklist per outcome; risk-scoring template; "pre-mortem" for top candidates [populated] |
| **EOT — Driving Output** | Ideation frameworks (morphological box, mind-mapping, SCAMPER); outcome canvas template [populated] |
| **EOT — Efficiency** | Structured outcome template (Outcome Name, Phase B Condition it addresses, Feasibility, Risk, Value); batch-generation tools [populated] |
| **EOT — Scalability** | Outcome database; tagging system; cross-project outcome search [populated] |
| **EOP** | (1) Review Phase B locked conditions → (2) Generate outcomes using structured frameworks (one per condition cluster) → (3) Document each outcome with feasibility + risk + value → (4) Cross-check: is the set MECE relative to conditions? → (5) Lock outcome set for Phase D |
| **RACI+ R DOs** | Developer: generates outcomes using frameworks; documents each with traceability |
| **RACI+ R DON'Ts** | Developer: do NOT evaluate during generation; do NOT stop at 1–2 outcomes (minimum 3+); do NOT ignore unconventional options |
| **RACI+ A DOs** | Product Owner: validates completeness of outcome set; ensures conditions coverage |
| **RACI+ A DON'Ts** | Product Owner: do NOT pre-select favorites during generation phase |
| **RACI+ C DOs** | Domain Expert: advises on feasibility; suggests outcomes from domain experience |
| **RACI+ C DON'Ts** | Domain Expert: do NOT constrain generation to only "proven" approaches |
| **RACI+ I DOs** | Team: informed of outcome set |
| **RACI+ I DON'Ts** | Team: do NOT begin evaluating until Phase D |

**User's System Mirror (Phase 0.C):**

| Column | Content |
|--------|---------|
| **Delivery Phase** | 0.C. Generate Possible Outcomes |
| **Pillar** | EFFICIENT |
| **User's Desired Outcome** | User sees the full set of possible outcomes and understands trade-offs [populated] |
| **User's Requirements** | Outcomes presented in User-understandable language; each outcome explains "what changes for the User" [populated] |
| **User's Environment** | No-pressure review; time to consider each option [populated] |
| **User's Tools** | Visual comparison aids; trade-off matrices; outcome summaries [populated] |
| **User's SOP** | Review outcomes → Ask questions → Flag missing options [populated] |
| **User's Actions** | Review → Question → Validate completeness [populated] |

---

### 3.5 Phase D — Prioritize & Choose

**Phase Purpose:** From the set of possible outcomes, prioritize and select which to execute. This is the decision phase.

**UT Traceability:** UT#7.WS5 (Effective Decision Making & Planning), UT#5 (derisking priority), UT#6 (guard against affect heuristic)

| Column | Content |
|--------|---------|
| **Development Phase** | D. Prioritize & Choose Outcomes to Execute |
| **Pillar** | EFFICIENT → SCALABLE |
| **Stage** | Structured prioritization and selection from Phase C outcomes |
| **Desired Outcome** | Prioritized execution plan with clear rationale, iteration assignment, and resource allocation |
| **EP — Derisking** | Highest-risk items addressed first (UT#5); each chosen outcome must have a failure contingency; reversibility assessment for each decision [populated] |
| **EP — Driving Output** | Highest-value items prioritized; selection criteria explicit and pre-committed (avoid affect heuristic); traceability from chosen outcomes back to EO [populated] |
| **EP — Efficiency** | Minimum viable plan — choose the fewest outcomes that cover the most critical conditions; avoid analysis paralysis by time-boxing the decision [populated] |
| **EP — Scalability** | Plan must support 4-iteration progression (S → E → Sc); chosen outcomes must have a clear path from Desirable Wrapper (Iter 1–2) to Effective Core (Iter 3–4) [populated] |
| **EOE — Derisking** | No HiPPO effect (UT#8) — structured decision process overrides authority bias; anonymous scoring where possible [populated] |
| **EOE — Driving Output** | Decision-makers have access to full Phase C outcome set and Phase B conditions; no information asymmetry [populated] |
| **EOE — Efficiency** | Single decision session with pre-distributed materials; time-boxed deliberation [populated] |
| **EOE — Scalability** | Documented decision process reusable for future prioritization rounds [populated] |
| **EOT — Derisking** | Risk-weighted scoring matrix; reversibility assessment template; contingency plan template [populated] |
| **EOT — Driving Output** | Value-risk prioritization matrix (2×2); multi-criteria decision analysis tool; traceability matrix to EO [populated] |
| **EOT — Efficiency** | Pre-built prioritization template; decision log; time-box timer [populated] |
| **EOT — Scalability** | Iteration planning template (what goes in Iter 1 vs 2 vs 3 vs 4); resource allocation model [populated] |
| **EOP** | (1) Review Phase C outcome set → (2) Apply pre-committed scoring criteria → (3) Score each outcome independently (avoid groupthink) → (4) Rank by composite score (derisking-weighted) → (5) Assign to iteration (S outcomes to Iter 1; E to Iter 2; Sc to Iter 3–4) → (6) Define contingencies for top selections → (7) Lock execution plan |
| **RACI+ R DOs** | Developer: applies scoring criteria; compiles rankings; drafts iteration plan |
| **RACI+ R DON'Ts** | Developer: do NOT pre-select favorites; do NOT skip contingency planning; do NOT let sunk cost from Phase C influence scoring |
| **RACI+ A DOs** | Product Owner: approves final prioritization; validates iteration assignment; confirms resource availability |
| **RACI+ A DON'Ts** | Product Owner: do NOT override structured scoring with gut feeling; do NOT approve without contingency plans |
| **RACI+ C DOs** | Domain Expert: validates feasibility of iteration assignments; flags resource conflicts |
| **RACI+ C DON'Ts** | Domain Expert: do NOT lobby for specific outcomes outside the structured process |
| **RACI+ I DOs** | Team: informed of execution plan and their assigned iteration |
| **RACI+ I DON'Ts** | Team: do NOT begin execution before plan is locked |

**User's System Mirror (Phase 0.D):**

| Column | Content |
|--------|---------|
| **Delivery Phase** | 0.D. Prioritize & Choose |
| **Pillar** | EFFICIENT → SCALABLE |
| **User's Desired Outcome** | User understands what will be built, in what order, and why [populated] |
| **User's Requirements** | Transparent rationale for prioritization; User's input weighted appropriately [populated] |
| **User's Environment** | User participates in prioritization review; User's real priorities heard [populated] |
| **User's Tools** | Priority review summary; iteration roadmap visual [populated] |
| **User's SOP** | Review priorities → Challenge if misaligned → Approve plan [populated] |
| **User's Actions** | Review → Challenge → Approve [populated] |

---

### 3.6 Phase E — Design & Deliver

Phase E is the largest phase and contains the 8 Stages. This is where the actual UE system is designed, built, tested, and delivered. Every Stage below uses the full uniform column structure.

**UT Traceability:** UT#7.WS6 (Effective Execution), UT#9.WS6 (Org Execution), UT#10 (concurrent workstreams within each stage)

---

#### Stage 1: Define the Scope

| Column | Content |
|--------|---------|
| **Stage** | E.1. Define Scope |
| **Pillar** | SUSTAINABLE |
| **Steps** | 1.1 Define boundaries (what is IN this iteration); 1.2 Define acceptance criteria using V-A-N-A grammar (UT#3) with binary A.C.s; 1.3 Define what is explicitly OUT of scope (Anti-Scope) |
| **Desired Outcome** | Clear, bounded scope with testable A.C.s and explicit exclusions for this iteration |
| **EP — Derisking** | Every scope item must have at least one binary A.C.; Anti-Scope must be documented (prevent scope creep, the #1 execution risk); scope must be small enough to complete within one iteration cycle [populated] |
| **EP — Driving Output** | Scope must trace to Phase D prioritized outcomes; every scope item must contribute to EO; no "nice-to-have" in Iteration 1 [populated] |
| **EP — Efficiency** | Minimum viable scope — the smallest set of features that tests the core assumption; use V-A-N-A to decompose, then cut anything that isn't Verb or SustainAdv for Iteration 1 [populated] |
| **EP — Scalability** | Scope definition format must be reusable across iterations; A.C.s from Iteration 1 carry forward (append, never delete) [populated] |
| **EOE — Derisking** | No stakeholder pressure to add "just one more thing"; clear iteration boundaries respected [populated] |
| **EOE — Driving Output** | Phase D execution plan visible; success definition from Phase A visible [populated] |
| **EOE — Efficiency** | Single focused scoping session; pre-distributed Phase D plan [populated] |
| **EOE — Scalability** | Scoping template reusable across iterations and subjects [populated] |
| **EOT — Derisking** | V-A-N-A scope template; A.C. registry; Anti-Scope checklist [populated] |
| **EOT — Driving Output** | Traceability matrix (scope item → Phase D outcome → EO); user story mapping tool [populated] |
| **EOT — Efficiency** | Pre-built scope template with iteration-appropriate defaults (Iter 1 = S only; Iter 2 = S+E; etc.) [populated] |
| **EOT — Scalability** | Version-controlled scope document; A.C. inheritance tracker [populated] |
| **EOP** | (1) Review Phase D plan for this iteration → (2) Draft scope boundaries using V-A-N-A → (3) Write binary A.C.s for each scope item → (4) Define Anti-Scope explicitly → (5) Validate: is every scope item traceable to EO? → (6) Lock scope |
| **RACI+ R DOs** | Developer: drafts scope; writes A.C.s; defines Anti-Scope |
| **RACI+ R DON'Ts** | Developer: do NOT accept scope without A.C.s; do NOT leave Anti-Scope blank; do NOT add scope items mid-iteration without change control |
| **RACI+ A DOs** | Product Owner: approves scope and Anti-Scope; validates A.C.s are binary/deterministic |
| **RACI+ A DON'Ts** | Product Owner: do NOT add scope after lock without formal change request |
| **RACI+ C DOs** | Domain Expert: validates feasibility of scope items; challenges unrealistic A.C.s |
| **RACI+ C DON'Ts** | Domain Expert: do NOT expand scope beyond iteration capacity |
| **RACI+ I DOs** | Team: informed of locked scope and their responsibilities |
| **RACI+ I DON'Ts** | Team: do NOT begin work on items not in locked scope |

**User's System Mirror (Stage E.1):**

| Column | Content |
|--------|---------|
| **Delivery Phase** | Iteration N — Scope Definition |
| **Pillar** | SUSTAINABLE |
| **User's Desired Outcome** | User understands what they will receive in this iteration and what is NOT included [populated] |
| **User's Requirements** | Clear, jargon-free scope summary; explicit "what you will NOT get" section [populated] |
| **User's Environment** | User reviews scope without pressure to accept [populated] |
| **User's Tools** | Scope summary document; visual scope map [populated] |
| **User's SOP** | Review scope → Confirm expectations → Flag misalignment [populated] |
| **User's Actions** | Review → Confirm → Flag [populated] |

---

#### Stage 2: Design the Solution

| Column | Content |
|--------|---------|
| **Stage** | E.2. Design Solution |
| **Pillar** | SUSTAINABLE → EFFICIENT |
| **Steps** | 2.1 Map UBS/UDS for this scope (recursive, dot-notation per UT#2); 2.2 Derive EP from UBS/UDS (each principle enables a UDS element or disables a UBS element); 2.3 Design EOE/EOT in 3 causal layers (Foundational → Operational → Enhancement per ESD Framework); 2.4 Design EOP with full RACI+ per step |
| **Desired Outcome** | Complete solution design: UBS/UDS map, EP derived from it, EOE/EOT in 3 layers, EOP with RACI+ — all traceable to scope A.C.s |
| **EP — Derisking** | UBS mapping must go at least 2 levels deep (UBS.UD, UBS.UB); every EP principle must trace to a specific UBS element it disables or UDS element it enables; design must address shared forces (Bio-Efficient Forces, Support System Belief per UT#2) [populated] |
| **EP — Driving Output** | UDS mapping must identify root drivers, not just surface capabilities; EOE/EOT must enable each UDS element; EOP must have clear value-creation steps, not just risk-management steps [populated] |
| **EP — Efficiency** | Design for the current iteration's pillar only (S for Iter 1; S+E for Iter 2); do NOT over-design; use ESD framework's Desirable Wrapper vs Effective Core distinction [populated] |
| **EP — Scalability** | Design architecture must support deepening in later iterations without redesign; EOE/EOT Layer 1 (Foundational) must be stable across iterations; Layer 3 (Enhancement) should be modular [populated] |
| **EOE — Derisking** | Uninterrupted design sessions; access to all Phase B conditions and Phase A success definition; no pressure to "design fast and fix later" [populated] |
| **EOE — Driving Output** | Collaborative design environment; whiteboarding or diagramming space; cross-functional input available [populated] |
| **EOE — Efficiency** | Single-focus workspace; all reference materials accessible in one place; design decisions documented as they are made (not retroactively) [populated] |
| **EOE — Scalability** | Design pattern library; reusable architecture components from previous projects [populated] |
| **EOT — Derisking** | UBS/UDS recursive analysis template (dot-notation); EP derivation worksheet; shared forces checklist; design review checklist [populated] |
| **EOT — Driving Output** | EOE/EOT 3-layer canvas; EOP step template with RACI+; architecture diagram tool [populated] |
| **EOT — Efficiency** | Pre-built design templates for each ESD phase; iteration-appropriate design checklist (Iter 1 scope vs Iter 3 scope) [populated] |
| **EOT — Scalability** | Architecture decision records (ADRs); design pattern catalog; component registry [populated] |
| **EOP** | (1) Map UBS for scope (surface → UBS.UD → UBS.UB → UBS.UD.UD → UBS.UD.UB minimum) → (2) Map UDS for scope (same depth) → (3) Identify shared forces → (4) Derive EP: for each UBS element, one principle that disables it; for each UDS element, one principle that enables it → (5) Design EOE/EOT Layer 1 (Foundational) → (6) Design EOE/EOT Layer 2 (Operational) → (7) Design EOE/EOT Layer 3 (Enhancement) → (8) Design EOP steps with RACI+ → (9) Validate: does every design element trace to a scope A.C.? → (10) Lock design |
| **RACI+ R DOs** | Developer: executes UBS/UDS mapping; derives EP; designs EOE/EOT and EOP; documents all decisions |
| **RACI+ R DON'Ts** | Developer: do NOT skip UBS/UDS mapping ("we know the problem"); do NOT use generic EP (must trace to specific UBS/UDS); do NOT design EOE/EOT around available tools only (design for required tools first, then evaluate fit) |
| **RACI+ A DOs** | Product Owner: validates design completeness; ensures traceability to scope A.C.s |
| **RACI+ A DON'Ts** | Product Owner: do NOT approve design without UBS/UDS map; do NOT skip EP derivation review |
| **RACI+ C DOs** | Domain Expert: validates UBS/UDS accuracy for domain; challenges EP that feel generic |
| **RACI+ C DON'Ts** | Domain Expert: do NOT introduce new requirements during design (those belong in Stage 1) |
| **RACI+ I DOs** | Team: informed of locked design and their EOP assignments |
| **RACI+ I DON'Ts** | Team: do NOT deviate from design during build (Stage 3) without change control |

**User's System Mirror (Stage E.2):**

| Column | Content |
|--------|---------|
| **Delivery Phase** | Iteration N — Solution Design |
| **Pillar** | SUSTAINABLE → EFFICIENT |
| **User's Desired Outcome** | User's needs are accurately represented in the design; User's UBS/UDS is mapped [populated] |
| **User's Requirements** | Design addresses User's stated blockers; design enables User's stated goals [populated] |
| **User's Environment** | User participates in design review; User's real workflow understood [populated] |
| **User's Tools** | Design review summary (non-technical); User journey map [populated] |
| **User's SOP** | Review design → Validate UBS/UDS accuracy → Confirm priorities [populated] |
| **User's Actions** | Review → Validate → Confirm [populated] |

---

#### Stage 3: Build & Prototype

| Column | Content |
|--------|---------|
| **Stage** | E.3. Build & Prototype |
| **Pillar** | EFFICIENT |
| **Steps** | 3.1 Build first working version (implements Stage 2 design); 3.2 Highest Priority Prototype — build the RISKIEST assumption first to de-risk early |
| **Desired Outcome** | Working prototype that demonstrates the core value proposition and tests the riskiest assumptions |
| **EP — Derisking** | Build the riskiest assumption FIRST (not the easiest); prototype must test core UBS mitigation (does the design actually disable the blocker?); rollback capability at every build step [populated] |
| **EP — Driving Output** | Prototype must demonstrate core value to User (not just technical functionality); "demo-able" to stakeholders; tests whether UDS is actually enabled [populated] |
| **EP — Efficiency** | Minimum build to test assumption — no gold-plating; time-box the build (if it can't be built in the time-box, scope is too large); reuse existing components before building new [populated] |
| **EP — Scalability** | Build with clean interfaces so components can be replaced in later iterations; document architectural decisions that affect scalability; prototype architecture should inform the scalable version [populated] |
| **EOE — Derisking** | Version control for all work (rollback capability); isolated build environment (prototype doesn't break existing systems); clear "definition of done" from Stage 1 A.C.s [populated] |
| **EOE — Driving Output** | Focused build environment; access to all design artifacts from Stage 2; rapid feedback loop (build → test → adjust within hours, not weeks) [populated] |
| **EOE — Efficiency** | Single-focus workspace; no context-switching; all dependencies resolved before build begins; pre-configured development environment [populated] |
| **EOE — Scalability** | CI/CD pipeline (even basic); modular build structure; documentation generated alongside code [populated] |
| **EOT — Derisking** | Version control (Git); automated testing framework; A.C. checklist from Stage 1; build verification checklist [populated] |
| **EOT — Driving Output** | Development IDE; framework libraries; demo/presentation tools; User-facing prototype tools (mockups, functional prototypes) [populated] |
| **EOT — Efficiency** | Code templates; component libraries; build automation; dependency management [populated] |
| **EOT — Scalability** | Modular architecture patterns; API-first design tools; documentation generators [populated] |
| **EOP** | (1) Review locked design from Stage 2 → (2) Identify riskiest assumption → (3) Build prototype for riskiest assumption first → (4) Verify prototype against Stage 1 A.C.s → (5) Build remaining scope items → (6) Verify each against A.C.s → (7) Prepare demo for stakeholders → (8) Hand off to Stage 4 (Test) |
| **RACI+ R DOs** | Developer: builds prototype; verifies against A.C.s; prepares demo; documents build decisions |
| **RACI+ R DON'Ts** | Developer: do NOT build before design is locked; do NOT gold-plate (perfectionism); do NOT skip A.C. verification during build; do NOT deviate from design without change control |
| **RACI+ A DOs** | Product Owner: monitors build progress; validates prototype demonstrates core value; approves hand-off to testing |
| **RACI+ A DON'Ts** | Product Owner: do NOT change scope mid-build; do NOT accept "it mostly works" (A.C.s must pass) |
| **RACI+ C DOs** | Domain Expert: available for build questions; validates domain-specific logic |
| **RACI+ C DON'Ts** | Domain Expert: do NOT introduce new requirements during build |
| **RACI+ I DOs** | Team: informed of build completion and demo schedule |
| **RACI+ I DON'Ts** | Team: do NOT use prototype in production |

**User's System Mirror (Stage E.3):**

| Column | Content |
|--------|---------|
| **Delivery Phase** | Iteration N — Prototyping |
| **Pillar** | EFFICIENT |
| **User's Desired Outcome** | User can interact with a working prototype that demonstrates core value [populated] |
| **User's Requirements** | Prototype is usable without training; prototype clearly shows what the final system will do [populated] |
| **User's Environment** | Low-stakes testing environment; User knows this is a prototype (not final) [populated] |
| **User's Tools** | Working prototype; feedback collection form [populated] |
| **User's SOP** | Try prototype → Record experience → Provide feedback [populated] |
| **User's Actions** | Try → Record → Feedback [populated] |

---

#### Stage 4: Test & Validate

| Column | Content |
|--------|---------|
| **Stage** | E.4. Test & Validate |
| **Pillar** | SUSTAINABLE |
| **Steps** | 4.1 Test against Sustainability A.C.s (all iterations); 4.2 Test against Efficiency A.C.s (Iteration 2+); 4.3 Test against Scalability A.C.s (Iteration 3+) |
| **Desired Outcome** | All relevant A.C.s tested with binary pass/fail results; no untested A.C.s; failure modes documented |
| **EP — Derisking** | Test to BREAK, not to confirm (anti-confirmation bias); tester must be different from builder (self-disassociation per UT#6 UDS environment); edge cases tested first; negative testing (what happens when input is wrong?) before positive testing [populated] |
| **EP — Driving Output** | Test against User's success definition (Phase A), not developer's expectations; test in User-representative conditions; measure value delivered, not just functionality [populated] |
| **EP — Efficiency** | Automate repeatable tests; test highest-risk A.C.s first (Pareto); time-box manual testing; reuse test cases across iterations [populated] |
| **EP — Scalability** | Test suite must grow with A.C.s across iterations; test infrastructure must handle increased load testing in Iter 3+; test reports reusable for audit [populated] |
| **EOE — Derisking** | Isolated test environment (not production); User-representative data; no developer override of test failures ("it works on my machine" per UT#6); blameless failure reporting [populated] |
| **EOE — Driving Output** | Access to real or realistic User scenarios; stakeholder available for judgment calls on edge cases [populated] |
| **EOE — Efficiency** | Automated test pipeline; single command to run full test suite; immediate feedback on results [populated] |
| **EOE — Scalability** | Scalable test infrastructure; load testing environment for Iter 3+; test data generators [populated] |
| **EOT — Derisking** | A.C. test matrix (A.C. ID → Test Case → Pass/Fail → Evidence); negative test case generator; independent test harness [populated] |
| **EOT — Driving Output** | User acceptance testing (UAT) protocol; value measurement tools; User scenario scripts [populated] |
| **EOT — Efficiency** | Automated testing framework; regression test suite; test report generator [populated] |
| **EOT — Scalability** | Load testing tools; performance benchmarking; scalability test scenarios [populated] |
| **EOP** | (1) Map all A.C.s for this iteration to test cases → (2) Execute Sustainability tests first → (3) Gate: ALL S A.C.s must pass before proceeding → (4) Execute Efficiency tests (if Iter 2+) → (5) Gate: ALL E A.C.s must pass → (6) Execute Scalability tests (if Iter 3+) → (7) Document all results (pass AND fail) → (8) For failures: root cause analysis (UBS/UDS — was it a design flaw, build error, or test error?) → (9) Hand off results to Stage 5 (if all gates pass) or Stage 2 (if redesign needed) |
| **RACI+ R DOs** | Tester (NOT the builder): executes tests; documents results; reports failures without blame |
| **RACI+ R DON'Ts** | Tester: do NOT test own work (must be independent per UT#6); do NOT soften failure reports; do NOT skip edge cases; do NOT mark "partial pass" (binary only) |
| **RACI+ A DOs** | Product Owner: reviews test results; decides go/no-go; approves hand-off to Stage 5 or return to Stage 2 |
| **RACI+ A DON'Ts** | Product Owner: do NOT override test failures; do NOT approve "good enough" when A.C.s fail |
| **RACI+ C DOs** | Domain Expert: validates test scenarios are domain-realistic; advises on edge cases |
| **RACI+ C DON'Ts** | Domain Expert: do NOT design test cases to avoid known failures |
| **RACI+ I DOs** | Team + Developer: informed of test results and go/no-go decision |
| **RACI+ I DON'Ts** | Developer: do NOT dispute test results without evidence |

**User's System Mirror (Stage E.4):**

| Column | Content |
|--------|---------|
| **Delivery Phase** | Iteration N — Validation |
| **Pillar** | SUSTAINABLE |
| **User's Desired Outcome** | User confirms the system works as expected in their real conditions [populated] |
| **User's Requirements** | UAT in User's actual environment; User's real data (or representative data); User can flag issues without blame [populated] |
| **User's Environment** | User's actual or simulated operating environment; blameless feedback culture [populated] |
| **User's Tools** | UAT checklist; issue reporting form; severity classification guide [populated] |
| **User's SOP** | Test against own success criteria → Report issues → Confirm resolution [populated] |
| **User's Actions** | Test → Report → Confirm [populated] |

---

#### Stage 5: Deliver & Gather Feedback

**Sub-Stage 5.1 — Deliver the Planned Enablement Features:**

| Column | Content |
|--------|---------|
| **Stage** | E.5.1. Deliver Increments |
| **Pillar** | SUSTAINABLE → EFFICIENT |
| **Steps** | 5.1.1 Prepare deployment (rollback plan, monitoring setup); 5.1.2 Execute deployment; 5.1.3 Verify deployment in production; 5.1.4 Confirm User access |
| **Desired Outcome** | Features deployed, accessible to User, and monitored — with rollback capability confirmed |
| **EP — Derisking** | Rollback plan tested BEFORE deployment; monitoring for failure modes active from first minute; deployment in smallest possible increment; canary deployment where possible [populated] |
| **EP — Driving Output** | Features work as designed in production; User can access and use features immediately; value delivery confirmed (not just "it's deployed") [populated] |
| **EP — Efficiency** | Deployment automated where possible; zero-downtime deployment; deployment time minimized [populated] |
| **EP — Scalability** | Deployment process is repeatable for future iterations; deployment pipeline scales with feature count; infrastructure auto-scales if applicable [populated] |
| **EOE — Derisking** | Staging environment mirrors production; rollback tested in staging; monitoring dashboards live; on-call support during deployment window [populated] |
| **EOE — Driving Output** | User-facing documentation ready; support channels open; User notified of new features [populated] |
| **EOE — Efficiency** | Automated deployment pipeline; single-command deployment; pre-validated environment configs [populated] |
| **EOE — Scalability** | Infrastructure-as-code; auto-scaling configured; deployment playbook documented [populated] |
| **EOT — Derisking** | Rollback scripts; monitoring tools (alerts, dashboards); deployment checklist; incident response playbook [populated] |
| **EOT — Driving Output** | Release notes generator; User notification system; feature flag management [populated] |
| **EOT — Efficiency** | CI/CD pipeline; deployment automation; configuration management [populated] |
| **EOT — Scalability** | Container orchestration; auto-scaling tools; load balancers; deployment pipeline templates [populated] |
| **EOP** | (1) Prepare rollback plan and test it → (2) Configure monitoring for known failure modes → (3) Deploy to staging and verify → (4) Deploy to production (smallest increment) → (5) Verify in production against A.C.s → (6) Confirm User access → (7) Monitor for 24h post-deploy minimum |
| **RACI+ R DOs** | Developer: executes deployment; monitors; confirms access |
| **RACI+ R DON'Ts** | Developer: do NOT deploy without tested rollback; do NOT deploy without monitoring; do NOT deploy everything at once (incremental) |
| **RACI+ A DOs** | Product Owner: approves go-live; confirms User access; validates value delivery |
| **RACI+ A DON'Ts** | Product Owner: do NOT approve deployment without rollback plan |
| **RACI+ C DOs** | Domain Expert: validates deployment doesn't disrupt User's existing workflow |
| **RACI+ C DON'Ts** | Domain Expert: do NOT request last-minute changes during deployment |
| **RACI+ I DOs** | Team + User: informed of deployment and new features |
| **RACI+ I DON'Ts** | User: do NOT assume features are final (iteration continues) |

**Sub-Stage 5.2 — Gather User's Feedback:**

| Column | Content |
|--------|---------|
| **Stage** | E.5.2. Gather User's Feedback |
| **Pillar** | SUSTAINABLE |
| **Steps** | 5.2.1 Collect structured feedback (questionnaire); 5.2.2 Collect unstructured feedback (interviews, observations); 5.2.3 Analyze feedback against success definition; 5.2.4 Prioritize feedback for next iteration |
| **Desired Outcome** | Comprehensive, unbiased User feedback collected, analyzed, and prioritized for the next iteration |
| **EP — Derisking** | Ask about failure modes FIRST (what didn't work?); collect from ALL user segments (avoid survivorship bias per UT#6); structured format ensures nothing is missed; anonymous option available [populated] |
| **EP — Driving Output** | Ask about value delivered (what helped most?); measure against Phase A success definition; quantify where possible [populated] |
| **EP — Efficiency** | Structured feedback format (not open-ended); minimum viable feedback set (focus on top 3 success/failure items); time-box collection period [populated] |
| **EP — Scalability** | Feedback process scales with user base; automated collection where possible; feedback database for trend analysis across iterations [populated] |
| **EOE — Derisking** | Users feel safe to give negative feedback (blameless, anonymous option); no developer present during feedback collection (avoid social desirability bias) [populated] |
| **EOE — Driving Output** | Multiple feedback channels (survey, interview, observation); Users see their feedback has impact on next iteration [populated] |
| **EOE — Efficiency** | Feedback collection integrated into User's workflow (not a separate task); pre-built feedback instruments [populated] |
| **EOE — Scalability** | Automated feedback aggregation; trend dashboards; scalable survey tools [populated] |
| **EOT — Derisking** | Structured feedback questionnaire (failure-first); anonymous feedback tool; feedback analysis template with bias checks [populated] |
| **EOT — Driving Output** | NPS or value-measurement survey; User interview protocol; observation checklist [populated] |
| **EOT — Efficiency** | Pre-built feedback forms; automated analysis; sentiment analysis tools [populated] |
| **EOT — Scalability** | Scalable survey platform; feedback database; trend analysis dashboard [populated] |
| **EOP** | (1) Deploy feedback instruments immediately after Stage 5.1 → (2) Collect structured feedback (min 3 days) → (3) Conduct User interviews (sample) → (4) Analyze: categorize by success criteria from Phase A → (5) Check for survivorship bias (who DIDN'T respond?) → (6) Prioritize findings for Stage 6 → (7) Share feedback summary with stakeholders |
| **RACI+ R DOs** | Developer (or dedicated researcher): deploys instruments; collects data; analyzes results; flags survivorship bias |
| **RACI+ R DON'Ts** | Developer: do NOT collect feedback personally if it biases responses; do NOT dismiss negative feedback; do NOT filter feedback before sharing |
| **RACI+ A DOs** | Product Owner: reviews feedback analysis; validates prioritization; ensures feedback reaches Stage 6 |
| **RACI+ A DON'Ts** | Product Owner: do NOT cherry-pick positive feedback; do NOT suppress negative findings |
| **RACI+ C DOs** | Domain Expert: validates feedback interpretation; provides context for unexpected feedback |
| **RACI+ C DON'Ts** | Domain Expert: do NOT rationalize away User complaints |
| **RACI+ I DOs** | Team: informed of feedback summary and next steps |
| **RACI+ I DON'Ts** | Team: do NOT take negative feedback personally |

**User's System Mirror (Stage E.5):**

| Column | Content |
|--------|---------|
| **Delivery Phase** | Iteration N — Delivery & Feedback |
| **Pillar** | SUSTAINABLE |
| **User's Desired Outcome** | User receives working features and has a voice in improvement [populated] |
| **User's Requirements** | Features accessible without extensive training; feedback process is easy and safe; User sees impact of their feedback [populated] |
| **User's Environment** | Production environment; feedback collection integrated into workflow [populated] |
| **User's Tools** | Delivered features; feedback form; support channel [populated] |
| **User's SOP** | Use features → Notice issues/value → Provide feedback → See changes in next iteration [populated] |
| **User's Actions** | Use → Notice → Feedback → Verify changes [populated] |

---

#### Stage 6: Reflect & Learn

| Column | Content |
|--------|---------|
| **Stage** | E.6. Reflect & Learn |
| **Pillar** | SUSTAINABLE |
| **Steps** | 6.1 What worked? (Evidence-based, not feeling-based); 6.2 What failed? (Root cause, not symptoms); 6.3 Root cause analysis using UBS/UDS (was failure caused by a blocker? Which one? At what recursive depth?); 6.4 What specific changes for next iteration? (Tied to root cause, not generic "do better") |
| **Desired Outcome** | Honest, evidence-based lessons captured with root-cause UBS/UDS analysis; specific, actionable changes documented for next iteration |
| **EP — Derisking** | Failures analyzed before successes (UT#5 priority); root cause traced to specific UBS element (not "things went wrong"); each lesson must have a specific mitigation action; same mistake must NEVER recur (if it does, the reflection process itself failed) [populated] |
| **EP — Driving Output** | Successes analyzed for replicability (not just celebrated); UDS elements that worked are documented for amplification; each success must be traceable to a specific design decision [populated] |
| **EP — Efficiency** | Time-boxed reflection (prevent endless post-mortems); focus on top 3 failures and top 3 successes (Pareto); structured format prevents rambling [populated] |
| **EP — Scalability** | Lessons documented in searchable format; cross-project lesson library; pattern recognition across iterations; lessons feed into Phases A and B of next iteration [populated] |
| **EOE — Derisking** | BLAMELESS (critical per UT#6 UBS.UD.UB — support system belief); no punishment for honest failure reporting; focus on system failures, not people failures; psychological safety maximum [populated] |
| **EOE — Driving Output** | Dedicated reflection time (not squeezed into project closeout); all relevant data accessible; cross-functional perspectives present [populated] |
| **EOE — Efficiency** | Structured agenda; pre-distributed data (test results, feedback, metrics); single focused session [populated] |
| **EOE — Scalability** | Standardized retrospective format reusable across projects; lesson repository accessible to future teams [populated] |
| **EOT — Derisking** | Blameless post-mortem template; UBS/UDS root cause analysis worksheet (recursive dot-notation); "5 Whys" with UBS mapping; incident timeline reconstruction tool [populated] |
| **EOT — Driving Output** | Success pattern recognition template; UDS amplification worksheet; design decision → outcome traceability matrix [populated] |
| **EOT — Efficiency** | Pre-built retrospective template (what worked / what failed / root cause / action item); time-box timer; prioritization matrix for lessons [populated] |
| **EOT — Scalability** | Lesson database (searchable by UBS/UDS element, project, iteration); pattern matching across retrospectives; automated lesson summary generator [populated] |
| **EOP** | (1) Gather all data: test results (Stage 4), feedback (Stage 5.2), metrics, incident logs → (2) Each participant independently writes top 3 failures and top 3 successes (avoid groupthink) → (3) Share and consolidate → (4) For each failure: trace root cause using UBS/UDS recursive analysis (which UBS element? at what depth? was it a design flaw, process flaw, or environment flaw?) → (5) For each success: trace to design decision (which EP principle? which EOE/EOT component?) → (6) Generate specific action items (each tied to a root cause) → (7) Document in lesson library → (8) Feed into Stage 7 (Iterate) scope decisions |
| **RACI+ R DOs** | Developer + Tester: provide factual data; perform root cause analysis; document lessons honestly |
| **RACI+ R DON'Ts** | Developer: do NOT rationalize failures; do NOT attribute failures to external factors without evidence; do NOT skip UBS/UDS tracing (generic "lessons learned" are worthless); do NOT rush reflection to "get back to building" |
| **RACI+ A DOs** | Product Owner: ensures reflection happens (not skipped); validates root cause depth; approves action items; ensures lessons reach next iteration |
| **RACI+ A DON'Ts** | Product Owner: do NOT skip reflection under time pressure; do NOT blame individuals; do NOT accept surface-level root causes ("we didn't have enough time" is a symptom, not a root cause) |
| **RACI+ C DOs** | Domain Expert: provides independent perspective on root causes; challenges self-serving attributions |
| **RACI+ C DON'Ts** | Domain Expert: do NOT participate if it creates blame dynamics |
| **RACI+ I DOs** | Team: informed of lessons and action items for next iteration |
| **RACI+ I DON'Ts** | Team: do NOT ignore lessons from other teams/iterations |

**User's System Mirror (Stage E.6):**

| Column | Content |
|--------|---------|
| **Delivery Phase** | Iteration N — Reflection |
| **Pillar** | SUSTAINABLE |
| **User's Desired Outcome** | User sees that their feedback was heard and analyzed; User trusts the improvement process [populated] |
| **User's Requirements** | Feedback loop closed: User knows what will change and why [populated] |
| **User's Environment** | User receives "you said, we learned, we'll change" summary [populated] |
| **User's Tools** | Iteration retrospective summary (User-facing version) [populated] |
| **User's SOP** | Receive summary → Confirm understanding → Provide additional input if needed [populated] |
| **User's Actions** | Receive → Confirm → Additional input [populated] |

---

#### Stage 7: Iterate

| Column | Content |
|--------|---------|
| **Stage** | E.7. Iterate |
| **Pillar** | Transitions: S → E (Iter 1→2); E → Sc (Iter 2→3); Sc → Leadership (Iter 3→4) |
| **Steps** | 7.1 Update scope from Stage 6 lessons and Stage 5.2 feedback; 7.2 Decide: re-enter Stage 1 (same Pillar, refined scope) OR graduate to next Pillar; 7.3 If graduating: verify all current-Pillar A.C.s pass before proceeding |
| **Desired Outcome** | Clear decision: iterate within current Pillar or graduate to next. Updated scope for next cycle. |
| **EP — Derisking** | Do NOT graduate to next Pillar if any current-Pillar A.C.s still fail (UT#5: S gates E gates Sc); graduation decision based on evidence (test results), not feeling; rollback to previous iteration if regression detected [populated] |
| **EP — Driving Output** | Each iteration must demonstrate measurable progress toward EO; scope updates must increase value delivered, not just fix bugs [populated] |
| **EP — Efficiency** | Scope updates are surgical — change only what Stage 6 root causes identified; avoid over-correction (changing everything because one thing failed) [populated] |
| **EP — Scalability** | Iteration process itself must be templated and repeatable; iteration velocity should increase over time (learning curve); iteration records enable prediction of future iteration needs [populated] |
| **EOE — Derisking** | Decision made with full data from Stages 4–6; no pressure to "ship faster" overriding quality gates [populated] |
| **EOE — Driving Output** | Stakeholder visibility into iteration progress; celebration of Pillar graduation as milestone [populated] |
| **EOE — Efficiency** | Quick turnaround between iterations; minimal ceremony for scope updates [populated] |
| **EOE — Scalability** | Iteration tracking visible across projects; iteration velocity benchmarks [populated] |
| **EOT — Derisking** | Pillar graduation checklist (all S A.C.s pass? all E A.C.s pass?); regression detection tools; iteration comparison dashboard [populated] |
| **EOT — Driving Output** | Progress tracker (EO achievement %); iteration roadmap; milestone celebration protocol [populated] |
| **EOT — Efficiency** | Scope diff tool (what changed between iterations); automated scope update template [populated] |
| **EOT — Scalability** | Iteration velocity tracker; cross-project iteration benchmarks; iteration planning template [populated] |
| **EOP** | (1) Review Stage 6 action items → (2) Review Stage 5.2 feedback priorities → (3) Draft updated scope → (4) Evaluate: do all current-Pillar A.C.s pass? → (5a) If YES and ready for next Pillar: graduate (Iter 1→2 or 2→3 or 3→4) → (5b) If NO: re-enter Stage 1 with updated scope at same Pillar → (6) Lock iteration decision → (7) Re-enter Stage 1 |
| **RACI+ R DOs** | Developer: drafts updated scope; compiles graduation evidence; prepares iteration plan |
| **RACI+ R DON'Ts** | Developer: do NOT skip graduation gate check; do NOT carry unresolved failures into next iteration without explicit acceptance; do NOT change scope without tracing to Stage 6 root causes |
| **RACI+ A DOs** | Product Owner: approves iteration decision (iterate or graduate); validates scope updates |
| **RACI+ A DON'Ts** | Product Owner: do NOT force graduation when A.C.s fail; do NOT approve identical scope (no learning applied) |
| **RACI+ C DOs** | Domain Expert: advises on graduation readiness; flags risks in scope updates |
| **RACI+ C DON'Ts** | Domain Expert: do NOT advocate for feature additions disguised as "scope updates" |
| **RACI+ I DOs** | Team + User: informed of iteration decision and updated timeline |
| **RACI+ I DON'Ts** | Team: do NOT start next iteration before scope is locked |

**User's System Mirror (Stage E.7):**

| Column | Content |
|--------|---------|
| **Delivery Phase** | Iteration N → N+1 Transition |
| **Pillar** | Transitioning |
| **User's Desired Outcome** | User sees continuous improvement; User trusts the iteration process delivers value [populated] |
| **User's Requirements** | Clear communication of what changes and when; User's priorities reflected in scope updates [populated] |
| **User's Environment** | User informed of iteration plan; User sees their feedback reflected [populated] |
| **User's Tools** | Updated roadmap; iteration summary; "what's changing" one-pager [populated] |
| **User's SOP** | Receive update → Confirm alignment → Continue using current version until next delivery [populated] |
| **User's Actions** | Receive → Confirm → Continue [populated] |

---

#### Stage 8: Scale & Sustain

| Column | Content |
|--------|---------|
| **Stage** | E.8. Scale & Sustain |
| **Pillar** | SCALABLE |
| **Steps** | 8.1 Monitor system at target scale (performance, reliability, cost); 8.2 Identify scaling bottlenecks (capacity limits, cost curves, failure modes under load); 8.3 Resolve bottlenecks (redesign, optimize, or accept with mitigation); 8.4 Document for replication (enable other teams/domains to adopt the system) |
| **Desired Outcome** | System operates at target scale without proportional cost increase; bottlenecks identified and resolved; system documented for replication to other domains |
| **EP — Derisking** | Monitor for failure modes that only appear at scale (emergent properties); have kill-switch for scale-back if system degrades; scaling must NOT compromise Sustainability A.C.s achieved in Iter 1–2 [populated] |
| **EP — Driving Output** | Value delivered must scale with users (not just capacity); measure per-user value at scale vs. at prototype; scaling must unlock new use cases or User Personas [populated] |
| **EP — Efficiency** | Cost per unit of value must decrease with scale (not increase); identify and eliminate waste that was acceptable at prototype scale; automation of manual processes [populated] |
| **EP — Scalability** | System architecture supports 10x current load without redesign; modular components can be swapped independently; documentation enables independent replication [populated] |
| **EOE — Derisking** | Production monitoring with alerts; incident response team on standby; rollback capability at scale; chaos engineering practices (test failures proactively) [populated] |
| **EOE — Driving Output** | Visibility into value metrics at scale; User satisfaction tracking; stakeholder dashboard [populated] |
| **EOE — Efficiency** | Cost monitoring (infrastructure, API, compute); efficiency benchmarks; waste identification process [populated] |
| **EOE — Scalability** | Auto-scaling infrastructure; multi-region/multi-tenant architecture if needed; documentation accessible to new teams [populated] |
| **EOT — Derisking** | Production monitoring (APM, logging, alerting); incident management platform; chaos engineering tools; capacity planning models [populated] |
| **EOT — Driving Output** | Value analytics dashboard; User adoption metrics; per-user value measurement; business impact reporting [populated] |
| **EOT — Efficiency** | Cost optimization tools; performance profilers; waste identification dashboards; automation frameworks [populated] |
| **EOT — Scalability** | Auto-scaling platforms; load balancers; CDN; multi-tenant frameworks; replication playbook templates; infrastructure-as-code [populated] |
| **EOP** | (1) Define target scale (users, volume, domains) → (2) Deploy monitoring at target scale → (3) Ramp to target scale incrementally (not all at once) → (4) At each increment: check S/E/Sc A.C.s still pass → (5) Identify bottlenecks (capacity, cost, reliability) → (6) For each bottleneck: root cause analysis (UT#2 — is it UBS in the system design?) → (7) Resolve: redesign component, optimize, or accept with documented mitigation → (8) Document the full system for replication: architecture, A.C.s, lessons, operational playbook → (9) Hand off documentation to replication teams |
| **RACI+ R DOs** | Developer + Ops: monitors at scale; identifies bottlenecks; resolves them; documents for replication |
| **RACI+ R DON'Ts** | Developer: do NOT scale before all Iter 3 A.C.s pass; do NOT ignore cost curves; do NOT skip documentation ("no one else will use this" — they will); do NOT assume current architecture handles 10x without testing |
| **RACI+ A DOs** | Product Owner: validates target scale is appropriate; approves replication documentation; ensures value scales with capacity |
| **RACI+ A DON'Ts** | Product Owner: do NOT push for scale before sustainability is confirmed; do NOT accept "it seems fine" without monitoring data |
| **RACI+ C DOs** | Domain Expert: validates scaling doesn't change domain-specific behavior; advises on replication to adjacent domains |
| **RACI+ C DON'Ts** | Domain Expert: do NOT assume domain knowledge transfers automatically to new teams (document explicitly) |
| **RACI+ I DOs** | Team + Future teams: informed of replication playbook and operational requirements |
| **RACI+ I DON'Ts** | Future teams: do NOT replicate without reading the full playbook (including failure history) |

**User's System Mirror (Stage E.8):**

| Column | Content |
|--------|---------|
| **Delivery Phase** | Iteration 4 — Leadership / At Scale |
| **Pillar** | SCALABLE |
| **User's Desired Outcome** | System works reliably at full scale; User experience does not degrade with more users; system available in User's domain [populated] |
| **User's Requirements** | Consistent performance; no regression from earlier iterations; support available at scale [populated] |
| **User's Environment** | Production at scale; User's normal operating conditions; support channels scaled [populated] |
| **User's Tools** | Fully deployed system; scaled support; self-service documentation [populated] |
| **User's SOP** | Use system at scale → Report issues → Access support → Onboard new users in their domain [populated] |
| **User's Actions** | Use → Report → Support → Onboard others [populated] |

---

### 3.7 Complete Stage Flow Diagram

```
UEDS: 5 DEVELOPMENT PHASES × 8 STAGES × ~26 SUB-STEPS
(All evaluated through 4 Lenses × RACI+ across 4 Iterations)

Phase A ─── Alignment of Success Definition
Phase B ─── Finding Conditions to Generate Outcomes
Phase C ─── Generate Possible Outcomes
Phase D ─── Prioritize & Choose
Phase E ─── Design & Deliver
  │
  ├── Stage 1: Define Scope
  │     ├── 1.1 Define boundaries
  │     ├── 1.2 Define acceptance criteria (V-A-N-A)
  │     └── 1.3 Define exclusions (Anti-Scope)
  │
  ├── Stage 2: Design Solution
  │     ├── 2.1 Map UBS/UDS (recursive, dot-notation)
  │     ├── 2.2 Derive EP (from UBS/UDS, not generic)
  │     ├── 2.3 Design EOE/EOT (3 causal layers)
  │     └── 2.4 Design EOP (RACI+)
  │
  ├── Stage 3: Build & Prototype
  │     ├── 3.1 Build first version
  │     └── 3.2 Highest priority prototype (DE-RISK riskiest assumption)
  │
  ├── Stage 4: Test & Validate
  │     ├── 4.1 Sustainability A.C.s (all iterations)
  │     ├── 4.2 Efficiency A.C.s (Iter 2+)
  │     └── 4.3 Scalability A.C.s (Iter 3+)
  │
  ├── Stage 5: Deliver & Feedback
  │     ├── 5.1 Deliver increments (with rollback plan)
  │     └── 5.2 Gather user feedback (failure-first, anti-survivorship)
  │
  ├── Stage 6: Reflect & Learn
  │     ├── 6.1 What worked? (evidence-based)
  │     ├── 6.2 What failed? (evidence-based)
  │     ├── 6.3 Root cause via UBS/UDS recursive analysis
  │     └── 6.4 Specific changes for next iteration
  │
  ├── Stage 7: Iterate
  │     ├── 7.1 Update scope from Stage 6 lessons
  │     ├── 7.2 Graduation gate check (all current-Pillar A.C.s pass?)
  │     └── 7.3 Re-enter Stage 1 (same or next Pillar)
  │
  └── Stage 8: Scale & Sustain
        ├── 8.1 Monitor at target scale
        ├── 8.2 Identify bottlenecks
        ├── 8.3 Resolve bottlenecks
        └── 8.4 Document for replication

TOTAL: 5 Phases + 8 Stages + ~26 Sub-steps
EACH evaluated: 4 Lenses × 16 columns (EP×4 + Env×4 + Tools×4 + EOP + RACI+ DOs/DON'Ts×8) = uniform
PLUS: User's System Mirror for every Phase/Stage (8 columns)
ACROSS: 4 Iterations = comprehensive UEDS
```

---

## Part 4: Human Weakness Analysis

### 4.1 Framework for Weakness Scoring

For every stage/step, we evaluate: **Which human UBS weakness is the primary bottleneck?** And score it on a **Weakness Exposure Scale (WES):**

```
WES SCORING:

5 = CRITICAL  — Human performs this step under maximum UBS influence.
                Step requires sustained System 2 engagement in conditions
                that favor System 1. Failure probability is high.
                AI replacement would eliminate this weakness entirely.

4 = HIGH      — Human performs this step with significant UBS interference.
                Step requires cognitive effort that bio-efficiency resists.
                AI would substantially reduce failure risk.

3 = MODERATE  — Human can perform this step but UBS creates measurable friction.
                With good support systems, failure risk is manageable.
                AI would improve consistency and speed.

2 = LOW       — Human performs this step adequately. UBS influence is minor.
                Step leverages human strengths (judgment, empathy, context).
                AI may assist but human remains the better actor.

1 = MINIMAL   — Human excels at this step. UBS is largely irrelevant.
                Step requires uniquely human capabilities.
                AI cannot replace and should not attempt.
```

### 4.2 Phase-by-Phase Weakness Analysis

#### Phase A: Alignment of Success Definition — WES: 4 (HIGH)

```
PRIMARY WEAKNESS: Anchoring Bias + WYSIATI (UT#6)

┌─────────────────────────────────────────────────────────────────────┐
│  HUMAN BOTTLENECK IN PHASE A                                        │
│                                                                     │
│  UBS.Surface:                                                       │
│    Anchoring — First success definition heard becomes the anchor.   │
│    WYSIATI — "What You See Is All There Is" — stakeholders define   │
│    success based on visible symptoms, not root causes.              │
│    Emotional reasoning — "This feels like the right goal."          │
│                                                                     │
│  UBS.UD (System 1 activation):                                      │
│    Under time pressure ("just start building"), System 1 produces   │
│    a "reasonable enough" definition that FEELS right but hasn't     │
│    been tested against failure modes.                                │
│                                                                     │
│  UBS.UD.UD (Bio-Efficiency):                                        │
│    Thorough alignment is EFFORTFUL. Bio-efficiency resists the      │
│    slow, careful work of defining success rigorously.               │
│    The brain wants to "just get started" — conserving energy.       │
│                                                                     │
│  SPECIFIC FAILURE MODES:                                            │
│    1. Success defined by what's easy to measure, not what matters   │
│    2. Success definition anchored on competitor or precedent        │
│    3. Stakeholders mistake "no objections" for "alignment"          │
│    4. V-A-N-A grammar not applied → requirements are ambiguous      │
│    5. Acceptance criteria are subjective, not binary/deterministic  │
│                                                                     │
│  WHY WES = 4:                                                       │
│    Alignment REQUIRES System 2 (deliberate, skeptical analysis).    │
│    But it happens early, before problems are visible, when bio-     │
│    efficiency says "this is fine, move on." The UBS is strongest    │
│    when the cost of being wrong is not yet felt (no pain signal     │
│    to activate UDS.UD.UD evolutionary forces).                      │
└─────────────────────────────────────────────────────────────────────┘
```

#### Phase B: Finding Conditions — WES: 5 (CRITICAL)

```
PRIMARY WEAKNESS: Confirmation Bias + Availability Heuristic (UT#6)

┌─────────────────────────────────────────────────────────────────────┐
│  HUMAN BOTTLENECK IN PHASE B                                        │
│                                                                     │
│  UBS.Surface:                                                       │
│    Confirmation bias — search for evidence that supports existing   │
│    beliefs about the problem space.                                 │
│    Availability heuristic — recent or vivid information is          │
│    overweighted vs. comprehensive, boring, but accurate data.       │
│    WYSIATI — conditions identified are limited to what's visible.   │
│                                                                     │
│  UBS.UD (System 1):                                                 │
│    System 1 creates "sensible stories" about conditions rather      │
│    than logically mapping all constraints. The brain fills gaps     │
│    with associations, not analysis.                                 │
│                                                                     │
│  UBS.UD.UD (Bio-Efficiency):                                        │
│    Learning is EXPENSIVE. Finding conditions requires research,     │
│    reading, asking experts, and admitting ignorance. Bio-efficiency │
│    pushes toward "I already know enough" and "let's just try it."  │
│                                                                     │
│  ORGANIZATIONAL UBS (UT#8):                                         │
│    Information silos — conditions known to one team are invisible   │
│    to the developer. Shadow operating systems — real constraints    │
│    are undocumented and politically sensitive.                       │
│                                                                     │
│  SPECIFIC FAILURE MODES:                                            │
│    1. Critical constraint unknown because no one asked the right    │
│       person (silo + availability heuristic)                        │
│    2. Conditions assumed from personal experience, not validated    │
│    3. UBS/UDS mapping skipped ("we already know the problem")       │
│    4. Conditions discovered too late (in Phase E, during build)     │
│    5. Research is biased toward confirming the preferred solution   │
│                                                                     │
│  WHY WES = 5:                                                       │
│    This is the MOST UBS-vulnerable phase. Learning requires the     │
│    most System 2 effort (truth-finding, skepticism, completeness)   │
│    in conditions where System 1 is most attractive ("I know this"). │
│    Bio-efficiency is maximally opposed. And the consequences of     │
│    failure are INVISIBLE until much later (Phase E), so there is    │
│    no pain signal to activate UDS.UD.UD.                            │
│    This is where the human weakness is most dangerous.              │
└─────────────────────────────────────────────────────────────────────┘
```

#### Phase C: Generate Possible Outcomes — WES: 4 (HIGH)

```
PRIMARY WEAKNESS: Premature Closure + Anchoring (UT#6)

┌─────────────────────────────────────────────────────────────────────┐
│  HUMAN BOTTLENECK IN PHASE C                                        │
│                                                                     │
│  UBS.Surface:                                                       │
│    Premature closure — accepting the first "good enough" outcome    │
│    instead of generating the full solution space.                   │
│    Anchoring — first outcome generated becomes the reference point. │
│    Representativeness — outcomes that "look right" are preferred    │
│    over outcomes that ARE right.                                    │
│                                                                     │
│  UBS.UD (System 1):                                                 │
│    System 1 generates ONE outcome quickly and labels it "the answer"│
│    rather than generating MANY and evaluating each.                 │
│    The heuristic: "If it came to mind easily, it must be good."    │
│                                                                     │
│  SPECIFIC FAILURE MODES:                                            │
│    1. Solution space too narrow (only 1–2 options generated)        │
│    2. Most creative/unconventional options never considered         │
│    3. Outcomes biased toward developer's existing skills/tools      │
│    4. "We've always done it this way" (institutional anchoring)     │
│    5. Feasibility confused with desirability                        │
│                                                                     │
│  WHY WES = 4:                                                       │
│    Generating genuinely diverse outcomes requires holding multiple  │
│    possibilities simultaneously in working memory — which is        │
│    exactly what System 2 does and System 1 avoids. Bio-efficiency  │
│    says "the first idea is fine." But not CRITICAL (WES 5) because │
│    structured frameworks (brainstorming templates, morphological    │
│    analysis) can partially mitigate.                                │
└─────────────────────────────────────────────────────────────────────┘
```

#### Phase D: Prioritize & Choose — WES: 4 (HIGH)

```
PRIMARY WEAKNESS: Affect Heuristic + Sunk Cost (UT#6)

┌─────────────────────────────────────────────────────────────────────┐
│  HUMAN BOTTLENECK IN PHASE D                                        │
│                                                                     │
│  UBS.Surface:                                                       │
│    Affect heuristic — "I like this option → it must be good."      │
│    Sunk cost — time invested in one option increases commitment    │
│    regardless of objective merit.                                   │
│    Social pressure — choosing against the group consensus is risky. │
│                                                                     │
│  ORGANIZATIONAL UBS (UT#8):                                         │
│    HiPPO effect (Highest Paid Person's Opinion) — power dynamics   │
│    override analytical prioritization.                               │
│    Groupthink — dissenting views suppressed to maintain harmony.    │
│                                                                     │
│  SPECIFIC FAILURE MODES:                                            │
│    1. Highest-value option rejected because it's politically risky │
│    2. Prioritization based on who advocates loudest, not analysis  │
│    3. Risk assessment is gut-feeling, not structured                │
│    4. Decision delayed indefinitely (analysis paralysis from       │
│       UDS.UB — bio-efficiency makes deciding "too hard")           │
│    5. Chosen outcome doesn't align with Iteration gate criteria    │
│                                                                     │
│  WHY WES = 4:                                                       │
│    Prioritization is a classic System 2 task (comparative analysis, │
│    trade-off evaluation, risk weighting) that System 1 shortcuts   │
│    with "this feels right." Organizational UBS compounds it.       │
└─────────────────────────────────────────────────────────────────────┘
```

#### Phase E, Stage 1: Define Scope — WES: 3 (MODERATE)

```
PRIMARY WEAKNESS: Scope Creep via Optimism Bias (UT#6)

  SPECIFIC FAILURE MODES:
    1. Scope too broad — "while we're at it, let's also..."
    2. Exclusions not defined — everything is implicitly in scope
    3. Acceptance criteria vague or missing
    4. V-A-N-A grammar not applied

  WHY WES = 3: Scope definition is more bounded and can be templated.
  With V-A-N-A and A.C. frameworks, the human has structural support.
```

#### Phase E, Stage 2: Design Solution — WES: 4 (HIGH)

```
PRIMARY WEAKNESS: Complexity Bias + Familiarity Bias (UT#6)

  SPECIFIC FAILURE MODES:
    1. UBS/UDS mapping skipped ("we'll figure it out during build")
    2. EP generic instead of derived from specific UBS/UDS
    3. EOE/EOT designed around available tools, not required tools
    4. EOP has no risk gates (only happy-path steps)
    5. RACI assigned by org chart, not by capability

  WHY WES = 4: Design requires deep System 2 engagement across
  multiple interconnected decisions. Each decision is a UBS entry point.
```

#### Phase E, Stage 3: Build & Prototype — WES: 3 (MODERATE)

```
PRIMARY WEAKNESS: Action Bias + Perfectionism (UT#6)

  SPECIFIC FAILURE MODES:
    1. Building before design is validated ("just start coding")
    2. Prototype too polished (perfectionism wastes iteration budget)
    3. Prototype tests convenience, not assumptions
    4. Builder's bias: "my code works" without testing against A.C.s

  WHY WES = 3: Building is concrete, feedback is immediate.
  System 1 actually HELPS here (pattern matching, rapid execution).
  The weakness is in WHAT gets built, not HOW.
```

#### Phase E, Stage 4: Test & Validate — WES: 4 (HIGH)

```
PRIMARY WEAKNESS: Confirmation Bias in Testing (UT#6)

  SPECIFIC FAILURE MODES:
    1. Testing confirms what works instead of probing what fails
    2. Test cases designed to pass, not to break
    3. Edge cases ignored ("that won't happen in production")
    4. Tester = Builder (no self-disassociation per UT#6)
    5. "It works on my machine" syndrome

  WHY WES = 4: Testing REQUIRES adversarial thinking — actively
  trying to prove your own work wrong. This directly opposes
  System 1's emotional investment in "my work is good."
```

#### Phase E, Stage 5: Deliver & Feedback — WES: 3 (MODERATE)

```
PRIMARY WEAKNESS: Survivorship Bias in Feedback (UT#6, UT#8)

  SPECIFIC FAILURE MODES (5.1 Deliver):
    1. Deployment without rollback plan
    2. Deployment to wrong audience segment
    3. No monitoring of failure modes post-deploy

  SPECIFIC FAILURE MODES (5.2 Feedback):
    1. Only collecting feedback from happy users (survivorship)
    2. Feedback questions biased toward positive responses
    3. Negative feedback dismissed as "user error"
    4. Feedback not structured → hard to act on

  WHY WES = 3: Delivery is procedural (lower UBS risk).
  Feedback collection is UBS-vulnerable but can be structured.
```

#### Phase E, Stage 6: Reflect & Learn — WES: 5 (CRITICAL)

```
PRIMARY WEAKNESS: Self-Serving Attribution + Effort Aversion (UT#6)

┌─────────────────────────────────────────────────────────────────────┐
│  HUMAN BOTTLENECK IN STAGE 6                                        │
│                                                                     │
│  UBS.Surface:                                                       │
│    Self-serving attribution — credit successes to skill; blame      │
│    failures on circumstances. Root cause analysis is distorted.     │
│    Emotional reasoning — reflecting on failure FEELS BAD, so the   │
│    brain avoids it or softens the conclusions.                      │
│    WYSIATI — lessons learned are limited to what was noticed.       │
│                                                                     │
│  UBS.UD (System 1):                                                 │
│    System 1 creates a narrative: "It didn't work because of X"     │
│    (where X protects the ego) instead of: "The root cause was Y"   │
│    (where Y might implicate the reflector).                         │
│                                                                     │
│  UBS.UD.UD (Bio-Efficiency):                                        │
│    Reflection is pure cognitive cost with no immediate reward.      │
│    Bio-efficiency aggressively resists it: "Move on to the next    │
│    thing" is always more appealing than "Sit and think about        │
│    what went wrong."                                                │
│                                                                     │
│  ORGANIZATIONAL UBS (UT#8):                                         │
│    Blame culture — reflection becomes finger-pointing.              │
│    Shadow systems — real process failures hidden behind official    │
│    narratives. Nobody wants to document that the shadow system      │
│    was the actual operating system.                                 │
│                                                                     │
│  SPECIFIC FAILURE MODES:                                            │
│    1. Reflection skipped entirely ("no time, let's move on")        │
│    2. Root cause is symptoms, not actual root (UBS.UD dominates)   │
│    3. Lessons documented but never referenced again                 │
│    4. Same mistakes repeated in next iteration                      │
│    5. Reflection becomes blame session (UT#8 org UBS)              │
│                                                                     │
│  WHY WES = 5:                                                       │
│    Reflection is the single most UBS-opposed activity in the UEDS. │
│    It requires: (1) admitting failure (opposes emotional UBS),     │
│    (2) sustained analysis with no immediate reward (opposes bio-   │
│    efficiency), (3) honesty about what actually happened (opposes  │
│    self-serving attribution), (4) organizational transparency      │
│    (opposes shadow systems).                                        │
│    This is the phase humans MOST need to do and LEAST want to.     │
└─────────────────────────────────────────────────────────────────────┘
```

#### Phase E, Stage 7: Iterate — WES: 3 (MODERATE)

```
PRIMARY WEAKNESS: Status Quo Bias (UT#6)

  SPECIFIC FAILURE MODES:
    1. Iteration scope identical to previous (not learning from feedback)
    2. Iteration rejected ("it's good enough as is")
    3. Scope changes too radical (overcorrection from feedback)

  WHY WES = 3: Iteration is a structural decision that can be gated.
```

#### Phase E, Stage 8: Scale & Sustain — WES: 4 (HIGH)

```
PRIMARY WEAKNESS: Complexity Blindness + Normalcy Bias (UT#6, UT#8)

  SPECIFIC FAILURE MODES:
    1. Scaling before sustainability is confirmed ("move fast")
    2. Bottlenecks invisible until they cause outage
    3. "It worked at small scale, so it will work at large scale"
    4. Documentation for replication never created
    5. Institutional knowledge trapped in individuals (UT#8 silos)

  WHY WES = 4: Scaling requires anticipating failures that haven't
  happened yet — which is anti-System 1. Normalcy bias says "it's
  been fine so far." Complexity blindness misses emergent properties.
```

### 4.3 Weakness Exposure Summary Table

| Phase/Stage | WES | Primary Human Weakness | UBS Layer | UDS Blocked? |
|-------------|-----|----------------------|-----------|-------------|
| **A. Alignment** | 4 | Anchoring + WYSIATI | UBS.Surface + UBS.UD.UD | UDS.UD blocked (no pain signal yet) |
| **B. Finding Conditions** | **5** | Confirmation bias + Availability | UBS.Surface + UBS.UD + UBS.UD.UD | UDS.UD maximally blocked |
| **C. Generate Outcomes** | 4 | Premature closure + Anchoring | UBS.Surface + UBS.UD | UDS.UD partially blocked |
| **D. Prioritize & Choose** | 4 | Affect heuristic + Sunk cost | UBS.Surface + Org UBS (UT#8) | UDS.UD blocked by social pressure |
| **E.1. Define Scope** | 3 | Optimism bias | UBS.Surface | UDS available (with templates) |
| **E.2. Design Solution** | 4 | Complexity bias + Familiarity | UBS.UD + UBS.UD.UD | UDS.UD intermittently blocked |
| **E.3. Build & Prototype** | 3 | Action bias | UBS.Surface (mild) | UDS.UD available (concrete work) |
| **E.4. Test & Validate** | 4 | Confirmation bias in testing | UBS.Surface + UBS.UD | UDS blocked by emotional investment |
| **E.5. Deliver & Feedback** | 3 | Survivorship bias | UBS.Surface | UDS available (with structure) |
| **E.6. Reflect & Learn** | **5** | Self-serving attribution + Effort aversion | ALL UBS layers | UDS maximally blocked |
| **E.7. Iterate** | 3 | Status quo bias | UBS.Surface | UDS available (gated decision) |
| **E.8. Scale & Sustain** | 4 | Complexity blindness + Normalcy | UBS.UD + Org UBS | UDS blocked by false confidence |

### 4.4 Weakness Heatmap (Visual)

```
HUMAN WEAKNESS EXPOSURE ACROSS THE UEDS

Phase/Stage         WES  ██████████ (1-5 scale)
─────────────────────────────────────────────────
A.  Alignment        4   ████████░░   HIGH
B.  Conditions       5   ██████████   CRITICAL  ← PEAK WEAKNESS
C.  Generate         4   ████████░░   HIGH
D.  Prioritize       4   ████████░░   HIGH
E.1 Scope            3   ██████░░░░   MODERATE
E.2 Design           4   ████████░░   HIGH
E.3 Build            3   ██████░░░░   MODERATE
E.4 Test             4   ████████░░   HIGH
E.5 Deliver          3   ██████░░░░   MODERATE
E.6 Reflect          5   ██████████   CRITICAL  ← PEAK WEAKNESS
E.7 Iterate          3   ██████░░░░   MODERATE
E.8 Scale            4   ████████░░   HIGH

AVERAGE WES: 3.83 — overall HIGH human weakness exposure

CRITICAL ZONES (WES 5):
  → Phase B: Finding Conditions (learning = max UBS opposition)
  → Stage 6: Reflect & Learn (reflection = max UBS opposition)

PATTERN: The most COGNITIVE phases (learning, reflection) are the
most VULNERABLE to human weakness. The most PROCEDURAL phases
(build, deliver, iterate) are the least vulnerable.

IMPLICATION FOR AI: AI should be the primary doer in WES 4-5 zones.
Human should remain the director/reviewer (Accountable, not Responsible).
```

### 4.5 Cross-Cutting Structural Weakness: Sequential Phase Addiction

Beyond individual phase weaknesses, there is a structural weakness that affects the ENTIRE UEDS and is not captured in any single WES score:

**UT#7 Root UBS — "Sequential Phase Addiction":** The deeply ingrained mental model that success requires completing Phase A before starting Phase B, Phase B before C, and so on. This is the UEDS's most fundamental vulnerability because the 5 phases and 8 stages *look* sequential even though UT#10 demands they run as concurrent workstreams.

```
THE SEQUENTIAL PHASE ADDICTION CASCADE (from UT#7 source):

Stage 1 — PHASE LOCKING: Developer "finishes" Phase A (Alignment)
before starting Phase B (Finding Conditions). Feels productive.
But Alignment cannot be truly validated until Phase B reveals
what conditions exist, and Phase C reveals what outcomes are possible.

Stage 2 — FEEDBACK STARVATION: Without concurrent phases, new
information from later phases never flows back to earlier phases.
Phase A alignment assumptions go unchallenged until Phase E
delivery reveals they were wrong. By then, rework cost is enormous.

Stage 3 — SUNK COST LOCK-IN: After months in one phase, the team
feels committed to the outputs of that phase even when new
information suggests revision. "We already approved the scope
document — we can't change it now."

STRUCTURAL WES: 5 (CRITICAL) — This weakness is invisible
in per-phase scoring because it operates BETWEEN phases, not
within them. It is the single most dangerous weakness because
it undermines the entire concurrent workstream architecture
that UT#10 demands.
```

**Connection to UT#6:** Sequential Phase Addiction is powered by Bio-Efficient Forces (UT#6 col 10). Sequential processing requires less executive function than concurrent processing. The brain defaults to the cheaper option — linear phases — even when it knows concurrent workstreams are more effective. This is why every educational system, every project management methodology, and every planning framework defaults to sequential: it is cognitively cheaper, not cognitively better.

**Connection to Reflection (Stage 6):** UT#7's UDS ("Workstream Integration Discipline") requires feedback loop sensitivity — recognizing when output from one workstream should trigger action in another. Stage 6 (Reflect) is the primary mechanism for this feedback, but when treated as a sequential stage (done AFTER execution), it cannot feed its insights back into earlier workstreams in real-time. This is why Stage 6 has WES 5 — it is structurally starved by the sequential layout.

---

## Part 5: Gap Map for AI-Centric Translation (Input to Document 3)

### 5.1 The Core Gap

The UEDS was designed with an implicit assumption: **the Developer is human.** Every stage, step, and sub-step assumes that the primary Doer has human psychology — which means every stage must defend against human psychological weaknesses (UBS from UT#6).

This creates a structural paradox:

```
THE UEDS PARADOX:

The UEDS exists to overcome human UBS in system building.
BUT: The UEDS itself is operated BY humans with UBS.
THEREFORE: The UEDS must defend against the very weaknesses
           it was designed to help humans manage.

This is like asking a patient to perform their own surgery.
The patient knows the procedure, but their hands shake.

RESOLUTION: Make the AI the surgeon (Responsible / Doer).
            Make the human the chief of medicine (Accountable / Director).
```

### 5.2 Specific Gaps for AI Translation

| Gap # | UEDS Assumption | Human Limitation | AI Advantage | Priority |
|-------|----------------|-----------------|-------------|----------|
| G1 | Developer performs UBS/UDS analysis | Confirmation bias distorts analysis | AI has no ego investment in the outcome | CRITICAL |
| G2 | Developer learns conditions (Phase B) | Bio-efficiency resists deep research | AI processes vast information without fatigue | CRITICAL |
| G3 | Developer reflects honestly (Stage 6) | Self-serving attribution distorts lessons | AI reports facts without emotional distortion | CRITICAL |
| G4 | Developer generates diverse options (Phase C) | Premature closure limits solution space | AI can generate systematically without anchoring | HIGH |
| G5 | Developer tests adversarially (Stage 4) | Builder tests to confirm, not to break | AI can test every edge case without emotional bias | HIGH |
| G6 | Developer maintains RACI discipline | Shadow systems override formal roles | AI follows RACI as code — no shadow processes | HIGH |
| G7 | Developer applies V-A-N-A rigorously (Stage 1) | Bio-efficiency shortcuts requirement grammar | AI can enforce V-A-N-A and A.C. validation programmatically | HIGH |
| G8 | Developer prioritizes by analysis (Phase D) | Affect heuristic + social pressure distort | AI ranks by measurable criteria, no social dynamics | HIGH |
| G9 | Developer aligns stakeholders (Phase A) | Anchoring + time pressure rush alignment | AI can systematically probe for misalignment | MODERATE |
| G10 | Developer documents for replication (Stage 8) | Documentation is effort with no immediate reward | AI can generate documentation as a byproduct of execution | MODERATE |
| G11 | Developer iterates willingly (Stage 7) | Status quo bias + sunk cost resist change | AI has no attachment to previous iterations | MODERATE |
| G12 | Developer scales processes (Stage 8) | Complexity blindness misses emergent failures | AI can model and simulate scaling scenarios | MODERATE |
| G13 | Risk management is genuine, not theater (UT#5 FM3) | Surface-level risk checklists create false confidence; risk models not interrogated recursively (Bear Stearns: AAA-rated CDOs, 35:1 leverage, "risk-managed") | AI can apply UT#2 recursively — interrogating the risk management system itself; but AI can ALSO practice UT#5 Theater if its risk checklists are shallow | HIGH |
| G14 | Workstreams run concurrently (UT#10) | Sequential Phase Addiction (UT#7 root UBS) collapses workstreams into linear phases, starving cross-workstream feedback | AI agents can run literal parallel processes; but sequential DAG architecture replicates the same anti-pattern digitally | CRITICAL |

### 5.3 What SURVIVES the AI Translation (Human Strengths)

Not everything changes. These elements rely on human capabilities that AI cannot replicate:

| Element | Why it stays human | RACI Role |
|---------|-------------------|-----------|
| **EO definition** | Requires human judgment about what's worth pursuing | Accountable |
| **Stakeholder alignment** | Requires reading social dynamics, building trust | Accountable |
| **Ethical judgment** | AI can flag but cannot own moral decisions | Accountable |
| **Domain context** | Human understands the "why" behind requirements | Consulted |
| **Final approval** | Human owns the outcome and bears the consequences | Accountable |
| **Creative direction** | Divergent thinking about what SHOULD exist | Accountable |
| **Cultural sensitivity** | Understanding organizational politics and dynamics | Consulted |

### 5.4 The RACI Shift (Summary)

```
HUMAN-CENTRIC UEDS RACI:           AI-CENTRIC UEDS RACI:
R = Human Developer                 R = AI Agent(s)
A = Human Product Owner             A = Human Director
C = Human Domain Expert             C = Human Domain Expert (unchanged)
I = Human Team Members              I = Human + System Logs

KEY SHIFT:
  "Responsible" moves from Human → AI
  "Accountable" stays with Human (ALWAYS)

  Human moves from DOER to DIRECTOR.
  AI moves from TOOL to DOER.

  The human still decides WHAT to build and WHETHER it's good enough.
  The AI decides HOW to build it and DOES the building.
```

### 5.5 Priority Matrix for Document 3

```
PRIORITY FOR AI-CENTRIC TRANSLATION:

    HIGH AI ADVANTAGE ────────────────────────────→
    │
    │  G2 (Learning)         G1 (UBS/UDS Analysis)
    │  G3 (Reflection)       G5 (Testing)
    │                        G6 (RACI Enforcement)
H   │
I   │  G4 (Generation)       G7 (V-A-N-A Enforcement)
G   │  G8 (Prioritization)   G10 (Documentation)
H   │
    │
W   │  G9 (Alignment)        G11 (Iteration)
E   │                        G12 (Scaling)
S   │
    │
    └────────────────────────────────────────────────
                            MODERATE AI ADVANTAGE

CRITICAL PATH (must be addressed first in Doc 3):
  G1 + G2 + G3 = The cognitive triad (analysis, learning, reflection)
  These are the 3 activities where human UBS is strongest and AI
  advantage is greatest. They define the core architecture of the
  AI-Centric UEDS.
```

---

## Appendix A: UT Compliance Verification

Every architectural element in this document traces to at least one UT/DT from Doc 1:

| Document Element | UT/DT Source | Compliance |
|-----------------|-------------|-----------|
| 5 Development Phases | UT#10 (workstream containers, not gates) | Phases are concurrent per UT#10 |
| 8 Stages | UT#9 (org workstreams formalized) | Stages map to WS1–WS6 |
| 4 Evaluation Lenses | UT#5 (S primary) + DT#1 (all components) | Derisking = S; Driving = E; Efficiency = E; Scalability = Sc |
| 4 Iterations | DT#1 + ESD Framework (§1.8) | Concept → Prototype → MVE → Leadership |
| Dual-System Architecture | UT#1 (system = 6 components, applied recursively) | Developer is User of UEDS; End-User is User of UE |
| RACI+ (with DON'Ts) | UT#5 (risk mgmt requires defining what NOT to do) | Standard RACI + explicit exclusions |
| WES Scoring | UT#6 (personal UBS) + UT#8 (org UBS) | Each score traces to specific UBS layer |
| Gap Map | UT#2 (UBS/UDS analysis) + UT#5 (risk mgmt) | Gaps = points where human UBS is bottleneck |
| Sequential Phase Addiction (§4.5) | UT#7 (root UBS) + UT#6 (Bio-Efficient Forces) + UT#10 (concurrent) | Cross-cutting structural weakness; WES 5 |
| G13 UT#5 Theater | UT#5 (FM3) + UT#2 (recursive UBS decomposition) | Risk management must interrogate itself |
| G14 Concurrent Workstreams | UT#7 (Workstream Integration Discipline) + UT#10 | Sequential architecture = digital Sequential Phase Addiction |

---

_End of Document 2. This file provides the complete human-centric UEDS architecture and systematically identifies every human weakness point. Document 3 (AI-Centric UEDS Translation) will use this gap map as its starting input — transforming every WES 4–5 zone into an AI-native process while preserving what humans do best._
