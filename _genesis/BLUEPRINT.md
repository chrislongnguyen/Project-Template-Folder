---
version: "1.0"
status: Draft
last_updated: 2026-04-03
owner: "Long Nguyen"
workstream: ALIGN
type: charter
---

# LTC AI OPERATING SYSTEM — BLUEPRINT

> This document is the bedrock for all iterations (I0–I4) of the LTC Project Template.
> It derives from Vinh Nguyen's ALPEI Framework, the 10 Ultimate Truths, and the 7-Component Agent System.
> Every EOP, EOT, and EOE built in this project must trace back to a principle stated here.
> No principle is designed from void — each tackles a named UBS or amplifies a named UDS.

---

## PART 1: PHILOSOPHY

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

---

## PART 2: PRINCIPLES

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

Physical folder structure encodes at most 3 dimensions:

```
Level 1: ALPEI workstream (1-ALIGN, 2-LEARN, 3-PLAN, 4-EXECUTE, 5-IMPROVE)
Level 2: Sub-system (PD, DP, DA, IDM) or cross-cutting (_cross)
Level 3: Files
```

DSBV stage, 8-component model, UES version, iteration number, and status are encoded in YAML frontmatter. Obsidian Bases dashboards provide multiple views over this frontmatter without physical folder nesting.

**Why:** Game repos use deep nesting because binary assets have no searchable metadata. Markdown files have unlimited frontmatter — folder depth duplicates what metadata already provides. HCI research: beyond 3-4 levels, navigation time increases superlinearly (Allen, 1984). Obsidian community consensus: max 2-3 levels (forum surveys, 2022-2025). 160 empty folders at I0 paralyzes junior PMs (GAN analysis, this session).

**Decision made:** 3-level structure won the adversarial GAN analysis 25/28 vs 18/28. The one concession: 4-EXECUTE may have a 4th level for code (src/tests/config) but NOT for documents.

---

### PRINCIPLE 8: GOVERNANCE IS INJECTED, NOT REFERENCED

Rules that agents must follow are auto-loaded into every session via `.claude/rules/` (always-on). Rules that require explicit lookup have near-0% compliance. Rules embedded in context have near-100% compliance [Research Axis 1, Source 16].

The governance stack:
1. **EP (Effective Principles):** CLAUDE.md + .claude/rules/ — always loaded, constrains everything
2. **EOP (Effective Operating Procedures):** .claude/skills/ — loaded on demand via /commands
3. **EOE (Effective Operating Environment):** IDE, terminal, context window, hooks, sandbox
4. **EOT (Effective Operating Tools):** MCP servers, APIs, CLI, web search

**Why:** Policy-as-code is the only approach that scales for distributed autonomous agents (Research Axis 1, Source 17). Documentation-only governance produces "AI theater" (Research Axis 1, Source 21).

---

## PART 3: FRAMEWORK OVERVIEW

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

The 4 sub-systems are MECE for the **analytical engine** of investment decision-making. Portfolio construction, trade execution, risk monitoring, and client reporting are adjacent operational systems — not sub-systems of the analytical pipeline (Research Axis 2 validation).

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

### THE 4-LAYER AI-OS ARCHITECTURE

| Layer | What | Tool | Compensates For | Status |
|-------|------|------|-----------------|--------|
| 1. Knowledge Graph | .md files linked via wikilinks + frontmatter | Obsidian | LT-6 (no persistent memory), stale context | I1: partial (QMD + Grep) |
| 2. Dashboards | Database views over frontmatter properties | Obsidian Bases | Cognitive load, folder navigation | I2: not yet built |
| 3. Skills | Executable ALPEI procedures as /commands | Claude Code | LT-3 (reasoning degradation), process enforcement | I1: 22 skills shipped |
| 4. Governance | Auto-loaded rules constraining all agents | .claude/rules/ | LT-8 (alignment approximate), governance theater | I1: 7 rules shipped |

---

## PART 4: DEVELOPMENT ROADMAP — AI-FIRST SYSTEM DESIGN BY ITERATION

