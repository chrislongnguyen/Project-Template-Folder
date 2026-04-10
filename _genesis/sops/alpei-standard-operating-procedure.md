---
version: "2.3"
status: draft
last_updated: 2026-04-10
type: sop
work_stream: _genesis
audience: LTC Project Managers operating a UES using this template
---

# ALPEI OPERATING PROCEDURE — LTC PROJECT TEMPLATE

> **What this is:** Step-by-step operating procedure for LTC members running a project cloned from this template.
> **What this is NOT:** The BLUEPRINT (`_genesis/alpei-blueprint.md`) covers WHY — philosophy, principles, framework theory. This SOP covers HOW — practical daily operations.
> **Authority:** When this SOP and BLUEPRINT conflict on procedure, this SOP wins. When they conflict on principle, BLUEPRINT wins.

---

## 1. PURPOSE AND SCOPE

### What

This SOP governs the daily operation of any LTC project built on the ALPEI template. It defines how a Project Manager (PM) — acting as Human Director — uses AI agents, slash commands, and the DSBV sub-process to produce workstream artifacts across 4 sub-systems.

### Who

| Role               | Person                       | Responsibilities                                                   |
| ------------------ | ---------------------------- | ------------------------------------------------------------------ |
| **Human Director** | LTC Project Manager          | Learn, Input, Review, Validate (BLUEPRINT Part 3) |
| **AI Agents**      | 4 specialist agents (see §9) | Research, Design, Build, Validate                                  |
| **CIO**            | Long Nguyen                  | Framework authority, BLUEPRINT owner                               |

### What the System Is

The LTC AI Operating System is a 5-workstream framework (ALPEI) that produces a User Enablement System (UES) composed of 4 sequential sub-systems. The PM directs AI agents through a 4-stage sub-process (DSBV) within each workstream to produce artifacts that are correct, safe, and reliable before they are efficient or scalable.

**Core equation:** `Success = Efficient & Scalable Management of Failure Risks`

**Three Pillars (in mandatory priority order):**

| Priority | Pillar | Focus | UES Version |
|----------|--------|-------|-------------|
| 1st | **Sustainability** | Correct, safe, reliable | Concept (Iteration 1) |
| 2nd | **Efficiency** | Best output for given resources | Prototype (Iteration 2) |
| 3rd | **Scalability** | Best output gains for additional resources | Leadership (Iteration 4) |

---

## 2. OPERATING MODEL

### AI-First Solo Ownership

Each PM owns one UES end-to-end. The PM is the Director — not the Doer. AI agents handle Plan and Execute at the Supervisor/Manager/Doer levels. The PM's job is to **learn well, align well, and coordinate AI well**.

The PM's #1 contribution is **learning quality** — not execution speed, not tool mastery, not framework compliance. If the PM cannot recognize incorrect AI output, every downstream artifact is suspect (BLUEPRINT Principle 2).

### RACI Model

| Activity | AI Agent | Human Director |
|----------|----------|----------------|
| Research and analysis | **R** (Responsible) | **A** (Accountable) |
| Artifact production | **R** | **A** |
| Architecture decisions | **C** (Consulted) | **A** |
| VANA validation | **C** | **A** |
| DSBV stage gate approval | — | **A** (sole) |
| Requirement definition | **C** | **A** |

**Rule:** Agent sets `status: draft`, `in-progress`, or `in-review`. Only Human sets `status: validated`. This is enforced by `scripts/status-guard.sh` at pre-commit.

### Collaboration Boundaries

- **PM-to-PM:** Share via ClickUp (primary WMS). Cross-project knowledge via template-sync.
- **PM-to-Agent:** Claude Code session. Context packaging for sub-agent dispatch.
- **Agent-to-Agent:** Orchestrator pattern only. Main session dispatches sub-agents. Sub-agents NEVER dispatch other sub-agents (EP-13).

### Tool Split

| Tool | Workstreams | Purpose |
|------|------------|---------|
| **Obsidian** | ALIGN, LEARN, PLAN | Thinking, research, knowledge graph, frontmatter dashboards (Bases) |
| **Claude Code** | All (primary for EXECUTE) | Building, coding, testing, agent orchestration |
| **ClickUp** | All | Task tracking, sprint planning, WMS |

---

