---
version: "1.1"
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

**Usability Lens (Team 2 focus):** Requirements are evaluated from Khang's perspective — what makes this template USABLE by a non-technical director in under 15 minutes of first contact.

---

## Requirements

---

### REQ-001: Zone Navigation Clarity
**MoSCoW: M (Must Have)**

| Element | Description |
|---------|-------------|
| **Verb** (Action) | Guide |
| **Adverb** (Outcome) | unambiguously and within 5 minutes of opening the repo |
| **Noun** (Subject) | any team member (technical or non-technical) |
| **Adjective** (Effectiveness) | to the correct zone folder for their current work type without external help |

**Acceptance Criteria (binary):**
- [ ] Root README contains a zone map table: rows = zone names, columns = "when to use this" and "first file to read." A new team member can identify the correct zone for a given task (e.g., "I need to document a risk") in under 60 seconds using only the README.
- [ ] Each zone (0–4, _shared) contains a README.md. README.md is the first file listed in that folder. README.md answers in plain language: (1) what this zone is for, (2) what to do first, (3) what not to put here.
- [ ] template-check.sh --quiet exits 0 only when all zone READMEs exist and are non-empty.

**Traces To:**
- Charter: §2 In-Scope (zone READMEs), §4 Principles E1, S1
- Risk: UBS-001 (cognitive overload), UBS-005 (wrong zone)
- Stakeholder UBS: Khang — "doesn't know where to start"

**Pillar Check:**
- Sustainability: Clear navigation prevents the "ask Long" failure mode — reduces the single-person dependency risk
- Efficiency: 60-second zone identification = zero overhead per task start; minimum viable navigation artifact is one README per zone
- Scalability: Zone structure is fixed (5 zones) — navigation guidance scales to N team members without modification

---

### REQ-002: First-Run Orientation
**MoSCoW: M (Must Have)**

| Element | Description |
|---------|-------------|
| **Verb** (Action) | Orient |
| **Adverb** (Outcome) | completely and self-sufficiently within 15 minutes of cloning |
| **Noun** (Subject) | a non-technical director (Khang archetype) |
| **Adjective** (Effectiveness) | to the point where they can name their first action without asking for help |

**Acceptance Criteria (binary):**
- [ ] Root README contains a "Start Here" section with 5 numbered steps that are executable (not descriptive). Steps must be: (1) rename the repo, (2) open 1-ALIGN/charter/, (3) do X, (4) do Y, (5) run template-check.sh. No step requires reading a framework guide first.
- [ ] GETTING_STARTED.md exists at `4-EXECUTE/docs/onboarding/GETTING_STARTED.md` and contains: what to install (git), how to clone, how to run template-check.sh, what to do when something breaks.
- [ ] A user with zero prior LTC template experience can, by following the README alone, produce a non-empty PROJECT_CHARTER.md draft within 30 minutes — validated by user test with Khang.

**Traces To:**
- Charter: §2 Success definition ("Khang can navigate in under 15 minutes")
- Risk: UBS-001 (overwhelming first impression), UBS-002 (skipping Zone 1)
- Stakeholder: Khang primary failure mode

**Pillar Check:**
- Sustainability: Onboarding is the highest-friction point — investing here prevents permanent "ask Long" dependency
- Efficiency: 15-minute onboarding cap forces README to stay focused; every word must earn its place
- Scalability: Onboarding must work for all future team members without Long being present

---

### REQ-003: Plain-Language Template Instructions
**MoSCoW: M (Must Have)**

| Element | Description |
|---------|-------------|
| **Verb** (Action) | Provide |
| **Adverb** (Outcome) | inline and without requiring external framework knowledge |
| **Noun** (Subject) | every template field in every zone artifact |
| **Adjective** (Effectiveness) | with a one-line instruction and a concrete example of what good looks like |

**Acceptance Criteria (binary):**
- [ ] Every placeholder field in PROJECT_CHARTER.md, STAKEHOLDERS.md, REQUIREMENTS.md, UBS_REGISTER.md, UDS_REGISTER.md contains an HTML comment with: (1) one sentence explaining what to write, (2) one concrete example specific to LTC projects (not generic). No field has only `[placeholder text]` without instruction.
- [ ] Framework acronyms (UBS, UDS, VANA, EO, RACI) that appear in templates include a parenthetical plain-English expansion on first use within that file.
- [ ] template-check.sh --quiet detects and flags any template file containing unfilled placeholder patterns (`[Name/Role]`, `[YYYY-MM-DD]`, `{Human Director}`) in a consumer repo — exits with a specific error code per violation type.

**Traces To:**
- Charter: §4 Principles S2 (guard rails in templates)
- Risk: UBS-003 (framework jargon kills adoption)
- Stakeholder UBS: Khang — "framework jargon with no plain-language explanation"

**Pillar Check:**
- Sustainability: Inline instructions prevent the failure mode where users leave fields blank or fill them wrong, producing useless artifacts
- Efficiency: One-line instruction per field is the minimum viable guidance — longer explanations go to _shared/frameworks/
- Scalability: Instructions are per-file, not per-user — scales to any team size without customization

