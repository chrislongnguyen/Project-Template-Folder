# DSBV Phase Execution Guide

Practical guidance for executing each phase. Supplements the procedural steps in SKILL.md with quality patterns and anti-patterns observed in practice.

## Design Phase — What Good Looks Like

A strong DESIGN.md has:
- **Artifact inventory** — every deliverable named, with purpose and owner
- **Per-artifact success rubric** — binary criteria, not vibes ("all fields validated against schema" not "good quality")
- **Alignment table** — every completion condition maps to an artifact, every artifact maps to a condition. Zero orphans.
- **Explicit out-of-scope** — what this workstream will NOT produce, to prevent scope creep during Build

A weak DESIGN.md has:
- Vague artifact names ("documentation", "tests")
- Success criteria that require judgment ("looks good", "is complete")
- No alignment table — conditions and artifacts listed separately with no traceability

## Sequence Phase — Dependency Ordering

Common dependency patterns per workstream:

| Workstream | Typical dependency chain |
|---|---|
| ALIGN | Charter → Stakeholders → Requirements → OKRs → Decisions |
| PLAN | Architecture → Risks (UBS) → Drivers (UDS) → Roadmap |
| EXECUTE | Config → Core modules → Integration → Tests → Docs |
| IMPROVE | Metrics collection → Analysis → Retro → Changelog |

**Sizing heuristic:** If a task would take >1h human-equivalent, decompose further. If <15min, consider merging with an adjacent task.

## Build Phase — Quality Checkpoints

**Single-agent Build:** After each task, self-verify against its acceptance criteria from DESIGN.md BEFORE moving to the next task. Do not batch verification.

**Multi-agent Build:** Before synthesis, each draft must include a self-assessment table:

```
| Criterion | Met? | Evidence |
|---|---|---|
| AC-01: ... | YES | [file:line or excerpt] |
| AC-02: ... | PARTIAL | [what's missing] |
```

The synthesizer uses these tables to select best elements, not just "pick the longest draft."

## Validate Phase — Evidence Standards

Each check in VALIDATE.md must have:
1. **Criterion** — exact text from DESIGN.md (copy, don't paraphrase)
2. **Verdict** — PASS / FAIL / PARTIAL (no other values)
3. **Evidence** — file path, line number, or excerpt that proves the verdict

**Red flag:** If every criterion is PASS and no evidence column exists, the validation was rubber-stamped. Re-run with evidence requirements.

## Workstream Transition Checklist

Before declaring a workstream complete:
- [ ] VALIDATE.md exists with per-criterion verdicts + evidence
- [ ] No FAIL verdicts remain (all fixed or explicitly deferred with justification)
- [ ] Next workstream's C1 (clear scope) and C2 (input materials) can be satisfied from this workstream's output
- [ ] Human has approved the transition
