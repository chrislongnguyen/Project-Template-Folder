---
version: "1.3"
iteration: "I1: Concept"
status: Draft
last_updated: 2026-03-30
owner: Long Nguyen
---

# PROJECT CHARTER
# OPS_OE.6.4.LTC-PROJECT-TEMPLATE

## Project Name
LTC Project Template — Canonical Scaffold for LTC Partners

## Date
2026-03-30

## Owner
Long Nguyen / COE OPS

---

## 1. WHY — Purpose & Strategic Alignment

**Effective Outcome (EO):**
LTC team members can start any new project with correct ALPEI zone structure, embedded thinking frameworks, and AI agent configuration already in place — without spending a day rebuilding scaffolding from scratch or losing chain-of-thought across zones.

**Problem this solves:**
Without a standard scaffold, each LTC project starts from zero. Decision rationale lives in chat, risks go unrecorded, folder structures diverge across projects, and new team members have no map when they join. Cognitive overhead of setup consumes time that should go to domain work. AI agents operate without project context and produce misaligned output.

**Strategic Focus Area:** Operational Excellence (OE) — Layer 2 systems that build systems
**Core Area:** OPS_OE.6 Project Operations / Template Infrastructure

**Why now:** The team is scaling from 1 active project to 8+ concurrent projects. Without a standard, every project reinvents the wheel. Template amortizes the setup cost across all future projects and makes onboarding self-service. Multi-agent orchestration (4 agents, 3 EPs, eval gates) is ready for I1 — sustainability demands deterministic enforcement before scaling.

---

## 2. WHAT — Scope & Success Definition

**System Boundary:**

| Field | Definition |
|-------|-----------|
| **INPUT** | A new project trigger (idea, directive, or problem statement from a Director) |
| **EO** | The team member or agent can navigate to the right ALPEI zone, understand what to do, and produce the correct artifact — without needing to ask Long or re-read a long guide |
| **OUTPUT** | A populated, zone-appropriate artifact (Charter, ADR, Risk entry, etc.) that feeds downstream zones |

**Success = A non-technical Director (e.g., Khang) can clone this template, open the README, understand the structure in under 15 minutes, and know exactly where to put the first piece of work.**

**Zone Structure — ALPEI Flow:**
The template follows the ALPEI zone model. This is the flow the Human Director follows:

| Zone | Name | Purpose |
|------|------|---------|
| 0 | GOVERN | Agent governance — CLAUDE.md, AGENTS.md, .claude/, rules/ |
| 1 | ALIGN | Right outcome — charter, decisions, OKRs (Human↔Agent alignment) |
| 2 | LEARN | Research & synthesize — feeds back into ALIGN and forward into PLAN |
| 3 | PLAN | Minimize risks — architecture, UBS/UDS registers, roadmap |
| 4 | EXECUTE | Deliver — src, tests, config, docs |
| 5 | IMPROVE | Learn & grow — changelog, metrics, retros, reviews |
| _genesis | Shared | Org knowledge base — brand, frameworks, security, SOPs, templates |

**In Scope (I1):**

- ALPEI 5-zone folder structure with LEARN as separate zone (see ADR-001)
- CLAUDE.md, AGENTS.md, and .claude/ agent governance files pre-configured
- `_genesis/` knowledge base: brand, frameworks (UBS/UDS, three pillars, system design), security, SOPs, templates
- Charter, Stakeholders, Requirements, OKRs, ADR templates in 1-ALIGN/
- LEARN zone with subfolder structure supporting three learning types: genesis frameworks, tool/platform, per-project
- UBS/UDS registers, architecture templates, roadmap files in PLAN zone
- Multi-agent orchestration: 4 MECE agents, 3 enforcement hooks, 3 new EPs, eval gates (see ADR-007)
- README at root and per zone explaining purpose + entry point
- Subfolder descriptions so agents and users know what goes where (R06)
- template-check.sh validation script
- GitHub branching strategy (I0-I4) enforced via CLAUDE.md rules
- Feedback pipeline: /feedback skill → GitHub Issue
- Version tracking visible to all team members (R09)
- Human-centric training materials (user guide / training deck) in LEARN zone to support adoption and change management

