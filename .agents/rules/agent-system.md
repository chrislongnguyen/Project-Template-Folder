# LTC Agent System

> For AntiGravity and other AAIF-compatible agents. Full spec: `rules/agent-system.md`

## 8 LLM Truths (structural limits — not bugs)
1. Hallucination is structural (factual accuracy)
2. Context compression is lossy (volume)
3. Reasoning degrades on complex tasks (step count)
4. Retrieval is fragile under token limits (precision in noise)
5. Prediction optimises plausibility, not truth
6. No persistent memory across sessions
7. Cost scales with token count
8. Alignment is approximate (rule compliance under pressure)

## 7-Component System
`Outcome = f(EP, Input, EOP, Environment, Tools, Agent, Action)`

| # | Component | Role |
|---|-----------|------|
| 1 | EP | Persistent rules — always active, constrains all below |
| 2 | Input | Task-specific context — sets output ceiling |
| 3 | EOP | Step-by-step procedures loaded on demand |
| 4 | Environment | Workspace config, permissions, context budget |
| 5 | Tools | MCP servers, APIs, CLI — extend Agent capability |
| 6 | Agent | The AI model — capabilities bounded by 8 LTs |
| 7 | Action | Emergent output — diagnose only, fix components 1-6 |

## 3 Principles
1. **Brake Before Gas** — derisk first, then drive output
2. **Know the Physics** — 8 LTs are constraints, not bugs; stop trying to fix them
3. **Two Operators, One System** — Human Director (judgment, strategy) + Agent (execution, exhaustive analysis) compensate for each other's blind spots
