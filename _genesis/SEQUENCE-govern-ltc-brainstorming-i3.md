---
version: "2.0"
status: Draft
last_updated: 2026-04-05
design: _genesis/DESIGN-govern-ltc-brainstorming-i3.md
---

# SEQUENCE — ltc-brainstorming I2 Upgrade

## Task Order

```
T0 → T1 (parallel) → T2 → T3 → T4 → T5 → T6
```

| # | Task | Artifact | Agent | AC |
|---|------|----------|-------|----|
| T0 | Write structural validator script | `scripts/validate-brainstorming-i3.sh` | ltc-builder/Sonnet | Script exits 0 on valid, 1 on fail; covers AC-S1–S7 from DESIGN |
| T1 | Write Tier 2 fixture set + judge criteria | `scripts/fixtures/brainstorming-i3/` (5 .md files) | ltc-builder/Sonnet | F1–F5 inputs + 8 binary judge criteria each written before build starts |
| T2 | Build discovery-modes.md (A2) | `references/discovery-modes.md` | ltc-builder/Sonnet | All 6 protocol elements present; each has trigger + action + exit; UDS present in Gate 3 |
| T3 | Update SKILL.md (A1) | `ltc-brainstorming/SKILL.md` | ltc-builder/Sonnet | ≤220 lines; companion framing; both terminal states; trigger phrases in frontmatter; references A2 |
| T4 | Run Tier 1 — structural validator | — | Shell (no agent) | `validate-brainstorming-i3.sh` exits 0 |
| T5 | Run Tier 2 — fixture tests | `scripts/fixtures/brainstorming-i3/results.md` | 5× Sonnet + Opus judge | ≥4/5 fixtures pass all 8 binary criteria; results written to file |
| T6 | Human Tier 3 acceptance | — | User (Long) | User confirms: felt like colleague, ≤1Q/msg, ≥1 novel insight, pre-spec trusted |

## Dependencies

- T0 ∥ T1 — independent, run in parallel
- T2 must complete before T3 (SKILL.md references discovery-modes.md)
- T4 requires T0 + T3 complete
- T5 requires T1 + T4 pass
- T6 requires T5 ≥4/5 pass

## Commit points

- After T3: `feat(skills): ltc-brainstorming I2 — discovery protocol + companion framing`
- After T5: `test(skills): ltc-brainstorming I2 fixture results`
