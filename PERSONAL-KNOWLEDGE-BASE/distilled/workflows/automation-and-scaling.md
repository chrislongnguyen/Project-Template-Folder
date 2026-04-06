---
version: "2.0"
status: Draft
last_updated: 2026-04-05
topic: workflows
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
  - so_what_benefit
  - now_what_next
---

# Automation and Scaling with Claude Code

Claude Code scales horizontally. Once you are effective with one session, non-interactive mode, parallel sessions, fan-out patterns, and auto mode multiply output without proportionally increasing human effort.

## L1 — Knowledge

### So What? (Relevance)

Single-session interactive use is only one mode. The same model that answers questions in a terminal can run in CI, process 2,000 files in parallel, or coordinate multiple specialized sessions — without changing your prompting style.

### What Is It?

Four scaling primitives:

| Primitive | Flag/Command | Best for |
|---|---|---|
| Non-interactive mode | `claude -p "prompt"` | CI, pre-commit hooks, scripting |
| Parallel sessions | Desktop app, web, agent teams | Speed, isolation, quality via Writer/Reviewer |
| Fan-out | Loop `claude -p` per file | Large migrations, batch analyses |
| Auto mode | `--permission-mode auto` | Unattended execution with safety classifier |

### What Else?

- Output formats: plain text (default), `--output-format json`, `--output-format stream-json`
- `--allowedTools` scopes what Claude can do per invocation — critical for unattended batch jobs
- `--verbose` for debugging; disable in production
- Writer/Reviewer pattern: Session A implements, Session B reviews with fresh context (no implementer bias)
- Agent teams provide automated coordination: shared tasks, messaging, team lead session
- Auto mode uses a classifier model that runs before each command — it blocks scope escalation, unknown infrastructure changes, and prompt-injection-driven actions
- Auto mode aborts non-interactive runs if the classifier blocks repeatedly (no human fallback available)

### How Does It Work?

**Non-interactive mode:**
```bash
# One-off query
claude -p "Explain what this project does"

# Structured output for scripts
claude -p "List all API endpoints" --output-format json

# Streaming for real-time processing
claude -p "Analyze this log file" --output-format stream-json

# Pipe into other commands
claude -p "Summarize errors" --output-format json | jq '.result'
```

**Parallel sessions — Writer/Reviewer pattern:**

| Session A (Writer) | Session B (Reviewer) |
|---|---|
| `Implement a rate limiter for our API endpoints` | — |
| — | `Review the rate limiter in @src/middleware/rateLimiter.ts. Look for edge cases, race conditions, and consistency with existing middleware.` |
| `Here's the review feedback: [output]. Address these issues.` | — |

Same pattern works for test-driven: Session A writes tests, Session B writes code to pass them.

**Fan-out across files:**
```bash
# Step 1: generate file list
claude -p "List all Python files that need migrating" > files.txt

# Step 2: loop with scoped permissions
for file in $(cat files.txt); do
  claude -p "Migrate $file from React to Vue. Return OK or FAIL." \
    --allowedTools "Edit,Bash(git commit *)"
done
```
Test on 2–3 files first, refine the prompt, then run at scale. `--allowedTools` prevents unintended side effects when running unattended.

**Auto mode:**
```bash
claude --permission-mode auto -p "fix all lint errors"
```
Classifier reviews commands before execution. Allows routine work without prompts. Blocks: scope escalation, unknown infrastructure, hostile-content-driven actions.

## L2 — Understanding

### Why Does It Work?

Non-interactive mode works because `claude -p` is stateless by default — no session overhead, pure input-output. This matches CI/CD patterns where idempotency and parseability matter more than conversation history.

Fan-out works because LLM tasks over files are embarrassingly parallel — each file migration is independent. The bottleneck is API rate limits, not task dependencies. `--allowedTools` makes each invocation safe by restricting blast radius.

The Writer/Reviewer quality pattern works because a fresh context has no anchoring bias toward code it just wrote. A reviewer session will catch mistakes the writer session rationalized away.

Auto mode's safety classifier works because it's a separate model with a narrow safety mandate — faster and cheaper than full model reasoning, focused only on permission decisions. The abort-on-repeated-block behavior prevents runaway API spend when the classifier is consistently rejecting actions in a non-interactive run.

### Why Not?

- Non-interactive runs consume tokens without a human checkpoint — cost can grow unexpectedly on large codebases
- Fan-out at 2,000 files is significant API spend; test on 10 files and extrapolate before committing
- Writer/Reviewer requires two active sessions and doubles API cost for the review phase
- Auto mode's classifier can be overly conservative on legitimate unusual operations — you may need to manually allow specific patterns
- `--allowedTools` scoping requires knowing in advance what tools the task needs; too-narrow scope causes premature failure
- Session naming and management across parallel sessions requires discipline — otherwise you lose track of which session has which state

## L3 — Application

### So What Benefit?

Fan-out turns a 40-hour manual migration into an overnight automated job. The Writer/Reviewer pattern applies quality control to Claude's own output without human review of every line. Non-interactive mode integrates AI into existing pipelines without architectural changes.

### Now What? (Next Actions)

1. Identify the next large repetitive task (migration, lint fixes, doc updates) and try a 5-file fan-out proof-of-concept
2. For the next significant feature review, open a second Claude session instead of asking the same session to self-review
3. Add `--permission-mode auto` to any recurring CI script where prompts are blocking

## Sources

- `captured/claude-code-docs-full.md` lines 1531–1623 ("Automate and scale")

## Links

[[session-management]]
[[communicating-with-claude-code]]
[[skills-and-subagents]]
