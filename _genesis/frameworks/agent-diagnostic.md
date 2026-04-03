---
version: "1.1"
last_updated: 2026-03-30
owner: "Long Nguyen"
---
# Agent Diagnostic Framework — Quick Reference
> LTC Global Framework — applies to ALL AI agent debugging.

## What is it?
Systematic blame-diagnostic: when agent output fails, trace through 6 configurable components before blaming the model. Most failures are configuration issues, not model issues.

## When to use
- When agent output is wrong, incomplete, or unexpected
- Before changing the model or adding more context
- During retrospectives (5-IMPROVE)

## Canonical source
| Source | What it contains | When to load |
|--------|-----------------|--------------|
| `rules/agent-diagnostic.md` | Full diagnostic: derisk checklist, symptom-to-component lookup, blame trace order, force map | On demand — when debugging agent behavior |

## Diagnostic order (summary)
```
EP → Input → EOP → EOE → EOT → Agent
(Most fixable ────────────────→ Least fixable)
```
If the first 5 components are correctly configured and the output is still wrong, THEN blame the model.
