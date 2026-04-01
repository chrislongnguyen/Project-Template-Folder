---
wversion: "1.1"
iteration: "I1: Concept"
status: Draft
last_updated: 2026-03-30
owner: Long Nguyen
---

# STAKEHOLDER ANALYSIS
# OPS_OE.6.4.LTC-PROJECT-TEMPLATE

## Derived From
Ultimate Truth #1 (Systems) — The Doer/User is a core system component.
ESD §3.1 (EU): "Is the right person/role involved?" + Anti-persona requirement (C3).
Zone-1-ALIGN SOP C3: Primary user profile specific enough to make design decisions against.

---

## Stakeholder Map

| Stakeholder | Role | What They Need | Their UBS (Blockers) | Their UDS (Drivers) | Engagement Level |
|-------------|------|----------------|---------------------|---------------------|-----------------|
| **Anh Vinh** (CIO/Director) | A — Accountable | Template embodies LTC operating principles; team adoption is real, not performative; ALPEI zones are the flow the Human Director follows | Strategic misalignment if template diverges from evolving LTC framework; no adoption signal until projects are underway; H↔H alignment conflated with H↔Agent alignment | Vision for LTC operating at professional fund level; pride when team operates without hand-holding; three learning types as organizational model for knowledge management | Low (approve + observe) |
| **Long Nguyen** (COE OPS, Builder) | R — Responsible | Clear scope boundary so build stays focused; feedback from consumers to improve the template; deterministic enforcement over probabilistic compliance | Scope creep from "while you're at it" requests; framework complexity that makes the template too heavy to clone; cascading hallucination in multi-agent handoffs (LT-1); agent drift exceeding scope (LT-8) | Building something the whole team uses long-term; proof that AI-assisted system design works in practice; multi-agent orchestration ready for I1 delivery | High (all decisions) |
| **Đạt** (Team Member, Builder/Dev) | C — Consulted | Subfolders have descriptions so agents don't guess and users don't skip; skills in nested folders must not be invocable outside intended scope; ADR/diagram/metadata folders in PLAN have specific guidance | Zone subfolders have no description — agents guess or bypass entirely without instructions [S2]; skills meant for one context bleed into others due to flat project-root placement; no description of what goes in ADR vs diagram vs metadata folders | Efficiency-oriented; wants to ship without agents producing misaligned output; motivated by explicit context that eliminates guesswork | High (builder feedback, sustainability issues) |
| **Khang** (Team Member, First Adopter) | C — Consulted | Knows where to start when he opens the repo; clear release announcement flow when template updates ship; version tracking that tells him which iteration, which version, what's current | No release announcement flow — doesn't know when updates ship or what changed [S2]; version tracking unclear — can't tell which iteration is current; git unfamiliarity creating friction before he even starts; too many folders with no obvious entry point | Wants to prove he can lead a project independently; motivated by clear wins and structured checklists; responds well to visible progress signals | High (primary test subject for UX, adopter feedback) |
| **Dong** (Team Member) | I — Informed | Templates that match the complexity of data/analytics work; clear ADR examples for technical decisions | Technical templates too generic for data pipeline decisions; framework overhead when he just needs to ship | Efficiency-oriented; motivated by not having to explain the same decisions twice | Medium (technical feedback) |
| **Other 5 Team Members** (Operators) | I — Informed | Onboarding path that doesn't require a 2-hour walkthrough; templates that make their first PR achievable | High cognitive load of 40+ files across 6 zones; not knowing which zone owns which type of decision; fear of doing it wrong | Desire to contribute without looking incompetent; peer recognition for following the system correctly | Low (passive consumers) |
| **Future AI Agents** (Claude Code, Gemini) | R — Responsible (execution) | CLAUDE.md and AGENTS.md that give full project context; zone structure that maps to ALPEI flow; subfolder descriptions so agents know what goes where (R06); explicit invocation context for skills | Ambiguous CLAUDE.md rules that require inference; missing subfolder descriptions force agents to guess context [S2-Đạt]; conflicting rules between CLAUDE.md and per-zone files; skills invoked outside intended scope [S2-Đạt] | Deterministic inputs producing reliable outputs; well-structured templates that guide completion rather than invention; explicit boundaries reduce hallucination risk | High (constant users) |

---

## RACI Legend
- **R** — Responsible (does the work)
- **A** — Accountable (owns the outcome)
- **C** — Consulted (provides input, two-way)
- **I** — Informed (kept in the loop, one-way)

