---
version: "1.2"
iteration: "I1: Concept"
status: Draft
last_updated: 2026-03-30
owner: Long Nguyen
---

# REQUIREMENTS
# OPS_OE.6.4.LTC-PROJECT-TEMPLATE
## Decomposed Using VANA Grammar (UT#3): Verb + Adverb + Noun + Adjective

---

## How to Read This Document

Every requirement is decomposed into 4 elements:
- **Verb** (The Action): What must be done?
- **Adverb** (The Outcome Quality): How well must it be done?
- **Noun** (The Subject/Tools/Environment): What is being acted upon?
- **Adjective** (The Effectiveness): How effective must the subject be?

**MoSCoW Key:** M = Must Have | S = Should Have | C = Could Have | W = Won't Have (this version)

**Traceability:** Every requirement traces to source sessions: S1 (Vinh whiteboard), S2 (Team feedback), S4 (Multi-agent design spec).

**Pillar Key:** Su = Sustainability | E = Efficiency | Sc = Scalability

---

## Requirements

---

### REQ-001: LEARN Zone Separation
**MoSCoW: M (Must Have) | Pillar: Su | Source: S1 (R01)**

| Element | Description |
|---------|-------------|
| **Verb** (Action) | Separate |
| **Adverb** (Outcome) | structurally as a distinct ALPEI zone between ALIGN and PLAN |
| **Noun** (Subject) | the LEARN zone in the template folder structure |
| **Adjective** (Effectiveness) | with its own README, subfolder structure, and bidirectional feed paths to ALIGN and PLAN |

**Acceptance Criteria (binary PASS/FAIL):**
- [ ] A folder named `2-LEARN/` exists at root level, positioned after `1-ALIGN/` and before `3-PLAN/` in the ALPEI zone numbering. PASS: folder exists with correct number prefix. FAIL: missing or misnumbered.
- [ ] `2-LEARN/README.md` exists and contains: (1) zone purpose statement, (2) the three learning types (genesis frameworks, tool/platform, per-project), (3) explicit feed-back path to ALIGN and feed-forward path to PLAN. PASS: all 3 sections present. FAIL: any missing.
- [ ] `template-check.sh --quiet` validates `2-LEARN/` as a required zone. PASS: script exits 0 when LEARN zone is present and non-empty. FAIL: script does not check LEARN zone.

**Traces To:**
- Charter: §2 In-Scope (ALPEI 5-zone with LEARN as separate zone), ADR-001
- Source: S1 — Vinh formal directive

**Pillar Check:**
- Sustainability: LEARN as a distinct zone prevents research artifacts from being lost inside ALIGN or skipped entirely
- Efficiency: Dedicated zone means learning outputs are findable without searching multiple zones
- Scalability: Zone structure is fixed — adding LEARN once serves all future projects

---

### REQ-002: Learning Pipeline Structure
**MoSCoW: M (Must Have) | Pillar: Su | Source: S1 (R05)**

| Element | Description |
|---------|-------------|
| **Verb** (Action) | Structure |
| **Adverb** (Outcome) | with explicit stages from information search through synthesis |
| **Noun** (Subject) | the learning pipeline within the LEARN zone |
| **Adjective** (Effectiveness) | supporting three learning types (genesis frameworks, tool/platform, per-project) with distinct lifecycle paths |

**Acceptance Criteria (binary PASS/FAIL):**
- [ ] `2-LEARN/` contains subfolders or files that map to the pipeline stages: information search, information connection, and synthesis output. PASS: at least 3 stage-mapped locations exist. FAIL: flat folder with no stage organization.
- [ ] Each learning type (genesis, tool/platform, per-project) has a designated storage location within the LEARN zone. PASS: 3 distinct paths exist. FAIL: all learning types dumped into one folder.
- [ ] A learning artifact produced in the LEARN zone contains metadata indicating whether it feeds back to ALIGN or forward to PLAN (or both). PASS: frontmatter includes `feeds:` field. FAIL: no destination metadata.

**Traces To:**
- Charter: §2 In-Scope (LEARN zone with subfolder structure), §4 Sc3
- Source: S1 — Vinh pipeline (Info search → Info connection → LEARN → synthesis)

**Pillar Check:**
- Sustainability: Structured pipeline prevents "research goes nowhere" failure mode
- Efficiency: Stage-mapped folders reduce time spent deciding where to put learning artifacts
- Scalability: Three learning types with different lifecycles scale independently

---

### REQ-003: Three Learning Types Taxonomy
**MoSCoW: M (Must Have) | Pillar: Su | Source: S2-Vinh (R15)**

| Element | Description |
|---------|-------------|
| **Verb** (Action) | Accommodate |
| **Adverb** (Outcome) | with distinct storage, lifecycle, and audience boundaries |
| **Noun** (Subject) | three learning types within the template LEARN zone |
| **Adjective** (Effectiveness) | so that genesis frameworks (org-level), tool/platform knowledge (operational), and per-project learning (project-scoped) do not collide or duplicate |

**Acceptance Criteria (binary PASS/FAIL):**
- [ ] LEARN zone README defines all three learning types with: name, lifecycle duration (long/medium/short), intended audience, and one example each. PASS: all 3 types documented with all 4 fields. FAIL: any type missing or incomplete.
- [ ] Genesis framework learning artifacts are stored in `_genesis/` (not duplicated in LEARN zone). PASS: LEARN zone README explicitly states genesis frameworks live in `_genesis/` with a cross-reference. FAIL: genesis content duplicated in LEARN zone.
- [ ] Per-project learning artifacts are scoped to the consumer repo's LEARN zone and do not reference template-level content. PASS: template's LEARN zone contains only template-level and tool/platform learning. FAIL: per-project examples embedded in template.

**Traces To:**
- Charter: §4 Sc3 (three types of learning), §2 In-Scope
- Source: S2-Vinh — "Three types of learning are not equal"

**Pillar Check:**
- Sustainability: Preventing lifecycle collision means long-lived genesis knowledge is not overwritten by project-specific research
- Efficiency: Clear taxonomy eliminates "where does this go?" decision overhead
- Scalability: Each type scales independently — genesis grows with org, per-project stays local

---

### REQ-004: 3-Layer Architecture Alignment
**MoSCoW: S (Should Have) | Pillar: Sc | Source: S1 (R04)**

| Element | Description |
|---------|-------------|
| **Verb** (Action) | Align |
| **Adverb** (Outcome) | structurally in the template's documentation and folder conventions |
| **Noun** (Subject) | the template's knowledge, execution, and accountability layers |
| **Adjective** (Effectiveness) | with Vinh's 3-layer model (Obsidian Base → Agent → WMS) so that each layer's boundary is explicit and no layer collapses into another |

