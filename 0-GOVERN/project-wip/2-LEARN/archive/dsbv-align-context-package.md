---
version: "1.0"
iteration: "I1: Concept"
status: Draft
last_updated: 2026-03-29
owner: Long Nguyen
---
# DSBV ALIGN Context Package

> Input context for Sonnet agents running Competing Hypotheses + Synthesis on Zone 1 (ALIGN).
> Budget: ~4000 words. Do not exceed. Every token costs signal-to-noise ratio.

---

## Section 1: Project Identity

### What

The **LTC Project Template** is the canonical scaffold that every LTC Partners project clones from. It is not an application — it is a **thinking system** that captures decisions, risks, rationale, and learning in a structured 4-zone APEI framework with AI agent configuration pre-loaded.

The template provides the **vertical process** (APEI zones: Align, Plan, Execute, Improve). Each consumer project adds its own **horizontal layer** (subsystems specific to that domain). The template itself has no subsystems — it is domain-agnostic infrastructure.

### Who

| Role | Person | RACI | Function |
|------|--------|------|----------|
| CIO / Director | Anh Vinh (Anh Long) | **A** — Accountable | Owns the outcome, provides strategic direction, approves designs |
| Builder | Long Nguyen | **R** — Responsible | Designs and builds the template scaffold, agent config, rules, skills |
| Team Members | 8 operators (Khang, Dong, Manh, others) | **I/C** | Clone the template for investment projects, provide feedback, test usability |

### Purpose

Enable **Human Directors** to use **AI Agents** to build domain-specific User Enablement (UE) Delivery Systems. The directors are not coders — they are managers who guide agents through structured processes. The template ensures:

1. Every project has a place for alignment, planning, execution, and improvement
2. Decisions and their rationale are captured (not lost in chat)
3. Version control tracks how the system evolves through iterations
4. AI agents receive structured rules, procedures, and context at session start

### First Consumer

The investment team, whose project has 4 subsystems: **User Problem**, **Data Pipeline**, **Analytics**, and **Interpretation/Decision-Making**. The template provides APEI process; the investment project adds these 4 subsystems as its horizontal layer.

---

## Section 2: Key Decisions Already Made

These decisions are settled. Do not re-litigate them. Design within these constraints.

| # | Decision | Rationale |
|---|----------|-----------|
| D1 | **4 zones: ALIGN, PLAN, EXECUTE, IMPROVE** | LEARN merged into ALIGN after team debate. Learning is an action within alignment (discovering what is known/unknown), not a separate phase. |
| D2 | **DSBV sub-process within each zone** | Each zone internally runs Design → Sequence → Build → Validate. The "align" of ALIGN asks "what conditions for success?" The "plan" of ALIGN sequences those conditions. The "execute" of ALIGN produces the artifacts. |
| D3 | **Subsystems are the primary organizational axis** | Folder structure organizes by subsystem first, then by APEI stage within each subsystem. Subsystems are independent projects that can version and iterate separately (enables CI/CD). |
| D4 | **MAJOR = iteration versioning** | I0 = 0.x (scaffold), I1 = 1.x (concept), I2 = 2.x (prototype), etc. Version must flow top-down: ALIGN version updates before PLAN version can advance. |
| D5 | **APEI flow constraint** | No zone-N artifact may reach Review status until zone-(N-1) has at least 1 Approved artifact. PLAN cannot start until ALIGN has approved output. |
| D6 | **Enforcement hierarchy** | Hooks (automated) > Rules (always loaded) > Skills (on-demand) > CLAUDE.md (session baseline). Automated enforcement preferred over human discipline. |
| D7 | **3-pillar priority order** | Sustainability (manage failure risks) > Efficiency (minimize waste) > Scalability (handle growth). Always derisk before optimizing. |
| D8 | **Flat folder structure for agents** | Minimize nested directories. Each nesting layer degrades agent capability. Long naming also degrades performance. Keep paths shallow and names concise. |
| D9 | **Single repo, not multi-repo** | One project = one repo. Subsystems are folders within the repo, not separate repositories. Large software projects do this successfully; the complexity is managed by structure, not separation. |
| D10 | **Validation is a human gate** | The human director's primary role is validation/approval. Commit and PR happen only after human validates. Agent executes; human judges. |

---

## Section 3: What ALIGN Must Produce

Zone 1 output = the complete alignment package that Zone 2 (PLAN) consumes as input.

### Required Artifacts

