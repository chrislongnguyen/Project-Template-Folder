---
version: "1.1"
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
2026-03-26

## Owner
Long Nguyen / COE OPS

---

## 1. WHY — Purpose & Strategic Alignment
<!-- ESD §3.2: EO format — "[User] [desired state] without [constraint]" -->

**Effective Outcome (EO):**
LTC team members can start any new project with correct structure, embedded thinking frameworks, and AI agent configuration already in place — without spending a day rebuilding scaffolding from scratch or losing chain-of-thought across zones.

**Problem this solves:**
Without a standard scaffold, each LTC project starts from zero. Decision rationale lives in chat, risks go unrecorded, folder structures diverge across projects, and new team members have no map when they join. Cognitive overhead of setup consumes time that should go to domain work. AI agents operate without project context and produce misaligned output.

**Strategic Focus Area:** Operational Excellence (OE) — Layer 2 systems that build systems
**Core Area:** OPS_OE.6 Project Operations / Template Infrastructure

**Why now:** The team is scaling from 1 active project to 8+ concurrent projects. Without a standard, every project reinvents the wheel. Template amortizes the setup cost across all future projects and makes onboarding self-service.

---

## 2. WHAT — Scope & Success Definition
<!-- ESD §3.0: System boundary — define INPUT/EO/OUTPUT contract -->

**System Boundary:**

| Field | Definition |
|-------|-----------|
| **INPUT** | A new project trigger (idea, directive, or problem statement from a Director) |
| **EO** | The team member or agent can navigate to the right zone, understand what to do, and produce the correct artifact — without needing to ask Long or re-read a long guide |
| **OUTPUT** | A populated, zone-appropriate artifact (Charter, ADR, Risk entry, etc.) that feeds downstream zones |

**Success = A non-technical Director (e.g., Khang) can clone this template, open the README, understand the structure in under 15 minutes, and know exactly where to put the first piece of work.**

**In Scope:**
- 5-zone folder structure (Zone 0–4 + _shared) with zone-appropriate placeholder files
- CLAUDE.md, AGENTS.md, and .claude/ agent governance files pre-configured
- _shared/ knowledge base: brand, frameworks (UBS/UDS, three pillars, system design), security, SOPs, templates
- Charter, Stakeholders, Requirements, OKRs, ADR templates in 1-ALIGN/
- UBS/UDS registers, architecture templates, roadmap files in 3-PLAN/
- README at root and per zone explaining purpose + entry point
- template-check.sh validation script
- GitHub branching strategy (I0-I4) enforced via CLAUDE.md rules
- Feedback pipeline: /feedback skill → GitHub Issue

**Out of Scope:**
- Auto-populating zone artifacts for consumer projects (that is agent work, not template work)
- CI/CD pipelines for code-producing projects (consumer responsibility)
- Notion/ClickUp integration (consumer responsibility)
- UI layer for non-git users (a separate tool problem — not this template)
- Training materials or guides beyond README and zone READMEs
- Project-specific content (any actual project work belongs in a consumer repo, not here)

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
<!-- ESD §3.3 (UDS) for initial drivers. S/E/Sc bucketed per ESD §4.1.
     NOTE: Initial governing principles only. Full Phase 2 system design
     (environment, tools, EOP) is Zone 2 scope. -->

**Governing Principles (EP) — bucketed by 3 pillars:**

**Sustainability (manage failure risk first):**
- S1: Every zone must have a README that answers "what do I do here?" — no zone should require external explanation to navigate
- S2: Templates contain guard rails, not just blank fields — each template section gets a one-line instruction and a bad-example warning where common mistakes occur
- S3: Agent governance (CLAUDE.md) is the first file any agent reads — all rules live there, never scattered
- S4: Branching strategy (I0-I4) is enforced at the template level — main is always clean, work happens on branches

**Efficiency (minimize waste):**
- E1: Principle of least surprise — folder names are self-explanatory; acronyms are defined on first use; no hidden conventions
- E2: Templates are lean — one template per artifact type, not one template per project variation
- E3: The agent does the heavy lifting — templates are designed so an agent can populate them given a project trigger + human context, without requiring the human to know the framework deeply
- E4: _shared/ is write-once-read-many — shared frameworks are not duplicated per zone

**Scalability (hold at 10x):**
- Sc1: Template is cloneable without modification — a new project is `git clone` + rename, not copy-paste-customize
- Sc2: Zone structure supports 5 concurrent workstreams (ALIGN, PLAN, EXECUTE, IMPROVE, LEARN-inside-ALIGN) without folder collisions
- Sc3: Agent config is modular — adding a new agent (Gemini, GPT-4) requires adding one file, not rewriting CLAUDE.md

---

## 5. WHEN — Timeline

**Target Start:** 2026-03-19 (design began)
**I1 Concept Complete:** 2026-03-28 (ALIGN package, PLAN package drafted)
**I2 Scaffold Complete:** 2026-04-04 (all zone files populated, template-check.sh passing)
**Target PR to main:** 2026-04-07

**Key Milestones:**
- [x] I0 — Scaffold built, 8/8 zones audited (2026-03-19)
- [x] I0 — SSOT restructured, v2 glossary applied (2026-03-22)
- [ ] I1 — ALIGN package: Charter, Stakeholders, Requirements (2026-03-28)
- [ ] I1 — PLAN package: UBS Register, UDS Register, Architecture (2026-04-01)
- [ ] I2 — EXECUTE package: all templates reviewed, README updated (2026-04-04)
- [ ] Release PR to main with CHANGELOG entry (2026-04-07)

---

## 6. RISKS — Initial UBS Scan
<!-- ESD §3.4: Role-aware — analyze from BOTH R perspective AND A perspective (D25) -->

**Top 3 risks identified at charter stage:**

1. **Cognitive overload on first clone (UX risk — A-perspective)**
   The template has 40+ files across 5 zones. A non-technical director (Khang) opens the repo and sees a wall of folders with no clear entry point. They don't know where to start, close the repo, and ask Long directly.
   Mitigation: Root README as navigation map; zone READMEs as "start here" guides; template-check.sh provides first-run orientation; GETTING_STARTED.md in 4-EXECUTE/docs/

2. **Framework complexity creates agent drift (R-perspective — builder risk)**
   The EFFECTIVENESS-GUIDE.md is 1505 lines. If agents load too much context, they produce artifacts that follow the letter of the framework but miss the spirit — generating verbose, framework-heavy documents that are hard for humans to use.
   Mitigation: CLAUDE.md rules limit context loads to 2-3 docs per step; templates are pre-structured so agents fill in, not invent; ESD references are one-line pointers, not inline explanations.

3. **Template drift — consumer repos diverge from canonical (Sc risk)**
   Teams customize their cloned repos. Over time, the template and all consumer repos drift. When the template is updated, consumer repos don't benefit and the standard is lost.
   Mitigation: template-check.sh detects version drift; branching strategy keeps main clean; CHANGELOG tracks template version; major structural changes are ADR-documented so teams can migrate deliberately.

See `3-PLAN/risks/UBS_REGISTER.md` for the full risk register.

---

**Classification:** INTERNAL