**Acceptance Criteria (binary PASS/FAIL):**
- [ ] A document in `_genesis/` or `1-ALIGN/decisions/` describes the 3-layer model with: layer name, responsibility boundary, and the template artifact(s) that belong to each layer. PASS: document exists with all 3 layers mapped. FAIL: missing or incomplete.
- [ ] No template artifact conflates knowledge storage (Obsidian/markdown) with accountability tracking (WMS/ClickUp). PASS: each artifact's purpose maps to exactly one layer. FAIL: any artifact spans two layers without explicit justification.

**Traces To:**
- Charter: §4 Design Principle 6 ("Separate knowledge, execution, and accountability")
- Source: S1 — Vinh 3-layer architecture

**Pillar Check:**
- Sustainability: Layer separation prevents the "everything in one tool" collapse that makes systems brittle
- Efficiency: Clear boundaries reduce tool confusion — users know where to look
- Scalability: 3-layer model scales to org-wide adoption without architectural rework

---

### REQ-005: Zone Navigation Clarity
**MoSCoW: M (Must Have) | Pillar: Su | Source: S2 (R13, R14)**

| Element | Description |
|---------|-------------|
| **Verb** (Action) | Guide |
| **Adverb** (Outcome) | unambiguously and within 5 minutes of opening the repo |
| **Noun** (Subject) | any team member (technical or non-technical) via the root README |
| **Adjective** (Effectiveness) | to the correct ALPEI zone folder for their current work type without external help |

**Acceptance Criteria (binary PASS/FAIL):**
- [ ] Root README contains a zone map table with rows for each ALPEI zone (ALIGN, LEARN, PLAN, EXECUTE, IMPROVE) plus `_genesis/`. Columns include: zone name, "when to use this," and "first file to read." PASS: table exists with all zones and all columns populated. FAIL: any zone or column missing.
- [ ] Each ALPEI zone folder contains a README.md that answers: (1) what this zone is for, (2) what to do first, (3) what not to put here. PASS: all zone READMEs present with all 3 answers. FAIL: any zone README missing or incomplete.
- [ ] `template-check.sh --quiet` exits 0 only when all zone READMEs exist and are non-empty. PASS: script validates zone READMEs. FAIL: script skips README check.

**Traces To:**
- Charter: §4 S1 (every zone has README), E1 (least surprise)
- Source: S2-consensus (R13 simplicity, R14 friction kills adoption)

**Pillar Check:**
- Sustainability: Clear navigation prevents "ask Long" single-person dependency
- Efficiency: 5-minute zone identification = zero overhead per task start
- Scalability: Zone structure is fixed — navigation scales to N team members without modification

---

### REQ-006: First-Run Orientation
**MoSCoW: M (Must Have) | Pillar: Su | Source: S2 (R12, R13, R14)**

| Element | Description |
|---------|-------------|
| **Verb** (Action) | Orient |
| **Adverb** (Outcome) | completely and self-sufficiently within 15 minutes of cloning |
| **Noun** (Subject) | a non-technical director (Khang archetype) via the root README |
| **Adjective** (Effectiveness) | to the point where they can name their first action without asking for help |

**Acceptance Criteria (binary PASS/FAIL):**
- [ ] Root README contains a "Start Here" section with 5 or fewer numbered steps. Each step is executable (verb-first). No step requires reading a framework guide first. PASS: section exists with ≤5 executable steps. FAIL: missing, >5 steps, or descriptive-only steps.
- [ ] A user with zero prior LTC template experience can identify which ALPEI zone to enter for their first task by following only the README. PASS: validated by user test (Khang or equivalent). FAIL: user needs to ask for help.
- [ ] `template-check.sh` (without --quiet) prints human-readable output with checkmark/X per item and plain-language error messages (no bash jargon). PASS: output uses checkmarks and plain English. FAIL: raw error codes or script output only.

**Traces To:**
- Charter: §2 Success definition ("Khang can navigate in under 15 minutes")
- Source: S2-consensus (R12 problem-first, R13 simplicity, R14 friction)

**Pillar Check:**
- Sustainability: Onboarding is the highest-friction point — investing here prevents permanent "ask Long" dependency
- Efficiency: 15-minute cap forces README to stay focused
- Scalability: Onboarding works for all future team members without Long present

---

### REQ-007: Subfolder Descriptions
**MoSCoW: M (Must Have) | Pillar: Su | Source: S2-Dat (R06)**

| Element | Description |
|---------|-------------|
| **Verb** (Action) | Describe |
| **Adverb** (Outcome) | explicitly within each subfolder so that neither agents nor humans must guess |
| **Noun** (Subject) | every subfolder's purpose, intended contents, and boundaries in the template |
| **Adjective** (Effectiveness) | with a machine-readable and human-scannable description that agents can parse on first load and users can read in under 10 seconds |

**Acceptance Criteria (binary PASS/FAIL):**
- [ ] Every subfolder within each ALPEI zone contains a description mechanism (README.md, frontmatter index, or equivalent per ADR-004). PASS: 100% of subfolders have descriptions. FAIL: any subfolder lacks a description.
- [ ] An AI agent (Claude Code) loading a zone can determine what each subfolder is for without reading files inside the subfolder. PASS: agent test produces correct subfolder purpose for all subfolders. FAIL: agent guesses or hallucinates purpose for any subfolder.
- [ ] `template-check.sh` flags subfolders missing descriptions. PASS: script detects and reports missing descriptions. FAIL: script does not check subfolder descriptions.

**Traces To:**
- Charter: §4 E5 (agent context must be explicit), §2 In-Scope (subfolder descriptions)
- Source: S2-Dat — "agents guess context, users skip"

**Pillar Check:**
- Sustainability: Explicit descriptions prevent agent drift and user confusion — two root causes of adoption failure
- Efficiency: 10-second scan time means descriptions don't slow down experienced users
- Scalability: Description mechanism works for any number of subfolders without architectural change

---

### REQ-008: Skill Scope Enforcement
**MoSCoW: M (Must Have) | Pillar: Su | Source: S2-Dat (R07)**

| Element | Description |
|---------|-------------|
| **Verb** (Action) | Enforce |
| **Adverb** (Outcome) | deterministically so that skills cannot be invoked outside their intended scope |
| **Noun** (Subject) | skill invocation boundaries within nested `.claude/skills/` folders |
| **Adjective** (Effectiveness) | via naming convention, manifest check, or runtime guard that prevents scope leakage without relying on agent self-discipline |

**Acceptance Criteria (binary PASS/FAIL):**
- [ ] Every skill in `.claude/skills/` has an explicit `scope` or `context` field in its SKILL.md frontmatter defining when the skill should and should not be invoked. PASS: 100% of skills have scope metadata. FAIL: any skill lacks scope definition.
- [ ] `scripts/skill-validator.sh` checks that skill invocation context matches the declared scope. PASS: validator catches scope violations in test cases. FAIL: validator does not check scope.
- [ ] No skill can modify files outside its declared zone or scope boundary when invoked by an agent. PASS: agent test confirms file modifications stay within scope. FAIL: any out-of-scope file modification observed.

