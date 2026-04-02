---
version: "1.3"
last_updated: 2026-04-02
type: governance
classification: INTERNAL
owner: LTC ALL
source: "Adapted from Vinh branch v3.0 (Vinh-ALPEI-AI-Operating-System-with-Obsidian)"
status: Deprecated
---

# ALPEI AI OPERATING SYSTEM — STANDARD OPERATING PROCEDURE

> **Classification:** INTERNAL
> **Owner:** LTC ALL
> **Last Updated:** 2026-03-31
> **Version:** 1.2 (adapted from Vinh v3.0)
> **Status:** DEPRECATED
>
> **DEPRECATION NOTICE (2026-03-31):** This SOP is a historical reference from Vinh's branch.
> Its content has been absorbed into the canonical system: `/dsbv` skill, `.claude/agents/`,
> `.claude/rules/`, `_genesis/frameworks/UES_VERSION_BEHAVIORS.md`, and the forthcoming
> `_genesis/frameworks/ALPEI_DSBV_PROCESS_MAP.md`. Do NOT use as authoritative source for
> new work. Use `/dsbv` as the operating procedure.

> **Adaptation notes:** Obsidian wikilinks replaced with plain references. Obsidian-specific tooling
> (Bases, Kanban plugin, Templater, Dataview) annotated with `[Obsidian-specific — adapt to your tooling]`.
> `/ues-*` commands are Vinh's skill set — our equivalents are noted inline. Our primary guided flow
> is `/dsbv`. See `_genesis/sops/` for our skill inventory.

---

# 1. PURPOSE & SCOPE

## 1.1. WHAT THIS SOP COVERS

This Standard Operating Procedure provides comprehensive instructions for LTC members to set up, configure, and work effectively with the ALPEI AI Operating System workspace. It covers the complete lifecycle from initial setup through daily operations, including all framework concepts, commands, templates, and workflows.

## 1.2. WHO THIS IS FOR

This SOP is for **all LTC members** who operate a User Enablement System (UES) using the ALPEI framework. This includes:

- New members onboarding to LTC
- Existing members setting up a new workspace
- Members needing a reference for daily operations and framework concepts

## 1.3. WHAT THE ALPEI AI OPERATING SYSTEM IS

The ALPEI AI Operating System is a **personal AI-powered workspace** powered by AI agents (primarily Claude Code). It serves as both a knowledge base and an operating system where each LTC member manages their User Enablement Projects using the ALPEI agile framework.

The workspace is:

