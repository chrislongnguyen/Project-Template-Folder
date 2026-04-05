---
version: "2.0"
status: Draft
last_updated: 2026-04-04
owner: "Long Nguyen"
type: template
work_stream: 0-govern
stage: design
---
# Template Blueprint — LTC Project Template

> Authoritative index of ALL templates. Agent templates live in `_genesis/templates/`. Obsidian Templater templates live in `_genesis/obsidian/templates/`. This README governs both.

## How to Use

### Via Claude Code (primary path)
Agent reads the appropriate template from `_genesis/templates/` automatically when:
- `/dsbv build` creates a workstream artifact
- `/learn` creates research outputs
- Any skill that produces ALPEI deliverables

The agent fills ALL frontmatter contextually — you don't need to specify field values.

### Via Obsidian Templater (manual fast path)
Press `Ctrl+T` (or `Cmd+T`) in Obsidian → select a template → fill prompted fields.
Use this when Claude Code isn't open and you need to quickly create:
- A daily note, inbox capture, ADR, risk entry, or driver entry

### Via Both
Some templates exist in BOTH locations. The agent version is the source of truth for structure. The Obsidian version adds Templater syntax (auto-fill dates, prompted fields).

## Naming Convention

| Convention | Example | Rule |
|-----------|---------|------|
| Agent templates | `CHARTER_TEMPLATE.md` | ALLCAPS with `_TEMPLATE` suffix |
| Obsidian templates | `charter.md` | lowercase, no suffix (Templater picks up by name) |
| Template IDs | T1, T2, ... T8 | Gap-fill templates added in I1 |

## Frontmatter Standard

Every template produces files with these frontmatter fields:

| Field | Values | Set by |
|-------|--------|--------|
| `type` | `ues-deliverable`, `decision`, `risk`, `driver`, `daily-note`, `template`, `project-index` | Template (hardcoded) |
| `version` | `"1.0"` for new files (MAJOR = iteration) | Template (hardcoded) |
| `status` | `draft` (always for new files) | Template (hardcoded) |
| `last_updated` | `YYYY-MM-DD` | Agent auto / Templater auto |
| `work_stream` | `1-align`, `2-learn`, `3-plan`, `4-execute`, `5-improve`, `0-govern` | Agent contextual / Templater prompted or hardcoded |
| `stage` | `design`, `sequence`, `build`, `validate` | Agent contextual / Templater prompted or hardcoded |
| `sub_system` | `1-PD`, `2-DP`, `3-DA`, `4-IDM` | Agent contextual / Templater prompted |
| `iteration` | `I1`, `I2`, `I3`, `I4` | Agent contextual / Templater prompted |
| `owner` | Name | Agent contextual / Templater hardcoded |

## Master Template Index

Legend: `obsidian*` = planned, not yet created.

### DSBV Process Templates (0-GOVERN)

| ID | Template | Lines | Location | Purpose | Invocation | Output Path |
|----|----------|-------|----------|---------|-----------|-------------|
| — | DESIGN_TEMPLATE.md | 126 | agent | DSBV Phase 1 contract: scope, artifacts, acceptance criteria | `/dsbv design {ws}` | `{N}-{WS}/DESIGN.md` |
| — | DSBV_PROCESS.md | 295 | agent | DSBV workflow definition, 9 patterns, C1-C6 readiness | `/dsbv` (reference) | N/A |
| — | DSBV_CONTEXT_TEMPLATE.md | 166 | agent | Agent input package: 8 LLM Truths + 7-CS grounding | `/dsbv build` (auto) | N/A |
| — | DSBV_EVAL_TEMPLATE.md | 154 | agent | Validation rubric: multi-agent synthesis, GO/NO-GO | `/dsbv validate` (auto) | N/A |

### 1-ALIGN Templates

