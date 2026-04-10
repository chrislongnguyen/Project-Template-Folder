---
description: DSBV process rules — Design→Sequence→Build→Validate phase ordering and gates
globs: "**"
---

# DSBV Process — Design → Sequence → Build → Validate

Full spec: `.claude/rules/alpei-chain-of-custody.md` | Skill: `.claude/skills/dsbv/SKILL.md`

## Phase Order (enforced — no skipping)

```
DESIGN → SEQUENCE → BUILD → VALIDATE
  G1        G2        G3       G4
```

| Gate | Trigger | Human approval required? |
|------|---------|--------------------------|
| G1 | DESIGN.md written → enter Sequence | Yes — approve DESIGN.md |
| G2 | SEQUENCE.md written → enter Build | Yes — approve SEQUENCE.md |
| G3 | Build artifacts produced → enter Validate | Yes — confirm deliverables complete |
| G4 | VALIDATE.md written → workstream complete | Yes — set `status: validated` |

## Hard Rules

- NEVER write workstream artifacts (1-ALIGN/, 3-PLAN/, 4-EXECUTE/, 5-IMPROVE/) without DESIGN.md
- NEVER self-set `status: validated` — only human validates
- NEVER skip a gate — if blocked, STOP and report
- DSBV applies to ALIGN/PLAN/EXECUTE/IMPROVE. LEARN uses a 6-state pipeline, NOT DSBV.

## Chain of Custody

ALIGN → LEARN → PLAN → EXECUTE → IMPROVE. Workstream N cannot start Build until N-1 has ≥1 validated artifact.

Sub-system order: PD → DP → DA → IDM. Downstream cannot exceed upstream version.

## Status Lifecycle

```
draft → in-progress → in-review → validated
```

Agent sets: `draft`, `in-progress`, `in-review`. Human ONLY sets `validated`.

## Links

- [[DESIGN]]
- [[SEQUENCE]]
- [[VALIDATE]]
- [[alpei-chain-of-custody]]
- [[dsbv-process]]
- [[workstream]]