> This roadmap specifies the 8 Effective System Components at each UES version level.
> The "system" being built is the LTC AI Operating System — an AI-first system where:
> - The **EU (Effective User)** is the Human PM (Accountable) + AI Agent (Responsible)
> - The **primary interface** is IDE (Claude Code / Cursor) + Obsidian vault
> - Every component compensates for named LLM Truths (LT-1 through LT-8)
> - Every component addresses named UBS entries or amplifies named UDS entries
>
> Technology baseline: April 2026. Claude Opus 4.6 (1M context), Claude Code CLI + desktop,
> Obsidian Bases (shipped Aug 2025), MCP protocol, QMD semantic search, GitNexus code graphs.

---

### ITERATION-TO-VERSION MAPPING

| Iteration | UES Version | Pillar | VANA Verb | VANA Adverbs | VANA Noun | VANA Adjectives |
|-----------|-------------|--------|-----------|--------------|-----------|-----------------|
| **I0** | Logic Scaffold | (Pre-build) | Understand and design | Clearly, completely | Scope and logic of the AI-OS | Clear, complete |
| **I1** | Concept | Sustainability | Derisk and deliver | Correctly, safely | Agent infrastructure | Correct, safe |
| **I2** | Prototype | Efficiency (emerging) | Derisk and deliver | Correctly, safely, more easily, higher output | Obsidian-integrated PM workflow | Correct, safe, efficient |
| **I3** | MVE | Efficiency (full) | Derisk and deliver | Correctly, safely, reliably, efficiently | Full AI-OS for 6 projects | Correct, safe, reliable, cost-effective |
| **I4** | Leadership | Scalability | Derisk and deliver | Automatically, predictively, prescriptively | Self-improving AI-OS | Automatic, predictive, prescriptive |

---

### I0: LOGIC SCAFFOLD — UNDERSTAND AND DESIGN (COMPLETE)

**EO:** Understand and design the scope and logic of the LTC AI Operating System clearly and completely.

| Component | I0 State | What Exists | What Does NOT Exist |
|-----------|----------|-------------|---------------------|
| **EI** (Input) | Raw, unstructured | Vinh's ALPEI PDFs, whiteboard photos, verbal discussions | No structured input pipeline, no frontmatter schema |
| **EU** (User) | Single builder | Long (sole builder), Vinh (consulted verbally) | No other PMs using the system, no RACI enforcement |
| **EA** (Action) | Manual | Manual file creation, copy-paste from Vinh's docs | No agent orchestration, no DSBV flow |
| **EO** (Output) | Scaffold only | Initial folder structure, _genesis/ frameworks captured | No working skills, no tests, no dashboards |
| **EP** (Principles) | Documented but not enforced | 9 Vinh blueprint files in _genesis/frameworks/ | No auto-loaded rules, no governance-as-code |
| **EOE** (Environment) | Terminal only | Claude Code CLI in a single terminal | No Obsidian, no multi-agent, no context management |
| **EOT** (Tools) | Basic file tools | Read, Write, Grep, Bash | No QMD, no Obsidian CLI, no MCP servers |
| **EOP** (Procedure) | None formalized | Vinh's verbal instructions captured as transcripts | No skills, no /dsbv, no /compress, no /resume |

**Exit criteria (met):** Scope mapped. 9 canonical frameworks captured. Folder structure defined. CLAUDE.md created.

---

### I1: CONCEPT — SUSTAINABILITY (COMPLETE)

**EO:** Derisk and deliver the agent infrastructure correctly and safely.

**Pillar focus:** Sustainability — prove the system is correct and safe before optimizing.

