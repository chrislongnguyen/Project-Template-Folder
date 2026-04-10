---
version: "2.4"
status: draft
last_updated: 2026-04-10
work_stream: _genesis
type: charter
aliases:
  - BLUEPRINT
---

# LTC AI OPERATING SYSTEM — BLUEPRINT

> This document is the bedrock for all iterations (Iteration 0–Iteration 4) of the LTC Project Template.
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

When building a sub-system (Iteration 0 → MVE), follow the chain: ALIGN first, then LEARN, then PLAN, then EXECUTE, then IMPROVE. Each workstream's output is the mandatory input for the next. Chain-of-custody is enforced by auto-loaded rules, not by human memory.

When the system is operating (post-MVE), the workstreams run concurrently — feedback from IMPROVE loops back to ALIGN continuously.

**Why:** UT#7 defines the work streams as a progression. Skipping LEARN to rush to EXECUTE is the #1 observed failure mode (Research Axis 1, Sources 5, 20). Junior PMs who skip learning produce "AI slop" — plausible but incorrect output that compounds downstream.

---

### PRINCIPLE 2: LEARN IS THE BOTTLENECK

The Human Director's #1 contribution is learning quality. Not execution speed, not tool mastery, not framework compliance.

If the Director does not understand the domain deeply enough to recognize incorrect AI output, every downstream artifact is suspect. LEARN feeds ALIGN (the Director can only align what they understand) and PLAN (the Director can only plan what they've analyzed).

**Why:** External validation — "The #1 failure mode was not the agents. It was the PM not knowing enough about the domain to recognize bad output" (Research Axis 1, Source from theunwindai.com). Vinh: "Cho nen failure cai bottleneck cua tui em la dang o cai level learning cua cac em" (2026-01-04 transcript).

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

VANA criteria are version-scoped through the Three Pillars: at Concept level, VANA adverbs are "correctly, safely" (Sustainability). At Prototype, they expand to include "efficiently" (Efficiency). At Leadership, they add "automatically, prescriptively" (Scalability). This means the same deliverable has different "done" criteria at each version — VANA is not static.

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


**Full spec:** `_genesis/filesystem-blueprint.md` | **Routing rule:** `rules/filesystem-routing.md`

---

### PRINCIPLE 8: GOVERNANCE IS INJECTED, NOT REFERENCED

Rules that agents must follow are auto-loaded into every session via `.claude/rules/` (always-on). Rules that require explicit lookup have near-0% compliance. Rules embedded in context have near-100% compliance [Research Axis 1, Source 16].

The governance stack (all 8 components of the 7-CS, mapped to enforcement):

| # | Component | What It Is | Where It Lives | Enforcement |
|---|-----------|-----------|---------------|-------------|
| 1 | **EI** (Effective Input) | Context the agent needs | Prompt, RAG, QMD auto-recall | `UserPromptSubmit` hook injects context |
| 2 | **EU** (Effective User) | Who does the work (RACI) | `.claude/agents/*.md` | Agent scope boundaries in agent files |
| 3 | **EA** (Effective Action) | What the agent does | Tool calls, reasoning | `PreToolUse`/`PostToolUse` hooks |
| 4 | **EO** (Effective Output) | What gets produced | Deliverables per 80-cell matrix | VANA gate at Validate stage |
| 5 | **EP** (Effective Principles) | Rules constraining actions | `CLAUDE.md` + `.claude/rules/` (always loaded) | Auto-loaded every session |
| 6 | **EOE** (Effective Operating Environment) | Workspace constraints | IDE, terminal, context window, hooks, sandbox | `.claude/settings.json` hooks |
| 7 | **EOT** (Effective Operating Tools) | Instruments the agent calls | MCP servers, APIs, CLI, web search, QMD | Tool availability in agent files |
| 8 | **EOP** (Effective Operating Procedures) | Step-by-step procedures | `.claude/skills/` (loaded on demand via /commands) | Skill HARD-GATE blocks in SKILL.md |

**Why:** Policy-as-code is the only approach that scales for distributed autonomous agents (Research Axis 1, Source 17). Documentation-only governance produces "AI theater" (Research Axis 1, Source 21).

**Full registry:** `_genesis/reference/ltc-effective-agent-principles-registry.md` (EP-01 through EP-14)

---

## PART 3: OPERATING MODEL — WHO DOES WHAT

### THE HUMAN DIRECTOR'S 4 RESPONSIBILITIES

The Human Director is not a builder. The Director's job in the ALPEI system:

| # | Responsibility | Workstream | What This Means |
|---|---------------|-----------|-----------------|
| 1 | **LEARN** | 2-LEARN | Understand the domain deeply enough to recognize incorrect AI output |
| 2 | **INPUT** | All | Provide context, direction, and constraints that AI cannot infer |
| 3 | **REVIEW** | All | Evaluate AI output against VANA criteria — not rubber-stamp |
| 4 | **VALIDATE** | All | Gate every DSBV stage transition — only humans set `status: validated` |

**"The Human Director's primary workstream is not execution — it is learning well enough to direct AI effectively."** (Vinh Nguyen)

### RACI TABLE

| Activity | Agent | Human Director |
|----------|-------|----------------|
| Research and analysis | Responsible | Accountable |
| Artifact production | Responsible | Accountable |
| Architecture decisions | Consulted | Accountable |
| VANA validation | Consulted | Accountable |
| Stage gate approval | — | Accountable (sole) |
| Requirement definition | Consulted | Accountable |

**Agent = Responsible + Consulted. PM = Accountable + Informed.**

RACI enforcement: agent files in `.claude/agents/` define each agent's scope boundary explicitly.

### TOOL SPLIT

| Tool                       | Workstreams        | Purpose                                                     |
| -------------------------- | ------------------ | ----------------------------------------------------------- |
| **Obsidian / Claude Code** | ALIGN, LEARN, PLAN | Thinking, research, knowledge graph, frontmatter dashboards |
| **Cursor / Claude Code**   | EXECUTE            | Building, coding, testing, deploying                        |

Obsidian is the PM's workspace for making decisions. Cursor/Claude Code is the PM's workspace for building outputs. Never mix the roles — PM thinking artifacts belong in Obsidian, not in the repo's EXECUTE folder.

---

## PART 4: FRAMEWORK OVERVIEW — ALPEI + DSBV + 8-COMPONENT

### THE ALPEI AI OPERATING SYSTEM

ALPEI is derived from UT#7's 6 work streams, compressed to 5:

| ALPEI       | Derived From (UT#7)              | Primary Role                           | Human Role             | AI Role                     |
| ----------- | -------------------------------- | -------------------------------------- | ---------------------- | --------------------------- |
| **ALIGN**   | Self Alignment + Risk Management | Choose the right outcome, manage risks | Director (Accountable) | Consulted                   |
| **LEARN**   | Effective Learning               | Find truths, analyze forces (UBS/UDS)  | Director (Accountable) | Responsible (research)      |
| **PLAN**    | Effective Thinking + Planning    | Design architecture, sequence work     | Director (Accountable) | Responsible (decomposition) |
| **EXECUTE** | Effective Execution              | Build and deliver                      | Supervisor (oversight) | Responsible (build)         |
| **IMPROVE** | (Feedback loop)                  | Collect feedback, validate, iterate    | Director (Accountable) | Responsible (analysis)      |

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

No workstream artifact is produced outside DSBV. No stage is skipped. Each gate requires explicit human approval.

**Exception:** LEARN (2-LEARN/) uses the `/learn:*` pipeline (S1-S5 + Complete), not DSBV stages. The 80-cell matrix below defines WHAT Learn produces per subsystem; the HOW is the learn pipeline.

### THE 8 EFFECTIVE SYSTEM COMPONENTS

Every sub-system is designed using the Universal 8-Component Model (UT#1). The first 4 components define the system's behavior (WHAT happens); the last 4 define the system's governance (HOW behavior is constrained). Full methodology: `_genesis/reference/ltc-effective-system-design.md`. Per-subsystem template: `_genesis/templates/vana-spec-template.md` (§0.6 8-Component Design).

| # | Component | Definition | AI Mapping | Enforcement Layer | Where Documented |
|---|-----------|-----------|------------|------------------|-----------------|
| 1 | **EI** (Effective Input) | What the system requires to operate — data, context, prompts | Prompt, context window, RAG, QMD auto-recall | `UserPromptSubmit` hook | DESIGN.md INPUT section |
| 2 | **EU** (Effective User) | The doer within the system — who is Responsible vs Accountable | Human Director (A) + AI Agent (R) per RACI | Agent scope boundaries in `.claude/agents/` | BLUEPRINT Part 3 RACI table |
| 3 | **EA** (Effective Action) | Observable execution — the emergent behavior of EU acting on EI | Tool calls, reasoning chains, file writes | `PreToolUse`/`PostToolUse` hooks | Agent output logs |
| 4 | **EO** (Effective Output) | Results of the action — deliverables, decisions, artifacts | Workstream artifacts per 80-cell matrix | VANA gate at Validate stage | DESIGN.md OUTPUT section |
| 5 | **EP** (Effective Principles) | Rules governing all actions — constraints that limit the solution space | `CLAUDE.md` + `.claude/rules/*.md` (14 EPs) | Auto-loaded every session | `_genesis/reference/ltc-effective-agent-principles-registry.md` |
| 6 | **EOE** (Effective Operating Environment) | Workspace constraints — what the agent can see and access | IDE, terminal, context window, hooks, sandbox, file permissions | `.claude/settings.json` hook registrations | `.claude/rules/enforcement-layers.md` |
| 7 | **EOT** (Effective Operating Tools) | Instruments the agent can call — external capabilities | MCP servers (Exa, QMD, Playwright), APIs, CLI, web search | Tool availability per agent file | `.claude/agents/*.md` tools field |
| 8 | **EOP** (Effective Operating Procedure) | Step-by-step procedures — the HOW for complex operations | `.claude/skills/*/SKILL.md` (28 skills) | Loaded on demand via `/commands`; HARD-GATE blocks | `_genesis/sops/alpei-standard-operating-procedure.md` |

**Design rule:** When designing any sub-system, fill in all 8 components using the ESD template. If a component is empty, the system has a governance gap. If two components conflict, EP takes precedence (Principle 3: no component is designed from void).

---

### THE 80-CELL MATRIX — Per-Subsystem Deliverable Definitions

The matrix below defines all 80 intersections of 4 subsystems x 5 workstreams x 4 stages. Each cell specifies: PURPOSE (why this work exists), OUTPUT (what it produces), TEMPLATE (starter from `_genesis/templates/`), and COMMAND (how to invoke it).

**Reading conventions:**
- **LEARN rows** map to `/learn:*` pipeline states (S1-S5), not DSBV stages. The matrix defines WHAT Learn produces; the HOW is the learn pipeline.
- **Subsystem order** follows the dependency chain: PD first (governs all), then DP, DA, IDM.
- **Version ceiling:** Each subsystem inherits EP from upstream. DP <= PD version. DA <= DP version. IDM <= DA version.
- **Path pattern:** `{W}-{WS}/{S}-{SUB}/{sub}-{name}.md` (DD-1 canonical form).

---

#### 4.5 PROBLEM DIAGNOSIS (1-PD)

> PD produces the Effective Principles that govern the entire UES. Every downstream subsystem inherits PD's EP as validated input. PD is the first subsystem to build and sets the version ceiling for all others.

**PD x ALIGN**

| Stage | Purpose | Output | Template | Command |
|-------|---------|--------|----------|---------|
| Design | Define project boundaries, stakeholders, constraints | Charter scope, Stakeholder Map, Constraint Register, Go/No-Go criteria | `charter-template.md`, `force-analysis-template.md` | `/dsbv design align pd` |
| Sequence | Design outcomes using VANA grammar | Master Plan, OKRs, Version Roadmap | `okr-template.md`, `roadmap-template.md` | `/dsbv sequence align pd` |
| Build | Finalize and lock alignment artifacts | Approved Master Plan, Signed-Off Outcomes | `charter-template.md` | `/dsbv build align pd` |
| Validate | Verify alignment completeness and correctness | Alignment validation report, corrective actions | `review-template.md` | `/dsbv validate align pd` |

Deliverable paths: `1-ALIGN/1-PD/pd-charter.md` · `1-ALIGN/1-PD/pd-okr-register.md` · `1-ALIGN/1-PD/pd-stakeholder-map.md`

**PD x LEARN (Pipeline — NOT DSBV)**

| Pipeline State | Purpose | Output | Template | Command |
|----------------|---------|--------|----------|---------|
| S1: Input | Define what to learn — scope research questions | Learning Scope, Research Questions | `learn-input-template.md` | `/learn:input pd-{slug}` |
| S2: Research | Execute UBS/UDS diagnosis, gather evidence | UBS/UDS diagnosis data, Draft EP | `research-template.md` | `/learn:research pd-{slug}` |
| S3: Structure | Organize findings into P0-P7 pages | Completed UBS/UDS analysis, Finalized EP, Solution Design | `research-methodology.md` | `/learn:structure pd-{slug}` |
| S4: Review | Verify research rigor and completeness | Learning validation report, quality assessment | `review-template.md` | `/learn:review pd-{slug}` |
| S5: Spec | Produce final VANA spec from validated research | VANA spec, locked Effective Principles | `vana-spec-template.md` | `/learn:spec pd-{slug}` |

Deliverable paths: `2-LEARN/1-PD/pd-ubs-uds.md` · `2-LEARN/1-PD/pd-effective-principles.md` · `2-LEARN/1-PD/pd-research-spec.md`

**PD x PLAN**

| Stage | Purpose | Output | Template | Command |
|-------|---------|--------|----------|---------|
| Design | Define iteration scope and priority ranking | Iteration Scope, Priority Ranking, Risk categories | `force-analysis-template.md`, `risk-entry-template.md` | `/dsbv design plan pd` |
| Sequence | Break scope into tasks with RACI and estimates | Task Breakdown, RACI, Effort Estimates, Dependencies | `sequence-template.md`, `roadmap-template.md` | `/dsbv sequence plan pd` |
| Build | Finalize execution plan and populate registers | Approved Execution Plan, Sprint Backlog, UBS Register | `architecture-template.md`, `driver-entry-template.md` | `/dsbv build plan pd` |
| Validate | Verify plan realism and risk coverage | Planning validation report, risk-adjusted schedule | `review-template.md` | `/dsbv validate plan pd` |

Deliverable paths: `3-PLAN/1-PD/pd-architecture.md` · `3-PLAN/1-PD/pd-roadmap.md` · `3-PLAN/risks/UBS_REGISTER.md` · `3-PLAN/drivers/UDS_REGISTER.md`

**PD x EXECUTE**

| Stage | Purpose | Output | Template | Command |
|-------|---------|--------|----------|---------|
| Design | Confirm sprint scope and identify blockers | Confirmed Scope, Blocker Log, Technical constraints | `design-template.md` | `/dsbv design execute pd` |
| Sequence | Design technical implementation approach | Technical Design, Test Plan, Integration points | `sequence-template.md`, `test-plan-template.md` | `/dsbv sequence execute pd` |
| Build | Build and deliver sprint artifacts | Delivered Artifacts, Test Results, Documentation | (artifact-specific per SEQUENCE.md) | `/dsbv build execute pd` |
| Validate | Verify deliverables against acceptance criteria | Execution validation report, AC pass/fail matrix | `dsbv-eval-template.md` | `/dsbv validate execute pd` |

Deliverable paths: `4-EXECUTE/1-PD/src/` · `4-EXECUTE/1-PD/tests/` · `4-EXECUTE/1-PD/docs/`

**PD x IMPROVE**

| Stage | Purpose | Output | Template | Command |
|-------|---------|--------|----------|---------|
| Design | Define feedback to collect and success metrics | Feedback Collection Plan, Metric definitions | `metrics-baseline-template.md` | `/dsbv design improve pd` |
| Sequence | Design analysis methodology and prioritization | Validation Criteria, Prioritization framework, Review schedule | `sequence-template.md` | `/dsbv sequence improve pd` |
| Build | Process feedback into actionable improvements | Feedback Register, Improvement Requests, Retro notes | `feedback-template.md`, `retro-template.md` | `/dsbv build improve pd` |
| Validate | Verify improvement rigor, package for next ALIGN cycle | Improvement validation report, recommendations for ALIGN | `review-package-template.md` | `/dsbv validate improve pd` |

Deliverable paths: `5-IMPROVE/1-PD/pd-feedback-register.md` · `5-IMPROVE/1-PD/pd-retro.md` · `5-IMPROVE/_cross/cross-metrics-baseline.md`

---

#### 4.6 DATA PIPELINE (2-DP)

> DP processes raw data into analysis-ready form. Inherits Effective Principles from PD. DP version cannot exceed PD version. Domain focus: data sources, cleaning, standardization, pipeline architecture.

**DP x ALIGN**

| Stage | Purpose | Output | Template | Command |
|-------|---------|--------|----------|---------|
| Design | Define data pipeline boundaries and data sources | Data Source Registry, Pipeline Scope, Data Quality constraints | `charter-template.md`, `force-analysis-template.md` | `/dsbv design align dp` |
| Sequence | Design data flow architecture using VANA | Pipeline Master Plan, Data OKRs, Source onboarding roadmap | `okr-template.md`, `roadmap-template.md` | `/dsbv sequence align dp` |
| Build | Finalize pipeline alignment artifacts | Approved Pipeline Plan, Data Source Agreements | `charter-template.md` | `/dsbv build align dp` |
| Validate | Verify pipeline scope covers analytical needs | Pipeline alignment validation report | `review-template.md` | `/dsbv validate align dp` |

Deliverable paths: `1-ALIGN/2-DP/dp-charter.md` · `1-ALIGN/2-DP/dp-okr-register.md`

**DP x LEARN (Pipeline — NOT DSBV)**

| Pipeline State | Purpose | Output | Template | Command |
|----------------|---------|--------|----------|---------|
| S1: Input | Define data domain learning scope | Data Source Profiles, Quality Research Questions | `learn-input-template.md` | `/learn:input dp-{slug}` |
| S2: Research | Diagnose data quality risks and pipeline patterns | Data UBS/UDS, Draft Pipeline Principles | `research-template.md` | `/learn:research dp-{slug}` |
| S3: Structure | Organize data findings into pipeline specs | Pipeline EP, Data Quality SLAs, Source Profiles | `research-methodology.md` | `/learn:structure dp-{slug}` |
| S4: Review | Verify data research completeness | Data learning validation report | `review-template.md` | `/learn:review dp-{slug}` |
| S5: Spec | Produce data pipeline VANA spec | Pipeline VANA spec, locked Data Principles | `vana-spec-template.md` | `/learn:spec dp-{slug}` |

Deliverable paths: `2-LEARN/2-DP/dp-ubs-uds.md` · `2-LEARN/2-DP/dp-effective-principles.md`

**DP x PLAN**

| Stage | Purpose | Output | Template | Command |
|-------|---------|--------|----------|---------|
| Design | Define pipeline iteration scope | Data Iteration Scope, Pipeline Priority Ranking | `force-analysis-template.md`, `risk-entry-template.md` | `/dsbv design plan dp` |
| Sequence | Break into pipeline tasks with estimates | Pipeline Task Breakdown, Data RACI, ETL dependencies | `sequence-template.md`, `roadmap-template.md` | `/dsbv sequence plan dp` |
| Build | Finalize pipeline execution plan | Pipeline Architecture, Data Sprint Backlog | `architecture-template.md`, `driver-entry-template.md` | `/dsbv build plan dp` |
| Validate | Verify pipeline plan against data quality SLAs | Pipeline planning validation report | `review-template.md` | `/dsbv validate plan dp` |

Deliverable paths: `3-PLAN/2-DP/dp-architecture.md` · `3-PLAN/2-DP/dp-roadmap.md`

**DP x EXECUTE**

| Stage | Purpose | Output | Template | Command |
|-------|---------|--------|----------|---------|
| Design | Confirm pipeline sprint scope and data blockers | Confirmed Data Scope, Data Blocker Log | `design-template.md` | `/dsbv design execute dp` |
| Sequence | Design ETL implementation and data tests | Pipeline Technical Design, Data Test Plan, Cleaning rules | `sequence-template.md`, `test-plan-template.md` | `/dsbv sequence execute dp` |
| Build | Build pipeline: extraction, cleaning, standardization | Delivered Pipeline Code, Data Test Results, Pipeline Docs | (artifact-specific per SEQUENCE.md) | `/dsbv build execute dp` |
| Validate | Verify pipeline output against data quality SLAs | Pipeline execution validation report | `dsbv-eval-template.md` | `/dsbv validate execute dp` |

Deliverable paths: `4-EXECUTE/2-DP/src/` · `4-EXECUTE/2-DP/tests/` · `4-EXECUTE/2-DP/config/`

**DP x IMPROVE**

| Stage | Purpose | Output | Template | Command |
|-------|---------|--------|----------|---------|
| Design | Define data quality feedback metrics | Data Quality Metric Plan, Pipeline health criteria | `metrics-baseline-template.md` | `/dsbv design improve dp` |
| Sequence | Design pipeline monitoring and analysis approach | Data Validation Criteria, Quality Prioritization | `sequence-template.md` | `/dsbv sequence improve dp` |
| Build | Process data quality feedback | Data Quality Register, Pipeline Improvement Requests | `feedback-template.md`, `retro-template.md` | `/dsbv build improve dp` |
| Validate | Verify pipeline improvement rigor | Pipeline improvement validation, package for ALIGN | `review-package-template.md` | `/dsbv validate improve dp` |

Deliverable paths: `5-IMPROVE/2-DP/dp-feedback-register.md` · `5-IMPROVE/2-DP/dp-retro.md`

---

#### 4.7 DATA ANALYTICS (3-DA)

> DA extracts insights from pipeline-processed data. Inherits Effective Principles from DP. DA version cannot exceed DP version. Domain focus: analytical methods, statistical rigor, insight generation, confidence scoring.

**DA x ALIGN**

| Stage | Purpose | Output | Template | Command |
|-------|---------|--------|----------|---------|
| Design | Define analytical boundaries and methods | Analysis Scope, Method Registry, Statistical constraints | `charter-template.md`, `force-analysis-template.md` | `/dsbv design align da` |
| Sequence | Design analytical architecture using VANA | Analysis Master Plan, Insight OKRs, Method roadmap | `okr-template.md`, `roadmap-template.md` | `/dsbv sequence align da` |
| Build | Finalize analytical alignment artifacts | Approved Analysis Plan, Method Agreements | `charter-template.md` | `/dsbv build align da` |
| Validate | Verify analytical scope covers decision needs | Analysis alignment validation report | `review-template.md` | `/dsbv validate align da` |

Deliverable paths: `1-ALIGN/3-DA/da-charter.md` · `1-ALIGN/3-DA/da-okr-register.md`

**DA x LEARN (Pipeline — NOT DSBV)**

| Pipeline State | Purpose | Output | Template | Command |
|----------------|---------|--------|----------|---------|
| S1: Input | Define analytical learning scope | Method Research Questions, Statistical rigor requirements | `learn-input-template.md` | `/learn:input da-{slug}` |
| S2: Research | Diagnose analytical risks and method patterns | Analytical UBS/UDS, Draft Analysis Principles | `research-template.md` | `/learn:research da-{slug}` |
| S3: Structure | Organize findings into methodology specs | Analysis EP, Statistical Standards, Method Profiles | `research-methodology.md` | `/learn:structure da-{slug}` |
| S4: Review | Verify analytical research rigor | Analysis learning validation report | `review-template.md` | `/learn:review da-{slug}` |
| S5: Spec | Produce analytical VANA spec | Analysis VANA spec, locked Analysis Principles | `vana-spec-template.md` | `/learn:spec da-{slug}` |

Deliverable paths: `2-LEARN/3-DA/da-ubs-uds.md` · `2-LEARN/3-DA/da-effective-principles.md`

**DA x PLAN**

| Stage | Purpose | Output | Template | Command |
|-------|---------|--------|----------|---------|
| Design | Define analysis iteration scope | Analysis Iteration Scope, Method Priority Ranking | `force-analysis-template.md`, `risk-entry-template.md` | `/dsbv design plan da` |
| Sequence | Break into analysis tasks with estimates | Analysis Task Breakdown, Analyst RACI, Method dependencies | `sequence-template.md`, `roadmap-template.md` | `/dsbv sequence plan da` |
| Build | Finalize analysis execution plan | Analysis Architecture, Analysis Sprint Backlog | `architecture-template.md`, `driver-entry-template.md` | `/dsbv build plan da` |
| Validate | Verify analysis plan against statistical standards | Analysis planning validation report | `review-template.md` | `/dsbv validate plan da` |

Deliverable paths: `3-PLAN/3-DA/da-architecture.md` · `3-PLAN/3-DA/da-roadmap.md`

**DA x EXECUTE**

| Stage | Purpose | Output | Template | Command |
|-------|---------|--------|----------|---------|
| Design | Confirm analysis sprint scope | Confirmed Analysis Scope, Method Blocker Log | `design-template.md` | `/dsbv design execute da` |
| Sequence | Design analytical implementation and validation | Analysis Technical Design, Statistical Test Plan | `sequence-template.md`, `test-plan-template.md` | `/dsbv sequence execute da` |
| Build | Execute analysis: compute insights, validate statistically | Delivered Insights with confidence, Analysis Documentation | (artifact-specific per SEQUENCE.md) | `/dsbv build execute da` |
| Validate | Verify insights against statistical rigor criteria | Analysis execution validation report | `dsbv-eval-template.md` | `/dsbv validate execute da` |

Deliverable paths: `4-EXECUTE/3-DA/src/` · `4-EXECUTE/3-DA/notebooks/` · `4-EXECUTE/3-DA/docs/`

**DA x IMPROVE**

| Stage | Purpose | Output | Template | Command |
|-------|---------|--------|----------|---------|
| Design | Define insight quality feedback metrics | Insight Quality Metric Plan, Analysis accuracy criteria | `metrics-baseline-template.md` | `/dsbv design improve da` |
| Sequence | Design analysis monitoring methodology | Insight Validation Criteria, Accuracy Prioritization | `sequence-template.md` | `/dsbv sequence improve da` |
| Build | Process analytical feedback | Insight Quality Register, Analysis Improvement Requests | `feedback-template.md`, `retro-template.md` | `/dsbv build improve da` |
| Validate | Verify analysis improvement rigor | Analysis improvement validation, package for ALIGN | `review-package-template.md` | `/dsbv validate improve da` |

Deliverable paths: `5-IMPROVE/3-DA/da-feedback-register.md` · `5-IMPROVE/3-DA/da-retro.md`

---

#### 4.8 INSIGHTS & DECISION MAKING (4-IDM)

> IDM converts analyzed insights into actionable decisions with risk management. Terminal subsystem in the pipeline — receives from DA, feeds back to ALL upstream subsystems via the improvement loop. Domain focus: dashboards, decision recommendations, risk alerts, SOPs.

**IDM x ALIGN**

| Stage | Purpose | Output | Template | Command |
|-------|---------|--------|----------|---------|
| Design | Define decision framework boundaries and risk appetite | Decision Scope, Stakeholder Decision Map, Risk appetite | `charter-template.md`, `force-analysis-template.md` | `/dsbv design align idm` |
| Sequence | Design decision architecture using VANA | Decision Master Plan, Decision OKRs, Dashboard roadmap | `okr-template.md`, `roadmap-template.md` | `/dsbv sequence align idm` |
| Build | Finalize decision alignment artifacts | Approved Decision Plan, Stakeholder Sign-Off | `charter-template.md` | `/dsbv build align idm` |
| Validate | Verify decision scope covers stakeholder needs | Decision alignment validation report | `review-template.md` | `/dsbv validate align idm` |

Deliverable paths: `1-ALIGN/4-IDM/idm-charter.md` · `1-ALIGN/4-IDM/idm-okr-register.md`

**IDM x LEARN (Pipeline — NOT DSBV)**

| Pipeline State | Purpose | Output | Template | Command |
|----------------|---------|--------|----------|---------|
| S1: Input | Define decision-making learning scope | Decision Framework Research Questions, UX requirements | `learn-input-template.md` | `/learn:input idm-{slug}` |
| S2: Research | Diagnose decision risks and presentation patterns | Decision UBS/UDS, Draft Decision Principles | `research-template.md` | `/learn:research idm-{slug}` |
| S3: Structure | Organize findings into decision framework specs | Decision EP, SOP Standards, Dashboard Patterns | `research-methodology.md` | `/learn:structure idm-{slug}` |
| S4: Review | Verify decision research completeness | Decision learning validation report | `review-template.md` | `/learn:review idm-{slug}` |
| S5: Spec | Produce decision-making VANA spec | Decision VANA spec, locked Decision Principles | `vana-spec-template.md` | `/learn:spec idm-{slug}` |

Deliverable paths: `2-LEARN/4-IDM/idm-ubs-uds.md` · `2-LEARN/4-IDM/idm-effective-principles.md`

**IDM x PLAN**

| Stage | Purpose | Output | Template | Command |
|-------|---------|--------|----------|---------|
| Design | Define decision iteration scope and dashboard priorities | Decision Iteration Scope, Dashboard Priority Ranking | `force-analysis-template.md`, `risk-entry-template.md` | `/dsbv design plan idm` |
| Sequence | Break into decision tasks with estimates | Decision Task Breakdown, Decision RACI, Dashboard dependencies | `sequence-template.md`, `roadmap-template.md` | `/dsbv sequence plan idm` |
| Build | Finalize decision execution plan | Decision Architecture, Decision Sprint Backlog | `architecture-template.md`, `driver-entry-template.md` | `/dsbv build plan idm` |
| Validate | Verify decision plan against stakeholder needs | Decision planning validation report | `review-template.md` | `/dsbv validate plan idm` |

Deliverable paths: `3-PLAN/4-IDM/idm-architecture.md` · `3-PLAN/4-IDM/idm-roadmap.md`

**IDM x EXECUTE**

| Stage | Purpose | Output | Template | Command |
|-------|---------|--------|----------|---------|
| Design | Confirm decision sprint scope and integration points | Confirmed Decision Scope, Integration Blocker Log | `design-template.md` | `/dsbv design execute idm` |
| Sequence | Design dashboard and SOP implementation | Decision Technical Design, Dashboard Test Plan, SOP drafts | `sequence-template.md`, `test-plan-template.md`, `sop-template.md` | `/dsbv sequence execute idm` |
| Build | Build dashboards, decision recommendations, risk alerts, SOPs | Delivered Dashboards, Decision SOPs, Risk Alert System | (artifact-specific per SEQUENCE.md) | `/dsbv build execute idm` |
| Validate | Verify decision outputs against stakeholder ACs | Decision execution validation report | `dsbv-eval-template.md` | `/dsbv validate execute idm` |

Deliverable paths: `4-EXECUTE/4-IDM/src/` · `4-EXECUTE/4-IDM/docs/` · `4-EXECUTE/4-IDM/config/`

**IDM x IMPROVE**

| Stage | Purpose | Output | Template | Command |
|-------|---------|--------|----------|---------|
| Design | Define decision quality and stakeholder satisfaction metrics | Decision Quality Metric Plan, Satisfaction criteria | `metrics-baseline-template.md` | `/dsbv design improve idm` |
| Sequence | Design decision monitoring and UX analysis approach | Decision Validation Criteria, UX Prioritization | `sequence-template.md` | `/dsbv sequence improve idm` |
| Build | Process decision feedback from all stakeholders | Decision Quality Register, UX Improvement Requests | `feedback-template.md`, `retro-template.md` | `/dsbv build improve idm` |
| Validate | Verify improvement rigor, package feedback to ALL subsystems | Cross-subsystem improvement validation, feedback package | `review-package-template.md` | `/dsbv validate improve idm` |

Deliverable paths: `5-IMPROVE/4-IDM/idm-feedback-register.md` · `5-IMPROVE/4-IDM/idm-retro.md` · `5-IMPROVE/_cross/cross-version-review.md`

---

## PART 5: ROADMAP — VANA + ACCEPTANCE CRITERIA

### ITERATION-TO-VERSION MAPPING

| Iteration | UES Version | Pillar | VANA |
|-----------|-------------|--------|------|
| Iteration 0 | Logic Scaffold | — | Understand and design the AI-OS scope clearly and completely |
| Iteration 1 | Concept | Sustainability | Derisk and deliver the agent infrastructure correctly and safely |
| Iteration 2 | Prototype | Efficiency | Derisk and deliver an Obsidian-integrated PM workflow correctly, safely, and efficiently |
| Iteration 3 | MVE | Full Efficiency | Derisk and deliver the full AI-OS reliably and efficiently for 6 projects |
| Iteration 4 | Leadership | Scalability | Derisk and deliver a self-improving AI-OS that operates automatically and prescriptively |

---

### Iteration 0: LOGIC SCAFFOLD (COMPLETE — RETROSPECTIVE)

Vinh's 9 canonical frameworks captured in `_genesis/frameworks/`. Folder structure defined. CLAUDE.md created. No automation, no agents, no enforcement.

---

### Iteration 1: CONCEPT — CORRECTLY AND SAFELY (COMPLETE — RETROSPECTIVE)

**VANA:** Derisk and deliver the agent infrastructure correctly and safely.

1. A new PM can read the BLUEPRINT and understand the project's EO without asking Long.
2. The agent runs without hallucinating workstream or sub-system assignments.
3. Every artifact produced by the agent traces to a named UBS or UDS in the register.
4. A session ends and restarts without losing context (compress + resume cycle works).
5. All 67 acceptance criteria pass on a clean checkout.
6. No secrets appear in any committed file.
7. A DSBV stage cannot advance without explicit human approval.

---

### Iteration 2: PROTOTYPE — EFFICIENTLY (CURRENT)

**VANA:** Derisk and deliver an Obsidian-integrated PM workflow correctly, safely, and efficiently.

1. A new PM can check project status in under 30 seconds via Obsidian Bases — no terminal needed.
2. A new PM can identify the next task via `/dsbv status` without reading DESIGN.md.
3. A new PM can onboard without verbal instruction — template materials are sufficient.
4. A new PM can create a correctly-frontmatted artifact via Templater in under 1 minute.
5. The PM never needs to hand-craft YAML frontmatter — Templater auto-fills all required fields.
6. All Iteration 1 acceptance criteria still pass after Iteration 2 changes are applied.
7. A context switch between projects takes under 2 minutes using `/resume`.
8. The 18 Obsidian Bases dashboards (C1-C7, W1-W5, U1-U6) show accurate live views — never stale data.

---

### Iteration 3: MVE — RELIABLY FOR 6 PROJECTS (DIRECTIONAL)

**VANA:** Derisk and deliver the full AI-OS reliably and efficiently across all 6 LTC investment projects.

1. A new PM at any of the 6 projects onboards using only the template — no per-project verbal coaching.
2. All 6 projects share a consistent frontmatter schema — cross-project Bases queries work.
3. A project handoff (PM leaves → new PM continues) completes within 1 working day.
4. No project is blocked waiting for a framework update in `_genesis/` — template upgrades merge cleanly.
5. At least 1 project has >=1 sub-system at Concept version with a validated UBS/UDS analysis.

---

### Iteration 4: LEADERSHIP — AUTOMATICALLY (DIRECTIONAL)

**VANA:** Derisk and deliver a self-improving AI-OS that operates automatically, predictively, and prescriptively.

1. The system executes >=50% of routine PM tasks without human initiation.
2. The system forecasts blockers >=3 days before they surface.
3. New team members receive personalized onboarding recommendations based on skill profile.

---

## PART 6: UBS/UDS REGISTER — THIS PROJECT

**Framework:** `_genesis/frameworks/ltc-ubs-uds-framework.md`

### ULTIMATE BLOCKING SYSTEM (UBS)

| ID | Blocker | Mechanism | Severity | Disabled By |
|----|---------|-----------|----------|-------------|
| UBS-1 | Junior team lacks ALPEI mental model | PM cargo-cults process without understanding → AI slop | CRITICAL | Principle 4 (training before tooling), LEARN workstream |
| UBS-2 | Over-engineering before value delivery | 42 skills + 14 dashboards before a single deliverable | HIGH | Phased rollout (Iteration 2: 6 dashboards, not 14) |
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
| UDS-6 | First-mover advantage | No competing AI-OS for investment PM in market | MEDIUM | Ship Iteration 2-Iteration 3 in 2026 before larger firms standardize |

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
version: "1.0"           # MAJOR = iteration (Iteration 1=1.x), MINOR = edit count
status: draft             # S2 vocabulary: draft | in-progress | in-review | validated | archived
                          # (human only sets: validated)
last_updated: 2026-04-03  # Always absolute date
type: ues-deliverable     # ues-deliverable | template | learning-source | reference
sub_system: 1-PD          # 1-PD | 2-DP | 3-DA | 4-IDM | _cross
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

| Agent | Model | DSBV Stage | Tools | Scope Boundary |
|-------|-------|-----------|-------|----------------|
| ltc-planner | Opus | Design + Sequence | Read, Glob, Grep, WebFetch, Exa, QMD | No file writes to 4-EXECUTE/ |
| ltc-builder | Sonnet | Build | Read, Edit, Write, Bash, Grep | From approved sequences only |
| ltc-reviewer | Opus | Validate | Read, Glob, Grep, Bash | Read-only, never modifies artifacts |
| ltc-explorer | Haiku | Pre-DSBV | Read, Glob, Grep, Exa, QMD | No commits, no file writes |

### TABLE 5: DELIVERABLE PATH LOOKUP (80-CELL)

> Quick-reference for agents to resolve subsystem x workstream to a file path. Pattern: `{W}-{WS}/{S}-{SUB}/{sub}-{name}.md`

| Sub-System | ALIGN | LEARN | PLAN | EXECUTE | IMPROVE |
|------------|-------|-------|------|---------|---------|
| **1-PD** | `pd-charter.md` `pd-okr-register.md` `pd-stakeholder-map.md` | `pd-ubs-uds.md` `pd-effective-principles.md` `pd-research-spec.md` | `pd-architecture.md` `pd-roadmap.md` | `src/` `tests/` `docs/` | `pd-feedback-register.md` `pd-retro.md` |
| **2-DP** | `dp-charter.md` `dp-okr-register.md` | `dp-ubs-uds.md` `dp-effective-principles.md` | `dp-architecture.md` `dp-roadmap.md` | `src/` `tests/` `config/` | `dp-feedback-register.md` `dp-retro.md` |
| **3-DA** | `da-charter.md` `da-okr-register.md` | `da-ubs-uds.md` `da-effective-principles.md` | `da-architecture.md` `da-roadmap.md` | `src/` `notebooks/` `docs/` | `da-feedback-register.md` `da-retro.md` |
| **4-IDM** | `idm-charter.md` `idm-okr-register.md` | `idm-ubs-uds.md` `idm-effective-principles.md` | `idm-architecture.md` `idm-roadmap.md` | `src/` `docs/` `config/` | `idm-feedback-register.md` `idm-retro.md` |
| **_cross** | `cross-stakeholder-map.md` `cross-stakeholder-raci.md` | — | `UBS_REGISTER.md` `UDS_REGISTER.md` | — | `cross-metrics-baseline.md` `cross-feedback-register.md` `cross-version-review.md` |

### TABLE 6: TEMPLATE LOOKUP (Per Stage)

| Stage | Templates | Agent |
|-------|-----------|-------|
| Design | `design-template.md`, `charter-template.md`, `force-analysis-template.md`, `metrics-baseline-template.md` | ltc-planner |
| Sequence | `sequence-template.md`, `okr-template.md`, `roadmap-template.md`, `driver-entry-template.md`, `risk-entry-template.md` | ltc-planner |
| Build | `charter-template.md`, `architecture-template.md`, `feedback-template.md`, `retro-template.md`, `sop-template.md`, `test-plan-template.md` | ltc-builder |
| Validate | `review-template.md`, `dsbv-eval-template.md`, `review-package-template.md` | ltc-reviewer |
| Learn (pipeline) | `learn-input-template.md`, `research-template.md`, `research-methodology.md`, `vana-spec-template.md` | ltc-explorer + ltc-builder |

---

## PART 8: CHAIN-OF-CUSTODY HANDOFF TABLES

> These tables define what crosses the boundary between sequential subsystems. Each handoff is a contract: the upstream subsystem commits to delivering these artifacts, and the downstream subsystem may not proceed until they are validated. Derived from Vinh's subsystem interface definitions and Principle 6 (PD governs all).

### PD → DP HANDOFF

| # | Handoff Artifact | Source (PD) | Consumer (DP) | Validation Gate |
|---|------------------|-------------|---------------|-----------------|
| 1 | Effective Principles | `2-LEARN/1-PD/pd-effective-principles.md` | Inherited as DP's governing principles | PD EP must be `status: validated` |
| 2 | UBS/UDS Analysis | `2-LEARN/1-PD/pd-ubs-uds.md` | Informs data quality risk identification | PD UBS/UDS must be `status: validated` |
| 3 | Design Guidelines | `3-PLAN/1-PD/pd-architecture.md` | Constrains pipeline architecture decisions | PD architecture must be approved |
| 4 | Solution Design | `4-EXECUTE/1-PD/docs/` | Technical reference for pipeline implementation | PD execution artifacts delivered |

**Rule:** DP cannot begin DSBV Build until PD has >=1 validated artifact in LEARN and ALIGN. DP's Effective Principles must not contradict PD's EP.

### DP → DA HANDOFF

| # | Handoff Artifact | Source (DP) | Consumer (DA) | Validation Gate |
|---|------------------|-------------|---------------|-----------------|
| 1 | Analysis-ready data | `4-EXECUTE/2-DP/src/` (pipeline output) | Primary input for all analytical work | Pipeline tests pass, data quality SLAs met |
| 2 | Pipeline Principles | `2-LEARN/2-DP/dp-effective-principles.md` | Inherited as DA's data-handling principles | DP EP must be `status: validated` |
| 3 | Data Quality SLAs | `2-LEARN/2-DP/dp-ubs-uds.md` | Defines acceptable data quality thresholds | DP UBS/UDS must be `status: validated` |
| 4 | Source Profiles | `2-LEARN/2-DP/` (research artifacts) | Context for analytical method selection | DP research complete |

**Rule:** DA cannot begin DSBV Build until DP has validated pipeline output. DA's analytical methods must respect DP's data quality SLAs.

### DA → IDM HANDOFF

| # | Handoff Artifact | Source (DA) | Consumer (IDM) | Validation Gate |
|---|------------------|-------------|----------------|-----------------|
| 1 | Analyzed insights with confidence | `4-EXECUTE/3-DA/notebooks/`, `docs/` | Primary input for decision recommendations | Insights validated with confidence intervals |
| 2 | Validated conclusions | `5-IMPROVE/3-DA/da-feedback-register.md` | Feeds decision quality assessment | DA validation report approved |
| 3 | Methodology documentation | `2-LEARN/3-DA/da-effective-principles.md` | Ensures IDM understands analytical basis | DA EP must be `status: validated` |
| 4 | Flagged risks | `3-PLAN/3-DA/da-architecture.md` | Informs decision risk management | DA risk entries present in register |

**Rule:** IDM cannot begin DSBV Build until DA has validated analytical output. IDM's decision recommendations must cite DA's confidence levels.

### IDM → ALL SUBSYSTEMS (Feedback Loop)

> IDM is the terminal subsystem. Its IMPROVE workstream feeds back to ALL upstream subsystems, closing the ALPEI loop. This is the mechanism by which the system self-corrects.

| # | Feedback Type | Target Subsystem | Artifact | Action |
|---|--------------|-----------------|----------|--------|
| 1 | Data quality issues | DP (2-DP) | `5-IMPROVE/4-IDM/idm-feedback-register.md` | DP re-evaluates pipeline for flagged quality gaps |
| 2 | Analytical gaps | DA (3-DA) | `5-IMPROVE/4-IDM/idm-feedback-register.md` | DA investigates missed patterns or method limitations |
| 3 | Diagnostic blind spots | PD (1-PD) | `5-IMPROVE/4-IDM/idm-feedback-register.md` | PD updates UBS/UDS if new risks/drivers identified |
| 4 | UX and presentation issues | IDM (4-IDM) | `5-IMPROVE/4-IDM/idm-feedback-register.md` | IDM self-improves dashboard and SOP design |

**Rule:** IDM IMPROVE validation (G4) must include cross-subsystem feedback categorization. Each feedback item must name its target subsystem. Target subsystems incorporate feedback in their next ALIGN cycle.

```
IDM IMPROVE → PD ALIGN (blind spots)
IDM IMPROVE → DP ALIGN (data quality)
IDM IMPROVE → DA ALIGN (analytical gaps)
IDM IMPROVE → IDM ALIGN (UX issues)
```

---

## Links

- [[AGENTS]]
- [[CLAUDE]]
- [[DESIGN]]
- [[EP-13]]
- [[SEQUENCE]]
- [[SKILL]]
- [[UBS-1]]
- [[UBS-7]]
- [[UDS-2]]
- [[UDS-3]]
- [[VALIDATE]]
- [[agent-system]]
- [[alpei-dsbv-process-map]]
- [[alpei-standard-operating-procedure]]
- [[architecture]]
- [[blocker]]
- [[charter]]
- [[deliverable]]
- [[documentation]]
- [[filesystem-blueprint]]
- [[filesystem-routing]]
- [[friction]]
- [[iteration]]
- [[learn-input-template]]
- [[ltc-10-ultimate-truths]]
- [[ltc-builder]]
- [[ltc-company-handbook]]
- [[ltc-effective-agent-principles-registry]]
- [[ltc-effective-system-design-blueprint]]
- [[ltc-effectiveness-guide]]
- [[ltc-explorer]]
- [[ltc-planner]]
- [[ltc-reviewer]]
- [[ltc-ubs-uds-framework]]
- [[ltc-ues-versioning]]
- [[methodology]]
- [[project]]
- [[research-methodology]]
- [[research-template]]
- [[roadmap]]
- [[schema]]
- [[sop-template]]
- [[task]]
- [[ues-deliverable]]
- [[vana-spec-template]]
- [[workstream]]
