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
  - what_if
---

# Subagent Hooks

Hooks are the mechanism for conditional, dynamic control over subagent tool usage and lifecycle events. They provide finer-grained control than tool restrictions alone — blocking specific operations within an allowed tool rather than blocking the tool entirely.

## L1 — Knowledge

### So What? (Relevance)

Tool restrictions are binary (allow or deny the whole tool). Hooks allow semantic validation — permit Bash but block any Bash command that contains SQL write keywords. This is the pattern for "allow Bash for SELECT queries only" without disabling Bash entirely.

### What Is It?

Two configuration surfaces for subagent hooks:

**1. Frontmatter hooks** — defined in the subagent's markdown file, run only while that specific agent is active:
```yaml
hooks:
  PreToolUse:
    - matcher: "Bash"
      hooks:
        - type: command
          command: "./scripts/validate-readonly-query.sh"
  PostToolUse:
    - matcher: "Edit|Write"
      hooks:
        - type: command
          command: "./scripts/run-linter.sh"
```

**2. Session-level hooks** — defined in `settings.json`, respond to subagent lifecycle events in the main session:
```json
{
  "hooks": {
    "SubagentStart": [
      { "matcher": "db-agent", "hooks": [{ "type": "command", "command": "./scripts/setup-db-connection.sh" }] }
    ],
    "SubagentStop": [
      { "hooks": [{ "type": "command", "command": "./scripts/cleanup.sh" }] }
    ]
  }
}
```

### What Else?

**Supported hook events for subagent frontmatter:**

| Event | Matcher input | When it fires |
|---|---|---|
| `PreToolUse` | Tool name | Before the subagent uses a tool |
| `PostToolUse` | Tool name | After the subagent uses a tool |
| `Stop` | (none) | When the subagent finishes (auto-converted to `SubagentStop` at runtime) |

All hook events are supported in frontmatter, but PreToolUse and PostToolUse are the most common for subagent use.

**Lifecycle events for `settings.json`:**

| Event | Matcher input | When it fires |
|---|---|---|
| `SubagentStart` | Agent type name | When a subagent begins execution |
| `SubagentStop` | Agent type name | When a subagent completes |

Both support matchers to target specific agent types by name. Omitting the matcher means the hook fires for all subagents.

**Plugin subagents:** `hooks` field is silently ignored for security. Copy the agent file to `.claude/agents/` if hooks are required.

### How Does It Work?

**PreToolUse hook flow:**
1. Agent decides to call a tool (e.g., Bash).
2. Matcher checks if the tool name matches (supports regex: `"Edit|Write"`).
3. If match: Claude Code invokes the hook command, passing JSON to stdin.
4. Hook reads `tool_input` from the JSON to inspect the tool call arguments.
5. Exit code determines outcome:
   - `0` — proceed with the tool call
   - `2` — block the tool call; stderr message is fed back to the agent as an error

**Validation script pattern (read-only SQL enforcer):**
```bash
#!/bin/bash
INPUT=$(cat)
COMMAND=$(echo "$INPUT" | jq -r '.tool_input.command // empty')

if echo "$COMMAND" | grep -iE '\b(INSERT|UPDATE|DELETE|DROP|CREATE|ALTER|TRUNCATE)\b' > /dev/null; then
  echo "Blocked: Only SELECT queries are allowed" >&2
  exit 2
fi

exit 0
```

The agent receives the stderr message as an error response and can adjust its next tool call accordingly.

## L2 — Understanding

### Why Does It Work?

Hooks are external processes — they run outside the agent's context and can apply any validation logic: regex matching, external API calls, file system checks, database lookups. This makes them more powerful than anything expressible in the agent's system prompt, because system prompts are advisory while hooks are enforced at the execution boundary.

The exit code 2 protocol is a clean design: the agent sees a tool call failure with an explanatory message (from stderr) and can reason about it. The agent is not abruptly terminated — it gets a chance to try a different approach.

`Stop` hooks in frontmatter being auto-converted to `SubagentStop` events is a convenience: you write `Stop` in your definition, and it becomes a lifecycle event that session-level settings can also observe.

### Why Not?

- Hook commands are shell commands — they have access to the filesystem and environment. A malicious or buggy hook script can cause damage. Treat hook scripts with the same security scrutiny as any shell script in the project.
- Hooks add latency to every matched tool call. For agents that call Bash frequently, a heavyweight validation script on every call degrades performance.
- Plugin subagents cannot use frontmatter hooks — silently ignored. This is a hard constraint for plugin distribution.
- Session-level `SubagentStart`/`SubagentStop` hooks fire for all subagents (unless a matcher is set). A cleanup hook without a matcher runs for every agent — check your matchers carefully.

### What If?

What if you need to validate tool input but the validation requires async external calls (e.g., checking a permissions API)? Hook commands are synchronous shell processes. For async validation, the hook script would need to block until the external call returns — possible but adds latency on every tool call. For high-frequency operations, consider caching validation results in a local file.

What if you need different hooks for different invocations of the same agent? Frontmatter hooks are static — they apply uniformly to all invocations. Dynamic per-invocation hook behavior would require separate agent definitions or session-level hooks with more complex matcher logic.

## Sources

- `captured/claude-code-docs-full.md` lines 28393–28527
- Source URL: https://code.claude.com/docs/en/sub-agents#conditional-rules-with-hooks

## Links

- [[custom-subagents-overview]]
- [[subagent-frontmatter-fields]]
- [[subagent-tool-restrictions]]
- [[subagent-permission-modes]]
