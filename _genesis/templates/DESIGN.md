---
version: "1.0"
status: draft
last_updated: 2026-04-10
owner: Long Nguyen
workstream: GOVERN
iteration: 1
iteration_name: concept
type: design
work_stream: 0-GOVERN
stage: design
sub_system: _cross
---
# DESIGN.md — GOVERN × DSBV Template Alignment

> DSBV Phase 1 artifact. This document is the contract. If it is not here, it is not in scope.

---

## Scope Check

| Question | Answer |
|----------|--------|
| Q1: Are upstream workstream outputs sufficient? | **YES** — SKILL.md v2.1 shipped (a8f2792), L1=100%, L2=4.72. All gate scripts exist (gate-precheck.sh, gate-state.sh, set-status-in-review.sh, classify-fail.sh, verify-approval-record.sh). context-packaging.md v1.7 and circuit-breaker-protocol.md v1.0 are current. |
| Q2: What is in scope? | Update 4 stale templates + create 1 missing template in `_genesis/templates/` to align with SKILL.md v2.1. Update process-map routing table. |
| Q2b: What is explicitly OUT of scope? | SKILL.md changes. Script changes. Agent file changes. New scripts. Rule file changes. CLAUDE.md changes. Any workstream artifact outside `_genesis/templates/` and `_genesis/frameworks/alpei-dsbv-process-map.md`. |
| Q3: Go/No-Go | **GO** — All inputs are stable, gaps are documented, no upstream blockers. |

---

## Design Decisions

**Intent:** Align the 5 DSBV templates with SKILL.md v2.1 so that any PM who reads the templates encounters the exact same process that `/dsbv` executes — gate scripts, Generator/Critic loop, circuit breaker, approval signal detection, structured gate reports, and approval audit trail.

**Key constraints:**
- SKILL.md v2.1 is the source of truth — templates conform to it, not the other way around
- Templates are for human consumption (PMs, training) AND agent consumption (ltc-planner, ltc-builder, ltc-reviewer)
- No breaking changes to template frontmatter schema — only additive sections
- Iteration 1 scope: correct + safe only (no efficiency optimizations beyond E-1 through E-4)

---

## Artifact Inventory

Unified artifact-condition table. Every artifact has at least one condition. Every condition maps to an artifact.