---

### REQ-004: Agent Orientation via CLAUDE.md
**MoSCoW: M (Must Have)**

| Element | Description |
|---------|-------------|
| **Verb** (Action) | Configure |
| **Adverb** (Outcome) | immediately upon first load without additional prompting |
| **Noun** (Subject) | any Claude Code or compatible AI agent |
| **Adjective** (Effectiveness) | with complete project context: EO, zone structure, rules, and pre-flight protocol — so the agent produces correct zone-scoped artifacts from the first response |

**Acceptance Criteria (binary):**
- [ ] CLAUDE.md (root) contains within first 50 lines: project name, stack, purpose statement, and the 5-zone structure map. An agent reading only the first 50 lines can identify: what this project is, what zone to work in for a given task, and what rules govern its behavior.
- [ ] CLAUDE.md §Before Every Task contains a numbered pre-flight protocol of 5 steps or fewer, each step pointing to a specific file path (not a vague instruction). The pre-flight protocol must include: read Charter, read UBS, read UDS.
- [ ] An agent given the CLAUDE.md and a task prompt "fill in the charter for the project" produces a Charter that matches the EO format (one testable sentence) without additional instruction — validated by running the prompt against the template.

**Traces To:**
- Charter: §4 Principles Sc3, E3
- Risk: UBS-004 (agent drift without project context)
- Stakeholder: Future AI Agents — primary operating rules

**Pillar Check:**
- Sustainability: Correct agent orientation at load time prevents compounding errors across a long session — fixing one wrong assumption is cheaper than fixing 10 artifacts built on it
- Efficiency: CLAUDE.md is read once per session — investing in clarity here pays dividends across all agent interactions
- Scalability: Same CLAUDE.md pattern works for Claude Code, Gemini (GEMINI.md), and future agents — modular by agent file

---

### REQ-005: Validation Script Completeness
**MoSCoW: M (Must Have)**

| Element | Description |
|---------|-------------|
| **Verb** (Action) | Validate |
| **Adverb** (Outcome) | automatically and without human inspection |
| **Noun** (Subject) | the structural integrity of any consumer repo cloned from this template |
| **Adjective** (Effectiveness) | against a complete checklist of required files, non-empty zones, and filled frontmatter — producing a pass/fail result with specific error messages |

**Acceptance Criteria (binary):**
- [ ] `scripts/template-check.sh --quiet` exits 0 if and only if: all 5 zone folders exist, all zone READMEs exist and are non-empty, CLAUDE.md exists at root, all charter templates have non-default frontmatter (version != "0.1", owner != "{Human Director}"), and VERSION file exists.
- [ ] `scripts/template-check.sh` (without --quiet) prints a human-readable report: checkmark per passing item, X per failing item with the exact file path and what is missing. Report is readable by a non-technical user (no bash jargon in error messages).
- [ ] Running template-check.sh on the unmodified cloned template (all placeholders unfilled) produces at least 3 specific failures, not a generic "template not configured" message.

**Traces To:**
- Charter: §4 Principles S4 (enforcement), E1 (least surprise)
- Risk: UBS-008 (template drift), UBS-006 (skipped setup)
- Stakeholder: All users — validation reduces dependency on Long for "is this correct?"

**Pillar Check:**
- Sustainability: Automated validation is the only enforcement mechanism that works at scale — human review does not scale to 8+ projects
- Efficiency: --quiet flag enables CI pipeline use; full output enables human debugging
- Scalability: Adding new required files to the check list is a one-line script change

---

### REQ-006: Folder Structure Cognitive Load Limit
**MoSCoW: S (Should Have)**

