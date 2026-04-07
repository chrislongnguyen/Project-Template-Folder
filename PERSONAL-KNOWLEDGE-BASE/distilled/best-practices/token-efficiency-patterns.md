---
version: "2.0"
status: draft
last_updated: 2026-04-06
topic: best-practices
source: "captured/2026-04-06_token-waste-audit-analytics.md"
review: true
review_interval: 14
questions_answered:
  - so_what_relevance
  - what_is_it
  - what_else
  - how_does_it_work
  - why_does_it_work
  - why_not
  - so_what_benefit
  - now_what_next
  - what_is_it_not
  - how_does_it_not_work
---
# Token Efficiency Patterns for Claude Code

> At L5 harness usage, token spend is deliberate expenditure not waste. The patterns below distinguish intentional cost from inefficiency — and identify where marginal gains are actually available.

## L1 — Knowledge

### So What? (Relevance)
Running a full ALPEI × DSBV workflow with 7 hooks, 4 MECE agents, QMD memory recall, and multi-account Claude Code is expensive by design. The question is not "am I wasting tokens?" but "which spend is deliberate and which is structural inefficiency?" Knowing the difference prevents both over-optimization (trading capability for pennies) and under-optimization (paying for waste that serves no purpose).

### What Is It?
Token efficiency patterns are architectural decisions — about hook triggers, model routing, context size, and agent spawning — that minimize token cost without degrading output quality or workflow capability.

**Measured baseline (2026-04-06, 26-day audit):**
| Metric | Value |
|---|---|
| Always-loaded context | 33.8 KB ≈ 13,500 tokens |
| System context cache TTL | 1-hour (extended cache) |
| Cache hit ratio | 1,300:1 (Opus) |
| Cost per warm system-context turn | ~$0.003 |
| Sessions audited | 1,949 JSONL files, 177,064 lines |
| Peak daily cost | $78.50 (Apr 6) |

### What Else?
- **Context compression** (`/compress`): reduces accumulated history at milestone points — trades continuity for cost reset
- **Model downgrade**: use Sonnet/Haiku for tasks that don't require Opus — direct cost multiplier
- **Shorter sessions**: fewer turns = less history cache accumulation = fewer cold-miss risks
- **Batch operations**: group related tasks into fewer, longer turns vs many short turns (reduces per-turn overhead)

### How Does It Work?
Four levers control token efficiency:

**1. Hook trigger frequency**
Each hook firing adds overhead. The key is filtering: fire only when the prompt/tool warrants it.
- `strategic-compact.sh`: filters to heavy tools only (Read/Bash/Agent) + outputs at threshold multiples only
- `memory-recall.sh`: throttles to every 3rd prompt + skips short/continuation prompts + requires 2+ keywords

**2. Model routing**
| Model | Use case | Relative cost |
|---|---|---|
| Haiku | Explore/search/read-only (ltc-explorer) | 1× |
| Sonnet | Build/code/iterate (ltc-builder) | ~5× |
| Opus | Design/synthesis/review (ltc-planner, ltc-reviewer) | ~40× |

Routing violations (using Opus where Sonnet suffices) are the highest-cost inefficiency.

**3. Sub-agent cold start cost**
Each spawned agent loads the full system context independently on turn 1. N parallel agents = N × 13,500 tokens of cold creation cost, regardless of cache state in the parent.

**4. Cache warmth**
System context: 1-hour TTL → almost never cold. Conversation history: 5-minute TTL → cold on any pause >5 min.

## L2 — Understanding

### Why Does It Work?
The 1,300:1 cache hit ratio means the 13,500-token always-loaded context is amortized to near-zero per turn. What looks like a "large" system context (33.8 KB) is actually efficient because:
1. It's on 1-hour cache — paid at 10% price
2. It's reused across every turn of every session that day
3. Cache creation is a one-time cost per session cold start

The hook filtering mechanisms (threshold gates, frequency throttles, pattern guards) work because they exit before any expensive computation — shell-level early exits cost microseconds, not tokens.

### Why Not?
- **Opus at 92% of turns** is the dominant cost driver — and often correct. ltc-planner + ltc-reviewer are Opus by design. Audit for routing violations before assuming model cost is waste.
- **Sub-agent multiplication is inherent**: 3 parallel Haiku explorers = 3 × 13,500 cold tokens. This is the price of parallelism, not inefficiency. Reduce by batching exploration into fewer, larger agents.
- **memory-recall firing on every 3rd prompt** — even with throttling, 29 recall injections per 87 prompts adds context. The value depends on recall quality vs injection cost.

## L3 — Wisdom (Prescriptions)

### So What? (Benefit)
Applying P1-P2 (completed or near-complete as of Apr 6) addresses the two structural inefficiencies — cross-session hook accumulation and unconditional recall injection. The remaining P3-P6 items are marginal (5-15% gains). Together they don't change the order of magnitude of spend.

**The real efficiency insight:** L5 users are not paying for waste — they're paying for capability. A $78.50 day reflects Opus-quality design decisions across 244 turns, not token leakage.

**Prescriptions status (Apr 6):**
| ID | Action | Impact | Status |
|---|---|---|---|
| P1 | strategic-compact: session-scoped counter, threshold 200→350 | Cross-session false fires | ✅ Done |
| P2 | memory-recall: skip <25 chars + continuation patterns | 17–44K tokens/day | ✅ Done |
| P3 | Rules consolidation 23.8KB → ~12KB | 6K tokens/cold-start | Open |
| P4 | Audit Opus sub-agent routing compliance | Model cost reduction | Open |
| P5 | Read tool deduplication rule (prompt-level) | Up to 500K heavy sessions | Open |
| P6 | Cache keepalive for thinking pauses | ~$0.70-1.00/session | Open |

### Now What? (Next actions)
1. **P3**: Extract verbose spec content from the 5 largest rules files (`versioning.md` 5.4KB, `enforcement-layers.md` 3.6KB, `git-conventions.md` 2.9KB) into `_genesis/` references. Replace with 2-3 line stubs in always-loaded versions.
2. **P4**: Run `git log --oneline | grep -i opus` or review recent JSONL for agent model distribution. Flag any ltc-explorer calls using Sonnet/Opus instead of Haiku.
3. **P5**: Add to CLAUDE.md: "Before calling Read on any file, check if already read this session. Only re-read if content likely changed."
4. **P6**: Use 2.1.92 footer cache-expiry warning reactively. For known long thinking sessions: `/loop 4m k`.

## L4 — Expertise

### What Is It NOT?
Token efficiency is NOT about minimizing context size at the expense of capability. The CLAUDE.md + 14 rules exist because they prevent systematic errors (wrong scope, wrong status, missing version bumps). Removing them to save 13,500 tokens per session would cost more in rework than it saves.

It is also NOT about avoiding sub-agents. Parallel Haiku explorers are cheaper than sequential Sonnet exploration. The multiplied cold-start cost is outweighed by parallelism gains on research tasks.

### How Does It NOT Work?
- **Shrinking CLAUDE.md aggressively** removes rules that exist for a reason — creates errors that cost more to fix than they save
- **Forcing everything to Haiku** degrades design/review quality — the Opus cost for architecture decisions is proportional to their value
- **Avoiding /compress** to preserve continuity leads to context bloat and eventual compaction-forced-by-limit, which is more disruptive

## Sources
- [[claude-code-context-costs]]
- [[claude-code-prompt-caching]]

## Links
- [[session-management]]
- [[hooks-lifecycle]]
- [[subagent-model-selection]]
- [[agent-teams-best-practices]]
- [[communicating-with-claude-code]]
- [[claude-code-prompt-caching]]
