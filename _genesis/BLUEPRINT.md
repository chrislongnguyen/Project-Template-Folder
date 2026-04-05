---
version: "2.2"
status: draft
last_updated: 2026-04-05
owner: "Long Nguyen"
workstream: GOVERN
type: charter
---

# LTC AI OPERATING SYSTEM — BLUEPRINT

> This document is the bedrock for all iterations (I0–I4) of the LTC Project Template.
> It derives from Vinh Nguyen's ALPEI Framework, the 10 Ultimate Truths, and the 7-Component Agent System.
> Every EOP, EOT, and EOE built in this project must trace back to a principle stated here.
> No principle is designed from void — each tackles a named UBS or amplifies a named UDS.

---

## PART 1: PHILOSOPHY — WHY WE EXIST

### WHY THIS EXISTS

The AI revolution promoted the Human from Doer to Director. AI agents now handle Plan and Execute at the Supervisor/Manager/Doer levels. The Human's job is no longer to write code or process data — it is to **learn well, align well, and coordinate AI well** (Vinh Nguyen, 2026-01-04).

This shift creates a new bottleneck: **the Human Director's learning speed.** If the Director does not learn fast enough to evaluate AI output, the quality gate collapses. 88% of AI agent projects never reach production — not because the AI fails, but because the human governance layer is missing [Research Axis 1, Source 6].

### THE SUCCESS FORMULA

From LTC's Ultimate Truths:

- **UT#5:** Success in reality is first about efficient and scalable management of failure risks before maximizing work output.
- **UT#6:** The personal UBS is our system of psychological biases. The personal UDS is our system of logical and analytical reasoning.
- **UT#7:** Personal success follows 6 work streams: Self Alignment → Risk Management → Effective Learning → Effective Thinking → Effective Planning → Effective Execution.

**Therefore:** Success = Workstreams First. The workstreams ARE the success model for the Human Director. The sub-systems (PD → DP → DA → IDM) are what the Director PRODUCES through those workstreams.

### THREE PILLARS OF EFFECTIVENESS (DT#1)

Every deliverable in every iteration is evaluated against three pillars, **in this order:**

| Priority | Pillar | Definition | UES Version |
|----------|--------|------------|-------------|
| 1st | **Sustainability** | Management of failure risks (correct, safe, reliable) | Concept |
| 2nd | **Efficiency** | Best possible output for given resources | Prototype → MVE |
| 3rd | **Scalability** | Best possible output gains for additional resources | Leadership |

**S > E > Sc is not a preference — it is a law derived from UT#5.** A system that is efficient but not sustainable will fail. A system that is scalable but not efficient will waste resources. Build in order.

**References:**
- `_genesis/reference/ltc-company-handbook.md` — LTC company principles and cultural foundation
- `_genesis/frameworks/ltc-10-ultimate-truths.md` — canonical source for UT#1 through UT#10

---

## PART 2: PRINCIPLES — HOW WE WORK

### PRINCIPLE 1: WORKSTREAMS ARE SEQUENTIAL FOR BUILDING, CONCURRENT FOR OPERATING

When building a sub-system (I0 → MVE), follow the chain: ALIGN first, then LEARN, then PLAN, then EXECUTE, then IMPROVE. Each workstream's output is the mandatory input for the next. Chain-of-custody is enforced by auto-loaded rules, not by human memory.

When the system is operating (post-MVE), the workstreams run concurrently — feedback from IMPROVE loops back to ALIGN continuously.

**Why:** UT#7 defines the work streams as a progression. Skipping LEARN to rush to EXECUTE is the #1 observed failure mode (Research Axis 1, Sources 5, 20). Junior PMs who skip learning produce "AI slop" — plausible but incorrect output that compounds downstream.

---

### PRINCIPLE 2: LEARN IS THE BOTTLENECK

The Human Director's #1 contribution is learning quality. Not execution speed, not tool mastery, not framework compliance.