| Element | Description |
|---------|-------------|
| **Verb** (Action) | Limit |
| **Adverb** (Outcome) | deliberately to avoid decision paralysis |
| **Noun** (Subject) | the number of visible files and folders at the root level and within each zone |
| **Adjective** (Effectiveness) | to a cognitive load that a non-technical director can scan and understand in under 30 seconds (Miller's Law: ≤7 items at root level) |

**Acceptance Criteria (binary):**
- [ ] Root directory contains 10 or fewer visible items (files + folders). Items that are agent-internal (`.claude/`, `.cursor/`, `.gemini/`) are present but visually de-prioritized by naming convention (dot-prefix). The 5 zone folders (1-ALIGN, 3-PLAN, 4-EXECUTE, 5-IMPROVE, _shared) are the dominant visual pattern.
- [ ] Each zone folder contains a maximum of 6 top-level folders or files before sub-navigation is required. Exception: `_shared/` may have up to 8 given its cross-cutting nature.
- [ ] When a non-technical user is shown a screenshot of the root directory (no README), they can correctly identify the purpose of at least 4 of the 5 zone folders from the folder names alone — validated by asking Khang during a template walkthrough.

**Traces To:**
- Charter: §4 Principles E1 (principle of least surprise), S1 (no zone requires external explanation)
- Risk: UBS-001 (overwhelming first impression)
- Stakeholder: Khang — "too many folders make him anxious"

**Pillar Check:**
- Sustainability: Cognitive load limits prevent the "close the repo" failure mode that creates Long-dependency
- Efficiency: Fewer visible items = faster navigation = less time lost to orientation
- Scalability: Folder count is a design constraint, not a function of project size — it scales by definition

---

### REQ-007: Feedback Loop (Friction Capture)
**MoSCoW: S (Should Have)**

| Element | Description |
|---------|-------------|
| **Verb** (Action) | Capture |
| **Adverb** (Outcome) | immediately and with minimal friction (under 60 seconds) |
| **Noun** (Subject) | any team member's confusion, frustration, or improvement suggestion |
| **Adjective** (Effectiveness) | as a structured GitHub Issue that template maintainers can triage, prioritize, and act on — without requiring a meeting or Slack message |

**Acceptance Criteria (binary):**
- [ ] `/feedback` skill exists at `5-IMPROVE/skills/feedback/SKILL.md` and is documented in CLAUDE.md. Running `/feedback` with a description creates a GitHub Issue in the template repo within 60 seconds — no additional human steps required.
- [ ] CLAUDE.md contains a trigger instruction: when a user expresses frustration, confusion, or improvement suggestion, the agent offers "/feedback" by name with an estimated time ("Takes 30 seconds").
- [ ] At least one worked example of a feedback issue exists in the template repo's GitHub Issues demonstrating the format — so new team members can see what a good feedback entry looks like.

**Traces To:**
- Charter: §4 Principles S3, Sc1
- Risk: UBS-007 (template never improves because feedback never reaches maintainer)
- Stakeholder: All users — any team member can surface friction

**Pillar Check:**
- Sustainability: Capturing friction in real-time prevents it from accumulating into "the template is unusable" — each issue is a data point for improvement
- Efficiency: 60-second capture means feedback doesn't interrupt workflow; structured format means triaging is fast
- Scalability: GitHub Issues scales to unlimited feedback without Long managing an inbox

---

### REQ-008: MoSCoW-Labeled Zone README Structure
**MoSCoW: S (Should Have)**

| Element | Description |
|---------|-------------|
| **Verb** (Action) | Label |
| **Adverb** (Outcome) | explicitly within each zone README |
| **Noun** (Subject) | every artifact listed in a zone README |
| **Adjective** (Effectiveness) | with a MoSCoW priority and a "read before you work here" vs "reference only" tag — so a team member knows what is mandatory vs optional without reading everything |

**Acceptance Criteria (binary):**
- [ ] Each zone README contains a table: rows = artifact name + file path, columns = MoSCoW (M/S/C/W), "Read Before Working" (yes/no), description (one sentence). No artifact is listed without all three columns populated.
- [ ] Total "Must Read Before Working" artifacts per zone is 3 or fewer — enforced by README structure. All other artifacts are "Reference Only."
- [ ] An agent loading a zone README can identify the 3 must-read artifacts per zone without reading any other file — verified by prompt test.

**Traces To:**
- Charter: §4 Principles E1, E2
- Risk: UBS-002 (skipping Zone 1), UBS-001 (volume paralysis)
- Stakeholder: Other 6 team members — "treat every file as mandatory"

**Pillar Check:**
- Sustainability: Explicit MoSCoW in READMEs prevents both extremes — skipping critical files and being paralyzed by optional ones
- Efficiency: Limits "must read" to 3 per zone = maximum 15 files total across all zones to understand the full template
- Scalability: As template grows, MoSCoW labels prevent README from becoming an undifferentiated list

---

### REQ-009: Worked Example Artifact
**MoSCoW: C (Could Have)**

| Element | Description |
|---------|-------------|
| **Verb** (Action) | Include |
| **Adverb** (Outcome) | in at least one zone, demonstrating the complete artifact lifecycle |
| **Noun** (Subject) | a worked example of a filled Charter, ADR, and UBS entry for a fictional LTC project |
| **Adjective** (Effectiveness) | realistic enough that a team member can pattern-match their own project context against it — not a toy example, but a plausible LTC project scenario |

**Acceptance Criteria (binary):**
- [ ] `docs/examples/` directory contains at minimum: one filled PROJECT_CHARTER.md for a fictional LTC project (e.g., "OPS_OE.7.1.REPORTING-DASHBOARD"), one ADR with a real decision structure, one UBS entry with all 7 layers filled.
- [ ] The example Charter's EO follows the "[User] [desired state] without [constraint]" format exactly — no paraphrasing or simplification that could mislead.
- [ ] Example files include a header comment: "THIS IS AN EXAMPLE — do not modify. Copy the template from 1-ALIGN/charter/ for your project."

**Traces To:**
- Charter: §4 Principles E3 (agent does heavy lifting — example reduces agent inference errors)
- Risk: UBS-003 (jargon), UBS-009 (first artifact quality)
- Stakeholder: Dong — "needs concrete examples for technical decisions"

**Pillar Check:**
- Sustainability: Examples act as calibration anchors — agents and humans can compare their output against a known-good artifact
- Efficiency: One good example teaches better than five pages of explanation
- Scalability: Example stays fixed as the template evolves; only updated when the template format changes materially

---

**Classification:** INTERNAL