| Component | I1 State | Capabilities Delivered | LT Compensated | UBS Disabled |
|-----------|----------|----------------------|-----------------|--------------|
| **EI** (Input) | Structured | CLAUDE.md (project rules), .claude/rules/ (always-loaded), memory/ (tiered: MEMORY.md index + topic files), session logs (v2 schema with rich frontmatter) | LT-6 (no persistent memory), LT-2 (context compression) | UBS-3 (stale context) — partially, memory still file-based |
| **EU** (User) | Human Director + 4 Agents | **Human:** Long as Accountable Director. **Agents:** ltc-planner (Opus, Design+Seq), ltc-builder (Sonnet, Build), ltc-reviewer (Opus, Validate), ltc-explorer (Haiku, Pre-DSBV). RACI enforced per agent file. | LT-3 (reasoning degradation — decompose across specialized agents), LT-7 (cost — route to cheapest capable model) | UBS-6 (governance theater) — agents have explicit scope boundaries |
| **EA** (Action) | Agent-assisted with gates | Agent builds via DSBV sub-process. Human gates at every phase transition. 67 acceptance criteria validated across 13 test scripts. A/B tested hybrid approach (1.9× fewer tool calls). | LT-1 (hallucination — tests catch it), LT-8 (alignment approximate — human gates catch drift) | UBS-7 (second-system effect) — DSBV forces scope discipline |
| **EO** (Output) | Correct infrastructure | 7 rules, 22 skills, 4 agents, 67-AC test suite, Obsidian CLI skill, session lifecycle (/compress + /resume), vault scaffold with 41 Templater templates, 336-file autolinker run | — | — |
| **EP** (Principles) | Auto-loaded governance | 7 always-on rules: alpei-pre-flight, alpei-chain-of-custody, dsbv, versioning, git-conventions, agent-dispatch, alpei-template-usage. Loaded into every Claude Code session automatically via .claude/rules/. Token-optimized (~50% reduction). | LT-8 (alignment) — rules constrain all agent behavior. LT-5 (plausibility) — VANA criteria force honest evaluation. | UBS-6 (governance theater) — injected, not referenced |
| **EOE** (Environment) | Claude Code + Obsidian (partial) | Claude Code CLI (Opus 4.6, 1M context). Obsidian vault registered. QMD indexing 1984 documents. Git workflow with branch strategy (I0-I4). PreToolUse hooks for rule warnings. Context budget: EP ~3K tokens, rest for work. | LT-2 (context compression) — token optimization keeps rules lean. LT-7 (cost) — model routing (Haiku for search, Sonnet for build, Opus for design). | UBS-5 (Obsidian friction) — partially, vault is registered but Bases not deployed |
| **EOT** (Tools) | 3-tool routing | **Tier 1:** QMD semantic search (1984 docs indexed, Cypher queries). **Tier 2:** Obsidian CLI (vault search, backlinks, graph queries — .md only). **Tier 3:** Grep/Glob (fallback for all file types including .sh, .json, .yaml). **Tier 4:** Web search (Exa MCP). Session tools: /compress (≤500 token output), /resume (≤5K token 2-pass). | LT-4 (retrieval fragile) — tiered routing puts best tool first. LT-6 (no memory) — /compress + /resume bridge sessions. | UBS-3 (stale context) — session lifecycle prevents context loss between sessions |
| **EOP** (Procedure) | 22 skills | /dsbv (guided DSBV flow), /compress, /resume, /git-save, /deep-research (4 modes), /slide-deck, /notion-planner, /obsidian, /ltc-brand-identity, /ltc-rules-compliance, /ltc-naming-rules, /code-review, /init, /simplify, and 8 others. Each skill = a SKILL.md with HARD-GATEs, steps, gotchas, and verification gates. | LT-3 (reasoning) — skills decompose complex tasks into steps. LT-1 (hallucination) — HARD-GATEs prevent common errors. | UBS-1 (junior mental model) — skills guide PMs through ALPEI process |

**VANA assessment:**
- **Correct:** 67/67 tests pass. ADR-002 documents Obsidian integration decision.
- **Safe:** Security rules (AP1-AP5), PreToolUse hooks, no-push-without-approval enforced, .gitignore covers secrets/.env.
- **NOT YET sustainable for team:** No PM-facing dashboards. No onboarding path. Obsidian Bases not deployed. This is the primary UBS for I2.

---

### I2: PROTOTYPE — EFFICIENCY EMERGING (NEXT)

**EO:** Derisk and deliver an Obsidian-integrated PM workflow that is more easily navigable, produces higher quality output, and saves more time than the CLI-only I1 approach.

**Pillar focus:** Efficiency — the system must demonstrably outperform the alternative (manual CLI workflow).

