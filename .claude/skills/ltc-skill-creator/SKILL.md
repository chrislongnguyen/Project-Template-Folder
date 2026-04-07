---
version: "1.0"
status: draft
last_updated: 2026-04-07
name: ltc-skill-creator
description: "Create a new skill following LTC EOP governance standards. Use when
  formalizing a repeated pattern into a reusable skill, adding a new capability,
  or packaging a workflow for reuse. Runs skill-validator.sh before human approval."
disable-model-invocation: true
---
# LTC Skill Creator

Creates new skills that conform to LTC EOP governance standards (8 principles).
Every skill must pass `skill-validator.sh` before it ships.

## When to Use

- User wants to add a new capability to the agent system
- User wants to formalize a repeated pattern into a reusable skill
- User wants to package an existing workflow for reuse across sessions
- User runs `/skill-creator`

## Meta-Rules

> Load `_genesis/reference/ltc-eop-gov.md` before proceeding. It contains the 8 EOP principles,
> the validator cross-reference, and the diagnostic table. All decisions in this skill
> trace back to that codex.

## Steps

1. **Name & Scope** the skill
   Reference: [references/creation-procedure.md](references/creation-procedure.md) (Steps 1-2)

2. **Choose Tier** — SIMPLE (body 40 lines or fewer) or STANDARD (41-200 lines)
   Reference: [references/creation-procedure.md](references/creation-procedure.md) (Step 3)

3. **Create directory structure** and write SKILL.md
   Templates: [templates/simple.md](templates/simple.md) | [templates/standard.md](templates/standard.md)
   Reference: [references/creation-procedure.md](references/creation-procedure.md) (Steps 4-5)

4. **Write gotchas.md** — minimum 1 entry from testing the skill
   Reference: [references/creation-procedure.md](references/creation-procedure.md) (Step 6)

5. **GATE:** Run `./scripts/skill-validator.sh {skill-dir}/` on the new skill.
   Must score 7+/8. Fix any HARD FAIL or 3+ WARNs before continuing.
   If validator is missing or broken: stop and tell the user.

6. **Present to user** for approval. Show: directory tree, SKILL.md content, validator output.
   Do NOT commit until the user says "Approved" or equivalent.

7. **Commit** the new skill with message: `feat(workstream): add {skill-name} skill`

## Constraints

- No skill ships without passing `skill-validator.sh` (EOP-01 through EOP-08)
- SKILL.md body must stay at or under 200 lines (EOP-05)
- Description is a trigger, not a summary (EOP-04)
- Gotchas are mandatory for all tiers (EOP-03)
- MECE check against sibling skills before committing — no trigger collisions

## Escape Hatch

If `skill-validator.sh` is missing or returns unexpected errors: manually verify the 8 EOP
checks from `_genesis/reference/ltc-eop-gov.md` Part 1 Quick Reference Table. Report to user
that automated validation was unavailable and list which checks were verified manually.

## Gotchas

See [gotchas.md](gotchas.md) for known failure patterns when creating skills.

## Anti-Patterns

See [references/anti-patterns.md](references/anti-patterns.md) for the 6 skill anti-patterns to avoid.

## Related Skills

- **/dsbv** — if the skill is part of a workstream artifact, run DSBV first to establish design context
- **/feedback** — if the skill idea came from user frustration, capture it as feedback too

## Links

- [[DESIGN]]
- [[anti-patterns]]
- [[creation-procedure]]
- [[dsbv]]
- [[gotchas]]
- [[idea]]
- [[ltc-eop-gov]]
- [[simple]]
- [[standard]]
- [[workstream]]
