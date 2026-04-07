# Gotchas — LTC Skill Creator

1. **Stale path references** — Old skills reference `engine/`, `.cursor/` which no longer exist in the template. Always use current path: `.claude/skills/` (the only valid skill location). Check the actual repo structure before writing any path.

2. **Description as summary** — Developers write "Manages X" or "Helps with Y" instead of "Use when Y happens." The description field is a trigger condition, not a summary. The validator catches this (CHECK-04), but the real fix is to write trigger-first from the start.

3. **Forgotten gotchas** — Skill ships without gotchas.md. The validator catches this (CHECK-05), but the fix is to TEST the skill once — even a mental walkthrough — and write down what went wrong or what was confusing. If nothing went wrong, write down what COULD go wrong.

4. **Trigger collision** — New skill overlaps with an existing one. Both activate on the same user request, wasting context. Always run MECE check against sibling skills in the same directory before committing. If overlap exists, either merge or make descriptions mutually exclusive.

## Links

- [[CLAUDE]]
- [[SKILL]]
- [[workstream]]
