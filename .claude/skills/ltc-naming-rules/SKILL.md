---
name: ltc-naming-rules
description: >
  Use when creating, renaming, or validating LTC Universal Naming Grammar (UNG) keys for repos,
  folders, Drive paths, ClickUp PJ Projects/Deliverables, or any canonical asset name; when the
  user asks for UNG, SCOPE/FA codes, canonical key format, or whether a name complies with LTC
  rules. Does not replace WMS planner skills — use those for full ClickUp/Notion task hierarchies;
  use this skill whenever a name string must match UNG.
---

# LTC Naming Rules (UNG)

Routes agents to the canonical naming grammar so digital assets get valid SCOPE/FA segments,
correct 2-part vs 3-part form, and platform-appropriate rendering — without guessing SCOPE codes.

## When to Use

- Before creating a Git repo, top-level folder, PJ Project, PJ Deliverable, or governed Drive item
- When converting between **Canonical Key** and **ClickUp display** form (brackets, spaces)
- When the user pastes a name and asks “is this valid UNG?” or “what SCOPE is this?”
- When a proposed name fails length limits (e.g. Git **50** characters)

## Steps

1. **Load source of truth**
   Read [rules/naming-rules.md](../../../rules/naming-rules.md) from the repo root. Optional: [_genesis/security/naming-convention.md](../../../_genesis/security/naming-convention.md) for human-oriented prose.

2. **Pick form and compose**
   Reference: [references/forms-and-separators.md](references/forms-and-separators.md) — default **3-part** with parent; **2-part** only for true top-level items. Use **longest matching SCOPE** from Table 3a (`COE_EFF` before `COE`).

3. **Validate composition**
   Reference: [references/pre-creation-checklist.md](references/pre-creation-checklist.md) — regex check, Table 3a/3b lookup, Git length, collision handling.

4. **GATE:** Do **not** create or rename the asset until:
   - SCOPE appears in Table 3a and FA in Table 3b (unless the user is explicitly requesting a governance change — then **HALT** and escalate)
   - The key matches the appropriate regex for 2-part or 3-part
   - For Git repos: total length **≤ 50** after any allowed abbreviation rules in `rules/naming-rules.md`
   - You resolved or acknowledged name **collisions** (adjust NAME or ask the user — never duplicate silently)

5. **Render for target platform**
   Reference: [references/platform-rendering.md](references/platform-rendering.md) — Git vs filesystem vs ClickUp vs Drive.

6. **Respect exclusions**
   Items **not** governed by UNG (e.g. ClickUp tasks below Deliverable, learning book filenames) — do not force a prefix; follow the rules doc’s “Where UNG Applies” table.

## Constraints

- **Never** derive SCOPE by algorithm alone — irregular mappings (e.g. `[INV TECH]` → `INVTECH`) come only from the collapse rules and Table 3a.
- **Abbreviation order for Git over 50 chars:** shorten NAME words first, then ORG segment — **never** abbreviate SCOPE, FA, or ID (`rules/naming-rules.md` §3).

## Escape Hatch

If `rules/naming-rules.md` is missing: **do not invent SCOPE or FA codes.** Stop and ask the user for the correct scope or restore the rules file. You may still explain the **shape** of 2-part vs 3-part keys at a high level.

## Gotchas

See [gotchas.md](gotchas.md) for known failure patterns.

## Links

- [[naming-convention]]
- [[VALIDATE]]
- [[deliverable]]
- [[forms-and-separators]]
- [[gotchas]]
- [[naming-rules]]
- [[platform-rendering]]
- [[pre-creation-checklist]]
- [[project]]
- [[security]]
- [[task]]
