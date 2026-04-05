---
version: "1.0"
status: draft
last_updated: 2026-04-02
workstream: ALIGN
owner: "{{OWNER}}"
---
# ADR Register — ALIGN Workstream

> Architecture Decision Records track non-trivial decisions with multiple viable options.
> Source template: `_genesis/templates/adr-template.md`

---

## Purpose

Every decision with multiple viable options produces an ADR in this directory. ADRs document the **why** behind choices — not just the what. They serve as institutional memory for future team members and AI agents.

## When to Create an ADR

- Architecture or design choices with ≥2 viable alternatives
- Technology selection decisions
- Process or convention changes that affect multiple workstreams
- Scope decisions that trade off one objective against another

## ADR Table

| ID | Title | Status | Date | Decision Summary |
|----|-------|--------|------|-----------------|
| _[ADR-001]_ | _[Decision title]_ | _[Proposed / Accepted / Deprecated / Superseded]_ | _[YYYY-MM-DD]_ | _[One-line summary of the decision]_ |

<!-- TODO: Add rows as decisions are made during the project lifecycle -->

## ADR File Convention

- **Filename:** `ADR-{NNN}-{short-slug}.md` (e.g., `ADR-001-database-selection.md`)
- **Template:** Use `_genesis/templates/adr-template.md` for each individual ADR
- **Location:** `1-ALIGN/decisions/`
- **Archive:** Deprecated or superseded ADRs move to `1-ALIGN/decisions/archive/`

## Three Pillars Evaluation

Each ADR should evaluate options against the Three Pillars of Effectiveness:

| Pillar | Question |
|--------|----------|
| Sustainability | Is this decision safe and correct? Can the team maintain it? |
| Efficiency | Does this decision improve productivity with current resources? |
| Scalability | Does this decision scale as resources and scope grow? |