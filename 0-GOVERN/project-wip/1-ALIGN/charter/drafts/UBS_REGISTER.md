---
version: "1.1"
iteration: "I1: Concept"
status: Draft
last_updated: 2026-03-30
owner: Long Nguyen
---

# UBS REGISTER — Ultimate Blocking System Identification
# OPS_OE.6.4.LTC-PROJECT-TEMPLATE
## Derived From: ESD §3.4 — Role-Aware UBS Analysis (R + A perspectives)
## Lens: Team 2 — User Experience & Adoption Barriers

---

## Key Principle
> The UBS exerts stronger influence than the UDS on valuable outcomes.
> Always prioritize risk mitigation over output maximization.
> Trace blockers to ROOT CAUSES, not symptoms.
> This register covers BOTH R-perspective (what blocks Long from building correctly)
> and A-perspective (what blocks Directors from adopting and using the template correctly).

---

## Active Blockers

---

### UBS-001: Overwhelming First Impression — "The Wall of Files"

| Layer | Question | Analysis |
|-------|----------|----------|
| **1.0 UBS** | What ultimately blocks success? | A non-technical director (Khang archetype) opens the cloned repo, sees 40+ files across unfamiliar folder names, feels instant cognitive overload, and closes the repo — asking Long directly instead of self-serving |
| **1.1 UBS.UB** | What prevents overcoming this blocker? | The template must be comprehensive (complete framework) AND approachable (digestible in 15 minutes) — these are genuinely in tension. Every file added to improve completeness makes the first impression worse |
| **1.2 UBS.UD** | What drives/enables this blocker? | LTC's framework depth is a feature, not a bug — but all the depth is visible at once. There is no progressive disclosure: the user sees ALL zones, ALL files, ALL frameworks simultaneously |
| **1.3 UBS.Principles** | Why does this blocker exist? | Miller's Law (cognitive limit: 7±2 items) is violated at every level: root has 10+ items, each zone has 6-8 sub-folders. There is no hierarchy of importance — all items look equally mandatory |
| **1.4 UBS.Environment** | What environment enables this blocker? | GitHub's default tree view shows all files equally. No visual hierarchy. No README preview in the folder browser. The .claude/, .cursor/, .gemini/ agent-internal folders appear prominent alongside user-facing zones |
| **1.5 UBS.Tools** | What tools enable this blocker? | Git/GitHub has no native "progressive disclosure" feature — you see everything or nothing. README.md renders at the folder level but only if you navigate to it, not before you see the file list |
| **1.6 UBS.Procedure** | What process enables this blocker? | Cloning gives immediate full file tree access. No onboarding gate before full access. No "welcome screen" that says "here is your first task" before the full structure is visible |

**Root-Cause Resolution:** Invest in the README as the "first and only screen" that matters — make the root README so clear and action-oriented that users read it before exploring the tree. Use numbering (1-ALIGN, 3-PLAN) to impose visual hierarchy. Dot-prefix agent-internal folders to push them below human-facing content.
**Mitigation:** REQ-001 (zone navigation), REQ-002 (first-run orientation), REQ-006 (cognitive load limit)
**Likelihood:** 4
**Impact:** 5
**Risk Score:** 20
**Owner:** Long Nguyen
**Status:** Open — mitigations in REQ-001, REQ-002, REQ-006

---

### UBS-002: Zone 1 Skip — "Bureaucracy Tax" Perception

| Layer | Question | Analysis |
|-------|----------|----------|
| **1.0 UBS** | What ultimately blocks success? | Team members perceive Zone 1 (ALIGN) as overhead documentation that delays "real work" — they skip directly to Zone 3 (EXECUTE) and start producing artifacts without alignment, resulting in work that must be redone |
| **1.1 UBS.UB** | What prevents overcoming this blocker? | The pain of skipping Zone 1 is delayed (becomes visible in Zone 3) while the pain of doing Zone 1 is immediate. Behavioral incentives favor skipping. The template cannot enforce sequential zone completion |
| **1.2 UBS.UD** | What drives/enables this blocker? | "I know what I'm building" confidence (often misplaced). Time pressure. Zone 1 template looks like corporate documentation: Stakeholder maps, RACI tables, VANA requirements — none of these feel like progress to a builder |
| **1.3 UBS.Principles** | Why does this blocker exist? | Humans are output-oriented, not process-oriented. Zone 1 produces no "shippable" artifact — it produces thinking artifacts. Its value is invisible until Zone 3 fails |
| **1.4 UBS.Environment** | What environment enables this blocker? | No enforcement mechanism in git. No CI check that fails if Zone 1 is empty before Zone 3 is populated. Zone 3 is accessible without completing Zone 1 — the path of least resistance is always available |
| **1.5 UBS.Tools** | What tools enable this blocker? | Git allows any file to be modified in any order. template-check.sh (current) only checks structure, not sequencing compliance |
| **1.6 UBS.Procedure** | What process enables this blocker? | The current SOP doesn't have an enforced gate between zones. There is a "conditions for success" checklist but it is advisory, not blocking |

