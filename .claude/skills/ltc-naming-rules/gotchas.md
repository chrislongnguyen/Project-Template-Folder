# Gotchas — ltc-naming-rules

1. **Shortest SCOPE wins (wrong)** — Matching `COE` before `COE_EFF` produces invalid keys. Always try the **longest** matching SCOPE from Table 3a first (`rules/naming-rules.md`).

2. **UNG on every ClickUp line** — Tasks, increments, and documentation under a deliverable are **free text** with no UNG prefix. Only PJ Project and PJ Deliverable use the full grammar; forcing UNG on task titles breaks team norms.

3. **Git 50-character wall** — Repos over 50 chars need planned abbreviation of NAME tokens (and possibly org wording), never truncation of SCOPE/FA/ID. Skipping this yields rejected or inconsistent repo names.

4. **Invented SCOPE when rules file is missing** — Guessing `OPS` vs `OPERATIONS` or inventing a new code creates non-portable keys. If Table 3a is unavailable, **HALT** and get confirmation from the user instead of fabricating codes.

5. **Collision silence** — Creating a second repo or folder with the same canonical key as an existing asset breaks search and governance. Detect collisions on the target system; if unclear, ask rather than duplicate.

## Links

- [[deliverable]]
- [[documentation]]
- [[naming-rules]]
- [[project]]
- [[task]]