## 3. FOLDER STRUCTURE

```
OPS_OE.X.X.PROJECT-NAME/
│
├── 1-ALIGN/                        ← Charter, decisions, OKRs (per sub-system)
│   ├── 1-PD/                       ← Problem Diagnosis
│   │   ├── DESIGN.md               ← DSBV Design spec
│   │   ├── SEQUENCE.md             ← DSBV Sequence spec
│   │   ├── VALIDATE.md             ← DSBV Validate report
│   │   ├── pd-charter.md           ← Sub-system charter
│   │   ├── pd-okr-register.md      ← Sub-system OKRs
│   │   └── pd-decision-*.md        ← ADRs
│   ├── 2-DP/                       ← Data Pipeline (same structure)
│   ├── 3-DA/                       ← Data Analysis (same structure)
│   ├── 4-IDM/                      ← Insights & Decision Making (same structure)
│   └── _cross/                     ← Cross-cutting (stakeholders, shared decisions)
│
├── 2-LEARN/                        ← Learning pipeline (NOT DSBV — uses /learn:*)
│   ├── 1-PD/                       ← PD learning artifacts
│   │   ├── input/                  ← Raw learning inputs
│   │   ├── research/               ← Research outputs per topic
│   │   ├── specs/                  ← Structured specifications
│   │   ├── output/                 ← Final learning outputs
│   │   ├── archive/                ← Completed items
│   │   ├── pd-effective-principles.md
│   │   ├── pd-ubs-uds.md
│   │   └── pd-research-spec.md
│   ├── 2-DP/                       ← DP learning (same structure)
│   ├── 3-DA/                       ← DA learning (same structure)
│   ├── 4-IDM/                      ← IDM learning (same structure)
│   └── _cross/                     ← Shared config, scripts, templates
│
├── 3-PLAN/                         ← Architecture, risks, drivers, roadmap
│   ├── 1-PD/                       ← PD planning artifacts
│   │   ├── DESIGN.md
│   │   ├── SEQUENCE.md
│   │   ├── VALIDATE.md
│   │   ├── pd-architecture.md
│   │   ├── pd-roadmap.md
│   │   ├── pd-risk-register.md
│   │   └── pd-driver-register.md
│   ├── 2-DP/                       ← DP planning (same structure)
│   ├── 3-DA/                       ← DA planning (same structure)
│   ├── 4-IDM/                      ← IDM planning (same structure)
│   ├── risks/                      ← Cross-cutting UBS register
│   │   └── UBS_REGISTER.md
│   └── drivers/                    ← Cross-cutting UDS register
│       └── UDS_REGISTER.md
│
├── 4-EXECUTE/                      ← Source, tests, config, docs
│   ├── 1-PD/                       ← PD execution artifacts
│   │   ├── DESIGN.md
│   │   ├── SEQUENCE.md
│   │   ├── VALIDATE.md
│   │   ├── src/                    ← Source code
│   │   ├── tests/                  ← Test suites
│   │   ├── config/                 ← Configuration
│   │   └── docs/                   ← Documentation
│   ├── 2-DP/                       ← DP execution (+ notebooks/)
│   ├── 3-DA/                       ← DA execution (+ notebooks/)
│   └── 4-IDM/                      ← IDM execution
│
├── 5-IMPROVE/                      ← Changelog, metrics, retros, reviews
│   ├── 1-PD/                       ← PD improvement artifacts
│   │   ├── DESIGN.md
│   │   ├── SEQUENCE.md
│   │   ├── VALIDATE.md
│   │   ├── pd-changelog.md
│   │   ├── pd-metrics.md
│   │   └── pd-retro-template.md
│   ├── 2-DP/                       ← DP improvement (same structure)
│   ├── 3-DA/                       ← DA improvement (same structure)
│   ├── 4-IDM/                      ← IDM improvement (same structure)
│   └── _cross/                     ← Cross-cutting improvement
│       ├── cross-metrics-baseline.md
│       ├── cross-feedback-register.md
│       └── cross-version-review.md
│
├── _genesis/                       ← OE-builder: frameworks, templates, SOPs
│   ├── alpei-blueprint.md          ← Philosophy, principles, 80-cell matrix
│   ├── frameworks/                 ← Vinh's 9 canonical frameworks
│   ├── templates/                  ← DSBV and artifact templates (43 files)
│   ├── sops/                       ← This SOP and other operating procedures
│   ├── reference/                  ← Agent designs, ESD, EP registry
│   └── version-registry.md         ← Master version tracking
│
├── PERSONAL-KNOWLEDGE-BASE/        ← PKB (Capture → Distill → Express)
├── DAILY-NOTES/                    ← Daily vault notes
├── inbox/                          ← Quick captures
│
├── .claude/                        ← Agent config (invisible to Obsidian)
│   ├── agents/                     ← 4 agent definition files
│   ├── rules/                      ← 12 always-on rule files
│   ├── skills/                     ← 28 slash command skills
│   ├── hooks/                      ← Hook enforcement scripts
│   └── settings.json               ← Hook registrations (29 hooks)
│
├── scripts/                        ← 49 automation scripts
├── rules/                          ← Full-spec rule files (on-demand)
├── CLAUDE.md                       ← Main agent instructions
└── AGENTS.md                       ← Multi-agent coordination
```

