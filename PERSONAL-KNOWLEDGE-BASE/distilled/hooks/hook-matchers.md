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
---

# Hook Matchers

> Matchers and the `if` field are two independent filters that together prevent unnecessary hook process spawns — matchers at the group level, `if` at the handler level.

## L1 — Knowledge

### So What? (Relevance)

Without matchers, every hook fires on every occurrence of its event. A `PostToolUse` hook without a matcher runs after every single tool call — Bash, Read, Edit, MCP tools, everything. Matchers are the primary cost-control mechanism for hooks.

### What Is It?

The **matcher** field is a regex string on the outer `hooks` array object (the matcher group). It filters which events activate the group. The **`if`** field is a permission-rule syntax string on each inner handler object. It filters which specific tool calls spawn the handler process.

Structure:
```json
{
  "hooks": {
    "PreToolUse": [
      {                          ← matcher group
        "matcher": "Bash",       ← regex on tool_name
        "hooks": [
          {                      ← handler
            "type": "command",
            "if": "Bash(git *)", ← permission-rule filter
            "command": "..."
          }
        ]
      }
    ]
  }
}
```

### What Else?

- `"*"`, `""`, or omitting `matcher` entirely = match all occurrences
- Matcher is a full regex: `Edit|Write` matches either, `mcp__.*` matches all MCP tools
- Different events match on different fields:

| Event(s) | Matcher filters on |
|----------|--------------------|
| PreToolUse, PostToolUse, PostToolUseFailure, PermissionRequest, PermissionDenied | tool_name |
| SessionStart | session source: `startup`, `resume`, `clear`, `compact` |
| SessionEnd | exit reason: `clear`, `resume`, `logout`, `prompt_input_exit`, etc. |
| Notification | type: `permission_prompt`, `idle_prompt`, `auth_success`, `elicitation_dialog` |
| SubagentStart/Stop | agent type: `Bash`, `Explore`, `Plan`, custom name |
| PreCompact, PostCompact | trigger: `manual`, `auto` |
| ConfigChange | source: `user_settings`, `project_settings`, `local_settings`, `policy_settings`, `skills` |
| FileChanged | basename of the changed file |
| InstructionsLoaded | load reason: `session_start`, `nested_traversal`, `path_glob_match`, `include`, `compact` |
| Elicitation, ElicitationResult | MCP server name |
| StopFailure | error type: `rate_limit`, `authentication_failed`, etc. |
| UserPromptSubmit, Stop, TeammateIdle, TaskCreated, TaskCompleted, WorktreeCreate, WorktreeRemove, CwdChanged | no matcher support — always fires |

### How Does It Work?

1. Event fires → Claude Code evaluates all matcher groups for that event
2. If matcher regex matches the event's filter field → group activates
3. For each handler in the group: if `if` field present → evaluate permission-rule syntax against tool name + arguments
4. If `if` matches (or is absent) → handler process spawns

**MCP tool naming pattern:** `mcp__<server>__<tool>`
- `mcp__memory__.*` = all tools from memory server
- `mcp__.*__write.*` = any "write" tool across all MCP servers

**`if` field notes:**
- Only evaluated on tool events: PreToolUse, PostToolUse, PostToolUseFailure, PermissionRequest, PermissionDenied
- Adding `if` to any other event prevents the hook from running
- Uses same syntax as permission rules: `Bash(git *)`, `Edit(*.ts)`, `Write(src/**)`
- Requires Claude Code v2.1.85+

## L2 — Understanding

### Why Does It Work?

The two-level filter design separates group-level routing (cheap regex, evaluated in-process) from handler-level routing (permission-rule parse, also cheap). Both happen before any process spawns. The `if` field specifically avoids spawning for every Bash command when you only care about git commands — avoiding process overhead on hot paths.

### Why Not?

- Matchers are case-sensitive — `bash` does not match `Bash`
- `if` field silently prevents hooks from running on non-tool events (no warning)
- Events without matcher support silently ignore a `matcher` field — no error, just no filtering
- Regex in matcher does not anchor by default — `Bash` matches `mcp__Bash__tool` — use `^Bash$` for exact matching if needed

## Sources

- captured/claude-code-docs-full.md (lines 12673-12765, 15366-15511)

## Links

- [[hooks-lifecycle]]
- [[hook-input-output]]