| Component | I2 Target State | What Gets Built | LT/UBS Addressed |
|-----------|----------------|-----------------|------------------|
| **EI** (Input) | Schema-enforced metadata | **Frontmatter schema** on all workstream artifacts: type, sub_system, work_stream, stage, component, version, iteration, ues_version, status, date. Schema validation in pre-commit hook. Templater auto-fills on file creation. | LT-4 (retrieval fragile) — structured metadata = precise filtering. UBS-2 (over-engineering) — schema prevents ad-hoc metadata sprawl |
| **EU** (User) | PM + 6 agents | **Human:** Long + 1-2 pilot PMs on one project. **New agents:** alpei-auditor (parallel sub-system sweep), alpei-auto-auditor (recommend-only health scanner). Total: 6 agents. Pilot PM uses Obsidian Bases as primary interface — never needs terminal for status/navigation. | LT-3 (reasoning) — auditor decomposes across 4 sub-systems in parallel. UBS-1 (junior mental model) — dashboard-first interface requires no CLI knowledge |
| **EA** (Action) | Dashboard-guided workflow | PM opens Obsidian → sees "ALPEI Process Board" → knows current phase → runs /ues-next → gets told what to do → creates file from Templater template → frontmatter auto-fills → Bases update live. The **decision loop** is: see status → identify gap → create artifact → validate → advance. | LT-6 (memory) — dashboards are live views, never stale. UBS-1 (junior model) — the dashboard IS the training |
| **EO** (Output) | PM workflow without CLI | **6 starter Obsidian Bases dashboards:** (1) ALPEI Process Board — group by workstream → sub-system → stage; (2) Sub-System Pipeline — group by sub-system → workstream; (3) Blocker Dashboard — filter: days_stale > 14 OR status = blocked, computed risk_level; (4) 8-Component Matrix — group by sub-system → component, show gaps; (5) Standup Preparation — activity banding: TODAY / LAST 3 DAYS / THIS WEEK; (6) Version Progress — sorted by staleness, advancement candidates. **3-level folder structure** enforced via ADR + validation script. **PM onboarding deck** (ALPEI training slides). | UBS-2 (over-engineering) — 6 dashboards, not 14. Start with what's needed. UBS-5 (Obsidian friction) — dashboards make Obsidian a PM tool, not a dev tool |
| **EP** (Principles) | 12 auto-loaded rules | **Ported from Vinh (adapted):** alpei-vana-gate, alpei-version-awareness, alpei-derisk-first, alpei-sub-system-inheritance, alpei-file-routing. **New:** 3-level-depth-enforcement. **Retained from I1:** all 7 existing rules. Total: 12 auto-loaded rules. Every rule traces to a UBS it disables (Principle 3). | LT-8 (alignment) — more rules = tighter behavioral bounds. UBS-6 (governance theater) — every rule has a named UBS justification |
| **EOE** (Environment) | Obsidian as primary workspace | **Obsidian vault** = project root (registered, indexed by QMD). **Obsidian Bases** = dashboard layer (6 .base files). **Claude Code** = build interface (terminal + desktop app). **Cursor/VS Code** = code editing (4-EXECUTE only). **Git** = version control + sync (team collaboration via branches, not Obsidian Sync — avoids $960/yr cost). **Context budget:** EP ~4K tokens (12 rules), skills loaded on demand, Bases queries via MCP. | LT-2 (context compression) — Bases offload status queries from context window. LT-7 (cost) — Git sync is free vs Obsidian Sync $10/user/month. UBS-5 (Obsidian friction) — Git-based, no new paid service |
| **EOT** (Tools) | 4-tool routing + Bases | **Tier 0:** Obsidian Bases (structured database queries over frontmatter — fastest, most precise). **Tier 1:** QMD (semantic search). **Tier 2:** Obsidian CLI (graph traversal, backlinks). **Tier 3:** Grep/Glob (all file types fallback). **New tools:** /auto-audit (parallel sweep), /ues-next (guided prioritization), Templater (template auto-fill with frontmatter). | LT-4 (retrieval) — Bases add structured query layer above semantic search. UBS-3 (stale context) — Bases are always-live views, never cached |
| **EOP** (Procedure) | 35+ skills | **Ported from Vinh (adapted):** /ues-align, /ues-learn, /ues-plan, /ues-execute, /ues-improve (workstream starters), /ues-audit-all (parallel 4-sub-system sweep), /ues-next (what to work on), /auto-audit (health scan), /vault-daily (daily note creation), /vault-capture (route input to correct workstream folder). **New:** /ues-overview (project status summary). **Retained from I1:** all 22 existing skills. **PM onboarding:** training deck + cheatsheets in 2-LEARN/. | LT-3 (reasoning) — more granular skills = smaller reasoning steps. UBS-1 (junior model) — /ues-next removes task-selection paralysis. UBS-4 (bus factor) — skills encode Vinh's methodology as executable code |