---

## 4. ALPEI FRAMEWORK OVERVIEW

### Three Structural Layers

```
Layer 1: WORKSTREAMS (vertical — what the PM produces)
  ALIGN → LEARN → PLAN → EXECUTE → IMPROVE

Layer 2: SUB-SYSTEMS (horizontal — domain decomposition)
  PD → DP → DA → IDM

Layer 3: DSBV STAGES (process — how each artifact is produced)
  Design → Sequence → Build → Validate
```

**5 x 4 x 4 = 80 cells** in the full matrix. Not all cells are active in every iteration.

### Workstreams

| # | Workstream | Directory | Primary Role | Key Outputs |
|---|-----------|-----------|--------------|-------------|
| 1 | **ALIGN** | `1-ALIGN/` | Choose the right outcome | Charter, decisions (ADRs), OKRs, stakeholder map |
| 2 | **LEARN** | `2-LEARN/` | Find truths, analyze forces | Research reports, specs, learning pages |
| 3 | **PLAN** | `3-PLAN/` | Design architecture, sequence work | Architecture docs, UBS/UDS registers, roadmap |
| 4 | **EXECUTE** | `4-EXECUTE/` | Build and deliver | Source code, tests, config, documentation |
| 5 | **IMPROVE** | `5-IMPROVE/` | Collect feedback, iterate | Changelog, metrics, retrospectives, reviews |

**Chain-of-custody:** Workstream N cannot start DSBV Build until N-1 has at least 1 validated artifact. Enforced by `scripts/dsbv-gate.sh`.

**LEARN exception:** 2-LEARN uses a 6-state pipeline (S1-S5 + Complete), NOT DSBV. DSBV files (`DESIGN.md`, `SEQUENCE.md`, `VALIDATE.md`) MUST NEVER exist in `2-LEARN/`.

### Sub-Systems

| Order | Sub-System | Code | Primary Output |
|-------|-----------|------|----------------|
| 1 | Problem Diagnosis | `1-PD` | Effective Principles for the entire UES |
| 2 | Data Pipeline | `2-DP` | Processed data ready for analysis |
| 3 | Data Analysis | `3-DA` | Analyzed insights extracted from data |
| 4 | Insights & Decision Making | `4-IDM` | Actionable decisions with risk management |

**PD governs all:** PD's Effective Principles always take precedence over downstream sub-systems. Downstream sub-systems cannot exceed upstream UES version.

### DSBV Stages

| Stage        | Purpose                                              | Agent                | Gate                       |
| ------------ | ---------------------------------------------------- | -------------------- | -------------------------- |
| **Design**   | Define WHAT and WHY, set acceptance criteria         | ltc-planner (Opus)   | Human approves DESIGN.md   |
| **Sequence** | Define HOW: Order work, size tasks, map dependencies | ltc-planner (Opus)   | Human approves SEQUENCE.md |
| **Build**    | Produce all the artifact(s) set by Design            | ltc-builder (Sonnet) | Human reviews output       |
| **Validate** | Verify against VANA criteria                         | ltc-reviewer (Opus)  | Human approves VALIDATE.md |

**No stage is skipped. Each gate requires explicit human approval.**

---

## 5. SLASH COMMAND SYSTEM

### DSBV Commands (Primary)