**RACI Verification:** R (Long Nguyen) ≠ A (Anh Vinh) — satisfies UT#9 (D23 constraint).

**RACI uniqueness check:** Every stakeholder has exactly one primary RACI role:
- A: Vinh | R: Long, Agents | C: Đạt, Khang | I: Dong, Other 5 Members

---

## Primary User Profiles — Design-Quality Definition

### Profile 1: Khang (archetype for non-technical team members)

| Attribute | Description |
|-----------|-------------|
| **Operating context** | Receives a project directive from Anh Long or Anh Vinh. Has a laptop with GitHub Desktop or basic terminal. Has never used this template before. Has 30 minutes before his next meeting. |
| **Capability level** | Understands project management concepts but not software engineering practices. Knows what a folder is; doesn't know what a branch is. Can follow step-by-step instructions if they are explicit. Will not read a 1500-line guide before starting. |
| **Primary job-to-be-done** | "Get the project structured and start capturing work without looking incompetent or asking for help." |
| **Key constraints** | High cognitive load from other responsibilities; low tolerance for ambiguity; needs visible progress within the first 15 minutes or abandons the process; prone to skipping "optional" steps. |
| **Failure mode** | Opens the repo, sees 40+ files across 6 zones, no subfolder descriptions, no version signal — closes the repo and asks Long to set up the project instead. |
| **Specific needs from S2** | (1) Release announcement flow — wants to know when template updates ship and what changed. (2) Version tracking — needs to tell at a glance which iteration is current. (3) Visible entry point — README as navigation map, not a wall of links. |

### Profile 2: Đạt (archetype for builder/dev team members)

| Attribute | Description |
|-----------|-------------|
| **Operating context** | Working inside a cloned project repo with Claude Code as primary agent. Executing across ALPEI zones. Has development experience but follows LTC frameworks. |
| **Capability level** | Comfortable with git, CLI, and agent-assisted workflows. Understands the ALPEI zone model conceptually. Can read CLAUDE.md and zone READMEs. Notices when agents produce misaligned output. |
| **Primary job-to-be-done** | "Execute project work with agent assistance, knowing that the agent has enough context to operate correctly in each zone and subfolder." |
| **Key constraints** | Relies on agent to navigate zone structure; if subfolders lack descriptions, agents guess and produce wrong artifacts; skills invoked outside intended scope waste time and create confusion. |
| **Failure mode** | Agents guess which subfolder to use for an ADR vs a diagram vs metadata; Đạt doesn't catch the error; downstream artifacts build on misplaced work. Or: a skill meant for one context gets invoked in another, producing off-scope output that Đạt has to debug. |
| **Specific needs from S2** | (1) Subfolder descriptions so agents don't guess [R06]. (2) Skill scope enforcement — skills in nested folders must not be invocable outside intended scope [R07]. (3) Specific guidance for ADR, diagram, metadata folders in PLAN. |

### Profile 3: AI Agent (Claude Code, Gemini)

| Attribute | Description |
|-----------|-------------|
| **Operating context** | Reads CLAUDE.md first, then zone files. Operates within a single ALPEI zone per task. Receives structured context via 5-field packaging (EO, INPUT, EP, OUTPUT, VERIFY). |
| **Capability level** | Can follow explicit instructions deterministically. Cannot reliably infer intent from folder names alone. Needs boundary definitions to stay in scope. |
| **Primary job-to-be-done** | "Produce the correct zone artifact given a trigger + human context, without requiring the human to know the framework deeply." |
| **Key constraints** | Token budget limits context loading; deep nesting causes content skipping [S2-Khang]; missing descriptions force guessing [S2-Đạt]; conflicting rules between CLAUDE.md and zone files cause non-deterministic behavior. |
| **Failure mode** | Loads too much context, produces verbose framework-heavy documents that humans can't use. Or: loads too little context, guesses subfolder purpose, produces off-zone artifacts. |

---

## Anti-Persona — Who This Template Is NOT For

**Name/Role:** A solo software developer building a personal side project, or a startup team that wants a "flexible" project scaffold they can reshape freely.