| Artifact | File | Key Content |
|----------|------|-------------|
| **Charter** | `1-ALIGN/charter/PROJECT_CHARTER.md` | WHY (EO statement), WHAT (scope boundary: in/out), WHO (primary user), HOW (governing principles bucketed S/E/Sc), WHEN (timeline), RISKS (initial UBS scan) |
| **Stakeholders** | `1-ALIGN/charter/STAKEHOLDERS.md` | Stakeholder map with RACI (R != A), UBS per stakeholder, UDS per stakeholder, engagement level, anti-persona |
| **Requirements** | `1-ALIGN/charter/REQUIREMENTS.md` | VANA-decomposed (Verb + Adverb + Noun + Adjective), binary acceptance criteria, MoSCoW tags, 3-pillar check, traceability to OKRs and risks |
| **OKRs** | `1-ALIGN/okrs/` | Objectives + Key Results with explicit formulas, each KR tagged to S/E/Sc pillar, at least 1 KR per pillar |
| **Decisions** | `1-ALIGN/decisions/` | ADRs for non-trivial choices: options considered, 3-pillar eval, UBS/UDS per option, bias check, chosen option + reasoning |
| **Force Analysis** | `2-PLAN/risks/UBS_REGISTER.md` + `2-PLAN/drivers/UDS_REGISTER.md` | Blocking forces (UBS) and driving forces (UDS) identified from both R and A perspectives |

### 10 Conditions for ALIGN Completion

Every condition must be PASS with evidence before Zone 2 can begin:

| # | Condition | Test |
|---|-----------|------|
| C1 | Problem understood (WHY) | Can state EO in one sentence: "[User] [desired state] without [constraint]" |
| C2 | System boundary defined | INPUT, EO, OUTPUT explicit. In-scope and out-of-scope stated |
| C3 | Primary user + anti-persona defined | Specific enough to make design decisions against |
| C4 | RACI assigned | R and A are different actors. Every stakeholder has one RACI |
| C5 | UBS identified (role-aware) | 3+ risks from both R and A perspectives, with mitigations |
| C6 | UDS identified (role-aware) | Initial principles bucketed S/E/Sc |
| C7 | Requirements VANA-decomposed | Every req has binary AC that returns PASS/FAIL |
| C8 | Success metrics with formulas | KRs have explicit formulas from real data sources |
| C9 | Domain understood | Can state binary ACs for all requirements right now |
| C10 | Non-trivial decisions recorded | ADRs exist for all multi-option choices affecting Zone 2/3 |

---

## Section 4: Strategic Context from Team Discussions

Extracted from two team standups (72 min + 30 min). These quotes and decisions reveal the thinking behind the framework.

### Why APEI Exists

**Anh Long (Director):** "The projects you're doing are going to be complex, so you need a structure that allows you to handle that level of complexity. If we simplify too much — because the structure is too basic — we force complex ideas into a simple box, and we might miss a lot of what's in our heads."

**Core problem:** Team members were losing decisions in chat, losing chain-of-thought in flat folder structures, and unable to track how their systems evolved. When projects fork into variations, without version control the work becomes untraceable.

**Anh Long:** "It's not just a place to capture our work; it's a place that allows us to think. Each part can have many different possibilities. That is exactly why we should have this structure."

### The "Thinking System" Concept

The template is not a project management tool. It is a **thinking system** — infrastructure that forces structured reasoning:

- **Before you execute, you must plan.** That planning must be recorded, not stay in your head or get lost in chat.
- **Before you plan, you must align.** You must know the outcome, the risks, and the driving forces.
- **Each zone forces you to think about a different dimension** — ALIGN (right outcome), PLAN (minimize risks), EXECUTE (deliver), IMPROVE (learn).

**Long (Builder):** "The align answers: what conditions for success? What artifacts are needed as output? Reverse-engineer: what conditions must be true to produce those artifacts? Then: what is known, what is unknown? Plan to convert unknowns to knowns. Then execute to fulfill all conditions."

### The Subsystem Debate and Resolution

**Problem:** Should the folder structure organize by APEI stage first, or by subsystem first?

**Anh Long's argument for subsystem-first:** "If you don't separate subsystems, when you improve one component it affects everything else. Each subsystem is essentially its own project. Subsystem-first enables CI/CD — you can update data pipeline without breaking analytics."

**Khang's concern:** Cross-subsystem references become more complex with subsystem-first organization (paths go up and across). **Anh Long's response:** "I want it complex like that. You're thinking as a doer, think as a manager. Accept one-time complexity now to avoid perpetual refactoring."

**Resolution:** Subsystem-first, with APEI stages nested inside each subsystem. The template itself ships without subsystems (domain-agnostic); each consumer project adds its own.

### Version Control as Foundation

**Long (Builder):** "When initiating for the first time, everything is 0.1.0 from top to bottom. If there's an update to 0.1.1, it must start from ALIGN. Then it flows down to PLAN. All versions must move together. If PLAN is at 0.1.2 but ALIGN is at 0.1.1, the system flags it."

**Anh Long:** "Version control is critical because each of these zones is a project by itself. For them to be independent yet sufficiently linked, we must have versioning."

**Khang (after working without structure):** "I will appreciate version control. The versioning is very important. Keeping track of everything... the system is wonderful."

### Team Dynamics

The team is transitioning from **doers** (task executors) to **directors** (people who manage AI agents). This is a fundamental shift:

- **Old model:** Human writes code, manages files, makes all decisions in their head
- **New model:** Human defines outcomes, manages agents, captures decisions in structured artifacts

**Anh Long:** "You are no longer just doers. You are Managers; you are Directors. I need a place to communicate your work with other Directors and stakeholders."

