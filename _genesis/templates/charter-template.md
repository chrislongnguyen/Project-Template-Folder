---
version: "1.2"
status: draft
last_updated: 2026-04-09
owner: ""
type: template
work_stream: 1-ALIGN
stage: design
sub_system: 
---
# CHARTER TEMPLATE (T1)
> Stub template — populate during ALIGN Design and Build stages.
> Cell(s) enabled: 1-ALIGN × Design, 1-ALIGN × Build
> Gap justification: DESIGN_TEMPLATE structures a DSBV stage; no existing template produces a project charter (EO, stakeholders, scope, success criteria).

<!-- TODO: Fill in during ALIGN Design stage -->

## Project Identity

| Field | Value |
|-------|-------|
| Project name | _[name]_ |
| Scope code (UNG) | _[SCOPE_FA.ID.NAME]_ |
| Owner | _[name]_ |
| Iteration | _[Iteration 0 / Iteration 1 / Iteration 2 / Iteration 3 / Iteration 4]_ |
| Last reviewed | _[YYYY-MM-DD]_ |

## Expected Outcome (EO)

> One paragraph: what success looks like. Be specific enough that a new team member could verify it.

_[Describe the expected outcome here.]_

## Stakeholders

| Role | Name | Involvement |
|------|------|-------------|
| Sponsor | _[name]_ | _[decision authority / funding]_ |
| PM | _[name]_ | _[day-to-day ownership]_ |
| Consumer | _[name or group]_ | _[who uses the output]_ |

## Scope

### In Scope

- _[item 1]_
- _[item 2]_

### Out of Scope

- _[item 1]_
- _[item 2]_

## VANA Criteria

> VANA = Verb + Adverb + Noun + Adjective. Decomposes every requirement into what the system does, how well, to what, and with what quality. Ref: `_genesis/frameworks/ltc-ues-versioning.md`

| Criterion | Prompt | Example |
|-----------|--------|---------|
| **V** (Verb) | _[What does the system do? Action verb.]_ | "Ingest", "Route", "Validate" |
| **A** (Adverb) | _[How effectively? Measurable qualifier.]_ | "within 2s", "with ≥95% accuracy" |
| **N** (Noun) | _[What does it act on? Input/object.]_ | "bank statements", "task records" |
| **A** (Adjective) | _[Quality attributes of the output.]_ | "auditable", "idempotent", "branded" |

## Design Principles

> Populated from `2-LEARN/output/[SUBSYSTEM]-EFFECTIVE-PRINCIPLES.md` during LEARN Build.

- _[Principle 1 — cite LEARN finding]_
- _[Principle 2 — cite LEARN finding]_

## Approval

| Gate | Approver | Date | Status |
|------|----------|------|--------|
| G1 (Design) | _[name]_ | _[YYYY-MM-DD]_ | Draft |
| G3 (Build final) | _[name]_ | _[YYYY-MM-DD]_ | Draft |

## Links

- [[DESIGN]]
- [[VALIDATE]]
- [[charter]]
- [[iteration]]
- [[ltc-ues-versioning]]
- [[project]]
- [[task]]
