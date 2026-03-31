---
version: "2.0"
last_updated: 2026-03-29
owner: "Long Nguyen"
iteration: I1
audience: "Human users (primary), AI agents (secondary)"
---
# LTC Project Template — User Guide

> **Who this is for:** Any LTC member working in a project that uses this template.
> You do not need to be technical. If you can open a file and read markdown, you can use this.
>
> **AI agents:** Skip to §7 (Agent Zone Map) for a machine-readable structure lookup.

---

## 1. Design Philosophy

This folder structure is **structural risk management encoded into the filesystem**. Every directory exists because it forces you to address a specific failure mode before it compounds.

**The governing equation:**

> **Success = Efficient & Scalable Management of Failure Risks**

Three principles shape the structure:

1. **Make risks visible before they compound** — explicit risk artifacts at every phase
2. **Follow the natural flow of effective work** — ALIGN → PLAN → EXECUTE → IMPROVE
3. **Encode the 3 pillars into the structure** — Sustainability (survives failures?), Efficiency (minimal waste?), Scalability (handles growth?)

---

## 2. Quick Start — 5 Steps

When you join a project that uses this template:

| Step | Action | Where |
|------|--------|-------|
| 1 | Read the agent rules | `CLAUDE.md` (or `GEMINI.md` for AntiGravity) |
| 2 | Understand the project purpose | `1-ALIGN/charter/` |
| 3 | Check what can go wrong | `2-PLAN/risks/UBS_REGISTER.md` |
| 4 | See where the project is | Run `/dsbv status` in Claude Code |
| 5 | Start producing | Every artifact goes through DSBV (see §5) |

---

## 3. The Full Structure

```
project-root/
│
│── CLAUDE.md                    ← Agent rules (Claude Code)
│── GEMINI.md                    ← Agent rules (AntiGravity)
│── README.md                    ← Project overview
│── VERSION                      ← Template version
│── CHANGELOG.md                 ← Version history
│
├── .claude/                     ← Agent internals
│   ├── settings.json            ← Permissions & safety boundaries
│   ├── rules/                   ← Always-loaded rules (DSBV, memory)
│   ├── hooks/                   ← Event-driven scripts
│   └── skills/                  ← On-demand procedures (26 skills)
│
├── .agents/rules/               ← AntiGravity-specific rules
├── .cursor/rules/               ← Cursor IDE rules
├── rules/                       ← LTC-wide standards
│
├── 1-ALIGN/                     ← Zone 1: Choose the right outcome
│   ├── charter/                 ← Why the project exists
│   ├── decisions/               ← Architecture Decision Records
│   ├── learning/                ← Learning pipeline outputs
│   │   └── research/            ← Research notes, specs, visuals
│   └── okrs/                    ← Objectives & Key Results
│
├── 2-PLAN/                      ← Zone 2: Minimize risks before acting
│   ├── risks/                   ← UBS register (what can go wrong)
│   ├── drivers/                 ← UDS register (what to leverage)
│   ├── architecture/            ← System design
│   └── roadmap/                 ← Sequenced plan
│
├── 3-EXECUTE/                   ← Zone 3: Build and deliver
│   ├── src/                     ← Source code
│   ├── tests/                   ← Test suites
│   ├── config/                  ← Environment configuration
│   └── docs/                    ← Delivery documentation
│
├── 4-IMPROVE/                   ← Zone 4: Learn and grow
│   ├── changelog/               ← What changed
│   ├── metrics/                 ← What we measured
│   ├── retrospectives/          ← What we learned
│   ├── reviews/                 ← Peer reviews
│   └── risk-log/                ← Risks that materialized
│
├── _genesis/                    ← Org-wide knowledge base (READ-ONLY)
│   ├── philosophy/              ← Core truths
│   ├── principles/              ← Derived principles
│   ├── frameworks/              ← Working frameworks
│   ├── reference/               ← Supplementary docs & PDFs
│   ├── templates/               ← Artifact templates
│   └── ...                      ← (13 MECE categories total)
│
└── scripts/                     ← Automation & validation
```

---

## 4. Zone-by-Zone Reference

### Zone 0 — Agent Governance

**What it is:** The configuration layer for AI agents. If something is wrong here, everything downstream is affected.

**Files you need to know:**

