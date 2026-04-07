---
version: "1.2"
status: draft
last_updated: 2026-04-07
name: learn-input
description: >
  Use when starting a new learning pipeline for any system or subject.
  Conducts a 9-question interview one-at-a-time (system name, EO, RACI, contracts,
  topic depth, research domains). Saves learn-input-{system-slug}.md used by
  /learn:research and /learn:structure.
argument-hint: [system-slug]
allowed-tools: Read, Write, Edit, Glob
---
# /learn:input — Learning Pipeline Interview

You are capturing all foundational inputs for a new learning subject.
Ask questions **one at a time, conversationally**. Wait for each answer before asking the next.

## Arguments

Optional: `{system-slug}` — if provided and `2-LEARN/_cross/input/learn-input-{system-slug}.md` exists, enter update mode.

<HARD-GATE>
1. Ask questions ONE AT A TIME. Never batch multiple questions in a single message.
2. Do NOT skip examples — non-technical users need them to understand what's expected.
3. Do NOT generate research or Effective Learning pages — this command captures input ONLY.
4. Do NOT overwrite an existing file without announcing update mode first.
</HARD-GATE>

---

## Pre-Checks

1. Read `_genesis/templates/learn-input-template.md` — this is the output format.
2. If system-slug provided, check if `2-LEARN/_cross/input/learn-input-{system-slug}.md` already exists.
   - If exists: load it, announce "Updating existing input for {system_name}. Current values shown as defaults — press Enter to keep or type new value."
   - If not: fresh interview.

---

## Interview (9 questions, one at a time)

### Q1: System Name

```
What system or subject are we learning about?

Example: "Data Foundation Layer", "Risk Management System", "Effective Thinking"
```

After answer: generate `system-slug` as kebab-case (lowercase, spaces to hyphens, strip special chars).
Example: "Data Foundation Layer" → `data-foundation-layer`

### Q2: Effective Outcome (EO)

```
What is the ultimate outcome this system should achieve?
Think: the state of the world when this system works perfectly — not a feature, not a tool, a state.

Example: "Every analyst can collect, clean, and manage data without manual error or tribal knowledge"
```

<HARD-GATE>
EO must contain three structural elements:
1. [User] — who benefits (a specific role, not "everyone")
2. [Desired state] — measurable end-state (not an activity)
3. [Constraint] — what must NOT happen or be compromised

If EO lacks any element, do NOT accept. Re-prompt with:
"Your EO needs [missing element]. Here's the pattern: [User] can [desired state] without [constraint]."

If the user struggles after 2 attempts, offer:
"Here are 3 EO patterns for {system_name} — pick one and customize:
1. [Role] can [achieve outcome] without [negative consequence]
2. [Role] understands [domain] well enough to [capability] without [dependency]
3. [Role] produces [artifact] that [quality standard] without [manual overhead]"
</HARD-GATE>

### Q3: Responsible Actor (R)

```
Who does the work in this system? Describe their role, context, capability level, and constraints.

Example: "AI Agent — operates within Claude Code, executes data pipeline tasks, current capability: can follow structured instructions but lacks domain-specific data quality heuristics"
```

### Q4: Accountable Actor (A)

```
Who owns the outcome? Describe their role, decision authority, and constraints.

Example: "Data Analyst — owns data quality decisions, reviews agent output at iteration gates, constrained by 2-hour daily capacity for review"
```

### Q5: Anti-Persona

```
Who is this system explicitly NOT for? Name specific characteristics that disqualify an actor.

Example: "NOT for: data engineers who already have production pipelines — this system targets analysts building their first data workflow"
```

### Q6: Input Contract

```
What does this system receive from upstream? I need 6 fields:
Source, Schema, Validation, Error, SLA, Version.
```

See `references/contract-examples.md` for a full example if needed.

### Q7: Output Contract

```
What does this system produce for downstream? Same 6 fields:
Consumer, Schema, Validation, Error, SLA, Version.
```

See `references/contract-examples.md` for a full example if needed.

### Q8: Topic Depth

```
How deep should we go? This determines research scope and page count.

- T0      — Overview only (1 topic, 6 pages). Good for: quick exploration, proof of concept.
- T0-T2   — Overview + Blockers + Drivers (3 topics, 18 pages). Good for: working prototype.
- T0-T5   — Full depth (6 topics, 36 pages). Good for: production system, comprehensive understanding.

Which depth? (T0 / T0-T2 / T0-T5)
```

### Q9: Research Domains

```
What key domains should we research for this system?
List 3-6 areas. These guide the research prompt — be specific to your system, not generic.

Example for Data Foundation Layer:
  1. "Data collection patterns — APIs, web scraping, manual entry, ETL pipelines"
  2. "Data quality frameworks — validation rules, anomaly detection, completeness checks"
  3. "Data management lifecycle — storage, versioning, retention, archival"
  4. "Data governance — access control, lineage tracking, compliance"
```

---

## Save Output

After all 9 questions are answered:

1. Read `_genesis/templates/learn-input-template.md`.
2. Fill all `{placeholder}` fields with User responses.
3. Set topic depth: remove inactive topic rows based on selected depth.
   - T0: keep only T0 row.
   - T0-T2: keep T0, T1, T2 rows.
   - T0-T5: keep all 6 rows.
4. Set all active topic Status to `Pending`.
5. Replace `{date}` with today's date.
6. Save to `2-LEARN/_cross/input/learn-input-{system-slug}.md`.
7. If file already existed (update mode): use Edit tool to update changed fields only.

---

## Completion Report

```
Learn input captured for: {system_name}
Saved to: 2-LEARN/_cross/input/learn-input-{system-slug}.md
Topic depth: {depth} ({N} topics, {N*6} pages)
Research domains: {count}

Next step: /learn:research {system-slug}
```

---

## Gotchas

- **Batching questions** — ONE question per message, always. Even if it feels slow, rich single answers > thin batch answers.
- **Accepting vague EO** — Apply the HARD-GATE: must have [User], [Desired state], [Constraint]. Push back if any are missing.
- **EO escape hatch** — After 2 failed EO attempts, offer 3 pattern examples. Don't let the user get stuck.
- **Overwriting without update mode** — if file exists, announce update mode and show defaults. Never silently replace.

Full list: [gotchas.md](gotchas.md)

## Rules

- Do NOT ask all 9 questions at once — one at a time, conversationally
- Do NOT skip the examples — non-tech users need them
- Do NOT generate research or Effective Learning pages — this command captures input only
- Do NOT overwrite an existing file without announcing update mode first

## Links

- [[CLAUDE]]
- [[contract-examples]]
- [[gotchas]]
- [[iteration]]
- [[standard]]
- [[versioning]]
