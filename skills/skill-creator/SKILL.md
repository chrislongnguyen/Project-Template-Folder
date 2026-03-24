---
name: skill-creator
description: Meta-skill for creating new ILE-compatible skills. This skill should be used when the User wants to add a new capability to the engine or formalize a repeated pattern into a reusable skill. Enforces YAML frontmatter, references/ structure, .cursor mirror, and engine registration.
disable-model-invocation: true
---

# Skill Creator — ILE Skill Factory

Creates new skills that conform to the LTC engine pattern. Every skill must integrate with the ILE learning system or the 2-State engine. Not for generic skills.

## When to Use

- User wants to add a new capability to the engine
- User wants to formalize a repeated pattern into a reusable skill
- User wants to package an existing workflow for reuse across sessions

## Procedure

**Reference:** [references/skill-template.md](references/skill-template.md)

## Rules

- Every new skill MUST have YAML frontmatter with `name` and `description`
- Every new skill MUST have a `SKILL.md` entry point
- Reference docs go in `references/`; shell scripts in `scripts/` (only if needed)
- After creating in `engine/skills/{name}/`, mirror to `.cursor/skills/{name}/`
- Register the new skill in `engine/SKILL.md` command table if it has a slash command
- Register new command in `engine/commands/{name}.md` if a slash command is desired
- Present the new skill to the User for approval before committing
- Check MECE against existing skills — no overlap with learn-build-cycle, root-cause-tracing, kaizen, or brainstorming

## Related Skills

- **kaizen** (`engine/skills/kaizen/SKILL.md`) — if the new skill addresses a recurring failure, kaizen should have diagnosed it first