**Root-Cause Resolution:** Zone 1 README must make the cost of skipping viscerally clear and immediate. Add a one-sentence warning at the top: "If you skip this zone, your Zone 3 work will be misaligned and require rework. 20 minutes here prevents 3 hours of rework later." Also: template-check.sh could optionally warn if Zone 3 has content but Zone 1 charter is still at placeholder state.
**Mitigation:** REQ-002 (first-run orientation), REQ-003 (inline instructions with skip-cost warnings), REQ-008 (MoSCoW labels make Zone 1 "must read" explicit)
**Likelihood:** 4
**Impact:** 5
**Risk Score:** 20
**Owner:** Long Nguyen
**Status:** Open — partial mitigation via README design

---

### UBS-003: Framework Jargon Barrier

| Layer | Question | Analysis |
|-------|----------|----------|
| **1.0 UBS** | What ultimately blocks success? | Team members encounter UBS, UDS, VANA, EO, RACI, EP, EOT, EOP as unexplained acronyms on their first pass through a template. They stop filling in the template and either ask Long or fill in fields incorrectly |
| **1.1 UBS.UB** | What prevents overcoming this blocker? | The framework IS complex — it cannot be simplified without losing its value. The acronyms are load-bearing. Replacing them with plain English throughout would make the framework less rigorous |
| **1.2 UBS.UD** | What drives/enables this blocker? | Acronyms were created for experts who already know the framework. Templates were designed for experts first, new users second. The glossary and EFFECTIVENESS-GUIDE.md exist but are not inline — they require separate navigation |
| **1.3 UBS.Principles** | Why does this blocker exist? | Expert knowledge illusion: framework builders (Long, Anh Vinh) assume familiarity. New users have zero exposure to LTC's proprietary framework language before their first project |
| **1.4 UBS.Environment** | What environment enables this blocker? | No glossary in the template itself. _shared/frameworks/ contains definitions but only if you navigate there. Templates have placeholder text but no contextual definitions |
| **1.5 UBS.Tools** | What tools enable this blocker? | Markdown has no hover-tooltip for inline definitions. The only mechanism available is: inline HTML comments (visible in editor), parenthetical expansions, or links to glossary |
| **1.6 UBS.Procedure** | What process enables this blocker? | Templates are designed to be filled in top-to-bottom. When a user hits an unknown acronym, there is no "what does this mean?" path embedded in the template itself |

**Root-Cause Resolution:** First-use expansion rule: every acronym appears with full expansion on first use IN THAT FILE (e.g., "UBS (Ultimate Blocking System — the forces preventing your project from succeeding)"). This is non-negotiable for all charter-level templates. Agent-internal files (CLAUDE.md, rules/) may use shorthand.
**Mitigation:** REQ-003 (plain-language instructions in every template field)
**Likelihood:** 4
**Impact:** 4
**Risk Score:** 16
**Owner:** Long Nguyen
**Status:** Open — partial (EFFECTIVENESS-GUIDE.md exists but not inline)

---

### UBS-004: Agent Context Gap — "CLAUDE.md Is Loaded But Project Is Unknown"