**Out of Scope (I1):**

- Human↔Human alignment (philosophy, frameworks on WMS) — WMS scope, not repo scope
- Auto-populating zone artifacts for consumer projects (agent work, not template work)
- CI/CD pipelines for code-producing projects (consumer responsibility)
- Notion/ClickUp integration (consumer responsibility)
- Obsidian Bases as interim dashboard (ADR-003, deferred to I2)
- UI layer for non-git users (separate tool problem)
- Project-specific training materials beyond what the LEARN zone provides (consumer responsibility)
- Project-specific content (belongs in consumer repos)
- Architecture design (Zone 3 PLAN scope)

### Scope Delta (v1.0 draft → v1.2)

| v1.0 Draft (2026-03-26) | v1.2 Current (2026-03-30) | Reason |
|--------------------------|---------------------------|--------|
| "5 zones: Zone 0–4 + `_shared/`" | ALPEI: 6 zones with LEARN as separate zone | Vinh formal request [S1] — ADR-001 |
| `_shared/` knowledge base | `_genesis/` knowledge base | Renamed in PR #6, reflects origin/source semantics |
| Sc2: "LEARN-inside-ALIGN" | Removed — LEARN is its own zone | Contradicts S1 directive |
| No multi-agent scope | Multi-agent orchestration: 4 agents, 3 EPs, eval gates | Approved design spec [S4] — ADR-007 |
| No subfolder descriptions | Subfolder descriptions required | Team feedback [S2-Dat]: agents guess, users skip |
| No version tracking mention | Version tracking explicitly in scope | Team feedback [S2-Khang]: unclear release/version |
| I1 complete 2026-03-28 | Timeline refreshed — I1 ongoing | Stale dates |
| Out of scope: "Notion/ClickUp" only | Out of scope: Human↔Human alignment, Obsidian Bases | Vinh scoping [S1]: H↔H alignment is WMS scope |

---

## 3. WHO — Stakeholders
See `STAKEHOLDERS.md` for the full stakeholder analysis.

**Primary User (EU):**
- **Directors building projects:** Khang, Dong, and future team members who clone this template to start a real project. Non-technical, high cognitive load, need structure that makes the right action obvious.
- **Agents working inside cloned repos:** Claude Code, Gemini, and future AI agents who read CLAUDE.md and zone files to understand project context and operate correctly.

**Accountable:** Anh Vinh (CIO) — strategic direction, template governance
**Responsible (Builder):** Long Nguyen — design, build, maintain

---

## 4. HOW — Approach & Principles

**Governing Principles (EP) — bucketed by 3 pillars:**

**Sustainability (manage failure risk first):**
- S1: Every zone must have a README that answers "what do I do here?" — no zone should require external explanation to navigate
- S2: Templates contain guard rails, not just blank fields — each template section gets a one-line instruction and a bad-example warning where common mistakes occur
- S3: Agent governance (CLAUDE.md) is the first file any agent reads — all rules live there, never scattered
- S4: Branching strategy (I0-I4) is enforced at the template level — main is always clean, work happens on branches
- S5: ALPEI zones are the flow the Human Director follows; DSBV is how agents produce artifacts within each zone — not a user-facing workflow [S2-Vinh]
- S6: Simplicity first — friction kills adoption. Every feature must pass the friction test: does this make the template harder to start using? [S2-consensus]
- S7: Deterministic over probabilistic enforcement — move from ~85% rule compliance (agent self-enforcement) to ~100% via hooks and allowlists [S4]
- S8: Human adoption risks (UBS) must be addressed before or alongside agent-facing risks. A technically correct system that nobody adopts has failed the sustainability pillar.

