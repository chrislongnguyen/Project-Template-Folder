---
version: "1.1"
status: draft
last_updated: 2026-04-13
---

# .claude — Agent Configuration Directory

Agent configuration for Claude Code. All LTC AI agent behavior is defined and enforced here.

| Directory / File | Contents |
|-----------------|----------|
| `agents/` | 4 agent definitions: ltc-explorer, ltc-planner, ltc-builder, ltc-reviewer |
| `rules/` | 12 always-on rule files — loaded every Claude Code session |
| `skills/` | 28 slash commands (`/dsbv`, `/organise`, `/obsidian`, etc.) |
| `hooks/` | Enforcement scripts wired to Claude Code hook events |
| `settings.json` | 29 hook registrations — the primary enforcement layer |

Full enforcement spec: `.claude/rules/enforcement-layers.md`
Hook event reference: `.claude/rules/enforcement-layers.md` § Hook Event Quick-Ref

## Links

- [[CLAUDE]]
- [[enforcement-layers]]
- [[agent-dispatch]]