| File / Folder | What it does | When to touch it |
|---------------|-------------|-----------------|
| `CLAUDE.md` | Claude Code rules — auto-loaded every session | When you set up or change the project |
| `GEMINI.md` | AntiGravity rules — auto-loaded every session | Same as above |
| `.claude/settings.json` | Hard permission deny/allow lists | **Configure this first** — it's your safety net |
| `.claude/rules/` | Rules loaded on every session (DSBV, memory) | Rarely — these are structural |
| `.claude/hooks/` | Scripts triggered by agent events | Ops team only |
| `.claude/skills/` | On-demand procedures (26 skills) | When adding new capabilities |
| `rules/` | LTC-wide standards (brand, naming, security) | Ops team — these flow from the template |

**How each tool gets its rules:**

| Tool | Reads from | Loaded when |
|------|-----------|-------------|
| Claude Code | `CLAUDE.md` + `.claude/rules/` | Every session, automatically |
| AntiGravity | `GEMINI.md` + `.agents/rules/` | Every session, automatically |
| Cursor | `.cursor/rules/` | Automatically, matching globs |
| All tools | `rules/` | On demand — when the agent needs the full spec |

**Available Skills (26 total):**

| Category | Skills | What they do |
|----------|--------|-------------|
| **dsbv** | `/dsbv` | Design → Sequence → Build → Validate lifecycle |
| **learning** | `/learn`, `/learn-input`, `/learn-research`, `/learn-structure`, `/learn-review`, `/learn-spec`, `/learn-visualize` | 6+1 learning pipeline — research → structured notes |
| **process** | `/ltc-brainstorming`, `/ltc-writing-plans`, `/ltc-execution-planner`, `/ltc-task-executor` | Structured thinking & planning workflows |
| **research** | `/deep-research`, `/root-cause-tracing` | Deep investigation |
| **quality** | `/feedback` | Capture frustrations & improvement ideas |
| **session** | `/session-start`, `/session-end`, `/resume`, `/compress`, `/setup` | Session lifecycle management |
| **wms** | `/ltc-clickup-planner`, `/ltc-notion-planner` | Work management integration |
| **brand** | `/ltc-brand-identity` | Visual output compliance (colors, fonts, logo) |
| **naming** | `/ltc-naming-rules` | Universal Naming Grammar compliance |
| **compliance** | `/ltc-rules-compliance` | Rule auditing across the project |
| **skill-creator** | `/ltc-skill-creator` | Create and validate new skills |

---

### Zone 1 — ALIGN (Choose the Right Outcome)

**What it answers:** "Are we solving the right problem? Is everyone aligned?"

| Folder | What goes here | Example |
|--------|---------------|---------|
| `charter/` | Project charter, stakeholders, requirements | Why this project exists and what success looks like |
| `decisions/` | Architecture Decision Records (ADRs) | "We chose X over Y because..." |
| `learning/` | Learning pipeline outputs | Research notes, specs, visual summaries |
| `okrs/` | Objectives & Key Results | Measurable success criteria with pillar tags |

**The Learning Pipeline:**

Zone 1 is the only zone with a `learning/` folder. The `/learn` pipeline feeds into it:

```
/learn-input → /learn-research → /learn-structure → /learn-review → /learn-spec → /learn-visualize
                                                                                        ↓
                                                                        1-ALIGN/learning/
```

To use it: open Claude Code in your project and type `/learn`. The orchestrator guides you through all 6 steps. You review and approve each output before moving on.

**When to add things here:**

- Starting a new project → write the charter first
- Making a non-trivial decision → ADR in `decisions/`
- Researching a topic → run `/learn` → outputs go to `learning/`
- Setting goals → define OKRs in `okrs/`

---

### Zone 2 — PLAN (Minimize Failure Risks Before Acting)

**What it answers:** "What can go wrong? What should we leverage? In what order?"

| Folder | What goes here | Example |
|--------|---------------|---------|
| `risks/` | UBS Register — every known risk, assumption, mitigation | "If the API changes, our integration breaks" |
| `drivers/` | UDS Register — every advantage, leverage point | "We have domain expertise in X — use it" |
| `architecture/` | System design, diagrams | How components fit together |
| `roadmap/` | Master plan, execution plan, dependencies | What to build, in what sequence |

**The UBS / UDS framework:**

- **UBS (Ultimate Blocking System):** Things that can stop your project. For each: what is it? What drives it? How do you disable it?
- **UDS (Ultimate Driving System):** Things that accelerate your project. For each: what is it? What enables it? How do you maximize it?

**When to add things here:**

- Before any execution → identify risks in `risks/`
- Before building → design the system in `architecture/`
- Before a sprint → sequence work in `roadmap/`

---

### Zone 3 — EXECUTE (Build and Deliver)

**What it answers:** "Is the thing built right? Does it trace back to requirements and risks?"