If the Director does not understand the domain deeply enough to recognize incorrect AI output, every downstream artifact is suspect. LEARN feeds ALIGN (the Director can only align what they understand) and PLAN (the Director can only plan what they've analyzed).

**Why:** External validation — "The #1 failure mode was not the agents. It was the PM not knowing enough about the domain to recognize bad output" (Research Axis 1, Source from theunwindai.com). Vinh: "Cho nên failure cái bottleneck của tụi em là đang ở cái level learning của các em" (2026-01-04 transcript).

---

### PRINCIPLE 3: NO COMPONENT IS DESIGNED FROM VOID

Every EP, EOP, EOE, and EOT must trace to:
1. A named UBS it disables (brake before gas), AND/OR
2. A named UDS it amplifies (gas after brake)

If a rule, tool, or procedure cannot name the force it addresses, it is governance theater — compliance artifact with no enforcement value [Research Axis 1, Source 21].

**Why:** UT#3 (UBS/UDS Force Analysis). UT#5 (risks first, output second). The 8 LLM Truths (LT-1 through LT-8) are the Agent's UBS — every component in the 7-CS exists to compensate for at least one.

---

### PRINCIPLE 4: TRAINING BEFORE TOOLING

Deploy learning materials before deploying tools. A PM who understands ALPEI but has no Obsidian will produce correct work slowly. A PM who has Obsidian but doesn't understand ALPEI will produce incorrect work fast.

The rollout sequence for any new capability:
1. LEARN: Why does this exist? What UBS does it disable?
2. ALIGN: How does this fit the project's EO?
3. PLAN: What's the adoption path?
4. EXECUTE: Deploy the tool/process
5. IMPROVE: Measure adoption, not just deployment

**Why:** "Training before tooling, not tooling before training" is the #1 differentiator between successful and failed AI adoptions (Research Axis 1, Source 26). 88% of AI projects fail from complexity outpacing capability, not from capability gaps (Research Axis 1, Source 6).

---

### PRINCIPLE 5: VANA DEFINES "DONE" AT EVERY LEVEL

Every deliverable has success criteria expressed in VANA grammar (UT#2):

| Element | Maps To | Example |
|---------|---------|---------|
| **Verb** | The Action | Derisk and deliver |
| **Adverb** | The Quality | Correctly, safely, efficiently |
| **Noun** | The System/Tool | User enablement system |
| **Adjective** | The Characteristic | Correct, safe, reliable |

Without VANA criteria, an AI agent will self-audit as "everything looks correct" (LT-5: plausibility over truth). VANA is the benchmark that forces honest evaluation.

**Why:** UT#2 (VANA Requirement Grammar). No external equivalent found in requirements engineering literature — VANA is LTC-original (Research Axis 1, Source 38).

---

### PRINCIPLE 6: SUB-SYSTEMS ARE SEQUENTIAL, PD GOVERNS ALL

The 4 sub-systems form a pipeline — the output of each is the input for the next:

```
PD (Problem Diagnosis) → DP (Data Pipeline) → DA (Data Analysis) → IDM (Insights & Decision Making)
```

PD's Effective Principles always take precedence. If a downstream sub-system's design conflicts with PD's EP, PD wins. When PD is at a given UES version, downstream sub-systems cannot exceed that version's behavioral expectations.

**Why:** PD produces the principles that govern the entire system. Building DP before PD's principles are validated means building on unverified assumptions — a direct UT#5 violation.

---

### PRINCIPLE 7: THREE LEVELS OF FOLDER DEPTH, FRONTMATTER FOR THE REST

Physical folder structure encodes at most 3 dimensions (4 for EXECUTE code):

```
L1: Workstream    1-ALIGN, 2-LEARN, 3-PLAN, 4-EXECUTE, 5-IMPROVE
L2: Subsystem     1-PD, 2-DP, 3-DA, 4-IDM, _cross (swappable per FA)
L3: Files         {sub}-{name}.md (documents)
L3: Code type     src, tests, config, notebooks, docs (EXECUTE only → L4: files)
```

Iteration, DSBV stage, status, UES version, and 8-component model are encoded in YAML frontmatter. Obsidian Bases dashboards provide multi-dimensional views over frontmatter without physical folder nesting.

**Why not deeper:** Empirical testing (40 AI task sessions, 16 disk verifications, 4 falsification tests on `archive/I2/improve/filesystem-depth-test`) proved AI agents perform equally at any depth. However, encoding temporal dimensions (iteration, DSBV stage) as folders forces file duplication or misleading locations. Frontmatter preserves single-source-of-truth. Additionally: 3-layer structure = 46 directories vs 6-layer = 400 directories. UBS-1 (junior PM paralysis) is directly disabled by fewer empty folders.

**Why not flatter:** Subsystem folders (L2) encode the sequential dependency chain (Principle 6: PD governs all). Removing L2 would lose this structural enforcement and require agents to read frontmatter before every file operation to determine domain.

**Full spec:** `3-PLAN/_cross/filesystem-blueprint.md` | **Routing rule:** `rules/filesystem-routing.md`

---

### PRINCIPLE 8: GOVERNANCE IS INJECTED, NOT REFERENCED

Rules that agents must follow are auto-loaded into every session via `.claude/rules/` (always-on). Rules that require explicit lookup have near-0% compliance. Rules embedded in context have near-100% compliance [Research Axis 1, Source 16].

The governance stack:
1. **EP (Effective Principles):** CLAUDE.md + .claude/rules/ — always loaded, constrains everything
2. **EOP (Effective Operating Procedures):** .claude/skills/ — loaded on demand via /commands
3. **EOE (Effective Operating Environment):** IDE, terminal, context window, hooks, sandbox
4. **EOT (Effective Operating Tools):** MCP servers, APIs, CLI, web search

**Why:** Policy-as-code is the only approach that scales for distributed autonomous agents (Research Axis 1, Source 17). Documentation-only governance produces "AI theater" (Research Axis 1, Source 21).

**Full registry:** `_genesis/reference/ltc-effective-agent-principles-registry.md` (EP-01 through EP-13)

---

## PART 3: OPERATING MODEL — WHO DOES WHAT

### THE HUMAN DIRECTOR'S 4 RESPONSIBILITIES

The Human Director is not a builder. The Director's job in the ALPEI system:

| # | Responsibility | Workstream | What This Means |
|---|---------------|-----------|-----------------|
| 1 | **LEARN** | 2-LEARN | Understand the domain deeply enough to recognize incorrect AI output |
| 2 | **INPUT** | All | Provide context, direction, and constraints that AI cannot infer |
| 3 | **REVIEW** | All | Evaluate AI output against VANA criteria — not rubber-stamp |
| 4 | **APPROVE** | All | Gate every DSBV phase transition — only humans advance stages |

**"The Human Director's primary workstream is not execution — it is learning well enough to direct AI effectively."** (Vinh Nguyen)

### RACI TABLE

| Activity | Agent | Human Director |
|----------|-------|----------------|
| Research and analysis | Responsible | Accountable |
| Artifact production | Responsible | Accountable |
| Architecture decisions | Consulted | Accountable |
| VANA validation | Consulted | Accountable |
| Phase gate approval | — | Accountable (sole) |
| Requirement definition | Consulted | Accountable |

**Agent = Responsible + Consulted. PM = Accountable + Informed.**

RACI enforcement: agent files in `.claude/agents/` define each agent's scope boundary explicitly.

### TOOL SPLIT

| Tool | Workstreams | Purpose |
|------|------------|---------|
| **Obsidian** | ALIGN, LEARN, PLAN | Thinking, research, knowledge graph, frontmatter dashboards |
| **Cursor / Claude Code** | EXECUTE | Building, coding, testing, deploying |

Obsidian is the PM's workspace for making decisions. Cursor/Claude Code is the PM's workspace for building outputs. Never mix the roles — PM thinking artifacts belong in Obsidian, not in the repo's EXECUTE folder.

---

## PART 4: FRAMEWORK OVERVIEW — ALPEI + DSBV + 8-COMPONENT

### THE ALPEI AI OPERATING SYSTEM

ALPEI is derived from UT#7's 6 work streams, compressed to 5:

| ALPEI | Derived From (UT#7) | Primary Role | Human Role | AI Role |
|-------|---------------------|--------------|------------|---------|
| **ALIGN** | Self Alignment + Risk Management | Choose the right outcome, manage risks | Director (Accountable) | Consulted |
| **LEARN** | Effective Learning | Find truths, analyze forces (UBS/UDS) | Director (Accountable) | Responsible (research) |
| **PLAN** | Effective Thinking + Planning | Design architecture, sequence work | Director (Accountable) | Responsible (decomposition) |
| **EXECUTE** | Effective Execution | Build and deliver | Supervisor (oversight) | Responsible (build) |
| **IMPROVE** | (Feedback loop) | Collect feedback, validate, iterate | Director (Accountable) | Responsible (analysis) |

### THE 4 SUB-SYSTEMS

Each ALPEI project produces a User Enablement System (UES) composed of 4 sequential sub-systems:

| Order | Sub-System | Primary Output | Feeds Into |
|-------|-----------|----------------|------------|
| 1 | **Problem Diagnosis (PD)** | Effective Principles for the entire UES (UBS/UDS analysis) | DP, DA, IDM |
| 2 | **Data Pipeline (DP)** | Processed data ready for analysis | DA |
| 3 | **Data Analysis (DA)** | Analyzed insights extracted from data | IDM |
| 4 | **Insights & Decision Making (IDM)** | Actionable decisions with risk management | Stakeholders |

### THE DSBV SUB-PROCESS

Each workstream uses Design → Sequence → Build → Validate for every artifact:

| Stage | Purpose | Gate |
|-------|---------|------|
| **Design** | Define what, why, and acceptance criteria | Human approves scope |
| **Sequence** | Order work, size tasks, identify dependencies | Human approves plan |
| **Build** | Produce the artifact | Agent builds, human reviews |
| **Validate** | Verify against VANA criteria | Human approves quality |

No workstream artifact is produced outside DSBV. No phase is skipped. Each gate requires explicit human approval.

### THE 8 EFFECTIVE SYSTEM COMPONENTS

Every sub-system is designed using the Universal 8-Component Model (UT#1):

| # | Component | Description | AI Mapping |
|---|-----------|-------------|------------|
| 1 | **EI** (Effective Input) | What the system requires to operate | Prompt, context, RAG |
| 2 | **EU** (Effective User) | The doer within the system (RACI) | Human Director + Agent |
| 3 | **EA** (Effective Action) | Observable execution (emergent) | Tool calls, reasoning |
| 4 | **EO** (Effective Output) | Results of the action | Deliverables, decisions |
| 5 | **EP** (Effective Principles) | Rules governing all actions | CLAUDE.md, rules/ |
| 6 | **EOE** (Effective Operating Environment) | Workspace constraints | IDE, context window |
| 7 | **EOT** (Effective Operating Tools) | Instruments the agent can call | MCP, APIs, CLI |
| 8 | **EOP** (Effective Operating Procedure) | Step-by-step procedures | SKILL.md, /commands |

---

## PART 5: ROADMAP — VANA + ACCEPTANCE CRITERIA

### ITERATION-TO-VERSION MAPPING

| Iteration | UES Version | Pillar | VANA |
|-----------|-------------|--------|------|
| I0 | Logic Scaffold | — | Understand and design the AI-OS scope clearly and completely |
| I1 | Concept | Sustainability | Derisk and deliver the agent infrastructure correctly and safely |
| I2 | Prototype | Efficiency | Derisk and deliver an Obsidian-integrated PM workflow correctly, safely, and efficiently |
| I3 | MVE | Full Efficiency | Derisk and deliver the full AI-OS reliably and efficiently for 6 projects |
| I4 | Leadership | Scalability | Derisk and deliver a self-improving AI-OS that operates automatically and prescriptively |

---

### I0: LOGIC SCAFFOLD (COMPLETE — RETROSPECTIVE)

Vinh's 9 canonical frameworks captured in `_genesis/frameworks/`. Folder structure defined. CLAUDE.md created. No automation, no agents, no enforcement.

---

### I1: CONCEPT — CORRECTLY AND SAFELY (COMPLETE — RETROSPECTIVE)

**VANA:** Derisk and deliver the agent infrastructure correctly and safely.

1. A new PM can read the BLUEPRINT and understand the project's EO without asking Long.
2. The agent runs without hallucinating workstream or sub-system assignments.
3. Every artifact produced by the agent traces to a named UBS or UDS in the register.
4. A session ends and restarts without losing context (compress + resume cycle works).
5. All 67 acceptance criteria pass on a clean checkout.
6. No secrets appear in any committed file.
7. A DSBV phase cannot advance without explicit human approval.

---

### I2: PROTOTYPE — EFFICIENTLY (CURRENT)

**VANA:** Derisk and deliver an Obsidian-integrated PM workflow correctly, safely, and efficiently.

1. A new PM can check project status in under 30 seconds via Obsidian Bases — no terminal needed.
2. A new PM can identify the next task via `/ues-next` without reading DESIGN.md.
3. A new PM can onboard without verbal instruction from Long — template materials are sufficient.
4. A new PM can create a correctly-frontmatted artifact via Templater in under 1 minute.
5. The PM never needs to hand-craft YAML frontmatter — Templater auto-fills all required fields.
6. All I1 acceptance criteria still pass after I2 changes are applied.
7. A context switch between projects takes under 2 minutes using `/resume`.
8. The 6 Obsidian Bases dashboards show accurate live views — never stale data.

---

### I3: MVE — RELIABLY FOR 6 PROJECTS (DIRECTIONAL)

**VANA:** Derisk and deliver the full AI-OS reliably and efficiently across all 6 LTC investment projects.

1. A new PM at any of the 6 projects onboards using only the template — no per-project verbal coaching.
2. All 6 projects share a consistent frontmatter schema — cross-project Bases queries work.
3. A project handoff (PM leaves → new PM continues) completes within 1 working day.
4. No project is blocked waiting for a framework update in `_genesis/` — template upgrades merge cleanly.
5. At least 1 project has ≥1 sub-system at Concept version with a validated UBS/UDS analysis.

---

### I4: LEADERSHIP — AUTOMATICALLY (DIRECTIONAL)

**VANA:** Derisk and deliver a self-improving AI-OS that operates automatically, predictively, and prescriptively.

1. The system executes ≥50% of routine PM tasks without human initiation.
2. The system forecasts blockers ≥3 days before they surface.
3. New team members receive personalized onboarding recommendations based on skill profile.

---

## PART 6: UBS/UDS REGISTER — THIS PROJECT

**Framework:** `_genesis/frameworks/ltc-ubs-uds-framework.md`

### ULTIMATE BLOCKING SYSTEM (UBS)

| ID | Blocker | Mechanism | Severity | Disabled By |
|----|---------|-----------|----------|-------------|
| UBS-1 | Junior team lacks ALPEI mental model | PM cargo-cults process without understanding → AI slop | CRITICAL | Principle 4 (training before tooling), LEARN workstream |
| UBS-2 | Over-engineering before value delivery | 42 skills + 14 dashboards before a single deliverable | HIGH | Phased rollout (I2: 6 dashboards, not 14) |
| UBS-3 | Stale context at scale | .md files disconnect, agent memory degrades | HIGH | Layer 1 (Obsidian knowledge graph), /compress lifecycle |
| UBS-4 | Bus factor of 1 on framework synthesis | Vinh leaves → methodology becomes opaque | HIGH | This blueprint + annotated frameworks in _genesis/ |
| UBS-5 | Obsidian team-scale friction | No real-time co-editing, $960/yr sync cost | MEDIUM | Git-based sync, limit vault to build artifacts |
| UBS-6 | Governance theater | Rules exist but nobody follows under pressure | MEDIUM | Principle 8 (governance injected), PreToolUse hooks |
| UBS-7 | Second-system effect | Template bloats with features nobody uses | MEDIUM | Strict scope per iteration, VANA exit criteria |

### ULTIMATE DRIVING SYSTEM (UDS)

| ID | Driver | Mechanism | Leverage | Amplified By |
|----|--------|-----------|----------|--------------|
| UDS-1 | Small team agility | 8 members, uniform workflows, retrain in days not months | HIGH | Standardized template, shared training |
| UDS-2 | AI execution speed | Agents build in hours what humans build in weeks | HIGH | DSBV + multi-agent roster |
| UDS-3 | Plain-text substrate | .md files are universal, version-controlled, AI-readable | HIGH | Obsidian + frontmatter + Git |
| UDS-4 | ALPEI framework maturity | 9 canonical frameworks from Vinh, battle-tested concepts | HIGH | This blueprint operationalizes them |
| UDS-5 | Governance-as-code pattern | Auto-loaded rules have near-100% compliance | HIGH | .claude/rules/ always-on architecture |
| UDS-6 | First-mover advantage | No competing AI-OS for investment PM in market | MEDIUM | Ship I2-I3 in 2026 before larger firms standardize |

---

## PART 7: REFERENCE TABLES FOR AI AGENTS

### TABLE 1: WORKSTREAM → DELIVERABLES → FOLDER

| Workstream | Key Deliverables | Folder | Human Role | AI Role |
|-----------|-----------------|--------|------------|---------|
| ALIGN | Charter, OKRs, Decisions (ADRs), Stakeholder Map | 1-ALIGN/ | Accountable | Consulted |
| LEARN | UBS/UDS Analysis, Research, Effective Principles, Specs | 2-LEARN/ | Accountable | Responsible |
| PLAN | Architecture, Risk Register, Driver Register, Roadmap | 3-PLAN/ | Accountable | Responsible |
| EXECUTE | Source Code, Tests, Config, Documentation, Dashboards | 4-EXECUTE/ | Supervisor | Responsible |
| IMPROVE | Feedback Register, Metrics, Retrospectives, Reviews | 5-IMPROVE/ | Accountable | Responsible |

### TABLE 2: FRONTMATTER SCHEMA

Every workstream artifact MUST include this frontmatter:

```yaml
---
version: "1.0"           # MAJOR = iteration (I1=1.x), MINOR = edit count
status: draft             # S2 vocabulary: draft | in-progress | in-review | validated | archived
                          # (human only sets: validated)
last_updated: 2026-04-03  # Always absolute date
type: ues-deliverable     # ues-deliverable | template | learning-source | reference
sub_system: 1-PD  # 1-PD | 2-DP | 3-DA | 4-IDM | _cross
work_stream: 3-PLAN       # 1-ALIGN | 2-LEARN | 3-PLAN | 4-EXECUTE | 5-IMPROVE
stage: design             # design | sequence | build | validate
component: EI             # EI | EU | EA | EO | EP | EOE | EOT | EOP (optional)
iteration: 1              # 0=scaffold | 1=concept | 2=prototype | 3=mve | 4=leadership
---
```

### TABLE 3: FOLDER STRUCTURE (3-LAYER DOCS / 4-LAYER CODE)

```
project-root/
├── 1-ALIGN/{1-PD,2-DP,3-DA,4-IDM,_cross}/files.md    ← L3: subsystem-prefixed docs
├── 2-LEARN/{1-PD,2-DP,3-DA,4-IDM,_cross}/files.md
├── 3-PLAN/{1-PD,2-DP,3-DA,4-IDM,_cross}/files.md
├── 4-EXECUTE/{1-PD,2-DP,3-DA,4-IDM}/                  ← L3: code type folders
│   └── {src,tests,config,notebooks,docs}/files         ← L4: code files
├── 5-IMPROVE/{1-PD,2-DP,3-DA,4-IDM,_cross}/files.md
├── _genesis/                                            ← Shared frameworks
├── .claude/                                             ← Agent config
├── DAILY-NOTES/                                         ← PM personal
├── MISC-TASKS/                                          ← PM personal
└── inbox/                                               ← PM personal
```

Subsystems are numbered to enforce sequential dependency (Principle 6).
Default subsystems (UE/Investment): PD, DP, DA, IDM. Swappable per functional area.
Full routing table: `rules/filesystem-routing.md`

### TABLE 4: AGENT ROSTER

| Agent | Model | DSBV Phase | Tools | Scope Boundary |
|-------|-------|-----------|-------|----------------|
| ltc-planner | Opus | Design + Sequence | Read, Grep, WebFetch, Exa, QMD | No file writes to 4-EXECUTE/ |
| ltc-builder | Sonnet | Build | Read, Edit, Write, Bash, Grep | From approved sequences only |
| ltc-reviewer | Opus | Validate | Read, Glob, Grep, Bash | Read-only, never modifies artifacts |
| ltc-explorer | Haiku | Pre-DSBV | Read, Glob, Grep, Exa, QMD | No commits, no file writes |

---

## LINKS

- [[ltc-ues-versioning]]
- [[agent-system]]
- [[ltc-effective-system-design-blueprint]]
- [[ltc-effectiveness-guide]]
- [[alpei-dsbv-process-map]]
- [[ltc-10-ultimate-truths]]
- [[ltc-effective-agent-principles-registry]]
