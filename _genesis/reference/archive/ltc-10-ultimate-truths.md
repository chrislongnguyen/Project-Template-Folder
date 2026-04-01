---
version: "1.0"
last_updated: 2026-03-29
owner: "Long Nguyen"
---

# Document 1: The 10 Ultimate Truths — Agent-Readable Codex

_Phase B. Capture Facts & Data | Subject: AI-Centric OE System Design_
_Source: LTC COE EFF, UEDS Training Materials, Effective System Design Framework, Advanced Effective Learning System. Canonical source document: [COE EFF]_[CAM]_0. EFFECTIVENESS OVERVIEW - Personal Chapter Distilled Understanding._
_Date: 2026-03-01 | Version: 1.0_
_Related: Worked examples and scenarios for UT#4–5, UT#6, UT#7 → `BOOK-00 — B. SOURCE — 10 Ultimate Truths (Examples).md` (same folder)._
_Purpose: Single-file reference that any AI agent or human can parse, navigate, and reason from. All logic chains are MECE. All cross-references are explicit._

---

## How to Read This File

Each Ultimate Truth (UT) has: **ID**, **Statement**, **Parent Dependencies** (which UTs it builds on), **Child Implications** (what it enables), **The 6 Workstreams it governs** (from UT#7/9), **Its 3-Pillar evaluation** (from DT#1), and **Its AI-Centric Translation** (how this truth changes when the primary actor shifts from human to AI agent).

Cross-references use the format `UT#n` or `DT#n`. Causal chains use `→` for "therefore" and `⇐` for "because."

---

## Part 1: The 10 Ultimate Truths + 2 Derived Truths

---

### UT#1 — Universal Truth of Systems

**Statement:** We are never doing things by ourselves. We are always a user of a system that includes 6 fundamental components.

**The 6 Components (MECE — no overlaps, no gaps):**

```
┌─────────────────────────────────────────────────────────┐
│                    THE SYSTEM (UT#1)                     │
│                                                         │
│   ┌──────────┐                                          │
│   │  INPUT   │ (external trigger / requirement)         │
│   └────┬─────┘                                          │
│        ▼                                                │
│   ┌──────────┐    governed by    ┌──────────────────┐   │
│   │   USER   │ ──────────────── │   PRINCIPLES     │   │
│   │  (Doer)  │                   │  of the Action   │   │
│   └────┬─────┘                   └──────────────────┘   │
│        │ performs                        ▲               │
│        ▼                                │ derived from   │
│   ┌──────────┐    using         ┌──────────────────┐   │
│   │  ACTION  │ ───────────────→ │  TOOLS used in   │   │
│   │          │                   │  the Action      │   │
│   └────┬─────┘                   └──────────────────┘   │
│        │ within                                         │
│        ▼                                                │
│   ┌──────────────────┐                                  │
│   │   ENVIRONMENT    │                                  │
│   │   of the Action  │                                  │
│   └────┬─────────────┘                                  │
│        │ produces                                       │
│        ▼                                                │
│   ┌──────────┐                                          │
│   │ OUTCOME  │                                          │
│   └──────────┘                                          │
└─────────────────────────────────────────────────────────┘
```

**Component Definitions (MECE):**

| #   | Component       | Definition                                                                                                                                | Boundary (what it is NOT)                                                                |
| --- | --------------- | ----------------------------------------------------------------------------------------------------------------------------------------- | ---------------------------------------------------------------------------------------- |
| 1   | **Input**       | The external trigger, requirement, or stimulus that initiates the system cycle.                                                           | Not the User's internal motivation (that lives in UDS per UT#2).                         |
| 2   | **User (Doer)** | The actor who performs the action. Can be human, AI agent, or hybrid.                                                                     | Not the beneficiary of the outcome (that may be a different stakeholder).                |
| 3   | **Action**      | The specific work performed by the User to transform Input into Outcome.                                                                  | Not the process design (that is the EOP — the meta-description of actions).              |
| 4   | **Principles**  | The governing rules that determine HOW the action must be performed to achieve the desired outcome. Derived from UBS/UDS analysis (UT#2). | Not generic best practices. Must trace to specific blockers or drivers.                  |
| 5   | **Tools**       | The instruments used by the User during the Action. Includes software, hardware, frameworks, templates.                                   | Not the environment (Tools are portable; Environment is contextual).                     |
| 6   | **Environment** | The conditions surrounding the Action. Includes physical space, digital workspace, cultural norms, time constraints, energy state.        | Not the tools (Environment is the context; Tools are the instruments within it).         |
| 7   | **Outcome**     | The result produced by the Action. Evaluated against the User's Desired Outcome (EO).                                                    | Not the Input to the next cycle (though it may become one — that is a new system cycle). |

**Parent Dependencies:** None. This is the root truth — axiomatic.
**Child Implications:** UT#2 (Principles must overcome UBS/activate UDS), UT#3 (requirements expressed as Verb-Adverb-Noun-Adjective mapping to these 6 components), DT#1 (all 6 components must be Sustainable, Efficient, Scalable).

---

### UT#2 — Why Effective Principles Are Required

**Statement:** The outcome of any system is always hindered by a collection of blockers (the Ultimate Blocking System, UBS) and driven by a collection of drivers (the Ultimate Driving System, UDS). The best outcome requires the best approach to overcome the UBS and utilize the UDS. Such an approach is described by the Effective Principles (EP).

**Causal Logic (MECE):**

```
OUTCOME quality = f(EP quality)
EP quality     = f(UBS understanding × UDS understanding)

Where:
  UBS = the system of forces PREVENTING the desired outcome
  UDS = the system of forces DRIVING toward the desired outcome
  EP = principles that DISABLE UBS elements + ENABLE UDS elements

The relationship is recursive:
  UBS has its own drivers (UBS.UD) and blockers (UBS.UB)
  UDS has its own drivers (UDS.UD) and blockers (UDS.UB)
  Each layer deeper: UBS.UD.UD, UBS.UD.UB, UBS.UB.UD, UBS.UB.UB, etc.
```

**Recursive Notation (dot-notation — canonical):**

```
UBS        = root blocker
UBS.UD     = what drives the UBS harder    → works AGAINST User
UBS.UB     = what disables the UBS         → works FOR User
UDS        = root driver
UDS.UD     = what drives the UDS further   → works FOR User
UDS.UB     = what blocks the UDS           → works AGAINST User

Deeper layers follow the same logic:
UBS.UD.UD  = what drives the driver of UBS → deeper AGAINST
UBS.UD.UB  = what blocks the driver of UBS → deeper FOR
...and so on.
```

**Key Insight (populated — missing from source):** The UBS and UDS are not independent. They share causal forces. As documented in the Advanced Effective Learning System:

- **Bio-Efficient Forces** appear as UBS.UD.UD (drives the blocker) AND UDS.UD.UB (blocks the driver). One force, two roles.
- **Support System Belief** appears as UBS.UD.UB (blocks the driver of UBS = FOR User) AND UDS.UB.UB (blocks the blocker of UDS = FOR User). One force, two roles — both favoring the User.

```
                SHARED FORCES MAP

Bio-Efficient    ──drives──→  UBS.UD (fast system)  ──drives──→  UBS (biases)
Forces           ──blocks──→  UDS.UD (slow system)  ──drives──→  UDS (reasoning)

                 NET EFFECT: Strengthens blockers, weakens drivers.
                 DESIGN RESPONSE: Reduce conditions where bio-efficiency dominates.

Support System   ──blocks──→  UBS.UD (fast system)  ──drives──→  UBS (biases)
Belief           ──blocks──→  UDS.UB (fast system)  ──blocks──→  UDS (reasoning)

                 NET EFFECT: Weakens blockers, strengthens drivers.
                 DESIGN RESPONSE: Provide trusted support systems (AI, templates, process).
```

**Parent Dependencies:** UT#1 (Principles are one of the 6 components).
**Child Implications:** UT#5 (UBS influence > UDS influence for valuable outcomes), UT#6 (personal UBS = psychological biases), UT#8 (organizational UBS = collective biases), DT#1 (EP must be S/E/Sc).

---

### UT#3 — Requirements Grammar (Verb-Adverb-Noun-Adjective)

**Statement:** The key requirements by any Doer/User can always be simplified into a deliverable with 4 elements: Verb, Adverb, Noun, Adjective.

**Mapping to UT#1 Components:**

```
┌──────────────────────────────────────────────────────────────┐
│  REQUIREMENT = VERB + ADVERB + NOUN + ADJECTIVE              │
│                                                              │
│  VERB     ← maps to → ACTION (component 6 of UT#1)          │
│              "What the User does"                            │
│              Example: "Track", "Analyze", "De-risk"          │
│                                                              │
│  ADVERB   ← maps to → OUTCOME quality (component 7 of UT#1) │
│              "How the action must perform"                   │
│              Always evaluated via 3 Pillars (DT#1):          │
│              Sustainably, Efficiently, Scalably              │
│                                                              │
│  NOUN     ← maps to → TOOLS + ENVIRONMENT + PRINCIPLES      │
│              (components 4, 5, 6 of UT#1)                    │
│              "What enables the action"                       │
│              Example: "Dashboard", "Agent Team", "Workflow"  │
│                                                              │
│  ADJECTIVE← maps to → Effectiveness of the NOUN             │
│              "What qualities the Noun must have"             │
│              Also evaluated via 3 Pillars (DT#1):            │
│              Sustainable, Efficient, Scalable                │
└──────────────────────────────────────────────────────────────┘
```

**Acceptance Criteria Rule (populated — implicit in source, made explicit):** Each element (Verb, each Adverb, Noun, each Adjective) must have at least one binary, deterministic Acceptance Criterion (A.C.). An A.C. is: Atomic (tests one thing), Binary (pass/fail), Deterministic (same input → same result regardless of evaluator).

**Source learner example (verbatim):** An effective user requirement has: verb → action; adverb → action's outcome; noun → Tools, Environment (inherent), Principles (implicit or explicit), User experience (UX); adjective → effectiveness of the noun. From original: _Sản phẩm mình thành công hơn so với competitor là vì sản phẩm của mình adj effective hơn_ — "Our product succeeds more than the competitor's because our product is [adjective] more effective."

**Parent Dependencies:** UT#1 (the 6 components being mapped), UT#2 (Principles as part of Noun).
**Child Implications:** DT#1 (Adverbs and Adjectives decompose into S/E/Sc), ESD Phase 3 (formalization of all requirements in this grammar).

---

### UT#4 — Success Definition: Approach 1 (Perfect World)

**Statement:** Success = Optimal Value Creation for a Given Amount of Resources.

**Logic:** In a hypothetical world with no uncertainty and no failure risk, success is purely about maximizing output per unit of input. This is the classical efficiency definition.

**Root UBS — "The Completeness Illusion" (populated from source):** The belief that optimizing output is sufficient for success. This illusion persists because it is partially correct in controlled environments — optimization theory (Mathematics), marginal utility (Economics), and information theory all validate that more output per unit input IS better, _holding all else equal_. The danger: "all else" is never equal for valuable outcomes. Goodhart's Law (Psychology/Sociology): "When a measure becomes a target, it ceases to be a good measure." Optimizing the visible metric (output) creates blind spots in invisible metrics (risk, fragility, sustainability).

**Root UDS (populated from source):** Resource Allocation Intelligence + Value Definition Clarity — the capacity to distinguish between activities that produce visible output and activities that produce durable value. Requires: knowing what to optimize FOR (not just what to optimize), and accepting that some resources must be allocated to non-output activities (risk management, learning, reflection).

**Why this is insufficient (bridge to UT#5):** This approach assumes:

1. All paths lead to some degree of success (no catastrophic failure).
2. The probability distribution of outcomes is known and symmetric.
3. Resources are not at risk of total loss.

In reality, none of these hold for outcomes worth pursuing. Hence UT#5.

**Parent Dependencies:** UT#1 (outcome as system component).
**Child Implications:** UT#5 (the realistic correction).

---

### UT#5 — Success Definition: Approach 2 (Real World)

**Statement:** Because the UBS has stronger influence than the UDS for valuable outcomes, Success in reality is about efficient and scalable management of failure risks more than maximizing work output.

**Causal Logic:**

```
For valuable outcomes (worth pursuing):
  Failure paths >> Success paths
  UBS influence > UDS influence
  Therefore:
    Maximizing output (UT#4) is secondary
    Managing failure risk is primary

  Success = Efficient & Scalable Risk Management

  This yields the 3 Pillars of Effectiveness:
    1. SUSTAINABILITY — manage failure risks (FIRST PRIORITY)
    2. EFFICIENCY     — optimal output at current resources (SECOND)
    3. SCALABILITY    — optimal output gain per resource increase (THIRD)
```

**The 3 Pillars — Priority Order (always this sequence):**

```
SUSTAINABILITY ──gates──→ EFFICIENCY ──gates──→ SCALABILITY

Sustainability must be satisfied before Efficiency is pursued.
Efficiency must be satisfied before Scalability is pursued.
A non-sustainable system is ineffective regardless of efficiency.
An inefficient system cannot scale.
```

**Pillar Definitions (canonical):**

| Pillar             | Definition                                                  | Question it answers                                                                                   | Gates                                                                         |
| ------------------ | ----------------------------------------------------------- | ----------------------------------------------------------------------------------------------------- | ----------------------------------------------------------------------------- |
| **Sustainability** | The management of failure risks to ensure survival.         | "Can it fail catastrophically? Have we eliminated ruin risk?"                                         | Everything. If not sustainable, stop.                                         |
| **Efficiency**     | The optimal output of de-risking at current resources.      | "Are we getting the most risk-reduction per unit of time/money/energy we currently have?"             | Scalability. Only optimize for growth after current operations are efficient. |
| **Scalability**    | The optimal gain in de-risking relative to resource growth. | "When we add more resources, does our risk-management capability grow faster than our risk exposure?" | Nothing — this is the aspiration layer.                                       |

**Root UBS — "The Optimism-Urgency Complex" (populated from source):** A self-reinforcing system of two biases. Stage 1 — Optimism Bias inflates expected value of success while deflating expected cost of failure (Psychology: Sharot, 2011; Weinstein, 1980). Stage 2 — Urgency Bias creates pressure to produce visible output quickly, rewarding action over prevention (Biology: dopamine reward for completion, not for risk avoided). Stage 3 — Reinforcing Loop: output IS rewarded (promotions, recognition, dopamine), while prevention is INVISIBLE (nothing bad happened — but was that luck or skill?). The three stages compound: optimism → urgency → action → visible reward → more optimism.

**Root UDS — "The Asymmetry Recognition System" (populated from source):** The capacity to recognize that loss and gain are NOT symmetric — that a 60% loss requires a 150% gain to recover (Jensen's inequality applied to returns). Consists of: (i) Statistical literacy — understanding fat tails, convexity of loss, base rates; (ii) Inversion thinking — asking "how can this fail?" before "how can this succeed?" (Munger, Taleb: via negativa); (iii) First-principles decomposition — tracing risk to root causes rather than managing symptoms.

**5 Failure Modes of UT#5 (from falsification challenge — see Examples file):**

```
FM1: UT#5 WITHOUT ALIGNMENT (UT#7/WS1) — managing the wrong risks
FM2: UT#5 WITHOUT UT#4 (gate never opens) — perpetual hedging, slow bleed
FM3: UT#5 THEATER — surface compliance, no depth (Bear Stearns)
FM4: UT#5 AT WRONG SYSTEM LEVEL — risk at one level, fragile at another
FM5: TIME HORIZON MISMATCH — right over 20 years, wrong over 5
```

**Critical refinement:** UT#5 is the strongest truth — but it is one truth in a system of 10. Practiced in isolation, it produces survival without success. Practiced in concert with all 10, it produces durable, compounding success. The 3-Pillar gate is bidirectional: Sustainability gates Efficiency, but Efficiency also CHECKS Sustainability (prevents pathological over-hedging).

**Parent Dependencies:** UT#2 (UBS > UDS for valuable outcomes), UT#4 (the insufficient perfect-world definition).
**Child Implications:** DT#1 (all system components must incorporate S/E/Sc), DT#2 (all workstreams must incorporate S/E/Sc), UT#7/UT#9 (workstreams are the process to achieve this risk management).

---

### UT#6 — Personal UBS and UDS

**Statement:** For personal success: the UBS is our system of psychological biases, and the UDS is our system of logical & analytical reasoning.

**Named Root UBS — Bio-Efficient Forces / System 1 Dominance (populated from source):** The biological imperative to conserve cognitive energy by defaulting to fast, automatic, low-effort processing. Four bias clusters: (i) Pattern-completion: confirmation bias, anchoring, availability heuristic; (ii) Loss-aversion: loss aversion (~2.25x weighting per Kahneman & Tversky, 1979), sunk cost fallacy, status quo bias; (iii) Social: herd behavior, authority bias, social proof; (iv) Self-serving: overconfidence, self-attribution bias, hindsight bias.

**Named Root UDS — The Deliberate Reasoning System (populated from source):** The capacity for structured, evidence-based, logically consistent analysis. Three components: (i) Metacognition — awareness of one's own thinking processes, detecting when System 1 is producing biased output (Flavell, 1979); (ii) Logical framework application — disciplined use of reasoning structures (deduction, induction, Bayesian updating); (iii) Evidence-based calibration — updating beliefs based on evidence rather than feelings (Tetlock: superforecasters outperform by updating frequently and incrementally).

**Three-Layer Failure Cascade (populated from source):**

```
Layer 1 — ENERGY CONSERVATION: System 2 consumes significantly more
glucose and attention. Brain defaults to the cheaper processor (System 1)
for ALL decisions unless explicitly triggered. This is metabolic
optimization — not laziness.

Layer 2 — INVISIBLE OPERATION: Biases operate below conscious awareness.
The individual does not experience "I am being biased" — they experience
"I am certain" or "this feels right." The bias masquerades as insight.

Layer 3 — EGO REINFORCEMENT: When System 1 produces a decision, the ego
invests in it. Contradicting evidence becomes a threat to self-image.
System 2 is then recruited not to CHALLENGE the decision but to DEFEND it.
At this stage, System 2 becomes a tool OF the bias, not against it.
(Kunda, 1990: motivated reasoning)
```

**Success Principles (populated from source):** P1: Detect before you decide — pause and ask "am I in System 1 or System 2?" before consequential decisions (enables Metacognition). P2: Structure beats intuition for consequential decisions — use checklists, decision matrices, pre-mortems (Gawande: checklists reduce surgical mortality 47%; Meehl: statistical prediction outperforms clinical judgment 60-70%). P3: Seek disconfirmation, not confirmation — actively search for contradicting evidence (Popper: falsifiability; Nickerson, 1998).

**Anti-Principles (populated from source):** Anti-P1: "Trust your gut" — conflates expert intuition (valid in predictable, high-repetition domains) with naive intuition (invalid in complex, uncertain domains). Anti-P2: "I'm not biased" — the bias blind spot; knowing about biases provides no protection without structural tools (Pronin et al., 2002). Anti-P3: "Follow the consensus" — herd behavior; dangerous in domains where consensus is systematically wrong (Asch: 75% conformed to obviously wrong answers).

**Detailed Breakdown (populated from Advanced Effective Learning System):**

```
PERSONAL UBS (Psychological Biases)
├── Surface: 3 categories of bias
│   ├── Survival biases (safety-first reactions)
│   ├── Emotional biases (feel-good reasoning)
│   └── Cognitive biases (WYSIATI, anchoring, confirmation)
│
├── UBS.UD: Fast, subconscious system (System 1)
│   ├── Principles: safety first → feeling good → "reasonable enough"
│   ├── Actions: quick "good enough" solutions, heuristics, association
│   └── Ideal conditions: unsafe, high cognitive load, pressure, low energy
│
├── UBS.UD.UD: Bio-Efficient Forces (deepest driver of UBS)
│   ├── Principles: "good enough" efficiency, autopilot mode
│   └── Actions: reduce cognitive load, conserve energy
│
└── UBS.UD.UB: Support System Belief (blocker of the UBS driver)
    ├── Principles: safe, fun, low-energy, accuracy-assured
    └── Actions: assure brain it can think well with minimal energy

PERSONAL UDS (Logical & Analytical Reasoning)
├── Surface: deep, deliberate reasoning
│   ├── Principles: truth-finding, skepticism, completeness
│   └── Actions: self-correction, critical evaluation, strategic planning
│
├── UDS.UD: Slow, conscious system (System 2)
│   ├── Principles: sequential steps, accuracy over speed, deliberate
│   └── Ideal conditions: low cognitive load, high resources, safety
│
├── UDS.UD.UD: Evolutionary Forces (deepest driver of UDS)
│   ├── Principles: conflict detection, cost-benefit, goal maintenance
│   └── Ideal conditions: high stakes, novelty, pain of failure
│
├── UDS.UD.UB: Bio-Efficient Forces (blocks the UDS driver)
│   └── SAME FORCE as UBS.UD.UD — one force, inverted role
│
├── UDS.UB: Fast System (blocks UDS — same machinery as UBS.UD)
│
└── UDS.UB.UB: Support System Belief (blocks the UDS blocker)
    └── SAME FORCE as UBS.UD.UB — one force, inverted role
```

**Design Implication:** To improve personal outcomes → Reduce conditions favoring Bio-Efficient Forces (weakens UBS, strengthens UDS simultaneously) + Increase Support System Belief (weakens UBS, strengthens UDS simultaneously). Two interventions, four effects.

**Parent Dependencies:** UT#2 (UBS/UDS framework), UT#5 (why managing the UBS matters more).
**Child Implications:** UT#7 (the 6 workstreams as process for managing personal UBS/UDS), UT#8 (organizational extension).

---

### UT#7 — The 6 Workstreams for Personal Success

**Statement:** The process of achieving success (efficient & scalable risk management) for humans includes 6 workstreams.

**Named Root UDS — Workstream Integration Discipline (populated from source):** The capacity to maintain all 6 workstreams simultaneously without collapsing them into sequential phases. Three components: (i) Concurrent awareness — holding multiple workstreams in active attention, switching as context demands (Psychology: executive function; Neuroscience: prefrontal cortex); (ii) Feedback loop sensitivity — recognizing when output from one workstream should trigger action in another (e.g., learning reveals risk → risk management activates → execution adjusts); (iii) Priority fluidity — shifting effort to whichever workstream is most bottlenecked without abandoning the others (Goldratt: Theory of Constraints).

**Named Root UBS — Sequential Phase Addiction (populated from source):** The deeply ingrained mental model that success is achieved through a linear sequence: learn → plan → execute → review. Reinforced by: (i) Educational conditioning — 16+ years of read → exercise → test → next chapter; (ii) Organizational culture — Waterfall, stage-gate processes, annual planning; (iii) Cognitive comfort — sequential processing requires less executive function than concurrent processing (UT#6: Bio-Efficient Forces prefer the cheaper option).

**Three-Stage Failure Cascade (populated from source):**

```
Stage 1 — PHASE LOCKING: "I need to learn everything about agents
before I start building one." Feels productive (progress in one domain)
but blocks feedback from other workstreams.

Stage 2 — FEEDBACK STARVATION: Without concurrent workstreams, no
cross-workstream feedback. Risks not identified until a "risk phase."
Learning not validated until an "execution phase." By then, rework
cost is enormous.

Stage 3 — SUNK COST LOCK-IN: After investing heavily in one phase,
the individual feels committed even when new information suggests
change. "I've spent 3 months learning this framework — I can't
switch now." UT#6's sunk cost bias operating at the process level.
```

**Anti-Principles (populated from source):** Anti-P1: "Learn first, build later" — partially correct (need premises before conclusions) but dangerous when absolute; building IS learning (UT#10). Anti-P2: "Finish what you started before switching" — derived from sunk cost psychology; in uncertain environments, changing direction based on new information IS the mechanism of success. Anti-P3: "Planning is separate from execution" — derived from industrial-era management (Taylor); in complex environments, plan and execution must co-evolve.

**Minor Tension — What BUILDS Workstream Integration Discipline?** The source names what Sequential Phase Addiction is caused by (educational conditioning, organizational culture, cognitive comfort) but is thinner on what specifically builds the UDS. For humans, it requires: deliberate practice in context-switching, accountability structures that check all 6 workstreams regularly, and environments that reward adaptation over completion. For AI agents, this tension resolves differently: AI does not suffer from educational conditioning or sunk cost psychology, so Sequential Phase Addiction is NOT the AI's natural default — UNLESS we accidentally encode it through sequential DAG/pipeline architecture. The AI-centric UDS is therefore "Concurrent Architecture Design" — the discipline of building agent workflows as event-driven loops with cross-workstream message passing, not as sequential pipelines. (See Doc 3 for full AI translation.)

**The 6 Workstreams:**

| #   | Workstream                               | What it does                                                   | Maps to UT#1 Component                             |
| --- | ---------------------------------------- | -------------------------------------------------------------- | -------------------------------------------------- |
| WS1 | **Alignment**                            | Choose the right definition of successful outcome              | Input + Outcome (defining what success looks like) |
| WS2 | **Risk Management**                      | Minimize failure risks in every step                           | Principles (the governing rules derived from UBS)  |
| WS3 | **Effective Learning**                   | Find truths and premises to think with                         | Environment (acquiring accurate information)       |
| WS4 | **Effective Thinking**                   | Generate possible outcomes                                     | Action (the cognitive work of analysis)            |
| WS5 | **Effective Decision Making & Planning** | Prioritize and choose outcomes to execute                      | Action (selecting from generated possibilities)    |
| WS6 | **Effective Execution**                  | Execute with effective process, capability, tools, environment | Tools + Environment + Action (the doing)           |

**Critical: These are WORKSTREAMS, not PHASES (see UT#10).** They run concurrently.

**Workstream Concurrency Diagram:**

```
TIME ──────────────────────────────────────────────────────→

WS1 Alignment         ████░░░░████░░░░████░░░░████░░░░████
WS2 Risk Management   ████████████████████████████████████████
WS3 Effective Learning ░░████░░░░████░░░░████░░░░████░░░░████
WS4 Effective Thinking ░░░░████░░░░████░░░░████░░░░████░░░░██
WS5 Decision & Plan   ░░░░░░████░░░░████░░░░████░░░░████░░░░
WS6 Execution         ░░░░░░░░████████░░░░████████░░░░██████

Legend: ████ = active   ░░░░ = dormant (but resumable instantly)

Key observations:
- WS2 (Risk Mgmt) is ALWAYS active — never dormant
- All workstreams pulse — they activate, produce, pause, reactivate
- No workstream waits for another to "finish" — they inform each other
- Information flows bidirectionally between any pair of workstreams
```

**Parent Dependencies:** UT#5 (success = risk management), UT#6 (personal UBS/UDS to be managed).
**Child Implications:** UT#9 (organizational version), UT#10 (concurrent, not sequential), DT#2 (each workstream must be S/E/Sc).

---

### UT#8 — Organizational UBS and UDS

**Statement:** For team/organizational success: the UBS is human-related biases (including nature & character flaws harmful for team performance, and psychological biases harmful for individuals to see truths). These lead to unofficial/shadow operating systems. The UDS is the collective logical & analytical reasoning capability.

**Expanded Structure (populated — connecting UT#6 to organizational level):**

```
ORGANIZATIONAL UBS (Collective Human Biases)
├── Layer 1: Individual psychological biases (from UT#6)
│   └── Each member carries their own UBS (System 1 dominance)
│
├── Layer 2: Interpersonal friction
│   ├── Character differences → goal misalignment
│   ├── Communication failures → information loss
│   └── Power dynamics → suppressed dissent
│
├── Layer 3: Structural/systemic biases
│   ├── Shadow operating systems (unofficial processes)
│   ├── Institutional inertia (resistance to change)
│   └── Information silos (knowledge trapped in teams)
│
└── CRITICAL INSIGHT: The unofficial system IS the system.
    The org chart says one thing; the shadow system decides reality.
    Any OE System that ignores the shadow system will fail.

ORGANIZATIONAL UDS (Collective Reasoning Capability)
├── Individual reasoning capacity (from UT#6) × number of members
├── Collaborative reasoning (team-level — greater than sum of parts)
│   ├── Diverse perspectives → wider solution space
│   ├── Peer review → error detection (self-disassociation per UT#6)
│   └── Structured knowledge sharing → compounding capability
│
└── Organizational reasoning infrastructure
    ├── Documented processes, frameworks, templates
    ├── Knowledge bases, learning systems (COE structure)
    └── Decision-making protocols (reduces reliance on individual judgment)
```

**Parent Dependencies:** UT#6 (individual biases as building blocks), UT#2 (UBS/UDS framework).
**Child Implications:** UT#9 (organizational workstreams), the UEDS (the meta-system designed to overcome organizational UBS).

---

### UT#9 — The 6 Workstreams for Organizational Success

**Statement:** The process of achieving success for a team or organization includes the same 6 workstreams as UT#7, but at the organizational level.

**Workstreams (identical structure, organizational scope):**

| #   | Workstream | Personal (UT#7)                 | Organizational (UT#9)                     |
| --- | ---------- | ------------------------------- | ----------------------------------------- |
| WS1 | Alignment  | Choose my definition of success | Choose the team/org definition of success |
| WS2 | Risk Mgmt  | Minimize my failure risks       | Minimize team/org failure risks           |
| WS3 | Learning   | Find truths for me to think     | Find truths for the org to think          |
| WS4 | Thinking   | Generate my possible outcomes   | Generate org-level possible outcomes      |
| WS5 | Decision   | Prioritize and choose my plan   | Prioritize and choose org-level plan      |
| WS6 | Execution  | Execute with my tools/env       | Execute with org tools/env/processes      |

**Organizational hierarchy (from source):** Level 1 — Shared value; Level 2 — Resources (2.1 Capacity: HR→User, Non-HR→Tools; 2.2 Capability: HR→User, Non-HR→Tools); Level 3 — Operation→Action; Level 4 — Culture. The 6 workstreams operate within this structure.

**Application to Product/System Development:** Design thinking is an organizational application of UT#9 — it involves teams of humans running all 6 workstreams concurrently to design and deliver systems for users.

**Application to UEDS:** The User Enablement Delivery System (UEDS) is the formalized implementation of UT#9 for the specific purpose of building UE systems. The UEDS codifies the 6 workstreams into 5 Development Phases, 8 Stages, and ~26 sub-steps — but the underlying logic is still 6 concurrent workstreams (UT#10).

**Parent Dependencies:** UT#7 (personal workstreams as basis), UT#8 (organizational UBS/UDS to be managed).
**Child Implications:** UT#10 (workstreams run concurrently), UEDS (the concrete system implementing these workstreams), DT#2 (each workstream must be S/E/Sc).

---

### UT#10 — Workstreams, Not Phases

**Statement:** The success process includes workstreams, not phases, stages or steps because life is highly uncertain. The most effective approach to deal with uncertainty and achieve best possible outcome is to do these 6 workstreams concurrently, not sequentially.

**Why Concurrent, Not Sequential:**

```
SEQUENTIAL (anti-pattern):
  Align → Learn → Think → Decide → Execute → Manage Risk

  PROBLEM: By the time you reach "Execute", your "Alignment"
  may be outdated. By the time you "Manage Risk", the risks
  have already materialized in the Execute phase.

CONCURRENT (UT#10 pattern):
  All 6 workstreams active simultaneously, pulsing at different
  intensities, informing each other in real-time. They are not
  perfectly parallel — incremental value creation plus incremental
  improvement (continuous delivery and continuous improvement).

  WHY IT WORKS:
  1. Uncertainty means new information arrives constantly
  2. Each workstream can immediately absorb new information
  3. Risk Management is always active, not deferred to a "phase"
  4. Alignment is continuously validated, not assumed fixed
```

**Relationship to Agile:** UT#10 is the theoretical foundation for agile principles. Agile manifests UT#10 as: continuous delivery (WS6), continuous improvement (WS2+WS3), adaptive planning (WS5), iterative development (WS4+WS6).

**Relationship to UEDS Phases:** The UEDS has 5 phases (A through E) which APPEAR sequential, but in practice: Phase E (Design & Delivery) loops back to Phase A (Alignment) continuously. Within Phase E, the 8 stages form a cycle, not a waterfall. The phases are organizational containers for workstreams — NOT gates that must complete before the next begins.

```
UEDS PHASES AS WORKSTREAM CONTAINERS (not sequential gates):

Phase A (Alignment)        → primarily WS1 + WS2
Phase B (Finding Cond.)    → primarily WS3 + WS2
Phase C (Generate)         → primarily WS4 + WS2
Phase D (Prioritize)       → primarily WS5 + WS2
Phase E (Design & Deliver) → primarily WS6 + WS2 (+ all others looping)

Note: WS2 (Risk Management) appears in EVERY phase.
This is why it is always active in the concurrency diagram.
```

**Parent Dependencies:** UT#7/UT#9 (the 6 workstreams), UT#5 (uncertainty and risk as primary concern).
**Child Implications:** UEDS design (stages form loops, not waterfalls), AI-centric OE System design (agents run workstreams as parallel processes, not sequential pipelines).

---

### DT#1 — Derived Truth: 3 Pillars Apply to All System Components

**Statement:** (Derived from UT#1 + UT#5) Every component of the system — Principles, Environment, Tools, and Processes — must incorporate all 3 aspects of effectiveness: Sustainability, Efficiency, Scalability.

**Application Matrix:**

| UT#1 Component    | Sustainable?                             | Efficient?                                           | Scalable?                                                 |
| ----------------- | ---------------------------------------- | ---------------------------------------------------- | --------------------------------------------------------- |
| **Principles**    | Do they manage failure risks?            | Are they the leanest set that achieves de-risking?   | Do they work across more domains without rewriting?       |
| **Environment**   | Is it safe, low-pressure, bias-reducing? | Is it optimized for current resources?               | Does it onboard new members/contexts cheaply?             |
| **Tools**         | Are they reliable, secure, non-fragile?  | Do they maximize output per unit cost?               | Do they handle growth without proportional cost increase? |
| **Process (EOP)** | Does every step have a risk gate?        | Is each step the minimum needed for quality?         | Can steps be templated and reused across domains?         |
| **Actions**       | Do they avoid catastrophic error?        | Do they produce maximum value per time unit?         | Do they compound in capability over repetitions?          |
| **Outcomes**      | Are they correct and safe?               | Are they the best achievable with current resources? | Do they improve with each iteration?                      |

**Parent Dependencies:** UT#1 + UT#5.
**Child Implications:** DT#2, all system design (every component evaluated on all 3 pillars).

---

### DT#2 — Derived Truth: 3 Pillars Apply to All Workstreams

**Statement:** (Derived from UT#5 + UT#7 + UT#9) The same 3 aspects of effectiveness apply to: (1) Effective User Requirements (UT#3), and (2) every workstream — Effective Alignment, Effective Learning, Effective Thinking, Effective Decision Making & Planning, Effective Execution. Each must incorporate Sustainability, Efficiency, Scalability.

| Workstream    | Sustainable                                    | Efficient                                       | Scalable                                           |
| ------------- | ---------------------------------------------- | ----------------------------------------------- | -------------------------------------------------- |
| WS1 Alignment | Alignment validated against failure modes      | Alignment achieved with minimum meetings/effort | Alignment cascades to new teams without reteaching |
| WS2 Risk Mgmt | Risks monitored continuously, not periodically | Highest-impact risks addressed first (Pareto)   | Risk frameworks reusable across new domains        |
| WS3 Learning  | Learning avoids bias (safe, low-pressure)      | Highest-leverage truths learned first           | Learning compounds; each subject makes next easier |
| WS4 Thinking  | Thinking checked for cognitive biases          | Structured frameworks reduce waste in ideation  | Thinking templates reusable across problems        |
| WS5 Decision  | Decisions have reversibility assessment        | Decisions made with minimum viable analysis     | Decision frameworks work for bigger/new decisions  |
| WS6 Execution | Execution has rollback/recovery procedures     | Execution minimizes waste and rework            | Execution processes template for new projects      |

**Parent Dependencies:** UT#5, UT#7, UT#9, DT#1.
**Child Implications:** All system design, UEDS evaluation, AI-centric UEDS design.

---

## Part 2: Dependency Map (Full Interconnection)

```
                        DEPENDENCY MAP

                     ┌──────────┐
                     │   UT#1   │  Universal System (6 components)
                     │  [ROOT]  │
                     └────┬─────┘
                          │
              ┌───────────┼───────────┐
              ▼           ▼           ▼
         ┌────────┐  ┌────────┐  ┌────────┐
         │  UT#2  │  │  UT#3  │  │  UT#4  │
         │UBS/UDS │  │V-A-N-A │  │Success │
         │Princip.│  │Grammar │  │Perfect │
         └───┬────┘  └────────┘  └───┬────┘
             │                       │
             ▼                       ▼
        ┌────────┐              ┌────────┐
        │  UT#5  │◄─────────────│  UT#4  │
        │Success │  (corrects)  │        │
        │Real    │              └────────┘
        └───┬────┘
            │
     ┌──────┼──────┐──────────────────┐
     ▼      ▼      ▼                  ▼
┌────────┐┌────────┐            ┌──────────┐
│  UT#6  ││  DT#1  │            │   DT#2   │
│Personal││3 Pillar│            │3P → WS   │
│UBS/UDS ││→ Comps │            │          │
└───┬────┘└────────┘            └──────────┘
    │                                 ▲
    ▼                                 │
┌────────┐                            │
│  UT#7  │  6 Personal Workstreams    │
└───┬────┘                            │
    │                                 │
    ▼                                 │
┌────────┐                            │
│  UT#8  │  Org UBS/UDS               │
└───┬────┘                            │
    │                                 │
    ▼                                 │
┌────────┐                            │
│  UT#9  │  6 Org Workstreams ────────┘
└───┬────┘
    │
    ▼
┌────────┐
│ UT#10  │  Workstreams, Not Phases
└───┬────┘
    │
    ▼
┌─────────────────────────────────────┐
│           UEDS / OE System          │
│  (The concrete implementation of    │
│   all 10 UTs + 2 DTs as a system)   │
└─────────────────────────────────────┘
```

---

## Part 3: AI-Centric Translation Summary

For each UT, a brief note on what changes when the primary Doer shifts from human to AI agent. Full treatment in Document 3.

| UT    | Human-Centric                                                                                                                   | AI-Centric                                                                                                                                                                                                              | What Survives                                                        | What Changes                                                                                                                                                   |
| ----- | ------------------------------------------------------------------------------------------------------------------------------- | ----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------- | -------------------------------------------------------------------- | -------------------------------------------------------------------------------------------------------------------------------------------------------------- |
| UT#1  | 6 components with human as User                                                                                                 | Same 6 components; User can be AI agent, human, or hybrid                                                                                                                                                               | The 6-component structure is universal                               | "User" now includes non-human actors                                                                                                                           |
| UT#2  | UBS/UDS with recursive depth                                                                                                    | Same recursive framework                                                                                                                                                                                                | The recursive UBS/UDS decomposition                                  | The CONTENT of UBS/UDS changes (see below)                                                                                                                     |
| UT#3  | V-A-N-A requirement grammar                                                                                                     | Same grammar; agents parse it natively                                                                                                                                                                                  | The grammar is universal                                             | Agents can validate A.C.s programmatically                                                                                                                     |
| UT#4  | "Completeness Illusion" — optimizing output feels sufficient                                                                    | Same illusion applies: optimizing token throughput or task completion rate without measuring risk management effectiveness                                                                                              | The illusion mechanism (Goodhart's Law)                              | AI metrics (tokens/sec, task completion %) can become the target, replacing actual value delivery                                                              |
| UT#5  | "Optimism-Urgency Complex" — optimism + urgency + dopamine loop                                                                 | AI version: demo-driven development (impressive demo → stakeholder excitement → rush to production → skip risk management). 5 failure modes all apply to AI systems                                                     | The 3 Pillars, the Asymmetry Recognition System, the 5 failure modes | AI-specific: UT#5 Theater is the #1 risk (checklists exist but don't interrogate the model itself)                                                             |
| UT#6  | UBS = Bio-Efficient Forces (System 1); UDS = Deliberate Reasoning System (metacognition + frameworks + calibration)             | UBS = Compute-Efficient Forces (cost optimization overriding quality) + Automation Bias (trusting fluent LLM output); UDS = Structured Reasoning (self-evaluation prompts + reasoning chains + RAG with source scoring) | The UBS/UDS framework, the 3-layer cascade structure                 | The CONTENT changes; the cascade becomes: Cost Pressure → Invisible Hallucination → Confirmation Loop (builder sees what they want in AI output)               |
| UT#7  | UDS = Workstream Integration Discipline; UBS = Sequential Phase Addiction (from education + org culture + Bio-Efficient Forces) | UDS = Concurrent Architecture Design (event loops + cross-workstream messaging); UBS = Sequential DAG Architecture (the AI equivalent of Sequential Phase Addiction — accidentally encoded by engineers)                | The 6-workstream structure, the 3-stage failure cascade              | AI agents don't have educational conditioning — Sequential Phase Addiction is NOT their natural default UNLESS we encode it through sequential pipeline design |
| UT#8  | Org UBS = collective human biases, shadow systems                                                                               | Org UBS = inter-agent coordination failures, prompt drift, inconsistent tool schemas, cost aggregation failures                                                                                                         | The concept of "shadow system"                                       | Shadow systems become observable (agent logs, traces)                                                                                                          |
| UT#9  | 6 org workstreams                                                                                                               | Same, but with AI agents as primary doers and humans as directors                                                                                                                                                       | The structure                                                        | The RACI shifts: AI = Responsible, Human = Accountable                                                                                                         |
| UT#10 | Concurrent workstreams (human must discipline themselves)                                                                       | Concurrent workstreams (agents naturally run in parallel)                                                                                                                                                               | The concurrency principle                                            | AI makes UT#10 trivially achievable — parallelism is native                                                                                                    |
| DT#1  | 3 Pillars on all components                                                                                                     | Same                                                                                                                                                                                                                    | Everything                                                           | No change — this is universal                                                                                                                                  |
| DT#2  | 3 Pillars on all workstreams                                                                                                    | Same                                                                                                                                                                                                                    | Everything                                                           | No change — this is universal                                                                                                                                  |

---

_End of Document 1. This file is the foundational reference for all subsequent documents (Doc 2–6). Every design decision in the AI-Centric OE System must trace back to at least one UT or DT in this codex._

## Links

- [[DESIGN]]
- [[SEQUENCE]]
- [[SKILL]]
- [[VALIDATE]]
- [[blocker]]
- [[deliverable]]
- [[friction]]
- [[iteration]]
- [[task]]
- [[workstream]]
