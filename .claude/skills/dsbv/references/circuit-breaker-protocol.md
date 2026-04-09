---
version: "1.0"
status: draft
last_updated: 2026-04-09
name: circuit-breaker-protocol
description: "Circuit breaker protocol for the Generator/Critic loop — loop state tracking, FAIL classification, hard-stop rules, and escalation format. Draft for SKILL.md Wave 4 integration (T4.1)."
work_stream: 4-EXECUTE
type: reference
---
# Circuit Breaker Protocol — Generator/Critic Loop

## Loop State Tracking

After each reviewer dispatch, update loop state in the gate state file:

```bash
bash scripts/gate-state.sh update-loop <workstream> iteration 1
bash scripts/gate-state.sh update-loop <workstream> cost_tokens <N>
bash scripts/gate-state.sh update-loop <workstream> fail_count <count_of_fails>
```

State file: `.claude/state/dsbv-<workstream>.json`
Relevant fields under `loop_state`:

| Field | Type | Description |
|-------|------|-------------|
| `iteration` | integer | Number of builder/reviewer cycles run |
| `max_iterations` | integer | Hard ceiling — default 3 |
| `fail_count` | integer | Running total of FAIL verdicts across iterations |
| `cost_tokens` | integer | Approximate token accumulation across iterations |

## FAIL Classification

After parsing VALIDATE.md FAIL items, classify each using:

```bash
CLASSIFICATION=$(bash scripts/classify-fail.sh "<fail_text>")
```

Classification is deterministic. Output is one of: `SYNTACTIC` | `SEMANTIC` | `ENVIRONMENTAL` | `SCOPE`.

## Hard-Stop Classification Table

| Classification | Meaning | Action |
|----------------|---------|--------|
| SYNTACTIC | Format, structure, frontmatter, schema error | Retry — provide specific correction instruction |
| SEMANTIC | Wrong logic, wrong content, misunderstood requirement | ESCALATE immediately — wrong understanding, needs PM |
| ENVIRONMENTAL | Missing file, permission error, script failure | Fix environment first, then retry |
| SCOPE | Out of scope, undefined requirement, needs research | ESCALATE immediately — out of build scope, needs PM |

## Hard-Stop Rules

Evaluate after every reviewer dispatch, in this order:

1. Same FAIL text persists across 2 consecutive iterations → ESCALATE
2. 2 consecutive agent failures (non-zero exit code from builder or reviewer) → STOP
3. All FAIL items in current iteration classified as SEMANTIC → ESCALATE immediately
4. `loop_state.iteration >= loop_state.max_iterations` (default 3) → ESCALATE

Rules 1 and 3 take precedence over retry logic. Never retry after ESCALATE is triggered.

## Escalation Message Format

When a hard-stop rule triggers, present to PM:

```
⚡ CIRCUIT BREAKER: <reason>
  Classification: <type>
  Iteration: <N>/<max>
  Fail count: <total_fails>
  Action required: Review and provide guidance, or /dsbv reset <workstream>
```

Example:

```
⚡ CIRCUIT BREAKER: Same FAIL persists across 2 iterations
  Classification: SEMANTIC
  Iteration: 2/3
  Fail count: 4
  Action required: Review DESIGN.md AC-03 — builder is misunderstanding the acceptance criterion. Provide clarification, then /dsbv reset 1-ALIGN.
```

## Reset

After PM provides guidance and the issue is resolved, reset loop state before retrying:

```bash
bash scripts/gate-state.sh reset <workstream>
```

This resets all gates and loop state to initial values. Re-advance gates to the correct phase before resuming.

## Cross-References

- Loop state schema: `scripts/gate-state.sh` — `loop_state` block in `print_initial_json`
- FAIL classifier: `scripts/classify-fail.sh`
- Metrics log (cross-session recurring FAILs): `.claude/logs/dsbv-metrics.jsonl`
- Generator/Critic loop context: `SKILL.md` §Generator/Critic Loop

## Links

- [[gate-state]]
- [[classify-fail]]
- [[SKILL]]
- [[dsbv-metrics]]
