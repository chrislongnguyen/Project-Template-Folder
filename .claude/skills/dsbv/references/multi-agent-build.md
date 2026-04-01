---
version: "1.0"
last_updated: 2026-03-30
---
# Multi-Agent Build Reference

> When to use: DSBV Build phase on design-heavy workstreams (ALIGN, PLAN).
> Pattern: Competing Hypotheses + Synthesis (ADR-001, Option C).
> Single-agent Build for execution-heavy workstreams (EXECUTE, IMPROVE).

## Pattern: Competing Hypotheses + Synthesis

```
N ltc-builder agents (Sonnet) ──→ N independent drafts
                                       │
                              ltc-planner (Opus) synthesizes
                                       │
                              Human Director approves
```

**Why synthesis over selection:** Selection discards insights from non-winning teams. Synthesis captures the union of best elements across all drafts. The Opus synthesizer produces output stronger than any individual draft.

## Cost Estimate Template

Show this to the user BEFORE launching multi-agent build:

```
Multi-Agent Build Estimate
──────────────────────────
Teams:     {N} ltc-builder agents (Sonnet)
Synthesis: 1 ltc-planner agent (Opus)
Est. cost: ~${N * 2-3} (builders) + ~$3-5 (synthesis) = ~${total}

Single-agent alternative: ~$3-5 (one Opus run)

Proceed with multi-agent? [y/n]
```

Default N=3 for I1. Scale up if outputs diverge significantly.

## Agent Files

| Role | File | Model | Purpose |
|------|------|-------|---------|
| Builder | `.claude/agents/ltc-builder.md` | Sonnet | Produces artifacts |
| Reviewer | `.claude/agents/ltc-reviewer.md` | Opus | Validates artifacts |
| Planner | `.claude/agents/ltc-planner.md` | Opus | Synthesizes multi-agent output |
| Explorer | `.claude/agents/ltc-explorer.md` | Haiku | Pre-DSBV research |

## When to Use Multi-Agent

| Workstream Type | Pattern | Rationale |
|-----------|---------|-----------|
| Design-heavy (ALIGN, PLAN) | Multi-agent (N=3) | Open-ended work benefits from diverse perspectives. Missing a risk has high blast radius. |
| Execution-heavy (EXECUTE, IMPROVE) | Single-agent | Deterministic output — diversity adds cost, not quality. |
| GOVERN workstream | Single-agent | Config files and agent definitions are deterministic. |

## Self-Assessment Table (required per draft)

Each ltc-builder draft must include:

```markdown
| Criterion | Met? | Evidence |
|-----------|------|----------|
| AC-01: ... | YES | [file:line or excerpt] |
| AC-02: ... | PARTIAL | [what's missing] |
```

The synthesizer uses these tables to select best elements — not "pick longest draft."

## Failure Modes

1. **All drafts converge** → Diversity added no value. Reduce N next time.
2. **Sonnet quality floor** → Drafts too poor for synthesis. Fall back to single Opus.
3. **Opus synthesis bias** → Favors "sounds best" over "is best." Mitigate: structured rubric scoring per dimension.

## Links

- [[ADR-001]]
- [[CLAUDE]]
- [[dsbv]]
- [[ltc-builder]]
- [[ltc-explorer]]
- [[ltc-planner]]
- [[ltc-reviewer]]
- [[workstream]]
