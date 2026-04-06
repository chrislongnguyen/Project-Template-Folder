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
  - what_is_it_not
---

# Subagent Permission Modes

Permission modes control whether and how a subagent prompts for user confirmation before executing operations. They are orthogonal to tool restrictions — both can be set independently.

## L1 — Knowledge

### So What? (Relevance)

Without understanding permission inheritance, you can accidentally deploy an agent that either prompts for every file read (annoying) or silently bypasses all safety checks (dangerous). Permission mode is the "interrupt policy" for agent operations.

### What Is It?

The `permissionMode` frontmatter field sets the interrupt policy for the subagent:

| Mode | Behavior |
|---|---|
| `default` | Standard permission checking — prompts user before executing tool calls that require approval |
| `acceptEdits` | Auto-accepts file edits except in protected directories |
| `auto` | Background classifier reviews commands and protected-directory writes before executing |
| `dontAsk` | Auto-denies all permission prompts (explicitly allowed tools still work) |
| `bypassPermissions` | Skips all permission prompts entirely |
| `plan` | Plan mode — read-only exploration, no writes |

Subagents inherit the permission context from the main conversation and can override it via this field — with one exception: **parent modes take precedence as described below**.

### What Else?

**Parent mode precedence rules:**
- If parent uses `bypassPermissions`: this takes precedence. Subagent cannot override to a more restrictive mode.
- If parent uses `auto` mode: subagent inherits auto mode. Any `permissionMode` in the subagent's frontmatter is ignored. The classifier evaluates the subagent's tool calls with the same rules as the parent.

**Protected directories** (always prompt, even in `bypassPermissions`):
`.git/`, `.claude/`, `.vscode/`, `.idea/`, `.husky/`

**Exceptions within protected directories** (no prompt even in `bypassPermissions`):
`.claude/commands`, `.claude/agents`, `.claude/skills`

**Background subagents and permissions:** When a background subagent starts, Claude Code prompts the user upfront for all tool permissions the agent will need. Once running, the agent inherits those pre-approved permissions and auto-denies anything not pre-approved. It cannot ask clarifying questions mid-run.

### How Does It Work?

At invocation, the effective permission mode is determined:
1. Check if parent session is `bypassPermissions` or `auto` (parent wins in both cases).
2. Otherwise, use the subagent's `permissionMode` field.
3. Apply that mode to all tool calls during the subagent's execution.

For `auto` mode: a background classifier evaluates each tool call before it executes. Calls that pass the classifier proceed without prompts. Calls that don't are blocked or escalated based on classifier output.

## L2 — Understanding

### Why Does It Work?

The inheritance model (parent wins for `bypassPermissions` and `auto`) prevents privilege escalation: a subagent definition cannot grant itself more autonomy than the parent session allows. This is the security boundary between subagent authors (who write definitions) and session operators (who control the parent mode).

`dontAsk` mode is useful for automated pipelines where you want operations to fail explicitly rather than pause waiting for input. The agent continues, explicit allows still work, but anything requiring approval is auto-denied — a clean failure mode.

`acceptEdits` is the middle ground: write operations proceed without prompting, but the user's protected directories are still guarded.

### Why Not?

- `bypassPermissions` should be treated like running shell commands as root — appropriate for tightly scoped, well-understood operations, not general use.
- Plugin subagents: `permissionMode` is ignored for security when loading from a plugin.
- `auto` mode is only as good as the classifier. The classifier is opaque — you cannot inspect its rules. If you need deterministic permission behavior, use `acceptEdits` or `default` instead.
- Background subagents with `dontAsk`: if the agent needs a permission not pre-approved at start, it auto-denies and the task fails silently. Always map out required permissions before deploying a background agent.

### What Is It Not?

Permission mode is not tool restrictions. Tool restrictions (`tools`, `disallowedTools`) control which tools are callable. Permission mode controls how the agent handles the permission prompt when calling an allowed tool. You can have a tool in the allowlist but still require user approval (default mode), or bypass approval entirely (bypassPermissions).

## Sources

- `captured/claude-code-docs-full.md` lines 28309–28326
- Source URL: https://code.claude.com/docs/en/sub-agents#permission-modes

## Links

- [[custom-subagents-overview]]
- [[subagent-frontmatter-fields]]
- [[subagent-tool-restrictions]]
- [[subagent-hooks]]