| Why they are excluded | Design implication |
|----------------------|-------------------|
| They have existing folder conventions (src/, docs/, .github/) and will not adopt ALPEI zones | We do NOT make the template "flexible enough for any convention" — we enforce the LTC ALPEI structure |
| They don't need UBS/UDS/VANA — they think in tickets, PRs, and sprints | We do NOT simplify the framework to feel like Jira or Linear — the framework IS the point |
| They would fork the template and break the SSOT link on day one | We design for drift detection (template-check.sh), not fork prevention |
| They find `_genesis/` frameworks patronizing and would delete them | We do NOT add "why frameworks exist" apologies — context is in EFFECTIVENESS-GUIDE.md, loaded on-demand |
| They want minimal files (README + src/) and see 40+ files as bloat | We do NOT reduce the zone structure to accommodate minimalists — every zone serves a specific failure-prevention function |
| They would skip ALIGN and jump straight to EXECUTE | We design guardrails (DSBV phase ordering, zone READMEs) that make skipping ALIGN visibly costly, not silently possible |

**Design rule derived from anti-persona:** Optimize for Khang (non-technical, high cognitive load, needs obvious first step) and Đạt (builder, needs agent context clarity) — without removing the framework depth that makes the template valuable for Long and AI agents. Reject any proposal that makes the template "more flexible" at the cost of ALPEI zone integrity or framework depth.

---

## Key Stakeholder Risks

| Stakeholder | Risk | Likelihood (1-5) | Impact (1-5) | Risk Score | Mitigation |
|-------------|------|:-----------------:|:------------:|:----------:|------------|
| **Khang** | Opens repo, gets overwhelmed by 40+ files across 6 zones, abandons — asks Long directly instead | 4 | 4 | 16 | Root README is a 5-step navigation map; zone READMEs as "start here" guides; subfolder descriptions (R06) |
| **Khang** | Clones template but skips Zone 1 (ALIGN) because it looks like bureaucracy | 4 | 5 | 20 | Zone 1 README: "If you skip this, your Zone 4 work will be wrong. 20 minutes here saves 3 hours later." |
| **Khang** | Doesn't know when template updates ship or what version he's on — uses stale template | 3 | 4 | 12 | Release announcement flow (R08); VERSION file + CHANGELOG.md visible at root; version in frontmatter (R09) |
| **Đạt** | Agents guess subfolder purpose, produce artifacts in wrong location, Đạt doesn't catch the error | 4 | 4 | 16 | Subfolder descriptions in every zone (R06); ADR-004 decides the mechanism |
| **Đạt** | Skills invoked outside intended scope — a skill meant for one context bleeds into another | 3 | 3 | 9 | Skill scope enforcement via naming + manifest check (R07); multi-agent tool allowlists (ADR-007) |
| **Dong** | Uses the template but finds technical templates too generic, creates parallel convention | 3 | 3 | 9 | Include one worked example of a data/analytics ADR in 1-ALIGN/decisions/ |
| **Other members** | Treat every file as mandatory, get paralyzed by volume | 3 | 3 | 9 | README uses MoSCoW language: "Must read: 3 files. Should read: 5 files. Optional: the rest." |
| **AI Agents** | Agent reads CLAUDE.md, misses zone context, produces off-zone artifacts | 2 | 4 | 8 | CLAUDE.md maps zones to subsystems; subfolder descriptions (R06); per-agent tool allowlists |
| **Anh Vinh** | Template released but no adoption — teams keep using old ad-hoc structure | 2 | 5 | 10 | template-check.sh drift detection; adoption as primary success metric [S2-Vinh]; simplicity-first (S6) |
| **Long Nguyen** | Scope creep during build — adding "one more feature" delays release past I1 | 3 | 3 | 9 | Charter OUT OF SCOPE explicit; all new ideas go to 5-IMPROVE/changelog as future backlog |

---

## Per-Stakeholder UBS/UDS Summary

| Stakeholder | Top UBS (Blocking Force) | Top UDS (Driving Force) |
|-------------|--------------------------|-------------------------|
| **Vinh** | Template diverges from ALPEI framework evolution | Team operating at professional fund level without hand-holding |
| **Long** | Cascading hallucination in multi-agent handoffs (LT-1) | Multi-agent orchestration proving AI-assisted system design works |
| **Đạt** | Subfolders without descriptions → agents guess context | Explicit context eliminates guesswork, enabling efficient execution |
| **Khang** | No release flow + unclear version tracking → stale template usage | Visible progress signals + clear entry points → independent project leadership |
| **Dong** | Generic templates don't fit data/analytics decisions | Not having to explain the same decisions twice |
| **Other members** | 40+ files with no cognitive load management → paralysis | Contributing without looking incompetent |
| **AI Agents** | Missing subfolder descriptions → forced guessing → off-zone artifacts | Deterministic inputs → reliable outputs |

---

**Classification:** INTERNAL
