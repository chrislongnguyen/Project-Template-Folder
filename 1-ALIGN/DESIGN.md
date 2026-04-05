---
version: "1.0"
status: draft
last_updated: 2026-04-02
workstream: ALIGN
iteration: "{{ITERATION}}"
owner: "{{OWNER}}"
---
# DESIGN.md — ALIGN Workstream, {{ITERATION}}

> DSBV Phase 1 artifact. This document is the contract. If it is not here, it is not in scope.
> Source template: `_genesis/templates/design-template.md`

---

## Scope Check

Answer before proceeding to DESIGN content.

| Question | Answer |
|----------|--------|
| Q1: Are upstream workstream outputs sufficient? (C1-C6 readiness) | <!-- YES / NO — detail --> |
| Q2: What is in scope for this workstream-iteration? | <!-- list --> |
| Q2b: What is explicitly OUT of scope? | <!-- list --> |
| Q3: Go/No-Go — proceed? | <!-- GO / NO-GO --> |

> If any answer is NO → return to upstream workstream. Do not design on shaky inputs.

---

## Design Decisions

High-level intent stated by Human Director (1-3 sentences). Agent expands below.

**Intent:** <!-- Human states what this workstream must produce and why. -->

**Key constraints:**
- <!-- constraint 1 -->
- <!-- constraint 2 -->

---

## Artifact Inventory

Unified artifact-condition table. Every artifact has at least one condition. Every condition maps to an artifact.

| # | Artifact | Path | Purpose (WHY) | Acceptance Conditions |
|---|----------|------|---------------|-----------------------|
| A1 | <!-- artifact name --> | <!-- path --> | <!-- why this artifact exists --> | AC-1: <!-- condition --> |
| A2 | | | | AC-2: <!-- condition --> |

**Alignment check (mandatory at G1):**
- [ ] Orphan conditions = 0 (every condition maps to a named artifact)
- [ ] Orphan artifacts = 0 or justified (every artifact has at least one condition)
- [ ] Artifact count here = deliverable count in SEQUENCE.md

---

## Execution Strategy

| Field | Value |
|-------|-------|
| Pattern | <!-- Pattern # + name from 9-pattern catalog --> |
| Why this pattern | <!-- Which LT risks does it compensate? --> |
| Why NOT simpler | <!-- What fails with single agent / sequential? --> |
| Agent config | <!-- How many agents, which models, roles, handoff protocol --> |
| Git strategy | <!-- Branches, worktrees, merge plan --> |
| Human gates | <!-- Which decisions pause for human approval --> |
| EP validation | <!-- How EP-01, EP-03, EP-04, EP-09 are satisfied --> |
| Cost estimate | <!-- Expected token/$ spend --> |

---

## Dependencies

| Dependency | From Workstream/Artifact | Status |
|------------|-------------------|--------|
| <!-- dependency --> | <!-- source --> | <!-- Ready / Pending --> |

---

## Human Gates

| Gate | Trigger | Decision Required |
|------|---------|-------------------|
| G1 | Design complete | Approve DESIGN.md to proceed to SEQUENCE |
| G2 | Sequence complete | Approve task ordering and sizing |
| G3 | Build complete | Approve all artifacts meet acceptance criteria |
| G4 | Validate complete | Approve workstream output; advance to next workstream |

Additional workstream-specific gates:
- <!-- gate description -->

---

## Readiness Conditions (C1-C6)

| ID | Condition | Status |
|----|-----------|--------|
| C1 | Clear scope — in/out written down | <!-- GREEN / RED --> |
| C2 | Input materials curated — reading list assembled | <!-- GREEN / RED --> |
| C3 | Success rubric defined — per-artifact criteria | <!-- GREEN / RED --> |
| C4 | Process definition loaded — dsbv-process.md in context | <!-- GREEN / RED --> |
| C5 | Prompt engineered — context fits effective window | <!-- GREEN / RED --> |
| C6 | Evaluation protocol defined — how Human reviews output | <!-- GREEN / RED --> |

**All conditions must be GREEN before G1.**