**VANA exit criteria:**
- **Correct:** All Bases dashboards produce accurate views matching frontmatter queries. I1 67/67 tests still pass. New tests for frontmatter schema + Bases integrity.
- **Safe:** No data loss from structure migration. No regressions.
- **Efficient (emerging):** Measured — a PM can: (a) check project status in < 30 seconds via Bases (vs. 5+ minutes via CLI grep), (b) identify the next task via /ues-next (vs. reading DESIGN.md manually), (c) create a correctly-frontmatted artifact via Templater in < 1 minute (vs. 5+ minutes hand-crafting YAML).

**Branch:** `I2/feat/obsidian-bases`

---

### I3: MVE — FULL EFFICIENCY (PLANNED)

**EO:** Derisk and deliver the full AI Operating System reliably and efficiently for all 6 LTC investment projects.

**Pillar focus:** Full Efficiency — the system must be reliable, cost-effective, and demonstrably better than alternatives at current scale (8 members, 6 projects).

| Component | I3 Target State | What Gets Built | Measurement |
|-----------|----------------|-----------------|-------------|
| **EI** (Input) | Cross-project data | All 6 projects using shared frontmatter schema. Cross-project Bases dashboards aggregate status. NotebookLM integration for LEARN workstream (external research → structured learning sources with `type: learning-source` frontmatter). | All 6 projects have ≥1 artifact per workstream |
| **EU** (User) | All 8 LTC members | Every PM has completed onboarding (2-LEARN/ materials). Role specialization: some PMs focus on PD, others on DA/IDM. Vinh shifts from builder to reviewer (Consulted → Informed on implementation). | Handoff test: new PM onboards using only template materials — no verbal instruction needed |
| **EA** (Action) | Multi-project orchestration | Cross-sub-system dependency tracking (PD output → DP input validated by agent). Automated version advancement proposals (agent detects when VANA criteria are met and suggests version bump). Sprint planning assisted by /ues-plan with historical velocity. | Time-to-first-deliverable measurably < I2 baseline |
| **EO** (Output) | Production AI-OS | 6 projects producing real investment analysis deliverables through the template. At least 1 project at Concept version (UBS/UDS analysis complete, Effective Principles derived). Version Registry showing active progress across sub-systems. | ≥1 project has ≥1 sub-system at Concept version |
| **EP** (Principles) | Battle-tested rules | Full rule set validated across 6 projects. Rules that caused false positives or friction removed/refined. Personal ↔ template skill sync mechanism prevents configuration drift. | Zero rule violations in last 50 commits across any project |
| **EOE** (Environment) | Multi-project workspace | Each project = own Git repo cloned from template. Shared _genesis/ via Git submodule or symlink. PM switches between projects via `cd` + /resume (context restored in ≤5K tokens). **GitNexus** (if code sub-systems in 4-EXECUTE/ have matured): code knowledge graph for .py/.ts files, MCP server for Claude Code integration. | Context switch between projects < 2 minutes |
| **EOT** (Tools) | Full 42-skill suite | All Vinh skills ported and adapted to 3-level structure. Cross-project dashboards (portfolio-level Bases view). GitNexus MCP tools (if deployed): `query`, `context`, `impact`, `cypher`. Automated PR creation from /git-save with changelog enforcement. | PM uses ≥10 skills/week without support requests |
| **EOP** (Procedure) | Complete PM lifecycle | Full ALPEI workflow from project kickoff to iteration close. Handoff procedure (PM leaves → new PM reads charter + /resume → continues). Audit trails: every decision in 1-ALIGN/decisions/, every risk in 3-PLAN/risks/, every improvement in 5-IMPROVE/. Monthly retrospective driven by /ues-improve with metrics from Bases. | Handoff success: new PM productive within 1 day |

