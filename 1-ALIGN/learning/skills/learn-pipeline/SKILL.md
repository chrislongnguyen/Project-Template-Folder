---
name: learn
description: Automated learning pipeline — captures inputs, runs deep-research (Claude-native), structures output into Effective Learning pages, and facilitates human review. Replaces manual 8-hour interactive page generation with a 3-step automated pipeline.
---

# Learn — Automated Learning Pipeline

Automates the ELF learning phase: capture inputs, research via parallel sub-agents using deep-research methodology (multi-angle web search, citation tracking), structure into Effective Learning pages, and review with human approval gates.

## Commands

| Command | Trigger | What it does | Creates |
|---------|---------|-------------|---------|
| `/learn:input` | User starts new learning subject | Phase 0 interview — captures EO, RACI, contracts, scope | `1-ALIGN/learning/input/learn-input-{system}.md` |
| `/learn:research` | After `/learn:input` complete | Spawns parallel sub-agents (1 per topic) using deep-research methodology — multi-angle web search, citation tracking, 6-section Effective Learning output | `1-ALIGN/learning/research/{system}/` |
| `/learn:structure` | After research complete | Claude Code skill (`context: fork`) — 2-pass parallel: spawns 6 sub-agents (one per page) to populate from research, then orchestrator fixes cross-page consistency | `1-ALIGN/learning/output/{system}/T{n}.P{m}-{name}.md` |
| `/learn:review` | After structuring complete | Claude Code skill (inline, no fork) — 2-phase: validates all pages automatically (validation + seed checks), then presents consolidated causal spine and collects approval in one turn | Updates page status (`status: approved` / `needs-revision`) |
| `/spec:extract` | After all 6 T0 pages approved | Claude Code skill (`context: fork, model: opus`) — reads approved T0 pages, extracts VANA grammar elements (Verbs from P5, Adverbs from P3, Nouns from P4, Adjectives from P3×P4), populates `1-ALIGN/learning/templates/vana-spec-template.md` | `1-ALIGN/learning/specs/{system}/vana-spec.md` |
| `/spec:handoff` | After `/spec:extract` complete | Claude Code skill (inline, model: opus) — presents VANA-SPEC to Human Director for review (I1 scope, failure modes, agent boundaries, contracts), HARD STOP waits for approval, then stamps spec + writes GSD-STATE.md to activate Build pipeline | `1-ALIGN/learning/specs/{system}/GSD-STATE.md`, `1-ALIGN/learning/specs/{system}/vana-spec.md` [handoff-approved] |

## Pipeline Flow

```
/learn:input → learn-input-{system}.md
                    ↓
/learn:research → 1-ALIGN/learning/research/{system}/T{n}-{topic}.md  (parallel, deep-research)
                    ↓
/learn:structure → 1-ALIGN/learning/output/{system}/T{n}.P0-P5.md (6 pages per topic, forked Opus agent)
                    ↓
/learn:review → human approves all 6 T0 pages
                    ↓
/spec:extract → 1-ALIGN/learning/specs/{system}/vana-spec.md  (VANA-SPEC with ACs, failure modes, contracts)
                    ↓
/spec:handoff → Human Director review (I1 scope, failure modes, boundaries, contracts)
             → 1-ALIGN/learning/specs/{system}/GSD-STATE.md  (I1 active AC tracker — Build pipeline activated)
```

## When to Use

- Starting a new Learning Book subject
- Adding topics to an existing subject (re-run at deeper depth)
- User says `/learn:input`, `/learn:research`, `/learn:structure`, or `/learn:review`

## Rules

- Commands run in sequence. Do not skip steps (e.g., no `/learn:structure` without research output).
- `/learn:input` is interactive (human interview). All other commands are agent-driven.
- `/learn:research` spawns parallel sub-agents that use deep-research *methodology* (multi-angle web search, citation tracking, anti-hallucination protocol). Sub-agents do NOT invoke the `/deep-research` skill — they output directly in 6-section Effective Learning format to avoid format collision. Depth mapped from topic depth: T0→mid (5 searches, 8+ sources), T0-T2/T0-T5→deep (8 searches, 12+ sources).
- `/learn:structure` is a Claude Code native skill (`1-ALIGN/learning/skills/learn-structure/SKILL.md`) with `context: fork`. Uses 2-pass parallel architecture: Pass 1 spawns 6 sub-agents (one per page) to populate from research simultaneously; Pass 2 fixes cross-page consistency (seed alignment, principle codes, direction inversion). One topic per invocation.
- `/learn:review` is a Claude Code native skill (`1-ALIGN/learning/skills/learn-review/SKILL.md`), runs inline (no fork — requires interactive approval). 2-phase design: Phase 1 validates all pages automatically (validation script + seed checks); Phase 2 presents consolidated causal spine and collects approval in one turn (not per-page). Writes `status: approved` frontmatter to page files. Resumable — re-run skips already-approved pages. Gate blocks `/spec:extract` until all pages approved.
- Generated pages must pass CAG validation (see `1-ALIGN/learning/config/constraints.yaml` cell_regex).
- `/spec:extract` is a Claude Code native skill (`1-ALIGN/learning/skills/spec-extract/SKILL.md`) with `context: fork, model: opus`. Reads all 6 approved T0 pages. Gate enforced — all pages must have `status: approved` before extraction begins. Outputs to `1-ALIGN/learning/specs/{system}/vana-spec.md`.
- `/spec:handoff` is a Claude Code native skill (`1-ALIGN/learning/skills/spec-handoff/SKILL.md`), runs inline (no fork — requires interactive Human Director approval). Presents I1 scope, failure modes, agent boundaries, and integration contracts. HARD STOP gate — does not write output until "approved". On approval: prepends `status: handoff-approved` frontmatter to the VANA-SPEC and writes `1-ALIGN/learning/specs/{system}/GSD-STATE.md` with I1 AC tracker. This activates the Build pipeline (`/build:init` Path A).

## References

| File | Purpose |
|------|---------|
| `1-ALIGN/learning/skills/learn-input/SKILL.md` | `/learn:input` skill spec |
| `1-ALIGN/learning/skills/learn-research/SKILL.md` | `/learn:research` skill spec |
| `1-ALIGN/learning/skills/learn-structure/SKILL.md` | `/learn:structure` skill spec |
| `1-ALIGN/learning/skills/learn-structure/references/` | Structuring procedure, validation rules, page dispatch |
| `1-ALIGN/learning/scripts/validate-learning-page.sh` | Effective Learning page validation script (CAG, rows, columns) |
| `1-ALIGN/learning/skills/learn-review/SKILL.md` | `/learn:review` skill spec |
| `1-ALIGN/learning/skills/learn-pipeline/references/research-prompt-template.md` | Research query template (interpolated per topic) |
| `1-ALIGN/learning/templates/learn-input-template.md` | Input file format |
| `1-ALIGN/learning/templates/page-0-overview-and-summary.md` through `page-5-*.md` | Effective Learning page templates |
| `1-ALIGN/learning/skills/spec-extract/SKILL.md` | `/spec:extract` skill spec |
| `1-ALIGN/learning/templates/vana-spec-template.md` | VANA-SPEC output template |
| `1-ALIGN/learning/skills/spec-handoff/SKILL.md` | `/spec:handoff` skill spec |

## Related Skills

- **learn-build-cycle** — the overarching methodology this skill implements the Learn half of
- **root-cause-tracing** — used during `/learn:structure` for P1/P2 causal chain construction
- **Build Engine** — the Build half. Activated after `/spec:handoff` produces `GSD-STATE.md`. Entry: `/build:init`.
