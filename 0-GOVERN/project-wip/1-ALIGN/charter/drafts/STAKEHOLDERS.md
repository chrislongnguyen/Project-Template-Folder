---
version: "1.1"
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
| **Anh Vinh** (CIO) | A — Accountable | Template embodies LTC operating principles; team adoption is real, not performative; template reduces onboarding overhead | Strategic misalignment if template diverges from evolving LTC framework; no adoption signal until projects are underway | Vision for LTC operating at professional fund level; pride when team operates without hand-holding | Low (approve + observe) |
| **Long Nguyen** (COE OPS, Builder) | R — Responsible | Clear scope boundary so build stays focused; feedback from consumers to improve the template; time to build correctly | Scope creep from "while you're at it" requests; framework complexity that makes the template too heavy to clone; perfectionism preventing I0 release | Building something the whole team uses long-term; proof that AI-assisted system design works in practice | High (all decisions) |
| **Khang** (Team Member, First Adopter) | C/I — Consulted + Informed | Knows where to start when he opens the repo; folder names that map to his mental model; can complete his first artifact without asking Long | Git unfamiliarity creating friction before he even starts working; too many folders make him anxious; framework jargon (UBS, VANA, EOP) with no plain-language explanation in sight | Wants to prove he can lead a project independently; motivated by clear wins; responds well to structured checklists | High (primary test subject for UX) |
| **Dong** (Team Member) | C/I — Consulted + Informed | Templates that match the complexity of data/analytics work; clear ADR examples for technical decisions | Technical templates that are too generic for data pipeline decisions; framework overhead when he just needs to ship | Efficiency-oriented; motivated by not having to explain the same decisions twice | Medium (technical feedback) |
| **Other 6 Team Members** (Operators) | I — Informed | Onboarding path that doesn't require a 2-hour walkthrough; templates that make their first PR achievable | High cognitive load of 40+ files; not knowing which zone owns which type of decision; fear of doing it wrong | Desire to contribute without looking incompetent; peer recognition for following the system correctly | Low (passive consumers) |
| **Future AI Agents** (Claude Code, Gemini) | R — Responsible (execution) | CLAUDE.md and AGENTS.md that give full project context without requiring long reads; zone structure that maps to the 8-component model; clear EO in every charter | Ambiguous CLAUDE.md rules that require inference; missing zone READMEs that force agents to guess context; conflicting rules between CLAUDE.md and per-zone files | Deterministic inputs producing reliable outputs; well-structured templates that guide completion rather than invention | High (constant users) |

---

## RACI Legend
- **R** — Responsible (does the work)
- **A** — Accountable (owns the outcome)
- **C** — Consulted (provides input, two-way)
- **I** — Informed (kept in the loop, one-way)

**RACI Verification:** R (Long Nguyen) ≠ A (Anh Vinh) — satisfies UT#9 (D23 constraint).

---

## Primary User Profile — Design-Quality Definition

**Name/Role:** Khang (archetype for all non-technical team members who clone this template)

| Attribute | Description |
|-----------|-------------|
| **Operating context** | Receives a project directive from Anh Long or Anh Vinh. Has a laptop with GitHub Desktop or basic terminal. Has never used this template before. Has 30 minutes before his next meeting. |
| **Capability level** | Understands project management concepts but not software engineering practices. Knows what a folder is; doesn't know what a branch is. Can follow step-by-step instructions if they are explicit. Will not read a 1500-line guide before starting. |
| **Primary job-to-be-done** | "Get the project structured and start capturing work without looking incompetent or asking for help." |
| **Key constraints** | High cognitive load from other responsibilities; low tolerance for ambiguity; needs visible progress within the first 15 minutes or abandons the process; prone to skipping "optional" steps. |
| **Failure mode** | Opens the repo, sees `_shared/frameworks/EFFECTIVENESS-GUIDE.md` listed in the README, assumes he must read it before doing anything, spends 45 minutes reading, loses momentum, asks Long to set up the project for him instead. |

---

## Anti-Persona — Who This Template Is NOT For

**Name/Role:** A solo software developer building a personal side project or a highly technical ML researcher

| Why they are excluded | Design implication |
|----------------------|-------------------|
| They have existing folder conventions and will not adopt a new one | We do not make the template "flexible enough for any convention" — we enforce the LTC structure |
| They don't need the UBS/UDS/VANA framework — they think in tickets and PRs | We do not simplify the framework to make it feel like Jira — the framework is the point |
| They will fork the template and break the SSOT link immediately | template-check.sh drift detection exists — but we do not design the template to prevent power users from customizing |
| They would find the _shared/ frameworks patronizing | We do not add "why frameworks exist" explanations in every file — the context is in EFFECTIVENESS-GUIDE.md, loaded on-demand |

**Design rule derived from anti-persona:** Optimize for Khang (non-technical, high cognitive load, needs obvious first step) without removing the framework depth that makes the template valuable for Long and AI agents.

---

## Key Stakeholder Risks

| Stakeholder | Risk | Likelihood (1-5) | Impact (1-5) | Risk Score | Mitigation |
|-------------|------|:-----------------:|:------------:|:----------:|------------|
| **Khang** | Opens repo, gets overwhelmed, abandons — asks Long directly instead | 4 | 4 | 16 | Root README is a 5-step navigation map, not a wall of links; GETTING_STARTED.md is the first file listed |
| **Khang** | Clones template but skips Zone 1 (ALIGN) because it looks like bureaucracy | 4 | 5 | 20 | Zone 1 README explicitly states: "If you skip this, your Zone 3 work will be wrong. 20 minutes here saves 3 hours later." |
| **Dong** | Uses the template but finds technical templates too generic, creates his own parallel convention | 3 | 3 | 9 | Include one worked example of a data/analytics ADR in 1-ALIGN/decisions/ — shows the template handles technical decisions |
| **Other team members** | Treat every file as mandatory, get paralyzed by volume | 3 | 3 | 9 | README uses MoSCoW language: "Must read: 3 files. Should read: 5 files. Optional: the rest." |
| **Future Agents** | Agent reads CLAUDE.md, misses zone context, produces off-zone artifacts | 2 | 4 | 8 | CLAUDE.md explicitly maps zones to subsystems; each zone README reinforces the boundary |
| **Anh Vinh** | Template is released but no adoption — teams keep using old ad-hoc structure | 2 | 5 | 10 | template-check.sh gives visible "you're using v1.0" signal; adoption is tracked via GitHub insights + standup checkin |
| **Long Nguyen** | Scope creep during build — adding "one more feature" delays release past I1 | 3 | 3 | 9 | Charter OUT OF SCOPE section is explicit; all new ideas go to 5-IMPROVE/changelog as future backlog |

---

**Classification:** INTERNAL
