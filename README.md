---
version: "1.1"
status: Draft
last_updated: 2026-04-01
---
# LTC Project Template — Iteration 1 (Concept)

Standard project scaffold for LT Capital Partners. Clone this to start any new project with the ALPEI workstream structure, DSBV production process, and AI agent configuration pre-loaded.

**Iteration 1 focus: Sustainability** — human adoption first. The template gives you a structure that agents follow and humans can verify.

## Must-Read Before Starting

| # | Resource | How to access | Time |
|---|----------|---------------|------|
| 1 | **Training Deck** (47 slides) | `cd _genesis/training/alpei-training-slides && npm install && npm run dev` → open `http://localhost:5173` | 30 min |
| 2 | **ALPEI Navigator** (interactive map) | Open `_genesis/tools/alpei-navigator.html` in any browser (no install needed) | 10 min |
| 3 | **Migration Guide** (I0 → I1) | Read `_genesis/guides/MIGRATION_GUIDE.md` — or tell your agent: *"Read the migration guide and execute it for my project"* | 15 min |

## Quick Start

### 1. Create your project from this template

**On GitHub:** Click the green **"Use this template"** button at the top of this repo. Choose the owner, name your project using LTC naming convention, and click "Create repository."

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
| 5 | `.mcp.json` | Add MCP server connections if your project uses external tools. |
| 6 | `.claude/rules/` | `memory-format.md` and `versioning.md` are pre-loaded. Delete the example rule. Add path-scoped rules for your codebase. |
| 7 | `.claude/skills/` | Add project-specific skills (on-demand procedures). |
| — | `.cursor/rules/`, `.agents/rules/` | Already configured with brand identity. Add more rules as needed for Cursor / AntiGravity. |

### 4. Start working

```bash
claude   # Opens Claude Code with CLAUDE.md auto-loaded
```

Or open the project in AntiGravity / Cursor — each IDE loads its own rules automatically.

### 5. Build your first workstream

Every workstream (ALIGN → PLAN → EXECUTE → IMPROVE) uses the **DSBV process** — Design, Sequence, Build, Validate:

```
/dsbv                    Start a guided DSBV cycle on any workstream
/dsbv design align       Run just the Design phase on the ALIGN workstream
/dsbv status             See current progress across all workstreams
```

DSBV guides you step by step: define what the workstream must produce (Design), order the work (Sequence), execute it (Build), and verify quality (Validate). Each phase has a human gate — you review and approve before proceeding.

Start with ALIGN: `/dsbv design align` — it will ask you to describe your project's purpose in 1-3 sentences, then draft the specification for your review.

Full process: `_genesis/templates/DSBV_PROCESS.md` | Skill: `.claude/skills/dsbv/SKILL.md`

### Already have a project? Migrate to I1

If your project was cloned from the I0 scaffold (or set up before this template existed), see the migration guide:

```
_genesis/guides/MIGRATION_GUIDE.md
```

Your AI agent can execute it: *"Read `_genesis/guides/MIGRATION_GUIDE.md` and execute it for my project."*

### 6. Research before you build

The **learning pipeline** helps you understand a domain before committing to decisions:

```
/learn "What is X and how does it apply to our project?"
```

This runs a 6-step pipeline: scope → research → structure → review → spec → visualize. Outputs land in `2-LEARN/` and feed directly into your charter, requirements, and risk analysis.

| Skill | What it does |
|-------|-------------|
| `/learn` | Orchestrates the full pipeline end-to-end |
| `/learn-input` | Scopes what to research |
| `/learn-research` | Deep research with sources |
| `/learn-structure` | Organizes into 6 structured pages |
| `/learn-review` | You approve the research |
| `/learn-spec` | Extracts acceptance criteria (VANA-SPEC) |
| `/learn-visualize` | Creates interactive HTML visualization |

## What's Included

