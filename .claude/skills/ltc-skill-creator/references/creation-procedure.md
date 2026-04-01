---
version: "1.0"
last_updated: 2026-03-30
---
# Skill Creation Procedure

Follow these steps in order. Do not skip steps unless explicitly noted.

## Step 1: Name the Skill

- Use kebab-case (e.g., `root-cause-tracing`, not `rct` or `rootCauseTracing`)
- Name must describe the capability, not the implementation
- Prefix with `ltc-` only for skills that customize a generic pattern (e.g., `ltc-writing-plans`)

## Step 2: Define Scope

Answer these questions before writing anything:

1. **What** does this skill do? (1 sentence)
2. **When** should the agent activate it? (trigger conditions — action verbs + scenarios)
3. **What NOT** — explicit boundaries (what this skill does not handle)
4. **Overlap check** — run MECE against sibling skills in the same location:
   - List existing skills in the target directory
   - For each, compare trigger conditions
   - If overlap exists: either merge into the existing skill or make descriptions mutually exclusive

## Step 3: Choose Tier

| Tier | Body Lines | Structure | When to Use |
|------|-----------|-----------|-------------|
| SIMPLE | 40 or fewer | SKILL.md + gotchas.md | Single-purpose, few steps, no branching |
| STANDARD | 41-200 | SKILL.md + references/ + templates/ + gotchas.md | Multi-step procedures, gates, reference material |

If unsure, start SIMPLE. Upgrade to STANDARD when SKILL.md exceeds 40 lines.

## Step 4: Create Directory Structure

```
{location}/skills/{name}/
├── SKILL.md              (required — all tiers)
├── gotchas.md            (required — all tiers)
├── references/           (STANDARD tier — procedures, checklists)
│   └── {procedure}.md
└── templates/            (optional — if skill produces templated output)
    └── {template}.md
```

**Location guidance:**

| Skill Type | Location | Example |
|-----------|----------|---------|
| Workstream-specific | `{N}-{WORKSTREAM}/skills/{name}/` | `5-IMPROVE/skills/feedback/` |
| Agent governance | `.claude/skills/{name}/` | `.claude/skills/ltc-skill-creator/` |
| Cross-project shared | `_genesis/skills/{name}/` | `_genesis/skills/common-lint/` |

## Step 5: Write SKILL.md

Use the appropriate tier template:

- **SIMPLE tier:** Use [templates/simple.md](../templates/simple.md)
- **STANDARD tier:** Use [templates/standard.md](../templates/standard.md)

Key rules when writing:

- **Description is a trigger** (EOP-04) — write "Use when X" or "Create Y when Z", not "Manages X"
- **Description must be 50+ characters** (CHECK-03)
- **Don't state the obvious** (EOP-07) — skip anything the agent already knows from training
- **Keep body under 200 lines** (EOP-05) — extract detail into references/

## Step 6: Write gotchas.md

Required for ALL tiers. Minimum 1 entry.

How to generate entries:

1. Test the skill once (even mentally) — what could go wrong?
2. Check the anti-patterns list: [references/anti-patterns.md](anti-patterns.md)
3. Write each gotcha as: what went wrong, why, and the correct approach

Format:
```markdown
# Gotchas — {Skill Name}

1. **{Short label}** — {What goes wrong}. {Why}. {Correct approach}.
```

## Step 7: Run Validator

```bash
./scripts/skill-validator.sh {skill-dir}/
```

**Pass criteria:** Score 7+/8. No HARD FAILs. Fewer than 3 WARNs.

**If validator fails:**
- HARD FAIL on CHECK-01/02/03 → structural issue, fix the file
- WARN on CHECK-04 → rewrite description with trigger language
- WARN on CHECK-05 → add gotchas.md (you should already have it from Step 6)
- WARN on CHECK-06 → add references/ or templates/ directory (STANDARD tier)
- WARN on CHECK-07 → add GATE keyword between critical steps
- WARN on CHECK-08 → extract content from SKILL.md into references/

## Step 8: Present to User

Show the user:
1. Directory tree of the new skill
2. Full content of SKILL.md
3. Validator output (must show 7+/8 passing)

Wait for explicit approval before committing.

## Step 9: Commit

```
feat({workstream}): add {skill-name} skill
```

Where `{workstream}` is the APEI workstream the skill belongs to (e.g., `align`, `improve`, `agent`).

## Links

- [[CLAUDE]]
- [[SKILL]]
- [[anti-patterns]]
- [[gotchas]]
- [[simple]]
- [[standard]]
- [[workstream]]