**Traces To:**
- Charter: §4 S7 (deterministic over probabilistic enforcement)
- Source: S2-Dat — "skills in nested folders invoked outside intended scope"

**Pillar Check:**
- Sustainability: Scope leakage is a sustainability risk — one misbehaving skill can corrupt artifacts across zones
- Efficiency: Deterministic enforcement is cheaper than debugging scope leakage after the fact
- Scalability: Enforcement mechanism scales with skill count without additional human review

---

### REQ-009: Version Tracking Visibility
**MoSCoW: M (Must Have) | Pillar: Su | Source: S2-Khang (R09)**

| Element | Description |
|---------|-------------|
| **Verb** (Action) | Display |
| **Adverb** (Outcome) | clearly and without requiring git knowledge |
| **Noun** (Subject) | the current template version and recent changes to all team members |
| **Adjective** (Effectiveness) | via a visible mechanism (VERSION file, CHANGELOG, or equivalent) that a non-technical director can check in under 30 seconds |

**Acceptance Criteria (binary PASS/FAIL):**
- [ ] Root `VERSION` file contains the current semantic version (MAJOR.MINOR format where MAJOR = iteration number). PASS: VERSION file exists and contains a valid version string. FAIL: missing or contains placeholder.
- [ ] `5-IMPROVE/changelog/CHANGELOG.md` contains dated entries for every version bump with a plain-language summary of changes. PASS: CHANGELOG has entries matching VERSION history. FAIL: CHANGELOG is empty or out of sync with VERSION.
- [ ] A non-technical team member can determine the current template version and what changed in the last release by reading only VERSION and CHANGELOG (no git log required). PASS: user test confirms. FAIL: user needs git commands or Long's explanation.

**Traces To:**
- Charter: §2 In-Scope (version tracking visible to all team members)
- Source: S2-Khang — "version/release tracking unclear"

**Pillar Check:**
- Sustainability: Visible versioning prevents "am I using the latest?" uncertainty that erodes trust
- Efficiency: 30-second version check is minimal overhead
- Scalability: VERSION + CHANGELOG pattern works for any number of consumers

---

### REQ-010: Release Announcement Flow
**MoSCoW: S (Should Have) | Pillar: Su | Source: S2-Khang (R08)**

| Element | Description |
|---------|-------------|
| **Verb** (Action) | Announce |
| **Adverb** (Outcome) | proactively upon each template release so team members are notified without checking manually |
| **Noun** (Subject) | template version releases to all active team members |
| **Adjective** (Effectiveness) | via a documented flow that includes what changed, what action (if any) consumers must take, and where to find details |

**Acceptance Criteria (binary PASS/FAIL):**
- [ ] A release flow document exists (ADR-005) with the chosen mechanism, responsible party, and trigger condition. PASS: ADR-005 exists with decision recorded. FAIL: no release flow documented.
- [ ] Each template release produces a CHANGELOG entry and a git tag following the versioning convention. PASS: latest release has both CHANGELOG entry and git tag. FAIL: either missing.
- [ ] Release announcement includes: version number, summary of changes (≤5 bullet points), and consumer action required (if any). PASS: announcement template or example exists with all 3 fields. FAIL: any field missing.

**Traces To:**
- Charter: §2 In-Scope (feedback pipeline), ADR-005
- Source: S2-Khang — "release announcement flow must exist"

**Pillar Check:**
- Sustainability: Proactive announcements prevent consumers from running stale templates unknowingly
- Efficiency: Structured announcements reduce "what changed?" back-and-forth
- Scalability: Announcement flow works for any number of consumer repos

---

### REQ-011: Iteration-Based Sustainability Priority
**MoSCoW: M (Must Have) | Pillar: Su | Source: S2-Long (R10)**

| Element | Description |
|---------|-------------|
| **Verb** (Action) | Prioritize |
| **Adverb** (Outcome) | explicitly in every I1 design decision |
| **Noun** (Subject) | sustainability (safe to use) over efficiency and scalability features |
| **Adjective** (Effectiveness) | so that no efficiency or scalability feature is added to I1 unless all sustainability requirements are met first |

**Acceptance Criteria (binary PASS/FAIL):**
- [ ] Every Must-Have requirement tagged Su in this document is scheduled for I1. PASS: all M+Su requirements are I1 scope. FAIL: any M+Su requirement deferred past I1.
- [ ] No Could-Have or Won't-Have feature is implemented in I1 before all Must-Have Su requirements pass their ACs. PASS: I1 delivery order confirms. FAIL: optional features shipped before Must-Have Su completion.
- [ ] Charter §4 states iteration logic (I1=Su, I2=E, I3+=Sc) and prioritization order (S > E > Sc). PASS: charter contains explicit iteration-pillar mapping. FAIL: mapping absent or contradicted.

**Traces To:**
- Charter: §4 Iteration logic, Design Principle 5
- Source: S2-Long — "template must be safe to use before adding features"

**Pillar Check:**
- Sustainability: This IS the sustainability meta-requirement — ensures the pillar is not traded away
- Efficiency: Prevents wasted effort on features that fail without a sustainable foundation
- Scalability: Defers scalability investment to I3+ when the foundation is proven

---

### REQ-012: Problem-First Feature Introduction
**MoSCoW: M (Must Have) | Pillar: Su | Source: S2-consensus (R12)**

| Element | Description |
|---------|-------------|
| **Verb** (Action) | Defer |
| **Adverb** (Outcome) | until users demonstrate the specific problem it solves |
| **Noun** (Subject) | any new template feature, tool integration, or structural addition |
| **Adjective** (Effectiveness) | so that no solution is introduced before users hit the problem — validated by a documented user need (UBS entry, feedback issue, or stakeholder request) |

**Acceptance Criteria (binary PASS/FAIL):**
- [ ] Every feature added to the template in I1 traces to a documented need: a UBS entry, a feedback GitHub Issue, or a stakeholder request from S1/S2/S4. PASS: all features have traceability. FAIL: any feature lacks a documented need.
- [ ] Features that solve anticipated (not demonstrated) problems are tagged Could-Have or Won't-Have and deferred. PASS: no anticipated-only features are Must-Have. FAIL: any Must-Have feature lacks demonstrated need.

**Traces To:**
- Charter: §4 Design Principle 2 ("Don't introduce solutions before users hit the problem")
- Source: S2-consensus

**Pillar Check:**
- Sustainability: Problem-first prevents template bloat, which is itself an adoption risk
- Efficiency: Only building what is needed eliminates wasted effort
- Scalability: Lean template is easier to maintain across consumer repos

---

### REQ-013: Simplicity-First Design
**MoSCoW: M (Must Have) | Pillar: Su | Source: S2-consensus (R13)**