```
.                                                       7-CS Component
├── CLAUDE.md                   # Claude Code rules      ← EPS (always-active constitution)
├── GEMINI.md                   # AntiGravity rules      ← EPS (always-active constitution)
├── VERSION                     # Template version        ← Input (distribution tracking)
├── CHANGELOG.md                # Tier-tagged changelog   ← Input (distribution tracking)
│
├── .claude/
│   ├── settings.json           # Safety deny/allow      ← Environment (hard ceilings)
│   ├── settings.local.json.example  # Personal overrides  ← Environment (per-user)
│   ├── agents/                 # Subagent definitions    ← Agent (operator config)
│   ├── commands/               # Slash commands          ← EOP (on-demand procedures)
│   ├── hooks/                  # Event-driven scripts    ← Environment (automation)
│   │   ├── session-reconstruct.sh  # Git state on startup
│   │   ├── session-summary.sh      # Auto-save on stop
│   │   ├── state-saver.sh          # Snapshot on every write
│   │   ├── strategic-compact.sh    # Context limit warnings
│   │   └── validate-frontmatter.sh # Version metadata gate
│   ├── rules/
│   │   ├── dsbv.md             # DSBV workstream awareness    ← EPS (always-loaded)
│   │   ├── versioning.md       # Version metadata rule  ← EPS (always-loaded)
│   │   └── memory-format.md    # Memory structure guard ← EPS (always-loaded)
│   └── skills/                 # 26 skills across 9 categories
│       ├── dsbv/               #   /dsbv — workstream production process
│       ├── learning/           #   7 skills: /learn pipeline
│       ├── process/            #   4 skills: brainstorming, planning, execution
│       ├── session/            #   5 skills: start, end, compress, resume, setup
│       ├── wms/                #   2 skills: Notion + ClickUp planners
│       ├── quality/            #   1 skill: /feedback capture
│       ├── research/           #   2 skills: deep-research, root-cause-tracing
│       ├── ltc-brand-identity/ #   Apply LTC brand rules
│       ├── ltc-naming-rules/   #   Apply LTC naming rules
│       ├── ltc-rules-compliance/ # Check LTC rules compliance
│       └── ltc-skill-creator/  #   Create new EOP-governed skills
│
├── _genesis/                   # Org knowledge base (read-only for projects)
│   ├── philosophy/             #   WHY we do things
│   ├── principles/             #   WHAT we commit to
│   ├── frameworks/             #   HOW we model systems (11 frameworks)
│   ├── brand/                  #   Visual identity (colors, typography, logo)
│   ├── security/               #   Data classification, naming, hierarchy
│   ├── sops/                   #   Standard operating procedures
│   ├── templates/              #   DSBV process, VANA-SPEC, ADR, 15+ templates
│   ├── reference/              #   User guide, handbook, ALPEI PDFs, EOP-GOV
│   ├── governance/             #   (I2 placeholder)
│   ├── compliance/             #   (I2 placeholder)
│   └── culture/                #   (I2 placeholder)
│
├── 1-ALIGN/                    # ALIGN workstream: Right Outcome
│   ├── charter/                #   Project charter, stakeholders, requirements
│   ├── decisions/              #   ADRs for multi-option choices
│   └── okrs/                   #   Objectives + Key Results
│
├── 2-LEARN/                    # LEARN workstream: Problem Research (ALPEI)
│   ├── input/                  #     Scoping documents + raw WIP
│   ├── research/               #     Structured research + HTML visualizations
│   ├── specs/                  #     VANA-SPEC extractions
│   └── output/                 #     Final structured deliverables
│
├── 3-PLAN/                     # PLAN workstream: Minimize Risks
│   ├── architecture/           #   System design, ADRs, diagrams
│   ├── risks/                  #   UBS register (blocking forces)
│   ├── drivers/                #   UDS register (driving forces)
│   └── roadmap/                #   Execution timeline
│
├── 4-EXECUTE/                  # EXECUTE workstream: Deliver
│   ├── src/                    #   Application code
│   ├── tests/                  #   Unit, integration, e2e, quality gates
│   ├── config/                 #   CI/CD, env, security config
│   ├── docs/                   #   API docs, onboarding, runbooks
│   └── scripts/                #   Build and deploy scripts
│
├── 5-IMPROVE/                  # IMPROVE workstream: Learn & Grow
│   ├── changelog/              #   CHANGELOG.md (tier-tagged)
│   ├── metrics/                #   Performance and quality metrics
│   ├── retrospectives/         #   Sprint and project retros
│   ├── reviews/                #   Code and design reviews
│   └── risk-log/               #   Materialized risks tracker
│
├── rules/                      # LTC global rules (agent-facing)
│   ├── brand-identity.md       #   Full 20-color palette ref
│   ├── naming-rules.md         #   UNG full spec (75 SCOPE codes)
│   ├── security-rules.md       #   3-layer security ref
│   ├── agent-system.md         #   8 LLM Truths + 7-CS model
│   ├── agent-diagnostic.md     #   6-component trace methodology
│   └── general-system.md       #   Universal 8-component model
│
├── scripts/
│   └── template-check.sh       # Staleness checker
├── .cursor/rules/              # Cursor IDE rules (brand, security)
├── .agents/rules/              # AntiGravity IDE rules
├── .pre-commit-config.yaml     # gitleaks hook config
├── .gitleaks.toml              # Secret detection rules
└── .mcp.json                   # MCP server connections
```