**VANA exit criteria:**
- **Correct:** All I1 + I2 tests pass. Cross-project schema consistency validated.
- **Safe:** Security audit green. No secret leakage across projects.
- **Reliable:** System works across 6 projects without per-project template customization.
- **Efficient:** PM time-to-first-deliverable measurably faster than pre-template baseline. Cost per project manageable (< $200/month in AI API costs at current usage).

---

### I4: LEADERSHIP — SCALABILITY (FUTURE)

**EO:** Derisk and deliver a self-improving AI Operating System that operates automatically, predictively, and prescriptively.

**Pillar focus:** Scalability — the system gets disproportionately better as resources grow. Output gains exceed resource investment.

| Component | I4 Target State | Capability | Technology (April 2026 frontier) |
|-----------|----------------|-----------|----------------------------------|
| **EI** (Input) | Auto-detected | System identifies new inputs before PM does. RSS/API feeds from economic data sources auto-routed to 2-LEARN/input/. Daily notes auto-generated with relevant context from yesterday's work + today's calendar. | Claude Code scheduled triggers (cron), Obsidian Daily Notes + Calendar plugin, MCP data feeds |
| **EU** (User) | PM as pure Director | PMs issue strategic direction only ("focus on inflation risk this quarter"). Agents self-organize into task teams. Agent-to-agent delegation with human oversight via dashboard, not per-task approval. | Claude Agent SDK (multi-agent orchestration), Claude Code agent teams (experimental), reduced human gates for validated patterns |
| **EA** (Action) | Self-executing DSBV | System detects when a DESIGN.md is approved → auto-generates SEQUENCE.md → dispatches ltc-builder → runs ltc-reviewer → presents results for human approval. Only the approval gate remains manual. Routine improvements (typo fixes, version bumps, frontmatter corrections) execute without human intervention. | Claude Code hooks (PostToolUse auto-commit for low-risk edits), /auto-audit scheduled daily |
| **EO** (Output) | Self-improving system | System produces its own improvement proposals: "UBS-3 severity increased — recommend adding NotebookLM integration to LEARN pipeline." Prescriptive recommendations with expected impact. Weekly automated retrospectives comparing planned vs actual across 6 projects. | Automated metrics collection (git log analysis, Bases query diffs, token cost tracking) |
| **EP** (Principles) | Self-updating | System detects when a rule causes consistent friction (false positives tracked) → proposes rule revision → human approves. New UBS entries auto-generated from recurring agent failures. EP evolves from static files to a living governance system. | Feedback loops: 5-IMPROVE/ retrospective data → proposed rule changes → human approval → .claude/rules/ update |
| **EOE** (Environment) | Auto-scaling | Multi-model routing optimized from usage data (which tasks actually need Opus vs. which Haiku handles fine). Context budget dynamically allocated based on task complexity. Worktree-per-branch automated for parallel work. | Claude Code model routing API (if available), dynamic context allocation, git worktree automation |
| **EOT** (Tools) | Full tool chain with auto-fallback | 4-tool routing self-optimizes: QMD → Obsidian → GitNexus → Grep with automatic fallback and performance logging. New tools auto-discovered and proposed via MCP registry. Broken tools auto-detected and removed from routing. | MCP tool registry, health-check automation, performance logging per tool per query type |
| **EOP** (Procedure) | Auto-generated procedures | Historical execution data → system learns which skill sequences work best for each task type → generates optimized procedures. New team members get personalized onboarding based on their skill profile. | Session log analysis (QMD corpus), personalized skill recommendations, adaptive /ues-next |

**VANA exit criteria:**
- All prior criteria met (correct, safe, reliable, efficient).
- **Automatic:** System executes ≥50% of routine PM tasks without human initiation.
- **Predictive:** System forecasts blockers ≥3 days before they surface (measured against retrospective data).
- **Prescriptive:** System recommends specific actions with expected outcomes. ≥70% of recommendations accepted by PM.

