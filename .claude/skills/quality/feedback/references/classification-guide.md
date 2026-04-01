---
version: "1.0"
last_updated: 2026-03-30
---
# Feedback Classification Guide

## Detect Type

From conversation context:

- Frustration, confusion, breakage → `friction`
- Suggestion, wish, "it would be nice if" → `idea`

## Detect Workstream

From recent file paths or conversation topic:

| Pattern | Workstream label |
|---------|-----------|
| `1-ALIGN/`, charter, stakeholders, OKRs | `workstream:align` |
| `3-PLAN/`, risks, drivers, architecture | `workstream:plan` |
| `4-EXECUTE/`, src, tests, config | `workstream:execute` |
| `5-IMPROVE/`, changelog, retro, metrics | `workstream:improve` |
| `_genesis/`, frameworks, templates, SOPs | `workstream:shared` |
| `.claude/`, `rules/`, `CLAUDE.md`, skills, hooks | `workstream:agent` |
| DSBV process, `/dsbv`, DESIGN.md, SEQUENCE.md | `workstream:agent` |

## Detect Severity (friction only)

| Severity | Meaning |
|----------|---------|
| `blocked` | Could not proceed at all |
| `confused` | Unclear what to do or where to look |
| `annoying` | Works but frustrating |
