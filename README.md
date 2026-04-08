---
version: "1.0"
status: draft
last_updated: 2026-04-07
iteration: 1
type: template
---

# LTC Project Template — Iteration 2 (Prototype)

> "A project without structure is a project without memory. A project without memory repeats every mistake."

Standard project scaffold for LT Capital Partners. Clone this to start any new project with the ALPEI workstream structure, 4-subsystem horizontal layer, Obsidian Bases dashboards, and AI agent configuration pre-loaded.

## What Changed from I1 to I2

| Dimension | I1 (Concept) | I2 (Prototype) |
|-----------|-------------|----------------|
| **Focus** | Sustainability — human adoption first | **Sustainability × Efficiency** — manage workflows sustainably AND efficiently |
| **Structure** | 5 flat workstream dirs | 5 workstreams × 4 subsystems (PD → DP → DA → IDM) + `_cross` |
| **Dashboards** | None | Obsidian Bases — filterable views of every artifact by workstream, status, iteration |
| **Knowledge capture** | Manual | Personal Knowledge Base (PKB) — `/ingest` pipeline + `/vault-capture` for books, articles, conversations |
| **Filesystem** | Category-based (`charter/`, `risks/`) | Subsystem-based (`1-PD/`, `2-DP/`) with routing rules |
| **Agent config** | 3 rules, basic skills | 12 always-on rules, 30+ skills, 4 MECE agents, event-driven hooks |
| **Learning pipeline** | 7 learn skills | Same skills + per-subsystem pipeline dirs (`input/research/specs/output/archive`) |

**Core equation:** Success = Efficient & Scalable Management of Failure Risks

Sustainability (S) ensures the system doesn't break. Efficiency (E) ensures output is maximized within safe boundaries. I2 delivers both — I1 delivered only S.

## Your Starting Point: Brainstorming

Before DSBV, before workstreams, before any production work — start with `/ltc-brainstorming`.

```
/ltc-brainstorming
```

This skill is your **thinking companion**. It doesn't generate artifacts or start workflows. It helps you explore unknown territory through structured dialogue:

1. **Explores context** — reads your project files, recent commits, existing decisions
2. **Asks one question at a time** — multiple choice when possible, never overwhelming
3. **Identifies risks before features** — UBS (what blocks?) before UDS (what drives?)
4. **Proposes 2-3 approaches** — with S > E > Sc trade-off analysis
5. **Presents a design for your approval** — no implementation until you say go
6. **Transitions to `/dsbv`** — when you're ready to produce artifacts

Use it when you're thinking out loud: *"I'm thinking about..."*, *"What if we..."*, *"How should I approach..."*. The brainstorming skill catches the #1 failure mode in project work: jumping to implementation before understanding the problem.

## Must-Read Before Starting

| # | Resource | How to access | Time |
|---|----------|---------------|------|
| 1 | **Training Deck** (47 slides) | `cd _genesis/training/alpei-training-slides && npm install && npm run dev` → open `http://localhost:5173` | 30 min |
| 2 | **ALPEI Navigator** (interactive map) | Open `_genesis/tools/alpei-navigator.html` in any browser (no install needed) | 10 min |
| 3 | **Migration Guide** (I1 → I2) | Read `_genesis/guides/migration-guide.md` — or tell your agent: *"Read the migration guide and execute it for my project"* | 15 min |

## Quick Start

### 1. Create your project from this template