| Element | Description |
|---------|-------------|
| **Verb** (Action) | Default |
| **Adverb** (Outcome) | always to the simpler option when multiple approaches exist |
| **Noun** (Subject) | every template design decision (folder structure, naming, artifact format) |
| **Adjective** (Effectiveness) | so that complexity is only added when justified by proportional value — validated by the friction test |

**Acceptance Criteria (binary PASS/FAIL):**
- [ ] Every ADR in `1-ALIGN/decisions/` that evaluates multiple options includes a "simplicity comparison" row in its evaluation table. PASS: all ADRs have simplicity comparison. FAIL: any ADR omits simplicity evaluation.
- [ ] Root directory contains 10 or fewer visible items (files + folders), with ALPEI zone folders as the dominant visual pattern. PASS: `ls` shows ≤10 items (excluding dot-prefixed). FAIL: >10 visible items.
- [ ] Each ALPEI zone folder contains 6 or fewer top-level items before sub-navigation is required. PASS: all zones comply. FAIL: any zone exceeds 6 items.

**Traces To:**
- Charter: §4 S6 (simplicity first), Design Principle 3
- Source: S2-consensus — "complexity must be justified by proportional value"

**Pillar Check:**
- Sustainability: Simplicity is the primary defense against adoption failure
- Efficiency: Fewer items = faster navigation = less cognitive overhead
- Scalability: Folder count is a design constraint, not a function of project size

---

### REQ-014: Friction Minimization
**MoSCoW: M (Must Have) | Pillar: Su | Source: S2-consensus (R14)**

| Element | Description |
|---------|-------------|
| **Verb** (Action) | Minimize |
| **Adverb** (Outcome) | relentlessly at every user touchpoint |
| **Noun** (Subject) | friction in the template adoption and daily use experience |
| **Adjective** (Effectiveness) | so that every feature passes the friction test: "does this make the template harder to start using?" — features that increase friction must earn their place with documented justification |

**Acceptance Criteria (binary PASS/FAIL):**
- [ ] Every Must-Have feature in this document has been evaluated against the friction test. PASS: no Must-Have feature increases first-use friction without documented justification. FAIL: any feature increases friction without justification.
- [ ] Template clone-to-first-artifact time is under 30 minutes for a non-technical user (Khang archetype). PASS: timed user test confirms ≤30 minutes. FAIL: >30 minutes.
- [ ] Feedback skill (`/feedback`) is available to capture friction points in under 60 seconds. PASS: skill exists and creates a GitHub Issue within 60 seconds. FAIL: skill missing or takes >60 seconds.

**Traces To:**
- Charter: §4 S6 (friction kills adoption), Design Principle 4
- Source: S2-consensus — "friction kills adoption"

**Pillar Check:**
- Sustainability: Friction is the #1 killer of template adoption — minimizing it is a survival requirement
- Efficiency: Lower friction = faster adoption = faster ROI on template investment
- Scalability: Low-friction template is easier to roll out to new team members

---

### REQ-015: Plain-Language Template Instructions
**MoSCoW: M (Must Have) | Pillar: Su | Source: S2 (R06, R13)**

| Element | Description |
|---------|-------------|
| **Verb** (Action) | Provide |
| **Adverb** (Outcome) | inline and without requiring external framework knowledge |
| **Noun** (Subject) | every template field in every ALPEI zone artifact |
| **Adjective** (Effectiveness) | with a one-line instruction and a concrete example so that no user or agent must look up framework definitions to fill in a field |

**Acceptance Criteria (binary PASS/FAIL):**
- [ ] Every placeholder field in PROJECT_CHARTER.md, STAKEHOLDERS.md, REQUIREMENTS.md, UBS_REGISTER.md, and UDS_REGISTER.md contains an HTML comment with: (1) one sentence explaining what to write, (2) one concrete LTC-specific example. PASS: all placeholder fields have both instruction and example. FAIL: any field has only `[placeholder text]`.
- [ ] Framework acronyms (UBS, UDS, VANA, EO, RACI, ALPEI, DSBV) include a parenthetical plain-English expansion on first use within each file. PASS: all acronyms expanded on first use per file. FAIL: any acronym used without expansion.
- [ ] `template-check.sh --quiet` detects unfilled placeholder patterns (`[Name/Role]`, `[YYYY-MM-DD]`, `{Human Director}`) and exits with a specific error code. PASS: script detects and reports unfilled placeholders. FAIL: script ignores placeholders.

**Traces To:**
- Charter: §4 S2 (guard rails in templates), E1 (least surprise)
- Source: S2-Dat (R06 descriptions), S2-consensus (R13 simplicity)

**Pillar Check:**
- Sustainability: Inline instructions prevent blank or wrong fields, which produce useless artifacts
- Efficiency: One-line instruction is the minimum viable guidance
- Scalability: Per-file instructions scale to any team size

---

### REQ-016: Agent Orientation via CLAUDE.md
**MoSCoW: M (Must Have) | Pillar: Su | Source: S2-Dat (R06), S1 (R01)**

| Element | Description |
|---------|-------------|
| **Verb** (Action) | Configure |
| **Adverb** (Outcome) | immediately upon first load without additional prompting |
| **Noun** (Subject) | any Claude Code or compatible AI agent via the root CLAUDE.md |
| **Adjective** (Effectiveness) | with complete project context: EO, ALPEI zone structure, rules, and pre-flight protocol — so the agent produces correct zone-scoped artifacts from the first response |

**Acceptance Criteria (binary PASS/FAIL):**
- [ ] CLAUDE.md (root) contains within the first 50 lines: project name, stack, purpose statement, and the ALPEI zone structure map (all 5 zones + `_genesis/`). PASS: all items present in first 50 lines. FAIL: any item missing or below line 50.
- [ ] CLAUDE.md contains a numbered pre-flight protocol of ≤5 steps, each pointing to a specific file path. Protocol includes: read Charter, read UBS, read UDS. PASS: pre-flight exists with file paths and all 3 reads. FAIL: missing or vague steps.
- [ ] An agent given CLAUDE.md and the prompt "fill in the charter" produces a Charter with an EO in the "[User] [desired state] without [constraint]" format. PASS: agent test confirms correct EO format. FAIL: agent produces wrong format.

**Traces To:**
- Charter: §4 S3 (agent governance first file), E5 (agent context explicit)
- Source: S2-Dat (agents guess context), S1 (ALPEI as primary flow)

**Pillar Check:**
- Sustainability: Correct agent orientation prevents compounding errors across a session
- Efficiency: CLAUDE.md is read once per session — clarity here pays dividends
- Scalability: Same pattern works for Claude, Gemini, and future agents

---

### REQ-017: ALPEI as Human Flow
**MoSCoW: M (Must Have) | Pillar: Su | Source: S2-Vinh (R17)**

| Element | Description |
|---------|-------------|
| **Verb** (Action) | Present |
| **Adverb** (Outcome) | consistently throughout all template documentation and navigation |
| **Noun** (Subject) | ALPEI zones as the primary flow the Human Director follows |
| **Adjective** (Effectiveness) | while keeping DSBV as an internal agent/builder process that is not exposed as a user-facing workflow |

