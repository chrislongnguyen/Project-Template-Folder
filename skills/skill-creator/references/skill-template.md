# Skill Creation Procedure

Follow these steps in order. Do not skip steps unless explicitly noted.

## Step 1: Name the Skill

- Use kebab-case (e.g., `root-cause-tracing`, not `rct` or `rootCauseTracing`)
- Name must describe the capability, not the implementation
- Check `engine/skills/` for existing skills — no duplicates or overlaps

## Step 2: Define Scope

Answer these questions before writing anything:
1. What ILE or engine capability does this skill provide?
2. When should the Agent activate it? (trigger conditions)
3. What does it NOT do? (explicit boundaries)
4. Does it overlap with existing skills? If so, how is it different?

## Step 3: Create the File Structure

```
engine/skills/{skill-name}/
├── SKILL.md              (required)
└── references/            (optional — one .md per procedure or checklist)
    ├── {procedure-1}.md
    └── {procedure-2}.md
```

Only add `scripts/` if the skill needs shell automation (rare for learning-system skills).

## Step 4: Write SKILL.md

Follow this template:

```markdown
---
name: {skill-name}
description: {What this skill does and when to use it. Use third-person: "This skill should be used when..."}
---

# {Skill Title}

{1-2 sentence purpose statement.}

## When to Use
- {Trigger condition 1}
- {Trigger condition 2}
- User runs `/{command}` (if applicable)

## Procedure
**Reference:** [references/{procedure}.md](references/{procedure}.md)

## Rules
- {Skill-specific rule 1}
- {Skill-specific rule 2}

## Related Skills
- **{skill-name}** (`engine/skills/{name}/SKILL.md`) — {when to use instead or together}
```

## Step 5: Write Reference Docs

- One `.md` per procedure or checklist
- Reference docs are loaded on-demand (not all at once) to conserve context
- Keep SKILL.md lean; put detailed procedures in references/
- If a reference file exceeds 500 lines, split it

## Step 6: Create IDE Mirrors

Copy the entire `engine/skills/{name}/` directory to both IDE skill paths:

```bash
cp -r engine/skills/{name} .claude/skills/{name}
cp -r engine/skills/{name} .cursor/skills/{name}
```

`.claude/skills/` is required for Claude Code discovery. `.cursor/skills/` is for Cursor backup.

## Step 7: Register (if slash command needed)

1. Create `engine/commands/{command}.md` following the existing pattern (see `engine/commands/debug.md` as example)
2. Add a row to `engine/SKILL.md` command table
3. Add a row to `engine/commands/help.md` decision tree

## Step 8: Verify

- [ ] SKILL.md has valid YAML frontmatter (name + description)
- [ ] All relative links in SKILL.md resolve to existing files
- [ ] `.claude/skills/{name}/` mirrors `engine/skills/{name}/` (Claude Code)
- [ ] `.cursor/skills/{name}/` mirrors `engine/skills/{name}/` (Cursor backup)
- [ ] engine/SKILL.md updated (if slash command)
- [ ] engine/commands/help.md updated (if slash command)
- [ ] No overlap with existing skills (MECE)

## Step 9: Present to User

Show the skill structure and content. Wait for "Approved" before committing.