**On GitHub:** Click the green **"Use this template"** button at the top of this repo. Choose the owner, name your project using [LTC naming convention](#naming-convention), and click "Create repository."

**From CLI:**
```bash
gh repo create Long-Term-Capital-Partners/{YOUR_PROJECT_NAME} \
  --template Long-Term-Capital-Partners/OPS_OE.6.4.LTC-PROJECT-TEMPLATE
```

### 2. Clone and configure

```bash
git clone https://github.com/Long-Term-Capital-Partners/{YOUR_PROJECT_NAME}.git
cd {YOUR_PROJECT_NAME}
```

### 3. Customize these files (in this order)

| Step | File | What to do |
|------|------|------------|
| 1 | `.claude/settings.json` | Review deny/allow rules. Add project-specific permissions. This is your safety net — configure it first. |
| 2 | `.gitignore` | Add any project-specific exclusions (credentials, data files, etc.) |
| 3 | `CLAUDE.md` | Replace all `{placeholders}` with your project details. Keep under 100 lines. |
| 4 | `GEMINI.md` | Replace all `{placeholders}` — same structure as CLAUDE.md but for AntiGravity. Keep in sync. |
| 4b | `codex.md` | Replace project details — same pattern as GEMINI.md but for OpenAI Codex. |
| 4c | `AGENTS.md` | Review the cross-agent roster. Update if you add custom agents or change model assignments. |
| 5 | `.mcp.json` | Add MCP server connections if your project uses external tools. |
| 6 | `.claude/rules/` | Always-on rules are pre-loaded. Add path-scoped rules for your codebase. |
| 7 | `.claude/skills/` | Add project-specific skills (on-demand procedures). |
| — | `.cursor/rules/`, `.agents/rules/` | Already configured with brand identity. Add more rules as needed for Cursor / AntiGravity. |

### 4. Start working

```bash
claude   # Opens Claude Code with CLAUDE.md auto-loaded
```

Or open the project in AntiGravity / Cursor — each IDE loads its own rules automatically.

### 5. Explore before you build

Don't start with DSBV. Start with brainstorming:

```
/ltc-brainstorming                     Think through your project idea
/ltc-brainstorming "market analysis"   Explore a specific domain
```

Once you have clarity, the brainstorming skill transitions you to `/dsbv` to begin production.

### 6. Produce with DSBV

Every workstream (ALIGN → PLAN → EXECUTE → IMPROVE) uses **DSBV** — Design, Sequence, Build, Validate:

```
/dsbv                    Start a guided DSBV cycle on any workstream
/dsbv design align       Run just the Design phase on the ALIGN workstream
/dsbv status             See current progress across all workstreams
```

DSBV guides you step by step: define what the workstream must produce (Design), order the work (Sequence), execute it (Build), and verify quality (Validate). Each phase has a human gate — you review and approve before proceeding.

Start with ALIGN: `/dsbv design align` — it will ask you to describe your project's purpose in 1-3 sentences, then draft the specification for your review.

### 7. Research before you plan

The **learning pipeline** helps you understand a domain before committing to decisions. LEARN is the PM's primary contribution point — where human knowledge enters the system:

```
/learn "What is X and how does it apply to our project?"
```

This runs a 6-state pipeline: scope → research → structure → review → spec → complete. Each subsystem (PD, DP, DA, IDM) gets its own pipeline dirs (`input/`, `research/`, `specs/`, `output/`, `archive/`).

The critical output: **Effective Principles** (S-Principles for safety, E-Principles for efficiency) derived from UBS/UDS analysis. These govern every downstream decision.

| Skill | What it does |
|-------|-------------|
| `/learn` | Orchestrates the full pipeline end-to-end |
| `/learn:input` | Scopes what to research |
| `/learn:research` | Deep research with sources |
| `/learn:structure` | Organizes into structured pages (P0-P7) |
| `/learn:review` | You approve the research |
| `/learn:spec` | Derives Effective Principles from UBS/UDS |

### 8. Capture knowledge as you go

I2 adds a **Personal Knowledge Base (PKB)** for capturing insights from any source:

```
/vault-capture "key insight from today's meeting"    Quick capture → Obsidian inbox
/ingest path/to/article.pdf                          Full pipeline: extract → embed → index
```

Books, articles, courses, conversations — everything lands in the Obsidian vault where it's searchable, linkable, and feeds into your LEARN pipeline.

### Already have an I1 project? Migrate to I2

If your project was cloned from the I1 scaffold and needs the subsystem structure, see:

```
_genesis/guides/migration-guide.md
```

Your AI agent can execute it: *"Read `_genesis/guides/migration-guide.md` and execute it for my project."*

## The PM's Daily Workflow (S × E)

```
Morning                           During work                     End of day
───────                           ───────────                     ──────────
/resume                           /ltc-brainstorming              /session-end
  ↓ load context                    ↓ explore ideas                 ↓ auto-save summary
Obsidian daily note               /learn → /dsbv → produce        /compress if needed
  ↓ check dashboards               ↓ research → produce            ↓ session log → vault
Notion/ClickUp tasks              /vault-capture insights
  ↓ prioritize                      ↓ capture as you go
```

**Why S × E matters:** Sustainability (S) means this workflow doesn't burn you out — session management, auto-saves, and crash recovery protect your work. Efficiency (E) means the tools amplify your output — Obsidian Bases give you instant dashboards, PKB makes knowledge searchable, brainstorming catches bad assumptions early.

## I2 Feature: Obsidian Bases Dashboards

Every workstream and subsystem is tagged with frontmatter (`work_stream`, `sub_system`, `status`, `iteration`). Obsidian Bases reads these tags to generate live, filterable views:

```
![[08-alignment-overview.base]]     ← Shows all ALIGN artifacts by status
![[09-learning-overview.base]]     ← Shows learning pipeline progress
![[11-execution-overview.base]] ← Shows delivery status across subsystems
```

No manual status tracking. Write your artifacts with proper frontmatter → dashboards update automatically.

## I2 Feature: 4-Subsystem Horizontal Layer

Every workstream is organized by subsystem, not by artifact category:

```
{N}-{WORKSTREAM}/
├── 1-PD/          Problem Diagnosis — what's the problem?
├── 2-DP/          Data Pipeline — what inputs do we need?
├── 3-DA/          Data Analysis — what logic transforms inputs?
├── 4-IDM/         Insights & Decision Making — how do outputs reach users?
└── _cross/        Cross-cutting artifacts spanning all subsystems
```

**PD governs all downstream.** Its effective principles constrain DP, DA, and IDM. No downstream subsystem may contradict PD's scope.

## What's Included

```
.
├── CLAUDE.md                        # Claude Code rules (always-loaded)
├── GEMINI.md                        # AntiGravity rules (always-loaded)
├── AGENTS.md                        # Cross-agent roster (all IDEs read this)
├── codex.md                         # OpenAI Codex rules
├── VERSION                          # Template version (distribution tracking)
│
├── .cursor/
│   └── rules/                       # 6 Cursor IDE rules (brand, security, agent system)
├── .agents/
│   ├── rules/                       # 6 AntiGravity rules (matches .cursor/rules/)
│   └── skills/                      # AntiGravity skills (future)
├── .claude/
│   ├── settings.json                # Safety deny/allow (hard ceilings)
│   ├── agents/                      # 4 MECE agents: planner, builder, reviewer, explorer
│   ├── hooks/                       # Event-driven automation (5 hooks)
│   ├── rules/                       # 12 always-on rules (versioning, naming, DSBV, etc.)
│   └── skills/                      # 30+ skills across 15 categories
│
├── _genesis/                        # Org knowledge base (read-only for projects)
│   ├── philosophy/                  #   WHY we do things
│   ├── principles/                  #   WHAT we commit to
│   ├── frameworks/                  #   HOW we model systems (11 frameworks)
│   ├── brand/                       #   Visual identity (colors, typography, logo)
│   ├── security/                    #   Data classification, naming, hierarchy
│   ├── sops/                        #   Standard operating procedures
│   ├── templates/                   #   20+ templates (DSBV, VANA-SPEC, ADR, research, README)
│   ├── reference/                   #   User guide, handbook, ALPEI PDFs, EOP governance
│   └── obsidian/                    #   Vault structure, theme, Bases config
│
├── 1-ALIGN/                         # Choose the Right Outcome
│   ├── 1-PD/ 2-DP/ 3-DA/ 4-IDM/   #   Subsystem-scoped: charter, OKRs, decisions
│   ├── decisions/                   #   Architecture Decision Records (ADRs)
│   └── _cross/                      #   Cross-cutting alignment artifacts
│
├── 2-LEARN/                         # Understand Before You Act
│   ├── 1-PD/ 2-DP/ 3-DA/ 4-IDM/   #   Each with pipeline: input/research/specs/output/archive
│   └── _cross/                      #   Cross-cutting learning (shared frameworks, UES design)
│
├── 3-PLAN/                          # Minimize Failure Risks
│   ├── 1-PD/ 2-DP/ 3-DA/ 4-IDM/   #   Architecture, UBS register, UDS register, roadmap
│   └── _cross/                      #   Cross-cutting risks and drivers
│
├── 4-EXECUTE/                       # Deliver with Effective Process
│   └── 1-PD/ 2-DP/ 3-DA/ 4-IDM/   #   src, tests, config, docs, notebooks (DP/DA)
│
├── 5-IMPROVE/                       # Learn, Reflect, Institutionalize
│   ├── 1-PD/ 2-DP/ 3-DA/ 4-IDM/   #   Changelog, metrics, retros, reviews
│   └── _cross/                      #   Cross-cutting improvement routing
│
├── rules/                           # LTC global rules (full specs)
│   ├── brand-identity.md            #   20-color palette, typography, logo usage
│   ├── naming-rules.md              #   UNG: 75 SCOPE codes, platform rendering
│   ├── security-rules.md            #   3-layer defense-in-depth
│   ├── agent-system.md              #   8 LLM Truths + 7-Component System
│   ├── agent-diagnostic.md          #   6-component trace methodology
│   └── general-system.md            #   Universal 8-component model + RACI + VANA
│
├── scripts/                         # Validation and generation scripts
└── PEOPLE/                          # Team member profiles and RACI assignments
```

## Skills (30+ total)

All skills live in `.claude/skills/` and are invoked with `/skill-name`.

| Category | Skills | Purpose |
|----------|--------|---------|
| **Process** | `/ltc-brainstorming`, `/ltc-task-executor` | Thinking companion + structured execution |
| **DSBV** | `/dsbv` | Workstream production — Design, Sequence, Build, Validate |
| **Learning** | `/learn`, `/learn:input`, `/learn:research`, `/learn:structure`, `/learn:review`, `/learn:spec` | 6-state research pipeline — from question to Effective Principles |
| **Knowledge** | `/ingest`, `/vault-capture` | Personal Knowledge Base — capture from any source |
| **Obsidian** | `/obsidian` | Vault search, navigation, Bases queries |
| **Session** | `/session-start`, `/session-end`, `/compress`, `/resume`, `/setup` | Session lifecycle management |
| **Git** | `/git-save` | Guided commit workflow with classification |
| **WMS** | `/ltc-clickup-planner`, `/ltc-notion-planner` | Work management system integration |
| **Quality** | `/feedback` | Capture friction reports → GitHub Issues |
| **Research** | `/deep-research`, `/root-cause-tracing` | Deep investigation and debugging |
| **Compliance** | `/ltc-brand-identity`, `/ltc-naming-rules`, `/ltc-rules-compliance` | Apply and verify LTC standards |
| **Governance** | `/ltc-skill-creator` | Create new EOP-governed skills |
| **Sync** | `/template-check`, `/template-sync` | Keep project in sync with template updates |

## Agent System

4 MECE agents handle all delegated work:

| Agent | Model | Scope |
|-------|-------|-------|
| `ltc-planner` | Opus | DSBV Design + Sequence, synthesis, orchestration |
| `ltc-builder` | Sonnet | DSBV Build — artifact production, code, docs |
| `ltc-reviewer` | Opus | DSBV Validate — review against DESIGN.md criteria |
| `ltc-explorer` | Haiku | Pre-DSBV research, discovery, read-only exploration |

Agent files: `.claude/agents/` | Dispatch rules: `.claude/rules/agent-dispatch.md` | Cross-agent roster: `AGENTS.md`

## Hooks (Event-Driven Automation)

| Hook | Event | What it does |
|------|-------|-------------|
| `session-reconstruct.sh` | SessionStart | Loads git state + cross-project landscape into context |
| `validate-frontmatter.sh` | PreToolUse (git commit) | Blocks commits missing version metadata |
| `strategic-compact.sh` | PreToolUse (all) | Warns when context approaches quality threshold |
| `state-saver.sh` | PostToolUse (Write/Edit) | Snapshots git state to vault for crash recovery |
| `session-summary.sh` | Stop | Auto-saves session summary to vault + refreshes QMD index |

## Org Knowledge Base (`_genesis/`)

Ships with every project. Follows a cascade — downstream layers cannot contradict upstream:

```
philosophy → principles → frameworks → derived artifacts
                                            ↑
                                   [reference/ supplements all]
```

| Layer | Path | Contents |
|-------|------|----------|
| Philosophy | `_genesis/philosophy/` | WHY we do things — core beliefs |
| Principles | `_genesis/principles/` | WHAT we commit to — non-negotiable standards |
| Frameworks | `_genesis/frameworks/` | HOW we model systems — 11 frameworks |
| Brand | `_genesis/brand/` | Visual identity — colors, typography, logo |
| Security | `_genesis/security/` | Data classification, naming, access control |
| SOPs | `_genesis/sops/` | Standard operating procedures |
| Templates | `_genesis/templates/` | 20+ templates — DSBV, VANA-SPEC, ADR, README, research |
| Reference | `_genesis/reference/` | User guide, handbook, ALPEI PDFs, EOP governance |

**Full user guide:** `_genesis/reference/ltc-ai-agent-system-project-template-guide.md`

## Safety Model

Three-layer defense-in-depth:

| Layer | Mechanism | Reliability |
|-------|-----------|-------------|
| **1 — Structural** | `.gitignore` excludes secrets, keys, backups by path | Passive — cannot be accidentally committed |
| **2 — Agent EPS** | `CLAUDE.md`, `GEMINI.md`, `.cursor/rules/` constitutional rules | Probabilistic (~80% compliance) |
| **3 — Hard Gate** | gitleaks + frontmatter validator + `settings.json` deny rules | Deterministic — cannot bypass |

Configure `.claude/settings.json` first — it is your safety net.

## Naming Convention

All LTC repos follow the **Universal Naming Grammar (UNG)**:

```
{SCOPE}_{FA}.{ID}.{NAME}
```

Example: `OPS_OE.6.4.LTC-PROJECT-TEMPLATE`
- **SCOPE:** OPS (Operations)
- **FA:** OE (Operational Excellence)
- **ID:** 6.4
- **NAME:** LTC-PROJECT-TEMPLATE

Full spec: `rules/naming-rules.md` | SCOPE codes are irregular — always look up, never derive.

## Memory Protection

LTC projects use a custom 3-section MEMORY.md template with 2-layer defense:

| Layer | Mechanism | Reliability |
|-------|-----------|-------------|
| 1 (Guide) | `.claude/rules/memory-format.md` — instructs agents to preserve structure | ~95% (probabilistic) |
| 2 (Gate) | `~/.claude/hooks/scripts/memory-guard.sh` — blocks destructive writes | 100% (deterministic) |

## Keeping Your Repo Updated

Run the staleness checker:

```bash
./scripts/template-check.sh           # full report
./scripts/template-check.sh --diff    # changed files with tier tags
./scripts/template-check.sh --quiet   # one-line summary
```

Distribution tiers: **T1:REPLACE** (org-owned, overwrite) | **T2:MERGE** (mixed ownership) | **T3:ADD-ONLY** (new files only). See CHANGELOG.md for tier tags per file.

## Personal Overrides

```bash
cp .claude/settings.local.json.example .claude/settings.local.json
# Edit settings.local.json — it's gitignored
```

---

_Template maintained by OPS Process. Source: [OPS_OE.6.4.LTC-PROJECT-TEMPLATE](https://github.com/Long-Term-Capital-Partners/OPS_OE.6.4.LTC-PROJECT-TEMPLATE)_

## Links

- [[AGENTS]]
- [[CHANGELOG]]
- [[CLAUDE]]
- [[DESIGN]]
- [[GEMINI]]
- [[SEQUENCE]]
- [[SKILL]]
- [[VALIDATE]]
- [[_template]]
- [[adr]]
- [[agent-diagnostic]]
- [[agent-dispatch]]
- [[agent-system]]
- [[architecture]]
- [[brand-identity]]
- [[charter]]
- [[codex]]
- [[friction]]
- [[general-system]]
- [[idea]]
- [[iteration]]
- [[ltc-ai-agent-system-project-template-guide]]
- [[ltc-builder]]
- [[ltc-explorer]]
- [[ltc-planner]]
- [[ltc-reviewer]]
- [[memory-format]]
- [[methodology]]
- [[migration-guide]]
- [[naming-convention]]
- [[naming-rules]]
- [[project]]
- [[roadmap]]
- [[security]]
- [[security-rules]]
- [[session-summary]]
- [[standard]]
- [[versioning]]
- [[workstream]]