**Efficiency (minimize waste):**
- E1: Principle of least surprise — folder names are self-explanatory; acronyms defined on first use; no hidden conventions
- E2: Templates are lean — one template per artifact type, not one per project variation
- E3: The agent does the heavy lifting — templates designed so an agent can populate them given a trigger + human context, without requiring the human to know the framework deeply
- E4: `_genesis/` is write-once-read-many — shared frameworks are not duplicated per zone
- E5: Agent context must be explicit — provide descriptions, boundaries, and intended invocation context so agents don't guess [S2-Dat]

**Scalability (hold at 10x):**
- Sc1: Template is cloneable without modification — a new project is `git clone` + rename, not copy-paste-customize
- Sc2: Agent config is modular — adding a new agent (Gemini, GPT-4) requires adding one file, not rewriting CLAUDE.md
- Sc3: Three types of learning (genesis frameworks, tool/platform, per-project) have different lifecycles and storage needs — the template must accommodate all three [S2-Vinh]

**Iteration logic:** I1 = Sustainability, I2 = Efficiency, I3+ = Scalability. Prioritization follows S > E > Sc within each iteration.

---

## 5. WHEN — Timeline

**Target Start:** 2026-03-19 (design began)
**I1 Target Complete:** 2026-04-14 (revised — ALIGN revision + multi-agent build)
**Target PR to main:** 2026-04-18

**Key Milestones:**
- [x] I0 — Scaffold built, 8/8 zones audited (2026-03-19)
- [x] I0 — SSOT restructured, v2 glossary applied (2026-03-22)
- [ ] I1 — ALIGN package: Charter, Stakeholders, Requirements, ADRs (2026-04-04)
- [ ] I1 — LEARN zone extraction: separate zone with 3 learning types (2026-04-07)
- [ ] I1 — Multi-agent orchestration: 4 agents, 3 EPs, hooks, eval gates (2026-04-11)
- [ ] I1 — PLAN package: UBS Register, UDS Register, Architecture (2026-04-14)
- [ ] Release PR to main with CHANGELOG entry (2026-04-18)

---

## 6. RISKS — Initial UBS Scan

**Top 5 risks identified at charter stage:**

1. **Cognitive overload on first clone (UX risk — A-perspective)**
   The template has 40+ files across 6 zones. A non-technical director (Khang) opens the repo and sees a wall of folders with no clear entry point. They close the repo and ask Long directly.
   **Mitigation:** Root README as navigation map; zone READMEs as "start here" guides; subfolder descriptions (R06); template-check.sh provides first-run orientation.

2. **Framework complexity creates agent drift (R-perspective — builder risk)**
   If agents load too much context, they produce artifacts that follow the letter of the framework but miss the spirit — generating verbose, framework-heavy documents that are hard for humans to use.
   **Mitigation:** CLAUDE.md rules limit context loads; templates are pre-structured so agents fill in, not invent; multi-agent roster with scoped tool allowlists (ADR-007).

3. **Template drift — consumer repos diverge from canonical (Sc risk)**
   Teams customize their cloned repos. Over time, the template and all consumer repos drift.
   **Mitigation:** template-check.sh detects version drift; CHANGELOG tracks template version; major structural changes are ADR-documented.

4. **Adoption friction kills template before it proves value (Su risk — S2/consensus)**
   Team members find the template too complex or prescriptive and revert to ad-hoc project setup.
   **Mitigation:** Simplicity-first principle (S6); subfolder descriptions; version tracking visibility; don't introduce solutions before users hit the problem (R12).

5. **Cascading hallucination in multi-agent handoffs (Su risk — S4/LT-1)**
   One agent produces a subtly wrong artifact; downstream agents treat it as authoritative and amplify the error.
   **Mitigation:** Eval gates with measured evidence before shipping; verify-deliverables hook; hypothesis-driven approach (ADR-007).

See `3-PLAN/risks/UBS_REGISTER.md` for the full risk register.

---

**Classification:** INTERNAL