| Command | Purpose | Example |
|---------|---------|---------|
| `/dsbv` | Start guided DSBV cycle | `/dsbv` (interactive) |
| `/dsbv design [ws] [sub]` | Run Design stage | `/dsbv design align pd` |
| `/dsbv sequence [ws] [sub]` | Run Sequence stage | `/dsbv sequence plan pd` |
| `/dsbv build [ws] [sub]` | Run Build stage | `/dsbv build execute dp` |
| `/dsbv validate [ws] [sub]` | Run Validate stage | `/dsbv validate align pd` |
| `/dsbv status` | Show progress across all workstreams | `/dsbv status` |

### Learning Pipeline Commands

| Command | Purpose | Stage |
|---------|---------|-------|
| `/learn` | Orchestrate full learning pipeline | All stages |
| `/learn:input` | Interview to capture learning need | S1: Input |
| `/learn:research` | Parallel research pipeline | S2: Research |
| `/learn:structure` | Generate effective learning page | S3: Structure |
| `/learn:spec` | VANA-SPEC + readiness package | S4: Spec |
| `/learn:review` | Per-topic review gate | S5: Review |
| `/learn:visualize` | Interactive system map | Visualization |

### Knowledge and Vault Commands

| Command | Purpose | Target |
|---------|---------|--------|
| `/ingest` | Ingest to Personal Knowledge Base | `PERSONAL-KNOWLEDGE-BASE/` |
| `/vault-capture` | Quick capture to vault inbox | `inbox/` |
| `/obsidian` | Obsidian CLI integration (search, backlinks, orphans) | Vault-wide |

### Session Lifecycle Commands

| Command | Purpose |
|---------|---------|
| `/compress` | Save session context before compaction |
| `/resume` | Load prior session context |

### Workspace and Governance Commands

| Command                 | Purpose                                          |
| ----------------------- | ------------------------------------------------ |
| `/setup`                | One-time harness onboarding                      |
| `/git-save`             | Guided commit workflow (classify, stage, commit) |
| `/template-check`       | Compare local vs template remote                 |
| `/template-sync`        | Pull updates from template remote                |
| `/ltc-clickup-planner`  | ClickUp work planner                             |
| `/ltc-feedback`         | Report issues via 7-CS force analysis            |
| `/ltc-rules-compliance` | Validate skill compliance                        |
| `/deep-research`        | Deep web research                                |
| `/ltc-brainstorming`    | Brainstorming with explorer + planner            |

### Command Matrix — Workstream x DSBV Stage

| Workstream | Design | Sequence | Build | Validate |
|-----------|--------|----------|-------|----------|
| **ALIGN** | `/dsbv design align [sub]` | `/dsbv sequence align [sub]` | `/dsbv build align [sub]` | `/dsbv validate align [sub]` |
| **LEARN** | `/learn:input` | `/learn:research` | `/learn:structure` + `/learn:spec` | `/learn:review` |
| **PLAN** | `/dsbv design plan [sub]` | `/dsbv sequence plan [sub]` | `/dsbv build plan [sub]` | `/dsbv validate plan [sub]` |
| **EXECUTE** | `/dsbv design execute [sub]` | `/dsbv sequence execute [sub]` | `/dsbv build execute [sub]` | `/dsbv validate execute [sub]` |
| **IMPROVE** | `/dsbv design improve [sub]` | `/dsbv sequence improve [sub]` | `/dsbv build improve [sub]` | `/dsbv validate improve [sub]` |

**Sub-system values:** `pd` | `dp` | `da` | `idm` | `cross`

---

## 6. SECURITY AND GOVERNANCE

### Foundational Principle

**Security is more important than quality of work.** Clients may forgive subpar analysis. They will not forgive a data breach.

### 3-Layer Defense-in-Depth

| Layer | Mechanism | Catches |
|-------|-----------|---------|
| **Layer 1: Structural** | `.gitignore` + file conventions | `.env`, `secrets/`, `.backup/`, private keys by extension |
| **Layer 2: Agent EP** | CLAUDE.md + `.claude/rules/` (always-loaded) | Secrets in prompts/output, PII, classification violations |
| **Layer 3: Pre-Commit** | `gitleaks` hook | API keys, private keys, tokens, JWTs, connection strings |

