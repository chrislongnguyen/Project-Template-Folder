---
version: "1.0"
status: draft
last_updated: 2026-04-08
type: decision
work_stream: 0-GOVERN
iteration: 1
title: "Decision: Should ltc-planner get Write/Edit tools?"
---

# Decision: Should ltc-planner get Write/Edit tools?

**Context:** ltc-planner currently has no Write/Edit tools. All output is text returned to the orchestrator, which must extract and write DESIGN.md/SEQUENCE.md to disk. This 2-step handoff is lossy (LT-2: content degrades during handoff).

**Source:** `inbox/2026-04-08_DESIGN-agent-2-planner.md` -- EO section, Write/Edit Tool Question.

## Options Evaluated

| Option | Sustainability | Efficiency | Scalability | Verdict |
|--------|---------------|------------|-------------|---------|
| A: No Write (current) | HIGH -- human gate prevents bad writes | LOW -- double token cost, lossy handoff | MEDIUM -- text-based, portable | Status quo |
| B: Add Write/Edit | MEDIUM -- removes human gate | HIGH -- single-step, no handoff loss | MEDIUM -- same | Risky |
| C: Add Write, gate behind G1/G2 | HIGH -- gate preserved, write is post-approval | HIGH -- single-step after approval | MEDIUM -- same | **Recommended** |

## Recommendation: Option C

Add Write/Edit to planner's tool whitelist, but update EOP to require:

1. Planner returns DESIGN.md content as text first (generation pass)
2. Orchestrator presents to human at G1/G2 gate
3. On approval, orchestrator re-invokes planner with "write approved content to disk"

This preserves the human gate while eliminating the lossy extraction step.

**Trade-off:** Option C adds one extra planner invocation (content generation + disk write = 2 calls instead of 1). Token cost increase ~10-15%. But it eliminates the LT-2 handoff loss, which is the higher risk.

## Status

**Deferred.** Requires Human Director approval (changes tool whitelist = MEDIUM risk). Flagged for discussion.

## Links

- [[2026-04-08_DESIGN-agent-2-planner]]
- [[DESIGN]]
- [[SEQUENCE]]
- [[iteration]]
- [[ltc-planner]]
