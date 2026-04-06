---
version: "2.0"
status: Draft
last_updated: 2026-04-05
topic: agents
source: captured/claude-code-docs-full.md
review: true
review_interval: 7
questions_answered:
  - so_what_relevance
  - what_is_it
  - what_else
  - how_does_it_work
  - why_does_it_work
  - why_not
---

# Subagent Model Selection

Model routing is the primary cost-control lever for subagents. Choosing wrong multiplies cost on every delegation — correct routing is a first-class design decision, not an afterthought.

## L1 — Knowledge

### So What? (Relevance)

A read-only search agent running on Opus costs ~15x what it would on Haiku. Model selection per subagent is how you match capability tier to task complexity and enforce the LTC model routing table (Haiku = explore/lookup, Sonnet = build, Opus = design/synthesis).

### What Is It?

The `model` frontmatter field controls which model a subagent uses. Values accepted:

| Value | Meaning |
|---|---|
| `sonnet` | Alias — resolves to current Sonnet version |
| `opus` | Alias — resolves to current Opus version |
| `haiku` | Alias — resolves to current Haiku version |
| `claude-opus-4-6` | Full model ID — pinned to specific version |
| `claude-sonnet-4-6` | Full model ID — pinned to specific version |
| `inherit` | Use same model as main conversation |
| *(omitted)* | Defaults to `inherit` |

### What Else?

**Model resolution order** (first match wins):

1. `CLAUDE_CODE_SUBAGENT_MODEL` environment variable
2. Per-invocation `model` parameter (Claude passes this when invoking the agent)
3. Subagent definition's `model` frontmatter field
4. Main conversation's model

The env var is the escape hatch for org-wide overrides — it overrides everything, including per-agent definitions.

**Effort level is separate from model.** The `effort` field (`low`, `medium`, `high`, `max`) controls extended thinking depth. `max` is only supported on Opus 4.6. Effort overrides the session-level effort setting for this agent's invocations.

### How Does It Work?

When Claude Code prepares to invoke a subagent, it resolves the model using the 4-step priority chain above. The resolved model is used for all turns of that subagent invocation. If the subagent is resumed (via `SendMessage`), the same resolution applies to the resumed session.

The built-in Explore agent uses **Haiku** by design — fast and low-latency for read-only search. The built-in Plan and General-purpose agents inherit from the main conversation, since their capability requirements depend on the current task's complexity.

## L2 — Understanding

### Why Does It Work?

Aliases (`sonnet`, `haiku`, `opus`) decouple agent definitions from model version churn — when Anthropic releases a new Sonnet, all agents using the alias upgrade automatically. Full model IDs (`claude-sonnet-4-6`) pin to a specific version for reproducibility or testing.

The env var override (`CLAUDE_CODE_SUBAGENT_MODEL`) exists for operators who need to enforce a cost ceiling across all subagents regardless of individual definitions — useful for org-managed deployments where budget control trumps per-agent optimization.

### Why Not?

- `inherit` (the default) is safe for capability but not for cost control. If the main conversation uses Opus and all agents inherit, every delegation costs Opus rates.
- Full model IDs require manual update when you want to upgrade to a newer version.
- `effort: max` on a subagent running frequently (like a code reviewer that triggers on every save) can be very expensive — effort level compounds with model cost.
- There is no per-invocation way for the user to override model — only Claude can pass a per-invocation `model` parameter. The env var is the only user-side global override.

## Sources

- `captured/claude-code-docs-full.md` lines 28212–28227
- Source URL: https://code.claude.com/docs/en/sub-agents#choose-a-model

## Links

- [[custom-subagents-overview]]
- [[subagent-frontmatter-fields]]
- [[subagent-tool-restrictions]]