| Folder | What goes here | Example |
|--------|---------------|---------|
| `src/` | Source code (business logic, UI, API, infra) | The actual product |
| `tests/` | Test suites (unit, integration, e2e) | Tests disable specific failure modes |
| `config/` | Environment configuration (dev, staging, prod) | Keep config separate from code |
| `docs/` | Delivery documentation (API docs, guides) | Docs that ship with the product |

**When to add things here:**

- Writing code → `src/`
- Writing tests → `tests/`
- Configuring environments → `config/`
- Writing user-facing docs → `docs/`

---

### Zone 4 — IMPROVE (Learn & Grow)

**What it answers:** "What worked? What didn't? What will we do differently?"

| Folder | What goes here | Example |
|--------|---------------|---------|
| `changelog/` | What changed, tagged by version | `CHANGELOG.md` — updated with every PR |
| `metrics/` | What we measured (velocity, quality, pillar scores) | Can't improve what you don't measure |
| `retrospectives/` | Retrospectives — what we learned | Turn experience into institutional knowledge |
| `risk-log/` | Risks that materialized during execution | Track what went wrong and how it was handled |
| `reviews/` | Peer reviews and audit results | External perspective catches blind spots |

**When to add things here:**

- After every PR → update `changelog/CHANGELOG.md`
- After a milestone → write a retro in `retrospectives/`
- After gathering data → record in `metrics/`

---

### _genesis/ — Org Knowledge Base

**What it is:** LTC-wide knowledge that applies to ALL projects. This is the shared organizational brain.

> **Rule:** In project repos, `_genesis/` is **read-only**. It flows down from the template.
> Never modify these files in a cloned project. To suggest changes, raise them with OPS Process.

**The Knowledge Cascade:**

```
philosophy → principles → frameworks → derived artifacts
                                            ↑
                                   [reference/ supplements all]
```

Each layer builds on the one before. Don't create a framework that contradicts principles. Don't quote a principle without understanding its philosophical root.

**Categories (13 MECE):**

| Folder | What lives here | Cascade position |
|--------|----------------|-----------------|
| `philosophy/` | Core truths (Ultimate Truths, 10 UTs) | Foundation |
| `principles/` | Effective Principles (EP-01 to EP-10) | Built on philosophy |
| `frameworks/` | Working frameworks (version control, ESD) | Built on principles |
| `governance/` | Governance documents | Organizational rules |
| `sops/` | Standard operating procedures | Process documentation |
| `templates/` | DSBV process, design templates | Reusable structures |
| `reference/` | Supplementary docs, handbook, PDFs | Supports all layers |
| `brand/` | Brand assets | Visual identity |
| `security/` | Security frameworks | Defense-in-depth |
| `compliance/` | Compliance requirements | Regulatory |
| `culture/` | Culture & values | Team norms |
| `scripts/` | Shared automation scripts | Reusable tooling |
| `skills/` | Shared skill references | Cross-project skills |

---

## 5. Common Workflows

### Starting a New Project

1. Clone from the template:
   ```
   gh repo create --template Long-Term-Capital-Partners/OPS_OE.6.4.LTC-PROJECT-TEMPLATE
   ```
2. Configure `.claude/settings.json` — **do this first**, it's your safety net
3. Edit `CLAUDE.md` — replace placeholders with your project details
4. Write the charter: `1-ALIGN/charter/`
5. Identify risks: `2-PLAN/risks/UBS_REGISTER.md`
6. Start DSBV: `/dsbv design align`

### Using the DSBV Process

Every zone produces artifacts through **Design → Sequence → Build → Validate**:

| Command | What it does |
|---------|-------------|
| `/dsbv` | Start a full guided DSBV cycle |
| `/dsbv design align` | Run just the Design phase on Zone 1 |
| `/dsbv status` | See progress across all zones |

**Rules:**
- Design MUST complete before Build
- Validate MUST happen before a zone is marked complete
- Each phase transition requires your explicit approval

### Using the Learning Pipeline

| Command | What it does |
|---------|-------------|
| `/learn` | Start the full 6-step pipeline |
| `/learn-research` | Run just the research step on its own |
| `/learn-spec` | Convert notes to a formal spec |

All outputs land in `1-ALIGN/learning/`. If you stop mid-pipeline, the outputs already saved remain — you can continue from any step later.

### Finding Any File