**Acceptance Criteria (binary PASS/FAIL):**
- [ ] Root README and all zone READMEs reference ALPEI zones as the navigation model. No README presents DSBV as the primary workflow for human directors. PASS: ALPEI is the flow in all READMEs. FAIL: any README presents DSBV as the human flow.
- [ ] DSBV references in CLAUDE.md and `.claude/rules/` are scoped to agent/builder context only. PASS: DSBV is described as "how agents/builders produce artifacts within zones." FAIL: DSBV described as "the process users follow."
- [ ] A non-technical director reading the root README understands their workflow as ALPEI zone navigation, not DSBV phase execution. PASS: user test confirms. FAIL: user thinks they need to "do Design then Sequence then Build."

**Traces To:**
- Charter: §4 S5 (ALPEI = flow, DSBV = internal), Design Principle 1
- Source: S2-Vinh — "zones are the flow; DSBV is internal"

**Pillar Check:**
- Sustainability: Presenting the wrong flow to users creates confusion and abandonment
- Efficiency: One clear flow (ALPEI) is cheaper to teach than two overlapping flows
- Scalability: ALPEI flow is stable across project types; DSBV stays internal

---

### REQ-018: 4 MECE Agent Roster
**MoSCoW: M (Must Have) | Pillar: Su | Source: S4 (R18)**

| Element | Description |
|---------|-------------|
| **Verb** (Action) | Define |
| **Adverb** (Outcome) | with MECE scope boundaries and explicit tool allowlists |
| **Noun** (Subject) | a roster of 4 agents (ltc-planner, ltc-builder, ltc-reviewer, ltc-explorer) in AGENTS.md |
| **Adjective** (Effectiveness) | so that each agent has a non-overlapping responsibility domain and cannot access tools outside its allowlist |

**Acceptance Criteria (binary PASS/FAIL):**
- [ ] `AGENTS.md` at root defines exactly 4 agents with: name, model tier, scope boundary, and tool allowlist. PASS: 4 agents with all 4 fields each. FAIL: missing agents, fields, or overlapping scopes.
- [ ] No two agents share the same scope boundary — verified by checking that MECE (Mutually Exclusive, Collectively Exhaustive) property holds. PASS: scope boundaries partition the full template domain. FAIL: any overlap or gap.
- [ ] Each agent's tool allowlist contains ≤7 tools. PASS: all allowlists comply. FAIL: any agent exceeds 7 tools.

**Traces To:**
- Charter: §2 In-Scope (multi-agent orchestration), ADR-007
- Source: S4 — 4 MECE agent roster

**Pillar Check:**
- Sustainability: MECE boundaries prevent agent confusion and scope leakage
- Efficiency: ≤7 tools per agent reduces token cost and decision overhead
- Scalability: Adding a 5th agent requires only defining a new MECE slice, not restructuring existing agents

---

### REQ-019: 3 Enforcement Hooks
**MoSCoW: M (Must Have) | Pillar: Su | Source: S4 (R19)**

| Element | Description |
|---------|-------------|
| **Verb** (Action) | Enforce |
| **Adverb** (Outcome) | deterministically via automated hooks (not agent self-discipline) |
| **Noun** (Subject) | 3 enforcement hooks: verify-deliverables, save-context-state, resume-check |
| **Adjective** (Effectiveness) | so that no artifact ships without verification, no context is lost between sessions, and no session resumes without state check |

**Acceptance Criteria (binary PASS/FAIL):**
- [ ] `verify-deliverables` hook exists in `.claude/` and runs automatically before any artifact is marked complete. PASS: hook exists and triggers on artifact completion. FAIL: hook missing or requires manual invocation.
- [ ] `save-context-state` hook persists session context (active work, decisions, blockers) to a recoverable location. PASS: hook writes state that `resume-check` can read. FAIL: no state persisted or format incompatible.
- [ ] `resume-check` hook validates session state on load and warns if state is stale or missing. PASS: hook runs on session start and produces a warning for stale state. FAIL: hook missing or silent on stale state.

**Traces To:**
- Charter: §4 S7 (deterministic enforcement), §2 In-Scope (3 enforcement hooks)
- Source: S4 — 3 enforcement hooks

**Pillar Check:**
- Sustainability: Hooks are the mechanism that moves from ~85% to ~100% compliance
- Efficiency: Automated enforcement is cheaper than human review
- Scalability: Hooks run per-session regardless of team size

---

### REQ-020: Context Packaging Template
**MoSCoW: M (Must Have) | Pillar: Su | Source: S4 (R20)**

| Element | Description |
|---------|-------------|
| **Verb** (Action) | Standardize |
| **Adverb** (Outcome) | with a 5-field structured template for every sub-agent dispatch |
| **Noun** (Subject) | context packaging for multi-agent handoffs |
| **Adjective** (Effectiveness) | using the fields EO, INPUT, EP, OUTPUT, VERIFY — so that receiving agents have complete context without guessing |

**Acceptance Criteria (binary PASS/FAIL):**
- [ ] A context packaging template exists in `_genesis/templates/` with exactly 5 fields: EO, INPUT, EP, OUTPUT, VERIFY. PASS: template exists with all 5 fields. FAIL: template missing or fields incomplete.
- [ ] Every sub-agent dispatch in AGENTS.md references the context packaging template. PASS: all dispatch instructions reference the template. FAIL: any dispatch lacks template reference.
- [ ] A receiving agent given a context package can identify: what to produce (EO), what to read (INPUT), what rules apply (EP), what to deliver (OUTPUT), and how to verify (VERIFY) — without additional prompting. PASS: agent test confirms. FAIL: agent asks clarifying questions about any of the 5 fields.

**Traces To:**
- Charter: §4 E5 (agent context must be explicit)
- Source: S4 — context packaging template (5-field structured handoff)

**Pillar Check:**
- Sustainability: Structured handoffs prevent cascading hallucination (LT-1) across agent boundaries
- Efficiency: 5 fields is the minimum viable context — no unnecessary overhead
- Scalability: Same template works for any number of agents and dispatch patterns

---

### REQ-021: Tool Routing with Per-Agent Allowlists
**MoSCoW: M (Must Have) | Pillar: Su | Source: S4 (R21)**

| Element | Description |
|---------|-------------|
| **Verb** (Action) | Route |
| **Adverb** (Outcome) | deterministically based on declared allowlists (not agent judgment) |
| **Noun** (Subject) | tool access for each agent in the multi-agent roster |
| **Adjective** (Effectiveness) | with per-agent allowlists and cost tiers so that expensive tools (Opus, web search) are restricted to agents that need them |

