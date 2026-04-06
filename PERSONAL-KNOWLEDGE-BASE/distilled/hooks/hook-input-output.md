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

# Hook Input and Output

> Hooks communicate via stdin JSON → exit code + stdout JSON — a simple contract that supports blocking, context injection, input rewriting, and session termination.

## L1 — Knowledge

### So What? (Relevance)

Understanding the I/O contract is required before writing any hook script. The most common hook bugs — JSON not being parsed, hooks not blocking — all trace to I/O contract violations (e.g., exit 2 with JSON on stdout, or profile echoing text before JSON).

### What Is It?

**Input:** Claude Code sends a JSON object to the hook on **stdin** (command hooks) or as the **POST body** (HTTP hooks). All events share common fields, plus event-specific fields.

**Output:** The hook communicates back via:
- Exit code (command) or HTTP status + body (HTTP)
- stdout (command) or response body (HTTP): JSON or plain text

### What Else?

**Common input fields (all events):**
| Field | Description |
|-------|-------------|
| `session_id` | Current session identifier |
| `transcript_path` | Path to conversation JSONL |
| `cwd` | Working directory when hook fires |
| `hook_event_name` | Name of the event |
| `permission_mode` | Current mode: `default`, `plan`, `acceptEdits`, `auto`, `dontAsk`, `bypassPermissions` |
| `agent_id` | Present inside subagent calls |
| `agent_type` | Agent name (inside subagent or `--agent` session) |

**Event-specific input examples:**
- PreToolUse: `tool_name`, `tool_input` (fields vary by tool — Bash has `command`, Edit has `file_path`/`old_string`/`new_string`, etc.)
- UserPromptSubmit: `prompt`
- SessionStart: `source` (`startup`/`resume`/`clear`/`compact`), `model`
- Stop: `stop_hook_active` (bool), `last_assistant_message`
- PermissionDenied: `reason`

**Output cap:** Context injected via `additionalContext`, `systemMessage`, or plain stdout is capped at 10,000 characters. Overflow saves to a file and inserts a reference.

### How Does It Work?

**Two output modes — choose one per hook:**

Mode 1 — Exit codes only:
```bash
exit 0   # allow, no structured output
exit 2   # block, write reason to stderr
exit 1   # non-blocking error, continue
```

Mode 2 — Exit 0 + JSON stdout:
```json
{
  "continue": false,           // stop Claude entirely
  "stopReason": "...",         // shown to user (not Claude)
  "decision": "block",         // block action (PostToolUse, Stop, etc.)
  "reason": "...",             // shown to Claude when blocking
  "suppressOutput": true,      // hide stdout from verbose mode
  "systemMessage": "...",      // warning to user
  "hookSpecificOutput": {      // per-event rich control
    "hookEventName": "PreToolUse",
    "permissionDecision": "deny",
    "permissionDecisionReason": "...",
    "updatedInput": {...},      // rewrite tool arguments
    "additionalContext": "..."
  }
}
```

**PreToolUse `permissionDecision` values:**
| Value | Effect |
|-------|--------|
| `allow` | Skip permission prompt |
| `deny` | Cancel tool call, send reason to Claude |
| `ask` | Show permission dialog (labeled with hook source) |
| `defer` | Pause and exit with `stop_reason: "tool_deferred"` (non-interactive only) |

**Precedence when multiple PreToolUse hooks conflict:** `deny` > `defer` > `ask` > `allow`

**HTTP hooks:**
- 2xx empty body = success
- 2xx JSON body = parsed same as command stdout
- Non-2xx = non-blocking error (execution continues)
- Cannot block via status code alone — must return JSON with decision

### How Does It Work? (continued — common pitfalls)

**Shell profile echo problem:** Claude Code sources `~/.zshrc` or `~/.bashrc` when spawning hook shells. If your profile unconditionally echoes text, it prepends to JSON:
```
Shell ready on arm64
{"decision": "block"}   ← Claude Code fails to parse this
```
Fix: wrap echo in `if [[ $- == *i* ]]; then` (interactive-only guard).

**stdin consumption:** Read all of stdin before processing. Use `INPUT=$(cat)` at the top, then parse with `jq`.

## L2 — Understanding

### Why Does It Work?

The JSON-on-stdout approach decouples the hook's decision from its exit code, enabling rich control (allow + rewrite input, deny + add context) that a binary exit code cannot express. The strict rule "JSON only processed on exit 0" prevents ambiguity — if you want to block, pick one method.

### Why Not?

- Cannot mix exit 2 with JSON — JSON is ignored on non-zero exits
- `updatedInput` rewrites the entire tool input object — must re-include unchanged fields
- Multiple hooks modifying `updatedInput` are non-deterministic (last to finish wins)
- `defer` only works in `-p` mode and only for single-tool-call turns
- `sessionEnd` hooks timeout in 1.5 seconds by default — set `CLAUDE_CODE_SESSIONEND_HOOKS_TIMEOUT_MS` if needed

## L3 — Wisdom

### So What? (Benefit)

The output contract enables a spectrum from simple (exit 2 to block) to sophisticated (exit 0 + JSON to rewrite tool input, inject context, and selectively allow). Start simple; add JSON output only when you need the richer control.

### Now What? (Next)

- For simple blocking: use exit 2 + stderr message
- For auto-approval of specific tools: use `permissionDecision: "allow"` in `hookSpecificOutput`
- For interactive UIs calling `claude -p`: implement `defer` to pause and collect user input programmatically
- Check `stop_hook_active` in Stop hooks to prevent infinite loops

## Sources

- captured/claude-code-docs-full.md (lines 12957-13162, 15309-15363)

## Links

- [[hooks-lifecycle]]
- [[hook-matchers]]
- [[hooks-in-skills-agents]]