| You're looking for... | Go to |
|-----------------------|-------|
| Brand rules | `rules/brand-identity.md` |
| Naming conventions | `rules/naming-rules.md` |
| Security rules | `rules/security-rules.md` |
| Agent system | `rules/agent-system.md` |
| System design | `rules/general-system.md` |
| Agent diagnostics | `rules/agent-diagnostic.md` |
| DSBV process | `_genesis/templates/DSBV_PROCESS.md` |
| EOP governance | `_genesis/reference/ltc-eop-gov.md` |
| Any skill | `.claude/skills/{category}/{skill-name}/SKILL.md` |
| Project charter | `1-ALIGN/charter/` |
| Risk register | `2-PLAN/risks/UBS_REGISTER.md` |
| Changelog | `4-IMPROVE/changelog/CHANGELOG.md` |
| This guide | `_genesis/reference/ltc-ai-agent-system-project-template-guide.md` |

---

## 6. Safety Model

Three layers of defense protect every project:

| Layer | Mechanism | What it does | Reliability |
|-------|-----------|-------------|-------------|
| 1 — Structural | `.gitignore` | Secrets and key files excluded by path | Passive, always on |
| 2 — Agent Rules | `CLAUDE.md`, `rules/` | Agent self-enforces security, brand, naming | ~80% (probabilistic) |
| 3 — Hard Gate | `.pre-commit-config.yaml` + `.gitleaks.toml` | Blocks any commit containing detected secrets | 100% (deterministic) |

Additionally, `.claude/settings.json` provides platform-level deny/allow rules the agent physically cannot bypass. Configure it first.

---

## 7. Agent Zone Map (Machine-Readable Reference)

> **For AI agents.** Use this section when you need to resolve "where does this artifact go?"
> or "what is the purpose of this folder?"

```yaml
ZONE_MAP:
  zone_0_governance:
    paths: [CLAUDE.md, GEMINI.md, .claude/, .agents/, .cursor/, rules/]
    purpose: agent_configuration_and_safety
    artifacts: [settings, rules, skills, hooks, commands]

  zone_1_align:
    path: 1-ALIGN/
    subfolders: [charter/, decisions/, learning/, okrs/]
    purpose: choose_the_right_outcome
    key_artifacts: [PROJECT_CHARTER.md, ADR-*.md, learning pipeline outputs]
    has_learning_pipeline: true

  zone_2_plan:
    path: 2-PLAN/
    subfolders: [risks/, drivers/, architecture/, roadmap/]
    purpose: minimize_failure_risks
    key_artifacts: [UBS_REGISTER.md, UDS_REGISTER.md, SYSTEM_DESIGN.md]

  zone_3_execute:
    path: 3-EXECUTE/
    subfolders: [src/, tests/, config/, docs/]
    purpose: build_and_deliver
    key_artifacts: [source code, test suites, deployment configs]

  zone_4_improve:
    path: 4-IMPROVE/
    subfolders: [changelog/, metrics/, retrospectives/, reviews/, risk-log/]
    purpose: learn_and_grow
    key_artifacts: [CHANGELOG.md, retrospectives, metrics dashboards]

  shared_genesis:
    path: _genesis/
    purpose: org_wide_knowledge_base
    cascade: philosophy > principles > frameworks > derived
    rule: read_only_in_project_repos
    categories: 13

ROUTING_RULES:
  - "research notes"    → 1-ALIGN/learning/
  - "decision record"   → 1-ALIGN/decisions/
  - "risk identified"   → 2-PLAN/risks/
  - "driver identified" → 2-PLAN/drivers/
  - "source code"       → 3-EXECUTE/src/
  - "test suite"        → 3-EXECUTE/tests/
  - "retrospective"     → 4-IMPROVE/retrospectives/
  - "changelog entry"   → 4-IMPROVE/changelog/
  - "new template"      → _genesis/templates/
  - "new skill"         → .claude/skills/{category}/
  - "new rule"          → .claude/rules/ (always-loaded) or rules/ (global)

SKILL_CATEGORIES:
  dsbv:         [dsbv]
  learning:     [learn, learn-input, learn-research, learn-structure, learn-review, learn-spec, learn-visualize]
  process:      [ltc-brainstorming, ltc-writing-plans, ltc-execution-planner, ltc-task-executor]
  research:     [deep-research, root-cause-tracing]
  quality:      [feedback]
  session:      [session-start, session-end, resume, compress, setup]
  wms:          [ltc-clickup-planner, ltc-notion-planner]
  brand:        [ltc-brand-identity]
  naming:       [ltc-naming-rules]
  compliance:   [ltc-rules-compliance]
  skill-creator:[ltc-skill-creator]
```

---

_Guide maintained by OPS Process. Template: [OPS_OE.6.4.LTC-PROJECT-TEMPLATE](https://github.com/Long-Term-Capital-Partners/OPS_OE.6.4.LTC-PROJECT-TEMPLATE)_