### Risk Classification

| Risk Level | Examples | Protocol |
|------------|----------|----------|
| **LOW** | Read, search, lint, test | Proceed |
| **MEDIUM** | Edit, commit, install | Proceed, user reviews |
| **HIGH** | Delete, push, force ops, deploy, .env/secrets/ | ALWAYS require explicit human confirmation |

### Data Classification

| Level | Examples | Handling |
|-------|----------|---------|
| **Public** | Open-source code, published frameworks | No restrictions |
| **Internal** | Project artifacts, learning outputs | Repo-scoped, no external sharing |
| **Confidential** | API keys, credentials, PII | `.env`/`secrets/` only, never in source |
| **Restricted** | Client data, financial records | Never in repo, external vault only |

### Audit Trail

Every workstream artifact has YAML frontmatter tracking `version`, `status`, `last_updated`. The version registry (`_genesis/version-registry.md`) provides a single-pane view of all artifact states. Git history provides full commit-level audit trail.

### Agent Security

- Agents NEVER hardcode secrets in source, prompts, or tool arguments
- Agents ALWAYS scan output for secret patterns before completing any task
- The `/obsidian` skill NEVER runs `obsidian eval` or `obsidian dev:console` (CVE Feb 2026)
- Sub-agents NEVER dispatch other sub-agents (EP-13: orchestrator authority)

---

## 7. GLOBAL AGENT RULES

These 10 rules are enforced across every session. They are auto-loaded via `.claude/rules/` (always-on).

### Rule 1: RACI Enforcement

Agent = Responsible + Consulted. PM = Accountable + Informed. Agent NEVER self-approves. Only Human sets `status: validated`.

**Enforcement:** `scripts/status-guard.sh` (pre-commit hook)

### Rule 2: Pre-Flight Protocol

Before starting any workstream task, run the 9-check pre-flight.

| Check | What It Verifies |
|-------|-----------------|
| C1: Workstream | Target directory exists |
| C2: Alignment | alpei-blueprint.md + charter present |
| C3: Risks | UBS Register present |
| C4: Drivers | UDS Register present |
| C5: Templates | DSBV process map has routing for this workstream |
| C6: Learning | 2-LEARN has content |
| C7: Version | Version registry exists |
| C8: Execute | DESIGN.md exists (required before Build) |
| C9: Document | Decisions directory exists |

**Command:** `./scripts/pre-flight.sh <workstream>` (e.g., `./scripts/pre-flight.sh 1-ALIGN`)

**Enforcement:** `scripts/pre-flight.sh` (manual) + DSBV skill runs it automatically

### Rule 3: Three Pillars (S > E > Sc)

Every prioritization decision follows Sustainability > Efficiency > Scalability. This is not a preference — it is derived from UT#5.

**Enforcement:** Documentation (CLAUDE.md, alpei-blueprint.md)

### Rule 4: Chain-of-Custody

Workstream N cannot start DSBV Build until N-1 has at least 1 validated artifact. Sub-system sequence: PD → DP → DA → IDM. Downstream cannot exceed upstream version.

**Enforcement:** `scripts/dsbv-gate.sh` (PreToolUse hook + pre-commit)

### Rule 5: VANA Handoff Verification

Every deliverable has success criteria expressed in VANA grammar (Verb, Adverb, Noun, Adjective). Without VANA criteria, AI agents self-audit as "everything looks correct" (LT-5).

**Source of Truth:** The per-subsystem VANA-SPEC (`2-LEARN/_cross/specs/{slug}/vana-spec.md`), produced by `/learn:spec`. The VANA-SPEC §9 (Iteration Plan) maps every AC to its target iteration.

**Iteration Scoping:** Each VANA-SPEC AC belongs to exactly one iteration based on its pillar:

| Pillar | Target Iteration | Rationale |
|--------|-----------------|-----------|
| Sustainability | Iteration 1 (Concept) | Correct + safe first |
| Efficiency | Iteration 2 (Prototype) | Optimize second |
| Scalability | Iteration 3-4 (MVE/Leadership) | Scale last |

The PM filters VANA-SPEC §9 by `Target_Iteration` to determine which ACs are in scope for the current iteration's PLAN and EXECUTE DESIGN.md files.

**Handoff Verification Checkpoints:**

