---
version: "2.0"
status: draft
last_updated: 2026-04-06
topic: platform
source: "captured/2026-04-06_token-waste-audit-analytics.md"
review: true
review_interval: 7
questions_answered:
  - so_what_relevance
  - what_is_it
  - what_else
  - how_does_it_work
  - why_does_it_work
  - why_not
  - so_what_benefit
  - now_what_next
---
# Claude Code Prompt Caching

> Claude Code automatically caches the system prompt (1-hour TTL) and conversation history (5-minute TTL). Cache reads cost ~10% of input price — the dominant cost lever in long sessions.

## L1 — Knowledge

### So What? (Relevance)
At L5 harness usage, the always-loaded system context (CLAUDE.md + rules ≈ 13,500 tokens) is read by the model on every single turn. Without caching, this would cost $0.04/turn at Opus pricing. With caching at 1,300:1 hit ratio, it costs $0.003/turn. Cache is what makes a rich always-on context economically viable. Understanding the two TTL tiers lets you actively manage cost vs. convenience.

### What Is It?
Prompt caching is Anthropic's server-side mechanism that stores token prefixes and serves them at reduced cost when the same prefix is sent again.

**Two cache tiers in Claude Code:**

| Tier | TTL | What it covers | Who controls it |
|---|---|---|---|
| Extended (1-hour) | 60 min | System prompt: CLAUDE.md + rules + tool schemas | Claude Code sets `cache_control` breakpoints automatically |
| Ephemeral (5-min) | 5 min | Conversation history (accumulated turns) | Resets on each API call; expires after 5 min idle |

**Pricing:**
| Token type | Cost (relative) |
|---|---|
| Fresh input | 100% |
| Cache creation | ~125% (one-time) |
| Cache read | ~10% |

### What Else?
- **KV cache** (different concept): in-process attention cache inside a single inference — not persistent across calls
- **Retrieval (RAG)**: fetches external context at query time — not cached at the prompt level
- **Context compression** (`/compress`): reduces token count by summarizing history — trades fidelity for cost

### How Does It Work?
```
Turn 1 (cold session):
  Send: [system prompt 13,500 tok] + [user message]
  API: process all tokens at full price
       store system prompt → extended cache (1-hr TTL)
       store history → ephemeral cache (5-min TTL)
  Cost: 13,500 × $3/M (creation) + small output

Turn 2 (within 5 min):
  Send: [same system prompt] + [prev history] + [new message]
  API: system prompt → cache HIT (10% price, 1-hr TTL reset)
       history → cache HIT (10% price, 5-min TTL reset)
       new message → full price
  Cost: ~$0.003 for system context + tiny history delta

Turn N (after 7-min pause, history cache expired):
  Send: [same system prompt] + [all accumulated history] + [new message]
  API: system prompt → cache HIT (still within 1 hr)
       history → cache MISS — pay full price to re-create
  Cost: system context cheap; history re-creation expensive
```

**Measured data (2026-04-06):**
- Opus cache reads: 271,619,204 tokens
- Opus fresh input: 209,171 tokens
- Hit ratio: **1,300:1**

## L2 — Understanding

### Why Does It Work?
Cache is keyed on exact token prefix sequences. The system prompt (CLAUDE.md + rules) is identical across every turn in a session — same bytes, same order — so it always hits the 1-hour cache. Conversation history grows with each turn but the prefix up to the last committed point is stable, so it hits the 5-minute cache as long as turns flow within the window.

Claude Code sets explicit `cache_control: {"type": "ephemeral"}` breakpoints on the system prompt, which is what earns the 1-hour TTL (vs the default 5-minute for unbracketed content). This is managed automatically — users don't need to set breakpoints manually.

### Why Not?
- **5-min history expiry on idle pauses**: any thinking pause >5 min re-prices all accumulated conversation history. At 50,000 tokens of history, one miss ≈ $0.34 at Opus pricing.
- **Sub-agents start cold**: spawned agents do NOT inherit the parent's cache. Each pays full creation cost on their first turn.
- **Prefix changes bust cache**: editing CLAUDE.md mid-session, adding an MCP server, or changing tool schemas invalidates the cache from the change point forward.
- **Cache is server-side**: cannot be controlled or warmed from outside an active session. No external keepalive mechanism exists.

## L3 — Wisdom

### So What? (Benefit)
The 1,300:1 hit ratio means the 13,500-token always-on context is essentially free per turn — it's already an optimized state. The remaining opportunity is the 5-minute history cache: preventing cold misses during thinking pauses is the one actionable lever.

Understanding the two-tier TTL also explains why system context size matters less than it appears: larger CLAUDE.md → larger creation cost on cold start, but once warm it's paid at 10%. The real cost is frequency of cold starts, not context size.

### Now What? (Keepalive strategies, ranked S×E×Sc)
1. **React to 2.1.92 footer hint**: when cache expires, Claude Code shows a warning. Send "k" to re-warm. Zero setup, zero automation.
2. **`/loop 4m k`** in long thinking sessions: sends "k" every 4 min, Claude replies "ok", cache stays warm. Cost: ~$0.001/hr.
3. **SessionStart notification hook**: macOS notification fires at 4.5-min mark as a reminder to send any message. Zero API calls.

**Warm first turn pattern**: open any session with a cheap message ("hi", "continue") before heavy work. Warms cache at minimum cost before the expensive turns.

## Sources
- [[claude-code-context-costs]]

## Links
- [[session-management]]
- [[hooks-lifecycle]]
- [[subagent-model-selection]]
- [[communicating-with-claude-code]]
- [[agent-reliability-compounding-error]]
