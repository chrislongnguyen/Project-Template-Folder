---
date: "2026-04-08"
type: capture
source: conversation
tags: [agent-sdk, capability-assessment, i1-i4, architecture-decision]
---

# Agent SDK Capability Assessment — I1 through I4

## Context
Evaluated whether Claude Agent SDK (Python/TS) can build the LTC 5-agent system (Orchestrator + Explorer, Planner, Builder, Reviewer) through I4 Leadership without external frameworks.

## Decisions Recorded (D7, D8)

### D7: Drop WMS Integration
- ClickUp is now primary WMS (Notion demoted)
- ClickUp MCP quality too poor for automation
- Gap #4 (WMS integration) dropped from I2/I3 agent improvement roadmap
- Manual WMS updates acceptable at I1-I3

### D8: Agent SDK Ceiling
- Claude Code Agent() + Agent SDK can reach I3 (MVE) without external frameworks
- Hard limits: no nested sub-agents (depth=1), no peer negotiation, no dynamic workflow DAGs
- I4 Leadership requires external orchestration (LangGraph or Agno)
- Agent SDK is the correct I2-I3 vehicle

## Capability Matrix

```
                    Claude Code       Agent SDK         External
                    Agent()           (Python/TS)       Framework
                    ──────────        ──────────        ──────────
I1 Concept          ✓ FULL            ✓ FULL            not needed
I2 Prototype        ✓ CEILING         ✓ FULL            not needed
I3 MVE              ✗ BOTTLENECK      ✓ MOSTLY          not needed*
I4 Leadership       ✗ IMPOSSIBLE      ✗ INSUFFICIENT    REQUIRED
```

*I3 requires app-level orchestration (async Python) for feedback loops.

## Hard Limits (Both Tools)
- No nested sub-agents — depth=1 only
- No peer negotiation — sub-agents can't talk to each other
- Reactive loop — always human-triggered, never self-initiating

## SDK Real-World Value for LTC PMs

Agent SDK does NOT replace Claude Code for interactive work. It enables:

1. **Batch DSBV** — Python script runs DSBV across 8 repos in parallel
2. **Session continuity** — `query(resume=session_id)` picks up exact state
3. **Cost visibility** — every `query()` returns `total_cost_usd`
4. **Automated nightly review** — cron + headless `bypassPermissions`
5. **Generator/Critic loop** — programmatic builder→reviewer→fix cycle (max 3x)

Does NOT help with: interactive exploration, one-off tasks, learning pipeline, <3 agent tasks.

## Effort Estimate

| Level | Effort | What |
|-------|--------|------|
| I1 | ~0 | Already here with Claude Code Agent() |
| I2 | 1-2 days | Python wrapper: session resume, cost tracking, context-packaging |
| I3 | 1-2 weeks | Async app: headless agents, hook feedback, persistence |
| I4 | Months | LangGraph/Agno on top of SDK — different project |

## Key Insight
For a single PM using 5 agents interactively: Agent SDK adds nothing. It's an engineering tool for when you want agents running without you in the chair.