| Checkpoint | When | Verification | Owner |
|------------|------|-------------|-------|
| CP-1 | PLAN Design (G1) | Every VANA-SPEC AC for the current iteration has a `VANA_Ref` row in `3-PLAN/{sub}/DESIGN.md` | PM |
| CP-2 | EXECUTE Design (G1) | Every VANA-SPEC AC for the current iteration has a `VANA_Ref` row in `4-EXECUTE/{sub}/DESIGN.md` | PM |
| CP-3 | EXECUTE Validate (G4) | `gate-precheck.sh` verifies VANA coverage (Iteration 2+ automation) | Script / PM |

CP-1 and CP-2 are manual checklist items at the G1 gate. The PM compares VANA-SPEC §9 (filtered to current iteration) against DESIGN.md `VANA_Ref` column. Missing AC = G1 blocker.

CP-3 is manual in Iteration 1. In Iteration 2+, `gate-precheck.sh` automates the coverage check.

**Enforcement:** `scripts/gate-precheck.sh` (DSBV skill) + manual checklist at G1

### Rule 6: Template-First

Before creating any workstream deliverable, check `_genesis/templates/` for an existing template. Never create a blank artifact when one exists.

**Enforcement:** Documentation (`.claude/rules/alpei-template-usage.md`)

### Rule 7: Frontmatter Required

Every `.md` workstream artifact MUST have YAML frontmatter: `version`, `status`, `last_updated`. Shell/Python use comment headers. All values lowercase except `work_stream` (numbered SCREAMING: `1-ALIGN`).

**Enforcement:** `scripts/validate-blueprint.py` (pre-commit) + `.claude/rules/versioning.md`

### Rule 8: Universal Naming Grammar

`{SCOPE}_{FA}.{ID}.{NAME}`. Separators: `_` = scope boundary, `.` = numeric level, `-` = word join. SCOPE codes are irregular — never derive algorithmically.

**Enforcement:** Documentation (`.claude/rules/naming-rules.md`) + PreToolUse hooks

### Rule 9: No Untracked Work

Every decision must be documented in the relevant sub-system's decisions directory (e.g., `1-ALIGN/1-PD/` for PD decisions, `1-ALIGN/_cross/` for cross-cutting decisions). No chat-only decisions. Every artifact must be categorized by sub-system x workstream.

**Enforcement:** Pre-flight C9 check + DSBV skill + subsystem routing in `/dsbv`

### Rule 10: Brand Identity