**Acceptance Criteria (binary PASS/FAIL):**
- [ ] Each agent in AGENTS.md has an explicit tool allowlist specifying which tools it can invoke. PASS: all 4 agents have allowlists. FAIL: any agent lacks an allowlist.
- [ ] Tool allowlists include cost tier labels (e.g., low/medium/high). High-cost tools are restricted to ≤2 agents. PASS: cost tiers present, high-cost tools restricted. FAIL: no cost tiers or unrestricted high-cost access.
- [ ] An agent attempting to use a tool outside its allowlist is blocked or warned by the enforcement mechanism. PASS: out-of-allowlist tool use produces an error or warning. FAIL: tool use proceeds silently.

**Traces To:**
- Charter: §4 S7 (deterministic enforcement)
- Source: S4 — tool routing with per-agent allowlists and cost tiers

**Pillar Check:**
- Sustainability: Tool restriction prevents token waste (LT-7) and scope leakage (LT-8)
- Efficiency: Cost-tier routing minimizes API spend
- Scalability: Allowlists scale with agent count — each new agent gets its own list

---

### REQ-022: 3 New Enforcement Principles (EP-11, EP-12, EP-13)
**MoSCoW: M (Must Have) | Pillar: Su | Source: S4 (R22)**

| Element | Description |
|---------|-------------|
| **Verb** (Action) | Codify |
| **Adverb** (Outcome) | as named EPs in the template's `_genesis/frameworks/` |
| **Noun** (Subject) | 3 new enforcement principles: EP-11 Agent Role Separation, EP-12 Verified Handoff, EP-13 Orchestrator Authority |
| **Adjective** (Effectiveness) | with definitions, rationale, and enforcement mechanisms so that multi-agent behavior is governed by principles, not ad-hoc rules |

**Acceptance Criteria (binary PASS/FAIL):**
- [ ] EP-11 (Agent Role Separation) is defined in `_genesis/frameworks/` with: principle statement, rationale, and how it maps to the MECE agent roster. PASS: EP-11 exists with all 3 sections. FAIL: missing or incomplete.
- [ ] EP-12 (Verified Handoff) is defined with: principle statement, rationale, and how it maps to the context packaging template. PASS: EP-12 exists with all 3 sections. FAIL: missing or incomplete.
- [ ] EP-13 (Orchestrator Authority) is defined with: principle statement, rationale, and how it maps to the orchestrator's override capability. PASS: EP-13 exists with all 3 sections. FAIL: missing or incomplete.

**Traces To:**
- Charter: §4 S7 (deterministic enforcement)
- Source: S4 — 3 new EPs for multi-agent governance

**Pillar Check:**
- Sustainability: Named principles are more durable than ad-hoc rules — they survive context changes
- Efficiency: Principles reduce the number of individual rules needed
- Scalability: EPs apply to any future agent additions without rewriting

---

### REQ-023: Hypothesis-Driven Eval Gates
**MoSCoW: M (Must Have) | Pillar: Su | Source: S4 (R23)**

| Element | Description |
|---------|-------------|
| **Verb** (Action) | Gate |
| **Adverb** (Outcome) | with measured evidence before any artifact ships |
| **Noun** (Subject) | artifact delivery in the multi-agent workflow via eval gates |
| **Adjective** (Effectiveness) | using hypothesis-driven validation (Approach D) so that nothing is marked complete without measured PASS/FAIL evidence |

**Acceptance Criteria (binary PASS/FAIL):**
- [ ] Every artifact produced by a sub-agent passes through an eval gate before being accepted by the orchestrator. PASS: eval gate exists in the workflow and blocks unchecked artifacts. FAIL: artifacts can bypass eval.
- [ ] Eval gates produce measured evidence (not subjective assessment). Evidence format includes: hypothesis, measurement method, and PASS/FAIL result. PASS: eval output contains all 3 fields. FAIL: any field missing or subjective.
- [ ] At least one eval gate has been tested with a deliberate failure case to confirm it catches defective artifacts. PASS: test case exists and eval gate correctly fails it. FAIL: no failure test or gate passes defective artifact.

**Traces To:**
- Charter: §4 Design Principle 11 ("nothing ships without measured evidence")
- Source: S4 — Approach D (hypothesis-driven with eval gates)

**Pillar Check:**
- Sustainability: Eval gates prevent cascading hallucination (LT-1) — the primary multi-agent risk
- Efficiency: Catching defects at eval is cheaper than fixing them downstream
- Scalability: Eval gates scale with artifact volume — each artifact gets the same check

---

### REQ-024: I0-I4 Iteration Model
**MoSCoW: M (Must Have) | Pillar: Sc | Source: S2-Long (R11)**

| Element | Description |
|---------|-------------|
| **Verb** (Action) | Implement |
| **Adverb** (Outcome) | with clear version numbering tied to iteration milestones |
| **Noun** (Subject) | the I0-I4 iteration model in the template's branching strategy and VERSION file |
| **Adjective** (Effectiveness) | so that every iteration has a version number, a branch, and a defined pillar focus (I1=Su, I2=E, I3+=Sc) |

**Acceptance Criteria (binary PASS/FAIL):**
- [ ] `VERSION` file uses MAJOR.MINOR format where MAJOR equals the iteration number. PASS: VERSION shows iteration-aligned version (e.g., 1.0 for I1). FAIL: version does not map to iteration.
- [ ] CLAUDE.md or `_genesis/frameworks/HISTORY_VERSION_CONTROL.md` documents the I0-I4 branching strategy with pillar focus per iteration. PASS: branching strategy documented with iteration-pillar mapping. FAIL: strategy missing or pillar mapping absent.
- [ ] Each iteration branch is named with the iteration prefix (e.g., `I1-feature-name`). PASS: branch naming convention documented and enforced. FAIL: no convention or inconsistent naming.

**Traces To:**
- Charter: §4 S4 (branching strategy enforced), Iteration logic
- Source: S2-Long — I0-I4 iteration model

**Pillar Check:**
- Sustainability: Version numbering tied to iterations makes template state legible
- Efficiency: One convention for versions and branches eliminates naming debates
- Scalability: I0-I4 model scales to long-lived templates with multiple iterations

---

### REQ-025: L3 Migration Guide
**MoSCoW: S (Should Have) | Pillar: E | Source: S4 (R24)**

| Element | Description |
|---------|-------------|
| **Verb** (Action) | Provide |
| **Adverb** (Outcome) | in a self-contained guide completable in under 10 minutes |
| **Noun** (Subject) | migration instructions for team members adopting the multi-agent orchestration layer |
| **Adjective** (Effectiveness) | covering: what changed, what to do differently, and how to verify the setup works — so adoption does not require a training session with Long |

**Acceptance Criteria (binary PASS/FAIL):**
- [ ] A migration guide exists in `4-EXECUTE/docs/` or `_genesis/` with sections: What Changed, What To Do, How To Verify. PASS: guide exists with all 3 sections. FAIL: guide missing or sections incomplete.
- [ ] Guide includes a verification checklist that a team member can run independently. PASS: checklist exists and references runnable commands or observable outcomes. FAIL: no checklist or checklist requires Long's help.
- [ ] A team member (Khang archetype) can complete the migration by following only the guide in ≤10 minutes. PASS: timed test confirms ≤10 minutes. FAIL: >10 minutes or external help needed.

