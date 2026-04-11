---
description: Naming rules — UNG grammar, separator logic, SCOPE codes
globs: "**"
---

# Naming Rules

Full spec: `rules/naming-rules.md`

## UNG Grammar

`{SCOPE}_{FA}.{ID}.{NAME}`

Separators: `_` = scope boundary | `.` = numeric level | `-` = word join within NAME

## CRITICAL: SCOPE codes are IRREGULAR — NEVER derive algorithmically

Memorized valid codes: `OPS`, `INVTECH`, `INV`, `COE_EFF`, `LTC`

## Cheat Sheet

| Creating a... | Format | Example |
|---|---|---|
| Git repo / ClickUp project | UNG canonical key | `OPS_OE.6.4.PROJECT-NAME` |
| Workstream folder | `{N}-{NAME}` (CAPS) | `1-ALIGN`, `3-PLAN` |
| Skill folder | `{prefix}-{name}` | `ltc-naming-rules` |
| Agent file | `{prefix}-{role}.md` | `ltc-planner.md` |
| Rule file | `{topic}.md` | `agent-dispatch.md` |
| Script file | `{name}.sh` | `dsbv-gate.sh` |
| Frontmatter values | lowercase kebab | `status: draft` |
| Frontmatter keys | snake_case | `work_stream`, `last_updated` |
| Python identifier | snake_case | `parse_frontmatter()` |
| JS identifier | camelCase | `parseFrontmatter()` |
| Version number | `MAJOR.MINOR` | `1.3` |

## Folder Format Rejection

`1_align`, `1.ALIGN`, `ALIGN-1` — all REJECTED. Only `{N}-{NAME}` in CAPS is valid.

## Frontmatter Casing Rule

All frontmatter values MUST be lowercase — EXCEPT `work_stream` which uses numbered SCREAMING:
`work_stream: 1-ALIGN` (not `1-align`)

## Links

- [[naming-rules]]
- [[project]]
- [[workstream]]
