# Standard Skill Template

Use for skills with 41-200 body lines. Copy and fill in the placeholders.

```markdown
---
name: {skill-name}
description: "{Detailed trigger description with action verbs, scenarios, and
  explicit exclusions. 50+ chars. Think: when should Claude activate this?}"
---

# {Skill Title}

{1-2 sentence purpose.}

## When to Use

- {Trigger condition 1}
- {Trigger condition 2}
- User runs `/{command}`

## Steps

1. **{Step name}**
   Reference: [references/{detail}.md](references/{detail}.md)

2. **{Step name}**
   ...

3. **GATE:** {Verification condition. Do NOT proceed until this passes.}

4. **{Step name}**
   ...

## Constraints

- {Rule 1}
- {Rule 2}

## Escape Hatch

If {failure condition}: {fallback action}.

## Gotchas

See [gotchas.md](gotchas.md) for known failure patterns.
```

## Checklist

- [ ] `name` is kebab-case and describes the capability
- [ ] `description` is 50+ characters with trigger language
- [ ] At least one GATE keyword between critical steps
- [ ] `references/` directory exists with at least one detail file
- [ ] `gotchas.md` exists with at least 1 entry
- [ ] Body is under 200 lines
- [ ] Escape hatch defined for steps that can fail
- [ ] MECE check done against sibling skills