| Layer | Question | Analysis |
|-------|----------|----------|
| **1.0 UBS** | What ultimately blocks success? | An AI agent loads CLAUDE.md from a consumer repo (cloned from this template), reads generic project rules, but has NO knowledge of the specific project (what it is, who it's for, what the EO is) — and produces artifacts that follow the template structure but contain wrong content |
| **1.1 UBS.UB** | What prevents overcoming this blocker? | The template cannot pre-populate project-specific content by definition — it is a template. The agent must infer project context from whatever the Human has filled in. If Zone 1 is empty, the agent has nothing to work with |
| **1.2 UBS.UD** | What drives/enables this blocker? | Agents are stateless between sessions. CLAUDE.md gives rules but not project identity. If Charter is empty and the agent is asked to "fill in the UBS register," it will generate plausible-sounding but wrong risks |
| **1.3 UBS.Principles** | Why does this blocker exist? | The template is designed for agents to ASSIST humans, not to operate without humans. But in practice, teams ask agents to "set up the project" before any human input is provided |
| **1.4 UBS.Environment** | What environment enables this blocker? | Claude Code sessions start fresh. Memory systems (memory-vault) help but require setup. An agent working in a new clone has no history |
| **1.5 UBS.Tools** | What tools enable this blocker? | Memory vault plugin exists but is not mandatory. CLAUDE.md pre-flight protocol requires reading Charter first — but if Charter is empty, the pre-flight provides no context |
| **1.6 UBS.Procedure** | What process enables this blocker? | Pre-flight protocol says "read Charter" but does not say "STOP if Charter is empty — ask Human Director for EO before proceeding" |

**Root-Cause Resolution:** CLAUDE.md pre-flight protocol must include a conditional: "If Charter EO is still at placeholder state, do NOT proceed with any artifact production. Ask Human Director: 'Before we start, I need to know the EO for this project. In one sentence: [User] [desired state] without [constraint].'"
**Mitigation:** REQ-004 (agent orientation), CLAUDE.md pre-flight protocol update
**Likelihood:** 3
**Impact:** 5
**Risk Score:** 15
**Owner:** Long Nguyen
**Status:** Open — CLAUDE.md pre-flight needs conditional

---

### UBS-005: Wrong-Zone Artifact Placement

| Layer | Question | Analysis |
|-------|----------|----------|
| **1.0 UBS** | What ultimately blocks success? | Team members (and agents) place artifacts in the wrong zone — decisions in Zone 3, risks in Zone 1, architecture in Zone 4. Over time, zone SST breaks down and the template becomes an unorganized file dump |
| **1.1 UBS.UB** | What prevents overcoming this blocker? | Zone ownership is not obvious for cross-cutting artifacts. Where does a "decision about what tools to use in Zone 3" go? Zone 1 (ADR) or Zone 3 (config)? The line is not always clear |
| **1.2 UBS.UD** | What drives/enables this blocker? | People work where they are, not where they should be. If someone is in Zone 3 and has a risk thought, they document it in Zone 3 rather than navigating to Zone 2 |
| **1.3 UBS.Principles** | Why does this blocker exist? | Zone boundaries are conceptual, not physical. Nothing in the file system prevents cross-zone placement |
| **1.4 UBS.Environment** | What environment enables this blocker? | Git allows any file anywhere. No enforcement layer checks zone-artifact type matching |
| **1.5 UBS.Tools** | What tools enable this blocker? | template-check.sh does not check that artifacts are zone-appropriate, only that required files exist |
| **1.6 UBS.Procedure** | What process enables this blocker? | Zone READMEs define what belongs here, but there is no "what does NOT belong here and where should it go" section |

**Root-Cause Resolution:** Each zone README must include a "NOT HERE" section: 3-5 examples of artifacts that look like they belong here but actually go elsewhere, with the correct destination. This prevents the most common misplacements.
**Mitigation:** REQ-001 (zone navigation clarity), REQ-008 (MoSCoW README labels)
**Likelihood:** 3
**Impact:** 3
**Risk Score:** 9
**Owner:** Long Nguyen
**Status:** Open — zone README design not yet finalized

---

### UBS-006: Git Barrier for Non-Technical Users

| Layer | Question | Analysis |
|-------|----------|----------|
| **1.0 UBS** | What ultimately blocks success? | Khang does not know how to clone a repo, create a branch, or commit a file. The template's version control infrastructure (I0-I4 branching strategy) is invisible and inaccessible to him — he uses Finder to copy files or edits directly on main |
| **1.1 UBS.UB** | What prevents overcoming this blocker? | This is a genuine capability gap. Teaching git is outside the scope of this template. But ignoring the gap means non-technical users will circumvent the version control system, breaking the branching strategy |
| **1.2 UBS.UD** | What drives/enables this blocker? | Git's UX is optimized for software developers. GitHub Desktop reduces friction but still requires understanding commits, branches, and pull requests — concepts that are new to non-technical directors |
| **1.3 UBS.Principles** | Why does this blocker exist? | The template assumes a minimum git literacy level that not all team members have. This assumption is embedded in the branching strategy and is never stated explicitly |
| **1.4 UBS.Environment** | What environment enables this blocker? | GitHub web UI allows file editing but not branch creation easily. GitHub Desktop requires installation. Terminal is non-starter for non-technical users |
| **1.5 UBS.Tools** | What tools enable this blocker? | No "git for non-technical LTC users" guide exists in the template |
| **1.6 UBS.Procedure** | What process enables this blocker? | GETTING_STARTED.md (if it exists) assumes git familiarity. Onboarding flow does not include "if you don't know git, do these 3 things first" |

**Root-Cause Resolution:** GETTING_STARTED.md must include a prerequisite check: "Can you run `git clone [url]` in your terminal? If yes, proceed. If no, install GitHub Desktop and follow these 3 steps first." This makes the assumption explicit and provides a path for non-technical users WITHOUT making the template git-free (that would reduce its value for power users).
**Mitigation:** REQ-002 (first-run orientation — GETTING_STARTED.md)
**Likelihood:** 3
**Impact:** 4
**Risk Score:** 12
**Owner:** Long Nguyen
**Status:** Open — GETTING_STARTED.md not yet written

---

### UBS-007: Feedback Loop Closure Failure

| Layer | Question | Analysis |
|-------|----------|----------|
| **1.0 UBS** | What ultimately blocks success? | Team members encounter friction (confusing README, wrong template field, broken script) but don't report it. The template never improves. Long hears about problems months later via casual conversation, if at all |
| **1.1 UBS.UB** | What prevents overcoming this blocker? | Reporting friction requires effort — finding a channel, writing it up, not wanting to bother Long. The path of least resistance is to work around the problem and forget it |
| **1.2 UBS.UD** | What drives/enables this blocker? | No explicit "report issues here" mechanism embedded in the template. CLAUDE.md mentions /feedback skill but only in a trigger condition ("when user expresses frustration") — not as a standing invitation |
| **1.3 UBS.Principles** | Why does this blocker exist? | Feedback systems require pull AND push: users must want to report AND the system must make reporting easy. Currently only one side works |
| **1.4 UBS.Environment** | What environment enables this blocker? | GitHub Issues is the right tool but requires knowing the template repo URL and having permissions. In-context agent trigger is more accessible |
| **1.5 UBS.Tools** | What tools enable this blocker? | /feedback skill exists (Zone 4) but is not discoverable from the README or from within templates |
| **1.6 UBS.Procedure** | What process enables this blocker? | No "how to report a template problem" step exists in any onboarding document |

**Root-Cause Resolution:** Make /feedback discoverable at the point of friction: (1) add a "Report a template issue" line at the bottom of every zone README, (2) CLAUDE.md trigger is unconditional (not only "when user expresses frustration"), (3) root README lists the feedback channel.
**Mitigation:** REQ-007 (feedback loop), CLAUDE.md trigger update
**Likelihood:** 4
**Impact:** 3
**Risk Score:** 12
**Owner:** Long Nguyen
**Status:** Open — /feedback skill exists but is not surfaced in onboarding

---

### UBS-008: Template Drift After Clone

| Layer | Question | Analysis |
|-------|----------|----------|
| **1.0 UBS** | What ultimately blocks success? | Consumer repos are cloned and immediately customized. Six months later, consumer repos share only a superficial resemblance to the canonical template. When Long updates the template (new framework, new zone README format), consumer projects don't benefit — the standard is lost |
| **1.1 UBS.UB** | What prevents overcoming this blocker? | Consumer repos SHOULD be customized — that's the point of a template. The blocker is not customization per se but the loss of the connection to the canonical source. There is no "check for template updates" mechanism |
| **1.2 UBS.UD** | What drives/enables this blocker? | git clone severs the upstream relationship by default. No git submodule, no template tag tracking, no "original template was v1.0" marker in the clone |
| **1.3 UBS.Principles** | Why does this blocker exist? | Templates in git are single-event — clone once, diverge forever. This is a fundamental property of git, not a design flaw in the template |
| **1.4 UBS.Environment** | What environment enables this blocker? | GitHub's "use template" feature creates a new repo from the template — no upstream relationship is maintained by default |
| **1.5 UBS.Tools** | What tools enable this blocker? | template-check.sh exists and checks version — but only tells you what version you're on, not what the latest canonical version is (requires network access or a hardcoded target version) |
| **1.6 UBS.Procedure** | What process enables this blocker? | No SOP exists for "how to apply a template update to an existing consumer project." Teams would have to manually diff and apply changes — high friction, never done in practice |

**Root-Cause Resolution:** VERSION file in every consumer repo records the template version it was cloned from. template-check.sh --quiet checks VERSION against a known-good minimum. CHANGELOG.md documents which template changes are breaking (must migrate) vs additive (optional). Migration SOPs for breaking changes live in _shared/sops/.
**Mitigation:** REQ-005 (validation script), VERSION file + CHANGELOG.md
**Likelihood:** 3
**Impact:** 3
**Risk Score:** 9
**Owner:** Long Nguyen
**Status:** Partially mitigated — VERSION file exists, migration SOP not yet written

---

### UBS-009: First Artifact Quality Anchoring

| Layer | Question | Analysis |
|-------|----------|----------|
| **1.0 UBS** | What ultimately blocks success? | The first artifact a team member produces (e.g., first Charter) is low quality — EO is vague ("make a good dashboard"), risks are generic ("timeline slips"), requirements have no VANA decomposition. This low-quality artifact becomes the template for all future work on that project |
| **1.1 UBS.UB** | What prevents overcoming this blocker? | Team members don't know what "good" looks like for LTC framework artifacts. Template placeholders show FORMAT but not quality bar. Without a concrete example to compare against, they default to familiar patterns (project brief style) |
| **1.2 UBS.UD** | What drives/enables this blocker? | No worked example exists in the template. Instructions say "write the EO" but don't show what a BAD EO looks like vs a GOOD one — the contrast is the most effective teaching tool |
| **1.3 UBS.Principles** | Why does this blocker exist? | Example artifacts require maintenance (must be updated when template changes) — Long chose to defer them to avoid ongoing overhead. But the absence creates a quality floor problem |
| **1.4 UBS.Environment** | What environment enables this blocker? | Consumer repos start empty. Agents without examples fill fields with plausible-but-wrong content. Without a reference, quality is random |
| **1.5 UBS.Tools** | What tools enable this blocker? | AI agents are particularly prone to this — they will produce grammatically correct, structurally valid artifacts that are semantically wrong (aspirational EOs, generic risks). Without a calibration anchor, the agent has no quality signal |
| **1.6 UBS.Procedure** | What process enables this blocker? | Zone 1 ALIGN SOP references quality criteria (C1-C10) but these are conditions for completion, not examples of what correctly-filled artifacts look like |

**Root-Cause Resolution:** Add a docs/examples/ directory with one worked Charter, one ADR, and one UBS entry for a fictional LTC project. Agent and human calibrate against these before producing their first real artifact.
**Mitigation:** REQ-009 (worked example artifact)
**Likelihood:** 3
**Impact:** 4
**Risk Score:** 12
**Owner:** Long Nguyen
**Status:** Open — docs/examples/ not yet created

---

### UBS-010: Second-Order Risk — Adoption Theater

| Layer | Question | Analysis |
|-------|----------|----------|
| **1.0 UBS** | What ultimately blocks success? | Teams appear to adopt the template (clone it, fill in some fields, run template-check.sh) but produce artifacts that are structurally correct but intellectually empty — charter with generic EO, risk register with obvious risks, no real thinking captured. Template creates the illusion of alignment without the substance |
| **1.1 UBS.UB** | What prevents overcoming this blocker? | The template can enforce structure (required files, filled frontmatter) but cannot enforce thinking quality. Automated validation cannot detect a generic EO vs a specific one |
| **1.2 UBS.UD** | What drives/enables this blocker? | Social pressure to "use the template" + time pressure = minimum viable compliance. Fill in the fields, run the script, done. |
| **1.3 UBS.Principles** | Why does this blocker exist? | Structure is teachable; thinking is not. The template is a forcing function for structure — it cannot be a forcing function for depth of analysis |
| **1.4 UBS.Environment** | What environment enables this blocker? | No human review gate is enforced by the template. Approvals (from zone SOP: "A approves before proceeding") are advisory in a git context — nothing prevents committing an unapproved charter |
| **1.5 UBS.Tools** | What tools enable this blocker? | Automated validation cannot distinguish "risks are real and specific" from "risks are plausible and generic" |
| **1.6 UBS.Procedure** | What process enables this blocker? | The SOP requires Human approval before proceeding between steps, but enforcement is human-dependent — there is no git hook that blocks Zone 2 work until Zone 1 is approved |

**Root-Cause Resolution:** This is a cultural and process risk, not a tool risk. The template's response: (1) include specific anti-examples ("A BAD EO: 'build a good dashboard.' WHY: not testable, no user named, no constraint.") inline in the EO field of the charter template — this is the highest-leverage intervention available at the template level; (2) zone SOP documents the approval gate explicitly and agent is instructed to ask for approval before proceeding.
**Mitigation:** REQ-003 (inline instructions with anti-examples), Zone 1 SOP approval gates
**Likelihood:** 3
**Impact:** 4
**Risk Score:** 12
**Owner:** Long Nguyen (template), Anh Vinh (culture)
**Status:** Open — anti-examples not yet in templates

---

### UBS-011: Hidden Dependency — Learning Inside ALIGN

| Layer | Question | Analysis |
|-------|----------|----------|
| **1.0 UBS** | What ultimately blocks success? | The APEI framework positions Learning as a sub-activity inside ALIGN (not a separate zone). Team members expect a 1-LEARN/ folder that doesn't exist. They place research outputs in Zone 3 (where they worked) or Zone 4 (as "retrospective learnings") — the learning workflow is invisible |
| **1.1 UBS.UB** | What prevents overcoming this blocker? | The decision to embed Learn inside ALIGN was deliberate and correct, but its implications for folder structure and workflow are not yet made explicit in the template. There is no 1-ALIGN/learning/ guidance that says "this is where your pre-work research goes" |
| **1.2 UBS.UD** | What drives/enables this blocker? | The APEI discussion explicitly debated Learn placement and chose ALIGN. But the template predates this decision being reflected in the folder structure and README |
| **1.3 UBS.Principles** | Why does this blocker exist? | Design decision (Learn inside ALIGN) was captured in discussion notes but not yet propagated to the zone README and GETTING_STARTED.md |
| **1.4 UBS.Environment** | What environment enables this blocker? | 1-ALIGN/learning/ subfolder exists in the spec but the README doesn't explain that "research before execution" goes here |
| **1.5 UBS.Tools** | What tools enable this blocker? | Zone SOP documents the learning workflow but SOP is a design doc, not a user-facing README |
| **1.6 UBS.Procedure** | What process enables this blocker? | No onboarding step says "before you plan, capture your research in 1-ALIGN/learning/" |

**Root-Cause Resolution:** Zone 1 README must explicitly call out the Learn sub-workflow: "Before planning, capture domain research in `1-ALIGN/learning/`. This is your pre-work. See `zone-1-align-sop.md` §3.3 for the research workflow."
**Mitigation:** Zone 1 README update, GETTING_STARTED.md onboarding step
**Likelihood:** 3
**Impact:** 3
**Risk Score:** 9
**Owner:** Long Nguyen
**Status:** Open — Zone 1 README not yet updated

---

## Summary Risk Matrix

| Risk Score | UBS Items | Action |
|-----------|-----------|--------|
| 20-25 (Critical) | UBS-001, UBS-002 | Immediate mitigation required — address in I1 ALIGN package |
| 10-19 (High) | UBS-003 (16), UBS-004 (15), UBS-006 (12), UBS-007 (12), UBS-009 (12), UBS-010 (12) | Mitigation plan before I2 execution |
| 5-9 (Medium) | UBS-005 (9), UBS-008 (9), UBS-011 (9) | Monitor and plan mitigation for I2 |
| 1-4 (Low) | — | — |

**Highest priority for I1:** UBS-001 and UBS-002 — both are adoption-fatal if not addressed in the base template design.

---

**Classification:** INTERNAL
