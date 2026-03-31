# Feedback Classification Guide

## Detect Type

From conversation context:

- Frustration, confusion, breakage → `friction`
- Suggestion, wish, "it would be nice if" → `idea`

## Detect Zone

From recent file paths or conversation topic:

| Pattern | Zone label |
|---------|-----------|
| `1-ALIGN/`, charter, stakeholders, OKRs | `zone:align` |
| `2-PLAN/`, risks, drivers, architecture | `zone:plan` |
| `3-EXECUTE/`, src, tests, config | `zone:execute` |
| `4-IMPROVE/`, changelog, retro, metrics | `zone:improve` |
| `_genesis/`, frameworks, templates, SOPs | `zone:shared` |
| `.claude/`, `rules/`, `CLAUDE.md`, skills, hooks | `zone:agent` |
| DSBV process, `/dsbv`, DESIGN.md, SEQUENCE.md | `zone:agent` |

## Detect Severity (friction only)

| Severity | Meaning |
|----------|---------|
| `blocked` | Could not proceed at all |
| `confused` | Unclear what to do or where to look |
| `annoying` | Works but frustrating |
