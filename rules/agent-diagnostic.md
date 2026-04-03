<!-- GOVERN workstream agent-facing copy. Human-readable version: _genesis/frameworks/agent-diagnostic.md -->
# LTC Agent Diagnostic

> Source of truth: Doc-9 §3.7 (OPS_OE.6.0 research/amt/), Session 0 §4+§6 (Notion ALIGN Wiki)
> Distilled for agent and practitioner use. Load when debugging agent failures.
> Last synced: 2026-03-18

---

## §1 Notation

| Abbreviation | Full Name |
|---|---|
| 7-CS | The Agent's 7-Component System |
| EP | Effective Principles |
| EOP | Effective Operating Procedures |
| LT-N | LLM Truth #N (the 8 fundamental limits of LLM models) |
| UBS | Ultimate Blocking System (forces preventing desired outcome) |
| UDS | Ultimate Driving System (forces driving toward desired outcome) |

---

## §2 Purpose

This document is a **structured diagnostic framework** for tracing agent failures to their root components in the 7-CS.

**When to load:** When agent output is wrong, unexpected, or rejected — and you need to find and fix the cause.

**Core principle:** Action is emergent — it results from all 6 other components interacting. When Action fails, the cause is in one of the other 6 components. You observe Action to diagnose, but you fix the other components. (see agent-system.md §5, Action component card)

This doc is structured for both human practitioners and future automated diagnostic agents.

---

## §3 The Blame Diagnostic

From Session 0 §4 Pattern 2 and Doc-9 §3.7. Sequential walkthrough — ALWAYS check in this order:

1. **EP** — Did the rules cover this case? Are they too verbose (consuming context budget via LT-7)?
2. **Input** — Was context complete and unambiguous? Was scope explicit?
3. **EOP** — Was the procedure appropriate? Were steps well-scoped? Was the right skill triggered?
4. **Environment** — Was context window sufficient? Permissions correct? Compute adequate?
5. **Tools** — Were the right tools available? Returning good data? Too many tools loaded?
6. **Agent** — Only after checking 1–5: is the model genuinely underpowered for this task?

**Platform-specific trace points:**

| Platform | How to trace |
|---|---|
| **Claude Code** | Review tool call log — trace which files were read (Input), which rules applied (EP), which skill triggered (EOP) |
| **Cursor** | Check .cursorrules loading + which files were in context via @ mentions |
| **Gemini** | Check workspace rules + which context was loaded into the session |

---

## §4 Symptom → Root Component Table

Merged from Doc-9 §3.7 diagnostic table and Session 0 §6 anti-pattern table.

| Symptom | Likely Root Component | Check First |
|---|---|---|
| Agent states incorrect facts confidently | EP (missing validation rules) or Tools (no fact-checking) or Input (no source material) | Does EP require citations? Are verification tools available? |
| Agent loses track of instructions mid-task | EP (too verbose, consumes context) or Environment (insufficient context budget) | Count EP token footprint. Check context utilization. |
| Agent completes the wrong task | Input (ambiguous requirements) or EOP (wrong procedure loaded) | Was scope explicit? Was the right skill triggered? |
| Agent reasoning is shallow or circular | EOP (steps too large) or Agent (underpowered) or Environment (insufficient compute) | Are steps decomposed? Is extended thinking enabled? |
| Agent uses wrong tool or misinterprets output | Tools (too many, unclear purpose) or EOP (no tool selection guidance) | How many tools loaded? Does EOP specify which to use? |
| Output is correct but Director rejects it | Human UBS — Director's biases overriding evaluation | Run Force Map (§6). Is System 1 dominant? |
| Rushed delegation, compound errors | Derisk step skipped | Run Derisk Checklist (§5) before re-delegating |
| Inconsistent behavior across sessions | EP missing or too thin; LT-6 (no memory) | Is CLAUDE.md loaded? Does it cover this case? |

*Future iteration may convert this table to a structured data format (YAML/JSON) for automated consumption. The Markdown table serves as the human-readable v1.*

---

## §5 The Derisk Checklist

From Session 0 §4 Pattern 3. Pre-delegation gate — 30 seconds before ANY delegation:

1. **List what can go wrong** with this specific task
2. **For each risk, map:**

   `Risk → Which LT → Which component should compensate → Is it configured?`

3. **If any component is unconfigured** for a known risk → configure it before delegating
4. **If all risks are covered** → delegate with confidence

Example: Before asking the agent to research a competitor — (1) Agent doesn't know our positioning → LT-6 → Input must include our summary → Is it loaded? (2) Task is multi-layered → LT-3 → EOP must decompose → Are sub-tasks defined? (3) Agent might present stale data → LT-1 → Tools must include search → Is web search available?

Three risks caught, three compensations verified, before a single token is generated.

---

## §6 The Force Map

From Session 0 §4 Pattern 4. Determine which operator's UBS is active right now:

- **Human under time pressure / fatigue / emotional investment** → System 1 (heuristic-driven) is dominant → Delegate analysis to the Agent. It doesn't get tired, doesn't have ego, and will examine every angle if instructed.
- **Decision requires values, ethics, strategic judgment, domain expertise** → System 2 (deliberate) is needed → Don't delegate that part. Use the Agent for data gathering only.
- **Both forces active** → Split the task: Agent gathers and structures data, Human makes the judgment call on the structured output.

This works identically across Claude Code, Cursor, and Gemini — it is a thinking framework, not a tool feature. (see agent-system.md §4, The Two Operators)

---

## §7 Automated Diagnostic Integration Points

> **FUTURE — not yet implemented.** This section defines the architecture for autonomous diagnostic automation. It serves as a design reference for future implementation.

**Post-action hooks:**

- Validate output against AC eval spec (see general-system.md §7, Layer 3)
- Check output schema against contract fields (see general-system.md §7, Layer 2)
- Log: action type, component trace, pass/fail, tokens consumed
- On failure: auto-populate §4 table lookup — map symptom to likely root component

**Per-step monitoring:**

- Check failure mode triggers per category (see general-system.md §7, Layer 4):
  - Hallucination — schema validation against source material
  - Context loss — state check against expected context keys
  - Token exhaustion — response length check against budget
  - Schema violation — parse error on output model
  - Permission denied — boundary check against Always/Ask/Never tiers
  - Stale data — timestamp check against freshness threshold
- Track step duration against SLA
- Flag when context utilization exceeds 80% of effective window

**Per-session aggregation:**

- Symptom frequency by root component (which component appears most in traces)
- Most common failure patterns (map to §4 table rows)
- Component health score: % of actions traced to this component as root cause
- Session cost: total tokens consumed vs. budget allocated

**Cross-session intelligence:**

- Trend: is a component degrading over time? (e.g., EP growing beyond token budget)
- Correlation: which component combinations produce compound failures?
- Recommendation engine: e.g., "EP has been root cause in 40% of failures this week — review rules"
- Drift detection: compare current session component scores against rolling baseline

**Future architecture:**

- Autonomous diagnostic agent: hooks into Action observation → traces to component via §3 order → proposes fix → optionally auto-remediates (with Human Director approval gate)
- Review agent (like Cursor Review, post-session): scores component health, flags drift from EP, generates improvement tickets (see agent-system.md §5, Action component card)
- Integration with observability stack: logging, metrics, tracing, alerting feed diagnostic data automatically

## Links

- [[agent-diagnostic]]
- [[CLAUDE]]
- [[DESIGN]]
- [[GEMINI]]
- [[SKILL]]
- [[VALIDATE]]
- [[agent-system]]
- [[general-system]]
- [[iteration]]
- [[task]]
- [[workstream]]
