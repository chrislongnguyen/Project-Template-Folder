---
name: learn-input
description: >
  Phase 0 interview — captures all foundational inputs before research begins.
  Asks 9 questions one-at-a-time (system name, EO, RACI, contracts, topic depth, research domains).
  Saves learn-input-{system-slug}.md used by /learn:research and /learn:structure.
  Use when starting a new learning pipeline for any system/subject.
argument-hint: [system-slug]
allowed-tools: Read, Write, Edit, Glob
---

# /learn:input — Learning Pipeline Interview

You are capturing all foundational inputs for a new learning subject.
Ask questions **one at a time, conversationally**. Wait for each answer before asking the next.

## Arguments

Optional: `{system-slug}` — if provided and `1-ALIGN/learning/input/learn-input-{system-slug}.md` exists, enter update mode.

---

## Pre-Checks

1. Read `1-ALIGN/learning/templates/learn-input-template.md` — this is the output format.
2. If system-slug provided, check if `1-ALIGN/learning/input/learn-input-{system-slug}.md` already exists.
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

1. Source — who/what provides the input?
2. Schema — what shape is the data? (describe the structure)
3. Validation — what rules must the input satisfy?
4. Error — what happens when input is bad or missing?
5. SLA — availability/latency expectations from upstream?
6. Version — what version of this contract? (start with v1.0)

Example:
  Source: "User interview + domain documents"
  Schema: "Unstructured text — interview transcripts, PDF/markdown docs"
  Validation: "At least 1 source document provided; EO stated"
  Error: "If no sources → abort with message; if EO missing → re-prompt"
  SLA: "Available at session start; no latency constraint"
  Version: "v1.0"
```

### Q7: Output Contract

```
What does this system produce for downstream? Same 6 fields:

1. Consumer — who/what consumes the output?
2. Schema — what shape is the output?
3. Validation — what rules does the output guarantee?
4. Error — what happens when output can't be produced?
5. SLA — availability/latency promises?
6. Version — contract version?

Example:
  Consumer: "Build Engine — consumes VANA-SPEC for implementation"
  Schema: "VANA-SPEC markdown — Verb/Adverb/Noun/Adjective sections with binary A.C. tables"
  Validation: "All A.C.s are binary (pass/fail); every Verb has at least 1 A.C. per S/E/Sc pillar"
  Error: "If structuring fails → return partial with error flags; human reviews before handoff"
  SLA: "Output within 30 min of /learn:structure completion"
  Version: "v1.0"
```

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

1. Read `1-ALIGN/learning/templates/learn-input-template.md`.
2. Fill all `{placeholder}` fields with User responses.
3. Set topic depth: remove inactive topic rows based on selected depth.
   - T0: keep only T0 row.
   - T0-T2: keep T0, T1, T2 rows.
   - T0-T5: keep all 6 rows.
4. Set all active topic Status to `Pending`.
5. Replace `{date}` with today's date.
6. Save to `1-ALIGN/learning/input/learn-input-{system-slug}.md`.
7. If file already existed (update mode): use Edit tool to update changed fields only.

---

## Completion Report

```
Learn input captured for: {system_name}
Saved to: 1-ALIGN/learning/input/learn-input-{system-slug}.md
Topic depth: {depth} ({N} topics, {N*6} pages)
Research domains: {count}

Next step: /learn:research {system-slug}
```

---

## Rules

- Do NOT ask all 9 questions at once — one at a time, conversationally
- Do NOT skip the examples — non-tech users need them
- Do NOT generate research or Effective Learning pages — this command captures input only
- Do NOT overwrite an existing file without announcing update mode first