---

### ITERATION PROGRESSION — 8-COMPONENT CAPABILITY SUMMARY

```
         I0 (Scaffold)    I1 (Concept)      I2 (Prototype)     I3 (MVE)           I4 (Leadership)
         ─────────────    ──────────────    ───────────────    ──────────────     ─────────────────
EI       Raw docs         CLAUDE.md +       Frontmatter        Cross-project      Auto-detected
                          memory/           schema enforced    data + NotebookLM  inputs + feeds

EU       1 builder        Director +        Director +         All 8 PMs +        PM = pure Director
                          4 agents          6 agents + pilot   specialized roles  agents self-organize

EA       Manual           Agent-DSBV +      Dashboard-guided   Multi-project      Self-executing
                          human gates       workflow           orchestration      DSBV

EO       Folder scaffold  Tested infra      PM workflow        Production AI-OS   Self-improving
                          (67 ACs)          without CLI        for 6 projects     system

EP       Docs only        7 auto-loaded     12 auto-loaded     Battle-tested      Self-updating
                          rules             rules              across 6 projects  rules

EOE      Terminal only    Claude Code +     + Obsidian Bases   + Multi-project    Auto-scaling
                          Obsidian (partial) as primary UI     + GitNexus         multi-model

EOT      Read/Write/Grep  3-tool routing    4-tool routing     Full 42 skills     Auto-optimizing
                          + QMD + Obsidian  + Bases + Templater + cross-project   tool chain

EOP      None             22 skills         35+ skills         Complete lifecycle  Auto-generated
                                            + PM onboarding    + handoff procs    procedures
```

---

## PART 5: UBS AND UDS REGISTER (THIS PROJECT)

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

## PART 6: REFERENCE TABLES FOR AI AGENTS

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
status: Draft             # Draft | Review | Approved (human only)
last_updated: 2026-04-03  # Always absolute date
type: ues-deliverable     # ues-deliverable | template | learning-source | reference
sub_system: problem-diagnosis  # problem-diagnosis | data-pipeline | data-analysis | insights-decision-making
work_stream: plan         # align | learn | plan | execute | improve
stage: design             # design | sequence | build | validate
component: EI             # EI | EU | EA | EO | EP | EOE | EOT | EOP (optional)
iteration: 1              # 0-4
ues_version: concept      # logic-scaffold | concept | prototype | mve | leadership
---
```

### TABLE 3: 3-LEVEL FOLDER STRUCTURE

```
project-root/
├── 1-ALIGN/{PD,DP,DA,IDM,_cross}/files.md    ← Level 3: files
├── 2-LEARN/{PD,DP,DA,IDM,_cross}/files.md
├── 3-PLAN/{PD,DP,DA,IDM,_cross}/files.md
├── 4-EXECUTE/{PD,DP,DA,IDM}/src|tests|config/ ← Level 4: code only
├── 5-IMPROVE/{PD,DP,DA,IDM,_cross}/files.md
├── _genesis/                                   ← Shared frameworks
└── .claude/                                    ← Agent config
```

### TABLE 4: AGENT ROSTER

| Agent | Model | DSBV Phase | Tools | Scope Boundary |
|-------|-------|-----------|-------|----------------|
| ltc-planner | Opus | Design + Sequence | Read, Grep, WebFetch, Exa, QMD | No file writes to 4-EXECUTE/ |
| ltc-builder | Sonnet | Build | Read, Edit, Write, Bash, Grep | From approved sequences only |
| ltc-reviewer | Opus | Validate | Read, Glob, Grep, Bash | Read-only, never modifies artifacts |
| ltc-explorer | Haiku | Pre-DSBV | Read, Glob, Grep, Exa, QMD | No commits, no file writes |

---

## LINKS

- [[CHARTER]]
- [[ROADMAP]]
- [[ltc-ues-versioning]]
- [[agent-system]]
- [[ltc-effective-system-design-blueprint]]
- [[ltc-effectiveness-guide]]
- [[alpei-dsbv-process-map]]
