---
description: Agent roster and dispatch rules — 4 agents, models, and EP-13 constraint
globs: "**"
---

# Agent Roster & Dispatch

Full spec: `rules/agent-system.md` | Agent files: `.claude/agents/`

## 4-Agent Roster

| Agent | Model | Scope |
|-------|-------|-------|
| `ltc-explorer` | haiku | Pre-DSBV research, discovery, read-only exploration |
| `ltc-planner` | opus | DSBV Design + Sequence, synthesis, orchestration |
| `ltc-builder` | sonnet | DSBV Build — artifact production, code, docs |
| `ltc-reviewer` | opus | DSBV Validate — review against DESIGN.md criteria |

## EP-13 — Sub-Agent Safety

- ONLY the orchestrator (main session) may call `Agent()` — sub-agents MUST NEVER call `Agent()`
- Spawning sub-agents from a build/review agent creates untracked nesting and scope drift
- If a sub-agent needs research → STOP and report to orchestrator

## Dispatch Requirements

Every Agent() call MUST:
1. Name exactly one of the 4 agents above
2. Use context packaging: EO → INPUT → EP → OUTPUT → VERIFY
3. Set model to match the agent file above (mismatch = silent failure)
4. Use absolute file paths when in a git worktree

## S > E > Sc Priority

Prioritize in this order — ALWAYS:
1. **Sustainability** — will this hold up over time? reversible? maintainable?
2. **Efficiency** — is this the simplest correct approach?
3. **Scalability** — only optimize for scale after S and E are satisfied

## Links

- [[AGENTS]]
- [[agent-system]]
- [[agent-dispatch]]
- [[DESIGN]]
- [[task]]