**Traces To:**
- Charter: §2 Success definition (self-service onboarding)
- Source: S4 — L3 migration guide for member adoption

**Pillar Check:**
- Sustainability: Self-service migration prevents Long-dependency bottleneck
- Efficiency: 10-minute cap forces the guide to be focused and actionable
- Scalability: Guide works for all future team members

---

### REQ-026: Obsidian CLI Integration
**MoSCoW: S (Should Have) | Pillar: E | Source: S1 (R02)**

| Element | Description |
|---------|-------------|
| **Verb** (Action) | Integrate |
| **Adverb** (Outcome) | as an optional enhancement (not a hard dependency) |
| **Noun** (Subject) | Obsidian CLI for markdown search and interconnectedness within the template |
| **Adjective** (Effectiveness) | so that agents and users can discover cross-zone relationships between artifacts without manual linking |

**Acceptance Criteria (binary PASS/FAIL):**
- [ ] ADR-002 documents the Obsidian CLI integration decision with options and chosen approach. PASS: ADR-002 exists with decision. FAIL: no ADR for Obsidian CLI.
- [ ] Obsidian CLI is listed as optional in the template's dependencies — template functions fully without it. PASS: `template-check.sh` passes without Obsidian CLI installed. FAIL: script fails or warns when Obsidian CLI is absent.
- [ ] When Obsidian CLI is present, agents can search across ALPEI zones for related artifacts. PASS: cross-zone search returns relevant results. FAIL: search is zone-scoped only.

**Traces To:**
- Charter: §2 Out of Scope note (ADR-002 — Long explores first)
- Source: S1 — Vinh suggests Obsidian CLI for MD search

**Pillar Check:**
- Sustainability: Optional dependency means the template is not fragile without Obsidian
- Efficiency: Cross-zone search reduces time spent manually finding related artifacts
- Scalability: Obsidian graph features scale with artifact volume

---

### REQ-027: Draft vs Final Separation
**MoSCoW: S (Should Have) | Pillar: E | Source: S2-Vinh (R16)**

| Element | Description |
|---------|-------------|
| **Verb** (Action) | Separate |
| **Adverb** (Outcome) | explicitly within the EXECUTE zone folder structure |
| **Noun** (Subject) | draft/WIP artifacts from final/published artifacts |
| **Adjective** (Effectiveness) | so that artifact maturity is visible from the folder path alone — no ambiguity about whether an artifact is work-in-progress or approved |

**Acceptance Criteria (binary PASS/FAIL):**
- [ ] EXECUTE zone has distinct locations for WIP and final artifacts (e.g., `drafts/` vs root, or `wip/` vs `deploy/`). PASS: two distinct locations exist with clear naming. FAIL: single location or ambiguous naming.
- [ ] An artifact's maturity (draft vs final) is determinable from its file path without reading the file content. PASS: path convention makes maturity obvious. FAIL: must open the file to determine maturity.

**Traces To:**
- Charter: §4 Design Principle 8 ("draft vs final must be explicit")
- Source: S2-Vinh — "execution folder = WIP, deploy = final"

**Pillar Check:**
- Sustainability: Ambiguous maturity leads to shipping draft artifacts — a trust-destroying failure
- Efficiency: Path-based maturity eliminates the need to open files to check status
- Scalability: Convention scales with artifact volume

---

### REQ-028: Validation Script Completeness
**MoSCoW: M (Must Have) | Pillar: Su | Source: S2 (R09, R13)**

| Element | Description |
|---------|-------------|
| **Verb** (Action) | Validate |
| **Adverb** (Outcome) | automatically and without human inspection |
| **Noun** (Subject) | the structural integrity of any consumer repo cloned from this template |
| **Adjective** (Effectiveness) | against a complete checklist of required files, non-empty ALPEI zones, and filled frontmatter — producing a PASS/FAIL result with specific error messages |

**Acceptance Criteria (binary PASS/FAIL):**
- [ ] `scripts/template-check.sh --quiet` exits 0 if and only if: all ALPEI zone folders exist (including LEARN), all zone READMEs are non-empty, CLAUDE.md exists at root, charter templates have non-default frontmatter, and VERSION file exists. PASS: script checks all conditions. FAIL: any condition unchecked.
- [ ] `scripts/template-check.sh` (without --quiet) prints a human-readable report with checkmark per passing item and X per failing item with the exact file path. PASS: output uses checkmarks and plain English. FAIL: raw error codes only.
- [ ] Running `template-check.sh` on the unmodified cloned template produces at least 3 specific failures. PASS: ≥3 distinct failure messages. FAIL: <3 failures or generic "not configured" message.

**Traces To:**
- Charter: §4 S7 (deterministic enforcement), E1 (least surprise)
- Source: S2 (R09 version tracking, R13 simplicity)

**Pillar Check:**
- Sustainability: Automated validation is the only enforcement that scales to 8+ projects
- Efficiency: --quiet enables CI; full output enables human debugging
- Scalability: Adding checks is a one-line script change

---

### REQ-029: Feedback Loop (Friction Capture)
**MoSCoW: S (Should Have) | Pillar: Su | Source: S2 (R14)**

| Element | Description |
|---------|-------------|
| **Verb** (Action) | Capture |
| **Adverb** (Outcome) | immediately and with minimal friction (under 60 seconds) |
| **Noun** (Subject) | any team member's confusion, frustration, or improvement suggestion |
| **Adjective** (Effectiveness) | as a structured GitHub Issue that template maintainers can triage without requiring a meeting |

**Acceptance Criteria (binary PASS/FAIL):**
- [ ] `/feedback` skill exists in `.claude/skills/` and is documented in CLAUDE.md. Running `/feedback` creates a GitHub Issue within 60 seconds. PASS: skill exists, creates issue in ≤60s. FAIL: skill missing or >60s.
- [ ] CLAUDE.md contains a trigger: when a user expresses frustration or confusion, the agent offers `/feedback` by name. PASS: trigger text exists in CLAUDE.md. FAIL: no trigger.
- [ ] At least one example feedback issue exists in the template repo's GitHub Issues. PASS: example issue exists. FAIL: no example.

**Traces To:**
- Charter: §4 S6 (friction capture), Design Principle 4
- Source: S2-consensus (R14 friction kills adoption)

**Pillar Check:**
- Sustainability: Real-time friction capture prevents accumulation into "template is unusable"
- Efficiency: 60-second capture does not interrupt workflow
- Scalability: GitHub Issues scales to unlimited feedback

---

### REQ-030: MoSCoW-Labeled Zone READMEs
**MoSCoW: S (Should Have) | Pillar: E | Source: S2 (R13)**

