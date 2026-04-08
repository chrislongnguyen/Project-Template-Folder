---
version: "1.0"
status: draft
last_updated: 2026-04-03
---
# Naming Rules — Always-On Rule

Full spec: `_genesis/security/naming-convention.md`

## Separator Grammar

`_` = scope boundary | `.` = numeric level | `-` = word join within NAME

## CRITICAL: SCOPE codes are IRREGULAR — NEVER derive algorithmically. Always look up Table 3a in full spec.

Memorized codes: `OPS`, `INVTECH`, `INV`, `COE_EFF`, `LTC` (= LTC ALL)

## Cheat Sheet

| Creating a... | Format | Example |
|---|---|---|
| Git repo name | UNG canonical key | `OPS_OE.6.4.PROJECT-NAME` |
| ClickUp project | UNG canonical key | `OPS_OE.6.4.PROJECT-NAME` |
| Drive folder | UNG canonical key | `OPS_OE.6.4.PROJECT-NAME` |
| Workstream folder | `{N}-{NAME}` (CAPS) | `1-ALIGN`, `3-PLAN` |
| Skill folder | `{prefix}-{name}` | `ltc-naming-rules` |
| Agent file | `{prefix}-{role}.md` | `ltc-planner.md` |
| Rule file | `{topic}.md` | `agent-dispatch.md` |
| Script file | `{name}.sh` | `dsbv-gate.sh` |
| Template file | (plain name in `_genesis/templates/`) | `design-spec.md` |
| Frontmatter values | lowercase kebab | `status: draft` |
| Frontmatter keys | snake_case | `work_stream`, `last_updated` |
| Python identifier | snake_case | `parse_frontmatter()` |
| JS identifier | camelCase | `parseFrontmatter()` |
| Version number | `MAJOR.MINOR` | `1.3` |
| Version label | lowercase-kebab | `concept`, `logic-scaffold` |

## Skill Prefix Registry

| Prefix | Domain |
|--------|--------|
| `ltc-` | governance / cross-cutting |
| `dsbv-` | process / DSBV lifecycle |
| `vault-` | obsidian / vault ops |
| `gws-` | google workspace |
| (none) | utility scripts |

## Folder Format Rejection

`1_align`, `1.ALIGN`, `ALIGN-1` — all REJECTED. Only `{N}-{NAME}` in CAPS is valid.

## Links

- [[SKILL]]
- [[agent-dispatch]]
- [[ltc-planner]]
- [[naming-convention]]
- [[project]]
- [[security]]
- [[workstream]]