> **7-CS** = The Agent's 7-Component System. Each file maps to a component:
> **EPS** constrains behavior | **EOP** defines procedures | **Environment** sets hard limits |
> **Tools** extend capability | **Input** provides context | **Agent** executes within all of the above.

## Skills (26 total)

All skills live in `.claude/skills/` and are invoked with `/skill-name`.

| Category | Skills | Purpose |
|----------|--------|---------|
| **DSBV** | `/dsbv` | Workstream production process — Design, Sequence, Build, Validate |
| **Learning** | `/learn`, `/learn-input`, `/learn-research`, `/learn-structure`, `/learn-review`, `/learn-spec`, `/learn-visualize` | Research pipeline — from question to structured spec |
| **Process** | `/ltc-brainstorming`, `/ltc-writing-plans`, `/ltc-execution-planner`, `/ltc-task-executor` | Structured thinking and execution |
| **Session** | `/session-start`, `/session-end`, `/compress`, `/resume`, `/setup` | Session lifecycle management |
| **WMS** | `/ltc-clickup-planner`, `/ltc-notion-planner` | Work management system integration |
| **Quality** | `/feedback` | Capture friction reports → GitHub Issues |
| **Research** | `/deep-research`, `/root-cause-tracing` | Deep investigation and debugging |
| **Compliance** | `/ltc-brand-identity`, `/ltc-naming-rules`, `/ltc-rules-compliance` | Apply and verify LTC standards |
| **Governance** | `/ltc-skill-creator` | Create new EOP-governed skills |

## LTC Global Rules

The `rules/` folder contains LTC-wide standards that apply to all projects:

| Rule File | What it covers |
|-----------|---------------|
| `brand-identity.md` | Colors (20-color palette), typography (Inter/Work Sans), logo usage, function color assignments |
| `naming-rules.md` | Universal Naming Grammar (UNG) — canonical key pattern, 75 SCOPE codes, platform rendering |
| `security-rules.md` | 3-layer defense-in-depth: AI agent security rules, risk tiers, secret detection (gitleaks) |
| `agent-system.md` | 8 LLM Truths + 7-Component System (AI specialization of the universal 8-component model) |
| `agent-diagnostic.md` | 6-component trace methodology — diagnose agent failures before blaming the model |
| `general-system.md` | Universal 8-component model (EI→EU→EA→EO + EP→EOE→EOT→EOP) + RACI + VANA requirements |

### How rules reach each tool

