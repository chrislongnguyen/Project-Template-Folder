---
version: "1.0"
last_updated: 2026-03-29
owner: "Long Nguyen"
---
# Agent 7-Component System (7-CS) — Quick Reference
> LTC Global Framework — applies to ALL AI agent projects.

## What is it?
The AI-specific specialization of the 8-component universal model.
7 configurable components: EP, Input, EOP, EOE, EOT, Agent, EA → produce EO.

Why 7, not 8: In AI systems, EU = Agent (LLM model — uncontrollable, only identify UBS/UDS), EA is observable-only (not controllable like human action), EI = Input (what you feed the agent).

## When to use
- When configuring, understanding, or diagnosing an AI agent
- When mapping the 8 LLM Truths to component compensations
- When assigning RACI between Human Director (A) and Agent (R)

## Canonical sources
| Source | What it contains | When to load |
|--------|-----------------|--------------|
| `rules/agent-system.md` | Full 7-CS spec: 8 LLM Truths, Two Operators, 7 component cards, dependency graph | Always-loaded via CLAUDE.md |
| `_genesis/reference/ltc-effective-agent-principles-registry.md` | 10 Effective Principles (EP-01 through EP-10) with LT grounding and APEI application | During agent design or debugging |

## Key concepts (summary only)
- **8 LLM Truths:** Structural constraints (hallucination, lossy context, reasoning degradation, etc.) — not bugs, not fixable by next model
- **Two Operators:** Human Director (Accountable, System 2 strengths, System 1 biases) + Agent (Responsible, architectural strengths, 8 LT limits)
- **Component Priority:** EP → Input → EOP → EOE → EOT → Agent → EA
- **Diagnostic Order:** When output fails, trace: EP → Input → EOP → EOE → EOT → Agent (blame model last)
