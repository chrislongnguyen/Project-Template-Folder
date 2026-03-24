# FOLDER STRUCTURE



# LTC_Project_Folder_Structure.md

# LTC CAPITAL PARTNERS — STANDARD PROJECT FOLDER STRUCTURE

## For Cursor / Antigravity + Claude Code Development Environments

### Version 1.0 | March 2026
* * *

## DESIGN PHILOSOPHY

This folder structure is not just an organizational convention — it is **structural risk management encoded into the filesystem**. Every directory exists because it forces the AI agent and the human operator to address a specific failure mode before it compounds.

The governing equation is **Success = Efficient & Scalable Management of Failure Risks** (Ultimate Truth #5). This means the structure must:

1. **Make risks visible before they compound** — by requiring explicit risk artifacts at every phase
2. **Follow the natural flow of effective work** — ALIGN → PLAN → EXECUTE → IMPROVE (LTC's four action areas)
3. **Run the 6 work streams concurrently, not sequentially** — each area contains hooks for all six work streams, because life is uncertain and effective work is iterative (Ultimate Truth #10)
4. **Encode the 3 pillars into the structure itself** — Sustainability (can it survive failures?), Efficiency (minimal waste), Scalability (handles growth)
* * *

## THE STRUCTURE

```yaml
project-root/
│
│   ══════════════════════════════════════════════════════════════
│   ZONE 0 — AGENT GOVERNANCE (The Effective Principles Layer)
│   "Why does the system work? What principles govern it?"
│   (Derived from: EP Framework — Section 3.0)
│   ══════════════════════════════════════════════════════════════
│
├── CLAUDE.md                         # Claude Code project-level instructions
├── AGENTS.md                         # Antigravity primary agent config
├── GEMINI.md                         # Gemini-specific behavioral rules
├── .cursorrules                      # Cursor IDE rules (if using Cursor)
│
├── .claude/                          # Claude Code agent internals
│   ├── settings.json                 # Model, permissions, MCP config
│   └── MEMORY.md                     # Claude Code self-learning log
│
├── .gemini/                          # Antigravity agent internals
│   ├── antigravity/
│   │   └── brain/                    # Antigravity knowledge base
│   │       ├── SKILLS.md             # Learned capabilities
│   │       └── PATTERNS.md           # Recognized patterns
│   └── GEMINI.md                     # Gemini global overrides (caution: shared path)
│
├── .mcp/                             # Model Context Protocol servers
│   ├── servers.json                  # MCP server registry
│   └── README.md                     # What each MCP server does and why
│
│   ══════════════════════════════════════════════════════════════
│   ZONE 1 — ALIGN (Choose the Right Outcome)
│   "Are we solving the right problem? Is everyone aligned?"
│   Work Stream 1: Self/Team Alignment
│   (Derived from: Ultimate Truth #7 — Work Stream 1;
│    Agile SOP 2.1 Alignment Meeting; SOP 2.2 OKR Planning)
│   ══════════════════════════════════════════════════════════════
│
├── 1-ALIGN/
│   │
│   ├── README.md                     # Purpose of this zone + checklist
│   │                                 # "Before anything in this project moves
│   │                                 #  forward, every item here must be green."
│   │
│   ├── charter/                      # PROJECT CHARTER (The Alignment Artifact)
│   │   ├── PROJECT_CHARTER.md        # Why this project exists, who it serves,
│   │   │                             # what success looks like (EO definition)
│   │   ├── STAKEHOLDERS.md           # Who has a stake, what they need,
│   │   │                             # what their UBS/UDS are
│   │   └── REQUIREMENTS.md           # Decomposed as Verb + Adverbs + Noun + Adjectives
│   │                                 # (Derived from: Ultimate Truth #3)
│   │
│   ├── okrs/                         # OBJECTIVES & KEY RESULTS
│   │   ├── OBJECTIVES.md             # What outcomes define success
│   │   └── KEY_RESULTS.md            # Measurable results with formulas
│   │                                 # Each KR must specify which pillar it
│   │                                 # measures: Sustainability / Efficiency / Scalability
│   │                                 # (Derived from: Derived Truth #1; Wiki KPI standards)
│   │
│   └── decisions/                    # ALIGNMENT DECISIONS LOG
│       └── ADR-000_template.md       # Architecture Decision Record template
│                                     # Fields: Context, Options Considered,
│                                     # Decision, UBS Mitigated, UDS Leveraged,
│                                     # Consequences, Review Date
│                                     # (Derived from: UT#7 Work Stream 5)
│
│   ══════════════════════════════════════════════════════════════
│   ZONE 2 — PLAN (Minimize Failure Risks Before Acting)
│   "What can go wrong? What should we leverage? In what order?"
│   Work Streams 2-5: Risk Mgmt, Learning, Thinking, Decisions
│   (Derived from: Ultimate Truth #5 — Risk > Output;
│    UT#7 Work Streams 2-5; Agile SOPs 2.3-2.4)
│   ══════════════════════════════════════════════════════════════
│
├── 2-PLAN/
│   │
│   ├── README.md                     # Purpose of this zone + checklist
│   │                                 # "No code is written until the top risks
│   │                                 #  are identified and mitigated."
│   │
│   ├── risks/                        # RISK REGISTER (The UBS Artifact)
│   │   ├── UBS_REGISTER.md           # Ultimate Blocking System identification
│   │   │                             # For each blocker: What is it? What drives it?
│   │   │                             # What principles enable it? How to disable it?
│   │   │                             # (Derived from: Section 3 — UBS Table 1.0-1.6)
│   │   ├── ASSUMPTIONS.md            # Explicit assumptions that could be wrong
│   │   │                             # Each assumption = a risk if invalidated
```

```yaml
│   │   │                             # (Derived from: Critical Thinking — Premises)
│   │   └── MITIGATIONS.md            # For each UBS entry: mitigation strategy,
│   │                                 # fallback plan, owner, review trigger
│   │
│   ├── drivers/                      # DRIVER REGISTER (The UDS Artifact)
│   │   ├── UDS_REGISTER.md           # Ultimate Driving System identification
│   │   │                             # For each driver: What is it? What enables it?
│   │   │                             # What principles underpin it? How to maximize it?
│   │   │                             # (Derived from: Section 3 — UDS Table 2.0-2.6)
│   │   └── LEVERAGE_PLAN.md          # How to exploit each driver systematically
│   │
│   ├── learning/                     # RESEARCH & LEARNING (Work Stream 3)
│   │   ├── research/                 # Domain research, spikes, investigations
│   │   │   └── _TEMPLATE.md          # Uses CODE template: Category → Overview →
│   │   │                             # Components → Steps to Apply
│   │   │                             # Each topic answers: WHY? WHAT? HOW? WHY?
│   │   │                             # WHY NOT? SO WHAT? NOW WHAT?
│   │   │                             # (Derived from: Wiki Section 8.1 CODE template;
│   │   │                             #  Learning Hierarchy: Facts→Info→Wisdom→Expertise)
│   │   └── spikes/                   # Time-boxed technical investigations
│   │       └── SPIKE_TEMPLATE.md     # Hypothesis + Method + Findings + Decision
│   │                                 # (Derived from: Critical Thinking model —
│   │                                 #  Hypothesis + Premises + Reasoning → Conclusion)
│   │
│   ├── architecture/                 # SYSTEM DESIGN (Work Stream 4: Thinking)
│   │   ├── SYSTEM_DESIGN.md          # Architecture using 7-component model:
│   │   │                             # EU, EA, EO, EP, EOE, EOT, EOP
│   │   │                             # (Derived from: Section 3 — Effective System)
│   │   ├── diagrams/                 # Visual architecture artifacts
│   │   └── ADRs/                     # Architecture Decision Records
│   │       └── ADR-001_example.md    # Each ADR: Context → Options → Decision →
│   │                                 # UBS Mitigated → UDS Leveraged → Trade-offs
│   │
│   └── roadmap/                      # PRIORITIZED PLAN (Work Stream 5: Decisions)
│       ├── MASTER_PLAN.md            # 3Y/3M strategic view — Initiatives → Projects
│       │                             # → Deliverables, prioritized by MoSCoW
│       │                             # (Derived from: Agile SOP 2.3 Master Planning)
│       ├── EXECUTION_PLAN.md         # 1M tactical view — Deliverables → Tasks
│       │                             # with Acceptance Criteria & Definition of Done
│       │                             # (Derived from: Agile SOP 2.4 Sprint Planning)
│       └── DEPENDENCIES.md           # Cross-cutting dependencies & sequencing
│
│   ══════════════════════════════════════════════════════════════
│   ZONE 3 — EXECUTE (Deliver with Effective Process)
│   "Build it right, with the right tools, in the right environment."
│   Work Stream 6: Effective Execution
│   (Derived from: Ultimate Truth #7 — Work Stream 6;
│    Agile SOPs 2.4-2.5; Effective Execution principles)
│   ══════════════════════════════════════════════════════════════
│
├── 3-EXECUTE/
│   │
│   ├── README.md                     # Purpose of this zone + checklist
│   │                                 # "Every file here must trace back to a
│   │                                 #  requirement in 1-ALIGN/ and a risk
│   │                                 #  consideration in 2-PLAN/."
│   │
│   ├── src/                          # SOURCE CODE (The Primary Execution Artifact)
│   │   ├── core/                     # Core business logic
│   │   ├── ui/                       # User interface layer
│   │   ├── api/                      # API / integration layer
│   │   ├── infra/                    # Infrastructure-as-code
│   │   └── shared/                   # Shared utilities, types, constants
│   │
│   ├── tests/                        # TEST SUITES (Risk Management in Execution)
│   │   │                             # Tests ARE risk management — each test
│   │   │                             # disables a specific failure mode.
│   │   │                             # (Derived from: UT#5 — manage risks > maximize output)
│   │   ├── unit/                     # Component-level risk gates
│   │   ├── integration/              # Interface-level risk gates
│   │   ├── e2e/                      # System-level risk gates (Playwright)
│   │   └── quality-gates/            # 3-pillar validation scripts:
│   │       ├── sustainability.md     # "Does it handle failure gracefully?"
│   │       ├── efficiency.md         # "Does it use resources wisely?"
│   │       └── scalability.md        # "Does it hold at 10× load?"
│   │                                 # (Derived from: Derived Truth #1 — 3 Pillars)
│   │
│   ├── config/                       # CONFIGURATION (EOE — Operating Environment)
│   │   ├── env/                      # Environment-specific configs
│   │   │   ├── .env.development
│   │   │   ├── .env.staging
│   │   │   └── .env.production
│   │   ├── security/                 # Security configs following LTC hierarchy:
│   │   │   └── SECURITY_POLICY.md    # YubiKey > Proton Pass > etc.
│   │   │                             # (Derived from: Wiki — Security Setup)
│   │   └── ci-cd/                    # Pipeline definitions
│   │       └── PIPELINE.md           # Build → Test → Gate → Deploy
│   │                                 # Each stage maps to a risk check
│   │
│   └── docs/                         # TECHNICAL DOCUMENTATION
│       ├── api/                      # API documentation
│       ├── runbooks/                 # Operational runbooks (EOP artifacts)
│       └── onboarding/              # New contributor guide
│                                     # (Derived from: Wiki KPI — "Average Time
│                                     #  for New User Onboarding")
│
│   ══════════════════════════════════════════════════════════════
│   ZONE 4 — IMPROVE (Learn, Reflect, Institutionalize)
│   "What worked? What didn't? How do we make it stick?"
│   Continuous: All 6 Work Streams feed back here
│   (Derived from: Ultimate Truth #10 — Continuous Improvement;
│    Agile SOPs 2.6-2.7; Step 6 Consolidate & Institutionalize)
│   ══════════════════════════════════════════════════════════════
│
├── 4-IMPROVE/
│   │
│   ├── README.md                     # Purpose of this zone + checklist
│   │                                 # "Nothing ships without a review.
│   │                                 #  Nothing improves without a retrospective."
│   │
│   ├── reviews/                      # SPRINT/EXECUTION REVIEWS
│   │   └── REVIEW_TEMPLATE.md        # Goal Recap → Demo of Done Work →
│   │                                 # Stakeholder Feedback → Gap Analysis →
│   │                                 # Next Steps
│   │                                 # (Derived from: Agile SOP 2.6 Sprint Review)
│   │
│   ├── retrospectives/               # TEAM REFLECTION & IMPROVEMENT
│   │   └── RETRO_TEMPLATE.md         # What worked? → What needs improvement? →
│   │                                 # Improvement opportunities → Action items
│   │                                 # (Derived from: Agile SOP 2.7 Retrospective)
│   │
│   ├── risk-log/                     # LIVING RISK LOG
│   │   ├── RISK_EVENTS.md            # Risks that materialized — what happened,
│   │   │                             # how was it handled, what to change
│   │   └── NEAR_MISSES.md            # Risks that almost materialized — early
│   │                                 # warning signals to watch for
│   │                                 # (Derived from: UT#5 — risk management emphasis)
│   │
│   ├── metrics/                      # EFFECTIVENESS METRICS
│   │   └── DASHBOARD.md              # KPIs organized by 3 pillars:
│   │                                 # Sustainability: Error rates, recovery time,
│   │                                 #   documented processes %
│   │                                 # Efficiency: Cycle time, resource utilization,
│   │                                 #   automation coverage
│   │                                 # Scalability: Load test results, template
│   │                                 #   adoption rate, onboarding time
│   │                                 # (Derived from: Wiki KPI design standards)
│   │
│   └── changelog/                    # VERSION HISTORY & INSTITUTIONALIZATION
│       ├── CHANGELOG.md              # What changed, when, why, by whom
│       └── INSTITUTIONALIZED.md      # Improvements that have been embedded into
│                                     # SOPs, templates, agent rules, or CI/CD
│                                     # (Derived from: Step 6 — Grounding + Sustaining)
│
│   ══════════════════════════════════════════════════════════════
│   _SHARED — THE ORGANIZATIONAL KNOWLEDGE BASE
│   "The collective UDS of the organization"
│   (Derived from: Ultimate Truth #8 — Org UDS = Collective
│    Logical & Analytical Reasoning)
│   ══════════════════════════════════════════════════════════════
│
├── _shared/
│   │
│   ├── brand/                        # LTC BRAND IDENTITY (Layer 3 Rules)
│   │   ├── BRAND_GUIDE.md            # Colors, typography, tone standards
│   │   ├── colors.json               # Machine-readable color definitions
│   │   │                             # {
│   │   │                             #   "primary": "#004851",     // Midnight Green
│   │   │                             #   "secondary": "#F2C75C",   // Gold
│   │   │                             #   "accent1_ruby": "#9B1842",
│   │   │                             #   "accent2_green": "#69994D",
│   │   │                             #   "accent3_purple": "#653469",
│   │   │                             #   "accent4_pink": "#E87299",
│   │   │                             #   "accent5_orange": "#FF9D3B",
│   │   │                             #   "text_dark": "#1D1F2A",
│   │   │                             #   "text_light": "#FFFFFF",
│   │   │                             #   "bg_light2": "#B7DDE1",
│   │   │                             #   "neutral_gray": "#787B86",
│   │   │                             #   "neutral_silver": "#B2B5BE"
│   │   │                             # }
│   │   ├── TYPOGRAPHY.md             # Tenorite, 50/20/16/12pt hierarchy
│   │   ├── function-colors.json      # Per-function color mapping (12 functions)
│   │   └── assets/                   # Logo files, theme files (.thmx)
│   │
│   ├── security/                     # LTC SECURITY STANDARDS
│   │   ├── SECURITY_HIERARCHY.md     # Auth: YubiKey > YubiKey Auth > Proton Pass
│   │   │                             # Storage: Synology > Proton Drive > Google Drive
│   │   │                             # Comms: ClickUp Chat > Threema > Signal
│   │   │                             # (Derived from: Wiki — Security Setup)
│   │   ├── DATA_CLASSIFICATION.md    # RESTRICTED / CONFIDENTIAL / INTERNAL /
│   │   │                             # EXTERNAL / PERSONAL
│   │   └── NAMING_CONVENTION.md      # [CLASSIFICATION]_[GROUP]_[MEMBER]_ID. NAME
│   │                                 # (Derived from: Wiki — Naming System)
│   │
│   ├── frameworks/                   # LTC PROPRIETARY FRAMEWORKS
│   │   ├── UBS_UDS_GUIDE.md          # How to identify blockers and drivers
│   │   ├── EFFECTIVE_SYSTEM.md       # 7-component model: EU,EA,EO,EP,EOE,EOT,EOP
│   │   ├── THREE_PILLARS.md          # Sustainability, Efficiency, Scalability
│   │   ├── SIX_WORKSTREAMS.md        # Align, Risk, Learn, Think, Decide, Execute
│   │   ├── CRITICAL_THINKING.md      # Hypothesis + Premises + Reasoning → Conclusion
│   │   │                             # Deduction > Abduction > Induction preference
│   │   │                             # (Derived from: Wiki — Critical Thinking)
│   │   ├── LEARNING_HIERARCHY.md     # Facts → Information → Wisdom → Expertise
│   │   │                             # Knowledge: So What? What? What Else? How?
│   │   │                             # Understanding: Why? Why Not?
│   │   │                             # Wisdom: So What? Now What?
│   │   │                             # Expertise: What Not? How Not? What If? Now What?
│   │   │                             # (Derived from: Wiki — Effective Learning)
│   │   ├── COGNITIVE_BIASES.md       # Availability, Representativeness, Anchoring,
│   │   │                             # Affect, Confirmation — with defenses
│   │   │                             # (Derived from: Wiki — UBS of Human Thinking)
│   │   └── DOCUMENT_STANDARDS.md     # 4 truths: reduce cognitive load, establish
│   │                                 # credibility, convey clear message, ensure
│   │                                 # maintainability. 5 principles: clear hierarchy,
│   │                                 # 60-30-10 color, consistent patterns, grouped
│   │                                 # proximity, negative space
│   │                                 # (Derived from: Wiki — Standard Document Guideline)
│   │
│   ├── templates/                    # REUSABLE TEMPLATES
│   │   ├── ADR_TEMPLATE.md           # Architecture Decision Record
│   │   ├── SPIKE_TEMPLATE.md         # Technical investigation
│   │   ├── RESEARCH_TEMPLATE.md      # CODE-structured learning artifact
│   │   ├── REVIEW_TEMPLATE.md        # Sprint review
│   │   ├── RETRO_TEMPLATE.md         # Retrospective
│   │   ├── WIKI_PAGE_TEMPLATE.md     # 7-section wiki standard
│   │   ├── SOP_TEMPLATE.md           # 7-section SOP standard
│   │   ├── RISK_ENTRY_TEMPLATE.md    # UBS register entry
│   │   └── STANDUP_TEMPLATE.md       # Done / WIP / Blocker format
│   │                                 # (Derived from: Agile SOP 2.5 Standups)
│   │
│   └── sops/                         # STANDARD OPERATING PROCEDURES
│       ├── DISCUSSION_SOP.md         # How to discuss: premises > opinions,
│       │                             # psychological safety, two-vote system
│       │                             # (Derived from: Wiki — Discussion SOP)
│       ├── CODE_REVIEW_SOP.md        # Review checklist against 3 pillars
│       └── DEPLOYMENT_SOP.md         # Gate → Stage → Validate → Release
│
│   ══════════════════════════════════════════════════════════════
│   ROOT CONFIGURATION FILES
│   ══════════════════════════════════════════════════════════════
│
├── package.json                      # (or pyproject.toml, go.mod, etc.)
├── tsconfig.json                     # (if TypeScript)
├── .gitignore
├── .env.example                      # Template — never commit real secrets
└── README.md                         # Project overview + quickstart
                                      # Links to 1-ALIGN/charter/ for context
```

* * *

## WHY THIS STRUCTURE WORKS: TRACING THE KEY IDEAS

### 1\. Success = Efficient & Scalable Management of Failure Risks (UT#5)

Risk management is not a folder — it is **woven through every zone**:

| Zone | How Risk Management Manifests |
| ---| --- |
| 0-Agent Config | Rules that force the AI to identify UBS before coding (Meta-Rule M-02) |
| 1-ALIGN | Requirements decomposition prevents building the wrong thing (the #1 risk) |
| 2-PLAN | Dedicated `risks/` directory with UBS register — risks are first-class citizens, not afterthoughts |
| 3-EXECUTE | `tests/` are reframed as risk gates; `quality-gates/` check the 3 pillars explicitly |
| 4-IMPROVE | `risk-log/` tracks what actually happened vs. what was predicted; `near-misses/` catches early warnings |

This means every phase asks: _"What failure are we preventing right now?"_ — not just _"What feature are we building?"_

### 2\. The Four Key Areas: ALIGN → PLAN → EXECUTE → IMPROVE

These map directly to LTC's ClickUp action types and the agile execution framework:

| Zone | LTC Action Type | Agile Events | Work Streams |
| ---| ---| ---| --- |
| 1-ALIGN | ALIGN | Alignment Meeting, OKR Planning | WS1: Alignment |
| 2-PLAN | PLAN | Master Planning, Sprint Planning | WS2: Risk, WS3: Learning, WS4: Thinking, WS5: Decisions |
| 3-EXECUTE | EXECUTE | Daily Standups, Sprint Execution | WS6: Execution |
| 4-IMPROVE | IMPROVE | Sprint Review, Retrospective | All 6 (feedback loop) |

The numbering (1-4) suggests a flow, but per Ultimate Truth #10, these run concurrently. A developer might update `4-IMPROVE/risk-log/` in the middle of execution, or revisit `1-ALIGN/charter/` after learning something new in `2-PLAN/learning/`.

### 3\. The 7-Component Effective System Model

The folder structure maps to all seven components:

| Component | Where It Lives |
| ---| --- |
| EU (Effective User) | `1-ALIGN/charter/STAKEHOLDERS.md` — who is the user and what do they need |
| EA (Effective Actions) | `3-EXECUTE/src/` — the actual code/work |
| EO (Effective Outcomes) | `1-ALIGN/okrs/` — measurable success definitions |
| EP (Effective Principles) | Zone 0 agent configs + `_shared/frameworks/` — governing rules |
| EOE (Effective Environment) | `3-EXECUTE/config/` + `_shared/security/` — the operating environment |
| EOT (Effective Tools) | `.claude/`, `.gemini/`, `.mcp/` — the AI toolchain itself |
| EOP (Effective Procedure) | `_shared/sops/` + `_shared/templates/` — standardized procedures |

### 4\. The Three Pillars at Every Level

Every zone's README checklist should include the three-pillar check:

```markdown
## Pre-Flight Checklist (Derived from: Derived Truth #1)

### Sustainability — Does it manage failure risks?
- [ ] Failure modes identified and mitigated (see 2-PLAN/risks/)
- [ ] Graceful degradation paths defined
- [ ] No single points of failure

### Efficiency — Does it minimize waste?
- [ ] No redundant code, data, or process steps
- [ ] Optimal resource utilization
- [ ] Leanest path to the required quality

### Scalability — Does it handle growth?
- [ ] No hardcoded assumptions that break at scale
- [ ] Tested at 3× expected load
- [ ] Designed for the next order of magnitude
```

### 5\. Critical Thinking Embedded in Planning

The `2-PLAN/learning/spikes/` directory uses the critical thinking model:

```markdown
# SPIKE: [Title]

## Hypothesis (The Problem Statement)
> Situation: Who does what to whom, when, where, how, why?
> Complication: What breaks, fails, or is unknown?

## Premises
> Truths (verified): ...
> Assumptions (to test): ...
> Facts (observations): ...

## Reasoning Method
> [ ] Deduction (general truth → specific conclusion) — PREFERRED
> [ ] Abduction (observations → best explanation) — ACCEPTABLE
> [ ] Induction (observations → generalization) — USE WITH CAUTION

## Conclusion & Decision
> What did we learn? What do we do now?

## Bias Check (Derived from: UT#6)
> [ ] Confirmation bias: Did I seek disconfirming evidence?
> [ ] Anchoring: Am I over-weighting the first data point?
> [ ] Availability: Am I over-weighting recent/vivid information?
```

### 6\. Learning Hierarchy in Research

The `2-PLAN/learning/research/` template follows the brain's natural learning flow:

```markdown
# Research: [Topic]

## Knowledge Level
1. **So What?** — Why is this important for our project?
2. **What is it?** — Definition and scope
3. **What else?** — Related concepts and alternatives
4. **How does it work?** — Mechanisms and processes

## Understanding Level
5. **Why does it work?** — Underlying principles
6. **Why not?** — When and why does it fail?

## Wisdom Level
7. **So What?** — How can we benefit from this?
8. **Now What?** — What should we do next?

## Expertise Level (Optional — for deep dives)
9. **What is it NOT?** — Common misconceptions
10. **How does it NOT work?** — Anti-patterns
11. **What If?** — Alternatives if this fails
12. **Now What?** — How can we do better than others?
```

### 7\. The `_shared/` Directory as Organizational UDS

Ultimate Truth #8 states that the UDS of an organization is its _collective logical & analytical reasoning capability_. The `_shared/` directory IS that collective intelligence — it persists across projects, accumulates institutional knowledge, and prevents each project from reinventing LTC's frameworks.

Every project links to `_shared/` but never modifies it directly. Changes to shared knowledge go through the `4-IMPROVE/` → `_shared/` promotion pipeline, mirroring the Grounding → Sustaining institutionalization pattern from the Change Management framework.
* * *

## AGENT CONFIGURATION: WHAT GOES IN [CLAUDE.md](http://CLAUDE.md) AND [AGENTS.md](http://AGENTS.md)

### [CLAUDE.md](http://CLAUDE.md) (Claude Code)

```markdown
# Project Instructions for Claude Code

## Identity
You are an AI coding agent working within LTC Capital Partners' development
environment. Your work is governed by LTC's Effective Systems methodology.

## Before Every Task — The Pre-Flight Protocol
1. CHECK ALIGNMENT: Read `1-ALIGN/charter/` to confirm you understand
   the project's purpose and stakeholder needs. (Work Stream 1)
2. CHECK RISKS: Read `2-PLAN/risks/UBS_REGISTER.md` to identify what
   can go wrong with this specific task. (Work Stream 2)
3. CHECK DRIVERS: Read `2-PLAN/drivers/UDS_REGISTER.md` to identify
   what you can leverage. (Work Stream 3)
4. EXECUTE with the three pillars in mind:
   - Sustainability: Handle errors gracefully. Write tests.
   - Efficiency: Minimal code for maximum clarity.
   - Scalability: No magic numbers. No hardcoded limits.
5. DOCUMENT decisions in `1-ALIGN/decisions/` when making
   non-trivial architectural choices.

## Quality Standards
- Every file traces to a requirement in `1-ALIGN/`
- Every test traces to a risk in `2-PLAN/risks/`
- Brand: LTC Midnight Green #004851, LTC Gold #F2C75C
- Typography: Tenorite, hierarchy 50/20/16/12pt
- See `_shared/brand/` for full standards

## Risk Management is Your Primary Job
Success ≠ writing more code faster.
Success = optimal value creation with minimal failure risk.
When in doubt, add a test before adding a feature.
```

### [AGENTS.md](http://AGENTS.md) (Antigravity)

```markdown
# Agent Configuration — Antigravity

## Priority Order
1. AGENTS.md (this file)
2. GEMINI.md
3. .gemini/antigravity/brain/

## Core Behavioral Rules
- ALWAYS read `2-PLAN/risks/` before generating code
- ALWAYS check `1-ALIGN/charter/REQUIREMENTS.md` before implementing
- ALWAYS run `3-EXECUTE/tests/quality-gates/` after significant changes
- NEVER skip the three-pillar validation
- NEVER introduce dependencies without an ADR in `1-ALIGN/decisions/`

## LTC Frameworks (see `_shared/frameworks/` for details)
- UBS/UDS: Identify blockers and drivers before acting
- 3 Pillars: Sustainability > Efficiency > Scalability
- 6 Work Streams: Run concurrently, not sequentially
- Critical Thinking: Hypothesis + Premises + Reasoning → Conclusion
```

* * *

## QUICK SETUP COMMAND

To scaffold this structure for a new project, run:

```bash
#!/bin/bash
# LTC Project Scaffold — v1.0
# Usage: bash scaffold.sh <project-name>

PROJECT_NAME=${1:-"new-project"}
mkdir -p "$PROJECT_NAME"/{.claude,.gemini/antigravity/brain,.mcp}
mkdir -p "$PROJECT_NAME"/1-ALIGN/{charter,okrs,decisions}
mkdir -p "$PROJECT_NAME"/2-PLAN/{risks,drivers,learning/{research,spikes},architecture/{diagrams,ADRs},roadmap}
mkdir -p "$PROJECT_NAME"/3-EXECUTE/{src/{core,ui,api,infra,shared},tests/{unit,integration,e2e,quality-gates},config/{env,security,ci-cd},docs/{api,runbooks,onboarding}}
mkdir -p "$PROJECT_NAME"/4-IMPROVE/{reviews,retrospectives,risk-log,metrics,changelog}
mkdir -p "$PROJECT_NAME"/_shared/{brand/assets,security,frameworks,templates,sops}

echo "# $PROJECT_NAME" > "$PROJECT_NAME/README.md"
echo "✅ LTC project structure created at ./$PROJECT_NAME"
```

* * *

_This structure is a living system. As LTC's frameworks evolve, update_ _`_shared/`_ _and let improvements flow through the IMPROVE → ALIGN feedback loop. The structure itself should be subject to retrospective review._

**Document Classification:** INTERNAL
**Owner:** Corporate Development / Investment Technology
**Last Updated:** 2026-03-22

# README — Project Template Guide

# LTC Project Template

Standard project scaffold for LT Capital Partners. Use this template to start any new project with LTC's global rules, safety guardrails, and AI agent configuration pre-loaded.

**GitHub:** [https://github.com/Long-Term-Capital-Partners/OPS\_OE.6.4.LTC-PROJECT-TEMPLATE](https://github.com/Long-Term-Capital-Partners/OPS_OE.6.4.LTC-PROJECT-TEMPLATE)
* * *

## Quick Start

### 1\. Create your project from this template

**On GitHub:** Click the green **"Use this template"** button at the top of the repo. Choose the owner, name your project using LTC naming convention, and click "Create repository."

**From CLI:**

```kotlin
gh repo create Long-Term-Capital-Partners/{YOUR_PROJECT_NAME} \
  --template Long-Term-Capital-Partners/OPS_OE.6.4.LTC-PROJECT-TEMPLATE
```

### 2\. Clone and configure

```bash
git clone https://github.com/Long-Term-Capital-Partners/{YOUR_PROJECT_NAME}.git
cd {YOUR_PROJECT_NAME}
```

### 3\. Customize these files (in this order)

| Step | File | What to do |
| ---| ---| --- |
| 1 | `.claude/settings.json` | Review deny/allow rules. Add project-specific permissions. This is your safety net — configure it first. |
| 2 | `.gitignore` | Add any project-specific exclusions (credentials, data files, etc.) |
| 3 | `CLAUDE.md` | Replace all `{placeholders}` with your project details. Keep under 80 lines. |
| 4 | `GEMINI.md` | Replace all `{placeholders}` — same structure as [CLAUDE.md](http://CLAUDE.md) but for AntiGravity. Keep in sync. |
| 5 | `.mcp.json` | Add MCP server connections if your project uses external tools. |
| 6 | `.claude/rules/` | Delete the example rule. Add path-scoped rules for your codebase. |
| 7 | `.claude/skills/` | Add project-specific skills (on-demand procedures). |
| — | `.cursor/rules/`, `.agents/rules/` | Already configured with brand identity and security. Add more rules as needed. |

### 4\. Set up security (one-time per clone)

```sql
pip install pre-commit   # or: brew install pre-commit
pre-commit install
pre-commit run --all-files   # verify
```

### 5\. Start working

```bash
claude   # Opens Claude Code with CLAUDE.md auto-loaded
```

Or open the project in AntiGravity / Cursor — each IDE loads its own rules automatically.
* * *

## What's Included

```php
.                                                    7-CS Component
├── CLAUDE.md                  # Claude Code rules     ← EPS (always-active constitution)
├── GEMINI.md                  # AntiGravity rules     ← EPS (always-active constitution)
├── .claude/
│   ├── settings.json          # Safety deny/allow     ← Environment (hard ceilings)
│   ├── settings.local.json.example  # Personal overrides  ← Environment (per-user)
│   ├── agents/                # Subagent definitions   ← Agent (operator config)
│   ├── commands/              # Slash commands         ← EOP (on-demand procedures)
│   ├── hooks/                 # Event-driven scripts   ← Environment (automation)
│   ├── rules/                 # Path-scoped rules      ← EPS (modular, on-demand)
│   └── skills/                # On-demand procedures   ← EOP (reusable playbooks)
├── .cursor/rules/
│   ├── brand-identity.md     # Cursor brand rules     ← EPS (tool-specific)
│   └── security.md           # Cursor security rules   ← EPS (tool-specific)
├── .agents/rules/
│   ├── brand-identity.md     # AntiGravity rules      ← EPS (tool-specific)
│   └── security.md           # AntiGravity security    ← EPS (tool-specific)
├── .pre-commit-config.yaml    # gitleaks hook config    ← Environment (hard gate)
├── .gitleaks.toml             # Secret detection rules  ← Environment (hard gate)
├── rules/
│   ├── brand-identity.md     # Full 20-color ref      ← EPS (global reference)
│   ├── naming-rules.md       # UNG full spec          ← EPS (global reference)
│   └── security-rules.md     # 3-layer security ref   ← EPS (global reference)
├── src/                       # Application code       ← Input (task context)
├── docs/                      # Reference docs         ← Input (knowledge base)
├── scripts/                   # Build/deploy utils     ← Tools (extend agent capability)
├── tests/                     # Test suites            ← EOP (verification gates)
├── .gitignore                 # Excluded files         ← Environment (safety boundary)
└── .mcp.json                  # MCP server connections ← Tools (external integrations)
```

**7-CS** = The Agent's 7-Component System (Doc-9). Each file maps to a component:
**EPS** constrains behavior | **EOP** defines procedures | **Environment** sets hard limits |
> **Tools** extend capability | **Input** provides context | **Agent** executes within all of the above.
* * *

## LTC Global Rules

The `rules/` folder contains LTC-wide standards that apply to all projects:

| Rule File | What it covers | Status |
| ---| ---| --- |
| `brand-identity.md` | Colors (20-color palette), typography (Tenorite/Work Sans), logo usage, function color assignments, MS Office theme | Active |
| `naming-rules.md` | Universal Naming Grammar (UNG) — canonical key pattern, 75 SCOPE codes, platform rendering (Git, Local, ClickUp, Drive), validation regex | Active |
| `security-rules.md` | 3-layer defense-in-depth: 6 AI agent security rules, risk tiers, secret detection (gitleaks), gap analysis, setup guide | Active |
| `effective-system.md` | Desired outcomes, UBS/UDS framework, effective principles | Coming soon |

### How rules reach each tool

Each tool reads **different files** at session start. There is no single file all tools share.

| Tool | Primary rules file | Brand + Security source | Loading |
| ---| ---| ---| --- |
| Claude Code (CLI) | `CLAUDE.md` | Distilled in [CLAUDE.md](http://CLAUDE.md) (brand, naming, security) | Auto-loaded every session |
| AntiGravity (IDE) | `GEMINI.md` | Distilled in [GEMINI.md](http://GEMINI.md) (brand, naming, security) | Auto-loaded every session |
| Cursor (IDE) | `.cursor/rules/` | `.cursor/rules/brand-identity.md`, `security.md` | Auto-loads matching globs |
| All tools | `rules/` | Full references: brand-identity, naming-rules, security-rules | On demand |
| Pre-commit | `.pre-commit-config.yaml` | `.gitleaks.toml` (secret detection) | Runs on every `git commit` |

* * *

## Safety Model

The template enforces a three-layer defense-in-depth model:

*   **Layer 1 — Structural** (`.gitignore`): Passive defense. Secrets, key files, and backup directories are excluded by path. Cannot be accidentally committed.
*   **Layer 2 — Agent EPS** (`CLAUDE.md`, `GEMINI.md`, `.cursor/rules/`, `.agents/rules/`): Constitutional rules the agent self-enforces — security, brand identity, naming conventions. Broad coverage, probabilistic enforcement (~80% compliance).
*   **Layer 3 — Hard Gate** (`.pre-commit-config.yaml` + `.gitleaks.toml`): Deterministic. gitleaks blocks any commit containing detected secrets. Cannot be bypassed without explicit allowlist entry.

Additionally, `.claude/settings.json` provides platform-level deny/allow rules the agent physically cannot bypass. Configure it first — it is your safety net.

See the **Security Rules** page in this document for the full reference.
* * *

## Naming Convention

All LTC repos follow the **Universal Naming Grammar (UNG):**

```plain
{SCOPE}_{FA}.{ID}.{NAME}
```

Example: `OPS_OE.6.4.LTC-PROJECT-TEMPLATE`

*   **SCOPE:** OPS (Operations)
*   **FA:** OE (Operational Excellence)
*   **ID:** 6.4
*   **NAME:** LTC-PROJECT-TEMPLATE

See the **Naming Rules** page in this document for the full UNG specification.
* * *

_Template maintained by OPS Process. Source:_ [_GitHub_](https://github.com/Long-Term-Capital-Partners/OPS_OE.6.4.LTC-PROJECT-TEMPLATE)

# Security Rules

# LTC Security Rules — AI Agent Reference

> Full reference for AI agent security behavior. Distilled rules are loaded via [CLAUDE.md](http://CLAUDE.md) / [GEMINI.md](http://GEMINI.md) / .cursor/rules/ / .agents/rules/. This file provides the rationale, examples, and setup instructions.

**Version:** 1.0 | **Date:** 2026-03-17 | **Task:** OPS\_-4215
**GitHub source:** `rules/security-rules.md`
* * *

## 1\. Purpose & Philosophy

**Security is more important than quality of work.** Clients may forgive subpar analysis. They will not forgive a data breach. This is LTC's foundational security principle.

**Zero tolerance for speed-over-security.** Compromising security to get things done quickly is a serious violation. The "Convenience Bias" — humans (and agents) defaulting to the path of least resistance — is the primary threat this system disables.

**Why agents need security rules:** LLM agents have structural limits that create security-relevant failure modes:

*   **LT-5 (Plausibility over truth):** The agent may embed a secret in code because it "looks helpful"
*   **LT-6 (No persistent memory):** The agent doesn't remember what was sensitive in a prior session
*   **LT-8 (Alignment approximate):** Under complex task pressure, the agent may drift from security rules

These are not bugs to be fixed. They are physics to be compensated for.
* * *

## 2\. The 3-Layer Defense-in-Depth Model

No single layer is sufficient. Each layer catches what the others miss.

```yaml
Layer 3: PRE-COMMIT HOOK (gitleaks)
  ├── Hard gate — blocks commits containing detected secrets
  ├── Catches: API keys, private keys, tokens, JWTs, connection strings, high-entropy strings
  └── Cannot catch: low-entropy secrets, PII, prompt leaks, classification violations

Layer 2: AGENT EPS (CLAUDE.md / GEMINI.md / .cursor/rules/ / .agents/rules/)
  ├── Always-loaded rules — agent self-enforces every session
  ├── Catches: secrets in prompts/output, PII, execution risk, blast radius, backup awareness
  └── Cannot catch: what LT-8 causes agent to miss under complex task pressure

Layer 1: STRUCTURAL CONVENTION (.gitignore + file conventions)
  ├── Passive defense — prevents accidental inclusion by path
  ├── Catches: .env, secrets/, .backup/, private keys by extension
  └── Cannot catch: secrets hardcoded in source files
```

**Key insight:** Layer 2 has the broadest coverage but probabilistic enforcement. Layer 3 has narrow coverage but deterministic enforcement. You need both.

### What the hook catches vs. what the agent must catch

| Threat | Hook (Layer 3) | Agent EPS (Layer 2) | Why |
| ---| ---| ---| --- |
| API keys (AWS, GCP, Anthropic, etc.) | Y | Y | Hook detects patterns; agent should not write them |
| Private keys (.pem, .key) | Y | Y | Hook + gitignore both block |
| Connection strings with credentials | Y | Y | Hook detects embedded passwords |
| High-entropy tokens (JWT, OAuth) | Y | Y | Hook flags unusual entropy |
| Low-entropy secrets (short passwords) | \- | Y | Too short for pattern detection |
| PII (names, emails, phone numbers) | \- | Y | Not a key pattern |
| Secrets in prompts or console output | \- | Y | Hook only runs on commits |
| Data classification violations | \- | Y | Semantic, not pattern-based |
| Outbound data exfiltration via API calls | \- | Y | No commit involved |

* * *

## 3\. The 6 Security Rules

### Rule 1: Limit Blast Radius

For destructive or experimental operations, prefer git worktrees or branches. Never operate directly on main for risky work.

**Compliant:** Feature branch before experimental changes. `git worktree` for isolation. Stay within project directory.
**Non-compliant:** Force-push to main. Modify files outside project. Destructive commands on main.

### Rule 2: Risk-Tiered User Review

| Tier | Actions | Agent Behavior |
| ---| ---| --- |
| LOW | Read files, search, lint, run tests | Proceed without confirmation |
| MEDIUM | Edit files, git commit, install packages | Proceed — user can review via diff |
| HIGH | Delete, push, force, deploy, CI/CD, .env/secrets/, DB writes | ALWAYS require explicit confirmation |

### Rule 3: No Secrets in Source, Prompts, or Output

NEVER hardcode secrets in source code, prompts, or tool arguments. All secrets in `.env` or `secrets/` only.

### Rule 4: Self-Check for Leaked Sensitive Information

Before completing any task, review output for secret patterns (API keys, tokens, passwords, PII). If found — stop, redact, alert user. If already committed: don't rewrite history without approval, advise rotating the secret, identify the commit.

### Rule 5: Scoped Access

Stay within project directory. Confirm scope before accessing external resources. Never include secrets/PII in outbound API calls unless endpoint is explicitly authorized.

### Rule 6: Backup Awareness

Warn before overwriting untracked files. Never force-push without confirming remote state. Flag irreplaceable files before modifying.
* * *

## 4\. Traceability Matrix

| Rule | LT Compensated | LTC Wiki/SOP Source | Enforcing Layer(s) |
| ---| ---| ---| --- |
| 1\. Blast Radius | LT-8, LT-1 | Wiki: Zero Trust Architecture | Layer 2 |
| 2\. Risk-Tiered Review | LT-8, LT-3 | Wiki: Zero tolerance for speed-over-security | Layer 2 |
| 3\. No Secrets | LT-5, LT-8, LT-6 | Wiki Policy 3: No Public Sharing; Principle: Zero Trust | Layers 1, 2, 3 |
| 4\. Self-Check | LT-5, LT-8 | SOP: Incident Reporting; Principle: Ethics Above All | Layers 2, 3 |
| 5\. Scoped Access | LT-8, LT-1 | Principle: Least Privilege | Layer 2 |
| 6\. Backup Awareness | LT-6, LT-8 | SOP: Data loss risk | Layer 2 |

* * *

## 5\. Human Operator Guidance

*   **Git is the primary backup.** If it's not committed, it doesn't exist.
*   **Commit before modifying.** Anything not easily recreated should be committed first.
*   **`secrets/`** **requires separate backup.** Gitignored by design. Use encrypted means per LTC SOP.
*   **Incident response:** If a secret is committed and pushed, rotate immediately. Treat as compromised.
* * *

## 6\. Setup Instructions

### One-time setup (per clone)

```sql
pip install pre-commit   # or: brew install pre-commit
pre-commit install
pre-commit run --all-files   # verify
```

### Verifying the 3 layers

| Layer | How to verify |
| ---| --- |
| Layer 1 (Structural) | `git status` should not show `.env`, `secrets/`, or `*.pem` files |
| Layer 2 (Agent EPS) | Check that [CLAUDE.md/GEMINI.md](http://CLAUDE.md/GEMINI.md) contains the `## Security` section |
| Layer 3 (Hook) | `pre-commit run --all-files` should complete without errors |

# Brand Identity Rules

# LTC Brand Identity Rules

Source of truth: ClickUp Wiki — \[LTC ALL\]\_WIKI > 1. LTC's BRAND IDENTITY SYSTEM
> **GitHub source:** `rules/brand-identity.md`
* * *

## 1\. Logo

**Company name in logo:** LT Capital Partners

*   **Midnight Green version** — use on light backgrounds (Pantone 316C, #004851)
*   **Gold version** — use on dark backgrounds (Pantone 141C, #F2C75C)

## 2\. Primary Brand Colors

| LTC Color Name | Hex | Pantone | Role |
| ---| ---| ---| --- |
| LTC Midnight Green | #004851 | 316C | Dark primary |
| LTC Gold | #F2C75C | 141C | Accent primary |

## 3\. Full Palette (20 colors)

| LTC Color Name | Hex | Type |
| ---| ---| --- |
| LTC Ruby Red | #9B1842 | Official |
| LTC Orange | #FF9D3B | Official |
| LTC Gold | #F2C75C | Official — Primary accent |
| LTC Olive | #766A11 | Harmonized |
| LTC Lime | #5CF26A | Harmonized |
| LTC Green | #69994D | Official |
| LTC Midnight Green | #004851 | Official — Dark primary |
| LTC Cyan | #69C7CC | Official |
| LTC Blue | #244091 | Harmonized |
| LTC Navy | #253669 | Harmonized |
| LTC Dark Purple | #653469 | Official |
| LTC Purple | #9949B8 | Harmonized |
| LTC Fuchsia | #D75CF2 | Harmonized |
| LTC Red | #9A2C65 | Harmonized |
| LTC Dark Gunmetal | #1D1F2A | Official |
| LTC Gray | #787B86 | Neutral |
| LTC Silver | #B2B5BE | Neutral |
| LTC White | #FFFFFF | Neutral |
| LTC Powder Blue | #B7DDE1 | Official |
| LTC Pink | #E87299 | Official |

## 4\. Function Color Assignments

| # | Function | Color | Hex |
| ---| ---| ---| --- |
| 1 | Governance | Purple | #9949B8 |
| 2 | LTC ALL | Gold | #F2C75C |
| 3 | External Corp Affairs | Orange | #FF9D3B |
| 4 | Admins & Leaders | Ruby Red | #9B1842 |
| 5 | Management | Cyan | #69C7CC |
| 6 | Internal Operations | Midnight Green | #004851 |
| 7 | Business Development | Lime | #5CF26A |
| 8 | Client Service | Pink | #E87299 |
| 9 | Business Ventures | Green | #69994D |
| 10 | Investment | Dark Purple | #653469 |
| 11 | Business Technology | Blue | #244091 |
| 12 | Investment Technology | Navy | #253669 |

## 5\. MS Office Theme

| Slot | Role | Color | Hex |
| ---| ---| ---| --- |
| 1 | Light 1 | White | #FFFFFF |
| 2 | Dark 1 | Dark Gunmetal | #1D1F2A |
| 3 | Light 2 | Powder Blue | #B7DDE1 |
| 4 | Dark 2 | Midnight Green | #004851 |
| 5 | Accent 1 | Gold | #F2C75C |
| 6 | Accent 2 | Ruby Red | #9B1842 |
| 7 | Accent 3 | Green | #69994D |
| 8 | Accent 4 | Dark Purple | #653469 |
| 9 | Accent 5 | Pink | #E87299 |
| 10 | Accent 6 | Orange | #FF9D3B |

## 6\. Typography

*   **English:** Inter | **Vietnamese:** Inter
*   Headlines: 66pt (6x) | Sub-Title: 33pt (3x) | Body Title: ~18pt (1.6x) | Body: 11pt (base)
*   CSS fallback: `'Tenorite', 'Segoe UI', system-ui, sans-serif`

# Naming Rules (UNG)

# LTC Naming Rules (Universal Naming Grammar)
> Source of truth: OPS\_OE.6.0 docs/governance/LTC-UNIVERSAL-NAMING-GRAMMAR-v1.md Distilled for agent use. Load when creating named items on any platform. Last synced: 2026-03-22
* * *
## 1\. Canonical Key Pattern
Every LTC digital asset has a Canonical Key. The key has **two forms** depending on whether the item has a parent.
### 1a. Standard Form — 3-Part (item with parent)
This is the **default**. Most items exist within a parent context.

```plain
{SCOPE}_{PARENT_ID}.{PARENT_NAME}_{ITEM_ID}.{ITEM_NAME}
```

The 3 parts:
1. **SCOPE** — organizational scope (from Table 3a)
2. **PARENT** — parent's ID + name (establishes context)
3. **ITEM** — this item's ID + name (the leaf)
Example: `OPS_OE.6.4.LTC-PROJECT-TEMPLATE_D1.FOUNDATION`
*   SCOPE: `OPS`
*   PARENT: `OE.6.4.LTC-PROJECT-TEMPLATE` (the project)
*   ITEM: [`D1.FOUNDATION`](http://D1.FOUNDATION) (deliverable 1)
### 1b. Short Form — 2-Part (top-level item, no parent)
Only for items that have **no parent** within the naming scope (e.g., Git repos, top-level ClickUp projects, root Drive folders).

```plain
{SCOPE}_{FA}.{ID}.{NAME}
```

Example: `OPS_OE.6.4.LTC-PROJECT-TEMPLATE`
*   SCOPE: `OPS`
*   ITEM: `OE.6.4.LTC-PROJECT-TEMPLATE`
### Separator Grammar
*   `_` = boundary separator (between SCOPE and PARENT; between PARENT and ITEM)
*   `.` = numeric hierarchy (between numbers; between last number and NAME)
*   `-` = word join within NAME
### Parsing Rules
**2-Part (no** **`_`** **after SCOPE+FA segment):**
1. Split on first `_` after SCOPE (try longest matching SCOPE from Table 3a first)
2. Next segment before `.` = FA
3. Consecutive numeric `.`\-separated segments = ID
4. Everything after last number `.` = NAME
**3-Part (second** **`_`** **present after PARENT\_NAME):**
1. First `_` after SCOPE → start of PARENT segment
2. Second `_` after PARENT\_NAME → start of ITEM segment
3. Each segment follows the `{ID}.{NAME}` pattern
**Agent rule:** Always try the longest matching SCOPE from Table 3a first. `COE_EFF` matches before `COE`. No algorithmic derivation — use the lookup table.
**Agent rule:** Default to 3-part naming. Only use 2-part when the item genuinely has no parent in the naming context.
* * *
## 2\. Where UNG Applies

| Platform | Named Items | Form | UNG Applies? |
| ---| ---| ---| --- |
| Git / GitHub | Repos | 2-part | Full UNG. Canonical Key as-is. Max 50 chars. |
| Local filesystem | Folders | 2-part | Full UNG. Canonical Key + trailing slash. |
| ClickUp — PJ Project | Top-level project | 2-part | `[GROUP]_FA.ID. NAME` |
| ClickUp — PJ Deliverable | Deliverable under project | 3-part | `[GROUP]_FA.ID. PROJECT NAME_D{n}. DELIVERABLE NAME` |
| ClickUp — Task and below | Task, Increment, Blocker, Documentation, etc. | Free text | No UNG prefix. Free text. |
| Google Drive | Folders, files | 2-part or 3-part | Full UNG with optional decorators (classification, member, version). |

**Not governed by UNG:** Learning Book page filenames inside repos (those use `BOOK-NN --` prefix convention).
* * *
## 3\. Platform Rendering Rules
### Git / GitHub
*   Format: Canonical Key as-is. ALL CAPS. No spaces, no brackets.
*   Max length: **50 characters**.
*   Abbreviation (if over 50 chars): shorten NAME words first (e.g. `OPERATING-SYSTEM-DESIGN` -> `OSD`), then abbreviate ORG segment. NEVER abbreviate SCOPE, FA, or ID.
### Local Filesystem
*   Format: Canonical Key + trailing `/`.
*   Max length: 255 (OS limit). ALL CAPS. No spaces, no brackets.
### ClickUp
**PJ Project (2-part, top-level):**

```cs
[GROUP DISPLAY]_FA.ID. PROJECT NAME
```

**PJ Deliverable (3-part, child of project):**

```cs
[GROUP DISPLAY]_FA.ID. PROJECT NAME_D{n}. DELIVERABLE NAME
```

**Task and below:** Free text. No UNG prefix.
**Examples:**

```yaml
PJ Project:     [OPS]_OE.6.4. LTC Project Template
PJ Deliverable: [OPS]_OE.6.4. LTC Project Template_D1. Foundation
PJ Deliverable: [OPS]_OE.6.4. LTC Project Template_D5. CLI
Task:           Core Commands
PJ Increment:   Embedder Interface + Local Backend
PJ Documentation: Storage Layer Reference
```

**Canonical -> ClickUp:**
1. Look up SCOPE in Table 3a -> get ClickUp Display name (e.g. `INVTECH` -> `INV TECH`)
2. Wrap in brackets: `[INV TECH]`
3. For 2-part (PJ Project): Append `_FA.ID.` (dot-space before NAME). NAME: replace hyphens with spaces.
4. For 3-part (PJ Deliverable): Append `_FA.ID. PARENT NAME_ITEM_ID. ITEM NAME`. Both NAMEs: replace hyphens with spaces.
**ClickUp -> Canonical:**
1. Strip brackets from group -> look up in Table 3a -> get SCOPE code
2. FA code stays as-is
3. ID numbers stay as-is
4. All NAMEs: spaces -> hyphens
5. If `_` separates parent and item segments, preserve as 3-part canonical key
### Google Drive
*   Same bracket format as ClickUp, plus optional decorators:
    *   Classification prefix: `[RESTRICTED]_`, `[CONFIDENTIAL]_`, `[EXT]_`
    *   Member owner: `[LONG N.]_`, `[TINA N.]_`
    *   Version/status/date suffixes: `vFINAL`, `REVIEWED`, `20260303`
*   `AND` in names may render as `&` on Drive (cosmetic).
*   Item names may use Title Case instead of ALL CAPS.
* * *
## 4\. Table 3a: SCOPE Codes
### Governance

| ClickUp Display | Git SCOPE | Full Name |
| ---| ---| --- |
| `[GOV BOD]` | `GOV_BOD` | LTC Board of Directors |
| `[GOV IC]` | `GOV_IC` | LTC Investment Committee |
| `[GOV COMPLIANCE]` | `GOV_COMPLIANCE` | LTC Compliance Committee |
| `[GOV CULTURE]` | `GOV_CULTURE` | LTC Culture & People Council |

### Center of Excellence (COE)

| ClickUp Display | Git SCOPE | Full Name |
| ---| ---| --- |
| `[COE]` | `COE` | Universal Capability Center |
| `[COE EFF]` | `COE_EFF` | Effective Excellence Area |
| `[COE DS]` | `COE_DS` | Data Science Excellence Area |
| `[COE TECH]` | `COE_TECH` | Technology Excellence Area |
| `[COE BIZ]` | `COE_BIZ` | Business Excellence Area |
| `[COE INV]` | `COE_INV` | Investment Excellence Area |
| `[COE WELLBEING]` | `COE_WELLBEING` | Wellbeing Excellence Area |
| `[COE FUN]` | `COE_FUN` | Fun & Culture Excellence Area |
| `[COE LEADERSHIP]` | `COE_LEADERSHIP` | Leadership Excellence Area |
| `[COE ALL]` | `COE_ALL` | All COE Members |
| `[COE SHARED]` | `COE_SHARED` | Shared COE Accounts |
| `[MGT COE]` | `MGT_COE` | Head of Center of Excellence |

### Management

| ClickUp Display | Git SCOPE | Full Name |
| ---| ---| --- |
| `[MGT]` | `MGT` | Management Function |
| `[MGT FOUNDERS]` | `MGT_FOUNDERS` | Founders |
| `[MGT LEADERS]` | `MGT_LEADERS` | Leadership Team |
| `[MGT STRATEGY]` | `MGT_STRATEGY` | Strategy |
| `[MGT FIN]` | `MGT_FIN` | Finance Management |
| `[MGT HR]` | `MGT_HR` | HR Management |
| `[MGT IT]` | `MGT_IT` | IT Management |
| `[MGT IT SUPER]` | `MGT_ITSUPER` | IT Supervisory |
| `[MGT LEGAL]` | `MGT_LEGAL` | Legal Management |
| `[MGT PR]` | `MGT_PR` | PR Management |
| `[MGT IR]` | `MGT_IR` | IR Management |
| `[MGT IMPACT]` | `MGT_IMPACT` | Impact Management |
| `[MGT INFRA]` | `MGT_INFRA` | Infrastructure Management |
| `[MGT PROCESS]` | `MGT_PROCESS` | Process Management |

### Operations

| ClickUp Display | Git SCOPE | Full Name |
| ---| ---| --- |
| `[OPS]` | `OPS` | Internal Operations |
| `[OPS FIN]` | `OPS_FIN` | Finance Operations |
| `[OPS HR]` | `OPS_HR` | HR Operations |
| `[OPS IT]` | `OPS_IT` | IT Operations |
| `[OPS INFRA]` | `OPS_INFRA` | Infrastructure Operations |
| `[OPS PROCESS]` | `OPS_PROCESS` | Process Operations |
| `[OPERATIONS]` | `OPERATIONS` | Operations Function Group |

### Business / Investment

| ClickUp Display | Git SCOPE | Full Name |
| ---| ---| --- |
| `[INV]` | `INV` | Public Investment Function |
| `[INV TECH]` | `INVTECH` | Investment Technology |
| `[BIZ VEN]` | `BIZVEN` | Business Ventures |
| `[BIZ DEV]` | `BIZ_DEV` | Business Development |
| `[BIZ TECH]` | `BIZ_TECH` | Business Technology |

### Growth / Fulfillment / Innovation

| ClickUp Display | Git SCOPE | Full Name |
| ---| ---| --- |
| `[GROW]` | `GROW` | Growth Function Group |
| `[FULFILL]` | `FULFILL` | Fulfillment Function Group |
| `[INNO]` | `INNO` | Innovation Function Group |
| `[CI]` | `CI` | Customer Intimacy |
| `[CLIENT SERV]` | `CLIENT_SERV` | Client Services |

### Corporate

| ClickUp Display | Git SCOPE | Full Name |
| ---| ---| --- |
| `[CORP DEV]` | `CORP_DEV` | Corporate Development |
| `[CORP DEV IB]` | `CORP_DEVIB` | Corporate Dev - IB |
| `[CORP DEV IR]` | `CORP_DEVIR` | Corporate Dev - IR |
| `[CORP DEV MGT]` | `CORP_DEVMGT` | Corporate Dev - Management |
| `[CORP AFFAIRS]` | `CORP_AFFAIRS` | Corporate Affairs |
| `[CORP IMPACT]` | `CORP_IMPACT` | Corporate Impact |
| `[CORP LEGAL]` | `CORP_LEGAL` | Corporate Legal |
| `[CORP PR]` | `CORP_PR` | Corporate PR |
| `[CORP IR]` | `CORP_IR` | Corporate IR |

### Company-Wide / Shared

| ClickUp Display | Git SCOPE | Full Name |
| ---| ---| --- |
| `[LTC ALL]` | `LTC` | All LTC Members |
| `[LTC SHARED]` | `LTC_SHARED` | Shared Non-Workspace Accounts |
| `[LTC PROD]` | `LTC_PROD` | Shared Product Accounts |
| `[LTC COE]` | `LTC_COE` | LTC Center of Excellence (parent) |
| `[LTC GOV]` | `LTC_GOV` | LTC Governance (parent) |
| `[LTC LEADERS]` | `LTC_LEADERS` | LTC Leadership Group |
| `[LTC ALIGN]` | `LTC_ALIGN` | LTC Alignment (Shared Guides) |

### Stakeholders / External

| ClickUp Display | Git SCOPE | Full Name |
| ---| ---| --- |
| `[STK CLIENT]` | `STK_CLIENT` | Client Stakeholders |
| `[STK INV CLIENTS]` | `STK_INVCLIENTS` | Investment Clients |
| `[STK CORP DEV CLIENTS]` | `STK_CORPDEVCLIENTS` | Corp Dev Clients |
| `[STK MEDIA]` | `STK_MEDIA` | Media Stakeholders |
| `[STK PARTNERS]` | `STK_PARTNERS` | Partner Stakeholders |
| `[STK SHARE]` | `STK_SHARE` | Shareholders |
| `[STK ESG]` | `STK_ESG` | ESG Stakeholders |
| `[STK GOVT]` | `STK_GOVT` | Government Stakeholders |
| `[EXT ADVISORS]` | `EXT_ADVISORS` | External Advisors |
| `[EXT BD]` | `EXT_BD` | External Board Directors |
| `[EXT OTHERS]` | `EXT_OTHERS` | External Others |
| `[EXT RECRUIT]` | `EXT_RECRUIT` | External Recruitment |

### Collapse Rules (Irregular Mappings)

```scss
[INV TECH]             -> INVTECH           (concatenated, no separator)
[BIZ VEN]              -> BIZVEN            (concatenated, no separator)
[COE EFF]              -> COE_EFF           (underscore -- COE is parent scope)
[COE TECH]             -> COE_TECH          (underscore -- COE is parent scope)
[MGT IT SUPER]         -> MGT_ITSUPER       (partial concatenation)
[LTC ALL]              -> LTC               (shortened -- drops qualifier)
```

No single algorithm produces all of these. ALWAYS use the lookup table.
* * *
## 5\. Table 3b: Focus Areas (FA)

| Code | Full Name |
| ---| --- |
| `SA` | Strategic Alignment |
| `PD` | People Development |
| `OE` | Operational Excellence |
| `UE` | User Enablement |
| `CI` | Customer Intimacy |
| `FP` | Financial Performance |
| `CR` | Corporate Responsibility |
| `OTH` | Others |

* * *
## 6\. Validation & Pre-Creation Checklist
### Canonical Key Regex
**2-part (top-level, no parent):**

```scss
^[A-Z][A-Z0-9_]*_[A-Z]{2,3}\.[0-9]+(\.[0-9]+)*\.[A-Z][A-Z0-9-]*$
```

**3-part (child item with parent):**

```scss
^[A-Z][A-Z0-9_]*_[A-Z]{2,3}\.[0-9]+(\.[0-9]+)*\.[A-Z][A-Z0-9-]*_[A-Z0-9]+\.[A-Z][A-Z0-9-]*$
```

### 8-Step Pre-Creation Checklist
Before creating ANY named item on ANY platform, the agent MUST:
1. **Determine form** — Does this item have a parent? 3-part (default) or 2-part (top-level only)?
2. **Compose** the Canonical Key from SCOPE + (PARENT +) ITEM
3. **Validate** against the appropriate regex above
4. **Verify** SCOPE exists in Table 3a (Section 4)
5. **Verify** FA exists in Table 3b (Section 5)
6. **Check** character count for Git (must be 50 chars or fewer — Git repos only, always 2-part)
7. **Render** to target platform using Section 3 rules
8. **Check** for name collisions on the target platform
If a collision is detected, disambiguate by adjusting NAME. As a last resort, append `-NN` suffix. Never create duplicates — halt and ask the user.

# General System

# LTC General System — AI Agent Reference

> Canonical reference for designing and building any system within LTC. Distills the universal system model, force analysis, principle design, and boundary specification into a single loadable resource. Load when designing or building a UE product, OE process, workflow, or agent team.

**Version:** 1.0 | **Date:** 2026-03-18 | **Task:** OPS\_-4216
**GitHub source:** `rules/general-system.md`
## **Source of truth:** ESD Framework (OPS\_OE.6.1 templates/), 10 Ultimate Truths (BOOK-00), Whiteboard Template (ClickUp)

## 1\. Notation

| Abbreviation | Full Name |
| ---| --- |
| UT#N | Ultimate Truth #N (from the 10 Universal Truths framework) |
| UDO | Ultimate Desired Outcome |
| UBS | Ultimate Blocking System (forces preventing desired outcome) |
| UDS | Ultimate Driving System (forces driving toward desired outcome) |
| EPS | Effective Principles and Standards |
| EOP | Effective Operating Procedures |
| UES | Ultimate Effective System (environment + tools implementing EPS) |
| ESD | Effective System Design (3-phase design methodology) |
| ELF | Effective Learning Framework (7-layer learning methodology) |
| VANA | Verb-Adverb-Noun-Adjective (requirements grammar) |
| RACI | Responsible, Accountable, Consulted, Informed |
| A.C. | Acceptance Criteria (binary, deterministic pass/fail) |
| MECE | Mutually Exclusive, Collectively Exhaustive |
| OE | Operational Excellence (Layer 2 — the systems that build systems) |
| UE | User Enablement (Layer 3 — the systems that serve users) |

* * *

## 2\. Purpose & Foundation

**UT#1 — Every system has the same 6 components that produce an Outcome.**

The universal system formula:

```sql
Outcome = f(Input, User, Action, Principles, Tools, Environment)
```

Every system — regardless of domain, scale, or technology — is composed of these six elements. If any component is missing or misconfigured, the Outcome degrades. There are no exceptions.

**Derisk-first principle applied to systems:** For every action at every level — per component, per task, per system: (1) identify and reduce failure risks first (release the brake), then (2) maximize value within remaining constraints (hit the gas). Skipping step 1 is among the most common failure modes for both humans and AI agents.

**Relationship to** [**agent-system.md**](http://agent-system.md)**:** The 7-Component System in the Agent System reference is a specialization of this universal model where User becomes Agent, Principles splits into EPS (always-active) and EOP (on-demand), and Action separates from process design.
* * *

## 3\. The Universal System Model

From UT#1 and the system formula, every system is composed of six components:

| Component | Definition | Role in System | What Happens When Missing |
| ---| ---| ---| --- |
| Input | What triggers the system and what data it receives | Feeds the doer with task-specific information; sets the ceiling for output quality | System never activates, or doer fills gaps with assumptions — producing wrong output |
| User / Doer | Who performs the work (human or agent) | Executes the cognitive or physical work within the system | No execution occurs; the system is inert |
| Action | The observable execution that emerges from all components interacting | Produces the Outcome; the diagnostic surface for system health | No observable work; nothing to measure or diagnose |
| Principles | Rules governing correct, efficient, scalable operation | Constrain all components; prevent harm and ensure quality | Unconstrained operation — errors compound, quality is random, risk is unmanaged |
| Tools | Instruments available during execution | Extend the doer's capabilities beyond what they can do alone | Doer is limited to native capability; throughput and accuracy capped |
| Environment | Workspace configuration, permissions, limits | Sets hard ceilings for doer and tools; no component can exceed what Environment allows | No operating context; doer cannot access tools, data, or workspace |

**Output vs Outcome:** Output is the concrete artifact a system produces (a report, a dataset, a decision). Outcome is the state change the system creates — the movement toward or away from the UDO. Output is what you ship; Outcome is what matters.

**System vs Workstream:** A workstream is a system that operates as a concurrent sub-system within a parent system. Every workstream is a system; not every system is a workstream. The distinction is deployment context, not structure. Both have the same 6 components.
* * *

## 4\. RACI — Who Does What

From ESD Phase 1 (§3.1): establish R (Responsible) and A (Accountable) BEFORE analyzing forces. The same system has different blockers depending on who is R vs A.

| Role | Actor | Perspective for UBS/UDS |
| ---| ---| --- |
| R (Responsible) | Who does the work (e.g., AI Agent) | UBS(R): what blocks R from executing; UDS(R): what drives R to succeed |
| A (Accountable) | Who owns the outcome (e.g., Human Director) | UBS(A): what blocks A from ensuring quality; UDS(A): what drives A to ensure quality |
| C (Consulted) | Domain expert or upstream provider | Provides input before action |
| I (Informed) | Downstream consumer, team, logs | Receives outcome after action |

**When R = AI Agent:** Behavioral boundaries (Always/Ask/Never) become part of the RACI contract — what the Agent always does (safe actions, no approval needed), what requires Human Director approval (high-impact actions), and what is prohibited (hard stops, violation = immediate halt).

**UBS/UDS analysis must cover both perspectives:** UBS(R), UBS(A), UDS(R), UDS(A). A system designed only from R's perspective ignores A's blockers, and vice versa.

Per-step RACI refines system-level RACI in EOP — each step assigns R, A, C, I independently.
* * *

## 5\. Force Analysis — UBS then UDS

> UBS is analyzed first because derisk always precedes driving output. This inverts the ESD framework's section ordering (ESD §3.3 UDS before §3.4 UBS) but aligns with the operating principle that governs all LTC system design.

**UT#2 — Every system has forces blocking it (UBS) and driving it (UDS).**

Forces are structural — they exist whether you identify them or not. Unidentified forces still degrade the system. Force analysis makes them visible so Principles can address them.

### UBS — The Blocking System (derisk first)

The root system of forces preventing the User from reaching the UDO. Analyzed from both RACI perspectives:

*   **UBS(R)** — what blocks the doer from executing (e.g., ambiguous input, missing tools, capability gaps)
*   **UBS(A)** — what blocks the owner from ensuring quality (e.g., cognitive biases, lack of visibility, decision fatigue)

**Recursive notation:** Forces have internal structure:

*   `UBS.UB` — what weakens the blocker (works IN the User's favor). Principles should amplify them.
*   `UBS.UD` — what strengthens the blocker (works AGAINST the User). Principles must neutralize them.
*   Recursion continues: `UBS.UB.UB`, `UBS.UD.UD`, etc.

### UDS — The Driving System (drive output second)

The root system of forces helping the User reach the UDO. Analyzed from both RACI perspectives:

*   **UDS(R)** — what drives the doer to succeed (e.g., structured procedures, strong tools, clear input)
*   **UDS(A)** — what drives the owner to ensure quality (e.g., domain expertise, strategic judgment, risk intuition)

**Recursive notation:**

*   `UDS.UD` — what strengthens the driver (works IN the User's favor). Principles should leverage these.
*   `UDS.UB` — what weakens the driver (works AGAINST the User). Principles must disable them.
*   Recursion continues: `UDS.UD.UD`, `UDS.UB.UB`, etc.

**Why both sides have internal contradictions:** UBS has forces that weaken it (UBS.UB) — the blocker is not invincible. UDS has forces that weaken it (UDS.UB) — the driver is not guaranteed. Effective system design exploits both: amplify UBS.UB to crack the blocker, disable UDS.UB to protect the driver.

**Core rule:** Disable UBS before amplifying UDS. A system that drives output into unmanaged blockers wastes energy. Remove the brake, then hit the gas.
* * *

## 6\. Effective Principles & Standards

From ESD Phase 2 (§4.1): Principles exist to disable specific UBS elements or enable specific UDS elements. They are the mechanism that translates force analysis into operational constraints.

**Every principle MUST trace to a force.** Format: `P[n](Pillar)(Role): [Principle] — Disables [UBS element] / Enables [UDS element]`. If a principle cannot be traced to a specific UBS or UDS element, it is noise — cut it.

**Role-tagged notation:**

*   `P[n](S)(R)` — constrains the doer (e.g., "Agent must validate every output against schema")
*   `P[n](E)(A)` — constrains the owner (e.g., "Director must review within 24 hours")
*   `P[n](Sc)(both)` — constrains both roles

### Three Pillars of Effectiveness

| Pillar | Governs | Purpose |
| ---| ---| --- |
| Sustainability (S) | Correct, safe, risk-managed operation | Prevents harm, data loss, compounding error. Addressed FIRST — always. |
| Efficiency (E) | Fast, lean, frugal operation | Saves time, tokens, cost, cognitive load. Addressed only after S is confirmed. |
| Scalability (Sc) | Repeatable, comparable, growth-capable operation | Enables increasing load, domains, complexity without redesign. Addressed only after E is confirmed. |

**Priority hierarchy when principles conflict: Sustainability > Efficiency > Scalability.** A fast system that is unsafe fails. A scalable system that is slow wastes resources at scale. Sustainability gates everything.
* * *

## 7\. System Boundaries — Input & Output

Progressive disclosure across four layers. Start with Minimum Viable Boundary at design time; add layers as the system matures.

### Layer 1 — What Flows (Minimum Viable Boundary)

Five categories flow through ANY system boundary:

1. **Acceptance Criteria** — what "correct" means, bucketed by Sustainability, Efficiency, Scalability
2. **Signal / Data / Information** — the payload the system processes
3. **Physical Resources** — hardware, infrastructure, materials
4. **Human Resources** — people, roles, availability, expertise
5. **Financial Resources** — budget, token spend, API cost, compute

### Layer 2 — How It Flows Reliably

Six contract fields define each boundary:

| Field | Purpose |
| ---| --- |
| Source / Consumer | Who sends (for input) / who receives (for output) |
| Schema | Data shape both sides agree on (JSON Schema, Pydantic model, or equivalent) |
| Validation | Rules the payload must satisfy (types, ranges, required fields) |
| Error | Behavior when the contract is violated or the source is unavailable |
| SLA | Availability and latency expectations |
| Version | Contract version; breaking changes require upstream/downstream notification |

**Integration chain:** Systems do not operate in isolation. Each system's output feeds the next system's input:

```css
SYS-A OUTPUT --> SYS-B INPUT --> SYS-B OUTPUT --> SYS-C INPUT
```

Without schema-level contracts, each system is designed in isolation. When SYS-A changes its output format, SYS-B breaks silently. Contracts make integration failures loud and early.

### Layer 3 — How You Verify (Pre-Build Boundary)

Every Acceptance Criterion must have an Eval Spec before building starts. Without automated proof, A.C.s are assertions without evidence.

Three eval types:

| Type | Grader | Best For |
| ---| ---| --- |
| Deterministic | Script returns pass/fail | Schema validation, data format checks, Noun A.C.s |
| Manual | Human Director reviews with rubric | Subjective quality, UX feel, strategic judgment |
| AI-Graded | Second LLM evaluates against rubric | Natural language quality, reasoning checks at scale |

Each A.C. requires four fields: **Type** + **Dataset** + **Grader** + **Threshold**.

Critical sequence — violated at your peril:

```elixir
Write A.C. --> Write Eval Spec --> Build Dataset --> Implement Grader --> Wire CI --> THEN build
```

**MECE applies:** One test per A.C., no gaps, no overlaps. Every A.C. is tested exactly once.

### Layer 4 — How It Fails Gracefully (Production-Ready Boundary)

Per EOP step, define failure behavior:

| Field | Purpose |
| ---| --- |
| Recovery | What happens on failure (retry, fallback, fail-fast) |
| Escalation | Who gets notified and when (e.g., 2nd retry fails -> Human Director) |
| Degradation | Is partial output acceptable? How is it marked? (e.g., `[UNVERIFIED]` tags) |
| Timeout | Max retries, max wall-clock time before the step is abandoned |

Failure modes are structural — they exist whether you specify them or not. Unspecified failure modes produce silent, cascading failures. Specified failure modes produce loud, contained failures.
* * *

## 8\. The ESD Methodology

ESD is a design methodology, not a document template. It defines HOW to translate learning into engineering requirements.

### Phase 1 — Problem Discovery

Reconstruct the User's system from ELF output — before introducing any technology.

*   **Who** is the User? (User Persona + Anti-Persona)
*   **What** is their UDO? (Carried verbatim from ELF — do not rephrase)
*   **What blocks** them? (UBS from both R and A perspectives)
*   **What drives** them? (UDS from both R and A perspectives)

No solution language. Phase 1 describes the problem space only.

### Phase 2 — System Design

Define the conceptual solution space based on Phase 1 and ELF.

*   **Principles** (S/E/Sc) — each traced to a UBS or UDS element, role-tagged
*   **Environment** — workspace configuration and constraints
*   **Tools** — organized by 3 UES causal layers (Foundational -> Operational -> Enhancement)
*   **Desirable Wrapper** (Iterations 1-2) — minimum viable tool configuration addressing root-level UBS/UDS. Tests: "Will the User want to use this?"
*   **Effective Core** (Iterations 3-4) — full configuration addressing all recursive UBS/UDS layers. Tests: "Does this actually solve the root cause?"
*   **EOP** — sequential gated steps with per-step RACI, staged DERISK then OPTIMIZE

### Phase 3 — User's Requirements

Translate Phase 2 into deterministic engineering requirements using VANA grammar:

*   **Verb** — atomic user action from EOP steps where User = R
*   **Adverb** — how the Verb must be performed, bucketed by S/E/Sc (SustainAdv, EffAdv, ScalAdv)
*   **Noun** — the UE tool/system built, organized by UES causal layers
*   **Adjective** — qualities the Noun must possess, bucketed by S/E/Sc (SustainAdj, EffAdj, ScalAdj)

Every A.C. must be: Atomic, Binary, Deterministic, Pre-committed, Traceable.

**The flow:**

```elixir
Learn (ELF) --> Design (ESD Phase 1+2) --> Requirements (Phase 3) --> Build --> Test
```

* * *

## 9\. The Value Chain

Every organization operates through a value chain of six interdependent layers. Each layer enables the one above it — causal ordering, not arbitrary stacking.

| Layer | Name | Purpose |
| ---| ---| --- |
| L0 | Strategic Alignment | Defines direction and priorities |
| L1 | People Development | Builds capability to execute |
| L2 | Operational Excellence | The systems that build systems (OE) |
| L3 | User Enablement | The systems that serve users (UE) |
| L4 | Customer Intimacy | Retains and grows relationships |
| L5 | Financial Performance | Measurable outcomes of all layers above |

**OE (L2) builds systems. UE (L3) serves users. Know where your system sits.** OE does not serve the end-user directly — it serves the builder. UE is built BY OE FOR a named User Persona.

**Causal ordering:** You cannot build UE systems (L3) without OE capability (L2). You cannot build OE capability without People Development (L1). You cannot develop people without Strategic Alignment (L0). Each layer enables the one above it; skip a layer and the chain breaks.

# Agent Diagnostic

# LTC Agent Diagnostic — AI Agent Reference

> Structured diagnostic framework for tracing agent failures to their root components in the 7-CS. Load when agent output is wrong, unexpected, or rejected — and you need to find and fix the cause. Structured for both human practitioners and future automated diagnostic agents.

**Version:** 1.0 | **Date:** 2026-03-18 | **Task:** OPS\_-4216
**GitHub source:** `rules/agent-diagnostic.md`
## **Source of truth:** Doc-9 §3.7 (OPS\_OE.6.0 research/amt/), Session 0 §4+§6 (Notion ALIGN Wiki)

## 1\. Notation

| Abbreviation | Full Name |
| ---| --- |
| 7-CS | The Agent's 7-Component System |
| EPS | Effective Principles and Standards |
| EOP | Effective Operating Procedures |
| LT-N | LLM Truth #N (the 8 fundamental limits of LLM models) |
| UBS | Ultimate Blocking System (forces preventing desired outcome) |
| UDS | Ultimate Driving System (forces driving toward desired outcome) |

* * *

## 2\. Purpose

**Core principle:** Action is emergent — it results from all 6 other components interacting. When Action fails, the cause is in one of the other 6 components. You observe Action to diagnose, but you fix the other components. (See Agent System reference, §5 Action component card.)
* * *

## 3\. The Blame Diagnostic

From Session 0 §4 Pattern 2 and Doc-9 §3.7. Sequential walkthrough — ALWAYS check in this order:

1. **EPS** — Did the rules cover this case? Are they too verbose (consuming context budget via LT-7)?
2. **Input** — Was context complete and unambiguous? Was scope explicit?
3. **EOP** — Was the procedure appropriate? Were steps well-scoped? Was the right skill triggered?
4. **Environment** — Was context window sufficient? Permissions correct? Compute adequate?
5. **Tools** — Were the right tools available? Returning good data? Too many tools loaded?
6. **Agent** — Only after checking 1–5: is the model genuinely underpowered for this task?

### Platform-Specific Trace Points

| Platform | How to trace |
| ---| --- |
| Claude Code | Review tool call log — trace which files were read (Input), which rules applied (EPS), which skill triggered (EOP) |
| Cursor | Check .cursorrules loading + which files were in context via @ mentions |
| Gemini | Check workspace rules + which context was loaded into the session |

* * *

## 4\. Symptom → Root Component Table

Merged from Doc-9 §3.7 diagnostic table and Session 0 §6 anti-pattern table.

| Symptom | Likely Root Component | Check First |
| ---| ---| --- |
| Agent states incorrect facts confidently | EPS (missing validation rules) or Tools (no fact-checking) or Input (no source material) | Does EPS require citations? Are verification tools available? |
| Agent loses track of instructions mid-task | EPS (too verbose, consumes context) or Environment (insufficient context budget) | Count EPS token footprint. Check context utilization. |
| Agent completes the wrong task | Input (ambiguous requirements) or EOP (wrong procedure loaded) | Was scope explicit? Was the right skill triggered? |
| Agent reasoning is shallow or circular | EOP (steps too large) or Agent (underpowered) or Environment (insufficient compute) | Are steps decomposed? Is extended thinking enabled? |
| Agent uses wrong tool or misinterprets output | Tools (too many, unclear purpose) or EOP (no tool selection guidance) | How many tools loaded? Does EOP specify which to use? |
| Output is correct but Director rejects it | Human UBS — Director's biases overriding evaluation | Run Force Map (§6). Is System 1 dominant? |
| Rushed delegation, compound errors | Derisk step skipped | Run Derisk Checklist (§5) before re-delegating |
| Inconsistent behavior across sessions | EPS missing or too thin; LT-6 (no memory) | Is [CLAUDE.md](http://CLAUDE.md) loaded? Does it cover this case? |

* * *

## 5\. The Derisk Checklist

From Session 0 §4 Pattern 3. Pre-delegation gate — 30 seconds before ANY delegation:

1. **List what can go wrong** with this specific task
2. **For each risk, map:**

  

`Risk → Which LT → Which component should compensate → Is it configured?`

3. **If any component is unconfigured** for a known risk → configure it before delegating
4. **If all risks are covered** → delegate with confidence

### Example

Before asking the agent to research a competitor:

| Risk | LT | Component | Configured? |
| ---| ---| ---| --- |
| Agent doesn't know our positioning | LT-6 | Input must include our summary | Is it loaded? |
| Task is multi-layered | LT-3 | EOP must decompose | Are sub-tasks defined? |
| Agent might present stale data | LT-1 | Tools must include search | Is web search available? |

Three risks caught, three compensations verified, before a single token is generated.
* * *

## 6\. The Force Map

From Session 0 §4 Pattern 4. Determine which operator's UBS is active right now:

*   **Human under time pressure / fatigue / emotional investment** → System 1 (heuristic-driven) is dominant → Delegate analysis to the Agent. It doesn't get tired, doesn't have ego, and will examine every angle if instructed.
*   **Decision requires values, ethics, strategic judgment, domain expertise** → System 2 (deliberate) is needed → Don't delegate that part. Use the Agent for data gathering only.
*   **Both forces active** → Split the task: Agent gathers and structures data, Human makes the judgment call on the structured output.

This works identically across Claude Code, Cursor, and Gemini — it is a thinking framework, not a tool feature. (See Agent System reference, §4 The Two Operators.)
* * *

## 7\. Automated Diagnostic Integration Points

> **FUTURE — not yet implemented.** This section defines the architecture for autonomous diagnostic automation. It serves as a design reference for future implementation.

### Post-Action Hooks

*   Validate output against AC eval spec (see General System reference, §7 Layer 3)
*   Check output schema against contract fields (see General System reference, §7 Layer 2)
*   Log: action type, component trace, pass/fail, tokens consumed
*   On failure: auto-populate §4 table lookup — map symptom to likely root component

### Per-Step Monitoring

*   Check failure mode triggers per category (see General System reference, §7 Layer 4):
    *   Hallucination — schema validation against source material
    *   Context loss — state check against expected context keys
    *   Token exhaustion — response length check against budget
    *   Schema violation — parse error on output model
    *   Permission denied — boundary check against Always/Ask/Never tiers
    *   Stale data — timestamp check against freshness threshold
*   Track step duration against SLA
*   Flag when context utilization exceeds 80% of effective window

### Per-Session Aggregation

*   Symptom frequency by root component (which component appears most in traces)
*   Most common failure patterns (map to §4 table rows)
*   Component health score: % of actions traced to this component as root cause
*   Session cost: total tokens consumed vs. budget allocated

### Cross-Session Intelligence

*   Trend: is a component degrading over time? (e.g., EPS growing beyond token budget)
*   Correlation: which component combinations produce compound failures?
*   Recommendation engine: e.g., "EPS has been root cause in 40% of failures this week — review rules"
*   Drift detection: compare current session component scores against rolling baseline

### Future Architecture

*   **Autonomous diagnostic agent:** hooks into Action observation → traces to component via §3 order → proposes fix → optionally auto-remediates (with Human Director approval gate)
*   **Review agent:** scores component health, flags drift from EPS, generates improvement tickets
*   **Observability stack integration:** logging, metrics, tracing, alerting feed diagnostic data automatically

# Agent System

# LTC Agent System — AI Agent Reference

> Canonical reference for configuring an AI agent's 7-Component System. Defines the 8 structural limits of LLM models, the two operators, and the 7 components that compensate for those limits.

**Version:** 1.0 | **Date:** 2026-03-18 | **Task:** OPS\_-4216
## **GitHub source:** `rules/agent-system.md`

## 1\. Notation

| Abbreviation | Full Name |
| ---| --- |
| 7-CS | The Agent's 7-Component System |
| EPS | Effective Principles and Standards |
| EOP | Effective Operating Procedures |
| UBS | Ultimate Blocking System |
| UDS | Ultimate Driving System |
| LT-N | LLM Truth #N (8 fundamental limits) |
| UT#N | Ultimate Truth #N (10 Universal Truths) |
| RACI | Responsible, Accountable, Consulted, Informed |
| A.C. | Acceptance Criteria (binary, deterministic) |

* * *

## 2\. Three Principles

### Principle 1: Brake Before Gas \[DERISK\]

For every action — per component, per task, per system — identify and reduce failure risks first (release the brake), then maximise output second (hit the gas). Grounded in UT#5. Skipping step 1 is the single most common failure mode.

### Principle 2: Know the Physics \[DERISK\]

The 8 LLM Truths are structural constraints, not bugs. Every component in the 7-CS exists to compensate for at least one. Learn what cannot change so you stop trying to change it.

### Principle 3: Two Operators, One System \[OUTPUT\]

The Human Director and the LLM Agent have complementary failure modes and strengths. The Human's weaknesses are cognitive shortcuts (System 1); the Agent's weaknesses are the 8 LTs. Neither can compensate for their own blind spots, but each can compensate for the other's.

**The System Formula:**

```java
Effective Outcome = f(EPS, Input, EOP, Environment, Tools, Agent, Action)
```

The Human Director is not a component — they are the Accountable party who owns the outcome.
* * *

## 3\. The 8 LLM Fundamental Truths

Structural constraints baked into how LLMs work. Not patched away by the next model release.

> **Note on LT-2/3/4:** All three involve "the model struggles when there's too much" but differ in WHAT dimension: LT-2 = VOLUME, LT-3 = NUMBER OF STEPS, LT-4 = PRECISION of retrieval.

| # | Truth | Bottleneck | Compensated by |
| ---| ---| ---| --- |
| LT-1 | Hallucination is structural | Factual accuracy | EPS, Tools, Input |
| LT-2 | Context compression is lossy | Volume of info loaded | Environment, Input, EPS |
| LT-3 | Reasoning degrades on complex tasks | Number of logical steps | EOP, Input, Environment |
| LT-4 | Retrieval is fragile under token limits | Precision in noisy context | Input, Tools, Environment |
| LT-5 | Prediction optimises plausibility, not truth | Truth vs sounding right | EPS, Tools, Human judgment |
| LT-6 | No persistent memory across sessions | Memory between sessions | Input, Tools, EPS |
| LT-7 | Cost scales with token count | Budget | Input, EPS, Environment |
| LT-8 | Alignment is approximate | Rule compliance under pressure | EPS, EOP, Human oversight |

### LT-1 — Hallucination is structural

**Bottleneck:** Factual accuracy. For any model, P(hallucination) > 0. It predicts the most plausible next word, and plausible is not true.
**Mechanism:** Diagonalization guarantees inputs where any computable predictor must fail.
**Compensated by:** EPS (validation rules), Tools (fact-checking), Input (provide source material).

### LT-2 — Context compression is lossy

**Bottleneck:** Volume of information loaded. The effective context window is much smaller than the nominal one. Information in the middle gets lost.
**Mechanism:** Positional under-training, encoding attenuation, and softmax crowding degrade retrieval as context grows.
**Compensated by:** Environment (context budget), Input (load only what is needed), EPS (concise rules).

### LT-3 — Reasoning degrades on complex tasks

**Bottleneck:** Number of logical steps. A 3-step task works well; a 12-step task breaks down. At 90% per-step, 0.9^7 ≈ 48% end-to-end.
**Mechanism:** Likelihood-based training favors pattern completion over inference.
**Compensated by:** EOP (smaller steps with checkpoints), Input (decompose before sending), Environment (compute for extended thinking).

### LT-4 — Retrieval is fragile under token limits

**Bottleneck:** Precision in noisy context. The needle-in-a-haystack problem — even in a reasonable window, when information is messy, the model grabs something close enough.
**Mechanism:** Attention-based retrieval suffers from semantic drift.
**Compensated by:** Input (label and structure clearly), Tools (dedicated search), Environment (reduce noise).

### LT-5 — Prediction optimises plausibility, not truth

**Bottleneck:** Truth vs sounding right. Trained to predict the most likely next word. Root cause of LT-1.
**Mechanism:** Next-token prediction with no native truth-detection mechanism.
**Compensated by:** EPS (require evidence/citations), Tools (external verification), Human judgment.

### LT-6 — No persistent memory across sessions

**Bottleneck:** Memory between sessions. Every new conversation starts blank.
**Mechanism:** All state must be externally provided. Nothing carries between sessions without external storage.
**Compensated by:** Input (load session state/history), Tools (memory vault systems), EPS (rules for session start).

### LT-7 — Cost scales with token count

**Bottleneck:** Budget. More words in/out = more money. Attention scales superlinearly. Wasted tokens waste budget AND worsen LT-2.
**Compensated by:** Input (lean context), EPS (concise rules), Environment (budget limits).

### LT-8 — Alignment is approximate

**Bottleneck:** Rule compliance under pressure. Safety training makes the model mostly behave, but "mostly" is not "always." Probabilistic, not deterministic.
**Mechanism:** RLHF/Constitutional AI shape behavior probabilistically. May optimize for proxy metrics over the desired outcome.
**Compensated by:** EPS (behavioral boundaries), EOP (verification gates), Human oversight.
* * *

## 4\. The Two Operators

### Human Director (Accountable)

Owns decision quality, provides domain judgment, approves outputs.

**System 1 UBS — Cognitive Shortcuts:**

| Bias | Mechanism | Design Threat |
| ---| ---| --- |
| Availability Heuristic | Judges by ease of recall | Overweights recent failures; ignores base rates |
| Representativeness | Matches to prototypes | Stereotypes solutions; skips edge cases |
| Anchoring | Over-relies on first info | Initial estimates lock in |
| Affect Heuristic | Gut feeling substitutes for analysis | Accepts "feels right" outputs |
| Confirmation Bias | Seeks confirming info | Ignores disconfirming Agent outputs |
| Self-Serving Attribution | Credits self, externalizes failure | Blames Agent when Input was the cause |

**System 2 UDS — Deliberate Strengths:**

| Strength | Mechanism |
| ---| --- |
| Domain expertise | Pattern recognition from years of experience |
| Strategic judgment | Trade-offs requiring values, not just data |
| Risk intuition | Sensing danger from incomplete signals |
| Ethical oversight | Moral reasoning algorithms cannot own |
| Creative direction | Defining what SHOULD exist |

### LLM Agent (Responsible)

Executes cognitive work. Weaknesses: the 8 LTs. Strengths are architectural:

| Strength | Mechanism |
| ---| --- |
| Orchestrated parallelism | Multiple hypotheses; no fatigue |
| Exhaustive analysis | No pressure to "wrap it up" |
| No ego investment | Failure analysis without distortion |
| High recall within context | No availability heuristic |
| Programmatic enforcement | EPS rules applied consistently |
| Consistent instruction following | Procedures execute the same way |

### Shared Forces

*   **Compute-Efficient Forces (Agent)** mirror **Bio-Efficient Forces (Human)** — both default to shortcuts under pressure
*   **Orchestration System Belief (Agent)** mirrors **Support System Belief (Human)** — both perform better in structured frameworks
* * *

## 5\. The 7-Component System

### Dependency Graph

```css
                    ┌─────────┐
                    │   EPS   │ ← Constitution
                    └────┬────┘
                         │ governs
              ┌──────────┼──────────┐
              ▼          ▼          ▼
         ┌─────────┐ ┌─────────┐   │
         │  Input  │ │   EOP   │   │
         └────┬────┘ └────┬────┘   │
              │           │         │
              ▼          ▼          │
         ┌─────────────────────┐   │
         │     AGENT           │◄──┘
         │  (within Env+Tools) │
         └────────┬────────────┘
                  │ produces
                  ▼
         ┌──────────────┐
         │   ACTION      │ ← Emergent
         └──────┬───────┘
                ▼
         ┌──────────────┐
         │   OUTCOME     │
         └──────────────┘
```

### Summary Table

| # | Component | One-liner | AI Examples | Priority |
| ---| ---| ---| ---| --- |
| 1 | EPS | Persistent rules — always active | [CLAUDE.md](http://CLAUDE.md), .cursorrules, [GEMINI.md](http://GEMINI.md) | 1st |
| 2 | Input | What you provide for this task | Prompt, context files, RAG, memory | 2nd |
| 3 | EOP | Step-by-step procedures, on demand | [SKILL.md](http://SKILL.md), .mdc files, Code Actions | 3rd |
| 4 | Environment | Workspace — config, permissions, limits | IDE, terminal, context window, hooks | 4th |
| 5 | Tools | Instruments the agent can call | MCP servers, APIs, CLI, web search | 5th |
| 6 | Agent | The AI model — capabilities and limits | Claude Opus/Sonnet, GPT-4o, Gemini | 6th |
| 7 | Action | Observable execution (emergent) | Reasoning chains, tool calls, edits | 7th |

### Component Cards

#### Card 1: EPS — Effective Principles and Standards

Persistent rules always active — the constitution. Constrains all other components.

*   **Compensates for:** LT-1, LT-5, LT-8. **Guards against:** Confirmation Bias, Self-Serving Attribution, Anchoring.
*   **Derisk:** Too verbose → consumes context (LT-7). Contradictory → plausible interpretation (LT-5). Missing → no safety bounds (LT-8).
*   **Drive:** Lean rules. Priority hierarchy. Traced to UBS/UDS. Always/Ask/Never behavioral boundaries.

#### Card 2: Input

Task-specific information — prompt, context, data, constraints. Quality sets the ceiling for Output.

*   **Compensates for:** LT-6, LT-2, LT-4. **Guards against:** Anchoring, Availability Heuristic.
*   **Derisk:** Too large → exceeds context (LT-2). Ambiguous → wrong assumptions (LT-1, LT-5). Missing context → cannot compensate (LT-6).
*   **Drive:** Structured, labeled sections. Explicit scope. Relevant context only. Prior session state provided.

#### Card 3: EOP — Effective Operating Procedures

Reusable step-by-step procedures loaded on demand — the playbook.

*   **Compensates for:** LT-3, LT-1, LT-8. **Guards against:** Affect Heuristic, Confirmation Bias.
*   **Derisk:** Too rigid → cannot adapt. Too vague → free interpretation (LT-1, LT-5). Steps too large (LT-3). Missing gates → compound errors.
*   **Drive:** Explicit input/output/A.C. per step. Sized to reasoning window. Validation gates. Modular composition.

#### Card 4: Environment

Workspace configuration — IDE, context window, sandbox, permissions, compute.

*   **Compensates for:** LT-2, LT-7, LT-4. **Guards against:** Anchoring.
*   **Derisk:** Too restrictive → blocked. Too permissive → destructive. Context overloaded. Compute insufficient (amplifies LT-3).
*   **Drive:** Explicit context budget. Sandboxing. Matched to task complexity. Monitoring enabled.

#### Card 5: Tools

Instruments callable by the Agent — MCP servers, APIs, CLI, databases, search.

*   **Compensates for:** LT-6, LT-1, LT-3, LT-4. **Guards against:** Availability Heuristic, Representativeness.
*   **Derisk:** Unavailable → halts. Wrong data → compounds hallucination (LT-1). Too many → confusion (LT-3). Output too large (LT-2, LT-7).
*   **Drive:** Clear purpose per tool. Fallback strategies. Validated output. Minimal set.

#### Card 6: Agent

The AI model itself — configured but not built by the user.

*   **Constrained by:** All 8 LTs. **Guards against:** All System 1 biases.
*   **Derisk:** Wrong model → underpowered (LT-3) or wasteful (LT-7). Outside domain → hallucination (LT-1). Alignment assumed perfect (LT-8).
*   **Drive:** Matched to task. Strengths leveraged. Clear Agent vs Director decision separation.

#### Card 7: Action — Emergent Output

Observable execution from all components interacting. Not configured — it emerges.

*   **Derisk:** Not observed → silent errors. Misdiagnosed → blame Action instead of root. Over-monitored → context cost (LT-7).
*   **Drive:** Trace failures to 6 input components via blame diagnostic. Log decision points. Catch failures before Outcome.

# Four-System Architecture

# Four-System Architecture — Universal Project Decomposition
> Canonical reference for decomposing any analytical or enablement project into 4 interdependent systems. Each system receives full 6-component treatment per `rules/general-system.md`. Load when starting a new project, running /state-a, or designing system boundaries.
**Version:** 1.0 | **Date:** 2026-03-19 **Depends on:** `rules/general-system.md` (system model, notation, force analysis, boundaries)
* * *
## 1\. Purpose
Every project that produces insight or enablement from a domain follows the same causal chain: **Understand → Observe → Reason → Express.** This rule defines the minimum viable decomposition of that chain into 4 systems, each with its own UDO, UBS/UDS, Principles, and full component design.
**Why 4 systems, not 1?** From UT#1, each system's output function is multiplicative — if any component goes to zero, output goes to zero. A single monolithic system hides which component is the bottleneck. Decomposing into 4 systems exposes per-system leverage points and prevents one weak layer from silently killing the whole chain.
**Why at least 4?** These 4 are MECE for the knowledge-to-action pipeline. Some projects add more (e.g., a Validation system between S2 and S3). But every project has at least these 4 — skip one and the chain breaks.
**What this is NOT for:** Projects that do not follow the Understand → Observe → Reason → Express chain. Examples: pure infrastructure provisioning, standalone tooling with no analytical output, training-only initiatives where the goal is skill transfer rather than domain insight. Those projects are still systems (UT#1 applies), but they decompose differently.
* * *
## 2\. The Four Systems

```haskell
S0: OBJECT         S1: DATA           S2: MODEL &        S3: PRESENTATION
SYSTEM             PIPELINE           ANALYSIS           SYSTEM
─────────          ──────────         ──────────         ──────────
Understand         Observe            Reason             Express
the domain         the domain         over data          for action

"What is this      "What data         "What does         "How does the
 thing and how      exists about       the data           team consume
 does it work?"     it?"               tell us?"          and act on this?"

Output:            Output:            Output:            Output:
Domain map         Clean,             Signals,           Dashboards,
(UBS, UDS,         standardized       models,            reports,
leverage points,   data               classifications,   interfaces,
feedback loops)                       predictions        integration APIs
```

| # | System | Core Function | What It Produces | Key Question |
| ---| ---| ---| ---| --- |
| S0 | Object System | First-principle understanding of the domain itself | Domain map: the domain's own causal structure — what blocks it (UBS), what drives it (UDS), its feedback loops and leverage points | "What blocks/drives this domain itself?" |
| S1 | Data Pipeline | Collect, clean, standardize, store data about the domain | Reliable, queryable, documented datasets | "Is this data true, complete, and timely?" |
| S2 | Model & Analysis | Reason over the data — statistical, algorithmic, ML, or manual | Signals, classifications, predictions, insights | "What does this data mean, and can we falsify it?" |
| S3 | Presentation | Express insights for decision-making and team enablement | Consumable outputs: dashboards, reports, alerts, integration interfaces | "Can the team act on this within their workflow?" |

* * *
## 3\. Dependency Chain & Feedback Loops
### Linear Dependencies (feedforward)

```plain
S0 ──► S1 ──► S2 ──► S3
```

*   **S0 → S1:** Understanding informs what data to collect. Without S0, S1 collects everything (wasteful) or the wrong things (dangerous).
*   **S1 → S2:** Clean data feeds models. Without S1, S2 models noise.
*   **S2 → S3:** Analysis feeds presentation. Without S2, S3 presents raw data (no insight).
### Feedback Loops (the system learns)
Each individual feedback **edge** is a balancing loop — it corrects errors:

```haskell
S3 ──► S0    Presentation reveals gaps in understanding (balancing)
S2 ──► S1    Analysis reveals data quality issues (balancing)
S3 ──► S2    Team usage reveals model blind spots (balancing)
```

The **full cycle** S0→S1→S2→S3→S0 is a reinforcing loop — it compounds. If S0 is correct, the cycle compounds improvement. If S0 is wrong, the cycle compounds error. This is the compound interest of the system.

```go
S0 ──► S0    Deeper understanding recursively refines the domain map (reinforcing)
```

Block compounding error by: falsification mechanisms in S2, feedback from S3 back to S0.
* * *
## 4\. Per-System Design Template
Each system has 6 controllable components per `rules/general-system.md`: **Input, User (UBS/UDS), Principles, Environment, Tools, Process → Outcome.** Action is emergent — you observe it as diagnostic surface, you don't design it.
**Spec references:** `rules/general-system.md` (universal system model, force analysis, boundaries), `rules/agent-system.md` (when doer is AI).
For each system, follow these steps in order:
### 4.0 System Mapping — How to See the System
Before defining components, **map the system's internal structure.** A system you cannot see is a system you cannot improve.
1. **List the nodes** — components, entities, variables within this system. Use the 6-component model as starting structure (Input, User, Principles, Environment, Tools, Process).
2. **Map the edges** — how each node influences others. This IS the system map. An edge = "A influences B in this way."
3. **Identify the loops** — which edges form reinforcing loops (drivers — more leads to more)? Which form balancing loops (blockers — system resists change)?
4. **Spot the leverage** — the edge with the highest compound potential. Trace backward from the output: which node constrains it most? Within that node, which edge is the bottleneck? That = leverage point. Filter: "Is this the leverage point of the entire system, or just a local optimization?"
5. **Check for inherent nodes** — forces that are always present, cannot be removed, only designed around:
    *   **Psychological biases**: confirmation bias, anchoring, sunk cost, loss aversion
    *   **Entropy/decay**: systems degrade without maintenance (code rot, knowledge erosion, data staleness)
    *   **Cognitive limits**: working memory ~7 items, attention span, decision fatigue
    *   **Social dynamics**: power dynamics, status seeking, in-group/out-group (emerge when >1 person)
> **You cannot remove inherent nodes.** Counter-design: anchoring → collect independent opinions before group discussion. Sunk cost → pre-commit kill criteria before starting. Loss aversion → frame changes as gains.
### 4.1 Problem Discovery (ESD Phase 1)
*   **UDO:** What is this system's outcome?
*   **User/Doer:** Who operates this system? (RACI: R and A)
*   **UBS:** What blocks the outcome? (from both R and A perspectives)
    *   Go to the root: `UBS.UB` (what weakens the blocker — amplify), `UBS.UD` (what strengthens the blocker — neutralize)
    *   **Chain reaction check:** UBS is often a series of linked loops where the output of one feeds the next. Leverage = cut the link BETWEEN loops, not fix individual loops.
*   **UDS:** What drives the outcome? (from both R and A perspectives)
    *   Go to the root: `UDS.UD` (what strengthens the driver — leverage), `UDS.UB` (what weakens the driver — disable)
**S0 note:** S0's UBS/UDS maps the **domain's own forces** (e.g., "What blocks/drives inflation itself?"). Each system also has its own project-level ESD Phase 1 for implementation forces — those are separate.
### 4.2 System Design (ESD Phase 2)
*   **Principles:** Traced to specific UBS/UDS elements. Tagged by pillar (S/E/Sc) and role (R/A).
    *   Principles must cover both **technical leverage** (structure layer — controls loops) AND **human leverage** (alignment layer — changes why people act). Principles without human layer = SOP (followed when watched, bypassed when not). Principles with human layer = Culture (followed because people believe).
*   **Environment:** Where this system operates (infrastructure, permissions, constraints).
*   **Tools:** What extends the doer's capability. Organized by UES layers (Foundational → Operational → Enhancement).
*   **EOP:** Step-by-step procedure with per-step RACI. Staged: DERISK then OPTIMIZE.
### 4.3 Requirements (ESD Phase 3, VANA)
*   **Verb:** What the user does in this system.
*   **Adverb:** How (Sustainability, Efficiency, Scalability).
*   **Noun:** What tool/artifact this system produces.
*   **Adjective:** Qualities the noun must have (S/E/Sc).
*   Every A.C.: Atomic, Binary, Deterministic, Pre-committed, Traceable.
### 4.4 System Boundaries
Per [`general-system.md`](http://general-system.md) §7, define each system's output clearly so the downstream system knows what to expect. When an output changes, failures should be loud, not silent.
* * *
## 5\. Integration Chain
Each system's output feeds the next system's input. Define what flows at each boundary so failures are loud, not silent.

```css
S0 OUTPUT ──► S1 INPUT ──► S1 OUTPUT ──► S2 INPUT ──► S2 OUTPUT ──► S3 INPUT
```

| Boundary | What Flows |
| ---| --- |
| S0 → S1 | Domain map: what to observe, which entities, which relationships |
| S1 → S2 | Clean datasets: standardized, documented, queryable |
| S2 → S3 | Signals, classifications, predictions, confidence levels |
| S3 → Users | Consumable outputs: dashboards, reports, alerts, APIs — or a product if the domain is a business |

* * *
## 6\. Leverage Point Hierarchy
**Across the 4 systems, the leverage ordering is:**
1. **S0 premises** — If S0's understanding of the domain is wrong, everything downstream amplifies the error. Highest-leverage, highest-risk point.
2. **S0 ↔ S3 feedback loop** — The loop from presentation back to understanding is how the system self-corrects. Without it, errors compound silently.
3. **EPS (Principles & Standards)** — The rules governing each system's operation. A system without principles operates randomly. Includes output definitions at system boundaries.
4. **S2 falsification mechanism** — S2 must be able to tell when its own model is wrong. Without this, overfitting goes undetected.
5. **S1 data quality** — Data is the raw material. Garbage in, garbage out — but only after S0 premises are correct.
**Within each system**, apply the component priority: EPS → Input → Process → Environment → Tools → User. Each component follows a curve: below a threshold it produces nothing, then a steep zone where investment pays off most, then saturation. Invest in the steep zone.
**How to find leverage (per system):**
1. Define the system's final output
2. Trace backward: which component constrains output the most?
3. Within that component: which edge/loop is the bottleneck?
4. That = system-level leverage point
5. **Sequence matters:** Eliminate negative leverage first (survival) → then strengthen positive leverage (growth). An LP strengthening a loop still suppressed by a blocker = multiplying zero.
**Leverage hierarchy (weakest → strongest):** Change parameters/numbers → Change feedback loop structure → Change the goal or paradigm of the system.
* * *
## 7\. When to Use This Template
*   **Starting a new project:** Decompose into 4 systems before building anything. Run /state-a for each system.
*   **Auditing an existing project:** Map current work to the 4 systems. Identify which system is below threshold (the bottleneck).
*   **Diagnosing failures:** First identify WHICH system failed (S0/S1/S2/S3), then use the Iceberg Model WITHIN that system to find depth:
    1. **Event** — What happened? (weakest leverage)
    2. /
    3. **Pattern** — Is this recurring? Where does it cluster?
    4. **Structure** — What loop/edge causes the pattern?
    5. **Root Cause** — Why does this loop exist?
    6. **Human Alignment** — Why doesn't anyone fix it? (strongest leverage)
*   **Planning iterations:** Each system can have its own /state-b execution loop. Systems execute in sequence per the dependency chain (§3): S0 → S1 → S2 → S3.
* * *
**Value Chain positioning:** This 4-system architecture is an OE (L2) system — the system that builds systems. From this OE foundation, excellent UE (L3) products are built. See [`general-system.md`](http://general-system.md) §9 for the full Value Chain.
_Depends on:_ _`rules/general-system.md`_ _(universal system model). Companion:_ _`rules/agent-system.md`_ _(when the doer is an AI agent)._

# Untitled

