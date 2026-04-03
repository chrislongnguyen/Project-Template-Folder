---
version: "1.0"
last_updated: 2026-04-03
owner: Long Nguyen
workstream: govern
iteration: I2
status: draft
type: sequence
stage: sequence
---

# SEQUENCE.md — GOVERN Workstream, I2 (Naming Convention Upgrade)

> DSBV Phase 2 artifact. Task ordering, sizing, and dependency map.

## Dependency Graph

```
         ┌──────────┐   ┌──────────┐   ┌──────────┐
         │ Group 1  │   │ Group 2  │   │ Group 3  │
         │ A10      │   │ A1-A3    │   │ A4, A7   │
         │ enforce- │   │ A5-A6    │   │ version  │
         │ ment ref │   │ NAMING_  │   │ .md      │
         │ (new)    │   │ CONV.md  │   │ (update) │
         └────┬─────┘   └────┬─────┘   └────┬─────┘
              │              │               │
              │    PARALLEL  │    PARALLEL   │
              │              │               │
              │              └───────┬───────┘
              │                      │
              │              ┌───────▼───────┐
              │              │   Group 4     │
              │              │   A8: naming- │
              │              │   rules.md    │
              │              │   (new, refs  │
              │              │    2+3)       │
              │              └───────┬───────┘
              │                      │
              │              ┌───────▼───────┐
              │              │   Group 5     │
              │              │   A9: hooks   │
              │              │   (refs A8)   │
              │              └───────┬───────┘
              │                      │
              └──────────┬───────────┘
                         │
                 ┌───────▼───────┐
                 │   Group 6     │
                 │   A11: CHANGE │
                 │   LOG stub    │
                 └───────────────┘
```

## Task Table

| Task | Artifacts | File | Action | Size | Dependencies | Group |
|------|-----------|------|--------|------|-------------|-------|
| T1 | A10 | `.claude/rules/enforcement-layers.md` | CREATE new always-on rule. 4×3 MECE matrix. | S | None | G1 (parallel) |
| T2 | A1,A2,A3,A5,A6 | `_genesis/security/naming-convention.md` | ADD 5 new sections (§2b boundary table, §2c folder+template rules, §7 kebab-case, §8 prefix registry) | M | None | G2 (parallel) |
| T3 | A4, A7 | `.claude/rules/versioning.md` | UPDATE: lowercase frontmatter rule + iteration_name field | S | None | G3 (parallel) |
| T4 | A8 | `.claude/rules/naming-rules.md` | CREATE new always-on rule with cheat sheet table | S | T2, T3 | G4 (sequential) |
| T5 | A9 | `.claude/hooks/naming-lint.sh` + settings.json | CREATE hook script + register in settings | S | T4 | G5 (sequential) |
| T6 | A11 | `5-IMPROVE/changelog/CHANGELOG.md` | ADD migration backlog entry | XS | None | G6 (anytime) |

## Execution Plan

**Wave 1 (parallel):** T1 + T2 + T3 — three ltc-builder agents
**Wave 2 (sequential):** T4 — depends on T2+T3 outputs
**Wave 3 (sequential):** T5 — depends on T4
**Wave 4 (parallel with any):** T6 — trivial, no deps

**Total:** 3 parallel + 2 sequential + 1 trivial = ~6 tasks, ~25K tokens
