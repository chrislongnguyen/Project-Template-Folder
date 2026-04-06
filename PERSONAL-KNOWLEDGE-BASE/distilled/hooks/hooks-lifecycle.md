---
version: "2.0"
status: Draft
last_updated: 2026-04-05
topic: hooks
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

# Hooks Lifecycle

> Claude Code fires deterministic shell commands, HTTP calls, or LLM prompts at fixed lifecycle points — giving you hard control over behavior that the model itself cannot override.

## L1 — Knowledge

### So What? (Relevance)

Hooks are the primary enforcement layer for any rule that must hold regardless of what Claude decides. Permission rules in settings control _what_ Claude can ask for; hooks control _what happens_ at each moment — before, during, and after. For LTC projects this is the mechanism behind `UserPromptSubmit` thinking-mode injection, `PreToolUse` security guards, and `InstructionsLoaded` audit logging.

### What Is It?

Hooks are user-defined handlers that execute automatically when specific lifecycle events fire in a Claude Code session. A hook attaches to an **event** (e.g., `PreToolUse`), optionally filtered by a **matcher** (regex on tool name or session source), and runs a **handler** of type `command`, `http`, `prompt`, or `agent`.

### What Else?

- 26 distinct events spanning the full session arc: SessionStart → agentic loop → SessionEnd
- Four handler types: command (shell), http (POST to URL), prompt (single-turn LLM), agent (multi-turn LLM with tools)
- Async mode: `async: true` on command hooks lets Claude continue without waiting
- Hooks in skills/agents: scoped to the component's lifetime via YAML frontmatter
- `/hooks` menu: read-only browser inside Claude Code showing all configured hooks

### How Does It Work?

```
Event fires
  → matcher regex filters (tool name, session source, notification type, etc.)
    → if field further filters by permission-rule syntax
      → handler(s) run in parallel (deduplicated by command string / URL)
        → handler communicates via exit codes + stdout (command) or HTTP response (http)
          → Claude Code applies the decision
```

**Exit code semantics (command hooks):**
| Exit code | Meaning |
|-----------|---------|
| 0 | Success — parse stdout for JSON decision |
| 2 | Blocking error — stderr fed to Claude as reason |
| Other | Non-blocking — stderr shown in verbose only |

**JSON output fields (exit 0):**
| Field | Effect |
|-------|--------|
| `continue: false` | Stop Claude entirely |
| `decision: "block"` | Block action (PostToolUse, Stop, etc.) |
| `hookSpecificOutput` | Richer per-event control (PreToolUse, PermissionRequest) |
| `additionalContext` | Inject string into Claude's context |
| `systemMessage` | Show warning to user |

**Events that CAN block:**
PreToolUse, PermissionRequest, UserPromptSubmit, Stop, SubagentStop, TeammateIdle, TaskCreated, TaskCompleted, ConfigChange, Elicitation, ElicitationResult, WorktreeCreate

**Events that CANNOT block** (observability only):
PostToolUse, PostToolUseFailure, PermissionDenied, Notification, SubagentStart, SessionStart, SessionEnd, CwdChanged, FileChanged, PreCompact, PostCompact, InstructionsLoaded, StopFailure, WorktreeRemove

## L2 — Understanding

### Why Does It Work?

Hooks run outside the LLM inference loop. They are shell processes (or HTTP calls) invoked by the Claude Code harness, not by the model. This means:
- A hook returning `permissionDecision: "deny"` blocks a tool even in `bypassPermissions` mode
- Hooks tighten restrictions; they cannot loosen them past what permission rules allow
- Identical handlers deduplicate automatically — adding the same hook twice has no extra cost

The three-level filter (event → matcher → if field) avoids spawning processes unnecessarily. The `if` field uses permission-rule syntax (`Bash(git *)`) and is only evaluated on tool events.

### Why Not?

- Hooks run with full user permissions — a malicious hook config is a privilege escalation vector
- `PostToolUse` hooks cannot undo the action (tool already ran)
- `PermissionRequest` hooks don't fire in `-p` non-interactive mode — use `PreToolUse` instead
- Stop hooks fire on every Claude response end, not just task completion — must check `stop_hook_active` to avoid infinite loops
- Multiple `PreToolUse` hooks returning `updatedInput` race non-deterministically — only one wins

## L3 — Wisdom

### So What? (Benefit)

Hooks enable **deterministic policy enforcement** in a probabilistic system. They are the answer to "Claude sometimes ignores my rule" — if it must always happen, put it in a hook, not in a CLAUDE.md instruction.

### Now What? (Next)

- Start with the `Notification` hook (desktop alert) — zero-risk, immediate payoff
- Add `PreToolUse` + `Bash(rm *)` guard before any agentic work on production systems
- Use `SessionStart` with `compact` matcher to re-inject critical context after compaction
- Read `InstructionsLoaded` events to audit which rule files are actually loading

## Sources

- captured/claude-code-docs-full.md (lines 12504-15718, hooks reference + guide)

## Links

- [[hook-matchers]]
- [[hook-input-output]]
- [[hooks-in-skills-agents]]
- [[mcp-server-config]]
