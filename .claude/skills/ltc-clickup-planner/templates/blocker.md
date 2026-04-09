# PJ Blocker — Template

Parent: Task (sibling of PJ Increments and PJ Documentation). Created reactively by agent or user.

## Custom Fields

### 🌐 RISK-BASED IMPORTANCE (MoSCoW) — field `1da92ea7-e200-4d60-84d8-e8b6148ba7dd` (dropdown)
`Must Have` (blockers always block parent completion)

### 🌐 BLOCKER(S) — field `62738883-ccff-4b3b-a8be-e41e560f28e5`
```
What is blocked and why. Keep concise.
```

### 🌐 SOLUTION FOR BLOCKER — field `ce1cbe61-1849-4662-ae50-314649f4e442`
```
Proposed resolution (if known). Updated when resolved.
```

---

## Description (native field)

```markdown
## Context
{Brief context — what was being done when the blocker was hit}

## Evidence
{Links, error messages, screenshots, or references}
```

## Lifecycle

1. Agent or user discovers blocker → create PJ Blocker under the blocked Task
2. Set status `blocked`, priority matches or exceeds parent
3. Fill BLOCKER(S) field — what + why
4. Fill SOLUTION FOR BLOCKER — proposed resolution (or "unknown — needs investigation")
5. When resolved → status `done`, add resolution comment
6. Parent Task can now proceed to completion

Note: PJ Blocker does NOT require DESIRED OUTCOMES or ACCEPTANCE CRITERIA custom fields.

## Links

- [[documentation]]
- [[task]]