All visual output MUST use LTC brand: Midnight Green (#004851), Gold (#F2C75C), Inter font. Load `rules/brand-identity.md` before generating any visual artifact.

**Enforcement:** Documentation (`rules/brand-identity.md`)

---

## 8. MULTI-PLATFORM AGENT CONFIG

### Config Hierarchy

```
Tier 1 (strongest): Hooks (.claude/settings.json)
  → 29 hooks across 7 event types
  → Fires automatically — agent cannot bypass

Tier 2: Scripts (scripts/)
  → 49 scripts: validation, gates, lifecycle, audit
  → Called by hooks or manually

Tier 3: Rules (.claude/rules/)
  → 12 always-on rule files — auto-loaded every session
  → Agent reads and follows

Tier 4 (weakest): Skills (.claude/skills/)
  → 28 slash commands — loaded on demand via /commands
  → Agent executes when invoked
```

### What Goes Where

| Content | Location | Loaded When |
|---------|----------|-------------|
| Project instructions | `CLAUDE.md` (root) | Every session (auto) |
| Always-on rules (summaries) | `.claude/rules/*.md` | Every session (auto) |
| Full-spec rules | `rules/*.md` | On demand (agent reads when needed) |
| Slash commands | `.claude/skills/*/SKILL.md` | When user invokes `/command` |
| Agent definitions | `.claude/agents/*.md` | When dispatched as sub-agent |
| Hook scripts | `.claude/hooks/` | On hook event trigger |
| Automation scripts | `scripts/` | Called by hooks, skills, or manually |
| Hook registrations | `.claude/settings.json` | Session initialization |

### Hook Event Types

| Event | Count | Purpose |
|-------|-------|---------|
| `SessionStart` | 3 | Load env context, warm cache, audit config |
| `PreToolUse` | 13 | Block forbidden patterns, enforce naming, DSBV gates |
| `PostToolUse` | 6 | Log, validate output, trigger follow-on checks |
| `SubagentStop` | 2 | Audit sub-agent output, verify chain-of-custody |
| `PreCompact` | 1 | Save state to vault before context compression |
| `Stop` | 3 | Summary, PKB ingest reminder, state save |
| `UserPromptSubmit` | 1 | Auto-recall injection from QMD knowledge base |

---

## 9. AGENT TEAM PATTERNS

### The 4 Agents

| Agent | File | Model | Scope | When Used |
|-------|------|-------|-------|-----------|
| **ltc-explorer** | `.claude/agents/ltc-explorer.md` | Haiku | Pre-DSBV research, discovery, read-only exploration | Before Design — codebase scan, prior art, web research |
| **ltc-planner** | `.claude/agents/ltc-planner.md` | Opus | DSBV Design + Sequence, synthesis, orchestration advice | Design and Sequence stages — architecture, trade-offs |
| **ltc-builder** | `.claude/agents/ltc-builder.md` | Sonnet | DSBV Build — artifact production, code, docs | Build stage — produce artifacts from approved sequence |
| **ltc-reviewer** | `.claude/agents/ltc-reviewer.md` | Opus | DSBV Validate — review against DESIGN.md criteria | Validate stage — evidence-based review against ACs |

### Coordination Protocol

```
Human Director
  │
  ▼
Main Session (Orchestrator)
  │
  ├──→ ltc-explorer (Haiku)    ← research stage
  │       │
  │       ▼ findings
  │
  ├──→ ltc-planner (Opus)      ← Design + Sequence
  │       │
  │       ▼ DESIGN.md, SEQUENCE.md
  │
  ├──→ ltc-builder (Sonnet)    ← Build
  │       │
  │       ▼ artifacts
  │
  └──→ ltc-reviewer (Opus)     ← Validate
          │
          ▼ VALIDATE.md (PASS/FAIL)
              │
              └──→ FAIL items → ltc-builder (retry, max 3 iterations)
```

**EP-13: Orchestrator Authority.** ONLY the main session (orchestrator) calls `Agent()`. Sub-agents NEVER dispatch other sub-agents. This is enforced by agent file scope boundaries.

### Context Packaging (5 Fields)

Every sub-agent dispatch uses this template:

| Field | Purpose |
|-------|---------|
| **EO** | What done looks like — desired end state |
| **INPUT** | Context the agent needs + files to read |
| **EP** | Which principles constrain this task |
| **OUTPUT** | Delivery format + acceptance criteria |
| **VERIFY** | How the agent self-checks before returning |

Full template: `.claude/skills/dsbv/references/context-packaging.md`

### Team Compositions by Workstream Type

| Workstream Type | Pattern | Agents Used |
|----------------|---------|-------------|
| **Design-heavy** (ALIGN, PLAN) | Competing Hypotheses + Synthesis | 3-5 ltc-builder (Sonnet) in parallel → ltc-planner (Opus) synthesizes |
| **Execution-heavy** (EXECUTE, IMPROVE) | Sequential Pipeline | ltc-builder (Sonnet) single agent, sequential task completion |
| **Research** (LEARN) | Parallel Research | ltc-explorer (Haiku) for discovery → main session structures |
| **Review** (any) | Generator/Critic | ltc-reviewer (Opus) validates → FAIL items → ltc-builder (Sonnet) fixes → max 3 iterations |

### Generator/Critic Loop Parameters

| Parameter | Value |
|-----------|-------|
| `max_iterations` | 3 (builder + reviewer = 1 iteration) |
| `exit_condition` | All criteria PASS in VALIDATE.md |
| `cost_cap` | ~$0.06 per iteration |
| `escalation` | Same FAIL persists 2 iterations → escalate to Human Director |

---

## 10. DAILY OPERATIONS QUICK REFERENCE

### Starting a New Session

```
1. /resume                          ← Load prior session context
2. /dsbv status                     ← Check workstream progress
3. Pre-flight checks run automatically when you invoke /dsbv. For manual diagnosis: ./scripts/pre-flight.sh <ws>
4. Proceed with current DSBV stage
```

### Completing a Task

```
1. Agent produces artifact
2. Agent self-checks against ACs
3. /git-save                        ← Guided commit workflow
4. If workstream artifact: update _genesis/version-registry.md
```

### Ending a Session

```
1. /compress                        ← Save session context
2. /vault-capture                   ← Capture any loose notes
3. Hooks auto-fire: PKB ingest reminder, state save
```

### Version Numbering

| Situation | Version |
|-----------|---------|
| New file in Iteration 0 (Logic Scaffold) | `0.0` — design and scope only, no building |
| New file in Iteration 1 (Concept) | `1.0` |
| Edit to committed file at 1.3 | `1.4` |
| Uncommitted rewrite | Same version (never committed at prior number) |
| Whitespace/typo only | No bump |
| New iteration (Iteration 2) | `2.0` |

> **Iteration 0 = Logic Scaffold.** PMs building investment sub-systems (PD→DP→DA→IDM) may start from Iteration 0 to scope and design before any building. Version `0.x` is valid for Logic Scaffold artifacts. No code, no building — only mapping, diagrams, and documentation.

### Status Lifecycle

```
draft ──→ in-progress ──→ in-review ──→ validated ──→ archived
  ↑                            ↑            ↑
Agent                        Agent       HUMAN ONLY
creates                    requests
& edits                     review
```

### Branching

```
Branch FROM main: git checkout main && git pull origin main
Branch naming:    I{N}/{type}/{short-name}
Examples:         I1/feat/obsidian-cli, I1/fix/workstream-rename
Merge:            Squash merge via PR → delete branch
```

### Commit Format

```
type(scope): short description        ← 72 chars max, imperative mood

Types:  feat | fix | refactor | docs | chore | test | cleanup
Scopes: govern | align | learn | plan | execute | improve | genesis | skills | rules
```

---

## APPENDIX A: WORKSPACE SETUP

> For full setup and migration guides, see `_genesis/sops/`. This appendix covers the essential first-time setup steps.

### Prerequisites

| Requirement | Version / Notes |
|-------------|----------------|
| macOS or Linux | Bash 3+ (macOS default) |
| Git | 2.x+ |
| Claude Code | Latest CLI |
| Obsidian | With Bases, Templater, Dataview plugins |
| Node.js | 18+ (for template-check) |
| Python | 3.10+ (for validation scripts) |
| GitHub CLI (`gh`) | For PR workflows |

### First-Time Setup

```
Step 1: Clone the template
  $ git clone <template-repo-url> OPS_OE.X.X.YOUR-PROJECT-NAME
  $ cd OPS_OE.X.X.YOUR-PROJECT-NAME

Step 2: Run the setup skill
  /setup
  → Creates 10 Obsidian vault folders + .gitkeep files
  → Runs smoke-test.sh (5 checks)
  → Verifies memory-vault hook system

Step 3: Verify agent files exist
  $ ls .claude/agents/
  → Expected: ltc-builder.md  ltc-explorer.md  ltc-planner.md  ltc-reviewer.md

Step 4: Verify hooks are registered
  $ cat .claude/settings.json | grep -c '"hooks"'
  → Expected: non-zero (29 hooks total across 7 event types)

Step 5: Run pre-flight on ALIGN
  /dsbv status
  → Shows workstream x sub-system progress grid

Step 6: Open Obsidian vault
  → Open the repo root as an Obsidian vault
  → Bases dashboards auto-load from _genesis/templates/obsidian/

Step 7: Create your first branch
  $ git checkout -b I0/feat/initial-align
  → Never commit directly to main
```

---

## Links

- [[BLUEPRINT]]
- [[CLAUDE]]
- [[DESIGN]]
- [[SEQUENCE]]
- [[VALIDATE]]
- [[agent-dispatch]]
- [[agent-system]]
- [[alpei-chain-of-custody]]
- [[alpei-dsbv-process-map]]
- [[alpei-template-usage]]
- [[dsbv-process]]
- [[enforcement-layers]]
- [[filesystem-routing]]
- [[git-conventions]]
- [[git-workflow]]
- [[ltc-builder]]
- [[ltc-explorer]]
- [[ltc-planner]]
- [[ltc-reviewer]]
- [[multi-agent-setup-guide]]
- [[naming-rules]]
- [[script-registry]]
- [[security-rules]]
- [[versioning]]
- [[workstream]]