| ID | Template | Lines | Location | Purpose | Invocation | Output Path |
|----|----------|-------|----------|---------|-----------|-------------|
| T1 | CHARTER_TEMPLATE.md | 83 | agent | Project charter: EO, stakeholders, scope, VANA criteria | `/dsbv build align` | `1-ALIGN/charter/CHARTER.md` |
| T1 | charter.md | — | obsidian* | Same structure + Templater prompts | `Ctrl+T → charter` | `1-ALIGN/charter/{title}.md` |
| T4 | FORCE_ANALYSIS_TEMPLATE.md | 81 | agent | UBS/UDS force analysis session | `/dsbv design align` or `plan` | Routes to UBS/UDS registers |
| T4 | force-analysis.md | — | obsidian* | Same + Templater prompts | `Ctrl+T → force-analysis` | `1-ALIGN/decisions/{title}.md` |
| T3 | OKR_TEMPLATE.md | 75 | agent | OKR register: Objective + KRs with baseline/target | `/dsbv build align` | `1-ALIGN/okrs/OKR_REGISTER.md` |
| T3 | okr.md | — | obsidian* | Same + Templater prompts | `Ctrl+T → okr` | `1-ALIGN/okrs/{title}.md` |
| — | ADR_TEMPLATE.md | 21 | agent | ADR stub → points to full template in 1-ALIGN | Agent reads on ADR creation | `1-ALIGN/decisions/ADR-{ID}_{slug}.md` |
| — | adr.md | 35 | obsidian | ADR with Templater prompts | `Ctrl+T → adr` | `1-ALIGN/decisions/{title}.md` |
| — | VANA_SPEC_TEMPLATE.md | 533 | agent | Full VANA requirements spec (11 sections) | `/dsbv build align` (I2+) | `1-ALIGN/specs/{sub}-VANA-SPEC.md` |

### 2-LEARN Templates

| ID | Template | Lines | Location | Purpose | Invocation | Output Path |
|----|----------|-------|----------|---------|-----------|-------------|
| — | RESEARCH_METHODOLOGY.md | 136 | agent | Research methodology: multi-angle search, source verification | `/learn` (reference) | N/A |
| — | RESEARCH_TEMPLATE.md | 20 | agent | Research stub → points to 2-LEARN/templates/ | Agent reads for research | `2-LEARN/research/{topic}.md` |
| — | SPIKE_TEMPLATE.md | 22 | agent | Spike stub: hypothesis-driven exploration | Agent reads for spikes | `2-LEARN/research/spikes/{topic}.md` |

### 3-PLAN Templates

| ID | Template | Lines | Location | Purpose | Invocation | Output Path |
|----|----------|-------|----------|---------|-----------|-------------|
| T2 | ARCHITECTURE_TEMPLATE.md | 80 | agent | Architecture doc: components, interfaces, data flows | `/dsbv build plan` | `3-PLAN/architecture/{sub}-ARCHITECTURE.md` |
| T2 | architecture.md | — | obsidian* | Same + Templater prompts | `Ctrl+T → architecture` | `3-PLAN/architecture/{title}.md` |
| T6 | ROADMAP_TEMPLATE.md | 75 | agent | Roadmap: iteration map, milestones, dependencies | `/dsbv build plan` | `3-PLAN/roadmap/{sub}-ROADMAP.md` |
| T6 | roadmap.md | — | obsidian* | Same + Templater prompts | `Ctrl+T → roadmap` | `3-PLAN/roadmap/{title}.md` |
| T5 | DRIVER_ENTRY_TEMPLATE.md | 63 | agent | UDS driver entry: root enabler + leverage actions | `/dsbv build plan` | `3-PLAN/drivers/UDS-{ID}.md` |
| — | driver-entry.md | 35 | obsidian | Same + Templater auto-fill | `Ctrl+T → driver-entry` | `3-PLAN/drivers/{title}.md` |
| — | RISK_ENTRY_TEMPLATE.md | 21 | agent | UBS risk stub → points to 3-PLAN/risks/ | Agent reads for risks | `3-PLAN/risks/UBS-{ID}.md` |
| — | risk-entry.md | 39 | obsidian | Risk + Templater auto-fill | `Ctrl+T → risk-entry` | `3-PLAN/risks/{title}.md` |

### 4-EXECUTE Templates

| ID | Template | Lines | Location | Purpose | Invocation | Output Path |
|----|----------|-------|----------|---------|-----------|-------------|
| T8 | TEST_PLAN_TEMPLATE.md | 89 | agent | Test plan: cases, AC coverage, pass/fail | `/dsbv validate execute` | `4-EXECUTE/tests/{sub}-TEST-PLAN.md` |
| T8 | test-plan.md | — | obsidian* | Same + Templater prompts | `Ctrl+T → test-plan` | `4-EXECUTE/tests/{title}.md` |
| — | SOP_TEMPLATE.md | 20 | agent | SOP stub → points to 8-component model | Agent reads for SOPs | `4-EXECUTE/docs/sops/{name}.md` |
| — | WIKI_PAGE_TEMPLATE.md | 19 | agent | Wiki page stub | Agent reads for docs | `4-EXECUTE/docs/{name}.md` |
| — | STANDUP_TEMPLATE.md | 33 | agent | Daily standup: Done/WIP/Blockers | Agent reads for standups | `DAILY-NOTES/{date}.md` |
| — | daily-note.md | 33 | obsidian | Same + Templater date auto-fill | `Ctrl+T → daily-note` | `DAILY-NOTES/{date}.md` |

