---
version: "1.0"
status: draft
last_updated: 2026-04-02
workstream: PLAN
iteration: "{{ITERATION}}"
owner: "{{OWNER}}"
---
# DESIGN.md — PLAN Workstream, {{ITERATION}}

> DSBV Phase 1 artifact. This document is the contract. If it is not here, it is not in scope.
> Source template: `_genesis/templates/design-template.md`

---

## Scope Check

Answer before proceeding to DESIGN content.

| Question | Answer |
|----------|--------|
| Q1: Are upstream workstream outputs sufficient? (C1-C6 readiness) | YES / NO — _detail_ |
| Q2: What is in scope for this workstream-iteration? | _list_ |
| Q2b: What is explicitly OUT of scope? | _list_ |
| Q3: Go/No-Go — proceed? | GO / NO-GO |

> If any answer is NO → return to upstream workstream. Do not design on shaky inputs.

---

## Design Decisions

High-level intent stated by Human Director (1-3 sentences). Agent expands below.

**Intent:** _Human states what this workstream must produce and why._

**Key constraints:**
- _constraint 1_
- _constraint 2_

---

## Artifact Inventory

Unified artifact-condition table. Every artifact has at least one condition. Every condition maps to an artifact.

| # | Artifact | Path | Purpose (WHY) | Acceptance Conditions |
|---|----------|------|---------------|-----------------------|
| A1 | _artifact name_ | _path_ | _why this artifact exists_ | AC-1: _condition_ |
| A2 | | | | AC-2: _condition_ |

**Alignment check (mandatory at G1):**
- [ ] Orphan conditions = 0 (every condition maps to a named artifact)
- [ ] Orphan artifacts = 0 or justified (every artifact has at least one condition)
- [ ] Artifact count here = deliverable count in SEQUENCE.md

---

## Execution Strategy

| Field | Value |
|-------|-------|
| Pattern | _Pattern # + name from 9-pattern catalog_ |
| Why this pattern | _Which LT risks does it compensate?_ |
| Why NOT simpler | _What fails with single agent / sequential?_ |
| Agent config | _How many agents, which models, roles, handoff protocol_ |
| Git strategy | _Branches, worktrees, merge plan_ |
| Human gates | _Which decisions pause for human approval_ |
| EP validation | _How EP-01, EP-03, EP-04, EP-09 are satisfied_ |
| Cost estimate | _Expected token/$ spend_ |

---

## Dependencies

| Dependency | From Workstream/Artifact | Status |
|------------|-------------------|--------|
| _dependency_ | _source_ | Ready / Pending |

---

## Human Gates

| Gate | Trigger | Decision Required |
|------|---------|-------------------|
| G1 | Design complete | Approve DESIGN.md to proceed to SEQUENCE |
| G2 | Sequence complete | Approve task ordering and sizing |
| G3 | Build complete | Approve all artifacts meet acceptance criteria |
| G4 | Validate complete | Approve workstream output; advance to next workstream |

Additional workstream-specific gates:
- _gate description_

---

## Readiness Conditions (C1-C6)

| ID | Condition | Status |
|----|-----------|--------|
| C1 | Clear scope — in/out written down | GREEN / RED |
| C2 | Input materials curated — reading list assembled | GREEN / RED |
| C3 | Success rubric defined — per-artifact criteria | GREEN / RED |
| C4 | Process definition loaded — dsbv-process.md in context | GREEN / RED |
| C5 | Prompt engineered — context fits effective window | GREEN / RED |
| C6 | Evaluation protocol defined — how Human reviews output | GREEN / RED |

**All conditions must be GREEN before G1.**