| Element | Description |
|---------|-------------|
| **Verb** (Action) | Label |
| **Adverb** (Outcome) | explicitly within each ALPEI zone README |
| **Noun** (Subject) | every artifact listed in a zone README |
| **Adjective** (Effectiveness) | with MoSCoW priority and "read before working" vs "reference only" tags — so users know what is mandatory vs optional without reading everything |

**Acceptance Criteria (binary PASS/FAIL):**
- [ ] Each zone README contains a table with columns: artifact name, file path, MoSCoW tag, "Read Before Working" (yes/no), one-sentence description. PASS: table present with all columns populated. FAIL: any column or artifact missing.
- [ ] Total "Must Read Before Working" artifacts per zone is ≤3. PASS: no zone exceeds 3 must-reads. FAIL: any zone has >3.
- [ ] An agent loading a zone README can identify the must-read artifacts without reading other files. PASS: agent test confirms. FAIL: agent needs additional files.

**Traces To:**
- Charter: §4 E1 (least surprise), E2 (lean templates)
- Source: S2-consensus (R13 simplicity)

**Pillar Check:**
- Sustainability: MoSCoW labels prevent both extremes — skipping critical files and being paralyzed by optional ones
- Efficiency: ≤3 must-reads per zone = ≤15 files total to understand the full template
- Scalability: Labels prevent READMEs from becoming undifferentiated lists as template grows

---

### REQ-031: Worked Example Artifact
**MoSCoW: C (Could Have) | Pillar: E | Source: S2**

| Element | Description |
|---------|-------------|
| **Verb** (Action) | Include |
| **Adverb** (Outcome) | in at least one zone demonstrating the complete artifact lifecycle |
| **Noun** (Subject) | a worked example of a filled Charter, ADR, and UBS entry for a fictional LTC project |
| **Adjective** (Effectiveness) | realistic enough that a team member can pattern-match against it — not a toy example |

**Acceptance Criteria (binary PASS/FAIL):**
- [ ] `docs/examples/` contains at minimum: one filled PROJECT_CHARTER.md for a fictional LTC project, one ADR with full decision structure, one UBS entry with all layers. PASS: all 3 example files exist and are complete. FAIL: any missing or incomplete.
- [ ] Example Charter's EO follows the "[User] [desired state] without [constraint]" format. PASS: EO matches format exactly. FAIL: paraphrased or simplified.
- [ ] Example files include a header comment: "THIS IS AN EXAMPLE — do not modify." PASS: header present. FAIL: header missing.

**Traces To:**
- Charter: §4 E3 (agent does heavy lifting — examples reduce inference errors)
- Source: S2 — team feedback on needing concrete examples

**Pillar Check:**
- Sustainability: Examples calibrate both agents and humans against known-good artifacts
- Efficiency: One example teaches better than five pages of explanation
- Scalability: Example stays fixed; only updated when format changes

---

### REQ-032: Obsidian Bases Dashboard
**MoSCoW: C (Could Have) | Pillar: E | Source: S1 (R03)**

| Element | Description |
|---------|-------------|
| **Verb** (Action) | Provide |
| **Adverb** (Outcome) | as an optional interim dashboard for the human PM role |
| **Noun** (Subject) | Obsidian Bases configuration for the template's knowledge layer |
| **Adjective** (Effectiveness) | so that a human PM can view cross-zone status without opening individual files or running git commands |

**Acceptance Criteria (binary PASS/FAIL):**
- [ ] ADR-003 documents the Obsidian Bases decision with options and chosen approach (deferred to I2). PASS: ADR-003 exists with decision. FAIL: no ADR.
- [ ] Template functions fully without Obsidian Bases — it is additive, not required. PASS: all other requirements pass without Obsidian Bases. FAIL: any requirement depends on Obsidian Bases.

**Traces To:**
- Charter: §2 Out of Scope (deferred to I2)
- Source: S1 — Vinh suggests Obsidian Bases as interim dashboard

**Pillar Check:**
- Sustainability: Optional dashboard does not add adoption friction
- Efficiency: Cross-zone visibility reduces PM overhead
- Scalability: Obsidian Bases can scale to org-wide view if adopted

---

## Traceability Matrix

| REQ | Source | MoSCoW | Pillar | R-ID |
|-----|--------|--------|--------|------|
| REQ-001 | S1 | M | Su | R01 |
| REQ-002 | S1 | M | Su | R05 |
| REQ-003 | S2-Vinh | M | Su | R15 |
| REQ-004 | S1 | S | Sc | R04 |
| REQ-005 | S2 | M | Su | R13,R14 |
| REQ-006 | S2 | M | Su | R12,R13,R14 |
| REQ-007 | S2-Dat | M | Su | R06 |
| REQ-008 | S2-Dat | M | Su | R07 |
| REQ-009 | S2-Khang | M | Su | R09 |
| REQ-010 | S2-Khang | S | Su | R08 |
| REQ-011 | S2-Long | M | Su | R10 |
| REQ-012 | S2 | M | Su | R12 |
| REQ-013 | S2 | M | Su | R13 |
| REQ-014 | S2 | M | Su | R14 |
| REQ-015 | S2 | M | Su | R06,R13 |
| REQ-016 | S2-Dat,S1 | M | Su | R06,R01 |
| REQ-017 | S2-Vinh | M | Su | R17 |
| REQ-018 | S4 | M | Su | R18 |
| REQ-019 | S4 | M | Su | R19 |
| REQ-020 | S4 | M | Su | R20 |
| REQ-021 | S4 | M | Su | R21 |
| REQ-022 | S4 | M | Su | R22 |
| REQ-023 | S4 | M | Su | R23 |
| REQ-024 | S2-Long | M | Sc | R11 |
| REQ-025 | S4 | S | E | R24 |
| REQ-026 | S1 | S | E | R02 |
| REQ-027 | S2-Vinh | S | E | R16 |
| REQ-028 | S2 | M | Su | R09,R13 |
| REQ-029 | S2 | S | Su | R14 |
| REQ-030 | S2 | S | E | R13 |
| REQ-031 | S2 | C | E | — |
| REQ-032 | S1 | C | E | R03 |

**Coverage Check:** All 24 source requirements (R01-R24) are traced. R01→REQ-001, R02→REQ-026, R03→REQ-032, R04→REQ-004, R05→REQ-002, R06→REQ-007/015, R07→REQ-008, R08→REQ-010, R09→REQ-009/028, R10→REQ-011, R11→REQ-024, R12→REQ-012, R13→REQ-005/013/015, R14→REQ-014, R15→REQ-003, R16→REQ-027, R17→REQ-017, R18→REQ-018, R19→REQ-019, R20→REQ-020, R21→REQ-021, R22→REQ-022, R23→REQ-023, R24→REQ-025.

**MoSCoW Summary:** Must=22 | Should=7 | Could=2 | Won't=0

---

**Classification:** INTERNAL
