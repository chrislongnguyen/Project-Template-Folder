---
version: "1.1"
iteration: "I1: Concept"
status: Draft
last_updated: 2026-03-30
owner: Long Nguyen
---

# KEY RESULTS
## Measurable Results with Formulas
### Derived From: Derived Truth #1 (3 Pillars); Charter EO; REQUIREMENTS.md (Must-have reqs)

---

## Key Principle
> KPIs without formulas are aspirations, not metrics.

Each Key Result specifies:
1. Which effectiveness **pillar** it measures (S = Sustainability / E = Efficiency / Sc = Scalability)
2. The **objective** it tracks
3. An explicit **calculation formula** referencing real, observable data
4. A **target** for I1
5. **Requirement traceability** to Must-have requirements

---

## Key Results for O1: Template Adoption

| KR# | Description | Pillar | Formula | Target | Current | Status | Req Trace |
|-----|-------------|--------|---------|--------|---------|--------|-----------|
| KR-1.1 | Non-technical Director can navigate to correct zone within 15 min | **S** | `Pass/Fail = Khang (or equivalent) clones repo, opens README, identifies correct zone for a given task type, within 15 min. Data source: timed walkthrough test` | PASS | — | Not Started | REQ-005, REQ-006 |
| KR-1.2 | Every ALPEI zone has a README answering 3 questions (what, first action, anti-content) | **S** | `Zone README Coverage = (zones with compliant README) / (total ALPEI zones). Data source: template-check.sh --quiet output` | 100% (6/6) | — | Not Started | REQ-005, REQ-015 |
| KR-1.3 | Team adoption: members who clone and produce a first artifact without asking Long | **S** | `Adoption Rate = (members who complete first artifact unassisted) / (members who attempt clone). Data source: team retro survey post-I1` | ≥ 50% (4/8) | — | Not Started | REQ-012, REQ-013, REQ-014 |
| KR-1.4 | Subfolder descriptions present so users and agents know what goes where | **S** | `Subfolder Description Coverage = (subfolders with description in parent README or CLAUDE.md) / (total subfolders requiring description per REQ-007). Data source: grep for subfolder tables in zone READMEs` | 100% | — | Not Started | REQ-007, REQ-015 |

---

## Key Results for O2: Agent Alignment

| KR# | Description | Pillar | Formula | Target | Current | Status | Req Trace |
|-----|-------------|--------|---------|--------|---------|--------|-----------|
| KR-2.1 | Agent produces zone-correct artifact on first attempt (no hallucinated structure) | **S** | `Agent Compliance Rate = (artifacts placed in correct zone with correct structure) / (total artifacts agent produces in test run). Data source: 5-artifact test suite run by Claude Code against cloned template` | ≥ 80% (4/5) | — | Not Started | REQ-016, REQ-017 |
| KR-2.2 | Multi-agent roster: 4 MECE agents with scoped tool allowlists and enforcement hooks | **S** | `Agent Roster Completeness = (agents configured with allowlist + hook) / 4. Data source: AGENTS.md + .claude/hooks/ file count` | 100% (4/4) | — | Not Started | REQ-018, REQ-019, REQ-021 |
| KR-2.3 | Eval gates block artifact shipping when evidence is insufficient | **E** | `Gate Enforcement Rate = (artifacts blocked by eval gate when evidence missing) / (artifacts submitted without evidence in test run). Data source: hook execution log from 3-artifact test` | 100% (3/3) | — | Not Started | REQ-023, REQ-022 |

---

## Key Results for O3: Structural Integrity

