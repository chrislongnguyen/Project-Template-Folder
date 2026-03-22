# Trade-Off Framework: S/E/Sc Structured Analysis

> Reference for evaluating design approaches during brainstorming.
> Ground truth: general-system.md §6 (S > E > Sc priority)

## Core Principle

**Sustainability > Efficiency > Scalability (S > E > Sc)**

When evaluating trade-offs between design approaches, apply this strict priority order:

1. **Sustainability (S)** — Can the system survive and recover from failures? Is it risk-mitigated? A fragile fast system is worse than a slow reliable one. A sustainable 80% solution outperforms a fragile 100% solution.

2. **Efficiency (E)** — Given sustainability is met, how well does the system use resources? Minimize waste, maximize throughput, reduce cognitive load.

3. **Scalability (Sc)** — Given sustainability and efficiency are met, can the system grow? Handle more load, more users, more complexity?

**Never sacrifice a higher-priority dimension for a lower one.** A scalable but fragile system is wrong. An efficient but unsustainable system is wrong.

## Structured Analysis Template

When proposing 2-3 approaches during brainstorming, evaluate each against S/E/Sc:

### Approach Evaluation Matrix

| Dimension | Approach A | Approach B | Approach C |
|---|---|---|---|
| **Sustainability** | | | |
| - Failure modes identified? | {Yes/No + count} | {Yes/No + count} | {Yes/No + count} |
| - Recovery mechanisms? | {describe} | {describe} | {describe} |
| - Single points of failure? | {count + location} | {count + location} | {count + location} |
| - Degradation behavior? | {graceful / catastrophic} | {graceful / catastrophic} | {graceful / catastrophic} |
| **Efficiency** | | | |
| - Resource usage | {tokens / time / cost} | {tokens / time / cost} | {tokens / time / cost} |
| - Cognitive load | {low / medium / high} | {low / medium / high} | {low / medium / high} |
| - Maintenance burden | {low / medium / high} | {low / medium / high} | {low / medium / high} |
| **Scalability** | | | |
| - Growth ceiling | {describe limit} | {describe limit} | {describe limit} |
| - Complexity growth | {linear / quadratic / exponential} | {linear / quadratic / exponential} | {linear / quadratic / exponential} |
| - Adaptation cost | {low / medium / high} | {low / medium / high} | {low / medium / high} |

### Decision Rule

1. **Eliminate** any approach that fails on Sustainability (no recovery, catastrophic failure modes, unmitigated single points of failure)
2. **Among surviving approaches,** prefer the one with better Efficiency
3. **If Efficiency is comparable,** prefer the one with better Scalability
4. **If all comparable,** prefer the simpler approach (YAGNI)

## Common Trade-Off Patterns

### Pattern 1: Simple vs. Robust

| | Simple | Robust |
|---|---|---|
| S | Low — no error handling, no recovery | High — explicit failure modes, graceful degradation |
| E | High — less code, faster to build | Medium — more code, more testing |
| Sc | Varies | Varies |
| **Verdict** | Reject if system is non-trivial | **Prefer** — sustainability wins |

### Pattern 2: Monolithic vs. Decomposed

| | Monolithic | Decomposed |
|---|---|---|
| S | Low — single point of failure, context overload risk (LT-2) | High — isolated failure, smaller blast radius |
| E | High initially — fewer moving parts | Lower initially — coordination overhead |
| Sc | Low — grows until it breaks | High — add/modify units independently |
| **Verdict** | OK for truly simple tasks only | **Prefer** for anything with 2+ concerns |

### Pattern 3: Fast-but-Fragile vs. Slow-but-Safe

| | Fast-but-Fragile | Slow-but-Safe |
|---|---|---|
| S | Low — skips validation, no retry | High — validates at each step, retries on failure |
| E | High throughput but high rework rate | Lower throughput but lower rework rate |
| Sc | Breaks under load / complexity | Maintains quality under load |
| **Verdict** | **Never** for production systems | **Prefer** — net efficiency is higher when rework is counted |

## Agent-Specific Trade-Offs

When designing systems that agents will build or operate:

| Trade-Off | S-Preferred Choice | Rationale |
|---|---|---|
| Large context vs. small context | Small context per agent | LT-2: context compression degrades quality |
| Implicit rules vs. explicit rules | Explicit, re-injected rules | LT-4: instruction following degrades with distance |
| Trust agent output vs. validate | Validate deterministically | LT-1: confident errors are undetectable without checks |
| Single long session vs. fresh sessions | Fresh sessions per task | LT-6: no persistent memory; fresh context = fresh rules |
| Complex prompt vs. simple prompt + reference | Simple prompt + reference | LT-3: reasoning degrades with complexity |

## How to Present

When presenting approaches to the user:

1. **Lead with your recommendation** and state which S/E/Sc dimension drives the choice
2. **Show the matrix** (simplified — 3-4 rows, not the full template) for each approach
3. **Explicitly name what you're sacrificing** and why the trade-off is worth it
4. **Flag any approach where sustainability is questionable** — the user should know the risk
