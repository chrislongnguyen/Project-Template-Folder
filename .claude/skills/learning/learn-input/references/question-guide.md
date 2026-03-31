# Learn Input Question Guide

Guidance for evaluating user answers during the /learn:input interview.

## Q2: EO — Common Mistakes

**Bad EO (too vague):** "Make data better" — no measurable outcome, no actor.
**Bad EO (feature list):** "Build a pipeline with validation and monitoring" — describes tools, not outcome.
**Good EO:** "Every analyst can collect, clean, and manage data without manual error or tribal knowledge" — describes a world-state.

## Q3/Q4: RACI — What Makes a Good Actor Description

Must include: role, context, capability level, constraints.
**Bad:** "AI Agent" — no context, no constraints.
**Good:** "AI Agent — operates within Claude Code, executes data pipeline tasks, current capability: can follow structured instructions but lacks domain-specific heuristics."

## Q6/Q7: Contracts — Completeness Check

All 6 fields required: source/consumer, schema, validation, error, SLA, version.
If user gives partial answers, prompt for missing fields specifically.

## Q8: Topic Depth — Guidance

| Depth | When to use |
|---|---|
| T0 | Quick exploration, proof of concept, single-system learning |
| T0-T2 | Working prototype, blockers + drivers analysis |
| T0-T5 | Production system, comprehensive understanding, multi-team use |

Default recommendation: T0 for first-time users, T0-T2 for experienced users.