### 5-IMPROVE Templates

| ID | Template | Lines | Location | Purpose | Invocation | Output Path |
|----|----------|-------|----------|---------|-----------|-------------|
| T7 | METRICS_BASELINE_TEMPLATE.md | 70 | agent | Metrics baseline: S/E/Sc pillars, measurement cadence | `/dsbv build improve` | `5-IMPROVE/metrics/{sub}-METRICS.md` |
| T7 | metrics-baseline.md | — | obsidian* | Same + Templater prompts | `Ctrl+T → metrics-baseline` | `5-IMPROVE/metrics/{title}.md` |
| — | RETRO_TEMPLATE.md | 20 | agent | Retro stub → points to 5-IMPROVE/retrospectives/ | Agent reads for retros | `5-IMPROVE/retrospectives/RETRO-I{N}.md` |
| — | REVIEW_TEMPLATE.md | 21 | agent | Review stub → points to 5-IMPROVE/reviews/ | Agent reads for reviews | `5-IMPROVE/reviews/REVIEW-I{N}.md` |
| — | REVIEW_PACKAGE_TEMPLATE.md | 60 | agent | Review package (auto-generated by script) | Script generates | `4-EXECUTE/reports/REVIEW-PACKAGE.md` |
| — | FEEDBACK_TEMPLATE.md | 25 | agent | Friction/idea capture → GitHub Issue | `/feedback` | `5-IMPROVE/feedback/{issue}.md` |

### Utility Templates

| ID | Template | Lines | Location | Purpose | Invocation | Output Path |
|----|----------|-------|----------|---------|-----------|-------------|
| — | ues-deliverable.md | 33 | obsidian | Generic DSBV artifact (any workstream/stage) | `Ctrl+T → ues-deliverable` | `{dynamic by picker}` |
| — | project-index.md | 38 | obsidian | Project-level Bases metadata index | `Ctrl+T → project-index` | Project root |
| — | GLOBAL_CLAUDE_MD_EXAMPLE.md | 74 | agent | Boilerplate for personal ~/.claude/CLAUDE.md | Copy manually | `~/.claude/CLAUDE.md` |

## Workstream x DSBV Phase Matrix

Shows which template to use at each intersection:

|  | Design | Sequence | Build | Validate |
|--|--------|----------|-------|----------|
| **1-ALIGN** | CHARTER_TEMPLATE (T1), FORCE_ANALYSIS_TEMPLATE (T4), VANA_SPEC_TEMPLATE, ADR_TEMPLATE | OKR_TEMPLATE (T3) | CHARTER_TEMPLATE (instance), ADR_TEMPLATE (instance) | REVIEW_TEMPLATE |
| **2-LEARN** | RESEARCH_METHODOLOGY, SPIKE_TEMPLATE | — (skill-based: `/learn`) | RESEARCH_TEMPLATE | `/learn` review |
| **3-PLAN** | FORCE_ANALYSIS_TEMPLATE (T4), RISK_ENTRY_TEMPLATE | ROADMAP_TEMPLATE (T6), DRIVER_ENTRY_TEMPLATE (T5) | ARCHITECTURE_TEMPLATE (T2) | REVIEW_TEMPLATE |
| **4-EXECUTE** | DESIGN_TEMPLATE | DSBV_CONTEXT_TEMPLATE | SOP_TEMPLATE, WIKI_PAGE_TEMPLATE, per-artifact | TEST_PLAN_TEMPLATE (T8), DSBV_EVAL_TEMPLATE |
| **5-IMPROVE** | METRICS_BASELINE_TEMPLATE (T7) | — | RETRO_TEMPLATE, FEEDBACK_TEMPLATE | REVIEW_PACKAGE_TEMPLATE |

## Links
- [[ADR_TEMPLATE]]
- [[alpei-dsbv-process-map]]
- [[architecture-template]]
- [[charter-template]]
- [[DESIGN]]
- [[design-template]]
- [[driver-entry-template]]
- [[dsbv-context-template]]
- [[dsbv-eval-template]]
- [[dsbv-process]]
- [[feedback-template]]
- [[force-analysis-template]]
- [[metrics-baseline-template]]
- [[okr-template]]
- [[research-methodology]]
- [[research-template]]
- [[retro-template]]
- [[review-package-template]]
- [[review-template]]
- [[risk-entry-template]]
- [[roadmap-template]]
- [[SEQUENCE]]
- [[sop-template]]
- [[spike-template]]
- [[standup-template]]
- [[test-plan-template]]
- [[VALIDATE]]
- [[vana-spec-template]]
- [[wiki-page-template]]
- [[dsbv]]
- [[versioning]]
- [[workstream]]