| KR# | Description | Pillar | Formula | Target | Current | Status | Req Trace |
|-----|-------------|--------|---------|--------|---------|--------|-----------|
| KR-3.1 | template-check.sh validates all required zones and files with exit 0 | **E** | `Validation Pass = template-check.sh --quiet exit code. Data source: script execution on clean clone` | Exit 0 | — | Not Started | REQ-028, REQ-001 |
| KR-3.2 | Version tracking visible: VERSION file + CHANGELOG updated per release | **Sc** | `Version Visibility = (VERSION file exists ∧ CHANGELOG has I1 entry ∧ frontmatter version matches). Data source: git diff on release branch` | All 3 checks PASS | — | Not Started | REQ-009, REQ-024 |
| KR-3.3 | Template cloneable without modification for a new project | **Sc** | `Clone-Ready Score = (placeholder fields in templates) / (hardcoded project-specific values in templates). Data source: grep for project-specific strings in template files, excluding CLAUDE.md` | 0 hardcoded values | — | Not Started | REQ-024, REQ-013 |

---

## Pillar Coverage Summary

| Pillar | KRs | Count |
|--------|-----|-------|
| **Sustainability (S)** | KR-1.1, KR-1.2, KR-1.3, KR-1.4, KR-2.1, KR-2.2 | 6 |
| **Efficiency (E)** | KR-2.3, KR-3.1 | 2 |
| **Scalability (Sc)** | KR-3.2, KR-3.3 | 2 |

S-heavy distribution is intentional: I1 = Sustainability iteration per charter §4.

---

## Must-Have Requirement Traceability

Every Must-have REQ must trace to at least one KR:

| REQ | KR(s) | Notes |
|-----|-------|-------|
| REQ-001 (LEARN Zone Separation) | KR-3.1 | Validated via template-check.sh |
| REQ-002 (Learning Pipeline) | KR-3.1 | Structure validated by script |
| REQ-003 (Three Learning Types) | KR-3.1, KR-1.2 | README coverage + script validation |
| REQ-005 (Zone Navigation) | KR-1.1, KR-1.2 | Walkthrough test + README audit |
| REQ-006 (First-Run Orientation) | KR-1.1 | Timed walkthrough |
| REQ-007 (Subfolder Descriptions) | KR-1.4 | Coverage metric |
| REQ-008 (Skill Scope Enforcement) | KR-2.2 | Agent allowlists |
| REQ-009 (Version Tracking) | KR-3.2 | VERSION + CHANGELOG check |
| REQ-010 (Release Announcement) | KR-3.2 | CHANGELOG entry |
| REQ-011 (Iteration Priority) | KR-1.3 | Adoption validates S-first approach |
| REQ-012 (Problem-First) | KR-1.3 | Adoption rate as outcome |
| REQ-013 (Simplicity-First) | KR-1.3, KR-3.3 | Adoption + clone-ready |
| REQ-014 (Friction Minimization) | KR-1.3 | Adoption rate |
| REQ-015 (Plain-Language) | KR-1.2, KR-1.4 | README compliance |
| REQ-016 (Agent Orientation) | KR-2.1 | Agent test suite |
| REQ-017 (ALPEI as Human Flow) | KR-2.1 | Agent produces zone-correct artifacts |
| REQ-018 (4 MECE Agents) | KR-2.2 | Roster completeness |
| REQ-019 (3 Enforcement Hooks) | KR-2.2 | Hook file count |
| REQ-020 (Context Packaging) | KR-2.1 | Agent compliance test |
| REQ-021 (Tool Routing) | KR-2.2 | Allowlist check |
| REQ-022 (3 New EPs) | KR-2.3 | Gate enforcement |
| REQ-023 (Eval Gates) | KR-2.3 | Gate enforcement rate |
| REQ-024 (I0-I4 Model) | KR-3.2, KR-3.3 | Version + clone-ready |
| REQ-028 (Validation Script) | KR-3.1 | Script exit code |
| REQ-029 (Feedback Loop) | KR-1.3 | Adoption survey captures friction |
| REQ-030 (MoSCoW Zone READMEs) | KR-1.2 | README coverage |
| REQ-031 (Worked Example) | KR-1.1 | Walkthrough uses example |
| REQ-032 (Obsidian Bases) | — | Out of scope I1 (Could Have) |

---

**Classification:** INTERNAL
