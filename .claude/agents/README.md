---
version: "1.0"
status: draft
last_updated: 2026-04-11
---

# agents — MECE Agent Definitions

4 agents covering the full DSBV lifecycle. Each agent has a distinct scope and model tier.

| Agent | Model | Scope |
|-------|-------|-------|
| `ltc-explorer.md` | Haiku | Pre-DSBV research, discovery, read-only exploration |
| `ltc-planner.md` | Opus | DSBV Design + Sequence, synthesis, orchestration |
| `ltc-builder.md` | Sonnet | DSBV Build — artifact production, code, docs |
| `ltc-reviewer.md` | Opus | DSBV Validate — review against DESIGN.md criteria |

Dispatch via `/dsbv` skill or direct `Agent()` call. Context packaging required for all invocations.
EP-13: Only the orchestrator (main session) calls `Agent()` — sub-agents MUST NEVER spawn sub-agents.

Full dispatch rules: `.claude/rules/agent-dispatch.md`

## Links

- [[CLAUDE]]
- [[agent-dispatch]]
- [[ltc-builder]]
- [[ltc-explorer]]
- [[ltc-planner]]
- [[ltc-reviewer]]