**Long (Builder):** "I could lock myself away for a week and produce an MVP. But the risk is it might take another month for everyone to understand and use it. That's why alignment takes time — it's not the build time, it's the absorption time."

---

## Section 5: Agent System Constraints

### The 8 LLM Truths (structural, not bugs)

| # | Truth | One-Line Summary |
|---|-------|-----------------|
| LT-1 | Hallucination is structural | For any model, there exist prompts where P(hallucination) > 0. Plausible is not true. |
| LT-2 | Context compression is lossy | Effective context window << nominal. Information in the middle gets lost. |
| LT-3 | Reasoning degrades on complex tasks | 3-step task works; 12-step task breaks. 0.9^7 = 48% end-to-end accuracy. |
| LT-4 | Retrieval is fragile under noise | Needle-in-haystack: model grabs "close enough" instead of the exact fact. |
| LT-5 | Prediction optimizes plausibility | Trained for "sounds right," not "is right." Root cause of LT-1. |
| LT-6 | No persistent memory | Every session starts blank. All state must be externally provided. |
| LT-7 | Cost scales with tokens | More words = more money. Wasted tokens waste budget AND worsen LT-2. |
| LT-8 | Alignment is approximate | "Mostly behaves" is not "always behaves." Can drift, game, find loopholes. |

### The 7-CS Formula

```
EO = f(EP, Input, EOP, EOE, EOT, Agent, EA)
```

The Human Director is NOT a component — they are the Accountable party who owns the outcome, provides judgment, and approves results.

### The 7 Components

| # | Component | What It Is | Priority |
|---|-----------|------------|----------|
| 1 | **EP** (Effective Principles) | Persistent rules, always active. CLAUDE.md, rules/ | 1st |
| 2 | **Input** | Task-specific context: prompt, files, memory | 2nd |
| 3 | **EOP** (Effective Operating Procedures) | Step-by-step procedures, loaded on demand | 3rd |
| 4 | **EOE** (Effective Operating Environment) | Workspace: IDE, context window, hooks, sandbox | 4th |
| 5 | **EOT** (Effective Operating Tools) | Instruments the agent can call: APIs, CLI, MCP | 5th |
| 6 | **Agent** | The AI model itself — capabilities and limits | 6th |
| 7 | **EA** (Effective Action) | Observable execution — emergent, diagnose only | 7th |

### Two Operators with Complementary Failures

- **Human Director** fails via System 1 biases: availability heuristic, anchoring, confirmation bias, affect heuristic
- **LLM Agent** fails via 8 LTs: hallucination, context loss, reasoning degradation, retrieval fragility
- Neither can compensate for their own blind spots; each compensates for the other's

---

## Section 6: Agent Instructions

### Your Role

You are one of N Sonnet agents, each independently producing a complete ALIGN package for the LTC Project Template. Your outputs will be collected and synthesized by an Opus agent using a Competing Hypotheses pattern — the synthesis will extract the strongest elements from each team's work and resolve conflicts.

### Your Deliverables

1. **DESIGN.md** — What ALIGN needs: list all artifacts, their dependencies, their conditions for completion, and the sequence to produce them. Identify risks specific to the ALIGN phase itself (meta-risks: what can go wrong during alignment?).

2. **Filled Charter** — Populate `PROJECT_CHARTER.md` for the LTC Project Template itself. The EO is: enable LTC team members (directors, not coders) to clone a scaffold that provides structured APEI process with agent config, so they can build domain-specific delivery systems without losing decisions, risks, or rationale.

3. **Filled Stakeholders** — Populate `STAKEHOLDERS.md` with all stakeholders of the template (not of consumer projects). Include anti-persona. RACI must have R != A.

4. **Force Analysis** — Identify UBS (blocking forces) and UDS (driving forces) for the template project. Analyze from both the R perspective (builder: what blocks building the template?) and the A perspective (director: what blocks ensuring template quality?).

5. **Filled Requirements** — VANA-decomposed requirements for the template. Binary acceptance criteria. MoSCoW tagged.

### What to Optimize For

- **Find non-obvious risks and drivers.** Other teams will find the obvious ones (e.g., "team might not adopt template"). Your value-add is the risks that require deeper analysis — second-order effects, hidden dependencies, failure modes that only surface at scale.
- **Challenge assumptions.** The decisions in Section 2 are settled — but their *implications* may not be fully mapped. What does "subsystem-first" mean for a first-time user who has no subsystems yet? What does "flat folder structure for agents" mean when human readability conflicts?
- **Be specific.** Vague outputs will be discarded during synthesis. "The template should be easy to use" is worthless. "REQ-005: Template structure must be navigable by a Sonnet-class agent within 2000 tokens of context loading, verified by running template-check.sh with zero errors" is useful.

### Constraints

- Do NOT invent new zones or rename existing ones
- Do NOT propose changes to the 7-CS or 8 LLM Truths
- Do NOT produce architecture or system design — that is Zone 2 (PLAN)
- All requirements must use VANA grammar with binary acceptance criteria
- Every decision with multiple viable options must have an ADR
- Sustainability > Efficiency > Scalability in all prioritization