| # | Artifact | Path | Purpose (WHY) | Acceptance Conditions |
|---|----------|------|---------------|-----------------------|
| A1 | sequence-template.md | `_genesis/templates/sequence-template.md` | Standardize SEQUENCE.md output so planner produces consistent task ordering across all workstreams and subsystems | AC-01: Template has YAML frontmatter with version, status, last_updated, workstream, iteration placeholders |
| A1 | | | | AC-02: Template has Dependency Map section with at least a table structure (ID, Task, Depends-on, Input, Output) |
| A1 | | | | AC-03: Template has Task Table with columns: ID, Name, Depends-on, Input, Output, AC, Size, Agent |
| A1 | | | | AC-04: Template has Critical Path section |
| A1 | | | | AC-05: Template has Git Strategy section (branch/worktree mapping) |
| A1 | | | | AC-06: Template has Approval Log section with table structure (Date, Gate, Decision, Signal, Tier) |
| A1 | | | | AC-07: Template references workstream-specific dependency patterns from phase-execution-guide.md |
| A2 | dsbv-eval-template.md | `_genesis/templates/dsbv-eval-template.md` | Align validation structure with SKILL.md's 4 Validate checks + evidence-based verdicts | AC-08: Universal dimensions are Completeness, Quality, Coherence, Downstream Readiness (matching SKILL.md §Phase 4 Steps 3-6) |
| A2 | | | | AC-09: Per-criterion verdict table exists with columns: Criterion (from DESIGN.md), Verdict (PASS/FAIL/PARTIAL), Evidence (file path + line/excerpt) |
| A2 | | | | AC-10: Template states "Criterion count in VALIDATE.md must equal DESIGN.md criterion count" |
| A2 | | | | AC-11: FAIL classification section exists with 4 types (SYNTACTIC/SEMANTIC/ENVIRONMENTAL/SCOPE) matching circuit-breaker-protocol.md |
| A2 | | | | AC-12: Aggregate Score concept is explicitly named and defined |
| A2 | | | | AC-13: Template has Approval Log section |
| A2 | | | | AC-14: dsbv-metrics.jsonl logging instruction exists |
| A3 | dsbv-process.md | `_genesis/templates/dsbv-process.md` | Reflect actual SKILL.md v2.1 process so training matches execution reality | AC-15: References gate-precheck.sh, gate-state.sh, set-status-in-review.sh in phase descriptions |
| A3 | | | | AC-16: Generator/Critic Loop section exists with max_iterations, exit_condition, cost_cap parameters |
| A3 | | | | AC-17: Circuit Breaker section exists with 4 error types and 3 hard-stop rules |
| A3 | | | | AC-18: Structured Gate Reports template is present |
| A3 | | | | AC-19: Approval Signal Detection catalog is present (4 tiers) |
| A3 | | | | AC-20: Gate Approval Protocol (6-step) is present or explicitly delegated to SKILL.md |
| A3 | | | | AC-21: EP count references 14 EPs (not 10) or references registry path |
| A3 | | | | AC-22: Template filenames use kebab-case (dsbv-context-template.md, not DSBV_CONTEXT_TEMPLATE.md) |
| A3 | | | | AC-23: Authority boundary stated: "SKILL.md is the execution authority; this document is the conceptual overview" |
| A3 | | | | AC-24: References section paths are all correct and current |
| A4 | design-template.md | `_genesis/templates/design-template.md` | Add audit trail and iteration awareness to DESIGN.md structure | AC-25: Approval Log section exists with table structure (Date, Gate, Decision, Signal, Tier) |
| A4 | | | | AC-26: Iteration/Version Context section exists referencing UES version behaviors |
| A4 | | | | AC-27: AC placeholders include at least one example of a binary, deterministic criterion |
| A4 | | | | AC-28: Alignment check bullet "Artifact count = deliverable count in SEQUENCE.md" is corrected (SEQUENCE.md doesn't exist at Design time — fix to reference DESIGN.md internal consistency) |
| A4 | | | | AC-29: Execution Strategy table includes Generator/Critic parameters row (max_iterations, cost_cap) |
| A5 | dsbv-context-template.md | `_genesis/templates/dsbv-context-template.md` | Add Budget section and clarify relationship to per-dispatch context-packaging.md | AC-30: Budget sub-section exists under Section 2 (INPUT) with token/scope guidance |
| A5 | | | | AC-31: max_tool_calls guidance present with default table per agent |
| A5 | | | | AC-32: Relationship to context-packaging.md is documented (this = workstream-level, that = per-dispatch) |
| A5 | | | | AC-33: Section 5 (Agent System Constraints) replaced with a reference to agent-system.md instead of inline boilerplate |
| A5 | | | | AC-34: EP task-type filtering guidance present (Research/Design/Build/Validate → specific EPs) |
| A6 | alpei-dsbv-process-map.md | `_genesis/frameworks/alpei-dsbv-process-map.md` | Update routing table to reference sequence-template.md and current template filenames | AC-35: Sequence column in Matrix Table 1 references sequence-template.md for all workstreams |
| A6 | | | | AC-36: All template references in both Matrix Tables use current kebab-case filenames |

**Alignment check (mandatory at G1):**
- [x] Orphan conditions = 0 (every AC maps to an artifact A1-A6)
- [x] Orphan artifacts = 0 (every artifact has ≥1 AC)
- [x] Total: 6 artifacts, 36 acceptance conditions

---

## Execution Strategy

| Field | Value |
|-------|-------|
| Pattern | Pattern 1: Sequential Pipeline (A1 → A2 → A3 → A4 → A5 → A6) |
| Why this pattern | Templates have write-order dependencies: A1 (sequence-template) must exist before A3 (process.md) can reference it. A2 (eval) must be updated before A3 can describe the Validate phase accurately. A6 (process-map) references all other templates. |
| Why NOT simpler | Single-file edit would work per file, but ordering matters for cross-references. Sequential pipeline is already simple. |
| Agent config | Single agent (Opus orchestrator producing directly). GOVERN exception: governance templates are meta-artifacts, not workstream deliverables. |
| Git strategy | Single worktree branch `worktree-dsbv-template-alignment`. One commit per artifact or logical group. |
| Human gates | G1 (this DESIGN.md), G2 (SEQUENCE.md), G3 (Build complete), G4 (Validate) |
| EP validation | EP-01 (Brake Before Gas): DESIGN before Build. EP-09 (Decompose): 36 binary ACs. EP-10 (Define Done): every AC is PASS/FAIL testable. EP-14 (Script-First): run template-check.sh post-build. |
| Cost estimate | Single-agent Opus session. ~$3-5 total. No multi-agent needed. |
| Generator/Critic | max_iterations: 2, cost_cap: ~$0.04/iter. Circuit breaker: SEMANTIC errors escalate immediately (template content misalignment = misunderstanding, not formatting). |

---

## Dependencies

| Dependency | From | Status |
|------------|------|--------|
| SKILL.md v2.1 | `.claude/skills/dsbv/SKILL.md` | Ready (committed a8f2792) |
| context-packaging.md v1.7 | `.claude/skills/dsbv/references/context-packaging.md` | Ready |
| circuit-breaker-protocol.md v1.0 | `.claude/skills/dsbv/references/circuit-breaker-protocol.md` | Ready |
| phase-execution-guide.md | `.claude/skills/dsbv/references/phase-execution-guide.md` | Ready |
| Gate scripts (5) | `scripts/gate-*.sh`, `scripts/set-status-*.sh`, etc. | Ready |
| alpei-dsbv-process-map.md | `_genesis/frameworks/alpei-dsbv-process-map.md` | Ready (will be updated as A6) |

---

## Human Gates

| Gate | Trigger | Decision Required |
|------|---------|-------------------|
| G1 | Design complete | Approve this DESIGN.md to proceed to SEQUENCE |
| G2 | Sequence complete | Approve task ordering and sizing |
| G3 | Build complete | Approve all 6 artifacts meet 36 acceptance conditions |
| G4 | Validate complete | Approve template alignment; merge worktree |

---

## Readiness Conditions (Criterion 1-6)

| ID | Condition | Status |
|----|-----------|--------|
| Criterion 1 | Clear scope — in/out written down | **GREEN** — §Scope Check above |
| Criterion 2 | Input materials curated — reading list assembled | **GREEN** — §Dependencies above, all read |
| Criterion 3 | Success rubric defined — per-artifact criteria | **GREEN** — 36 ACs in §Artifact Inventory |
| Criterion 4 | Process definition loaded — dsbv-process.md in context | **GREEN** — loaded at session start |
| Criterion 5 | Prompt engineered — context fits effective window | **GREEN** — all source files read, gap analysis complete |
| Criterion 6 | Evaluation protocol defined — how Human reviews output | **GREEN** — single-agent review, G4 per-AC verification |

**All conditions GREEN.**

---

## Approval Log

| Date | Gate | Decision | Signal | Tier |
|------|------|----------|--------|------|
| | | | | |

---

## Links

- [[SKILL]]
- [[SEQUENCE]]
- [[VALIDATE]]
- [[dsbv-process]]
- [[design-template]]
- [[dsbv-eval-template]]
- [[dsbv-context-template]]
- [[alpei-dsbv-process-map]]
- [[context-packaging]]
- [[circuit-breaker-protocol]]
- [[phase-execution-guide]]
- [[versioning]]
- [[workstream]]