| Tool | Primary rules file | Brand + Security source | Loading |
|------|-------------------|------------------------|---------|
| **Claude Code** (CLI) | `CLAUDE.md` | Distilled in CLAUDE.md (brand, naming, security) | Auto-loaded every session |
| **AntiGravity** (IDE) | `GEMINI.md` | Distilled in GEMINI.md (brand, naming, security) | Auto-loaded every session |
| **Cursor** (IDE) | `.cursor/rules/` | `.cursor/rules/brand-identity.md`, `security.md` | Auto-loads matching globs |
| **All tools** | `rules/` | Full references: brand-identity, naming-rules, security-rules | On demand — agent reads when it needs detailed specs |
| **Pre-commit** | `.pre-commit-config.yaml` | `.gitleaks.toml` (secret detection) | Runs on every `git commit` |

**Why no AGENTS.md?** The AAIF standard promises a universal file all tools read. In practice, only Claude Code reads it. AntiGravity reads GEMINI.md. Cursor reads .cursor/rules/. Rather than maintain a file only one tool uses, each tool gets rules through its own guaranteed loading path. Less elegant, more reliable.

## Hooks (Event-Driven Automation)

The `.claude/hooks/` directory contains scripts that fire automatically on Claude Code events:

| Hook | Event | What it does |
|------|-------|-------------|
| `session-reconstruct.sh` | SessionStart | Loads git state + cross-project landscape into context |
| `validate-frontmatter.sh` | PreToolUse (git commit) | Blocks commits missing version metadata — exit 2 = block |
| `strategic-compact.sh` | PreToolUse (all) | Warns when context approaches quality threshold |
| `state-saver.sh` | PostToolUse (Write/Edit) | Snapshots git state to vault for crash recovery (30s debounce) |
| `session-summary.sh` | Stop | Auto-saves session summary to vault + refreshes QMD index |

## Org Knowledge Base (`_genesis/`)

`_genesis/` is the organizational knowledge base that ships with every project. It follows a cascade:

```
philosophy → principles → frameworks → derived artifacts
                                            ↑
                                   [reference/ supplements all]
```

| Layer | Path | Contents |
|-------|------|----------|
| Philosophy | `_genesis/philosophy/` | WHY we do things — core beliefs |
| Principles | `_genesis/principles/` | WHAT we commit to — non-negotiable standards |
| Frameworks | `_genesis/frameworks/` | HOW we model systems — 11 frameworks (3 pillars, 6 workstreams, UBS/UDS, etc.) |
| Brand | `_genesis/brand/` | Visual identity — colors.json, BRAND_GUIDE.md, assets/ |
| Security | `_genesis/security/` | Data classification, naming convention, security hierarchy |
| SOPs | `_genesis/sops/` | Standard operating procedures (code review, deployment, discussion) |
| Templates | `_genesis/templates/` | 18 templates — DSBV process, VANA-SPEC, ADR, research, review, and more |
| Reference | `_genesis/reference/` | User guide, company handbook, ALPEI PDFs, EOP governance spec |

**Full user guide:** `_genesis/reference/ltc-ai-agent-system-project-template-guide.md`

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

## Safety Model

The template enforces a three-layer defense-in-depth model:

- **Layer 1 — Structural** (`.gitignore`): Passive defense. Secrets, key files, and backup directories are excluded by path. Cannot be accidentally committed.
- **Layer 2 — Agent EPS** (`CLAUDE.md`, `GEMINI.md`, `.cursor/rules/`, `.agents/rules/`): Constitutional rules the agent self-enforces — security, brand identity, naming conventions. Broad coverage, probabilistic enforcement (~80% compliance).
- **Layer 3 — Hard Gate** (`.pre-commit-config.yaml` + `.gitleaks.toml` + `.claude/hooks/validate-frontmatter.sh`): Deterministic. gitleaks blocks commits containing secrets. Frontmatter validator blocks commits missing version metadata. Cannot be bypassed without explicit allowlist.

Additionally, `.claude/settings.json` provides platform-level deny/allow rules the agent physically cannot bypass. Configure it first — it is your safety net.

See `rules/security-rules.md` for the full security reference, including risk tiers, gap analysis, and setup instructions.

## Memory Protection

