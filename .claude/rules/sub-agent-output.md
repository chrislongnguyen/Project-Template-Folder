# Sub-Agent Output — Always-On Rule

# version: 2.0 | status: Draft | last_updated: 2026-04-05

Applies to: ltc-builder, ltc-reviewer completion reports returned to orchestrator.
Does NOT apply to: ltc-explorer research reports (need full content), ltc-planner designs.

## Completion Report Format (ltc-builder / ltc-reviewer)

When returning a completion report to the orchestrating session, use this exact format:

```
DONE: <artifact-path> | ACs: <pass>/<total> | Blockers: <none or list>
```

Examples:
- `DONE: _genesis/DESIGN-obsidian-bases.md | ACs: 4/4 | Blockers: none`
- `DONE: scripts/status-guard.sh | ACs: 3/4 | Blockers: AC-03 FAIL — grep pattern missing`

## Rules

1. **One line for completion** — no synthesis paragraphs, no re-listing passing ACs
2. **List blockers explicitly** — if any AC fails, name it and why in the Blockers field
3. **No deferral** — never write "report sent to ltc-planner" or "I have completed and notified". Your output IS the report.
4. **Artifact path required** — always include the full relative path to the primary output

## What NOT to trim

- Research summaries from ltc-explorer: keep full content — orchestrator needs it to proceed
- Design rationale from ltc-planner: keep full content — decisions must be documented
- Error messages: never abbreviate failures — full error text required for diagnosis