- **A GitHub repository** — All work is version-controlled, tracked via pull requests
- **An AI agent environment** — Claude Code reads the vault's instructions (`CLAUDE.md`, rules, and skills) to operate as an intelligent assistant that understands the ALPEI framework
- **An Obsidian vault** (Vinh's implementation) — Markdown-based knowledge management with wikilinks and task tracking `[Obsidian-specific — adapt to your tooling]`

**Key references:**

- `_genesis/reference/` — Vinh ALPEI PDFs: Framework Overview, By Work Streams, By Sub-system, Process Requirements, UES Versioning
- `_genesis/reference/` — 10 Ultimate Truths and Foundational training materials
- `_genesis/frameworks/` — 8-component system design model and versioning

---

# 2. OPERATING MODEL

## 2.1. AI-FIRST SOLO OWNERSHIP

Each LTC member operates as a **solo project manager (PM) paired with AI agents**. The operating model is:

| **ROLE** | **RESPONSIBILITY** | **DESCRIPTION** |
|---|---|---|
| **LTC MEMBER (PM)** | Accountable | Sets direction, makes decisions, approves deliverables, attends standups |
| **AI AGENT** | Responsible | Executes tasks, produces deliverables, manages vault, runs framework commands |

This means:

- **1 PM + AI agents = 1 complete execution team**
- The PM directs the AI agent using slash commands and natural language
- The AI agent produces all deliverables, maintains documentation, and tracks progress
- The PM reviews, approves, and takes accountability for all outputs

## 2.2. RACI MODEL

| **ACTIVITY** | **AI AGENT** | **LTC MEMBER (PM)** |
|---|---|---|
| **Producing deliverables** | Responsible | Accountable |
| **Running framework commands** | Responsible | Accountable |
| **Making strategic decisions** | Consulted | Accountable |
| **Approving version advancement** | Informed | Accountable |
| **Updating the vault** | Responsible | Accountable |
| **Attending standups** | Not involved | Responsible + Accountable |
| **Cross-member alignment** | Not involved | Responsible + Accountable |

## 2.3. COLLABORATION BOUNDARIES

| **ACTIVITY** | **SCOPE** | **WHERE** |
|---|---|---|
| **Execution** | Solo (no cross-member collaboration) | Own workspace |
| **Alignment** | Collaborative (standup meetings) | Daily standup |
| **Company decisions** | Collaborative (group discussion) | Standup Part 2 |
| **Project-specific issues** | 1:1 or small group | Standup Part 3 |

**Important:** Cross-member collaboration happens ONLY for alignment purposes (standup meetings). Execution is always solo within your own workspace.

## 2.4. AI AGENT TEAMS AND SUBAGENTS

For complex tasks, your AI agent can spawn **subagents** that work in parallel. The workspace defines 5 agent archetypes and 5 team patterns.

### AGENT ARCHETYPES

| **AGENT** | **ROLE** | **USED IN** |
|---|---|---|
| **alpei-researcher** | Investigates one dimension of UBS/UDS analysis with evidence quality ratings | LEARN work stream (Research Team) |
| **alpei-auditor** | Verifies deliverables against VANA criteria, chain-of-custody, and Three Pillars | Cross-cutting audits (Audit Team) |
| **alpei-planner** | Handles task decomposition, dependency mapping, risk analysis, capacity estimation | PLAN work stream (Planning Team) |
| **alpei-task-executor** | Executes individual tasks with prerequisite checking and VANA validation | EXECUTE work stream (Execution Team) |
| **alpei-reviewer** | Evaluates deliverables through Sustainability/Efficiency/Scalability lenses | Version advancement (Review Team) |

Our repo equivalent agent configs: `.claude/agents/` — see `ltc-planner`, `ltc-builder`, `ltc-reviewer`, `ltc-explorer`.

### TEAM PATTERNS

| **PATTERN** | **WHEN** | **COMPOSITION** |
|---|---|---|
| **Research Team** | LEARN work stream — UBS/UDS analysis | 2-3 researchers + coordinator |
| **Audit Team** | Cross-cutting verification | 4 sub-system auditors + synthesizer |
| **Planning Team** | PLAN work stream — iteration planning | Task decomposer + Risk analyst + Estimator + coordinator |
| **Execution Team** | EXECUTE — multiple independent tasks | N task agents + quality agent + coordinator |
| **Review Team** | Version advancement — multi-pillar review | Sustainability + Efficiency + Scalability reviewers + coordinator |

### HOW AGENT TEAMS WORK

1. **Coordinator** defines scope, output format, and success criteria
2. **Subagents** work in parallel (background, with worktree isolation when needed)
3. **Subagents** save outputs to designated paths
4. **Coordinator** reads all outputs, synthesizes, and flags conflicts
5. **Coordinator** presents consolidated result to the human PM for approval

**When to use teams:**
- Task spans multiple sub-systems independently (e.g., audit all 4 sub-systems)
- Task requires 3+ research sources simultaneously (e.g., UBS/UDS analysis)
- Multiple tasks have no dependencies between them (e.g., parallel execution)

**Your role as PM:** You do not need to manually manage subagents. Simply invoke the relevant slash command and the AI agent will decide whether to use a team pattern. You review and approve the consolidated output.

---

# 3. WORKSPACE SETUP

## 3.1. PREREQUISITES

Before setting up the workspace, ensure you have the following:

| **TOOL** | **PURPOSE** | **INSTALL** |
|---|---|---|
| **Git** | Version control | `brew install git` (macOS) |
| **Claude Code** (or other AI agent) | AI-powered execution partner | `npm install -g @anthropic-ai/claude-code` |
| **Node.js** (v18+) | Required for Claude Code and CLI tools | `brew install node` |
| **Obsidian** | Knowledge base and vault UI (Vinh's implementation) `[Obsidian-specific — adapt to your tooling]` | Download from obsidian.md |
| **gws CLI** | Google Workspace integration | Follow LTC internal setup guide |
| **gcloud CLI** | Google Cloud services | `brew install google-cloud-sdk` |

## 3.2. STEP-BY-STEP SETUP

### STEP 1: CLONE THE WORKSPACE

```bash
# Clone from the LTC template
git clone https://github.com/Long-Term-Capital-Partners/OPS_OE.6.4.LTC-PROJECT-TEMPLATE.git "YOUR_PROJECT_NAME"
cd "YOUR_PROJECT_NAME"

# Set up your branch (follow I0-I4 strategy)
git checkout -b YourName-ProjectScope
```

### STEP 2: CONFIGURE CLAUDE CODE

Claude Code reads its instructions from these files in the workspace:

| **FILE** | **PURPOSE** |
|---|---|
| `CLAUDE.md` | Main instructions — vault structure, framework rules, slash commands |
| `.claude/rules/*.md` | Individual rules — brand identity, security, naming, ALPEI framework rules |
| `~/.claude/CLAUDE.md` | Global rules — LTC brand, security, naming (applies to all projects) |

No manual configuration is needed — these files are included in the template.

### STEP 3: AUTHENTICATE TOOLS

```bash
# Authenticate Google Workspace CLI
gws auth setup

# Initialize Google Cloud CLI
gcloud init

# Verify Claude Code is installed
claude --version
```

### STEP 4: VERIFY SETUP

Run the following in Claude Code to verify everything works:

```
/dsbv status    # Should display current APEI workstream progress
```

If this executes without errors, your workspace is ready.

## 3.3. REPO FOLDER STRUCTURE

This template follows the APEI 5-workstream structure:

```
PROJECT_ROOT/
|
|-- 1-ALIGN/               # ALIGN workstream (charter, decisions, okrs, learning)
|-- 3-PLAN/                # PLAN workstream (architecture, risks, drivers, roadmap)
|-- 4-EXECUTE/             # EXECUTE workstream (src, tests, config, docs)
|-- 5-IMPROVE/             # IMPROVE workstream (changelog, metrics, retros, reviews)
|
|-- _genesis/              # Shared org knowledge base
|   |-- brand/             # LTC brand identity
|   |-- frameworks/        # ALPEI, ESD, versioning frameworks
|   |-- reference/         # Vinh ALPEI PDFs (5 canonical PDFs)
|   |-- security/          # Security rules and SOPs
|   |-- sops/              # Standard operating procedures
|   |-- templates/         # DSBV and project templates
|
|-- .claude/               # Claude Code configuration
|   |-- agents/            # Agent config files
|   |-- rules/             # Individual rules files
|   |-- skills/            # Slash command skill definitions
|-- AGENTS.md              # Multi-agent coordination instructions
|-- CLAUDE.md              # Main Claude Code agent instructions
```

### FOLDER PURPOSE MAP

| **FOLDER** | **ALPEI STAGE** | **ESD COMPONENT** | **WHAT GOES HERE** |
|---|---|---|---|
| **_genesis** | Cross-cutting | EOT (Effective Operating Tools) | Templates, frameworks, SOPs, brand |
| **1-ALIGN** | Align | EU, EO, EOP | Charter, decisions, OKRs, learning |
| **3-PLAN** | Plan | EI (Effective Inputs) | Execution plans, task breakdowns, OKRs |
| **4-EXECUTE** | Execute | EA (Effective Actions) | Active deliverables, sprint work |
| **5-IMPROVE** | Improve | Feedback loop | Retrospectives, feedback, improvement logs |

---

# 4. ALPEI FRAMEWORK OVERVIEW

## 4.1. THREE STRUCTURAL LAYERS

The ALPEI framework is built on three structural layers that together create an **80-cell matrix** defining every possible work unit in a UES:

### LAYER 1: FIVE CONCURRENT WORK STREAMS

| **ORDER** | **WORK STREAM** | **PURPOSE** | **PRIMARY OUTPUT** |
|---|---|---|---|
| 1 | **ALIGN** | Define scope, design outcomes, lock master plan, audit alignment | Desired outcome, master plan, stakeholder commitments |
| 2 | **LEARN** | Understand blockers (UBS) and drivers (UDS), design effective solutions | Validated understanding, effective principles, solution design |
| 3 | **PLAN** | Create execution plan for each iteration | Execution plan with feature scope, resource allocation, risk register |
| 4 | **EXECUTE** | Develop and deliver planned features | Deployed solution, tested and delivered to users |
| 5 | **IMPROVE** | Collect feedback, validate improvements | Validated improvements and feedback (loops back to Align) |

These work streams are **concurrent, not sequential** — they run in parallel and feed into each other continuously: Align -> Learn -> Plan -> Execute -> Improve -> back to Align.

### LAYER 2: FOUR STAGES PER WORK STREAM

| **ORDER** | **STAGE** | **PURPOSE** | **INPUT** | **OUTPUT** |
|---|---|---|---|---|
| 1 | **SCOPE** | Define what and why | Context, needs, objectives from prior work stream | Objectives and success criteria |
| 2 | **DESIGN** | Design how | Objectives, constraints, available resources | Plan or blueprint for execution |
| 3 | **PRODUCTION** | Do it | Plan, resources, access | Completed deliverable |
| 4 | **AUDIT** | Verify correctness | Completed deliverable, original objectives | Validated deliverable ready for next work stream |

### LAYER 3: FOUR SUB-SYSTEMS WITHIN THE UES

| **ORDER** | **SUB-SYSTEM** | **PURPOSE** | **PRIMARY OUTPUT** |
|---|---|---|---|
| 1 | **PROBLEM DIAGNOSIS (PD)** | Diagnose user problems, identify UBS/UDS, establish effective principles | Effective principles for the entire UES |
| 2 | **DATA PIPELINE (DP)** | Acquire, clean, standardize, process data | Processed, analysis-ready data |
| 3 | **DATA ANALYSIS (DA)** | Analyze data, extract insights with confidence levels | Validated insights, trends, patterns, forecasts |
| 4 | **INSIGHTS & DECISION MAKING (IDM)** | Deliver insights via dashboards, support decisions, manage risk | Insight dashboards, decision recommendations, risk alerts |

### THE 80-CELL MATRIX

The three layers combine to form:

**4 Sub-Systems x 5 Work Streams x 4 Stages = 80 cells**

Each cell represents a specific unit of work. For example:

- **PD - Learn - Scope** = Defining what to learn about the problem domain
- **DP - Execute - Production** = Building and deploying pipeline components
- **DA - Improve - Audit** = Verifying the improvement process for data analysis
- **IDM - Align - Design** = Designing desired IDM outcomes using VANA

## 4.2. THREE PILLARS OF EFFECTIVENESS

Derived from LTC Ultimate Truths training materials (Derived Truth #1):

| **PRIORITY** | **PILLAR** | **DEFINITION** | **KEY QUESTION** |
|---|---|---|---|
| 1st | **SUSTAINABILITY** | Management of failure risks | Is it correct? Is it safe? Can it fail gracefully? |
| 2nd | **EFFICIENCY** | Best possible output for given resources | Is it productive? Does it save time/resources vs. alternatives? |
| 3rd | **SCALABILITY** | Best possible output gains from additional resources | Does it grow effortlessly? Is it automatic, predictive? |

**Critical rule:** Always address risks in Three Pillars priority order. Sustainability first, efficiency second, scalability third. Never sacrifice correctness for speed.

## 4.3. FIVE PRINCIPLES OF LTC

| **#** | **PRINCIPLE** | **DESCRIPTION** |
|---|---|---|
| 1 | **ETHICS** | All actions must be ethical and compliant |
| 2 | **EFFECTIVENESS** | Pursue sustainability, efficiency, and scalability in that order |
| 3 | **TRANSPARENCY** | All work is documented, tracked, and auditable |
| 4 | **COLLECTIVE LEADERSHIP** | Decisions are made collaboratively at the alignment level |
| 5 | **CONTINUOUS IMPROVEMENT** | The Improve -> Align loop never stops |

## 4.4. VANA SUCCESS CRITERIA

VANA (Verb, Adverb, Noun, Adjective) defines "done" at every version level. Derived from Ultimate Truth #2:

> The success criteria of any system can always be simplified into a deliverable with four elements: **Verb** (actions), **Adverbs** (quality of actions), **Noun** (what is acted upon), **Adjectives** (quality of what is acted upon).

| **VERSION** | **PILLAR** | **VERB** | **ADVERBS** | **NOUN** | **ADJECTIVES** |
|---|---|---|---|---|---|
| **LOGIC SCAFFOLD** | (Pre-build) | Understand and design | Clearly, completely | The scope and logic of the enablement system | Clear, complete |
| **CONCEPT** | Sustainability | Derisk and deliver output | Correctly, safely | User's environment with simulated tools, SOP, and actions | Correct, safe |
| **PROTOTYPE** | Sustainability + Efficiency (emerging) | Derisk and deliver output | Correctly, safely, more easily, higher output, better time-saving than alternatives | Prototype of the real enablement system (environment, tools, and SOP) | Correct, safe |
| **MVE** | Sustainability + Efficiency (full) | Derisk and deliver output | Correctly, safely, reliably, more easily, higher output, better time-saving | Full, working enablement system | Correct, safe, reliable, cheaper, fairly easy to acquire |
| **LEADERSHIP** | Sustainability + Efficiency + Scalability | Derisk and deliver output | Correctly, safely, reliably, automatically, predictively, prescriptively | Full enablement system including some user actions | Correct, safe, reliable, automatic, predictive, prescriptive |

**Full reference:** `_genesis/reference/` — UES Versioning PDF

---

# 5. DAILY WORKFLOW

## 5.1. DAILY STANDUP STRUCTURE

The daily standup is a **management meeting** with three parts:

### PART 1: UPDATE (EACH MEMBER, 2-3 MINUTES)

| **ITEM** | **DESCRIPTION** | **EXAMPLE** |
|---|---|---|
| **INCREMENT** | What AI work was completed since last standup | "PD Learn Scope deliverable completed and audited" |
| **BLOCKERS** | Issues preventing progress, classified as project-level or company-wide | "Blocked on data access (company-wide)" |
| **TODAY'S PLAN** | What you plan to work on today | "Starting PD Learn Design with `/dsbv build`" |

### PART 2: GROUP DISCUSSION

| **TOPIC** | **DESCRIPTION** |
|---|---|
| **COMPANY ALIGNMENT** | Strategic direction changes, new priorities |
| **INFRASTRUCTURE** | Shared tools, platforms, access issues |
| **TECHNOLOGY** | New tools, integrations, technical decisions |
| **PROCESS CLARIFICATION** | Framework questions, SOP updates, workflow improvements |

### PART 3: PRIVATE DISCUSSION

Project-specific breakouts with management or the relevant member. Used for:

- Resolving project-specific blockers that do not affect the whole team
- Getting management approval on deliverables
- Discussing sensitive or confidential project details

## 5.2. DAILY WORKFLOW STEPS

### MORNING (BEFORE STANDUP)

| **STEP** | **ACTION** | **COMMAND / NOTE** |
|---|---|---|
| 1 | Create or update today's daily note | `1-ALIGN/learning/YYYY-MM-DD.md` or your preferred daily note location |
| 2 | Review yesterday's daily note | Read prior day's learning notes |
| 3 | Check current project status | `/dsbv status` |
| 4 | Identify what was done and what is next | Review `5-IMPROVE/changelog/` and open PRs |
| 5 | Prepare standup items | Note your increment, blockers, and today's plan |

### STANDUP MEETING

Attend the standup. Deliver your Part 1 update. Participate in Part 2 group discussion. Join Part 3 breakouts if needed.

### WORK SESSION (AFTER STANDUP)

| **STEP** | **ACTION** | **COMMAND** |
|---|---|---|
| 1 | Identify next work item | `/dsbv status` |
| 2 | Execute the recommended work stream and stage | Use `/dsbv` guided flow |
| 3 | Review and approve deliverables as they are produced | Read output, provide feedback, approve or request changes |
| 4 | Log progress as tasks complete | AI agent updates progress tracker automatically |
| 5 | Commit and push meaningful changes | `git add . && git commit -m "message" && git push` |

### END OF DAY

| **STEP** | **ACTION** | **COMMAND** |
|---|---|---|
| 1 | Update daily note with reflections | Edit your daily note |
| 2 | Capture any new blockers for tomorrow | Note them in the daily note |
| 3 | Commit and push all changes | `git add . && git commit -m "End of day sync" && git push` |
| 4 | Review what to work on tomorrow | `/dsbv status` |

## 5.3. PRE-FLIGHT PROTOCOL

Before every UES task, the AI agent runs a 6-step pre-flight checklist. As PM, you should understand what it checks so you can verify compliance:

| **STEP** | **CHECK** | **WHAT IT MEANS FOR YOU** |
|---|---|---|
| **1** | Identify the ALPEI cell (sub-system × work stream × stage) | AI knows exactly where this work belongs in the 80-cell matrix |
| **2** | Check chain-of-custody (upstream outputs exist?) | Upstream deliverables are verified before proceeding |
| **3** | Check version level | AI will calibrate depth to match current version (no over-building) |
| **4** | Identify applicable templates | AI will use the correct template, not create blank files |
| **5** | Confirm Three Pillars priority | Sustainability risks addressed before efficiency optimization |
| **6** | Check cross-sub-system version consistency (PD >= DP >= DA >= IDM) | Downstream sub-systems cannot be ahead of upstream ones |

**If any check fails**, the AI agent will tell you what's wrong and suggest the fix. You decide whether to fix it first or proceed anyway.

**When pre-flight is skipped:** Vault management, daily operations, general questions, and non-UES tasks do not require pre-flight.

This pre-flight is equivalent to our **CLAUDE.md Before Every Task — Pre-Flight Protocol** (`CLAUDE.md` §Before Every Task).

---

# 6. WORK STREAM GUIDE

## 6.1. ALIGN

> **Purpose:** Define scope, design outcomes, lock master plan, and audit alignment for a sub-system.

**Our command:** `/dsbv design align` | Vinh's command: `/ues-align <sub-system>`

**What it produces at each stage:**

| **STAGE** | **DELIVERABLE** | **PM ROLE** | **AI ROLE** |
|---|---|---|---|
| **SCOPE** | Project Charter | Defines project boundaries and objectives | Drafts charter, identifies stakeholders, creates RACI |
| **DESIGN** | Master Plan + OKR | Reviews and validates outcomes and milestones | Designs VANA criteria per version, drafts master plan and OKRs |
| **PRODUCTION** | Lock & Sign-Off | Signs off on the master plan | Finalizes plan, obtains sign-off, distributes to all work streams |
| **AUDIT** | Alignment Audit | Reviews audit findings | Checks for gaps, misalignment, overlooked risks |

**Sequence:**
1. PM tells AI agent which sub-system to align
2. AI runs pre-flight checks (chain-of-custody, version level)
3. AI produces Scope deliverable -> PM reviews and approves
4. AI produces Design deliverable -> PM reviews and approves
5. AI produces Production deliverable -> PM signs off
6. AI produces Audit deliverable -> PM reviews findings
7. Validated alignment package feeds into Learn

**PM approval gates:** Scope boundaries, master plan design, final sign-off, audit acceptance.

**Example interaction:**
```
PM:  /dsbv design align pd
AI:  [Pre-flight] PD at Logic Scaffold, no upstream needed.
     Here is the draft Project Charter for PD...
PM:  The scope looks good but add "user onboarding" as an objective.
AI:  Updated. Here is the revised Project Charter. Ready to proceed to Design?
PM:  Yes, proceed.
AI:  [Design] Here is the master plan with VANA criteria...
PM:  Approved. Lock it.
AI:  [Production] Alignment locked and signed off. Moving to Audit.
AI:  [Audit] Alignment Audit complete. No gaps found. Ready for Learn.
```

## 6.2. LEARN

> **Purpose:** Understand blockers (UBS) and drivers (UDS), design effective solutions based on outcome, timeline, and resources.

**Our command:** `/dsbv design learn` | Vinh's command: `/ues-learn <sub-system>`

**What it produces at each stage:**

| **STAGE** | **DELIVERABLE** | **PM ROLE** | **AI ROLE** |
|---|---|---|---|
| **SCOPE** | Learning Scope | Prioritizes research questions | Defines learning boundaries and data collection plan |
| **DESIGN** | Research Methodology | Validates analytical approach | Designs UBS/UDS diagnosis, drafts effective principles |
| **PRODUCTION** | UBS/UDS Analysis + Effective Principles | Reviews evidence and principles | Executes full UBS/UDS analysis, derives effective principles |
| **AUDIT** | Learning Audit | Reviews rigor of analysis | Verifies diagnosis is evidence-based and complete |

**PM approval gates:** Research question priorities, analytical approach validation, evidence quality review, audit rigor.

**This is where Effective System Design happens.** The Learn work stream uses the 8-component ESD model:

| **#** | **COMPONENT** | **ABBREVIATION** | **DESCRIPTION** |
|---|---|---|---|
| 1 | **EFFECTIVE INPUTS** | EI | Quality and quantity of inputs (data, resources, criteria) |
| 2 | **EFFECTIVE USERS** | EU | The right people in the right roles (RACI) |
| 3 | **EFFECTIVE ACTIONS** | EA | The right actions performed correctly |
| 4 | **EFFECTIVE OUTPUTS** | EO | Quality and quantity of outputs (deliverables, outcomes) |
| 5 | **EFFECTIVE PRINCIPLES** | EP | Principles that overcome UBS and utilize UDS |
| 6 | **EFFECTIVE OPERATING ENVIRONMENT** | EOE | The right conditions for success |
| 7 | **EFFECTIVE OPERATING TOOLS** | EOT | The right tools for the job |
| 8 | **EFFECTIVE OPERATING PROCEDURE** | EOP | The right process (SOPs) |

**Full reference:** `_genesis/reference/` — Effective System Design PDF

## 6.3. PLAN

> **Purpose:** Create an execution plan to develop the appropriate set of features in each iteration.

**Our command:** `/dsbv design plan` | Vinh's command: `/ues-plan <sub-system>`

**What it produces at each stage:**

| **STAGE** | **DELIVERABLE** | **PM ROLE** | **AI ROLE** |
|---|---|---|---|
| **SCOPE** | Iteration Scope | Approves scope and priorities | Defines iteration boundaries, capacity assessment |
| **DESIGN** | Task Breakdown + RACI | Reviews task assignments and estimates | Breaks deliverables into tasks, assigns RACI, estimates effort |
| **PRODUCTION** | Risk/Driver Entries + Stage Board | Approves execution plan | Finalizes plan, creates tracking board, sets up WMS |
| **AUDIT** | Planning Audit | Reviews plan feasibility | Verifies plan is realistic and risk-managed |

**PM approval gates:** Scope and priority approval, task assignment review, execution plan lock, plan feasibility.

**Key principle:** Plan always sequences **derisk-first**. Sustainability risks are addressed before efficiency optimizations.

## 6.4. EXECUTE

> **Purpose:** Develop and deliver the planned set of features.

**Our command:** `/dsbv build` | Vinh's command: `/ues-execute <sub-system>`

**What it produces at each stage:**

| **STAGE** | **DELIVERABLE** | **PM ROLE** | **AI ROLE** |
|---|---|---|---|
| **SCOPE** | Sprint Kickoff | Confirms sprint scope is ready | Verifies prerequisites, creates kickoff brief |
| **DESIGN** | Technical Design | Reviews technical approach | Designs implementation, creates test plans |
| **PRODUCTION** | Progress Tracker + Daily Standup | Monitors progress, unblocks issues | Builds deliverables, tracks progress, updates daily |
| **AUDIT** | Execution Audit | Accepts or rejects deliverables | Verifies artifacts meet acceptance criteria |

**PM approval gates during Execute:**
- Sprint scope confirmation (Scope stage)
- Technical design sign-off (Design stage)
- Deliverable acceptance (Audit stage)

## 6.5. IMPROVE

> **Purpose:** Collect feedback from users, validate improvements, and feed them back into Align.

**Our command:** `/dsbv validate` | Vinh's command: `/ues-improve <sub-system>`

**What it produces at each stage:**

| **STAGE** | **DELIVERABLE** | **PM ROLE** | **AI ROLE** |
|---|---|---|---|
| **SCOPE** | Feedback Collection Plan | Defines feedback channels | Plans feedback collection scope and methods |
| **DESIGN** | Feedback Analysis Design | Validates analysis criteria | Designs feedback analysis methodology |
| **PRODUCTION** | Feedback Register + Sprint Review | Reviews validated improvements | Processes feedback, categorizes, validates against Three Pillars |
| **AUDIT** | Improvement Audit + Retrospective | Approves improvement recommendations | Verifies process was rigorous, produces retrospective |

**PM approval gates:** Feedback channel selection, analysis criteria validation, improvement acceptance, retrospective approval.

**The improvement loop closes here:** Validated improvement requests feed back into Align for the next iteration.

---

# 7. STAGE GUIDE

## 7.1. SCOPE

> **Purpose:** Define what needs to be done and why.

| **ACTIVITY** | **DESCRIPTION** |
|---|---|
| **DEFINE BOUNDARIES** | What is in scope and what is out of scope |
| **IDENTIFY STAKEHOLDERS** | Who is involved (RACI) |
| **SET SUCCESS CRITERIA** | What does "done" look like (VANA) |
| **ASSESS RISKS** | What could go wrong |
| **GO/NO-GO DECISION** | PM approves or rejects the scope |

**PM review gate:** Approve the scope before proceeding to Design.

## 7.2. DESIGN

> **Purpose:** Design how to accomplish the scoped work.

| **ACTIVITY** | **DESCRIPTION** |
|---|---|
| **DESIGN THE APPROACH** | How will the work be done |
| **DEFINE ACCEPTANCE CRITERIA** | Detailed VANA criteria per deliverable |
| **PLAN RESOURCES** | What tools, data, and people are needed |
| **SEQUENCE DERISK-FIRST** | Address sustainability risks before efficiency optimizations |
| **CREATE BLUEPRINT** | Produce the design document or methodology |

**PM review gate:** Approve the design before proceeding to Production.

## 7.3. PRODUCTION

> **Purpose:** Execute the design and produce deliverables.

| **ACTIVITY** | **DESCRIPTION** |
|---|---|
| **BUILD DELIVERABLES** | AI agent produces the planned outputs |
| **TRACK PROGRESS** | Update progress tracker and daily standup notes |
| **LOG ISSUES** | Record blockers, risks, and decisions |
| **TEST AND VALIDATE** | Verify outputs against acceptance criteria |
| **DOCUMENT** | Ensure all work is documented and committed |

**PM review gate:** Spot-check deliverables during production. Final review at Audit.

## 7.4. AUDIT

> **Purpose:** Verify deliverables meet acceptance criteria and feed the right output forward.

| **ACTIVITY** | **DESCRIPTION** |
|---|---|
| **VERIFY AGAINST VANA** | Do deliverables meet the version's VANA criteria |
| **CHECK CHAIN-OF-CUSTODY** | Are upstream inputs properly consumed |
| **LOG DEFECTS** | Record any issues with severity |
| **PRODUCE AUDIT REPORT** | Summarize findings and corrective actions |
| **FEED FORWARD** | Pass validated deliverables to the next work stream |

**PM review gate:** Accept or reject the audit report. If rejected, corrective actions loop back to the appropriate stage.

---

# 8. SUB-SYSTEM GUIDE

## 8.1. PROBLEM DIAGNOSIS (PD)

> **Purpose:** Diagnose user problems by identifying blockers (UBS) and drivers (UDS). Produce effective principles and design guidelines that govern the entire UES.

| **ATTRIBUTE** | **DETAIL** |
|---|---|
| **PRIMARY OUTPUT** | Effective principles (EP) for the entire UES |
| **CHAIN POSITION** | First in sequence (PD -> DP -> DA -> IDM) |
| **UPSTREAM INPUT** | Business mandate, user problem statement, strategic directive |
| **DOWNSTREAM IMPACT** | EP governs ALL downstream sub-systems (DP, DA, IDM) |

**What PD inherits from upstream:** Nothing — PD is the first sub-system in the chain.

**What PD produces for downstream:** Effective Principles (EP) that govern ALL downstream sub-systems (DP, DA, IDM). If PD's EP conflicts with a downstream design decision, PD's EP takes precedence.

**Version constraints:** PD has no upstream version constraints. PD's version level sets the ceiling for all downstream sub-systems (DP version <= PD version, DA version <= DP version, IDM version <= DA version).

**Critical rule:** PD produces Effective Principles that govern the ENTIRE UES. All downstream sub-systems (DP, DA, IDM) MUST inherit and comply with PD's effective principles.

**Full reference:** `_genesis/reference/` — ALPEI Framework by Sub-Systems PDF (Section 1: Problem Diagnosis)

## 8.2. DATA PIPELINE (DP)

> **Purpose:** Build and operate the data pipeline to acquire, clean, standardize, transform, and validate data into analysis-ready datasets.

| **ATTRIBUTE** | **DETAIL** |
|---|---|
| **PRIMARY OUTPUT** | Processed, clean, standardized, analysis-ready data |
| **CHAIN POSITION** | Second (PD -> **DP** -> DA -> IDM) |
| **UPSTREAM INPUT** | Effective principles from PD, design guidelines from PD |
| **DOWNSTREAM IMPACT** | Data quality determines analysis accuracy |

**What DP inherits from upstream:** Effective Principles from PD, design guidelines from PD. All pipeline design must comply with PD's EP.

**What DP produces for downstream:** Processed, clean, standardized, analysis-ready data for DA.

**Version constraints:** DP cannot advance to a version level higher than PD's current version.

**Pre-requisite:** PD effective principles MUST exist before starting DP.

**Full reference:** `_genesis/reference/` — ALPEI Framework by Sub-Systems PDF (Section 2: Data Pipeline)

## 8.3. DATA ANALYSIS (DA)

> **Purpose:** Analyze processed data to produce validated insights with confidence levels and stated limitations.

| **ATTRIBUTE** | **DETAIL** |
|---|---|
| **PRIMARY OUTPUT** | Analyzed insights (trends, patterns, correlations, anomalies, forecasts) |
| **CHAIN POSITION** | Third (PD -> DP -> **DA** -> IDM) |
| **UPSTREAM INPUT** | Analysis-ready data from DP, effective principles from PD |
| **DOWNSTREAM IMPACT** | Insight quality determines decision quality |

**What DA inherits from upstream:** Analysis-ready data from DP, Effective Principles from PD. All analytical methodology must comply with PD's EP.

**What DA produces for downstream:** Validated insights (trends, patterns, correlations, anomalies, forecasts) with confidence levels for IDM.

**Version constraints:** DA cannot advance to a version level higher than DP's current version.

**Pre-requisite:** DP analysis-ready data MUST exist before starting DA.

**Full reference:** `_genesis/reference/` — ALPEI Framework by Sub-Systems PDF (Section 3: Data Analysis)

## 8.4. INSIGHTS & DECISION MAKING (IDM)

> **Purpose:** Deliver actionable insights through dashboards, decision recommendations, and risk alerts. This is the user-facing sub-system and the final quality gate of the UES.

| **ATTRIBUTE** | **DETAIL** |
|---|---|
| **PRIMARY OUTPUT** | Insight dashboards, decision recommendations, risk alerts |
| **CHAIN POSITION** | Fourth and final (PD -> DP -> DA -> **IDM**) |
| **UPSTREAM INPUT** | Validated insights from DA, effective principles from PD |
| **DOWNSTREAM IMPACT** | End-user enablement — this is what users interact with |

**What IDM inherits from upstream:** Validated insights from DA, Effective Principles from PD. All dashboard and decision design must comply with PD's EP.

**What IDM produces for downstream:** End-user-facing insight dashboards, decision recommendations, and risk alerts. This is the final output of the UES.

**Version constraints:** IDM cannot advance to a version level higher than DA's current version.

**Pre-requisite:** DA validated insights MUST exist before starting IDM.

**Full reference:** `_genesis/reference/` — ALPEI Framework by Sub-Systems PDF (Section 4: Insights & Decision Making)

## 8.5. CHAIN-OF-CUSTODY

The sub-systems chain forward. Each sub-system's output is the next sub-system's input:

```
PD Effective Principles
  |
  |-- DP: Pipeline design governed by PD's EP
  |     |
  |     |-- DA: Analytical methodology governed by PD's EP
  |           |
  |           |-- IDM: Dashboard/decision design governed by PD's EP
  |
  v
  All sub-systems inherit PD's Effective Principles
```

| **BEFORE STARTING** | **VERIFY EXISTS** | **IF MISSING** |
|---|---|---|
| **DP** | PD effective principles | Complete PD first |
| **DA** | DP analysis-ready data | Complete DP first |
| **IDM** | DA validated insights | Complete DA first |

### VERSION ADVANCEMENT CONSTRAINTS

Downstream sub-systems cannot advance to a higher version than their upstream sub-system:

- **DP** cannot advance past PD's current version
- **DA** cannot advance past DP's current version
- **IDM** cannot advance past DA's current version

Before advancing any sub-system, verify the upstream sub-system is at the same or higher version.

### PARALLEL CELL ELIGIBILITY

- **Work streams** within the SAME sub-system can run **concurrently** (they are designed to be concurrent)
- **Work across DIFFERENT sub-systems** can run in parallel **ONLY IF** upstream outputs exist and chain-of-custody is satisfied
- **Stages** within a work stream are **STRICTLY sequential** (Scope → Design → Production → Audit)

---

# 9. VERSION PROGRESSION GUIDE

## 9.1. VERSION SEQUENCE

Each sub-system progresses through five versions, each corresponding to a pillar of effectiveness:

```
Logic Scaffold --> Concept --> Prototype --> MVE --> Leadership
  (Pre-build)    (Sustain)   (+ Effic.)  (Full Effic.)  (+ Scale)
```

### LOGIC SCAFFOLD

| **ATTRIBUTE** | **DETAIL** |
|---|---|
| **PILLAR** | Pre-build (no construction yet) |
| **WHAT IT DELIVERS** | Complete understanding of the problem, scope mapping, logical structure |
| **WHAT IT DOES NOT DELIVER** | Implementation code, working systems, automation |
| **VANA** | Understand and design, clearly and completely, the scope and logic (clear, complete) |
| **ANALOGY** | The blueprint — mapping what the system needs to solve |

### CONCEPT

| **ATTRIBUTE** | **DETAIL** |
|---|---|
| **PILLAR** | Sustainability |
| **WHAT IT DELIVERS** | Proof that the logic works and failure risks are under control |
| **KEY CRITERIA** | Correct and safe, even if manual and simulated |
| **VANA** | Derisk and deliver output, correctly and safely, in simulated environment (correct, safe) |
| **ANALOGY** | The safety test — proving it will not break |

### PROTOTYPE

| **ATTRIBUTE** | **DETAIL** |
|---|---|
| **PILLAR** | Sustainability + Efficiency (emerging) |
| **WHAT IT DELIVERS** | Demonstration that the system outperforms alternatives |
| **KEY CRITERIA** | Still safe, but now also faster and easier than other approaches |
| **VANA** | Derisk and deliver output, more easily and with higher output than alternatives, using a prototype system (correct, safe) |
| **ANALOGY** | The proof of concept — showing it is better than what exists |

### MINIMUM VIABLE ENABLEMENT (MVE)

| **ATTRIBUTE** | **DETAIL** |
|---|---|
| **PILLAR** | Sustainability + Efficiency (full) |
| **WHAT IT DELIVERS** | Full, working, production-ready enablement system |
| **KEY CRITERIA** | Reliable, cost-effective, proven at scale for current resources |
| **VANA** | Derisk and deliver output, reliably, with the full working system (reliable, cheaper, fairly easy to acquire) |
| **ANALOGY** | The production release — ready for daily use |

### LEADERSHIP

| **ATTRIBUTE** | **DETAIL** |
|---|---|
| **PILLAR** | Sustainability + Efficiency + Scalability |
| **WHAT IT DELIVERS** | Automated, predictive, prescriptive system that improves as resources grow |
| **KEY CRITERIA** | Gets disproportionately better with more resources |
| **VANA** | Derisk and deliver output, automatically and predictively, including some user actions (automatic, predictive, prescriptive) |
| **ANALOGY** | The self-driving system — it gets better on its own |

## 9.2. VANA CRITERIA PER VERSION (FULL TABLE)

| **VERSION** | **PILLAR** | **VERB** | **ADVERBS** | **NOUN** | **ADJECTIVES** |
|---|---|---|---|---|---|
| **LOGIC SCAFFOLD** | (Pre-build) | Understand and design | Clearly, completely | The scope and logic of the enablement system | Clear, complete |
| **CONCEPT** | Sustainability | Derisk and deliver output | Correctly, safely | User's environment with simulated tools, SOP, and actions | Correct, safe |
| **PROTOTYPE** | Sustainability + Efficiency | Derisk and deliver output | Correctly, safely, more easily, higher output, better time-saving than alternatives | Prototype of the real enablement system | Correct, safe |
| **MVE** | Sustainability + full Efficiency | Derisk and deliver output | Correctly, safely, reliably, more easily, higher output, better time-saving | Full, working enablement system | Correct, safe, reliable, cheaper, fairly easy to acquire |
| **LEADERSHIP** | All three pillars | Derisk and deliver output | Correctly, safely, reliably, automatically, predictively, prescriptively | Full enablement system including some user actions | Correct, safe, reliable, automatic, predictive, prescriptive |

## 9.3. VERSION MANAGEMENT (OUR EQUIVALENTS)

Vinh's commands and our nearest equivalents:

| **VINH COMMAND** | **PURPOSE** | **OUR EQUIVALENT** |
|---|---|---|
| `/ues-version` | Check current version level of a sub-system | `/dsbv status` |
| `/ues-vana` | Validate deliverables against VANA criteria | `/dsbv validate` |
| `/ues-advance-version` | Formally advance to next version | Manual: update version in deliverable frontmatter + ADR in `1-ALIGN/decisions/` |
| `/ues-close-iteration` | Formally close an iteration | Update `5-IMPROVE/changelog/CHANGELOG.md` + close PR |

## 9.4. VERSION ADVANCEMENT PROCESS

```
1. Complete all deliverables for current version
       |
2. Run /dsbv validate to check against VANA criteria
       |
3. If VANA passes --> Advance version
       |                  (update frontmatter + log ADR)
       |
4. If VANA fails --> Identify gaps
       |
5. Create new iteration to address gaps
       |
6. Loop back to step 1
```

## 9.5. ITERATION VS VERSION

| **CONCEPT** | **DESCRIPTION** | **EXAMPLE** |
|---|---|---|
| **ITERATION** | One cycle through Align -> Learn -> Plan -> Execute -> Improve within a version | PD Concept Iteration 1, PD Concept Iteration 2 |
| **VERSION** | A maturity level defined by VANA criteria | Logic Scaffold, Concept, Prototype, MVE, Leadership |
| **RELATIONSHIP** | Each version can have one or more iterations | Concept may take 3 iterations before VANA is satisfied |

---

# 10. ITERATION LIFECYCLE

## 10.1. STEP-BY-STEP ITERATION FLOW

A single iteration flows through all five work streams in sequence. Each step includes the command to use and the PM approval gate.

### STEP 1: ALIGN THE ITERATION

| **ATTRIBUTE** | **DETAIL** |
|---|---|
| **COMMAND** | `/dsbv design align` |
| **PM GATE** | Approve scope boundaries, validate master plan, sign off on alignment lock |

- Define what this iteration will deliver
- Set VANA criteria for the current version
- Lock the master plan and get PM sign-off
- Output: Approved master plan and stakeholder commitments

### STEP 2: LEARN THE DOMAIN

| **ATTRIBUTE** | **DETAIL** |
|---|---|
| **COMMAND** | `/dsbv design learn` |
| **PM GATE** | Prioritize research questions, validate analytical approach, review evidence quality |

- Understand blockers (UBS) and drivers (UDS)
- Design effective solutions based on outcome, timeline, and resources
- Derive effective principles
- Output: Validated UBS/UDS analysis and effective principles

### STEP 3: PLAN THE EXECUTION

| **ATTRIBUTE** | **DETAIL** |
|---|---|
| **COMMAND** | `/dsbv design plan` |
| **PM GATE** | Approve scope and priorities, review task assignments, lock execution plan |

- Create detailed execution plan with task breakdown
- Assign RACI for each task
- Sequence tasks derisk-first
- Output: Locked execution plan with risk register

### STEP 4: EXECUTE THE PLAN

| **ATTRIBUTE** | **DETAIL** |
|---|---|
| **COMMAND** | `/dsbv build` |
| **PM GATE** | Confirm sprint scope, sign off technical design, accept or reject deliverables |

- Build and deliver all planned features
- Track progress daily
- Test and validate against acceptance criteria
- Output: Delivered and tested artifacts

### STEP 5: IMPROVE FROM FEEDBACK

| **ATTRIBUTE** | **DETAIL** |
|---|---|
| **COMMAND** | `/dsbv validate` |
| **PM GATE** | Define feedback channels, validate analysis criteria, approve improvement recommendations |

- Collect feedback from users and stakeholders
- Validate feedback against evidence and Three Pillars
- Categorize improvement requests
- Output: Validated improvement requests for next iteration

### STEP 6: CLOSE THE ITERATION

- Formally verify all deliverables are complete
- Update `5-IMPROVE/changelog/CHANGELOG.md`
- Log lessons learned in `5-IMPROVE/retros/`
- Close PR per branching strategy in `_genesis/frameworks/HISTORY_VERSION_CONTROL.md`

### STEP 7: DECIDE — ITERATE AGAIN OR ADVANCE VERSION

- Validate all deliverables against VANA criteria for the current version (`/dsbv validate`)
- **If all VANA criteria are met:** PM decides to advance version (proceed to Step 8)
- **If gaps remain:** PM decides to iterate again (loop back to Step 1 with a new iteration number)
- This is the most critical PM decision point — the AI agent recommends, but the PM decides

### STEP 8: ADVANCE VERSION (IF READY)

- Formally advance the sub-system to the next version
- Log ADR in `1-ALIGN/decisions/` documenting the advancement decision
- Verify chain-of-custody (upstream sub-systems must be at same or higher version)
- Begin next version's first iteration

## 10.2. ITERATION LIFECYCLE DIAGRAM

```
  Design: align     Design: learn     Design: plan
      |                   |                   |
  [ALIGN]  ---------> [LEARN]  ---------> [PLAN]
      |                   |                   |
  Scope                Scope                Scope
  Design               Design               Design
  Production           Production           Production
  Audit                Audit                Audit
                                              |
                                              v
  Validate             Build
      |                   |
  [IMPROVE] <--------- [EXECUTE]
      |                   |
  Scope                Scope
  Design               Design
  Production           Production
  Audit                Audit
      |
      v
  Close iteration --> /dsbv validate --> Advance version (if ready)
      |                                         |
      v                                         v
  [Next Iteration]                    [Next Version, Iteration 1]
```

---

# 11. COMMAND REFERENCE

Vinh's workspace provides 44 `/ues-*` commands. Our equivalents are in `.claude/skills/`. Key mapping:

## 11.1. WORK STREAM COMMANDS

| **VINH COMMAND** | **OUR EQUIVALENT** | **PURPOSE** |
|---|---|---|
| `/ues-align <sub-system>` | `/dsbv design align` | Run the Align work stream |
| `/ues-learn <sub-system>` | `/dsbv design learn` | Run the Learn work stream |
| `/ues-plan <sub-system>` | `/dsbv design plan` | Run the Plan work stream |
| `/ues-execute <sub-system>` | `/dsbv build` | Run the Execute work stream |
| `/ues-improve <sub-system>` | `/dsbv validate` | Run the Improve work stream |

## 11.2. SUB-SYSTEM COMMANDS

| **VINH COMMAND** | **PURPOSE** | **NOTE** |
|---|---|---|
| `/ues-pd` | Problem Diagnosis — diagnose user problems, identify UBS/UDS | Use `/dsbv` with pd context |
| `/ues-dp` | Data Pipeline — build and operate pipelines | Use `/dsbv` with dp context |
| `/ues-da` | Data Analysis — analyze processed data for insights | Use `/dsbv` with da context |
| `/ues-idm` | Insights & Decision Making — deliver dashboards, recommendations | Use `/dsbv` with idm context |

## 11.3. LIFECYCLE COMMANDS

| **VINH COMMAND** | **OUR EQUIVALENT** | **PURPOSE** |
|---|---|---|
| `/ues-overview` | `/dsbv status` | Display full ALPEI framework matrix and current progress |
| `/ues-next` | `/dsbv status` | AI recommends next step based on chain-of-custody |
| `/ues-audit-all` | `/dsbv validate` (cross-cutting) | Cross-cutting audit of all deliverables |
| `/ues-close-iteration` | Update `5-IMPROVE/changelog/` + close PR | Formally close an iteration |
| `/ues-advance-version` | Log ADR + update frontmatter | Formally advance a sub-system to next version |
| `/ues-vana` | `/dsbv validate` | Validate deliverables against VANA criteria |
| `/ues-risk` | Read `3-PLAN/risks/UBS_REGISTER.md` | View consolidated risk register |
| `/ues-system-design` | Load `rules/general-system.md` | Design using 8-component ESD model |
| `/ues-truths` | Load `_genesis/reference/` — Ultimate Truths PDF | Ground analysis in 10 Ultimate Truths |
| `/ues-version` | `/dsbv status` | Check current version level |

## 11.4. GOVERNANCE COMMANDS

| **VINH COMMAND** | **OUR EQUIVALENT** | **PURPOSE** |
|---|---|---|
| `/ltc-decide` | Load `rules/general-system.md` — force analysis | Filter decisions through Three Pillars framework |
| `/ltc-brainstorming` | Load `rules/general-system.md` | Structured creative exploration |
| `/ltc-writing-plans` | `/dsbv design plan` | Create structured execution plans |
| `/ltc-clickup-planner` | ClickUp MCP | Sync plans to ClickUp |
| `/ltc-notion-planner` | `/notion-planner` skill | Sync plans to Notion |

## 11.5. VAULT / DAILY COMMANDS

| **VINH COMMAND** | **OUR EQUIVALENT** | **PURPOSE** |
|---|---|---|
| `/vault-daily` | Manual: create `DAILY NOTES/YYYY-MM-DD.md` [Obsidian-specific] | Create or update today's daily note |
| `/vault-capture` | Add to `1-ALIGN/learning/` | Quick capture a thought or task |
| `/vault-weekly-review` | Review `5-IMPROVE/retros/` | Review the past week |
| `/obsidian-cli` | N/A `[Obsidian-specific — adapt to your tooling]` | Obsidian vault manipulation |

---

# 12. TEMPLATE REFERENCE (41 TEMPLATES)

Vinh's workspace provides 41 Templater templates `[Obsidian-specific — adapt to your tooling]`. Our equivalent templates are in `_genesis/templates/`. Key mapping:

## 12.1. CORE DELIVERABLE TEMPLATES

### ALIGN TEMPLATES (5)

| **STAGE** | **VINH TEMPLATE** | **OUR LOCATION** |
|---|---|---|
| **SCOPE** | Project Charter | `1-ALIGN/charter/` |
| **DESIGN** | ALIGN Master Plan (VANA) | `1-ALIGN/charter/` |
| **DESIGN** | OKR | `1-ALIGN/okrs/` |
| **PRODUCTION** | Alignment Lock & Sign-Off | `1-ALIGN/charter/` |
| **AUDIT** | Alignment Audit Report | `1-ALIGN/VALIDATE.md` |

### LEARN TEMPLATES (9)

| **STAGE** | **VINH TEMPLATE** | **OUR LOCATION** |
|---|---|---|
| **SCOPE** | Learning Scope Document | `1-ALIGN/learning/` |
| **DESIGN** | Research Methodology Design | `1-ALIGN/learning/` |
| **PRODUCTION** | UBS Full Analysis | `3-PLAN/risks/UBS_REGISTER.md` |
| **PRODUCTION** | UDS Full Analysis | `3-PLAN/drivers/UDS_REGISTER.md` |
| **PRODUCTION** | Effective Principles Derivation | `1-ALIGN/learning/` |
| **PRODUCTION** | Effective System Design (UES) | Load `rules/general-system.md` |
| **PRODUCTION** | Research (CODE Framework) | `/deep-research` skill |
| **PRODUCTION** | Spike Investigation | `1-ALIGN/learning/` |
| **AUDIT** | Learning Audit Report | `2-LEARN/VALIDATE.md` |

### PLAN TEMPLATES (6)

| **STAGE** | **VINH TEMPLATE** | **OUR LOCATION** |
|---|---|---|
| **SCOPE** | Iteration Scope Document | `3-PLAN/roadmap/` |
| **DESIGN** | Task Breakdown + RACI | `3-PLAN/architecture/` |
| **DESIGN** | Architecture Decision Record | `1-ALIGN/decisions/` |
| **PRODUCTION** | UBS Risk Entry | `3-PLAN/risks/UBS_REGISTER.md` |
| **PRODUCTION** | UDS Driver Entry | `3-PLAN/drivers/UDS_REGISTER.md` |
| **AUDIT** | Planning Audit Report | `3-PLAN/VALIDATE.md` |

### EXECUTE TEMPLATES (5)

| **STAGE** | **VINH TEMPLATE** | **OUR LOCATION** |
|---|---|---|
| **SCOPE** | Sprint Kickoff + Readiness Check | `4-EXECUTE/` |
| **DESIGN** | Technical Design Document | `4-EXECUTE/` |
| **PRODUCTION** | Execution Progress Tracker | `4-EXECUTE/` |
| **PRODUCTION** | Daily Standup | `4-EXECUTE/` |
| **AUDIT** | Execution Audit Report | `4-EXECUTE/VALIDATE.md` |

### IMPROVE TEMPLATES (6)

| **STAGE** | **VINH TEMPLATE** | **OUR LOCATION** |
|---|---|---|
| **SCOPE** | Feedback Collection Plan | `5-IMPROVE/` |
| **DESIGN** | Feedback Analysis Design | `5-IMPROVE/` |
| **PRODUCTION** | Feedback Register | `5-IMPROVE/` |
| **PRODUCTION** | Sprint Review | `5-IMPROVE/reviews/` |
| **AUDIT** | Improvement Audit Report | `5-IMPROVE/VALIDATE.md` |
| **AUDIT** | Retrospective | `5-IMPROVE/retros/` |

## 12.2. TEMPLATE COUNT SUMMARY

| **CATEGORY** | **COUNT** | **DETAILS** |
|---|---|---|
| **Align** | 5 | Project Charter, Master Plan, OKR, Lock & Sign-Off, Audit |
| **Learn** | 9 | Scope, Methodology, UBS, UDS, EP, ESD, Research, Spike, Audit |
| **Plan** | 6 | Scope, Task Breakdown, ADR, Risk Entry, Driver Entry, Audit |
| **Execute** | 5 | Kickoff, Technical Design, Progress Tracker, Daily Standup, Audit |
| **Improve** | 6 | Collection, Analysis, Register, Review, Audit, Retrospective |
| **Collaboration** | 4 | Approval, Escalation, Status Report, Dependency Register |
| **Lifecycle** | 4 | Iteration Close, Version Log, Version Registry, Handoff |
| **PM Oversight** | 2 | Master Dashboard, Stage Board |
| **TOTAL** | **41** | |

---

# 13. DASHBOARDS & TRACKING

`[Obsidian-specific section — Vinh uses Obsidian Bases (.base files) for database-like views. Adapt to your tooling.]`

Vinh's workspace uses **Obsidian Bases** to provide structured oversight dashboards. The concept translates to any tracking tool:

## 13.1. DASHBOARD EQUIVALENTS

| **VINH DASHBOARD** | **PURPOSE** | **OUR EQUIVALENT** |
|---|---|---|
| **ALPEI Master Dashboard** | Single-page view of all 4 sub-systems: version, iteration, work stream, stage, blockers | `/dsbv status` output + WMS (Notion/ClickUp) |
| **ALPEI Stage Board** | Kanban across Scope, Design, Production, Audit stages `[Obsidian Kanban plugin]` | ClickUp board view or Notion board |
| **Approval Queue** | Pending PM approvals | Notion task board or ClickUp |
| **Blocker Dashboard** | Aggregated blockers across sub-systems | `3-PLAN/risks/UBS_REGISTER.md` |
| **Version Progress** | All sub-systems' version status | `/dsbv status` |

## 13.2. FRONTMATTER REQUIREMENTS

For files to work with ALPEI tracking, they need proper frontmatter:

- `version` — Current version level (Logic Scaffold, Concept, Prototype, MVE, Leadership)
- `last_updated` — ISO date (YYYY-MM-DD)
- `sub-system` — PD, DP, DA, or IDM
- `work-stream` — align, learn, plan, execute, or improve
- `stage` — scope, design, production, or audit
- `status` — draft, in-progress, complete, approved

All our files also follow the versioning rule in `.claude/rules/versioning.md`.

---

# 14. GLOSSARY

| **TERM** | **FULL NAME** | **DEFINITION** |
|---|---|---|
| **ALPEI** | Align, Learn, Plan, Execute, Improve | The five concurrent work streams of the LTC agile framework |
| **CONCEPT** | Concept Version | Second version level; proves sustainability (correct, safe) |
| **DA** | Data Analysis | Third sub-system; analyzes processed data into insights |
| **DP** | Data Pipeline | Second sub-system; acquires, cleans, and processes data |
| **EA** | Effective Actions | The right actions performed correctly (ESD component 3) |
| **EI** | Effective Inputs | Quality inputs including data, resources, criteria (ESD component 1) |
| **EO** | Effective Outputs | Quality outputs and deliverables (ESD component 4) |
| **EOE** | Effective Operating Environment | The right conditions for success (ESD component 6) |
| **EOP** | Effective Operating Procedure | The right process and SOPs (ESD component 8) |
| **EOT** | Effective Operating Tools | The right tools for the job (ESD component 7) |
| **EP** | Effective Principles | Principles that overcome UBS and utilize UDS (ESD component 5) |
| **ESD** | Effective System Design | The 8-component model for designing effective systems |
| **EU** | Effective Users | The right people in the right roles via RACI (ESD component 2) |
| **IDM** | Insights & Decision Making | Fourth sub-system; delivers dashboards, recommendations, risk alerts |
| **LEADERSHIP** | Leadership Version | Fifth version level; adds scalability (automatic, predictive, prescriptive) |
| **LOGIC SCAFFOLD** | Logic Scaffold Version | First version level; understand and design only, no building |
| **MVE** | Minimum Viable Enablement | Fourth version level; full efficiency (reliable, cost-effective) |
| **PD** | Problem Diagnosis | First sub-system; diagnoses problems, produces effective principles |
| **PROTOTYPE** | Prototype Version | Third version level; emerging efficiency (outperforms alternatives) |
| **RACI** | Responsible, Accountable, Consulted, Informed | Role assignment framework for task ownership |
| **THREE PILLARS** | Three Pillars of Effectiveness | Sustainability -> Efficiency -> Scalability (in priority order) |
| **UBS** | Ultimate Blocking System | Collection of blockers that hinder the system's outcome |
| **UDS** | Ultimate Driving System | Collection of drivers that enable the system's outcome |
| **UES** | User Enablement System | The complete system produced by the ALPEI framework |
| **VANA** | Verb, Adverb, Noun, Adjective | Success criteria framework derived from Ultimate Truth #2 |

---

# 15. TROUBLESHOOTING

## 15.1. SETUP ISSUES

| **PROBLEM** | **CAUSE** | **SOLUTION** |
|---|---|---|
| **Claude Code not recognizing commands** | `CLAUDE.md` or `.claude/rules/` not found | Verify you are in the workspace root directory; check file existence |
| **Git push fails** | Authentication not configured | Run `git config credential.helper osxkeychain` and authenticate |
| **Obsidian shows empty vault** `[Obsidian-specific]` | Folder not opened correctly | Reopen vault: Settings > Vault > Open folder as vault |
| **Plugins not loading** `[Obsidian-specific]` | `.obsidian/` config missing or corrupted | Re-clone the repository |
| **iCloud sync conflicts** `[Obsidian-specific]` | Multiple devices editing simultaneously | Close Obsidian on other devices; resolve conflicts by keeping the latest version |

## 15.2. FRAMEWORK ISSUES

| **PROBLEM** | **CAUSE** | **SOLUTION** |
|---|---|---|
| **Chain-of-custody warning** | Upstream deliverables missing | Complete the upstream work stream first (PD before DP, etc.) |
| **VANA check fails** | Deliverables do not meet version criteria | Review VANA table (Section 9.2), identify gaps, create a new iteration |
| **AI agent skips pre-flight** | Agent not following rules | Explicitly say "Run pre-flight checks" or invoke `/dsbv status` |
| **Wrong version depth** | AI agent building beyond current version | Remind the agent of the current version: "We are at Logic Scaffold, no code yet" |
| **Template not found** | Template does not exist for this deliverable type | Create the deliverable with proper frontmatter and flag the gap |

## 15.3. DAILY WORKFLOW ISSUES

| **PROBLEM** | **CAUSE** | **SOLUTION** |
|---|---|---|
| **`/dsbv status` shows stale data** | Deliverables not saved or committed | Save all open files; commit and push changes |
| **Unsure what to do next** | Context missing or outdated | Run `/dsbv status` first to refresh context |
| **Progress not tracked** | Deliverables saved but not committed | Commit and push: `git add . && git commit -m "Progress update" && git push` |

## 15.4. GOOGLE WORKSPACE ISSUES

| **PROBLEM** | **CAUSE** | **SOLUTION** |
|---|---|---|
| **gws commands fail** | Authentication expired | Run `gws auth setup` to re-authenticate |
| **gcloud commands fail** | Project not configured | Run `gcloud init` and select the correct project |

## 15.5. GETTING HELP

If you encounter an issue not covered here:

1. **Check the knowledge base:** Search the `1-ALIGN/learning/` folder for relevant documentation
2. **Ask your AI agent:** Describe the problem; the agent has access to all framework documentation
3. **Raise at standup:** Bring it up in Part 2 (Group Discussion) if it may affect others
4. **Update this SOP:** If you solve a new issue, add it to the troubleshooting section via a pull request

---

> **End of SOP.** This document is maintained in `_genesis/sops/` and tracked via Git. All updates
> must be committed and pushed as pull requests per LTC security policy.
>
> **Related documents:**
> - `_genesis/reference/` — ALPEI Framework Overview & Principles PDF
> - `_genesis/reference/` — ALPEI Framework by Sub-Systems PDF
> - `_genesis/reference/` — Ultimate Truths training materials PDF
> - `_genesis/reference/` — Effective System Design PDF
> - `_genesis/reference/` — UES Versioning PDF
> - `_genesis/frameworks/UES_VERSION_BEHAVIORS.md` — Version-specific deliverables matrix
> - `_genesis/frameworks/HISTORY_VERSION_CONTROL.md` — Branching strategy and version control
> - `_genesis/sops/` — Other LTC SOPs
> - `rules/brand-identity.md` — LTC brand identity
> - `rules/security-rules.md` — Data security and cybersecurity guide

## Links

- [[ALPEI_DSBV_PROCESS_MAP]]
- [[CHANGELOG]]
- [[CLAUDE]]
- [[DESIGN]]
- [[HISTORY_VERSION_CONTROL]]
- [[SEQUENCE]]
- [[SKILL]]
- [[UES_VERSION_BEHAVIORS]]
- [[VALIDATE]]
- [[blocker]]
- [[brand-identity]]
- [[deliverable]]
- [[documentation]]
- [[dsbv]]
- [[general-system]]
- [[increment]]
- [[iteration]]
- [[ltc-builder]]
- [[ltc-explorer]]
- [[ltc-planner]]
- [[ltc-reviewer]]
- [[methodology]]
- [[project]]
- [[security]]
- [[security-rules]]
- [[standard]]
- [[task]]
- [[versioning]]
- [[workstream]]
