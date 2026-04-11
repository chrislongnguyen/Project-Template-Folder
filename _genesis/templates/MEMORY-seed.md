# Session Memory — {PROJECT_NAME}

## Agent Instructions

This memory uses a tiered design. Briefing Card = always-loaded. Topic Index = on-demand.

**Rules for ALL agents touching this file:**
- NEVER write content directly into MEMORY.md — add/update topic files, then update the index
- NEVER save derivable info (repo paths, file structure, git history, code patterns, API IDs discoverable at runtime)
- UPDATE topic files after any major state change (milestone, blocker, pivot)
- Keep this index under 60 lines — if approaching limit, consolidate topic files
- Each topic file must have frontmatter: name, description, type (user | project | reference | feedback)
- When a topic file becomes fully obsolete, remove from index and delete the file

## Briefing Card

**Identity:** {MEMBER_NAME} ({ORG_ROLE}) | {TITLE}
**Subject:** {PROJECT_DESCRIPTION}
**EO:** {EXPECTED_OUTCOME}

**Current state ({DATE}):** Project memory initialized. No sessions recorded yet.
**Charter:** `1-ALIGN/1-PD/`
**WMS:** Notion is authoritative. ClickUp is secondary.
**Active work:** Initial setup — run `/resume` at the start of each session to load context.

## Topic Index

- [user_role.md](user_role.md) — Who you are, your role, preferences, and how the agent should tailor its work
- [learned_patterns.md](learned_patterns.md) — Recurring patterns discovered during execution (APEI IMPROVE workstream)
- [key_decisions.md](key_decisions.md) — Architecture Decision Records and rationale (APEI ALIGN workstream)
- [common_pitfalls.md](common_pitfalls.md) — UBS entries that materialized during execution (APEI PLAN workstream)

## Links

- [[AGENTS]]
- [[DESIGN]]
- [[architecture]]
- [[blocker]]
- [[charter]]
- [[common_pitfalls]]
- [[key_decisions]]
- [[learned_patterns]]
- [[project]]
- [[user_role]]
- [[workstream]]