Claude Code's **Auto Memory** writes notes about your project across sessions into `~/.claude/projects/<project>/memory/MEMORY.md`. **AutoDream** periodically consolidates these notes — pruning stale entries, merging duplicates, and normalizing dates.

LTC projects use a custom 3-section MEMORY.md template:

```
## Agent Instructions   ← Meta-rules (structural, never consolidate)
## Briefing Card        ← Quick-load context (Identity, Subject, EO, state, WMS)
## Topic Index          ← Pointer list to detail files
```

Without protection, AutoDream flattens this structure into generic sections and deletes the meta-rules. The template includes a 2-layer defense:

| Layer | File | Mechanism | Reliability |
|-------|------|-----------|-------------|
| 1 (Guide) | `.claude/rules/memory-format.md` | Instructs any agent to preserve the 3-section structure | ~95% (probabilistic) |
| 2 (Gate) | `~/.claude/hooks/scripts/memory-guard.sh` | PreToolUse hook blocks writes that destroy structure | 100% (deterministic) |

**Layer 1** ships with the template. **Layer 2** must be installed per-machine (global hook — see setup instructions from your team lead).

To check memory health across all projects:

```bash
bash ~/.claude/hooks/scripts/validate-memory-structure.sh
```

## Personal Overrides

To add personal permissions without affecting the team:

```bash
cp .claude/settings.local.json.example .claude/settings.local.json
# Edit settings.local.json — it's gitignored
```

## Keeping Your Repo Updated

This template uses semver versioning. The `VERSION` file tracks the current template version.

### Distribution Tiers

Every file falls into one of three update tiers:

| Tier | Strategy | What it means |
|------|----------|---------------|
| T1:REPLACE | Overwrite | Org-owned. Copy the template's version directly. |
| T2:MERGE | Merge | Mixed ownership. Update org sections, keep your project sections. |
| T3:ADD-ONLY | Add new | New files only. Never overwrites your existing files. |

See CHANGELOG.md for tier tags on every change.

### Checking for Updates

Run the staleness checker:

    ./scripts/template-check.sh           # full report
    ./scripts/template-check.sh --diff    # show changed files with tier tags
    ./scripts/template-check.sh --quiet   # one-line summary (used by session-start)

First time? Bootstrap your sync version:

    ./scripts/template-check.sh --init

### Applying Updates

1. Open your repo in Claude Code (or your IDE of choice)
2. Paste the template repo URL and ask:
   "Check this template and see if there is any update I need to make to my repo"
3. Claude diffs the template against your repo and recommends changes per tier
4. Review and approve each change
5. Update `.template-version` to the new version

### Releasing a Template Update (maintainers)

1. Make changes to the template repo
2. Bump `VERSION` (semver: patch/minor/major)
3. Add CHANGELOG.md entry with tier tags per file
4. Commit, push, and optionally tag: `git tag v{VERSION}`

---

_Template maintained by OPS Process. Source: [OPS_OE.6.4.LTC-PROJECT-TEMPLATE](https://github.com/Long-Term-Capital-Partners/OPS_OE.6.4.LTC-PROJECT-TEMPLATE)_

## Links

- [[BRAND_GUIDE]]
- [[CHANGELOG]]
- [[CLAUDE]]
- [[DESIGN]]
- [[DSBV_PROCESS]]
- [[GEMINI]]
- [[MIGRATION_GUIDE]]
- [[SEQUENCE]]
- [[SKILL]]
- [[VALIDATE]]
- [[_TEMPLATE]]
- [[agent-diagnostic]]
- [[agent-system]]
- [[brand-identity]]
- [[dsbv]]
- [[friction]]
- [[general-system]]
- [[iteration]]
- [[ltc-ai-agent-system-project-template-guide]]
- [[memory-format]]
- [[methodology]]
- [[naming-rules]]
- [[project]]
- [[security]]
- [[security-rules]]
- [[session-summary]]
- [[standard]]
- [[template-version]]
- [[versioning]]
- [[workstream]]
