---
name: memory-format
description: Structural rules for auto-memory and AutoDream consolidation of MEMORY.md files
version: "1.0"
status: draft
last_updated: 2026-04-06
---

# Memory File Format Rules

When reading or writing to any `memory/MEMORY.md` file, preserve this exact 3-section structure:

## Required Sections (in order)

1. **## Agent Instructions** — Meta-rules governing how this file is maintained. NEVER delete, merge, rewrite, or consolidate this section. It is structural, not content.
2. **## Briefing Card** — Quick-load project context. May be updated with current facts but must retain these fields: Identity, Subject, EO, Current state (with absolute date), Charter (path to authoritative project definition, e.g. `1-ALIGN/1-PD/`), WMS, Active work.
3. **## Topic Index** — Pointer list to topic files. May add/remove entries but must remain a flat list of `- [filename](filename) — description` entries.

## Rules for Consolidation

- NEVER flatten the 3-section structure into fewer sections
- NEVER rename section headers (e.g., "Agent Instructions" → "Memory Overview" is FORBIDDEN)
- NEVER remove the Agent Instructions section — it governs file maintenance behavior
- When updating the Briefing Card, preserve all named fields (Identity, Subject, EO, etc.) — update values, don't restructure
- When pruning the Topic Index, only remove entries whose topic files have been deleted
- Topic files MUST retain YAML frontmatter (name, description, type)
- When updating stale numbers in topic files, replace with current values — do NOT strip numbers entirely and replace with generic descriptions
- The "Remaining Work" section in topic files is intentional backlog — do NOT treat as stale content to prune

## Seed Topic Files

When creating MEMORY.md for a new project, include these starter entries in the Topic Index. Claude and AutoDream will add more as the project evolves.

- `learned_patterns.md` — Recurring patterns discovered during execution (APEI IMPROVE workstream)
- `key_decisions.md` — Architecture Decision Records and rationale (APEI ALIGN workstream)
- `common_pitfalls.md` — UBS entries that materialized during execution (APEI PLAN workstream)

## Links

- [[CLAUDE]]
- [[architecture]]
- [[charter]]
- [[common_pitfalls]]
- [[key_decisions]]
- [[learned_patterns]]
- [[project]]
- [[workstream]]
